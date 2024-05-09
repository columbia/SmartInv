1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: openzeppelin-solidity/contracts/access/Roles.sol
77 
78 pragma solidity ^0.5.0;
79 
80 /**
81  * @title Roles
82  * @dev Library for managing addresses assigned to a Role.
83  */
84 library Roles {
85     struct Role {
86         mapping (address => bool) bearer;
87     }
88 
89     /**
90      * @dev give an account access to this role
91      */
92     function add(Role storage role, address account) internal {
93         require(account != address(0));
94         require(!has(role, account));
95 
96         role.bearer[account] = true;
97     }
98 
99     /**
100      * @dev remove an account's access to this role
101      */
102     function remove(Role storage role, address account) internal {
103         require(account != address(0));
104         require(has(role, account));
105 
106         role.bearer[account] = false;
107     }
108 
109     /**
110      * @dev check if an account has this role
111      * @return bool
112      */
113     function has(Role storage role, address account) internal view returns (bool) {
114         require(account != address(0));
115         return role.bearer[account];
116     }
117 }
118 
119 // File: openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol
120 
121 pragma solidity ^0.5.0;
122 
123 
124 /**
125  * @title WhitelistAdminRole
126  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
127  */
128 contract WhitelistAdminRole {
129     using Roles for Roles.Role;
130 
131     event WhitelistAdminAdded(address indexed account);
132     event WhitelistAdminRemoved(address indexed account);
133 
134     Roles.Role private _whitelistAdmins;
135 
136     constructor () internal {
137         _addWhitelistAdmin(msg.sender);
138     }
139 
140     modifier onlyWhitelistAdmin() {
141         require(isWhitelistAdmin(msg.sender));
142         _;
143     }
144 
145     function isWhitelistAdmin(address account) public view returns (bool) {
146         return _whitelistAdmins.has(account);
147     }
148 
149     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
150         _addWhitelistAdmin(account);
151     }
152 
153     function renounceWhitelistAdmin() public {
154         _removeWhitelistAdmin(msg.sender);
155     }
156 
157     function _addWhitelistAdmin(address account) internal {
158         _whitelistAdmins.add(account);
159         emit WhitelistAdminAdded(account);
160     }
161 
162     function _removeWhitelistAdmin(address account) internal {
163         _whitelistAdmins.remove(account);
164         emit WhitelistAdminRemoved(account);
165     }
166 }
167 
168 // File: openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol
169 
170 pragma solidity ^0.5.0;
171 
172 
173 
174 /**
175  * @title WhitelistedRole
176  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
177  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
178  * it), and not Whitelisteds themselves.
179  */
180 contract WhitelistedRole is WhitelistAdminRole {
181     using Roles for Roles.Role;
182 
183     event WhitelistedAdded(address indexed account);
184     event WhitelistedRemoved(address indexed account);
185 
186     Roles.Role private _whitelisteds;
187 
188     modifier onlyWhitelisted() {
189         require(isWhitelisted(msg.sender));
190         _;
191     }
192 
193     function isWhitelisted(address account) public view returns (bool) {
194         return _whitelisteds.has(account);
195     }
196 
197     function addWhitelisted(address account) public onlyWhitelistAdmin {
198         _addWhitelisted(account);
199     }
200 
201     function removeWhitelisted(address account) public onlyWhitelistAdmin {
202         _removeWhitelisted(account);
203     }
204 
205     function renounceWhitelisted() public {
206         _removeWhitelisted(msg.sender);
207     }
208 
209     function _addWhitelisted(address account) internal {
210         _whitelisteds.add(account);
211         emit WhitelistedAdded(account);
212     }
213 
214     function _removeWhitelisted(address account) internal {
215         _whitelisteds.remove(account);
216         emit WhitelistedRemoved(account);
217     }
218 }
219 
220 // File: contracts/libs/Strings.sol
221 
222 pragma solidity ^0.5.0;
223 
224 library Strings {
225 
226     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
227     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
228         bytes memory _ba = bytes(_a);
229         bytes memory _bb = bytes(_b);
230         bytes memory _bc = bytes(_c);
231         bytes memory _bd = bytes(_d);
232         bytes memory _be = bytes(_e);
233         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
234         bytes memory babcde = bytes(abcde);
235         uint k = 0;
236         uint i = 0;
237         for (i = 0; i < _ba.length; i++) {
238             babcde[k++] = _ba[i];
239         }
240         for (i = 0; i < _bb.length; i++) {
241             babcde[k++] = _bb[i];
242         }
243         for (i = 0; i < _bc.length; i++) {
244             babcde[k++] = _bc[i];
245         }
246         for (i = 0; i < _bd.length; i++) {
247             babcde[k++] = _bd[i];
248         }
249         for (i = 0; i < _be.length; i++) {
250             babcde[k++] = _be[i];
251         }
252         return string(babcde);
253     }
254 
255     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
256         return strConcat(_a, _b, "", "", "");
257     }
258 
259     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
260         return strConcat(_a, _b, _c, "", "");
261     }
262 
263     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
264         if (_i == 0) {
265             return "0";
266         }
267         uint j = _i;
268         uint len;
269         while (j != 0) {
270             len++;
271             j /= 10;
272         }
273         bytes memory bstr = new bytes(len);
274         uint k = len - 1;
275         while (_i != 0) {
276             bstr[k--] = byte(uint8(48 + _i % 10));
277             _i /= 10;
278         }
279         return string(bstr);
280     }
281 }
282 
283 // File: contracts/IBlockCitiesCreator.sol
284 
285 pragma solidity ^0.5.0;
286 
287 interface IBlockCitiesCreator {
288     function createBuilding(
289         uint256 _exteriorColorway,
290         uint256 _backgroundColorway,
291         uint256 _city,
292         uint256 _building,
293         uint256 _base,
294         uint256 _body,
295         uint256 _roof,
296         uint256 _special,
297         address _architect
298     ) external returns (uint256 _tokenId);
299 }
300 
301 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
302 
303 pragma solidity ^0.5.0;
304 
305 /**
306  * @title IERC165
307  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
308  */
309 interface IERC165 {
310     /**
311      * @notice Query if a contract implements an interface
312      * @param interfaceId The interface identifier, as specified in ERC-165
313      * @dev Interface identification is specified in ERC-165. This function
314      * uses less than 30,000 gas.
315      */
316     function supportsInterface(bytes4 interfaceId) external view returns (bool);
317 }
318 
319 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
320 
321 pragma solidity ^0.5.0;
322 
323 
324 /**
325  * @title ERC721 Non-Fungible Token Standard basic interface
326  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
327  */
328 contract IERC721 is IERC165 {
329     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
330     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
331     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
332 
333     function balanceOf(address owner) public view returns (uint256 balance);
334     function ownerOf(uint256 tokenId) public view returns (address owner);
335 
336     function approve(address to, uint256 tokenId) public;
337     function getApproved(uint256 tokenId) public view returns (address operator);
338 
339     function setApprovalForAll(address operator, bool _approved) public;
340     function isApprovedForAll(address owner, address operator) public view returns (bool);
341 
342     function transferFrom(address from, address to, uint256 tokenId) public;
343     function safeTransferFrom(address from, address to, uint256 tokenId) public;
344 
345     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
346 }
347 
348 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
349 
350 pragma solidity ^0.5.0;
351 
352 /**
353  * @title ERC721 token receiver interface
354  * @dev Interface for any contract that wants to support safeTransfers
355  * from ERC721 asset contracts.
356  */
357 contract IERC721Receiver {
358     /**
359      * @notice Handle the receipt of an NFT
360      * @dev The ERC721 smart contract calls this function on the recipient
361      * after a `safeTransfer`. This function MUST return the function selector,
362      * otherwise the caller will revert the transaction. The selector to be
363      * returned can be obtained as `this.onERC721Received.selector`. This
364      * function MAY throw to revert and reject the transfer.
365      * Note: the ERC721 contract address is always the message sender.
366      * @param operator The address which called `safeTransferFrom` function
367      * @param from The address which previously owned the token
368      * @param tokenId The NFT identifier which is being transferred
369      * @param data Additional data with no specified format
370      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
371      */
372     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
373     public returns (bytes4);
374 }
375 
376 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
377 
378 pragma solidity ^0.5.0;
379 
380 /**
381  * @title SafeMath
382  * @dev Unsigned math operations with safety checks that revert on error
383  */
384 library SafeMath {
385     /**
386     * @dev Multiplies two unsigned integers, reverts on overflow.
387     */
388     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
389         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
390         // benefit is lost if 'b' is also tested.
391         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
392         if (a == 0) {
393             return 0;
394         }
395 
396         uint256 c = a * b;
397         require(c / a == b);
398 
399         return c;
400     }
401 
402     /**
403     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
404     */
405     function div(uint256 a, uint256 b) internal pure returns (uint256) {
406         // Solidity only automatically asserts when dividing by 0
407         require(b > 0);
408         uint256 c = a / b;
409         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
410 
411         return c;
412     }
413 
414     /**
415     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
416     */
417     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
418         require(b <= a);
419         uint256 c = a - b;
420 
421         return c;
422     }
423 
424     /**
425     * @dev Adds two unsigned integers, reverts on overflow.
426     */
427     function add(uint256 a, uint256 b) internal pure returns (uint256) {
428         uint256 c = a + b;
429         require(c >= a);
430 
431         return c;
432     }
433 
434     /**
435     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
436     * reverts when dividing by zero.
437     */
438     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
439         require(b != 0);
440         return a % b;
441     }
442 }
443 
444 // File: openzeppelin-solidity/contracts/utils/Address.sol
445 
446 pragma solidity ^0.5.0;
447 
448 /**
449  * Utility library of inline functions on addresses
450  */
451 library Address {
452     /**
453      * Returns whether the target address is a contract
454      * @dev This function will return false if invoked during the constructor of a contract,
455      * as the code is not actually created until after the constructor finishes.
456      * @param account address of the account to check
457      * @return whether the target address is a contract
458      */
459     function isContract(address account) internal view returns (bool) {
460         uint256 size;
461         // XXX Currently there is no better way to check if there is a contract in an address
462         // than to check the size of the code at that address.
463         // See https://ethereum.stackexchange.com/a/14016/36603
464         // for more details about how this works.
465         // TODO Check this again before the Serenity release, because all addresses will be
466         // contracts then.
467         // solhint-disable-next-line no-inline-assembly
468         assembly { size := extcodesize(account) }
469         return size > 0;
470     }
471 }
472 
473 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
474 
475 pragma solidity ^0.5.0;
476 
477 
478 /**
479  * @title ERC165
480  * @author Matt Condon (@shrugs)
481  * @dev Implements ERC165 using a lookup table.
482  */
483 contract ERC165 is IERC165 {
484     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
485     /**
486      * 0x01ffc9a7 ===
487      *     bytes4(keccak256('supportsInterface(bytes4)'))
488      */
489 
490     /**
491      * @dev a mapping of interface id to whether or not it's supported
492      */
493     mapping(bytes4 => bool) private _supportedInterfaces;
494 
495     /**
496      * @dev A contract implementing SupportsInterfaceWithLookup
497      * implement ERC165 itself
498      */
499     constructor () internal {
500         _registerInterface(_INTERFACE_ID_ERC165);
501     }
502 
503     /**
504      * @dev implement supportsInterface(bytes4) using a lookup table
505      */
506     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
507         return _supportedInterfaces[interfaceId];
508     }
509 
510     /**
511      * @dev internal method for registering an interface
512      */
513     function _registerInterface(bytes4 interfaceId) internal {
514         require(interfaceId != 0xffffffff);
515         _supportedInterfaces[interfaceId] = true;
516     }
517 }
518 
519 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
520 
521 pragma solidity ^0.5.0;
522 
523 
524 
525 
526 
527 
528 /**
529  * @title ERC721 Non-Fungible Token Standard basic implementation
530  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
531  */
532 contract ERC721 is ERC165, IERC721 {
533     using SafeMath for uint256;
534     using Address for address;
535 
536     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
537     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
538     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
539 
540     // Mapping from token ID to owner
541     mapping (uint256 => address) private _tokenOwner;
542 
543     // Mapping from token ID to approved address
544     mapping (uint256 => address) private _tokenApprovals;
545 
546     // Mapping from owner to number of owned token
547     mapping (address => uint256) private _ownedTokensCount;
548 
549     // Mapping from owner to operator approvals
550     mapping (address => mapping (address => bool)) private _operatorApprovals;
551 
552     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
553     /*
554      * 0x80ac58cd ===
555      *     bytes4(keccak256('balanceOf(address)')) ^
556      *     bytes4(keccak256('ownerOf(uint256)')) ^
557      *     bytes4(keccak256('approve(address,uint256)')) ^
558      *     bytes4(keccak256('getApproved(uint256)')) ^
559      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
560      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
561      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
562      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
563      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
564      */
565 
566     constructor () public {
567         // register the supported interfaces to conform to ERC721 via ERC165
568         _registerInterface(_INTERFACE_ID_ERC721);
569     }
570 
571     /**
572      * @dev Gets the balance of the specified address
573      * @param owner address to query the balance of
574      * @return uint256 representing the amount owned by the passed address
575      */
576     function balanceOf(address owner) public view returns (uint256) {
577         require(owner != address(0));
578         return _ownedTokensCount[owner];
579     }
580 
581     /**
582      * @dev Gets the owner of the specified token ID
583      * @param tokenId uint256 ID of the token to query the owner of
584      * @return owner address currently marked as the owner of the given token ID
585      */
586     function ownerOf(uint256 tokenId) public view returns (address) {
587         address owner = _tokenOwner[tokenId];
588         require(owner != address(0));
589         return owner;
590     }
591 
592     /**
593      * @dev Approves another address to transfer the given token ID
594      * The zero address indicates there is no approved address.
595      * There can only be one approved address per token at a given time.
596      * Can only be called by the token owner or an approved operator.
597      * @param to address to be approved for the given token ID
598      * @param tokenId uint256 ID of the token to be approved
599      */
600     function approve(address to, uint256 tokenId) public {
601         address owner = ownerOf(tokenId);
602         require(to != owner);
603         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
604 
605         _tokenApprovals[tokenId] = to;
606         emit Approval(owner, to, tokenId);
607     }
608 
609     /**
610      * @dev Gets the approved address for a token ID, or zero if no address set
611      * Reverts if the token ID does not exist.
612      * @param tokenId uint256 ID of the token to query the approval of
613      * @return address currently approved for the given token ID
614      */
615     function getApproved(uint256 tokenId) public view returns (address) {
616         require(_exists(tokenId));
617         return _tokenApprovals[tokenId];
618     }
619 
620     /**
621      * @dev Sets or unsets the approval of a given operator
622      * An operator is allowed to transfer all tokens of the sender on their behalf
623      * @param to operator address to set the approval
624      * @param approved representing the status of the approval to be set
625      */
626     function setApprovalForAll(address to, bool approved) public {
627         require(to != msg.sender);
628         _operatorApprovals[msg.sender][to] = approved;
629         emit ApprovalForAll(msg.sender, to, approved);
630     }
631 
632     /**
633      * @dev Tells whether an operator is approved by a given owner
634      * @param owner owner address which you want to query the approval of
635      * @param operator operator address which you want to query the approval of
636      * @return bool whether the given operator is approved by the given owner
637      */
638     function isApprovedForAll(address owner, address operator) public view returns (bool) {
639         return _operatorApprovals[owner][operator];
640     }
641 
642     /**
643      * @dev Transfers the ownership of a given token ID to another address
644      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
645      * Requires the msg sender to be the owner, approved, or operator
646      * @param from current owner of the token
647      * @param to address to receive the ownership of the given token ID
648      * @param tokenId uint256 ID of the token to be transferred
649     */
650     function transferFrom(address from, address to, uint256 tokenId) public {
651         require(_isApprovedOrOwner(msg.sender, tokenId));
652 
653         _transferFrom(from, to, tokenId);
654     }
655 
656     /**
657      * @dev Safely transfers the ownership of a given token ID to another address
658      * If the target address is a contract, it must implement `onERC721Received`,
659      * which is called upon a safe transfer, and return the magic value
660      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
661      * the transfer is reverted.
662      *
663      * Requires the msg sender to be the owner, approved, or operator
664      * @param from current owner of the token
665      * @param to address to receive the ownership of the given token ID
666      * @param tokenId uint256 ID of the token to be transferred
667     */
668     function safeTransferFrom(address from, address to, uint256 tokenId) public {
669         safeTransferFrom(from, to, tokenId, "");
670     }
671 
672     /**
673      * @dev Safely transfers the ownership of a given token ID to another address
674      * If the target address is a contract, it must implement `onERC721Received`,
675      * which is called upon a safe transfer, and return the magic value
676      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
677      * the transfer is reverted.
678      * Requires the msg sender to be the owner, approved, or operator
679      * @param from current owner of the token
680      * @param to address to receive the ownership of the given token ID
681      * @param tokenId uint256 ID of the token to be transferred
682      * @param _data bytes data to send along with a safe transfer check
683      */
684     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
685         transferFrom(from, to, tokenId);
686         require(_checkOnERC721Received(from, to, tokenId, _data));
687     }
688 
689     /**
690      * @dev Returns whether the specified token exists
691      * @param tokenId uint256 ID of the token to query the existence of
692      * @return whether the token exists
693      */
694     function _exists(uint256 tokenId) internal view returns (bool) {
695         address owner = _tokenOwner[tokenId];
696         return owner != address(0);
697     }
698 
699     /**
700      * @dev Returns whether the given spender can transfer a given token ID
701      * @param spender address of the spender to query
702      * @param tokenId uint256 ID of the token to be transferred
703      * @return bool whether the msg.sender is approved for the given token ID,
704      *    is an operator of the owner, or is the owner of the token
705      */
706     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
707         address owner = ownerOf(tokenId);
708         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
709     }
710 
711     /**
712      * @dev Internal function to mint a new token
713      * Reverts if the given token ID already exists
714      * @param to The address that will own the minted token
715      * @param tokenId uint256 ID of the token to be minted
716      */
717     function _mint(address to, uint256 tokenId) internal {
718         require(to != address(0));
719         require(!_exists(tokenId));
720 
721         _tokenOwner[tokenId] = to;
722         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
723 
724         emit Transfer(address(0), to, tokenId);
725     }
726 
727     /**
728      * @dev Internal function to burn a specific token
729      * Reverts if the token does not exist
730      * Deprecated, use _burn(uint256) instead.
731      * @param owner owner of the token to burn
732      * @param tokenId uint256 ID of the token being burned
733      */
734     function _burn(address owner, uint256 tokenId) internal {
735         require(ownerOf(tokenId) == owner);
736 
737         _clearApproval(tokenId);
738 
739         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
740         _tokenOwner[tokenId] = address(0);
741 
742         emit Transfer(owner, address(0), tokenId);
743     }
744 
745     /**
746      * @dev Internal function to burn a specific token
747      * Reverts if the token does not exist
748      * @param tokenId uint256 ID of the token being burned
749      */
750     function _burn(uint256 tokenId) internal {
751         _burn(ownerOf(tokenId), tokenId);
752     }
753 
754     /**
755      * @dev Internal function to transfer ownership of a given token ID to another address.
756      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
757      * @param from current owner of the token
758      * @param to address to receive the ownership of the given token ID
759      * @param tokenId uint256 ID of the token to be transferred
760     */
761     function _transferFrom(address from, address to, uint256 tokenId) internal {
762         require(ownerOf(tokenId) == from);
763         require(to != address(0));
764 
765         _clearApproval(tokenId);
766 
767         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
768         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
769 
770         _tokenOwner[tokenId] = to;
771 
772         emit Transfer(from, to, tokenId);
773     }
774 
775     /**
776      * @dev Internal function to invoke `onERC721Received` on a target address
777      * The call is not executed if the target address is not a contract
778      * @param from address representing the previous owner of the given token ID
779      * @param to target address that will receive the tokens
780      * @param tokenId uint256 ID of the token to be transferred
781      * @param _data bytes optional data to send along with the call
782      * @return whether the call correctly returned the expected magic value
783      */
784     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
785         internal returns (bool)
786     {
787         if (!to.isContract()) {
788             return true;
789         }
790 
791         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
792         return (retval == _ERC721_RECEIVED);
793     }
794 
795     /**
796      * @dev Private function to clear current approval of a given token ID
797      * @param tokenId uint256 ID of the token to be transferred
798      */
799     function _clearApproval(uint256 tokenId) private {
800         if (_tokenApprovals[tokenId] != address(0)) {
801             _tokenApprovals[tokenId] = address(0);
802         }
803     }
804 }
805 
806 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
807 
808 pragma solidity ^0.5.0;
809 
810 
811 /**
812  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
813  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
814  */
815 contract IERC721Enumerable is IERC721 {
816     function totalSupply() public view returns (uint256);
817     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
818 
819     function tokenByIndex(uint256 index) public view returns (uint256);
820 }
821 
822 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
823 
824 pragma solidity ^0.5.0;
825 
826 
827 
828 
829 /**
830  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
831  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
832  */
833 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
834     // Mapping from owner to list of owned token IDs
835     mapping(address => uint256[]) private _ownedTokens;
836 
837     // Mapping from token ID to index of the owner tokens list
838     mapping(uint256 => uint256) private _ownedTokensIndex;
839 
840     // Array with all token ids, used for enumeration
841     uint256[] private _allTokens;
842 
843     // Mapping from token id to position in the allTokens array
844     mapping(uint256 => uint256) private _allTokensIndex;
845 
846     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
847     /**
848      * 0x780e9d63 ===
849      *     bytes4(keccak256('totalSupply()')) ^
850      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
851      *     bytes4(keccak256('tokenByIndex(uint256)'))
852      */
853 
854     /**
855      * @dev Constructor function
856      */
857     constructor () public {
858         // register the supported interface to conform to ERC721 via ERC165
859         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
860     }
861 
862     /**
863      * @dev Gets the token ID at a given index of the tokens list of the requested owner
864      * @param owner address owning the tokens list to be accessed
865      * @param index uint256 representing the index to be accessed of the requested tokens list
866      * @return uint256 token ID at the given index of the tokens list owned by the requested address
867      */
868     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
869         require(index < balanceOf(owner));
870         return _ownedTokens[owner][index];
871     }
872 
873     /**
874      * @dev Gets the total amount of tokens stored by the contract
875      * @return uint256 representing the total amount of tokens
876      */
877     function totalSupply() public view returns (uint256) {
878         return _allTokens.length;
879     }
880 
881     /**
882      * @dev Gets the token ID at a given index of all the tokens in this contract
883      * Reverts if the index is greater or equal to the total number of tokens
884      * @param index uint256 representing the index to be accessed of the tokens list
885      * @return uint256 token ID at the given index of the tokens list
886      */
887     function tokenByIndex(uint256 index) public view returns (uint256) {
888         require(index < totalSupply());
889         return _allTokens[index];
890     }
891 
892     /**
893      * @dev Internal function to transfer ownership of a given token ID to another address.
894      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
895      * @param from current owner of the token
896      * @param to address to receive the ownership of the given token ID
897      * @param tokenId uint256 ID of the token to be transferred
898     */
899     function _transferFrom(address from, address to, uint256 tokenId) internal {
900         super._transferFrom(from, to, tokenId);
901 
902         _removeTokenFromOwnerEnumeration(from, tokenId);
903 
904         _addTokenToOwnerEnumeration(to, tokenId);
905     }
906 
907     /**
908      * @dev Internal function to mint a new token
909      * Reverts if the given token ID already exists
910      * @param to address the beneficiary that will own the minted token
911      * @param tokenId uint256 ID of the token to be minted
912      */
913     function _mint(address to, uint256 tokenId) internal {
914         super._mint(to, tokenId);
915 
916         _addTokenToOwnerEnumeration(to, tokenId);
917 
918         _addTokenToAllTokensEnumeration(tokenId);
919     }
920 
921     /**
922      * @dev Internal function to burn a specific token
923      * Reverts if the token does not exist
924      * Deprecated, use _burn(uint256) instead
925      * @param owner owner of the token to burn
926      * @param tokenId uint256 ID of the token being burned
927      */
928     function _burn(address owner, uint256 tokenId) internal {
929         super._burn(owner, tokenId);
930 
931         _removeTokenFromOwnerEnumeration(owner, tokenId);
932         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
933         _ownedTokensIndex[tokenId] = 0;
934 
935         _removeTokenFromAllTokensEnumeration(tokenId);
936     }
937 
938     /**
939      * @dev Gets the list of token IDs of the requested owner
940      * @param owner address owning the tokens
941      * @return uint256[] List of token IDs owned by the requested address
942      */
943     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
944         return _ownedTokens[owner];
945     }
946 
947     /**
948      * @dev Private function to add a token to this extension's ownership-tracking data structures.
949      * @param to address representing the new owner of the given token ID
950      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
951      */
952     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
953         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
954         _ownedTokens[to].push(tokenId);
955     }
956 
957     /**
958      * @dev Private function to add a token to this extension's token tracking data structures.
959      * @param tokenId uint256 ID of the token to be added to the tokens list
960      */
961     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
962         _allTokensIndex[tokenId] = _allTokens.length;
963         _allTokens.push(tokenId);
964     }
965 
966     /**
967      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
968      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
969      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
970      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
971      * @param from address representing the previous owner of the given token ID
972      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
973      */
974     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
975         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
976         // then delete the last slot (swap and pop).
977 
978         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
979         uint256 tokenIndex = _ownedTokensIndex[tokenId];
980 
981         // When the token to delete is the last token, the swap operation is unnecessary
982         if (tokenIndex != lastTokenIndex) {
983             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
984 
985             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
986             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
987         }
988 
989         // This also deletes the contents at the last position of the array
990         _ownedTokens[from].length--;
991 
992         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
993         // lasTokenId, or just over the end of the array if the token was the last one).
994     }
995 
996     /**
997      * @dev Private function to remove a token from this extension's token tracking data structures.
998      * This has O(1) time complexity, but alters the order of the _allTokens array.
999      * @param tokenId uint256 ID of the token to be removed from the tokens list
1000      */
1001     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1002         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1003         // then delete the last slot (swap and pop).
1004 
1005         uint256 lastTokenIndex = _allTokens.length.sub(1);
1006         uint256 tokenIndex = _allTokensIndex[tokenId];
1007 
1008         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1009         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1010         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1011         uint256 lastTokenId = _allTokens[lastTokenIndex];
1012 
1013         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1014         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1015 
1016         // This also deletes the contents at the last position of the array
1017         _allTokens.length--;
1018         _allTokensIndex[tokenId] = 0;
1019     }
1020 }
1021 
1022 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
1023 
1024 pragma solidity ^0.5.0;
1025 
1026 
1027 /**
1028  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1029  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1030  */
1031 contract IERC721Metadata is IERC721 {
1032     function name() external view returns (string memory);
1033     function symbol() external view returns (string memory);
1034     function tokenURI(uint256 tokenId) external view returns (string memory);
1035 }
1036 
1037 // File: contracts/erc721/ERC721MetadataWithoutTokenUri.sol
1038 
1039 pragma solidity ^0.5.0;
1040 
1041 
1042 
1043 
1044 contract ERC721MetadataWithoutTokenUri is ERC165, ERC721, IERC721Metadata {
1045     // Token name
1046     string private _name;
1047 
1048     // Token symbol
1049     string private _symbol;
1050 
1051     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1052     /**
1053      * 0x5b5e139f ===
1054      *     bytes4(keccak256('name()')) ^
1055      *     bytes4(keccak256('symbol()')) ^
1056      *     bytes4(keccak256('tokenURI(uint256)'))
1057      */
1058 
1059     /**
1060      * @dev Constructor function
1061      */
1062     constructor (string memory name, string memory symbol) public {
1063         _name = name;
1064         _symbol = symbol;
1065 
1066         // register the supported interfaces to conform to ERC721 via ERC165
1067         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1068     }
1069 
1070     /**
1071      * @dev Gets the token name
1072      * @return string representing the token name
1073      */
1074     function name() external view returns (string memory) {
1075         return _name;
1076     }
1077 
1078     /**
1079      * @dev Gets the token symbol
1080      * @return string representing the token symbol
1081      */
1082     function symbol() external view returns (string memory) {
1083         return _symbol;
1084     }
1085 
1086     /**
1087      * @dev Internal function to burn a specific token
1088      * Reverts if the token does not exist
1089      * Deprecated, use _burn(uint256) instead
1090      * @param owner owner of the token to burn
1091      * @param tokenId uint256 ID of the token being burned by the msg.sender
1092      */
1093     function _burn(address owner, uint256 tokenId) internal {
1094         super._burn(owner, tokenId);
1095     }
1096 }
1097 
1098 // File: contracts/erc721/CustomERC721Full.sol
1099 
1100 pragma solidity ^0.5.0;
1101 
1102 
1103 
1104 
1105 /**
1106  * @title Full ERC721 Token without token URI as this is handled in the base contract
1107  *
1108  * This implementation includes all the required and some optional functionality of the ERC721 standard
1109  * Moreover, it includes approve all functionality using operator terminology
1110  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1111  */
1112 contract CustomERC721Full is ERC721, ERC721Enumerable, ERC721MetadataWithoutTokenUri {
1113     constructor (string memory name, string memory symbol) public ERC721MetadataWithoutTokenUri(name, symbol) {
1114         // solhint-disable-previous-line no-empty-blocks
1115     }
1116 }
1117 
1118 // File: contracts/BlockCities.sol
1119 
1120 pragma solidity ^0.5.0;
1121 
1122 
1123 
1124 
1125 
1126 
1127 contract BlockCities is CustomERC721Full, WhitelistedRole, IBlockCitiesCreator {
1128     using SafeMath for uint256;
1129 
1130     string public tokenBaseURI = "";
1131 
1132     event BuildingMinted(
1133         uint256 indexed _tokenId,
1134         address indexed _to,
1135         address indexed _architect
1136     );
1137 
1138     uint256 public totalBuildings = 0;
1139     uint256 public tokenIdPointer = 0;
1140 
1141     struct Building {
1142         uint256 exteriorColorway;
1143         uint256 backgroundColorway;
1144         uint256 city;
1145         uint256 building;
1146         uint256 base;
1147         uint256 body;
1148         uint256 roof;
1149         uint256 special;
1150         address architect;
1151     }
1152 
1153     mapping(uint256 => Building) internal buildings;
1154 
1155     constructor (string memory _tokenBaseURI) public CustomERC721Full("BlockCities", "BKC") {
1156         super.addWhitelisted(msg.sender);
1157         tokenBaseURI = _tokenBaseURI;
1158     }
1159 
1160     function createBuilding(
1161         uint256 _exteriorColorway,
1162         uint256 _backgroundColorway,
1163         uint256 _city,
1164         uint256 _building,
1165         uint256 _base,
1166         uint256 _body,
1167         uint256 _roof,
1168         uint256 _special,
1169         address _architect
1170     )
1171     public onlyWhitelisted returns (uint256 _tokenId) {
1172         uint256 tokenId = tokenIdPointer.add(1);
1173 
1174         // reset token pointer
1175         tokenIdPointer = tokenId;
1176 
1177         // create building
1178         buildings[tokenId] = Building({
1179             exteriorColorway : _exteriorColorway,
1180             backgroundColorway : _backgroundColorway,
1181             city : _city,
1182             building: _building,
1183             base : _base,
1184             body : _body,
1185             roof : _roof,
1186             special: _special,
1187             architect : _architect
1188             });
1189 
1190         totalBuildings = totalBuildings.add(1);
1191 
1192         // mint the actual token magic
1193         _mint(_architect, tokenId);
1194 
1195         emit BuildingMinted(tokenId, _architect, _architect);
1196 
1197         return tokenId;
1198     }
1199 
1200     /**
1201      * @dev Returns an URI for a given token ID
1202      * Throws if the token ID does not exist. May return an empty string.
1203      * @param tokenId uint256 ID of the token to query
1204      */
1205     function tokenURI(uint256 tokenId) external view returns (string memory) {
1206         require(_exists(tokenId));
1207         return Strings.strConcat(tokenBaseURI, Strings.uint2str(tokenId));
1208     }
1209 
1210     function attributes(uint256 _tokenId) public view returns (
1211         uint256 _exteriorColorway,
1212         uint256 _backgroundColorway,
1213         uint256 _city,
1214         uint256 _building,
1215         uint256 _base,
1216         uint256 _body,
1217         uint256 _roof,
1218         uint256 _special,
1219         address _architect
1220     ) {
1221         require(_exists(_tokenId), "Token ID not found");
1222         Building storage building = buildings[_tokenId];
1223 
1224         return (
1225         building.exteriorColorway,
1226         building.backgroundColorway,
1227         building.city,
1228         building.building,
1229         building.base,
1230         building.body,
1231         building.roof,
1232         building.special,
1233         building.architect
1234         );
1235     }
1236 
1237     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1238         return _tokensOfOwner(owner);
1239     }
1240 
1241     function burn(uint256 _tokenId) public onlyWhitelisted returns (bool) {
1242         _burn(_tokenId);
1243 
1244         delete buildings[_tokenId];
1245 
1246         return true;
1247     }
1248 
1249     function updateTokenBaseURI(string memory _newBaseURI) public onlyWhitelisted {
1250         require(bytes(_newBaseURI).length != 0, "Base URI invalid");
1251         tokenBaseURI = _newBaseURI;
1252     }
1253 }