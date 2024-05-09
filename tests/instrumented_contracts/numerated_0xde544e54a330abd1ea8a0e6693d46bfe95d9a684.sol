1 pragma solidity ^0.5.16; /*
2 
3 ___________________________________________________________________
4   _      _                                        ______           
5   |  |  /          /                                /              
6 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
8 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10 
11 
12 ███╗   ██╗██╗███████╗████████╗██╗   ██╗    ███╗   ███╗ ██████╗      ██╗██╗
13 ████╗  ██║██║██╔════╝╚══██╔══╝╚██╗ ██╔╝    ████╗ ████║██╔═══██╗     ██║██║
14 ██╔██╗ ██║██║█████╗     ██║    ╚████╔╝     ██╔████╔██║██║   ██║     ██║██║
15 ██║╚██╗██║██║██╔══╝     ██║     ╚██╔╝      ██║╚██╔╝██║██║   ██║██   ██║██║
16 ██║ ╚████║██║██║        ██║      ██║       ██║ ╚═╝ ██║╚██████╔╝╚█████╔╝██║
17 ╚═╝  ╚═══╝╚═╝╚═╝        ╚═╝      ╚═╝       ╚═╝     ╚═╝ ╚═════╝  ╚════╝ ╚═╝
18                                                                           
19 
20 === 'Niftymoji' NFT Management contract with following features ===
21     => ERC721 Compliance
22     => ERC165 Compliance
23     => SafeMath implementation 
24     => Generation of new digital assets
25     => Destroyal of digital assets
26 
27 
28 ============= Independant Audit of the code ============
29     => Multiple Freelancers Auditors
30 
31 
32 -------------------------------------------------------------------
33  Copyright (c) 2019 onwards  Niftymoji Inc. ( https://niftymoji.com )
34 -------------------------------------------------------------------
35 */ 
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44     address payable internal _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50      * account.
51      */
52     constructor () internal {
53         _owner = msg.sender;
54         emit OwnershipTransferred(address(0), _owner);
55     }
56 
57     /**
58      * @return the address of the owner.
59      */
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(isOwner());
69         _;
70     }
71 
72     /**
73      * @return true if `msg.sender` is the owner of the contract.
74      */
75     function isOwner() public view returns (bool) {
76         return msg.sender == _owner;
77     }
78 
79     /**
80      * @dev Allows the current owner to relinquish control of the contract.
81      * It will not be possible to call the functions with the `onlyOwner`
82      * modifier anymore.
83      * @notice Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Allows the current owner to transfer control of the contract to a newOwner.
93      * @param newOwner The address to transfer ownership to.
94      */
95     function transferOwnership(address payable newOwner) public onlyOwner {
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers control of the contract to a newOwner.
101      * @param newOwner The address to transfer ownership to.
102      */
103     function _transferOwnership(address payable newOwner) internal {
104         require(newOwner != address(0));
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
108 }
109 
110 
111 // File: contracts/Strings.sol
112 
113 pragma solidity ^0.5.2;
114 
115 library Strings {
116   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
117   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
118     bytes memory _ba = bytes(_a);
119     bytes memory _bb = bytes(_b);
120     bytes memory _bc = bytes(_c);
121     bytes memory _bd = bytes(_d);
122     bytes memory _be = bytes(_e);
123     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
124     bytes memory babcde = bytes(abcde);
125     uint k = 0;
126     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
127     for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
128     for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
129     for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
130     for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
131     return string(babcde);
132   }
133 
134   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
135     return strConcat(_a, _b, _c, _d, "");
136   }
137 
138   function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
139     return strConcat(_a, _b, _c, "", "");
140   }
141 
142   function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
143     return strConcat(_a, _b, "", "", "");
144   }
145 
146   function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
147     if (_i == 0) {
148       return "0";
149     }
150     uint j = _i;
151     uint len;
152     while (j != 0) {
153       len++;
154       j /= 10;
155     }
156     bytes memory bstr = new bytes(len);
157     uint k = len - 1;
158     while (_i != 0) {
159       bstr[k--] = byte(uint8(48 + _i % 10));
160       _i /= 10;
161     }
162     return string(bstr);
163   }
164 
165   function fromAddress(address addr) internal pure returns(string memory) {
166     bytes20 addrBytes = bytes20(addr);
167     bytes16 hexAlphabet = "0123456789abcdef";
168     bytes memory result = new bytes(42);
169     result[0] = '0';
170     result[1] = 'x';
171     for (uint i = 0; i < 20; i++) {
172       result[i * 2 + 2] = hexAlphabet[uint8(addrBytes[i] >> 4)];
173       result[i * 2 + 3] = hexAlphabet[uint8(addrBytes[i] & 0x0f)];
174     }
175     return string(result);
176   }
177 }
178 
179 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
180 
181 pragma solidity ^0.5.2;
182 
183 /**
184  * @title IERC165
185  * @dev https://eips.ethereum.org/EIPS/eip-165
186  */
187 interface IERC165 {
188     /**
189      * @notice Query if a contract implements an interface
190      * @param interfaceId The interface identifier, as specified in ERC-165
191      * @dev Interface identification is specified in ERC-165. This function
192      * uses less than 30,000 gas.
193      */
194     function supportsInterface(bytes4 interfaceId) external view returns (bool);
195 }
196 
197 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
198 
199 pragma solidity ^0.5.2;
200 
201 
202 /**
203  * @title ERC721 Non-Fungible Token Standard basic interface
204  * @dev see https://eips.ethereum.org/EIPS/eip-721
205  */
206 contract IERC721 is IERC165 {
207     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
208     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
209     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
210 
211     function balanceOf(address owner) public view returns (uint256 balance);
212     function ownerOf(uint256 tokenId) public view returns (address owner);
213 
214     function approve(address to, uint256 tokenId) public;
215     function getApproved(uint256 tokenId) public view returns (address operator);
216 
217     function setApprovalForAll(address operator, bool _approved) public;
218     function isApprovedForAll(address owner, address operator) public view returns (bool);
219 
220     function transferFrom(address from, address to, uint256 tokenId) public;
221     function safeTransferFrom(address from, address to, uint256 tokenId) public;
222 
223     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
224 }
225 
226 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
227 
228 pragma solidity ^0.5.2;
229 
230 /**
231  * @title ERC721 token receiver interface
232  * @dev Interface for any contract that wants to support safeTransfers
233  * from ERC721 asset contracts.
234  */
235 contract IERC721Receiver {
236     /**
237      * @notice Handle the receipt of an NFT
238      * @dev The ERC721 smart contract calls this function on the recipient
239      * after a `safeTransfer`. This function MUST return the function selector,
240      * otherwise the caller will revert the transaction. The selector to be
241      * returned can be obtained as `this.onERC721Received.selector`. This
242      * function MAY throw to revert and reject the transfer.
243      * Note: the ERC721 contract address is always the message sender.
244      * @param operator The address which called `safeTransferFrom` function
245      * @param from The address which previously owned the token
246      * @param tokenId The NFT identifier which is being transferred
247      * @param data Additional data with no specified format
248      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
249      */
250     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
251     public returns (bytes4);
252 }
253 
254 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
255 
256 pragma solidity ^0.5.2;
257 
258 /**
259  * @title SafeMath
260  * @dev Unsigned math operations with safety checks that revert on error
261  */
262 library SafeMath {
263     /**
264      * @dev Multiplies two unsigned integers, reverts on overflow.
265      */
266     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
267         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
268         // benefit is lost if 'b' is also tested.
269         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
270         if (a == 0) {
271             return 0;
272         }
273 
274         uint256 c = a * b;
275         require(c / a == b);
276 
277         return c;
278     }
279 
280     /**
281      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
282      */
283     function div(uint256 a, uint256 b) internal pure returns (uint256) {
284         // Solidity only automatically asserts when dividing by 0
285         require(b > 0);
286         uint256 c = a / b;
287         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
288 
289         return c;
290     }
291 
292     /**
293      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
294      */
295     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
296         require(b <= a);
297         uint256 c = a - b;
298 
299         return c;
300     }
301 
302     /**
303      * @dev Adds two unsigned integers, reverts on overflow.
304      */
305     function add(uint256 a, uint256 b) internal pure returns (uint256) {
306         uint256 c = a + b;
307         require(c >= a);
308 
309         return c;
310     }
311 
312     /**
313      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
314      * reverts when dividing by zero.
315      */
316     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
317         require(b != 0);
318         return a % b;
319     }
320 }
321 
322 // File: openzeppelin-solidity/contracts/utils/Address.sol
323 
324 pragma solidity ^0.5.2;
325 
326 /**
327  * Utility library of inline functions on addresses
328  */
329 library Address {
330     /**
331      * Returns whether the target address is a contract
332      * @dev This function will return false if invoked during the constructor of a contract,
333      * as the code is not actually created until after the constructor finishes.
334      * @param account address of the account to check
335      * @return whether the target address is a contract
336      */
337     function isContract(address account) internal view returns (bool) {
338         uint256 size;
339         // XXX Currently there is no better way to check if there is a contract in an address
340         // than to check the size of the code at that address.
341         // See https://ethereum.stackexchange.com/a/14016/36603
342         // for more details about how this works.
343         // TODO Check this again before the Serenity release, because all addresses will be
344         // contracts then.
345         // solhint-disable-next-line no-inline-assembly
346         assembly { size := extcodesize(account) }
347         return size > 0;
348     }
349 }
350 
351 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
352 
353 pragma solidity ^0.5.2;
354 
355 
356 /**
357  * @title Counters
358  * @author Matt Condon (@shrugs)
359  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
360  * of elements in a mapping, issuing ERC721 ids, or counting request ids
361  *
362  * Include with `using Counters for Counters.Counter;`
363  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
364  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
365  * directly accessed.
366  */
367 library Counters {
368     using SafeMath for uint256;
369 
370     struct Counter {
371         // This variable should never be directly accessed by users of the library: interactions must be restricted to
372         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
373         // this feature: see https://github.com/ethereum/solidity/issues/4637
374         uint256 _value; // default: 0
375     }
376 
377     function current(Counter storage counter) internal view returns (uint256) {
378         return counter._value;
379     }
380 
381     function increment(Counter storage counter) internal {
382         counter._value += 1;
383     }
384 
385     function decrement(Counter storage counter) internal {
386         counter._value = counter._value.sub(1);
387     }
388 }
389 
390 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
391 
392 pragma solidity ^0.5.2;
393 
394 
395 /**
396  * @title ERC165
397  * @author Matt Condon (@shrugs)
398  * @dev Implements ERC165 using a lookup table.
399  */
400 contract ERC165 is IERC165 {
401     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
402     /*
403      * 0x01ffc9a7 ===
404      *     bytes4(keccak256('supportsInterface(bytes4)'))
405      */
406 
407     /**
408      * @dev a mapping of interface id to whether or not it's supported
409      */
410     mapping(bytes4 => bool) private _supportedInterfaces;
411 
412     /**
413      * @dev A contract implementing SupportsInterfaceWithLookup
414      * implement ERC165 itself
415      */
416     constructor () internal {
417         _registerInterface(_INTERFACE_ID_ERC165);
418     }
419 
420     /**
421      * @dev implement supportsInterface(bytes4) using a lookup table
422      */
423     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
424         return _supportedInterfaces[interfaceId];
425     }
426 
427     /**
428      * @dev internal method for registering an interface
429      */
430     function _registerInterface(bytes4 interfaceId) internal {
431         require(interfaceId != 0xffffffff);
432         _supportedInterfaces[interfaceId] = true;
433     }
434 }
435 
436 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
437 
438 pragma solidity ^0.5.2;
439 
440 
441 
442 
443 interface OldNiftymoji{
444     function powerNLucks(uint256 tokenID) external returns(uint256, uint256);
445 }
446 
447 
448 
449 
450 /**
451  * @title ERC721 Non-Fungible Token Standard basic implementation
452  * @dev see https://eips.ethereum.org/EIPS/eip-721
453  */
454 contract ERC721 is ERC165, IERC721 {
455     using SafeMath for uint256;
456     using Address for address;
457     using Counters for Counters.Counter;
458     
459         struct powerNLuck
460     {
461         uint256 power;
462         uint256 luck;        
463     }
464     
465     uint256 public totalSupply;
466     
467     //uint256 is tokenNo and powerNLuck is associated details in uint256
468     mapping (uint256 => powerNLuck) public powerNLucks;
469 
470     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
471     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
472     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
473 
474     // Mapping from token ID to owner
475     mapping (uint256 => address) private _tokenOwner;
476 
477     // Mapping from token ID to approved address
478     mapping (uint256 => address) private _tokenApprovals;
479 
480     // Mapping from owner to number of owned token
481     mapping (address => Counters.Counter) private _ownedTokensCount;
482 
483     // Mapping from owner to operator approvals
484     mapping (address => mapping (address => bool)) private _operatorApprovals;
485 
486     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
487     /*
488      * 0x80ac58cd ===
489      *     bytes4(keccak256('balanceOf(address)')) ^
490      *     bytes4(keccak256('ownerOf(uint256)')) ^
491      *     bytes4(keccak256('approve(address,uint256)')) ^
492      *     bytes4(keccak256('getApproved(uint256)')) ^
493      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
494      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
495      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
496      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
497      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
498      */
499 
500     constructor () public {
501         // register the supported interfaces to conform to ERC721 via ERC165
502         _registerInterface(_INTERFACE_ID_ERC721);
503     }
504 
505     /**
506      * @dev Gets the balance of the specified address
507      * @param owner address to query the balance of
508      * @return uint256 representing the amount owned by the passed address
509      */
510     function balanceOf(address owner) public view returns (uint256) {
511         require(owner != address(0));
512         return _ownedTokensCount[owner].current();
513     }
514 
515     /**
516      * @dev Gets the owner of the specified token ID
517      * @param tokenId uint256 ID of the token to query the owner of
518      * @return address currently marked as the owner of the given token ID
519      */
520     function ownerOf(uint256 tokenId) public view returns (address) {
521         address owner = _tokenOwner[tokenId];
522         require(owner != address(0));
523         return owner;
524     }
525 
526     /**
527      * @dev Approves another address to transfer the given token ID
528      * The zero address indicates there is no approved address.
529      * There can only be one approved address per token at a given time.
530      * Can only be called by the token owner or an approved operator.
531      * @param to address to be approved for the given token ID
532      * @param tokenId uint256 ID of the token to be approved
533      */
534     function approve(address to, uint256 tokenId) public {
535         address owner = ownerOf(tokenId);
536         require(to != owner);
537         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
538 
539         _tokenApprovals[tokenId] = to;
540         emit Approval(owner, to, tokenId);
541     }
542 
543     /**
544      * @dev Gets the approved address for a token ID, or zero if no address set
545      * Reverts if the token ID does not exist.
546      * @param tokenId uint256 ID of the token to query the approval of
547      * @return address currently approved for the given token ID
548      */
549     function getApproved(uint256 tokenId) public view returns (address) {
550         require(_exists(tokenId));
551         return _tokenApprovals[tokenId];
552     }
553 
554     /**
555      * @dev Sets or unsets the approval of a given operator
556      * An operator is allowed to transfer all tokens of the sender on their behalf
557      * @param to operator address to set the approval
558      * @param approved representing the status of the approval to be set
559      */
560     function setApprovalForAll(address to, bool approved) public {
561         require(to != msg.sender);
562         _operatorApprovals[msg.sender][to] = approved;
563         emit ApprovalForAll(msg.sender, to, approved);
564     }
565 
566     /**
567      * @dev Tells whether an operator is approved by a given owner
568      * @param owner owner address which you want to query the approval of
569      * @param operator operator address which you want to query the approval of
570      * @return bool whether the given operator is approved by the given owner
571      */
572     function isApprovedForAll(address owner, address operator) public view returns (bool) {
573         return _operatorApprovals[owner][operator];
574     }
575 
576     /**
577      * @dev Transfers the ownership of a given token ID to another address
578      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
579      * Requires the msg.sender to be the owner, approved, or operator
580      * @param from current owner of the token
581      * @param to address to receive the ownership of the given token ID
582      * @param tokenId uint256 ID of the token to be transferred
583      */
584     function transferFrom(address from, address to, uint256 tokenId) public {
585         require(_isApprovedOrOwner(msg.sender, tokenId));
586 
587         _transferFrom(from, to, tokenId);
588     }
589 
590     /**
591      * @dev Safely transfers the ownership of a given token ID to another address
592      * If the target address is a contract, it must implement `onERC721Received`,
593      * which is called upon a safe transfer, and return the magic value
594      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
595      * the transfer is reverted.
596      * Requires the msg.sender to be the owner, approved, or operator
597      * @param from current owner of the token
598      * @param to address to receive the ownership of the given token ID
599      * @param tokenId uint256 ID of the token to be transferred
600      */
601     function safeTransferFrom(address from, address to, uint256 tokenId) public {
602         safeTransferFrom(from, to, tokenId, "");
603     }
604 
605     /**
606      * @dev Safely transfers the ownership of a given token ID to another address
607      * If the target address is a contract, it must implement `onERC721Received`,
608      * which is called upon a safe transfer, and return the magic value
609      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
610      * the transfer is reverted.
611      * Requires the msg.sender to be the owner, approved, or operator
612      * @param from current owner of the token
613      * @param to address to receive the ownership of the given token ID
614      * @param tokenId uint256 ID of the token to be transferred
615      * @param _data bytes data to send along with a safe transfer check
616      */
617     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
618         transferFrom(from, to, tokenId);
619         require(_checkOnERC721Received(from, to, tokenId, _data));
620     }
621 
622     /**
623      * @dev Returns whether the specified token exists
624      * @param tokenId uint256 ID of the token to query the existence of
625      * @return bool whether the token exists
626      */
627     function _exists(uint256 tokenId) internal view returns (bool) {
628         address owner = _tokenOwner[tokenId];
629         return owner != address(0);
630     }
631 
632     /**
633      * @dev Returns whether the given spender can transfer a given token ID
634      * @param spender address of the spender to query
635      * @param tokenId uint256 ID of the token to be transferred
636      * @return bool whether the msg.sender is approved for the given token ID,
637      * is an operator of the owner, or is the owner of the token
638      */
639     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
640         address owner = ownerOf(tokenId);
641         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
642     }
643 
644     /**
645      * @dev Internal function to mint a new token
646      * Reverts if the given token ID already exists
647      * @param to The address that will own the minted token
648      * @param tokenId uint256 ID of the token to be minted
649      */
650     function _mint(address to, uint256 tokenId, uint256 _userSeed) internal {
651         require(to != address(0));
652         require(!_exists(tokenId));
653         require(totalSupply <= 3187, 'Excedend Max Token Supply');
654 
655         _tokenOwner[tokenId] = to;
656         _ownedTokensCount[to].increment();
657         totalSupply++;
658         
659         //generating random numbers for luck and power based on previous blockhash and user seed
660         //this method of entropy is not very secure, but kept it as consent of client
661         uint256 _luck = uint256(keccak256(abi.encodePacked(blockhash( block.number -1), _userSeed))) % 100; //0-99
662         uint256 _power = uint256(keccak256(abi.encodePacked(blockhash( block.number -10), now, _userSeed))) % 100; //0-99
663         //assigning lucky no and power to tokenId        
664         powerNLucks[tokenId].luck = _luck+1;    //this will cause it will never be zero.
665         powerNLucks[tokenId].power = _power+1;  //this will cause it will never be zero.
666 
667         emit Transfer(address(0), to, tokenId);
668     }
669     
670     function _mintSyncedTokens(uint256 tokenID, address user) internal {
671         
672         _tokenOwner[tokenID] = user;
673         _ownedTokensCount[user].increment();
674         totalSupply++;
675         
676         //generating random numbers for luck and power based on previous blockhash and user seed
677         //this method of entropy is not very secure, but kept it as consent of client
678         (uint256 _power, uint256 _luck) = OldNiftymoji(0x40b16A1b6bEA856745FeDf7E0946494B895611a2).powerNLucks(tokenID);  //mainnet
679         //(uint256 _power, uint256 _luck) = OldNiftymoji(0x03f701FB8EA5441A9Bf98B65461e795931B55298).powerNLucks(tokenID);    //testnet
680         
681         //assigning lucky no and power to tokenId        
682         powerNLucks[tokenID].luck = _luck;    //this will cause it will never be zero.
683         powerNLucks[tokenID].power = _power;  //this will cause it will never be zero.
684 
685         emit Transfer(address(0), user, tokenID);
686     }
687     
688     
689 
690     /**
691      * @dev Internal function to burn a specific token
692      * Reverts if the token does not exist
693      * Deprecated, use _burn(uint256) instead.
694      * @param owner owner of the token to burn
695      * @param tokenId uint256 ID of the token being burned
696      */
697     function _burn(address owner, uint256 tokenId) internal {
698         require(ownerOf(tokenId) == owner);
699 
700         _clearApproval(tokenId);
701 
702         _ownedTokensCount[owner].decrement();
703         _tokenOwner[tokenId] = address(0);
704 
705         emit Transfer(owner, address(0), tokenId);
706     }
707 
708     /**
709      * @dev Internal function to burn a specific token
710      * Reverts if the token does not exist
711      * @param tokenId uint256 ID of the token being burned
712      */
713     function _burn(uint256 tokenId) internal {
714         _burn(ownerOf(tokenId), tokenId);
715     }
716 
717     /**
718      * @dev Internal function to transfer ownership of a given token ID to another address.
719      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
720      * @param from current owner of the token
721      * @param to address to receive the ownership of the given token ID
722      * @param tokenId uint256 ID of the token to be transferred
723      */
724     function _transferFrom(address from, address to, uint256 tokenId) internal {
725         require(ownerOf(tokenId) == from);
726         require(to != address(0));
727 
728         _clearApproval(tokenId);
729 
730         _ownedTokensCount[from].decrement();
731         _ownedTokensCount[to].increment();
732 
733         _tokenOwner[tokenId] = to;
734 
735         emit Transfer(from, to, tokenId);
736     }
737 
738     /**
739      * @dev Internal function to invoke `onERC721Received` on a target address
740      * The call is not executed if the target address is not a contract
741      * @param from address representing the previous owner of the given token ID
742      * @param to target address that will receive the tokens
743      * @param tokenId uint256 ID of the token to be transferred
744      * @param _data bytes optional data to send along with the call
745      * @return bool whether the call correctly returned the expected magic value
746      */
747     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
748         internal returns (bool)
749     {
750         if (!to.isContract()) {
751             return true;
752         }
753 
754         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
755         return (retval == _ERC721_RECEIVED);
756     }
757 
758     /**
759      * @dev Private function to clear current approval of a given token ID
760      * @param tokenId uint256 ID of the token to be transferred
761      */
762     function _clearApproval(uint256 tokenId) private {
763         if (_tokenApprovals[tokenId] != address(0)) {
764             _tokenApprovals[tokenId] = address(0);
765         }
766     }
767     
768     
769     
770 }
771 
772 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
773 
774 pragma solidity ^0.5.2;
775 
776 
777 /**
778  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
779  * @dev See https://eips.ethereum.org/EIPS/eip-721
780  */
781 contract IERC721Enumerable is IERC721 {
782     //function totalSupply() public view returns (uint256);
783     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
784 
785     function tokenByIndex(uint256 index) public view returns (uint256);
786 }
787 
788 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
789 
790 pragma solidity ^0.5.2;
791 
792 
793 
794 
795 /**
796  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
797  * @dev See https://eips.ethereum.org/EIPS/eip-721
798  */
799 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
800     // Mapping from owner to list of owned token IDs
801     mapping(address => uint256[]) private _ownedTokens;
802 
803     // Mapping from token ID to index of the owner tokens list
804     mapping(uint256 => uint256) private _ownedTokensIndex;
805 
806     // Array with all token ids, used for enumeration
807     uint256[] private _allTokens;
808 
809     // Mapping from token id to position in the allTokens array
810     mapping(uint256 => uint256) private _allTokensIndex;
811 
812     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
813     /*
814      * 0x780e9d63 ===
815      *     bytes4(keccak256('totalSupply()')) ^
816      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
817      *     bytes4(keccak256('tokenByIndex(uint256)'))
818      */
819 
820     /**
821      * @dev Constructor function
822      */
823     constructor () public {
824         // register the supported interface to conform to ERC721Enumerable via ERC165
825         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
826     }
827 
828     /**
829      * @dev Gets the token ID at a given index of the tokens list of the requested owner
830      * @param owner address owning the tokens list to be accessed
831      * @param index uint256 representing the index to be accessed of the requested tokens list
832      * @return uint256 token ID at the given index of the tokens list owned by the requested address
833      */
834     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
835         require(index < balanceOf(owner));
836         return _ownedTokens[owner][index];
837     }
838 
839     /**
840      * @dev Gets the total amount of tokens stored by the contract
841      * @return uint256 representing the total amount of tokens
842      */
843     function totalSupplyEnum() public view returns (uint256) {
844         return _allTokens.length;
845     }
846 
847     /**
848      * @dev Gets the token ID at a given index of all the tokens in this contract
849      * Reverts if the index is greater or equal to the total number of tokens
850      * @param index uint256 representing the index to be accessed of the tokens list
851      * @return uint256 token ID at the given index of the tokens list
852      */
853     function tokenByIndex(uint256 index) public view returns (uint256) {
854         require(index < totalSupplyEnum());
855         return _allTokens[index];
856     }
857 
858     
859 
860     /**
861      * @dev Gets the list of token IDs of the requested owner
862      * @param owner address owning the tokens
863      * @return uint256[] List of token IDs owned by the requested address
864      */
865     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
866         return _ownedTokens[owner];
867     }
868 
869     /**
870      * @dev Private function to add a token to this extension's ownership-tracking data structures.
871      * @param to address representing the new owner of the given token ID
872      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
873      */
874     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
875         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
876         _ownedTokens[to].push(tokenId);
877     }
878 
879     /**
880      * @dev Private function to add a token to this extension's token tracking data structures.
881      * @param tokenId uint256 ID of the token to be added to the tokens list
882      */
883     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
884         _allTokensIndex[tokenId] = _allTokens.length;
885         _allTokens.push(tokenId);
886     }
887     
888     /**
889      * @dev Internal function to mint a new token
890      * Reverts if the given token ID already exists
891      * @param to address the beneficiary that will own the minted token
892      * @param tokenId uint256 ID of the token to be minted
893      */
894     function _mint(address to, uint256 tokenId) internal {
895         super._mint(to, tokenId,0);
896 
897         _addTokenToOwnerEnumeration(to, tokenId);
898 
899         _addTokenToAllTokensEnumeration(tokenId);
900     }
901 
902     /**
903      * @dev Internal function to burn a specific token
904      * Reverts if the token does not exist
905      * Deprecated, use _burn(uint256) instead
906      * @param owner owner of the token to burn
907      * @param tokenId uint256 ID of the token being burned
908      */
909     function _burn(address owner, uint256 tokenId) internal {
910         super._burn(owner, tokenId);
911 
912         _removeTokenFromOwnerEnumeration(owner, tokenId);
913         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
914         _ownedTokensIndex[tokenId] = 0;
915 
916         _removeTokenFromAllTokensEnumeration(tokenId);
917     }
918 
919     /**
920      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
921      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
922      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
923      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
924      * @param from address representing the previous owner of the given token ID
925      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
926      */
927     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
928         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
929         // then delete the last slot (swap and pop).
930 
931         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
932         uint256 tokenIndex = _ownedTokensIndex[tokenId];
933 
934         // When the token to delete is the last token, the swap operation is unnecessary
935         if (tokenIndex != lastTokenIndex) {
936             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
937 
938             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
939             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
940         }
941 
942         // This also deletes the contents at the last position of the array
943         _ownedTokens[from].length--;
944 
945         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
946         // lastTokenId, or just over the end of the array if the token was the last one).
947     }
948 
949     /**
950      * @dev Private function to remove a token from this extension's token tracking data structures.
951      * This has O(1) time complexity, but alters the order of the _allTokens array.
952      * @param tokenId uint256 ID of the token to be removed from the tokens list
953      */
954     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
955         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
956         // then delete the last slot (swap and pop).
957 
958         uint256 lastTokenIndex = _allTokens.length.sub(1);
959         uint256 tokenIndex = _allTokensIndex[tokenId];
960 
961         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
962         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
963         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
964         uint256 lastTokenId = _allTokens[lastTokenIndex];
965 
966         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
967         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
968 
969         // This also deletes the contents at the last position of the array
970         _allTokens.length--;
971         _allTokensIndex[tokenId] = 0;
972     }
973 }
974 
975 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
976 
977 pragma solidity ^0.5.2;
978 
979 
980 /**
981  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
982  * @dev See https://eips.ethereum.org/EIPS/eip-721
983  */
984 contract IERC721Metadata is IERC721 {
985     function name() external view returns (string memory);
986     function symbol() external view returns (string memory);
987     function tokenURI(uint256 tokenId) external view returns (string memory);
988 }
989 
990 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
991 
992 pragma solidity ^0.5.2;
993 
994 
995 
996 
997 contract ERC721Metadata is ERC165, IERC721Metadata, ERC721 {
998     // Token name
999     string private _name;
1000 
1001     // Token symbol
1002     string private _symbol;
1003 
1004     // Optional mapping for token URIs
1005     mapping(uint256 => string) private _tokenURIs;
1006 
1007     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1008     /*
1009      * 0x5b5e139f ===
1010      *     bytes4(keccak256('name()')) ^
1011      *     bytes4(keccak256('symbol()')) ^
1012      *     bytes4(keccak256('tokenURI(uint256)'))
1013      */
1014 
1015     /**
1016      * @dev Constructor function
1017      */
1018     constructor (string memory name, string memory symbol) public {
1019         _name = name;
1020         _symbol = symbol;
1021 
1022         // register the supported interfaces to conform to ERC721 via ERC165
1023         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1024     }
1025 
1026     /**
1027      * @dev Gets the token name
1028      * @return string representing the token name
1029      */
1030     function name() external view returns (string memory) {
1031         return _name;
1032     }
1033 
1034     /**
1035      * @dev Gets the token symbol
1036      * @return string representing the token symbol
1037      */
1038     function symbol() external view returns (string memory) {
1039         return _symbol;
1040     }
1041 
1042     /**
1043      * @dev Returns an URI for a given token ID
1044      * Throws if the token ID does not exist. May return an empty string.
1045      * @param tokenId uint256 ID of the token to query
1046      */
1047     function tokenURI(uint256 tokenId) external view returns (string memory) {
1048         require(_exists(tokenId));
1049         return _tokenURIs[tokenId];
1050     }
1051 
1052     /**
1053      * @dev Internal function to set the token URI for a given token
1054      * Reverts if the token ID does not exist
1055      * @param tokenId uint256 ID of the token to set its URI
1056      * @param uri string URI to assign
1057      */
1058     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1059         require(_exists(tokenId));
1060         _tokenURIs[tokenId] = uri;
1061     }
1062 
1063     /**
1064      * @dev Internal function to burn a specific token
1065      * Reverts if the token does not exist
1066      * Deprecated, use _burn(uint256) instead
1067      * @param owner owner of the token to burn
1068      * @param tokenId uint256 ID of the token being burned by the msg.sender
1069      */
1070     function _burn(address owner, uint256 tokenId) internal {
1071         super._burn(owner, tokenId);
1072 
1073         // Clear metadata (if any)
1074         if (bytes(_tokenURIs[tokenId]).length != 0) {
1075             delete _tokenURIs[tokenId];
1076         }
1077     }
1078 }
1079 
1080 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
1081 
1082 pragma solidity ^0.5.2;
1083 
1084 
1085 
1086 
1087 /**
1088  * @title Full ERC721 Token
1089  * This implementation includes all the required and some optional functionality of the ERC721 standard
1090  * Moreover, it includes approve all functionality using operator terminology
1091  * @dev see https://eips.ethereum.org/EIPS/eip-721
1092  */
1093 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1094     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1095         // solhint-disable-previous-line no-empty-blocks
1096     }
1097 }
1098 
1099 
1100 // File: contracts/TradeableERC721Token.sol
1101 
1102 pragma solidity ^0.5.2;
1103 
1104 
1105 
1106 
1107 contract OwnableDelegateProxy { }
1108 
1109 
1110 
1111 contract ProxyRegistry {
1112     mapping(address => OwnableDelegateProxy) public proxies;
1113 }
1114 
1115 /**
1116  * @title TradeableERC721Token
1117  * TradeableERC721Token - ERC721 contract that whitelists a trading address, and has minting functionality.
1118  */
1119 contract TradeableERC721Token is ERC721Full, Ownable {
1120   using Strings for string;
1121   
1122   uint256 public tokenPrice=5 * (10**16) ;  //price of token to buy
1123   address proxyRegistryAddress;
1124   uint256 private _currentTokenId = 0;
1125   
1126   
1127 
1128   constructor(string memory _name, string memory _symbol) ERC721Full(_name, _symbol) public {
1129   }
1130 
1131   /**
1132     * @dev Mints a token to an address with a tokenURI.
1133     * @param _to address of the future owner of the token
1134     */
1135   function mintTo(address _to) public onlyOwner {
1136     uint256 newTokenId = _getNextTokenId();
1137     _mint(_to, newTokenId,0);
1138     _incrementTokenId();
1139   }
1140 
1141 
1142   function setTokenPrice(uint256 _tokenPrice) public onlyOwner returns(bool)
1143   {
1144       tokenPrice = _tokenPrice;
1145       return true;
1146   }
1147   
1148 
1149   function buyToken(uint256 _userSeed) public payable returns(bool)
1150   {
1151     uint256 paidAmount = msg.value;
1152     require(paidAmount == tokenPrice, "Invalid amount paid");
1153     uint256 newTokenId = _getNextTokenId();
1154     _mint(msg.sender, newTokenId,_userSeed);
1155     _incrementTokenId(); 
1156     _owner.transfer(paidAmount);
1157      return true;
1158   }
1159   
1160   function batchMintToken(address[] memory _buyer) public onlyOwner returns(bool)
1161   {
1162       uint256 buyerLength = _buyer.length;
1163       require(buyerLength <= 100, "please try less then 101");
1164       for(uint256 i=0;i<buyerLength;i++)
1165       {
1166         uint256 newTokenId = _getNextTokenId();
1167         _mint(_buyer[i], newTokenId,0);
1168         _incrementTokenId();           
1169       }
1170       return true;
1171   }
1172   
1173 
1174   /**
1175     * @dev calculates the next token ID based on value of _currentTokenId 
1176     * @return uint256 for the next token ID
1177     */
1178   function _getNextTokenId() private view returns (uint256) {
1179     return _currentTokenId.add(1);
1180   }
1181 
1182   /**
1183     * @dev increments the value of _currentTokenId 
1184     */
1185   function _incrementTokenId() private  {
1186     _currentTokenId++;
1187   }
1188 
1189   function baseTokenURI() public view returns (string memory) {
1190     return "";
1191   }
1192 
1193   function tokenURI(uint256 _tokenId) external view returns (string memory) {
1194     return Strings.strConcat(baseTokenURI(),Strings.uint2str(_tokenId)
1195     );
1196   }
1197 
1198   /**
1199    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1200    */
1201   function isApprovedForAll(
1202     address owner,
1203     address operator
1204   )
1205     public
1206     view
1207     returns (bool)
1208   {
1209     // Whitelist OpenSea proxy contract for easy trading.
1210     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1211     if (address(proxyRegistry.proxies(owner)) == operator) {
1212         return true;
1213     }
1214 
1215     return super.isApprovedForAll(owner, operator);
1216   }
1217   
1218   function changeProxyURL(address newProxyAddress) public onlyOwner returns(bool){
1219       proxyRegistryAddress = newProxyAddress;
1220       return true;
1221   }
1222   
1223   
1224   function syncFromOldContract(uint256[] memory tokens, address[] memory users) public onlyOwner returns(bool) {
1225       uint256 arrayLength = tokens.length;
1226         require(arrayLength <= 150, 'Too many tokens IDs');
1227         
1228         //processing each entries
1229         for(uint8 i=0; i< arrayLength; i++ ){
1230             if(!_exists(tokens[i])){
1231                 _mintSyncedTokens(tokens[i], users[i]);
1232                 _incrementTokenId(); 
1233             }
1234         }
1235         return true;
1236     }
1237   
1238 }
1239 
1240 // File: contracts/OpenSeaAsset.sol
1241 
1242 pragma solidity ^0.5.2;
1243 
1244 
1245 
1246 /**
1247  * @title OpenSea Asset
1248  * OpenSea Asset - A contract for easily creating custom assets on OpenSea. 
1249  */
1250 contract Niftymoji is TradeableERC721Token {
1251   string private _baseTokenURI;
1252   uint256 public changePowerPrice = 20000000000000000; //0.02 ETH
1253   uint256 public changeLuckPrice =  20000000000000000; //0.02 ETH
1254 
1255   constructor(
1256     string memory _name,
1257     string memory _symbol,
1258     string memory baseURI
1259   ) TradeableERC721Token(_name, _symbol) public {
1260     _baseTokenURI = baseURI;
1261   }
1262 
1263   function openSeaVersion() public pure returns (string memory) {
1264     return "1.2.0";
1265   }
1266 
1267   function baseTokenURI() public view returns (string memory) {
1268     return _baseTokenURI;
1269   }
1270 
1271   function setBaseTokenURI(string memory uri) public onlyOwner {
1272     _baseTokenURI = uri;
1273   }
1274   
1275   function changePowerLuckPrice(uint256 powerPrice, uint256 luckPrice) public onlyOwner returns(bool){
1276       changePowerPrice = powerPrice;
1277       changeLuckPrice  = luckPrice;
1278       return true;
1279   }
1280   
1281   /**
1282    * Status: 0 = only power, 1 = only luck, 2 = both power and luck
1283    */
1284   function changePowerLuck(uint256 tokenID, uint8 status) public payable returns(bool){
1285       require(msg.sender == ownerOf(tokenID), 'This token is not owned by caller');
1286       if(status == 0){
1287           require(msg.value == changePowerPrice, 'Invalid ETH amount');
1288             //generating random numbers for luck and power based on previous blockhash and timestamp
1289             //this method of entropy is not very secure, but kept it as consent of client
1290             uint256 _power = uint256(keccak256(abi.encodePacked(blockhash( block.number -10), now))) % 100; //0-99 
1291             powerNLucks[tokenID].power = _power+1;  //this will cause it will never be zero.
1292       }
1293       else if(status == 1){
1294           require(msg.value == changeLuckPrice, 'Invalid ETH amount');
1295             uint256 _luck = uint256(keccak256(abi.encodePacked(blockhash( block.number -1)))) % 100;        //0-99
1296             powerNLucks[tokenID].luck = _luck+1;    //this will cause it will never be zero.
1297       }
1298       else if(status == 2){
1299           require(msg.value == (changePowerPrice + changeLuckPrice), 'Invalid ETH amount');
1300             uint256 _luck = uint256(keccak256(abi.encodePacked(blockhash( block.number -1)))) % 100;        //0-99
1301             uint256 _power = uint256(keccak256(abi.encodePacked(blockhash( block.number -10), now))) % 100; //0-99 
1302             //assigning lucky no and power to tokenId        
1303             powerNLucks[tokenID].luck = _luck+1;    //this will cause it will never be zero.
1304             powerNLucks[tokenID].power = _power+1;  //this will cause it will never be zero.
1305       }
1306       
1307         _owner.transfer(msg.value);
1308         return true;
1309       
1310   }
1311   
1312   
1313   
1314   
1315   
1316 }