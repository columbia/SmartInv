1 pragma solidity ^0.5.6;
2 
3 /**
4  * @title IERC165
5  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
6  */
7 interface IERC165 {
8     /**
9      * @notice Query if a contract implements an interface
10      * @param interfaceId The interface identifier, as specified in ERC-165
11      * @dev Interface identification is specified in ERC-165. This function
12      * uses less than 30,000 gas.
13      */
14     function supportsInterface(bytes4 interfaceId) external view returns (bool);
15 }
16 
17 /**
18  * @title ERC721 Non-Fungible Token Standard basic interface
19  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
20  */
21 contract IERC721 is IERC165 {
22     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
23     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
24     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
25 
26     function balanceOf(address owner) public view returns (uint256 balance);
27     function ownerOf(uint256 tokenId) public view returns (address owner);
28 
29     function approve(address to, uint256 tokenId) public;
30     function getApproved(uint256 tokenId) public view returns (address operator);
31 
32     function setApprovalForAll(address operator, bool _approved) public;
33     function isApprovedForAll(address owner, address operator) public view returns (bool);
34 
35     function transferFrom(address from, address to, uint256 tokenId) public;
36     function safeTransferFrom(address from, address to, uint256 tokenId) public;
37 
38     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
39 }
40 
41 /**
42  * @title ERC721 token receiver interface
43  * @dev Interface for any contract that wants to support safeTransfers
44  * from ERC721 asset contracts.
45  */
46 contract IERC721Receiver {
47     /**
48      * @notice Handle the receipt of an NFT
49      * @dev The ERC721 smart contract calls this function on the recipient
50      * after a `safeTransfer`. This function MUST return the function selector,
51      * otherwise the caller will revert the transaction. The selector to be
52      * returned can be obtained as `this.onERC721Received.selector`. This
53      * function MAY throw to revert and reject the transfer.
54      * Note: the ERC721 contract address is always the message sender.
55      * @param operator The address which called `safeTransferFrom` function
56      * @param from The address which previously owned the token
57      * @param tokenId The NFT identifier which is being transferred
58      * @param data Additional data with no specified format
59      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
60      */
61     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4);
62 }
63 
64 library Strings {
65     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
66         if (_i == 0) {
67             return "0";
68         }
69         uint j = _i;
70         uint len;
71         while (j != 0) {
72             len++;
73             j /= 10;
74         }
75         bytes memory bstr = new bytes(len);
76         uint k = len - 1;
77         while (_i != 0) {
78             bstr[k--] = byte(uint8(48 + _i % 10));
79             _i /= 10;
80         }
81         return string(bstr);
82     }
83     
84     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
85         return strConcat(_a, _b, "", "", "");
86     }
87     
88     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
89         bytes memory _ba = bytes(_a);
90         bytes memory _bb = bytes(_b);
91         bytes memory _bc = bytes(_c);
92         bytes memory _bd = bytes(_d);
93         bytes memory _be = bytes(_e);
94         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
95         bytes memory babcde = bytes(abcde);
96         uint k = 0;
97         uint i = 0;
98         for (i = 0; i < _ba.length; i++) {
99             babcde[k++] = _ba[i];
100         }
101         for (i = 0; i < _bb.length; i++) {
102             babcde[k++] = _bb[i];
103         }
104         for (i = 0; i < _bc.length; i++) {
105             babcde[k++] = _bc[i];
106         }
107         for (i = 0; i < _bd.length; i++) {
108             babcde[k++] = _bd[i];
109         }
110         for (i = 0; i < _be.length; i++) {
111             babcde[k++] = _be[i];
112         }
113         return string(babcde);
114     }
115 }
116 /**
117  * @title SafeMath
118  * @dev Unsigned math operations with safety checks that revert on error
119  */
120 library SafeMath {
121     /**
122     * @dev Multiplies two unsigned integers, reverts on overflow.
123     */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
126         // benefit is lost if 'b' is also tested.
127         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
128         if (a == 0) {
129             return 0;
130         }
131 
132         uint256 c = a * b;
133         require(c / a == b);
134 
135         return c;
136     }
137 
138     /**
139     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
140     */
141     function div(uint256 a, uint256 b) internal pure returns (uint256) {
142         // Solidity only automatically asserts when dividing by 0
143         require(b > 0);
144         uint256 c = a / b;
145         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147         return c;
148     }
149 
150     /**
151     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
152     */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         require(b <= a);
155         uint256 c = a - b;
156 
157         return c;
158     }
159 
160     /**
161     * @dev Adds two unsigned integers, reverts on overflow.
162     */
163     function add(uint256 a, uint256 b) internal pure returns (uint256) {
164         uint256 c = a + b;
165         require(c >= a);
166 
167         return c;
168     }
169 
170     /**
171     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
172     * reverts when dividing by zero.
173     */
174     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175         require(b != 0);
176         return a % b;
177     }
178 }
179 
180 /**
181  * Utility library of inline functions on addresses
182  */
183 library Address {
184     /**
185      * Returns whether the target address is a contract
186      * @dev This function will return false if invoked during the constructor of a contract,
187      * as the code is not actually created until after the constructor finishes.
188      * @param account address of the account to check
189      * @return whether the target address is a contract
190      */
191     function isContract(address account) internal view returns (bool) {
192         uint256 size;
193         // XXX Currently there is no better way to check if there is a contract in an address
194         // than to check the size of the code at that address.
195         // See https://ethereum.stackexchange.com/a/14016/36603
196         // for more details about how this works.
197         // TODO Check this again before the Serenity release, because all addresses will be
198         // contracts then.
199         // solhint-disable-next-line no-inline-assembly
200         assembly { size := extcodesize(account) }
201         return size > 0;
202     }
203 }
204 
205 /**
206  * @title ERC165
207  * @author Matt Condon (@shrugs)
208  * @dev Implements ERC165 using a lookup table.
209  */
210 contract ERC165 is IERC165 {
211     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
212     /**
213      * 0x01ffc9a7 ===
214      *     bytes4(keccak256('supportsInterface(bytes4)'))
215      */
216 
217     /**
218      * @dev a mapping of interface id to whether or not it's supported
219      */
220     mapping(bytes4 => bool) private _supportedInterfaces;
221 
222     /**
223      * @dev A contract implementing SupportsInterfaceWithLookup
224      * implement ERC165 itself
225      */
226     constructor () internal {
227         _registerInterface(_INTERFACE_ID_ERC165);
228     }
229 
230     /**
231      * @dev implement supportsInterface(bytes4) using a lookup table
232      */
233     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
234         return _supportedInterfaces[interfaceId];
235     }
236 
237     /**
238      * @dev internal method for registering an interface
239      */
240     function _registerInterface(bytes4 interfaceId) internal {
241         require(interfaceId != 0xffffffff);
242         _supportedInterfaces[interfaceId] = true;
243     }
244 }
245 
246 /**
247  * @title ERC721 Non-Fungible Token Standard basic implementation
248  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
249  */
250 contract ERC721 is ERC165, IERC721 {
251     using SafeMath for uint256;
252     using Address for address;
253 
254     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
255     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
256     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
257 
258     // Mapping from token ID to owner
259     mapping (uint256 => address) private _tokenOwner;
260 
261     // Mapping from token ID to approved address
262     mapping (uint256 => address) private _tokenApprovals;
263 
264     // Mapping from owner to number of owned token
265     mapping (address => uint256) private _ownedTokensCount;
266 
267     // Mapping from owner to operator approvals
268     mapping (address => mapping (address => bool)) private _operatorApprovals;
269 
270     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
271     /*
272      * 0x80ac58cd ===
273      *     bytes4(keccak256('balanceOf(address)')) ^
274      *     bytes4(keccak256('ownerOf(uint256)')) ^
275      *     bytes4(keccak256('approve(address,uint256)')) ^
276      *     bytes4(keccak256('getApproved(uint256)')) ^
277      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
278      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
279      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
280      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
281      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
282      */
283 
284     constructor () public {
285         // register the supported interfaces to conform to ERC721 via ERC165
286         _registerInterface(_INTERFACE_ID_ERC721);
287     }
288 
289     /**
290      * @dev Gets the balance of the specified address
291      * @param owner address to query the balance of
292      * @return uint256 representing the amount owned by the passed address
293      */
294     function balanceOf(address owner) public view returns (uint256) {
295         require(owner != address(0));
296         return _ownedTokensCount[owner];
297     }
298 
299     /**
300      * @dev Gets the owner of the specified token ID
301      * @param tokenId uint256 ID of the token to query the owner of
302      * @return owner address currently marked as the owner of the given token ID
303      */
304     function ownerOf(uint256 tokenId) public view returns (address) {
305         address owner = _tokenOwner[tokenId];
306         require(owner != address(0));
307         return owner;
308     }
309 
310     /**
311      * @dev Approves another address to transfer the given token ID
312      * The zero address indicates there is no approved address.
313      * There can only be one approved address per token at a given time.
314      * Can only be called by the token owner or an approved operator.
315      * @param to address to be approved for the given token ID
316      * @param tokenId uint256 ID of the token to be approved
317      */
318     function approve(address to, uint256 tokenId) public {
319         address owner = ownerOf(tokenId);
320         require(to != owner);
321         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
322 
323         _tokenApprovals[tokenId] = to;
324         emit Approval(owner, to, tokenId);
325     }
326 
327     /**
328      * @dev Gets the approved address for a token ID, or zero if no address set
329      * Reverts if the token ID does not exist.
330      * @param tokenId uint256 ID of the token to query the approval of
331      * @return address currently approved for the given token ID
332      */
333     function getApproved(uint256 tokenId) public view returns (address) {
334         require(_exists(tokenId));
335         return _tokenApprovals[tokenId];
336     }
337 
338     /**
339      * @dev Sets or unsets the approval of a given operator
340      * An operator is allowed to transfer all tokens of the sender on their behalf
341      * @param to operator address to set the approval
342      * @param approved representing the status of the approval to be set
343      */
344     function setApprovalForAll(address to, bool approved) public {
345         require(to != msg.sender);
346         _operatorApprovals[msg.sender][to] = approved;
347         emit ApprovalForAll(msg.sender, to, approved);
348     }
349 
350     /**
351      * @dev Tells whether an operator is approved by a given owner
352      * @param owner owner address which you want to query the approval of
353      * @param operator operator address which you want to query the approval of
354      * @return bool whether the given operator is approved by the given owner
355      */
356     function isApprovedForAll(address owner, address operator) public view returns (bool) {
357         return _operatorApprovals[owner][operator];
358     }
359 
360     /**
361      * @dev Transfers the ownership of a given token ID to another address
362      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
363      * Requires the msg sender to be the owner, approved, or operator
364      * @param from current owner of the token
365      * @param to address to receive the ownership of the given token ID
366      * @param tokenId uint256 ID of the token to be transferred
367     */
368     function transferFrom(address from, address to, uint256 tokenId) public {
369         require(_isApprovedOrOwner(msg.sender, tokenId));
370 
371         _transferFrom(from, to, tokenId);
372     }
373 
374     /**
375      * @dev Safely transfers the ownership of a given token ID to another address
376      * If the target address is a contract, it must implement `onERC721Received`,
377      * which is called upon a safe transfer, and return the magic value
378      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
379      * the transfer is reverted.
380      *
381      * Requires the msg sender to be the owner, approved, or operator
382      * @param from current owner of the token
383      * @param to address to receive the ownership of the given token ID
384      * @param tokenId uint256 ID of the token to be transferred
385     */
386     function safeTransferFrom(address from, address to, uint256 tokenId) public {
387         safeTransferFrom(from, to, tokenId, "");
388     }
389 
390     /**
391      * @dev Safely transfers the ownership of a given token ID to another address
392      * If the target address is a contract, it must implement `onERC721Received`,
393      * which is called upon a safe transfer, and return the magic value
394      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
395      * the transfer is reverted.
396      * Requires the msg sender to be the owner, approved, or operator
397      * @param from current owner of the token
398      * @param to address to receive the ownership of the given token ID
399      * @param tokenId uint256 ID of the token to be transferred
400      * @param _data bytes data to send along with a safe transfer check
401      */
402     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
403         transferFrom(from, to, tokenId);
404         require(_checkOnERC721Received(from, to, tokenId, _data));
405     }
406 
407     /**
408      * @dev Returns whether the specified token exists
409      * @param tokenId uint256 ID of the token to query the existence of
410      * @return whether the token exists
411      */
412     function _exists(uint256 tokenId) internal view returns (bool) {
413         address owner = _tokenOwner[tokenId];
414         return owner != address(0);
415     }
416 
417     /**
418      * @dev Returns whether the given spender can transfer a given token ID
419      * @param spender address of the spender to query
420      * @param tokenId uint256 ID of the token to be transferred
421      * @return bool whether the msg.sender is approved for the given token ID,
422      *    is an operator of the owner, or is the owner of the token
423      */
424     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
425         address owner = ownerOf(tokenId);
426         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
427     }
428 
429     /**
430      * @dev Internal function to mint a new token
431      * Reverts if the given token ID already exists
432      * @param to The address that will own the minted token
433      * @param tokenId uint256 ID of the token to be minted
434      */
435     function _mint(address to, uint256 tokenId) internal {
436         require(to != address(0));
437         require(!_exists(tokenId));
438 
439         _tokenOwner[tokenId] = to;
440         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
441 
442         emit Transfer(address(0), to, tokenId);
443     }
444 
445     /**
446      * @dev Internal function to burn a specific token
447      * Reverts if the token does not exist
448      * Deprecated, use _burn(uint256) instead.
449      * @param owner owner of the token to burn
450      * @param tokenId uint256 ID of the token being burned
451      */
452     function _burn(address owner, uint256 tokenId) internal {
453         require(ownerOf(tokenId) == owner);
454 
455         _clearApproval(tokenId);
456 
457         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
458         _tokenOwner[tokenId] = address(0);
459 
460         emit Transfer(owner, address(0), tokenId);
461     }
462 
463     /**
464      * @dev Internal function to burn a specific token
465      * Reverts if the token does not exist
466      * @param tokenId uint256 ID of the token being burned
467      */
468     function _burn(uint256 tokenId) internal {
469         _burn(ownerOf(tokenId), tokenId);
470     }
471 
472     /**
473      * @dev Internal function to transfer ownership of a given token ID to another address.
474      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
475      * @param from current owner of the token
476      * @param to address to receive the ownership of the given token ID
477      * @param tokenId uint256 ID of the token to be transferred
478     */
479     function _transferFrom(address from, address to, uint256 tokenId) internal {
480         require(ownerOf(tokenId) == from);
481         require(to != address(0));
482 
483         _clearApproval(tokenId);
484 
485         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
486         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
487 
488         _tokenOwner[tokenId] = to;
489 
490         emit Transfer(from, to, tokenId);
491     }
492 
493     /**
494      * @dev Internal function to invoke `onERC721Received` on a target address
495      * The call is not executed if the target address is not a contract
496      * @param from address representing the previous owner of the given token ID
497      * @param to target address that will receive the tokens
498      * @param tokenId uint256 ID of the token to be transferred
499      * @param _data bytes optional data to send along with the call
500      * @return whether the call correctly returned the expected magic value
501      */
502     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
503         internal returns (bool)
504     {
505         if (!to.isContract()) {
506             return true;
507         }
508 
509         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
510         return (retval == _ERC721_RECEIVED);
511     }
512 
513     /**
514      * @dev Private function to clear current approval of a given token ID
515      * @param tokenId uint256 ID of the token to be transferred
516      */
517     function _clearApproval(uint256 tokenId) private {
518         if (_tokenApprovals[tokenId] != address(0)) {
519             _tokenApprovals[tokenId] = address(0);
520         }
521     }
522 }
523 
524 /**
525  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
526  * @dev See https://eips.ethereum.org/EIPS/eip-721
527  */
528 contract IERC721Enumerable is IERC721 {
529     function totalSupply() public view returns (uint256);
530     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
531 
532     function tokenByIndex(uint256 index) public view returns (uint256);
533 }
534 /**
535  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
536  * @dev See https://eips.ethereum.org/EIPS/eip-721
537  */
538 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
539     // Mapping from owner to list of owned token IDs
540     mapping(address => uint256[]) private _ownedTokens;
541 
542     // Mapping from token ID to index of the owner tokens list
543     mapping(uint256 => uint256) private _ownedTokensIndex;
544 
545     // Array with all token ids, used for enumeration
546     uint256[] private _allTokens;
547 
548     // Mapping from token id to position in the allTokens array
549     mapping(uint256 => uint256) private _allTokensIndex;
550 
551     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
552     /*
553      * 0x780e9d63 ===
554      *     bytes4(keccak256('totalSupply()')) ^
555      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
556      *     bytes4(keccak256('tokenByIndex(uint256)'))
557      */
558 
559     /**
560      * @dev Constructor function
561      */
562     constructor () public {
563         // register the supported interface to conform to ERC721Enumerable via ERC165
564         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
565     }
566 
567     /**
568      * @dev Gets the token ID at a given index of the tokens list of the requested owner
569      * @param owner address owning the tokens list to be accessed
570      * @param index uint256 representing the index to be accessed of the requested tokens list
571      * @return uint256 token ID at the given index of the tokens list owned by the requested address
572      */
573     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
574         require(index < balanceOf(owner));
575         return _ownedTokens[owner][index];
576     }
577 
578     /**
579      * @dev Gets the total amount of tokens stored by the contract
580      * @return uint256 representing the total amount of tokens
581      */
582     function totalSupply() public view returns (uint256) {
583         return _allTokens.length;
584     }
585 
586     /**
587      * @dev Gets the token ID at a given index of all the tokens in this contract
588      * Reverts if the index is greater or equal to the total number of tokens
589      * @param index uint256 representing the index to be accessed of the tokens list
590      * @return uint256 token ID at the given index of the tokens list
591      */
592     function tokenByIndex(uint256 index) public view returns (uint256) {
593         require(index < totalSupply());
594         return _allTokens[index];
595     }
596 
597     /**
598      * @dev Internal function to transfer ownership of a given token ID to another address.
599      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
600      * @param from current owner of the token
601      * @param to address to receive the ownership of the given token ID
602      * @param tokenId uint256 ID of the token to be transferred
603      */
604     function _transferFrom(address from, address to, uint256 tokenId) internal {
605         super._transferFrom(from, to, tokenId);
606 
607         _removeTokenFromOwnerEnumeration(from, tokenId);
608 
609         _addTokenToOwnerEnumeration(to, tokenId);
610     }
611 
612     /**
613      * @dev Internal function to mint a new token
614      * Reverts if the given token ID already exists
615      * @param to address the beneficiary that will own the minted token
616      * @param tokenId uint256 ID of the token to be minted
617      */
618     function _mint(address to, uint256 tokenId) internal {
619         super._mint(to, tokenId);
620 
621         _addTokenToOwnerEnumeration(to, tokenId);
622 
623         _addTokenToAllTokensEnumeration(tokenId);
624     }
625 
626     /**
627      * @dev Gets the list of token IDs of the requested owner
628      * @param owner address owning the tokens
629      * @return uint256[] List of token IDs owned by the requested address
630      */
631     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
632         return _ownedTokens[owner];
633     }
634 
635     /**
636      * @dev Private function to add a token to this extension's ownership-tracking data structures.
637      * @param to address representing the new owner of the given token ID
638      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
639      */
640     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
641         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
642         _ownedTokens[to].push(tokenId);
643     }
644 
645     /**
646      * @dev Private function to add a token to this extension's token tracking data structures.
647      * @param tokenId uint256 ID of the token to be added to the tokens list
648      */
649     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
650         _allTokensIndex[tokenId] = _allTokens.length;
651         _allTokens.push(tokenId);
652     }
653 
654     /**
655      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
656      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
657      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
658      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
659      * @param from address representing the previous owner of the given token ID
660      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
661      */
662     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
663         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
664         // then delete the last slot (swap and pop).
665 
666         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
667         uint256 tokenIndex = _ownedTokensIndex[tokenId];
668 
669         // When the token to delete is the last token, the swap operation is unnecessary
670         if (tokenIndex != lastTokenIndex) {
671             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
672 
673             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
674             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
675         }
676 
677         // This also deletes the contents at the last position of the array
678         _ownedTokens[from].length--;
679 
680         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
681         // lastTokenId, or just over the end of the array if the token was the last one).
682     }
683 
684     /**
685      * @dev Private function to remove a token from this extension's token tracking data structures.
686      * This has O(1) time complexity, but alters the order of the _allTokens array.
687      * @param tokenId uint256 ID of the token to be removed from the tokens list
688      */
689     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
690         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
691         // then delete the last slot (swap and pop).
692 
693         uint256 lastTokenIndex = _allTokens.length.sub(1);
694         uint256 tokenIndex = _allTokensIndex[tokenId];
695 
696         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
697         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
698         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
699         uint256 lastTokenId = _allTokens[lastTokenIndex];
700 
701         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
702         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
703 
704         // This also deletes the contents at the last position of the array
705         _allTokens.length--;
706         _allTokensIndex[tokenId] = 0;
707     }
708 }
709 
710 /**
711  * @title Roles
712  * @dev Library for managing addresses assigned to a Role.
713  */
714 library Roles {
715     struct Role {
716         mapping (address => bool) bearer;
717     }
718 
719     /**
720      * @dev give an account access to this role
721      */
722     function add(Role storage role, address account) internal {
723         require(account != address(0));
724         require(!has(role, account));
725 
726         role.bearer[account] = true;
727     }
728 
729     /**
730      * @dev remove an account's access to this role
731      */
732     function remove(Role storage role, address account) internal {
733         require(account != address(0));
734         require(has(role, account));
735 
736         role.bearer[account] = false;
737     }
738 
739     /**
740      * @dev check if an account has this role
741      * @return bool
742      */
743     function has(Role storage role, address account) internal view returns (bool) {
744         require(account != address(0));
745         return role.bearer[account];
746     }
747 }
748 
749 contract MinterRole {
750     using Roles for Roles.Role;
751 
752     event MinterAdded(address indexed account);
753     event MinterRemoved(address indexed account);
754 
755     Roles.Role private _minters;
756 
757     constructor () internal {
758         _addMinter(msg.sender);
759     }
760 
761     modifier onlyMinter() {
762         require(isMinter(msg.sender));
763         _;
764     }
765 
766     function isMinter(address account) public view returns (bool) {
767         return _minters.has(account);
768     }
769 
770     function addMinter(address account) public onlyMinter {
771         _addMinter(account);
772     }
773 
774     function renounceMinter() public {
775         _removeMinter(msg.sender);
776     }
777 
778     function _addMinter(address account) internal {
779         _minters.add(account);
780         emit MinterAdded(account);
781     }
782 
783     function _removeMinter(address account) internal {
784         _minters.remove(account);
785         emit MinterRemoved(account);
786     }
787 
788 }
789 
790 /**
791  * @title Helps contracts guard against reentrancy attacks.
792  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
793  * @dev If you mark a function `nonReentrant`, you should also
794  * mark it `external`.
795  */
796 contract ReentrancyGuard {
797     /// @dev counter to allow mutex lock with only one SSTORE operation
798     uint256 private _guardCounter;
799 
800     constructor () internal {
801         // The counter starts at one to prevent changing it from zero to a non-zero
802         // value, which is a more expensive operation.
803         _guardCounter = 1;
804     }
805 
806     /**
807      * @dev Prevents a contract from calling itself, directly or indirectly.
808      * Calling a `nonReentrant` function from another `nonReentrant`
809      * function is not supported. It is possible to prevent this from happening
810      * by making the `nonReentrant` function external, and make it call a
811      * `private` function that does the actual work.
812      */
813     modifier nonReentrant() {
814         _guardCounter += 1;
815         uint256 localCounter = _guardCounter;
816         _;
817         require(localCounter == _guardCounter);
818     }
819 }
820 
821 contract IERC721Metadata is IERC721 {
822     function name() external view returns (string memory);
823     function symbol() external view returns (string memory);
824     function tokenURI(uint256 tokenId) external view returns (string memory);
825 }
826 
827 contract ProductInventory is MinterRole {
828     using SafeMath for uint256;
829     using Address for address;
830     
831     event ProductCreated(
832         uint256 id,
833         uint256 price,
834         uint256 activationPrice,
835         uint256 available,
836         uint256 supply,
837         uint256 interval,
838         bool minterOnly
839     );
840     event ProductAvailabilityChanged(uint256 productId, uint256 available);
841     event ProductPriceChanged(uint256 productId, uint256 price);
842 
843     // All product ids in existence
844     uint256[] public allProductIds;
845 
846     // Map from product id to Product
847     mapping (uint256 => Product) public products;
848 
849     struct Product {
850         uint256 id;
851         uint256 price;
852         uint256 activationPrice;
853         uint256 available;
854         uint256 supply;
855         uint256 sold;
856         uint256 interval;
857         bool minterOnly;
858     }
859 
860     function _productExists(uint256 _productId) internal view returns (bool) {
861         return products[_productId].id != 0;
862     }
863 
864     function _createProduct(
865         uint256 _productId,
866         uint256 _price,
867         uint256 _activationPrice,
868         uint256 _initialAvailable,
869         uint256 _supply,
870         uint256 _interval,
871         bool _minterOnly
872     )
873     internal
874     {
875         require(_productId != 0);
876         require(!_productExists(_productId));
877         require(_initialAvailable <= _supply);
878 
879         Product memory _product = Product({
880             id: _productId,
881             price: _price,
882             activationPrice: _activationPrice,
883             available: _initialAvailable,
884             supply: _supply,
885             sold: 0,
886             interval: _interval,
887             minterOnly: _minterOnly
888         });
889 
890         products[_productId] = _product;
891         allProductIds.push(_productId);
892 
893         emit ProductCreated(
894             _product.id,
895             _product.price,
896             _product.activationPrice,
897             _product.available,
898             _product.supply,
899             _product.interval,
900             _product.minterOnly
901         );
902     }
903 
904     function _incrementAvailability(
905         uint256 _productId,
906         uint256 _increment)
907         internal
908     {
909         require(_productExists(_productId));
910         uint256 newAvailabilityLevel = products[_productId].available.add(_increment);
911         //if supply isn't 0 (unlimited), we check if incrementing puts above supply
912         if(products[_productId].supply != 0) {
913             require(products[_productId].sold.add(newAvailabilityLevel) <= products[_productId].supply);
914         }
915         products[_productId].available = newAvailabilityLevel;
916     }
917 
918     function _setAvailability(uint256 _productId, uint256 _availability) internal
919     {
920         require(_productExists(_productId));
921         require(_availability >= 0);
922         products[_productId].available = _availability;
923     }
924 
925     function _setPrice(uint256 _productId, uint256 _price) internal
926     {
927         require(_productExists(_productId));
928         products[_productId].price = _price;
929     }
930 
931     function _setMinterOnly(uint256 _productId, bool _isMinterOnly) internal
932     {
933         require(_productExists(_productId));
934         products[_productId].minterOnly = _isMinterOnly;
935     }
936 
937     function _purchaseProduct(uint256 _productId) internal {
938         require(_productExists(_productId));
939         require(products[_productId].available > 0);
940         require(products[_productId].available.sub(1) >= 0);
941         products[_productId].available = products[_productId].available.sub(1);
942         products[_productId].sold = products[_productId].sold.add(1);
943     }
944 
945     /*** public onlyMinter ***/
946 
947     /**
948     * @notice Creates a Product
949     * @param _productId - product id to use (immutable)
950     * @param _price - price of product
951     * @param _activationPrice - price of activation
952     * @param _initialAvailable - the initial amount available for sale
953     * @param _supply - total supply - `0` means unlimited (immutable)
954     * @param _interval - interval - period of time, in seconds, users can subscribe 
955     * for. If set to 0, it's not a subscription product (immutable)
956     * @param _minterOnly - if true, purchase is only available to minter
957     */
958     function createProduct(
959         uint256 _productId,
960         uint256 _price,
961         uint256 _activationPrice,
962         uint256 _initialAvailable,
963         uint256 _supply,
964         uint256 _interval,
965         bool _minterOnly
966     )
967     external
968     onlyMinter
969     {
970         _createProduct(
971             _productId,
972             _price,
973             _activationPrice,
974             _initialAvailable,
975             _supply,
976             _interval,
977             _minterOnly);
978     }
979 
980     /**
981     * @notice incrementAvailability - increments the 
982     * @param _productId - product id
983     * @param _increment - amount to increment
984     */
985     function incrementAvailability(
986         uint256 _productId,
987         uint256 _increment)
988     external
989     onlyMinter
990     {
991         _incrementAvailability(_productId, _increment);
992         emit ProductAvailabilityChanged(_productId, products[_productId].available);
993     }
994 
995     /**
996     * @notice Increments the inventory of a product
997     * @param _productId - the product id
998     * @param _amount - the amount to set
999     */
1000     function setAvailability(
1001         uint256 _productId,
1002         uint256 _amount)
1003     external
1004     onlyMinter
1005     {
1006         _setAvailability(_productId, _amount);
1007         emit ProductAvailabilityChanged(_productId, products[_productId].available);
1008     }
1009 
1010     /**
1011     * @notice Sets the price of a product
1012     * @param _productId - the product id
1013     * @param _price - the product price
1014     */
1015     function setPrice(uint256 _productId, uint256 _price)
1016     external
1017     onlyMinter
1018     {
1019         _setPrice(_productId, _price);
1020         emit ProductPriceChanged(_productId, _price);
1021     }
1022 
1023     /**
1024     * @notice Sets the price of a product
1025     * @param _productId - the product id
1026     * @param _isMinterOnly - the product price
1027     */
1028     function setMinterOnly(uint256 _productId, bool _isMinterOnly)
1029     external
1030     onlyMinter
1031     {
1032         _setMinterOnly(_productId, _isMinterOnly);
1033     }
1034 
1035     /*** public onlyMinter ***/
1036 
1037     /**
1038     * @notice Total amount sold of a product
1039     * @param _productId - the product id
1040     */
1041     function totalSold(uint256 _productId) public view returns (uint256) {
1042         return products[_productId].sold;
1043     }
1044 
1045     /**
1046     * @notice Mintable permission of a product
1047     * @param _productId - the product id
1048     */
1049     function isMinterOnly(uint256 _productId) public view returns (bool) {
1050         return products[_productId].minterOnly;
1051     }
1052 
1053     /**
1054     * @notice Price of a product
1055     * @param _productId - the product id
1056     */
1057     function priceOf(uint256 _productId) public view returns (uint256) {
1058         return products[_productId].price;
1059     }
1060 
1061     /**
1062     * @notice Price of activation of a product
1063     * @param _productId - the product id
1064     */
1065     function priceOfActivation(uint256 _productId) public view returns (uint256) {
1066         return products[_productId].activationPrice;
1067     }
1068 
1069     /**
1070     * @notice Product info for a product
1071     * @param _productId - the product id
1072     */
1073     function productInfo(uint256 _productId)
1074     public
1075     view
1076     returns (uint256, uint256, uint256, uint256, uint256, bool)
1077     {
1078         return (
1079             products[_productId].price,
1080             products[_productId].activationPrice,
1081             products[_productId].available,
1082             products[_productId].supply,
1083             products[_productId].interval,
1084             products[_productId].minterOnly
1085         );
1086     }
1087 
1088   /**
1089   * @notice Get product ids
1090   */
1091     function getAllProductIds() public view returns (uint256[] memory) {
1092         return allProductIds;
1093     }
1094 }
1095 
1096 contract IERC721ProductKey is IERC721Enumerable, IERC721Metadata {
1097     function activate(uint256 _tokenId) public payable;
1098     function purchase(uint256 _productId, address _beneficiary) public payable returns (uint256);
1099     function setKeyAttributes(uint256 _keyId, uint256 _attributes) public;
1100     function keyInfo(uint256 _keyId) external view returns (uint256, uint256, uint256, uint256);
1101     function isKeyActive(uint256 _keyId) public view returns (bool);
1102     event KeyIssued(
1103         address indexed owner,
1104         address indexed purchaser,
1105         uint256 keyId,
1106         uint256 productId,
1107         uint256 attributes,
1108         uint256 issuedTime,
1109         uint256 expirationTime
1110     );
1111     event KeyActivated(
1112         address indexed owner,
1113         address indexed activator,
1114         uint256 keyId,
1115         uint256 productId,
1116         uint256 attributes,
1117         uint256 issuedTime,
1118         uint256 expirationTime
1119     );
1120 }
1121 
1122 contract ERC721ProductKey is IERC721ProductKey, ERC721Enumerable, ReentrancyGuard, ProductInventory {
1123     using SafeMath for uint256;
1124     using Address for address;
1125 
1126     // Token name
1127     string private _name;
1128     // Token symbol
1129     string private _symbol;
1130     // Base metadata URI symbol
1131     string private _baseMetadataURI;
1132     // Withdrawal wallet
1133     address payable private _withdrawalWallet;
1134 
1135     event KeyIssued(
1136         address indexed owner,
1137         address indexed purchaser,
1138         uint256 keyId,
1139         uint256 productId,
1140         uint256 attributes,
1141         uint256 issuedTime,
1142         uint256 expirationTime
1143     );
1144 
1145     event KeyActivated(
1146         address indexed owner,
1147         address indexed activator,
1148         uint256 keyId,
1149         uint256 productId,
1150         uint256 attributes,
1151         uint256 issuedTime,
1152         uint256 expirationTime
1153     );
1154 
1155     struct ProductKey {
1156         uint256 productId;
1157         uint256 attributes;
1158         uint256 issuedTime;
1159         uint256 expirationTime;
1160     }
1161     
1162     // Map from keyid to ProductKey
1163     mapping (uint256 => ProductKey) public productKeys;
1164 
1165     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1166     /*
1167      * 0x5b5e139f ===
1168      *     bytes4(keccak256('name()')) ^
1169      *     bytes4(keccak256('symbol()')) ^
1170      *     bytes4(keccak256('tokenURI(uint256)'))
1171      */
1172 
1173     /**
1174      * @dev Constructor function
1175      */
1176     constructor (string memory name, string memory symbol, string memory baseURI, address payable withdrawalWallet) public {
1177         _name = name;
1178         _symbol = symbol;
1179         _baseMetadataURI = baseURI;
1180         _withdrawalWallet = withdrawalWallet;
1181         // register the supported interfaces to conform to ERC721 via ERC165
1182         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1183     }
1184 
1185     /**
1186      * @dev Gets the token name
1187      * @return string representing the token name
1188      */
1189     function name() external view returns (string memory) {
1190         return _name;
1191     }
1192 
1193     /**
1194      * @notice Gets the token symbol
1195      * @return string representing the token symbol
1196      */
1197     function symbol() external view returns (string memory) {
1198         return _symbol;
1199     }
1200 
1201     /**
1202      * @return the address where funds are collected.
1203      */
1204     function withdrawalWallet() public view returns (address payable) {
1205         return _withdrawalWallet;
1206     }
1207 
1208     /**
1209      * @notice Sets a Base URI to be used for token URI
1210      * @param baseURI string of the base uri to set
1211      */
1212     function setTokenMetadataBaseURI(string calldata baseURI) external onlyMinter {
1213         _baseMetadataURI = baseURI;
1214     }
1215 
1216     /**
1217      * @notice Returns a URI for a given ID
1218      * Throws if the token ID does not exist. May return an empty string.
1219      * @param tokenId uint256 ID of the token to query
1220      */
1221     function tokenURI(uint256 tokenId) external view returns (string memory) {
1222         require(_exists(tokenId));
1223         return Strings.strConcat(
1224             _baseMetadataURI,
1225             Strings.uint2str(tokenId));
1226     }
1227     
1228     /**
1229      * @notice activates access key
1230      * Throws if not approved or owner or key already active
1231      * @param _keyId uint256 ID of the key to activate
1232      */
1233     function _activate(uint256 _keyId) internal {
1234         require(_isApprovedOrOwner(msg.sender, _keyId));
1235         require(!isKeyActive(_keyId));
1236         require(productKeys[_keyId].expirationTime == 0);
1237         uint256 productId = productKeys[_keyId].productId;
1238         //set expiration time which activates the productkey
1239         productKeys[_keyId].expirationTime = now.add(products[productId].interval);
1240         //emit key activated event
1241         emit KeyActivated(
1242             ownerOf(_keyId),
1243             msg.sender,
1244             _keyId,
1245             productId,
1246             productKeys[_keyId].attributes,
1247             productKeys[_keyId].issuedTime,
1248             productKeys[_keyId].expirationTime
1249         );
1250     }
1251 
1252     function _createKey(
1253         uint256 _productId,
1254         address _beneficiary
1255     )
1256     internal
1257     returns (uint)
1258     {
1259         ProductKey memory _productKey = ProductKey({
1260             productId: _productId,
1261             attributes: 0,
1262             issuedTime: now, 
1263             expirationTime: 0
1264         });
1265 
1266         uint256 newKeyId = totalSupply();
1267             
1268         productKeys[newKeyId] = _productKey;
1269         emit KeyIssued(
1270             _beneficiary,
1271             msg.sender,
1272             newKeyId,
1273             _productKey.productId,
1274             _productKey.attributes,
1275             _productKey.issuedTime,
1276             _productKey.expirationTime);
1277         _mint(_beneficiary, newKeyId);
1278         return newKeyId;
1279     }
1280 
1281     function _setKeyAttributes(uint256 _keyId, uint256 _attributes) internal
1282     {
1283         productKeys[_keyId].attributes = _attributes;
1284     }
1285 
1286     function _purchase(
1287         uint256 _productId,
1288         address _beneficiary)
1289     internal returns (uint)
1290     {
1291         _purchaseProduct(_productId);
1292         return _createKey(
1293             _productId,
1294             _beneficiary
1295         );
1296     }
1297 
1298     /** only minter **/
1299 
1300     function withdrawBalance() external onlyMinter {
1301         _withdrawalWallet.transfer(address(this).balance);
1302     }
1303 
1304     function minterOnlyPurchase(
1305         uint256 _productId,
1306         address _beneficiary
1307     )
1308     external
1309     onlyMinter
1310     returns (uint256)
1311     {
1312         return _purchase(
1313             _productId,
1314             _beneficiary
1315         );
1316     }
1317 
1318     function setKeyAttributes(
1319         uint256 _keyId,
1320         uint256 _attributes
1321     )
1322     public
1323     onlyMinter
1324     {
1325         return _setKeyAttributes(
1326             _keyId,
1327             _attributes
1328         );
1329     }
1330 
1331     /** anyone **/
1332 
1333     /**
1334     * @notice Get if productkey is active
1335     * @param _keyId the id of key
1336     */
1337     function isKeyActive(uint256 _keyId) public view returns (bool) {
1338         return productKeys[_keyId].expirationTime > now || products[productKeys[_keyId].productId].interval == 0;
1339     }
1340 
1341     /**
1342     * @notice Get a ProductKey's info
1343     * @param _keyId key id
1344     */
1345     function keyInfo(uint256 _keyId)
1346     external view returns (uint256, uint256, uint256, uint256)
1347     {
1348         return (productKeys[_keyId].productId,
1349             productKeys[_keyId].attributes,
1350             productKeys[_keyId].issuedTime,
1351             productKeys[_keyId].expirationTime
1352         );
1353     }
1354 
1355     /**
1356     * @notice purchase a product
1357     * @param _productId - product id to purchase
1358     * @param _beneficiary - the token receiving address
1359     */
1360     function purchase(
1361         uint256 _productId,
1362         address _beneficiary
1363     )
1364     public
1365     payable
1366     returns (uint256)
1367     {
1368         require(_productId != 0);
1369         require(_beneficiary != address(0));
1370         // No excess
1371         require(msg.value == priceOf(_productId));
1372         require(!isMinterOnly(_productId));
1373         return _purchase(
1374             _productId,
1375             _beneficiary
1376         );
1377     }
1378 
1379     /**
1380     * @notice activates token
1381     */
1382     function activate(
1383         uint256 _tokenId
1384     )
1385     public
1386     payable
1387     {
1388         require(ownerOf(_tokenId) != address(0));
1389         // no excess
1390         require(msg.value == priceOfActivation(_tokenId));
1391         _activate(_tokenId);
1392 
1393     }
1394 }