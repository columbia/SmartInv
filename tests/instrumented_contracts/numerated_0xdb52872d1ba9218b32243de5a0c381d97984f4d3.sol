1 pragma solidity ^0.5.0;
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
61     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
62     public returns (bytes4);
63 }
64 
65 /**
66  * @title SafeMath
67  * @dev Unsigned math operations with safety checks that revert on error
68  */
69 library SafeMath {
70     /**
71     * @dev Multiplies two unsigned integers, reverts on overflow.
72     */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b);
83 
84         return c;
85     }
86 
87     /**
88     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
89     */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         // Solidity only automatically asserts when dividing by 0
92         require(b > 0);
93         uint256 c = a / b;
94         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95 
96         return c;
97     }
98 
99     /**
100     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
101     */
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b <= a);
104         uint256 c = a - b;
105 
106         return c;
107     }
108 
109     /**
110     * @dev Adds two unsigned integers, reverts on overflow.
111     */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a);
115 
116         return c;
117     }
118 
119     /**
120     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
121     * reverts when dividing by zero.
122     */
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b != 0);
125         return a % b;
126     }
127 }
128 
129 /**
130  * Utility library of inline functions on addresses
131  */
132 library Address {
133     /**
134      * Returns whether the target address is a contract
135      * @dev This function will return false if invoked during the constructor of a contract,
136      * as the code is not actually created until after the constructor finishes.
137      * @param account address of the account to check
138      * @return whether the target address is a contract
139      */
140     function isContract(address account) internal view returns (bool) {
141         uint256 size;
142         // XXX Currently there is no better way to check if there is a contract in an address
143         // than to check the size of the code at that address.
144         // See https://ethereum.stackexchange.com/a/14016/36603
145         // for more details about how this works.
146         // TODO Check this again before the Serenity release, because all addresses will be
147         // contracts then.
148         // solhint-disable-next-line no-inline-assembly
149         assembly { size := extcodesize(account) }
150         return size > 0;
151     }
152 }
153 
154 /**
155  * @title ERC165
156  * @author Matt Condon (@shrugs)
157  * @dev Implements ERC165 using a lookup table.
158  */
159 contract ERC165 is IERC165 {
160     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
161     /**
162      * 0x01ffc9a7 ===
163      *     bytes4(keccak256('supportsInterface(bytes4)'))
164      */
165 
166     /**
167      * @dev a mapping of interface id to whether or not it's supported
168      */
169     mapping(bytes4 => bool) private _supportedInterfaces;
170 
171     /**
172      * @dev A contract implementing SupportsInterfaceWithLookup
173      * implement ERC165 itself
174      */
175     constructor () internal {
176         _registerInterface(_INTERFACE_ID_ERC165);
177     }
178 
179     /**
180      * @dev implement supportsInterface(bytes4) using a lookup table
181      */
182     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
183         return _supportedInterfaces[interfaceId];
184     }
185 
186     /**
187      * @dev internal method for registering an interface
188      */
189     function _registerInterface(bytes4 interfaceId) internal {
190         require(interfaceId != 0xffffffff);
191         _supportedInterfaces[interfaceId] = true;
192     }
193 }
194 
195 /**
196  * @title ERC721 Non-Fungible Token Standard basic implementation
197  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
198  */
199 contract ERC721 is ERC165, IERC721 {
200     using SafeMath for uint256;
201     using Address for address;
202 
203     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
204     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
205     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
206 
207     // Mapping from token ID to owner
208     mapping (uint256 => address) private _tokenOwner;
209 
210     // Mapping from token ID to approved address
211     mapping (uint256 => address) private _tokenApprovals;
212 
213     // Mapping from owner to number of owned token
214     mapping (address => uint256) private _ownedTokensCount;
215 
216     // Mapping from owner to operator approvals
217     mapping (address => mapping (address => bool)) private _operatorApprovals;
218 
219     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
220     /*
221      * 0x80ac58cd ===
222      *     bytes4(keccak256('balanceOf(address)')) ^
223      *     bytes4(keccak256('ownerOf(uint256)')) ^
224      *     bytes4(keccak256('approve(address,uint256)')) ^
225      *     bytes4(keccak256('getApproved(uint256)')) ^
226      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
227      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
228      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
229      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
230      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
231      */
232 
233     constructor () public {
234         // register the supported interfaces to conform to ERC721 via ERC165
235         _registerInterface(_INTERFACE_ID_ERC721);
236     }
237 
238     /**
239      * @dev Gets the balance of the specified address
240      * @param owner address to query the balance of
241      * @return uint256 representing the amount owned by the passed address
242      */
243     function balanceOf(address owner) public view returns (uint256) {
244         require(owner != address(0));
245         return _ownedTokensCount[owner];
246     }
247 
248     /**
249      * @dev Gets the owner of the specified token ID
250      * @param tokenId uint256 ID of the token to query the owner of
251      * @return owner address currently marked as the owner of the given token ID
252      */
253     function ownerOf(uint256 tokenId) public view returns (address) {
254         address owner = _tokenOwner[tokenId];
255         require(owner != address(0));
256         return owner;
257     }
258 
259     /**
260      * @dev Approves another address to transfer the given token ID
261      * The zero address indicates there is no approved address.
262      * There can only be one approved address per token at a given time.
263      * Can only be called by the token owner or an approved operator.
264      * @param to address to be approved for the given token ID
265      * @param tokenId uint256 ID of the token to be approved
266      */
267     function approve(address to, uint256 tokenId) public {
268         address owner = ownerOf(tokenId);
269         require(to != owner);
270         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
271 
272         _tokenApprovals[tokenId] = to;
273         emit Approval(owner, to, tokenId);
274     }
275 
276     /**
277      * @dev Gets the approved address for a token ID, or zero if no address set
278      * Reverts if the token ID does not exist.
279      * @param tokenId uint256 ID of the token to query the approval of
280      * @return address currently approved for the given token ID
281      */
282     function getApproved(uint256 tokenId) public view returns (address) {
283         require(_exists(tokenId));
284         return _tokenApprovals[tokenId];
285     }
286 
287     /**
288      * @dev Sets or unsets the approval of a given operator
289      * An operator is allowed to transfer all tokens of the sender on their behalf
290      * @param to operator address to set the approval
291      * @param approved representing the status of the approval to be set
292      */
293     function setApprovalForAll(address to, bool approved) public {
294         require(to != msg.sender);
295         _operatorApprovals[msg.sender][to] = approved;
296         emit ApprovalForAll(msg.sender, to, approved);
297     }
298 
299     /**
300      * @dev Tells whether an operator is approved by a given owner
301      * @param owner owner address which you want to query the approval of
302      * @param operator operator address which you want to query the approval of
303      * @return bool whether the given operator is approved by the given owner
304      */
305     function isApprovedForAll(address owner, address operator) public view returns (bool) {
306         return _operatorApprovals[owner][operator];
307     }
308 
309     /**
310      * @dev Transfers the ownership of a given token ID to another address
311      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
312      * Requires the msg sender to be the owner, approved, or operator
313      * @param from current owner of the token
314      * @param to address to receive the ownership of the given token ID
315      * @param tokenId uint256 ID of the token to be transferred
316     */
317     function transferFrom(address from, address to, uint256 tokenId) public {
318         require(_isApprovedOrOwner(msg.sender, tokenId));
319 
320         _transferFrom(from, to, tokenId);
321     }
322 
323     /**
324      * @dev Safely transfers the ownership of a given token ID to another address
325      * If the target address is a contract, it must implement `onERC721Received`,
326      * which is called upon a safe transfer, and return the magic value
327      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
328      * the transfer is reverted.
329      *
330      * Requires the msg sender to be the owner, approved, or operator
331      * @param from current owner of the token
332      * @param to address to receive the ownership of the given token ID
333      * @param tokenId uint256 ID of the token to be transferred
334     */
335     function safeTransferFrom(address from, address to, uint256 tokenId) public {
336         safeTransferFrom(from, to, tokenId, "");
337     }
338 
339     /**
340      * @dev Safely transfers the ownership of a given token ID to another address
341      * If the target address is a contract, it must implement `onERC721Received`,
342      * which is called upon a safe transfer, and return the magic value
343      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
344      * the transfer is reverted.
345      * Requires the msg sender to be the owner, approved, or operator
346      * @param from current owner of the token
347      * @param to address to receive the ownership of the given token ID
348      * @param tokenId uint256 ID of the token to be transferred
349      * @param _data bytes data to send along with a safe transfer check
350      */
351     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
352         transferFrom(from, to, tokenId);
353         require(_checkOnERC721Received(from, to, tokenId, _data));
354     }
355 
356     /**
357      * @dev Returns whether the specified token exists
358      * @param tokenId uint256 ID of the token to query the existence of
359      * @return whether the token exists
360      */
361     function _exists(uint256 tokenId) internal view returns (bool) {
362         address owner = _tokenOwner[tokenId];
363         return owner != address(0);
364     }
365 
366     /**
367      * @dev Returns whether the given spender can transfer a given token ID
368      * @param spender address of the spender to query
369      * @param tokenId uint256 ID of the token to be transferred
370      * @return bool whether the msg.sender is approved for the given token ID,
371      *    is an operator of the owner, or is the owner of the token
372      */
373     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
374         address owner = ownerOf(tokenId);
375         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
376     }
377 
378     /**
379      * @dev Internal function to mint a new token
380      * Reverts if the given token ID already exists
381      * @param to The address that will own the minted token
382      * @param tokenId uint256 ID of the token to be minted
383      */
384     function _mint(address to, uint256 tokenId) internal {
385         require(to != address(0));
386         require(!_exists(tokenId));
387 
388         _tokenOwner[tokenId] = to;
389         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
390 
391         emit Transfer(msg.sender, to, tokenId);
392     }
393 
394     /**
395      * @dev Internal function to burn a specific token
396      * Reverts if the token does not exist
397      * Deprecated, use _burn(uint256) instead.
398      * @param owner owner of the token to burn
399      * @param tokenId uint256 ID of the token being burned
400      */
401     function _burn(address owner, uint256 tokenId) internal {
402         require(ownerOf(tokenId) == owner);
403 
404         _clearApproval(tokenId);
405 
406         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
407         _tokenOwner[tokenId] = address(0);
408 
409         emit Transfer(owner, address(0), tokenId);
410     }
411 
412     /**
413      * @dev Internal function to burn a specific token
414      * Reverts if the token does not exist
415      * @param tokenId uint256 ID of the token being burned
416      */
417     function _burn(uint256 tokenId) internal {
418         _burn(ownerOf(tokenId), tokenId);
419     }
420 
421     /**
422      * @dev Internal function to transfer ownership of a given token ID to another address.
423      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
424      * @param from current owner of the token
425      * @param to address to receive the ownership of the given token ID
426      * @param tokenId uint256 ID of the token to be transferred
427     */
428     function _transferFrom(address from, address to, uint256 tokenId) internal {
429         require(ownerOf(tokenId) == from);
430         require(to != address(0));
431 
432         _clearApproval(tokenId);
433 
434         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
435         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
436 
437         _tokenOwner[tokenId] = to;
438 
439         emit Transfer(from, to, tokenId);
440     }
441 
442     /**
443      * @dev Internal function to invoke `onERC721Received` on a target address
444      * The call is not executed if the target address is not a contract
445      * @param from address representing the previous owner of the given token ID
446      * @param to target address that will receive the tokens
447      * @param tokenId uint256 ID of the token to be transferred
448      * @param _data bytes optional data to send along with the call
449      * @return whether the call correctly returned the expected magic value
450      */
451     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
452         internal returns (bool)
453     {
454         if (!to.isContract()) {
455             return true;
456         }
457 
458         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
459         return (retval == _ERC721_RECEIVED);
460     }
461 
462     /**
463      * @dev Private function to clear current approval of a given token ID
464      * @param tokenId uint256 ID of the token to be transferred
465      */
466     function _clearApproval(uint256 tokenId) private {
467         if (_tokenApprovals[tokenId] != address(0)) {
468             _tokenApprovals[tokenId] = address(0);
469         }
470     }
471 }
472 
473 
474 /**
475  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
476  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
477  */
478 contract IERC721Metadata is IERC721 {
479     function name() external view returns (string memory);
480     function symbol() external view returns (string memory);
481     function tokenURI(uint256 tokenId) external view returns (string memory);
482 }
483 
484 
485 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
486     // Token name
487     string private _name;
488 
489     // Token symbol
490     string private _symbol;
491 
492     // Optional mapping for token URIs
493     mapping(uint256 => string) private _tokenURIs;
494     
495     string _tokenURI;
496 
497     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
498     /**
499      * 0x5b5e139f ===
500      *     bytes4(keccak256('name()')) ^
501      *     bytes4(keccak256('symbol()')) ^
502      *     bytes4(keccak256('tokenURI(uint256)'))
503      */
504 
505     /**
506      * @dev Constructor function
507      */
508     constructor (string memory name, string memory symbol) public {
509         _name = name;
510         _symbol = symbol;
511 
512         // register the supported interfaces to conform to ERC721 via ERC165
513         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
514     }
515 
516     /**
517      * @dev Gets the token name
518      * @return string representing the token name
519      */
520     function name() external view returns (string memory) {
521         return _name;
522     }
523 
524     /**
525      * @dev Gets the token symbol
526      * @return string representing the token symbol
527      */
528     function symbol() external view returns (string memory) {
529         return _symbol;
530     }
531 
532     /**
533      * @dev Returns an URI for a given token ID
534      * Throws if the token ID does not exist. May return an empty string.
535      * @param tokenId uint256 ID of the token to query
536      */
537     function tokenURI(uint256 tokenId) external view returns (string memory) {
538         require(_exists(tokenId));
539         //return _tokenURIs[tokenId];
540         return _tokenURI;
541     }
542 
543     /**
544      * @dev Internal function to set the token URI for a given token
545      * Reverts if the token ID does not exist
546      * @param tokenId uint256 ID of the token to set its URI
547      * @param uri string URI to assign
548      */
549     function _setTokenURI(uint256 tokenId, string memory uri) internal {
550             _tokenURI = uri;
551             //require(_exists(tokenId));
552             //_tokenURIs[tokenId] = uri;
553     }
554 
555     /**
556      * @dev Internal function to burn a specific token
557      * Reverts if the token does not exist
558      * Deprecated, use _burn(uint256) instead
559      * @param owner owner of the token to burn
560      * @param tokenId uint256 ID of the token being burned by the msg.sender
561      */
562     function _burn(address owner, uint256 tokenId) internal {
563         super._burn(owner, tokenId);
564 
565         // Clear metadata (if any)
566         if (bytes(_tokenURIs[tokenId]).length != 0) {
567             delete _tokenURIs[tokenId];
568         }
569     }
570 }
571 
572 
573 /**
574  * @title Ownable
575  * @dev The Ownable contract has an owner address, and provides basic authorization control
576  * functions, this simplifies the implementation of "user permissions".
577  */
578 contract Ownable {
579     address private _owner;
580 
581     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
582 
583     /**
584      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
585      * account.
586      */
587     constructor () internal {
588         _owner = msg.sender;
589         emit OwnershipTransferred(address(0), _owner);
590     }
591 
592     /**
593      * @return the address of the owner.
594      */
595     function owner() public view returns (address) {
596         return _owner;
597     }
598 
599     /**
600      * @dev Throws if called by any account other than the owner.
601      */
602     modifier onlyOwner() {
603         require(isOwner());
604         _;
605     }
606 
607     /**
608      * @return true if `msg.sender` is the owner of the contract.
609      */
610     function isOwner() public view returns (bool) {
611         return msg.sender == _owner;
612     }
613 
614     /**
615      * @dev Allows the current owner to relinquish control of the contract.
616      * @notice Renouncing to ownership will leave the contract without an owner.
617      * It will not be possible to call the functions with the `onlyOwner`
618      * modifier anymore.
619      */
620     function renounceOwnership() public onlyOwner {
621         emit OwnershipTransferred(_owner, address(0));
622         _owner = address(0);
623     }
624 
625     /**
626      * @dev Allows the current owner to transfer control of the contract to a newOwner.
627      * @param newOwner The address to transfer ownership to.
628      */
629     function transferOwnership(address newOwner) public onlyOwner {
630         _transferOwnership(newOwner);
631     }
632 
633     /**
634      * @dev Transfers control of the contract to a newOwner.
635      * @param newOwner The address to transfer ownership to.
636      */
637     function _transferOwnership(address newOwner) internal {
638         require(newOwner != address(0));
639         emit OwnershipTransferred(_owner, newOwner);
640         _owner = newOwner;
641     }
642 }
643 
644 /**
645  * @title ERC721Mintable
646  * @dev ERC721 minting logic
647  */
648 contract ERC721Mintable is ERC721, Ownable {
649     /**
650      * @dev Function to mint tokens
651      * @param to The address that will receive the minted tokens.
652      * @param tokenId The token id to mint.
653      * @return A boolean that indicates if the operation was successful.
654      */
655     function mint(address to, uint256 tokenId, string memory s) public onlyOwner returns (bool) {
656         _mint(to, tokenId);
657         return true;
658     }
659 }
660 
661 /**
662  * @title ERC721 Burnable Token
663  * @dev ERC721 Token that can be irreversibly burned (destroyed).
664  */
665 contract ERC721Burnable is ERC721, Ownable {
666     /**
667      * @dev Burns a specific ERC721 token.
668      * @param tokenId uint256 id of the ERC721 token to be burned.
669      */
670     function burn(uint256 tokenId) public onlyOwner {
671         //require(_isApprovedOrOwner(msg.sender, tokenId));
672         _burn(tokenId);
673     }
674 }
675 
676 contract C_Score is ERC721, ERC721Metadata, Ownable, ERC721Mintable, ERC721Burnable {
677 
678     constructor() ERC721Metadata("C-SCORE", "") public 
679     {
680         _setTokenURI(0, "https://s3.eu-west-2.amazonaws.com/coinfirm-io/c-score-token/token.json");
681     }
682 
683 }