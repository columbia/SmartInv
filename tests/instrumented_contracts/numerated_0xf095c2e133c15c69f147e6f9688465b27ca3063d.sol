1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-15
3 */
4 
5 // File: contracts/Strings.sol
6 
7 pragma solidity ^0.5.2;
8 
9 library Strings {
10   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
11   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
12     bytes memory _ba = bytes(_a);
13     bytes memory _bb = bytes(_b);
14     bytes memory _bc = bytes(_c);
15     bytes memory _bd = bytes(_d);
16     bytes memory _be = bytes(_e); 
17     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
18     bytes memory babcde = bytes(abcde);
19     uint k = 0;
20     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
21     for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
22     for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
23     for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
24     for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
25     return string(babcde);
26   }
27 
28   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
29     return strConcat(_a, _b, _c, _d, "");
30   }
31 
32   function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
33     return strConcat(_a, _b, _c, "", "");
34   }
35 
36   function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
37     return strConcat(_a, _b, "", "", "");
38   }
39 
40   function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
41     if (_i == 0) {
42       return "0";
43     }
44     uint j = _i;
45     uint len;
46     while (j != 0) {
47       len++;
48       j /= 10;
49     }
50     bytes memory bstr = new bytes(len);
51     uint k = len - 1;
52     while (_i != 0) {
53       bstr[k--] = byte(uint8(48 + _i % 10));
54       _i /= 10;
55     }
56     return string(bstr);
57   }
58 
59   function fromAddress(address addr) internal pure returns(string memory) {
60     bytes20 addrBytes = bytes20(addr);
61     bytes16 hexAlphabet = "0123456789abcdef";
62     bytes memory result = new bytes(42);
63     result[0] = '0';
64     result[1] = 'x';
65     for (uint i = 0; i < 20; i++) {
66       result[i * 2 + 2] = hexAlphabet[uint8(addrBytes[i] >> 4)];
67       result[i * 2 + 3] = hexAlphabet[uint8(addrBytes[i] & 0x0f)];
68     }
69     return string(result);
70   }
71 }
72 
73 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
74 
75 pragma solidity ^0.5.2;
76 
77 /**
78  * @title IERC165
79  * @dev https://eips.ethereum.org/EIPS/eip-165
80  */
81 interface IERC165 {
82     /**
83      * @notice Query if a contract implements an interface
84      * @param interfaceId The interface identifier, as specified in ERC-165
85      * @dev Interface identification is specified in ERC-165. This function
86      * uses less than 30,000 gas.
87      */
88     function supportsInterface(bytes4 interfaceId) external view returns (bool);
89 }
90 
91 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
92 
93 pragma solidity ^0.5.2;
94 
95 
96 /**
97  * @title ERC721 Non-Fungible Token Standard basic interface
98  * @dev see https://eips.ethereum.org/EIPS/eip-721
99  */
100 contract IERC721 is IERC165 {
101     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
102     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
103     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
104 
105     function balanceOf(address owner) public view returns (uint256 balance);
106     function ownerOf(uint256 tokenId) public view returns (address owner);
107 
108     function approve(address to, uint256 tokenId) public;
109     function getApproved(uint256 tokenId) public view returns (address operator);
110 
111     function setApprovalForAll(address operator, bool _approved) public;
112     function isApprovedForAll(address owner, address operator) public view returns (bool);
113 
114     function transferFrom(address from, address to, uint256 tokenId) public;
115     function safeTransferFrom(address from, address to, uint256 tokenId) public;
116 
117     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
118 }
119 
120 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
121 
122 pragma solidity ^0.5.2;
123 
124 /**
125  * @title ERC721 token receiver interface
126  * @dev Interface for any contract that wants to support safeTransfers
127  * from ERC721 asset contracts.
128  */
129 contract IERC721Receiver {
130     /**
131      * @notice Handle the receipt of an NFT
132      * @dev The ERC721 smart contract calls this function on the recipient
133      * after a `safeTransfer`. This function MUST return the function selector,
134      * otherwise the caller will revert the transaction. The selector to be
135      * returned can be obtained as `this.onERC721Received.selector`. This
136      * function MAY throw to revert and reject the transfer.
137      * Note: the ERC721 contract address is always the message sender.
138      * @param operator The address which called `safeTransferFrom` function
139      * @param from The address which previously owned the token
140      * @param tokenId The NFT identifier which is being transferred
141      * @param data Additional data with no specified format
142      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
143      */
144     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
145     public returns (bytes4);
146 }
147 
148 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
149 
150 pragma solidity ^0.5.2;
151 
152 /**
153  * @title SafeMath
154  * @dev Unsigned math operations with safety checks that revert on error
155  */
156 library SafeMath {
157     /**
158      * @dev Multiplies two unsigned integers, reverts on overflow.
159      */
160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162         // benefit is lost if 'b' is also tested.
163         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
164         if (a == 0) {
165             return 0;
166         }
167 
168         uint256 c = a * b;
169         require(c / a == b);
170 
171         return c;
172     }
173 
174     /**
175      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Solidity only automatically asserts when dividing by 0
179         require(b > 0);
180         uint256 c = a / b;
181         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
182 
183         return c;
184     }
185 
186     /**
187      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
188      */
189     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
190         require(b <= a);
191         uint256 c = a - b;
192 
193         return c;
194     }
195 
196     /**
197      * @dev Adds two unsigned integers, reverts on overflow.
198      */
199     function add(uint256 a, uint256 b) internal pure returns (uint256) {
200         uint256 c = a + b;
201         require(c >= a);
202 
203         return c;
204     }
205 
206     /**
207      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
208      * reverts when dividing by zero.
209      */
210     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
211         require(b != 0);
212         return a % b;
213     }
214 }
215 
216 // File: openzeppelin-solidity/contracts/utils/Address.sol
217 
218 pragma solidity ^0.5.2;
219 
220 /**
221  * Utility library of inline functions on addresses
222  */
223 library Address {
224     /**
225      * Returns whether the target address is a contract
226      * @dev This function will return false if invoked during the constructor of a contract,
227      * as the code is not actually created until after the constructor finishes.
228      * @param account address of the account to check
229      * @return whether the target address is a contract
230      */
231     function isContract(address account) internal view returns (bool) {
232         uint256 size;
233         // XXX Currently there is no better way to check if there is a contract in an address
234         // than to check the size of the code at that address.
235         // See https://ethereum.stackexchange.com/a/14016/36603
236         // for more details about how this works.
237         // TODO Check this again before the Serenity release, because all addresses will be
238         // contracts then.
239         // solhint-disable-next-line no-inline-assembly
240         assembly { size := extcodesize(account) }
241         return size > 0;
242     }
243 }
244 
245 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
246 
247 pragma solidity ^0.5.2;
248 
249 
250 /**
251  * @title Counters
252  * @author Matt Condon (@shrugs)
253  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
254  * of elements in a mapping, issuing ERC721 ids, or counting request ids
255  *
256  * Include with `using Counters for Counters.Counter;`
257  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
258  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
259  * directly accessed.
260  */
261 library Counters {
262     using SafeMath for uint256;
263 
264     struct Counter {
265         // This variable should never be directly accessed by users of the library: interactions must be restricted to
266         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
267         // this feature: see https://github.com/ethereum/solidity/issues/4637
268         uint256 _value; // default: 0
269     }
270 
271     function current(Counter storage counter) internal view returns (uint256) {
272         return counter._value;
273     }
274 
275     function increment(Counter storage counter) internal {
276         counter._value += 1;
277     }
278 
279     function decrement(Counter storage counter) internal {
280         counter._value = counter._value.sub(1);
281     }
282 }
283 
284 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
285 
286 pragma solidity ^0.5.2;
287 
288 
289 /**
290  * @title ERC165
291  * @author Matt Condon (@shrugs)
292  * @dev Implements ERC165 using a lookup table.
293  */
294 contract ERC165 is IERC165 {
295     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
296     /*
297      * 0x01ffc9a7 ===
298      *     bytes4(keccak256('supportsInterface(bytes4)'))
299      */
300 
301     /**
302      * @dev a mapping of interface id to whether or not it's supported
303      */
304     mapping(bytes4 => bool) private _supportedInterfaces;
305 
306     /**
307      * @dev A contract implementing SupportsInterfaceWithLookup
308      * implement ERC165 itself
309      */
310     constructor () internal {
311         _registerInterface(_INTERFACE_ID_ERC165);
312     }
313 
314     /**
315      * @dev implement supportsInterface(bytes4) using a lookup table
316      */
317     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
318         return _supportedInterfaces[interfaceId];
319     }
320 
321     /**
322      * @dev internal method for registering an interface
323      */
324     function _registerInterface(bytes4 interfaceId) internal {
325         require(interfaceId != 0xffffffff);
326         _supportedInterfaces[interfaceId] = true;
327     }
328 }
329 
330 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
331 
332 pragma solidity ^0.5.2;
333 
334 
335 
336 
337 
338 
339 
340 /**
341  * @title ERC721 Non-Fungible Token Standard basic implementation
342  * @dev see https://eips.ethereum.org/EIPS/eip-721
343  */
344 contract ERC721 is ERC165, IERC721 {
345     using SafeMath for uint256;
346     using Address for address;
347     using Counters for Counters.Counter;
348 
349     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
350     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
351     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
352 
353     // Mapping from token ID to owner
354     mapping (uint256 => address) private _tokenOwner;
355 
356     // Mapping from token ID to approved address
357     mapping (uint256 => address) private _tokenApprovals;
358 
359     // Mapping from owner to number of owned token
360     mapping (address => Counters.Counter) private _ownedTokensCount;
361 
362     // Mapping from owner to operator approvals
363     mapping (address => mapping (address => bool)) private _operatorApprovals;
364 
365     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
366     /*
367      * 0x80ac58cd ===
368      *     bytes4(keccak256('balanceOf(address)')) ^
369      *     bytes4(keccak256('ownerOf(uint256)')) ^
370      *     bytes4(keccak256('approve(address,uint256)')) ^
371      *     bytes4(keccak256('getApproved(uint256)')) ^
372      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
373      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
374      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
375      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
376      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
377      */
378 
379     constructor () public {
380         // register the supported interfaces to conform to ERC721 via ERC165
381         _registerInterface(_INTERFACE_ID_ERC721);
382     }
383 
384     /**
385      * @dev Gets the balance of the specified address
386      * @param owner address to query the balance of
387      * @return uint256 representing the amount owned by the passed address
388      */
389     function balanceOf(address owner) public view returns (uint256) {
390         require(owner != address(0));
391         return _ownedTokensCount[owner].current();
392     }
393 
394     /**
395      * @dev Gets the owner of the specified token ID
396      * @param tokenId uint256 ID of the token to query the owner of
397      * @return address currently marked as the owner of the given token ID
398      */
399     function ownerOf(uint256 tokenId) public view returns (address) {
400         address owner = _tokenOwner[tokenId];
401         require(owner != address(0));
402         return owner;
403     }
404 
405     /**
406      * @dev Approves another address to transfer the given token ID
407      * The zero address indicates there is no approved address.
408      * There can only be one approved address per token at a given time.
409      * Can only be called by the token owner or an approved operator.
410      * @param to address to be approved for the given token ID
411      * @param tokenId uint256 ID of the token to be approved
412      */
413     function approve(address to, uint256 tokenId) public {
414         address owner = ownerOf(tokenId);
415         require(to != owner);
416         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
417 
418         _tokenApprovals[tokenId] = to;
419         emit Approval(owner, to, tokenId);
420     }
421 
422     /**
423      * @dev Gets the approved address for a token ID, or zero if no address set
424      * Reverts if the token ID does not exist.
425      * @param tokenId uint256 ID of the token to query the approval of
426      * @return address currently approved for the given token ID
427      */
428     function getApproved(uint256 tokenId) public view returns (address) {
429         require(_exists(tokenId));
430         return _tokenApprovals[tokenId];
431     }
432 
433     /**
434      * @dev Sets or unsets the approval of a given operator
435      * An operator is allowed to transfer all tokens of the sender on their behalf
436      * @param to operator address to set the approval
437      * @param approved representing the status of the approval to be set
438      */
439     function setApprovalForAll(address to, bool approved) public {
440         require(to != msg.sender);
441         _operatorApprovals[msg.sender][to] = approved;
442         emit ApprovalForAll(msg.sender, to, approved);
443     }
444 
445     /**
446      * @dev Tells whether an operator is approved by a given owner
447      * @param owner owner address which you want to query the approval of
448      * @param operator operator address which you want to query the approval of
449      * @return bool whether the given operator is approved by the given owner
450      */
451     function isApprovedForAll(address owner, address operator) public view returns (bool) {
452         return _operatorApprovals[owner][operator];
453     }
454 
455     /**
456      * @dev Transfers the ownership of a given token ID to another address
457      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
458      * Requires the msg.sender to be the owner, approved, or operator
459      * @param from current owner of the token
460      * @param to address to receive the ownership of the given token ID
461      * @param tokenId uint256 ID of the token to be transferred
462      */
463     function transferFrom(address from, address to, uint256 tokenId) public {
464         require(_isApprovedOrOwner(msg.sender, tokenId));
465 
466         _transferFrom(from, to, tokenId);
467     }
468 
469     /**
470      * @dev Safely transfers the ownership of a given token ID to another address
471      * If the target address is a contract, it must implement `onERC721Received`,
472      * which is called upon a safe transfer, and return the magic value
473      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
474      * the transfer is reverted.
475      * Requires the msg.sender to be the owner, approved, or operator
476      * @param from current owner of the token
477      * @param to address to receive the ownership of the given token ID
478      * @param tokenId uint256 ID of the token to be transferred
479      */
480     function safeTransferFrom(address from, address to, uint256 tokenId) public {
481         safeTransferFrom(from, to, tokenId, "");
482     }
483 
484     /**
485      * @dev Safely transfers the ownership of a given token ID to another address
486      * If the target address is a contract, it must implement `onERC721Received`,
487      * which is called upon a safe transfer, and return the magic value
488      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
489      * the transfer is reverted.
490      * Requires the msg.sender to be the owner, approved, or operator
491      * @param from current owner of the token
492      * @param to address to receive the ownership of the given token ID
493      * @param tokenId uint256 ID of the token to be transferred
494      * @param _data bytes data to send along with a safe transfer check
495      */
496     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
497         transferFrom(from, to, tokenId);
498         require(_checkOnERC721Received(from, to, tokenId, _data));
499     }
500 
501     /**
502      * @dev Returns whether the specified token exists
503      * @param tokenId uint256 ID of the token to query the existence of
504      * @return bool whether the token exists
505      */
506     function _exists(uint256 tokenId) internal view returns (bool) {
507         address owner = _tokenOwner[tokenId];
508         return owner != address(0);
509     }
510 
511     /**
512      * @dev Returns whether the given spender can transfer a given token ID
513      * @param spender address of the spender to query
514      * @param tokenId uint256 ID of the token to be transferred
515      * @return bool whether the msg.sender is approved for the given token ID,
516      * is an operator of the owner, or is the owner of the token
517      */
518     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
519         address owner = ownerOf(tokenId);
520         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
521     }
522 
523     /**
524      * @dev Internal function to mint a new token
525      * Reverts if the given token ID already exists
526      * @param to The address that will own the minted token
527      * @param tokenId uint256 ID of the token to be minted
528      */
529     function _mint(address to, uint256 tokenId) internal {
530         require(to != address(0));
531         require(!_exists(tokenId));
532 
533         _tokenOwner[tokenId] = to;
534         _ownedTokensCount[to].increment();
535 
536         emit Transfer(address(0), to, tokenId);
537     }
538 
539     /**
540      * @dev Internal function to burn a specific token
541      * Reverts if the token does not exist
542      * Deprecated, use _burn(uint256) instead.
543      * @param owner owner of the token to burn
544      * @param tokenId uint256 ID of the token being burned
545      */
546     function _burn(address owner, uint256 tokenId) internal {
547         require(ownerOf(tokenId) == owner);
548 
549         _clearApproval(tokenId);
550 
551         _ownedTokensCount[owner].decrement();
552         _tokenOwner[tokenId] = address(0);
553 
554         emit Transfer(owner, address(0), tokenId);
555     }
556 
557     /**
558      * @dev Internal function to burn a specific token
559      * Reverts if the token does not exist
560      * @param tokenId uint256 ID of the token being burned
561      */
562     function _burn(uint256 tokenId) internal {
563         _burn(ownerOf(tokenId), tokenId);
564     }
565 
566     /**
567      * @dev Internal function to transfer ownership of a given token ID to another address.
568      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
569      * @param from current owner of the token
570      * @param to address to receive the ownership of the given token ID
571      * @param tokenId uint256 ID of the token to be transferred
572      */
573     function _transferFrom(address from, address to, uint256 tokenId) internal {
574         require(ownerOf(tokenId) == from);
575         require(to != address(0));
576 
577         _clearApproval(tokenId);
578 
579         _ownedTokensCount[from].decrement();
580         _ownedTokensCount[to].increment();
581 
582         _tokenOwner[tokenId] = to;
583 
584         emit Transfer(from, to, tokenId);
585     }
586 
587     /**
588      * @dev Internal function to invoke `onERC721Received` on a target address
589      * The call is not executed if the target address is not a contract
590      * @param from address representing the previous owner of the given token ID
591      * @param to target address that will receive the tokens
592      * @param tokenId uint256 ID of the token to be transferred
593      * @param _data bytes optional data to send along with the call
594      * @return bool whether the call correctly returned the expected magic value
595      */
596     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
597         internal returns (bool)
598     {
599         if (!to.isContract()) {
600             return true;
601         }
602 
603         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
604         return (retval == _ERC721_RECEIVED);
605     }
606 
607     /**
608      * @dev Private function to clear current approval of a given token ID
609      * @param tokenId uint256 ID of the token to be transferred
610      */
611     function _clearApproval(uint256 tokenId) private {
612         if (_tokenApprovals[tokenId] != address(0)) {
613             _tokenApprovals[tokenId] = address(0);
614         }
615     }
616 }
617 
618 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
619 
620 pragma solidity ^0.5.2;
621 
622 
623 /**
624  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
625  * @dev See https://eips.ethereum.org/EIPS/eip-721
626  */
627 contract IERC721Enumerable is IERC721 {
628     function totalSupply() public view returns (uint256);
629     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
630 
631     function tokenByIndex(uint256 index) public view returns (uint256);
632 }
633 
634 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
635 
636 pragma solidity ^0.5.2;
637 
638 
639 
640 
641 /**
642  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
643  * @dev See https://eips.ethereum.org/EIPS/eip-721
644  */
645 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
646     // Mapping from owner to list of owned token IDs
647     mapping(address => uint256[]) private _ownedTokens;
648 
649     // Mapping from token ID to index of the owner tokens list
650     mapping(uint256 => uint256) private _ownedTokensIndex;
651 
652     // Array with all token ids, used for enumeration
653     uint256[] private _allTokens;
654 
655     // Mapping from token id to position in the allTokens array
656     mapping(uint256 => uint256) private _allTokensIndex;
657 
658     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
659     /*
660      * 0x780e9d63 ===
661      *     bytes4(keccak256('totalSupply()')) ^
662      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
663      *     bytes4(keccak256('tokenByIndex(uint256)'))
664      */
665 
666     /**
667      * @dev Constructor function
668      */
669     constructor () public {
670         // register the supported interface to conform to ERC721Enumerable via ERC165
671         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
672     }
673 
674     /**
675      * @dev Gets the token ID at a given index of the tokens list of the requested owner
676      * @param owner address owning the tokens list to be accessed
677      * @param index uint256 representing the index to be accessed of the requested tokens list
678      * @return uint256 token ID at the given index of the tokens list owned by the requested address
679      */
680     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
681         require(index < balanceOf(owner));
682         return _ownedTokens[owner][index];
683     }
684 
685     /**
686      * @dev Gets the total amount of tokens stored by the contract
687      * @return uint256 representing the total amount of tokens
688      */
689     function totalSupply() public view returns (uint256) {
690         return _allTokens.length;
691     }
692 
693     /**
694      * @dev Gets the token ID at a given index of all the tokens in this contract
695      * Reverts if the index is greater or equal to the total number of tokens
696      * @param index uint256 representing the index to be accessed of the tokens list
697      * @return uint256 token ID at the given index of the tokens list
698      */
699     function tokenByIndex(uint256 index) public view returns (uint256) {
700         require(index < totalSupply());
701         return _allTokens[index];
702     }
703 
704     /**
705      * @dev Internal function to transfer ownership of a given token ID to another address.
706      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
707      * @param from current owner of the token
708      * @param to address to receive the ownership of the given token ID
709      * @param tokenId uint256 ID of the token to be transferred
710      */
711     function _transferFrom(address from, address to, uint256 tokenId) internal {
712         super._transferFrom(from, to, tokenId);
713 
714         _removeTokenFromOwnerEnumeration(from, tokenId);
715 
716         _addTokenToOwnerEnumeration(to, tokenId);
717     }
718 
719     /**
720      * @dev Internal function to mint a new token
721      * Reverts if the given token ID already exists
722      * @param to address the beneficiary that will own the minted token
723      * @param tokenId uint256 ID of the token to be minted
724      */
725     function _mint(address to, uint256 tokenId) internal {
726         super._mint(to, tokenId);
727 
728         _addTokenToOwnerEnumeration(to, tokenId);
729 
730         _addTokenToAllTokensEnumeration(tokenId);
731     }
732 
733     /**
734      * @dev Internal function to burn a specific token
735      * Reverts if the token does not exist
736      * Deprecated, use _burn(uint256) instead
737      * @param owner owner of the token to burn
738      * @param tokenId uint256 ID of the token being burned
739      */
740     function _burn(address owner, uint256 tokenId) internal {
741         super._burn(owner, tokenId);
742 
743         _removeTokenFromOwnerEnumeration(owner, tokenId);
744         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
745         _ownedTokensIndex[tokenId] = 0;
746 
747         _removeTokenFromAllTokensEnumeration(tokenId);
748     }
749 
750     /**
751      * @dev Gets the list of token IDs of the requested owner
752      * @param owner address owning the tokens
753      * @return uint256[] List of token IDs owned by the requested address
754      */
755     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
756         return _ownedTokens[owner];
757     }
758 
759     /**
760      * @dev Private function to add a token to this extension's ownership-tracking data structures.
761      * @param to address representing the new owner of the given token ID
762      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
763      */
764     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
765         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
766         _ownedTokens[to].push(tokenId);
767     }
768 
769     /**
770      * @dev Private function to add a token to this extension's token tracking data structures.
771      * @param tokenId uint256 ID of the token to be added to the tokens list
772      */
773     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
774         _allTokensIndex[tokenId] = _allTokens.length;
775         _allTokens.push(tokenId);
776     }
777 
778     /**
779      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
780      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
781      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
782      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
783      * @param from address representing the previous owner of the given token ID
784      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
785      */
786     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
787         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
788         // then delete the last slot (swap and pop).
789 
790         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
791         uint256 tokenIndex = _ownedTokensIndex[tokenId];
792 
793         // When the token to delete is the last token, the swap operation is unnecessary
794         if (tokenIndex != lastTokenIndex) {
795             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
796 
797             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
798             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
799         }
800 
801         // This also deletes the contents at the last position of the array
802         _ownedTokens[from].length--;
803 
804         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
805         // lastTokenId, or just over the end of the array if the token was the last one).
806     }
807 
808     /**
809      * @dev Private function to remove a token from this extension's token tracking data structures.
810      * This has O(1) time complexity, but alters the order of the _allTokens array.
811      * @param tokenId uint256 ID of the token to be removed from the tokens list
812      */
813     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
814         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
815         // then delete the last slot (swap and pop).
816 
817         uint256 lastTokenIndex = _allTokens.length.sub(1);
818         uint256 tokenIndex = _allTokensIndex[tokenId];
819 
820         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
821         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
822         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
823         uint256 lastTokenId = _allTokens[lastTokenIndex];
824 
825         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
826         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
827 
828         // This also deletes the contents at the last position of the array
829         _allTokens.length--;
830         _allTokensIndex[tokenId] = 0;
831     }
832 }
833 
834 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
835 
836 pragma solidity ^0.5.2;
837 
838 
839 /**
840  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
841  * @dev See https://eips.ethereum.org/EIPS/eip-721
842  */
843 contract IERC721Metadata is IERC721 {
844     function name() external view returns (string memory);
845     function symbol() external view returns (string memory);
846     function tokenURI(uint256 tokenId) external view returns (string memory);
847 }
848 
849 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
850 
851 pragma solidity ^0.5.2;
852 
853 
854 
855 
856 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
857     // Token name
858     string private _name;
859 
860     // Token symbol
861     string private _symbol;
862 
863     // Optional mapping for token URIs
864     mapping(uint256 => string) internal _tokenURIs;
865 
866     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
867     /*
868      * 0x5b5e139f ===
869      *     bytes4(keccak256('name()')) ^
870      *     bytes4(keccak256('symbol()')) ^
871      *     bytes4(keccak256('tokenURI(uint256)'))
872      */
873 
874     /**
875      * @dev Constructor function
876      */
877     constructor (string memory name, string memory symbol) public {
878         _name = name;
879         _symbol = symbol;
880 
881         // register the supported interfaces to conform to ERC721 via ERC165
882         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
883     }
884 
885     /**
886      * @dev Gets the token name
887      * @return string representing the token name
888      */
889     function name() external view returns (string memory) {
890         return _name;
891     }
892 
893     /**
894      * @dev Gets the token symbol
895      * @return string representing the token symbol
896      */
897     function symbol() external view returns (string memory) {
898         return _symbol;
899     }
900 
901     /**
902      * @dev Returns an URI for a given token ID
903      * Throws if the token ID does not exist. May return an empty string.
904      * @param tokenId uint256 ID of the token to query
905      */
906     function tokenURI(uint256 tokenId) external view returns (string memory) {
907         require(_exists(tokenId));
908         return _tokenURIs[tokenId];
909     }
910 
911     /**
912      * @dev Internal function to set the token URI for a given token
913      * Reverts if the token ID does not exist
914      * @param tokenId uint256 ID of the token to set its URI
915      * @param uri string URI to assign
916      */
917     function _setTokenURI(uint256 tokenId, string memory uri) internal {
918         require(_exists(tokenId));
919         _tokenURIs[tokenId] = uri;
920     }
921 
922     /**
923      * @dev Internal function to burn a specific token
924      * Reverts if the token does not exist
925      * Deprecated, use _burn(uint256) instead
926      * @param owner owner of the token to burn
927      * @param tokenId uint256 ID of the token being burned by the msg.sender
928      */
929     function _burn(address owner, uint256 tokenId) internal {
930         super._burn(owner, tokenId);
931 
932         // Clear metadata (if any)
933         if (bytes(_tokenURIs[tokenId]).length != 0) {
934             delete _tokenURIs[tokenId];
935         }
936     }
937 }
938 
939 
940 //=======================================
941 
942 pragma solidity ^0.5.2;
943 
944 /*
945  * @dev Provides information about the current execution context, including the
946  * sender of the transaction and its data. While these are generally available
947  * via msg.sender and msg.data, they should not be accessed in such a direct
948  * manner, since when dealing with GSN meta-transactions the account sending and
949  * paying for execution may not be the actual sender (as far as an application
950  * is concerned).
951  *
952  * This contract is only required for intermediate, library-like contracts.
953  */
954 contract Context {
955     // Empty internal constructor, to prevent people from mistakenly deploying
956     // an instance of this contract, which should be used via inheritance.
957     constructor () internal { }
958     // solhint-disable-previous-line no-empty-blocks
959 
960     function _msgSender() internal view returns (address payable) {
961         return msg.sender;
962     }
963 
964     function _msgData() internal view returns (bytes memory) {
965         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
966         return msg.data;
967     }
968 }
969 
970 
971 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Burnable.sol
972 pragma solidity ^0.5.2;
973 
974 
975 /**
976  * @title ERC721 Burnable Token
977  * @dev ERC721 Token that can be irreversibly burned (destroyed).
978  */
979 contract ERC721Burnable is Context, ERC721 {
980     /**
981      * @dev Burns a specific ERC721 token.
982      * @param tokenId uint256 id of the ERC721 token to be burned.
983      */
984     function burn(uint256 tokenId) public {
985         //solhint-disable-next-line max-line-length
986         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
987         _burn(tokenId);
988     }
989 }
990 
991 //=====================================================
992 
993 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
994 
995 pragma solidity ^0.5.2;
996 
997 
998 
999 
1000 /**
1001  * @title Full ERC721 Token
1002  * This implementation includes all the required and some optional functionality of the ERC721 standard
1003  * Moreover, it includes approve all functionality using operator terminology
1004  * @dev see https://eips.ethereum.org/EIPS/eip-721
1005  */
1006 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata, ERC721Burnable {
1007     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1008         // solhint-disable-previous-line no-empty-blocks
1009     }
1010 }
1011 
1012 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1013 
1014 pragma solidity ^0.5.2;
1015 
1016 /**
1017  * @title Ownable
1018  * @dev The Ownable contract has an owner address, and provides basic authorization control
1019  * functions, this simplifies the implementation of "user permissions".
1020  */
1021 contract Ownable {
1022     address private _owner;
1023 
1024     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1025 
1026     /**
1027      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1028      * account.
1029      */
1030     constructor () internal {
1031         _owner = msg.sender;
1032         emit OwnershipTransferred(address(0), _owner);
1033     }
1034 
1035     /**
1036      * @return the address of the owner.
1037      */
1038     function owner() public view returns (address) {
1039         return _owner;
1040     }
1041 
1042     /**
1043      * @dev Throws if called by any account other than the owner.
1044      */
1045     modifier onlyOwner() {
1046         require(isOwner());
1047         _;
1048     }
1049 
1050     /**
1051      * @return true if `msg.sender` is the owner of the contract.
1052      */
1053     function isOwner() public view returns (bool) {
1054         return msg.sender == _owner;
1055     }
1056 
1057     /**
1058      * @dev Allows the current owner to relinquish control of the contract.
1059      * It will not be possible to call the functions with the `onlyOwner`
1060      * modifier anymore.
1061      * @notice Renouncing ownership will leave the contract without an owner,
1062      * thereby removing any functionality that is only available to the owner.
1063      */
1064     function renounceOwnership() public onlyOwner {
1065         emit OwnershipTransferred(_owner, address(0));
1066         _owner = address(0);
1067     }
1068 
1069     /**
1070      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1071      * @param newOwner The address to transfer ownership to.
1072      */
1073     function transferOwnership(address newOwner) public onlyOwner {
1074         _transferOwnership(newOwner);
1075     }
1076 
1077     /**
1078      * @dev Transfers control of the contract to a newOwner.
1079      * @param newOwner The address to transfer ownership to.
1080      */
1081     function _transferOwnership(address newOwner) internal {
1082         require(newOwner != address(0));
1083         emit OwnershipTransferred(_owner, newOwner);
1084         _owner = newOwner;
1085     }
1086 }
1087 
1088 // File: contracts/TradeableERC721Token.sol
1089 
1090 pragma solidity ^0.5.2;
1091 
1092 
1093 
1094 
1095 contract OwnableDelegateProxy { }
1096 
1097 contract ProxyRegistry {
1098     mapping(address => OwnableDelegateProxy) public proxies;
1099 }
1100 
1101 /**
1102  * @title TradeableERC721Token
1103  * TradeableERC721Token - ERC721 contract that whitelists a trading address, and has minting functionality.
1104  */
1105 contract TradeableERC721Token is ERC721Full, Ownable {
1106   using Strings for string;
1107 
1108   address proxyRegistryAddress;
1109   uint256 private _currentTokenId = 0;
1110 
1111   constructor(string memory _name, string memory _symbol, address _proxyRegistryAddress) ERC721Full(_name, _symbol) public {
1112     proxyRegistryAddress = _proxyRegistryAddress;
1113   }
1114 
1115   /**
1116     * @dev Mints a token to an address.
1117     * @param _to address of the future owner of the token
1118     */
1119   function mintTo(address _to) public onlyOwner {
1120     uint256 newTokenId = _getNextTokenId();
1121     _mint(_to, newTokenId);
1122     _incrementTokenId();
1123   }
1124 
1125    /**
1126     * @dev Mints a token to an address in batch.
1127     * @param _to  address of the future owner of the token
1128     * @param _count number of items to minted
1129     * @param _startID starting id of the token to be minted
1130     */
1131 
1132   function mintTokenBatch(address _to, uint256 _count, uint256 _startID) public onlyOwner {
1133     require(_count > 0,"count can't be zero");
1134         for (uint256 i = 0; i < _count; i++) {
1135             uint256 newTokenId = _getNextTokenId();
1136             _mint(_to, newTokenId);
1137             _incrementTokenId();
1138 
1139             string memory _uri = Strings.strConcat(
1140                 baseTokenURI(),
1141                 Strings.uint2str(_startID));
1142             _setTokenURI(newTokenId, _uri);
1143             _startID = _startID+1;
1144         }
1145   }
1146     
1147     /**
1148     * @dev Mints a token to an address with a tokenURI.
1149     * @param _to  address of the future owner of the token
1150     * @param _uri metadata link to be attached with nft
1151     */
1152   
1153   function mintWithTokenURI(address _to, string memory _uri) public onlyOwner {
1154     uint256 newTokenId = _getNextTokenId();
1155     _mint(_to, newTokenId);
1156     _incrementTokenId();
1157     _setTokenURI(newTokenId, _uri);
1158   }
1159   
1160     /**
1161      * @dev public function to set the token URI for a given token
1162      * Reverts if the token ID does not exist
1163      * @param tokenId uint256 ID of the token to set its URI
1164      * @param uri string URI to assign
1165      */
1166     function setTokenURI(uint256 tokenId, string memory uri) public onlyOwner {
1167         _setTokenURI(tokenId, uri);
1168     }
1169   /**
1170     * @dev calculates the next token ID based on value of _currentTokenId 
1171     * @return uint256 for the next token ID
1172     */
1173   function _getNextTokenId() private view returns (uint256) {
1174     return _currentTokenId.add(1);
1175   }
1176 
1177   /**
1178     * @dev increments the value of _currentTokenId 
1179     */
1180   function _incrementTokenId() private  {
1181     _currentTokenId++;
1182   }
1183 
1184   function baseTokenURI() public view returns (string memory) {
1185     return "";
1186   }
1187 // customizing tokenURI for TV so if have provided independent metadata of any NFT could be returned first
1188 
1189   function tokenURI(uint256 _tokenId) external view returns (string memory) {
1190       if(bytes(_tokenURIs[_tokenId]).length != 0){
1191           return _tokenURIs[_tokenId];
1192       }else{
1193           return Strings.strConcat(
1194         baseTokenURI(),
1195         Strings.uint2str(_tokenId)
1196     );
1197       }
1198     
1199   }
1200 
1201   /**
1202    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1203    */
1204   function isApprovedForAll(
1205     address owner,
1206     address operator
1207   )
1208     public
1209     view
1210     returns (bool)
1211   {
1212     // Whitelist OpenSea proxy contract for easy trading.
1213     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1214     if (address(proxyRegistry.proxies(owner)) == operator) {
1215         return true;
1216     }
1217 
1218     return super.isApprovedForAll(owner, operator);
1219   }
1220 }
1221 
1222 // File: contracts/OpenSeaAsset.sol
1223 
1224 pragma solidity ^0.5.2;
1225 
1226 
1227 
1228 /**
1229  * @title OpenSea Asset
1230  * OpenSea Asset - A contract for easily creating custom assets on OpenSea. 
1231  */
1232 contract OpenSeaAsset is TradeableERC721Token {
1233   string private _baseTokenURI;
1234 
1235   constructor(
1236     string memory _name,
1237     string memory _symbol,
1238     address _proxyRegistryAddress,
1239     string memory baseURI
1240   ) TradeableERC721Token(_name, _symbol, _proxyRegistryAddress) public {
1241     _baseTokenURI = baseURI;
1242   }
1243 
1244   function openSeaVersion() public pure returns (string memory) {
1245     return "1.2.0";
1246   }
1247 
1248   function baseTokenURI() public view returns (string memory) {
1249     return _baseTokenURI;
1250   }
1251 
1252   function setBaseTokenURI(string memory uri) public onlyOwner {
1253     _baseTokenURI = uri;
1254   }
1255 }