1 pragma solidity ^0.4.24;
2 
3 library Address {
4 
5   /**
6    * Returns whether the target address is a contract
7    * @dev This function will return false if invoked during the constructor of a contract,
8    * as the code is not actually created until after the constructor finishes.
9    * @param addr address to check
10    * @return whether the target address is a contract
11    */
12     function isContract(address addr) internal view returns (bool) {
13         uint256 size;
14         // XXX Currently there is no better way to check if there is a contract in an address
15         // than to check the size of the code at that address.
16         // See https://ethereum.stackexchange.com/a/14016/36603
17         // for more details about how this works.
18         // TODO Check this again before the Serenity release, because all addresses will be
19         // contracts then.
20         // solium-disable-next-line security/no-inline-assembly
21         assembly { size := extcodesize(addr) }
22         return size > 0;
23     }
24 
25 }
26 
27 contract Ownable {
28 
29     address public owner;
30 
31     constructor() public {
32         owner = msg.sender;
33     }
34 
35     function setOwner(address _owner) public onlyOwner {
36         owner = _owner;
37     }
38 
39     function getOwner() public view returns (address) {
40         return owner;
41     }
42 
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47 
48 }
49 
50 library SafeMath {
51 
52     /**
53     * @dev Multiplies two numbers, throws on overflow.
54     */
55     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
56         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
57         // benefit is lost if 'b' is also tested.
58         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
59         if (a == 0) {
60             return 0;
61         }
62 
63         c = a * b;
64         assert(c / a == b);
65         return c;
66     }
67 
68     /**
69     * @dev Integer division of two numbers, truncating the quotient.
70     */
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         // assert(b > 0); // Solidity automatically throws when dividing by 0
73         // uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75         return a / b;
76     }
77 
78     /**
79     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
80     */
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         assert(b <= a);
83         return a - b;
84     }
85 
86     /**
87     * @dev Adds two numbers, throws on overflow.
88     */
89     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
90         c = a + b;
91         assert(c >= a);
92         return c;
93     }
94 }
95 
96 library Strings {
97     
98   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
99   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
100       bytes memory _ba = bytes(_a);
101       bytes memory _bb = bytes(_b);
102       bytes memory _bc = bytes(_c);
103       bytes memory _bd = bytes(_d);
104       bytes memory _be = bytes(_e);
105       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
106       bytes memory babcde = bytes(abcde);
107       uint k = 0;
108       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
109       for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
110       for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
111       for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
112       for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
113       return string(babcde);
114     }
115 
116     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
117         return strConcat(_a, _b, _c, _d, "");
118     }
119 
120     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
121         return strConcat(_a, _b, _c, "", "");
122     }
123 
124     function strConcat(string _a, string _b) internal pure returns (string) {
125         return strConcat(_a, _b, "", "", "");
126     }
127 
128     function uint2str(uint i) internal pure returns (string) {
129         if (i == 0) return "0";
130         uint j = i;
131         uint len;
132         while (j != 0){
133             len++;
134             j /= 10;
135         }
136         bytes memory bstr = new bytes(len);
137         uint k = len - 1;
138         while (i != 0){
139             bstr[k--] = byte(48 + i % 10);
140             i /= 10;
141         }
142         return string(bstr);
143     }
144 }
145 
146 interface IERC165 {
147 
148   /**
149    * @notice Query if a contract implements an interface
150    * @param _interfaceId The interface identifier, as specified in ERC-165
151    * @dev Interface identification is specified in ERC-165. This function
152    * uses less than 30,000 gas.
153    */
154   function supportsInterface(bytes4 _interfaceId) external view returns (bool);
155   
156 }
157 
158 contract IERC721Receiver {
159     /**
160     * @dev Magic value to be returned upon successful reception of an NFT
161     *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
162     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
163     */
164     bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
165 
166     /**
167     * @notice Handle the receipt of an NFT
168     * @dev The ERC721 smart contract calls this function on the recipient
169     * after a `safetransfer`. This function MAY throw to revert and reject the
170     * transfer. Return of other than the magic value MUST result in the 
171     * transaction being reverted.
172     * Note: the contract address is always the message sender.
173     * @param _operator The address which called `safeTransferFrom` function
174     * @param _from The address which previously owned the token
175     * @param _tokenId The NFT identifier which is being transfered
176     * @param _data Additional data with no specified format
177     * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
178     */
179     function onERC721Received(
180         address _operator,
181         address _from,
182         uint256 _tokenId,
183         bytes memory _data
184     )
185         public
186         returns(bytes4);
187 }
188 
189 contract IERC721Holder is IERC721Receiver {
190 
191     function onERC721Received(address, address, uint256, bytes) public returns(bytes4) {
192         return ERC721_RECEIVED;
193     }
194 
195 }
196 
197 contract IERC721 is IERC165 {
198 
199     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
200     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
201     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
202 
203     function balanceOf(address owner) public view returns (uint256 balance);
204     function ownerOf(uint256 tokenId) public view returns (address owner);
205 
206     function approve(address to, uint256 tokenId) public;
207     function getApproved(uint256 tokenId) public view returns (address operator);
208 
209     function setApprovalForAll(address operator, bool _approved) public;
210     function isApprovedForAll(address owner, address operator) public view returns (bool);
211 
212     function transferFrom(address from, address to, uint256 tokenId) public;
213     function safeTransferFrom(address from, address to, uint256 tokenId) public;
214 
215     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
216 
217 }
218 
219 contract IERC721Enumerable is IERC721 {
220     function totalSupply() public view returns (uint256);
221     function tokenOfOwnerByIndex(
222         address _owner,
223         uint256 _index
224     )
225         public
226         view
227         returns (uint256 _tokenId);
228 
229     function tokenByIndex(uint256 _index) public view returns (uint256);
230 }
231 
232 contract IERC721Metadata is IERC721 {
233     function name() external view returns (string memory _name);
234     function symbol() external view returns (string memory _symbol);
235     function tokenURI(uint256 _tokenId) public view returns (string memory);
236 }
237 
238 contract SupportsInterfaceWithLookup is IERC165 {
239     bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
240     /**
241     * 0x01ffc9a7 ===
242     *   bytes4(keccak256('supportsInterface(bytes4)'))
243     */
244 
245     /**
246     * @dev a mapping of interface id to whether or not it's supported
247     */
248     mapping(bytes4 => bool) internal supportedInterfaces;
249 
250     /**
251     * @dev A contract implementing SupportsInterfaceWithLookup
252     * implement ERC165 itself
253     */
254     constructor() public {
255         _registerInterface(InterfaceId_ERC165);
256     }
257 
258     /**
259     * @dev implement supportsInterface(bytes4) using a lookup table
260     */
261     function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
262         return supportedInterfaces[_interfaceId];
263     }
264 
265     /**
266     * @dev private method for registering an interface
267     */
268     function _registerInterface(bytes4 _interfaceId) internal {
269         require(_interfaceId != 0xffffffff);
270         supportedInterfaces[_interfaceId] = true;
271     }
272 }
273 
274 contract Delegate {
275 
276     function mint(address _sender, address _to) public returns (bool);
277 
278     function approve(address _sender, address _to, uint256 _tokenId) public returns (bool);
279 
280     function setApprovalForAll(address _sender, address _operator, bool _approved) public returns (bool);
281 
282     function transferFrom(address _sender, address _from, address _to, uint256 _tokenId) public returns (bool);
283     
284     function safeTransferFrom(address _sender, address _from, address _to, uint256 _tokenId) public returns (bool);
285 
286     function safeTransferFrom(address _sender, address _from, address _to, uint256 _tokenId, bytes memory _data) public returns (bool);
287 
288 }
289 
290 /**
291  * @title ERC165
292  * @author Matt Condon (@shrugs)
293  * @dev Implements ERC165 using a lookup table.
294  */
295 contract ERC165 is IERC165 {
296 
297     bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
298     /**
299     * 0x01ffc9a7 ===
300     *   bytes4(keccak256('supportsInterface(bytes4)'))
301     */
302 
303     /**
304     * @dev a mapping of interface id to whether or not it's supported
305     */
306     mapping(bytes4 => bool) private _supportedInterfaces;
307 
308     /**
309     * @dev A contract implementing SupportsInterfaceWithLookup
310     * implement ERC165 itself
311     */
312     constructor()
313       internal
314     {
315         _registerInterface(_InterfaceId_ERC165);
316     }
317 
318     /**
319     * @dev implement supportsInterface(bytes4) using a lookup table
320     */
321     function supportsInterface(bytes4 interfaceId)
322       external
323       view
324       returns (bool)
325     {
326         return _supportedInterfaces[interfaceId];
327     }
328 
329     /**
330     * @dev internal method for registering an interface
331     */
332     function _registerInterface(bytes4 interfaceId)
333       internal
334     {
335         require(interfaceId != 0xffffffff);
336         _supportedInterfaces[interfaceId] = true;
337     }
338 }
339 
340 contract ERC721 is ERC165, IERC721 {
341 
342     using SafeMath for uint256;
343     using Address for address;
344 
345     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
346     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
347     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
348 
349     // Mapping from token ID to owner
350     mapping (uint256 => address) private _tokenOwner;
351 
352     // Mapping from token ID to approved address
353     mapping (uint256 => address) private _tokenApprovals;
354 
355     // Mapping from owner to number of owned token
356     mapping (address => uint256) private _ownedTokensCount;
357 
358     // Mapping from owner to operator approvals
359     mapping (address => mapping (address => bool)) private _operatorApprovals;
360 
361     bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
362     /*
363     * 0x80ac58cd ===
364     *   bytes4(keccak256('balanceOf(address)')) ^
365     *   bytes4(keccak256('ownerOf(uint256)')) ^
366     *   bytes4(keccak256('approve(address,uint256)')) ^
367     *   bytes4(keccak256('getApproved(uint256)')) ^
368     *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
369     *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
370     *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
371     *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
372     *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
373     */
374 
375     constructor()
376         public
377     {
378         // register the supported interfaces to conform to ERC721 via ERC165
379         _registerInterface(_InterfaceId_ERC721);
380     }
381 
382     /**
383     * @dev Gets the balance of the specified address
384     * @param owner address to query the balance of
385     * @return uint256 representing the amount owned by the passed address
386     */
387     function balanceOf(address owner) public view returns (uint256) {
388         require(owner != address(0));
389         return _ownedTokensCount[owner];
390     }
391 
392     /**
393     * @dev Gets the owner of the specified token ID
394     * @param tokenId uint256 ID of the token to query the owner of
395     * @return owner address currently marked as the owner of the given token ID
396     */
397     function ownerOf(uint256 tokenId) public view returns (address) {
398         address owner = _tokenOwner[tokenId];
399         require(owner != address(0));
400         return owner;
401     }
402 
403     /**
404     * @dev Approves another address to transfer the given token ID
405     * The zero address indicates there is no approved address.
406     * There can only be one approved address per token at a given time.
407     * Can only be called by the token owner or an approved operator.
408     * @param to address to be approved for the given token ID
409     * @param tokenId uint256 ID of the token to be approved
410     */
411     function approve(address to, uint256 tokenId) public {
412         address owner = ownerOf(tokenId);
413         require(to != owner);
414         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
415 
416         _tokenApprovals[tokenId] = to;
417         emit Approval(owner, to, tokenId);
418     }
419 
420     /**
421     * @dev Gets the approved address for a token ID, or zero if no address set
422     * Reverts if the token ID does not exist.
423     * @param tokenId uint256 ID of the token to query the approval of
424     * @return address currently approved for the given token ID
425     */
426     function getApproved(uint256 tokenId) public view returns (address) {
427         require(_exists(tokenId));
428         return _tokenApprovals[tokenId];
429     }
430 
431     /**
432     * @dev Sets or unsets the approval of a given operator
433     * An operator is allowed to transfer all tokens of the sender on their behalf
434     * @param to operator address to set the approval
435     * @param approved representing the status of the approval to be set
436     */
437     function setApprovalForAll(address to, bool approved) public {
438         require(to != msg.sender);
439         _operatorApprovals[msg.sender][to] = approved;
440         emit ApprovalForAll(msg.sender, to, approved);
441     }
442 
443     /**
444     * @dev Tells whether an operator is approved by a given owner
445     * @param owner owner address which you want to query the approval of
446     * @param operator operator address which you want to query the approval of
447     * @return bool whether the given operator is approved by the given owner
448     */
449     function isApprovedForAll(
450         address owner,
451         address operator
452     )
453         public
454         view
455         returns (bool)
456     {
457         return _operatorApprovals[owner][operator];
458     }
459 
460     /**
461     * @dev Transfers the ownership of a given token ID to another address
462     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
463     * Requires the msg sender to be the owner, approved, or operator
464     * @param from current owner of the token
465     * @param to address to receive the ownership of the given token ID
466     * @param tokenId uint256 ID of the token to be transferred
467     */
468     function transferFrom(
469         address from,
470         address to,
471         uint256 tokenId
472     )
473         public
474     {
475         require(_isApprovedOrOwner(msg.sender, tokenId));
476         require(to != address(0));
477 
478         _clearApproval(from, tokenId);
479         _removeTokenFrom(from, tokenId);
480         _addTokenTo(to, tokenId);
481 
482         emit Transfer(from, to, tokenId);
483     }
484 
485     /**
486     * @dev Safely transfers the ownership of a given token ID to another address
487     * If the target address is a contract, it must implement `onERC721Received`,
488     * which is called upon a safe transfer, and return the magic value
489     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
490     * the transfer is reverted.
491     *
492     * Requires the msg sender to be the owner, approved, or operator
493     * @param from current owner of the token
494     * @param to address to receive the ownership of the given token ID
495     * @param tokenId uint256 ID of the token to be transferred
496     */
497     function safeTransferFrom(
498         address from,
499         address to,
500         uint256 tokenId
501     )
502         public
503     {
504         // solium-disable-next-line arg-overflow
505         safeTransferFrom(from, to, tokenId, "");
506     }
507 
508     /**
509     * @dev Safely transfers the ownership of a given token ID to another address
510     * If the target address is a contract, it must implement `onERC721Received`,
511     * which is called upon a safe transfer, and return the magic value
512     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
513     * the transfer is reverted.
514     * Requires the msg sender to be the owner, approved, or operator
515     * @param from current owner of the token
516     * @param to address to receive the ownership of the given token ID
517     * @param tokenId uint256 ID of the token to be transferred
518     * @param _data bytes data to send along with a safe transfer check
519     */
520     function safeTransferFrom(
521         address from,
522         address to,
523         uint256 tokenId,
524         bytes memory _data
525     )
526         public
527     {
528         transferFrom(from, to, tokenId);
529         // solium-disable-next-line arg-overflow
530         require(_checkAndCallSafeTransfer(from, to, tokenId, _data));
531     }
532 
533     /**
534     * @dev Returns whether the specified token exists
535     * @param tokenId uint256 ID of the token to query the existence of
536     * @return whether the token exists
537     */
538     function _exists(uint256 tokenId) internal view returns (bool) {
539         address owner = _tokenOwner[tokenId];
540         return owner != address(0);
541     }
542 
543     /**
544     * @dev Returns whether the given spender can transfer a given token ID
545     * @param spender address of the spender to query
546     * @param tokenId uint256 ID of the token to be transferred
547     * @return bool whether the msg.sender is approved for the given token ID,
548     *  is an operator of the owner, or is the owner of the token
549     */
550     function _isApprovedOrOwner(
551         address spender,
552         uint256 tokenId
553     )
554         internal
555         view
556         returns (bool)
557     {
558         address owner = ownerOf(tokenId);
559         // Disable solium check because of
560         // https://github.com/duaraghav8/Solium/issues/175
561         // solium-disable-next-line operator-whitespace
562         return (
563         spender == owner ||
564         getApproved(tokenId) == spender ||
565         isApprovedForAll(owner, spender)
566         );
567     }
568 
569     /**
570     * @dev Internal function to mint a new token
571     * Reverts if the given token ID already exists
572     * @param to The address that will own the minted token
573     * @param tokenId uint256 ID of the token to be minted by the msg.sender
574     */
575     function _mint(address to, uint256 tokenId) internal {
576         require(to != address(0));
577         _addTokenTo(to, tokenId);
578         emit Transfer(address(0), to, tokenId);
579     }
580 
581     /**
582     * @dev Internal function to burn a specific token
583     * Reverts if the token does not exist
584     * @param tokenId uint256 ID of the token being burned by the msg.sender
585     */
586     function _burn(address owner, uint256 tokenId) internal {
587         _clearApproval(owner, tokenId);
588         _removeTokenFrom(owner, tokenId);
589         emit Transfer(owner, address(0), tokenId);
590     }
591 
592     /**
593     * @dev Internal function to clear current approval of a given token ID
594     * Reverts if the given address is not indeed the owner of the token
595     * @param owner owner of the token
596     * @param tokenId uint256 ID of the token to be transferred
597     */
598     function _clearApproval(address owner, uint256 tokenId) internal {
599         require(ownerOf(tokenId) == owner);
600         if (_tokenApprovals[tokenId] != address(0)) {
601             _tokenApprovals[tokenId] = address(0);
602         }
603     }
604 
605     /**
606     * @dev Internal function to add a token ID to the list of a given address
607     * @param to address representing the new owner of the given token ID
608     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
609     */
610     function _addTokenTo(address to, uint256 tokenId) internal {
611         require(_tokenOwner[tokenId] == address(0));
612         _tokenOwner[tokenId] = to;
613         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
614     }
615 
616     /**
617     * @dev Internal function to remove a token ID from the list of a given address
618     * @param from address representing the previous owner of the given token ID
619     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
620     */
621     function _removeTokenFrom(address from, uint256 tokenId) internal {
622         require(ownerOf(tokenId) == from);
623         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
624         _tokenOwner[tokenId] = address(0);
625     }
626 
627     /**
628     * @dev Internal function to invoke `onERC721Received` on a target address
629     * The call is not executed if the target address is not a contract
630     * @param from address representing the previous owner of the given token ID
631     * @param to target address that will receive the tokens
632     * @param tokenId uint256 ID of the token to be transferred
633     * @param _data bytes optional data to send along with the call
634     * @return whether the call correctly returned the expected magic value
635     */
636     function _checkAndCallSafeTransfer(
637         address from,
638         address to,
639         uint256 tokenId,
640         bytes memory _data
641     )
642         internal
643         returns (bool)
644     {
645         if (!to.isContract()) {
646             return true;
647         }
648         bytes4 retval = IERC721Receiver(to).onERC721Received(
649         msg.sender, from, tokenId, _data);
650         return (retval == _ERC721_RECEIVED);
651     }
652 }
653 
654 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
655     // Mapping from owner to list of owned token IDs
656     mapping(address => uint256[]) private _ownedTokens;
657 
658     // Mapping from token ID to index of the owner tokens list
659     mapping(uint256 => uint256) private _ownedTokensIndex;
660 
661     // Array with all token ids, used for enumeration
662     uint256[] private _allTokens;
663 
664     // Mapping from token id to position in the allTokens array
665     mapping(uint256 => uint256) private _allTokensIndex;
666 
667     bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
668     /**
669     * 0x780e9d63 ===
670     *   bytes4(keccak256('totalSupply()')) ^
671     *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
672     *   bytes4(keccak256('tokenByIndex(uint256)'))
673     */
674 
675     /**
676     * @dev Constructor function
677     */
678     constructor() public {
679         // register the supported interface to conform to ERC721 via ERC165
680         _registerInterface(_InterfaceId_ERC721Enumerable);
681     }
682 
683     /**
684     * @dev Gets the token ID at a given index of the tokens list of the requested owner
685     * @param owner address owning the tokens list to be accessed
686     * @param index uint256 representing the index to be accessed of the requested tokens list
687     * @return uint256 token ID at the given index of the tokens list owned by the requested address
688     */
689     function tokenOfOwnerByIndex(
690         address owner,
691         uint256 index
692     )
693         public
694         view
695         returns (uint256)
696     {
697         require(index < balanceOf(owner));
698         return _ownedTokens[owner][index];
699     }
700 
701     /**
702     * @dev Gets the total amount of tokens stored by the contract
703     * @return uint256 representing the total amount of tokens
704     */
705     function totalSupply() public view returns (uint256) {
706         return _allTokens.length;
707     }
708 
709     /**
710     * @dev Gets the token ID at a given index of all the tokens in this contract
711     * Reverts if the index is greater or equal to the total number of tokens
712     * @param index uint256 representing the index to be accessed of the tokens list
713     * @return uint256 token ID at the given index of the tokens list
714     */
715     function tokenByIndex(uint256 index) public view returns (uint256) {
716         require(index < totalSupply());
717         return _allTokens[index];
718     }
719 
720     /**
721     * @dev Internal function to add a token ID to the list of a given address
722     * @param to address representing the new owner of the given token ID
723     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
724     */
725     function _addTokenTo(address to, uint256 tokenId) internal {
726         super._addTokenTo(to, tokenId);
727         uint256 length = _ownedTokens[to].length;
728         _ownedTokens[to].push(tokenId);
729         _ownedTokensIndex[tokenId] = length;
730     }
731 
732     /**
733     * @dev Internal function to remove a token ID from the list of a given address
734     * @param from address representing the previous owner of the given token ID
735     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
736     */
737     function _removeTokenFrom(address from, uint256 tokenId) internal {
738         super._removeTokenFrom(from, tokenId);
739 
740         // To prevent a gap in the array, we store the last token in the index of the token to delete, and
741         // then delete the last slot.
742         uint256 tokenIndex = _ownedTokensIndex[tokenId];
743         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
744         uint256 lastToken = _ownedTokens[from][lastTokenIndex];
745 
746         _ownedTokens[from][tokenIndex] = lastToken;
747         // This also deletes the contents at the last position of the array
748         _ownedTokens[from].length--;
749 
750         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
751         // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
752         // the lastToken to the first position, and then dropping the element placed in the last position of the list
753 
754         _ownedTokensIndex[tokenId] = 0;
755         _ownedTokensIndex[lastToken] = tokenIndex;
756     }
757 
758     /**
759     * @dev Internal function to mint a new token
760     * Reverts if the given token ID already exists
761     * @param to address the beneficiary that will own the minted token
762     * @param tokenId uint256 ID of the token to be minted by the msg.sender
763     */
764     function _mint(address to, uint256 tokenId) internal {
765         super._mint(to, tokenId);
766 
767         _allTokensIndex[tokenId] = _allTokens.length;
768         _allTokens.push(tokenId);
769     }
770 
771     /**
772     * @dev Internal function to burn a specific token
773     * Reverts if the token does not exist
774     * @param owner owner of the token to burn
775     * @param tokenId uint256 ID of the token being burned by the msg.sender
776     */
777     function _burn(address owner, uint256 tokenId) internal {
778         super._burn(owner, tokenId);
779 
780         // Reorg all tokens array
781         uint256 tokenIndex = _allTokensIndex[tokenId];
782         uint256 lastTokenIndex = _allTokens.length.sub(1);
783         uint256 lastToken = _allTokens[lastTokenIndex];
784 
785         _allTokens[tokenIndex] = lastToken;
786         _allTokens[lastTokenIndex] = 0;
787 
788         _allTokens.length--;
789         _allTokensIndex[tokenId] = 0;
790         _allTokensIndex[lastToken] = tokenIndex;
791     }
792 }
793 
794 
795 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
796     // Token name
797     string internal _name;
798 
799     // Token symbol
800     string internal _symbol;
801 
802     // Optional mapping for token URIs
803     mapping(uint256 => string) private _tokenURIs;
804 
805     bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
806     /**
807     * 0x5b5e139f ===
808     *   bytes4(keccak256('name()')) ^
809     *   bytes4(keccak256('symbol()')) ^
810     *   bytes4(keccak256('tokenURI(uint256)'))
811     */
812 
813     /**
814     * @dev Constructor function
815     */
816     constructor(string memory name, string memory symbol) public {
817         _name = name;
818         _symbol = symbol;
819 
820         // register the supported interfaces to conform to ERC721 via ERC165
821         _registerInterface(InterfaceId_ERC721Metadata);
822     }
823 
824     /**
825     * @dev Gets the token name
826     * @return string representing the token name
827     */
828     function name() external view returns (string memory) {
829         return _name;
830     }
831 
832     /**
833     * @dev Gets the token symbol
834     * @return string representing the token symbol
835     */
836     function symbol() external view returns (string memory) {
837         return _symbol;
838     }
839 
840     /**
841     * @dev Returns an URI for a given token ID
842     * Throws if the token ID does not exist. May return an empty string.
843     * @param tokenId uint256 ID of the token to query
844     */
845     function tokenURI(uint256 tokenId) public view returns (string memory) {
846         require(_exists(tokenId));
847         return _tokenURIs[tokenId];
848     }
849 
850     /**
851     * @dev Internal function to set the token URI for a given token
852     * Reverts if the token ID does not exist
853     * @param tokenId uint256 ID of the token to set its URI
854     * @param uri string URI to assign
855     */
856     function _setTokenURI(uint256 tokenId, string memory uri) internal {
857         require(_exists(tokenId));
858         _tokenURIs[tokenId] = uri;
859     }
860 
861     /**
862     * @dev Internal function to burn a specific token
863     * Reverts if the token does not exist
864     * @param owner owner of the token to burn
865     * @param tokenId uint256 ID of the token being burned by the msg.sender
866     */
867     function _burn(address owner, uint256 tokenId) internal {
868         super._burn(owner, tokenId);
869 
870         // Clear metadata (if any)
871         if (bytes(_tokenURIs[tokenId]).length != 0) {
872             delete _tokenURIs[tokenId];
873         }
874     }
875 }
876 
877 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
878   
879     constructor(string memory name, string memory symbol) ERC721Metadata(name, symbol) public {
880 
881     }
882 
883 }
884 
885 contract Collectables is ERC721Full("GU Collectable", "TRINKET"), Ownable {
886 
887     using Strings for string;
888 
889     // delegate item specific storage/logic to other contracts
890     // one main contract manages transfers etc
891     mapping(uint32 => address) public delegates;
892 
893     // use uint32s instead of addresses to reduce the storage size needed
894     // individual token properties should be stored in the delegate contract
895     uint32[] public collectables;
896     uint public delegateCount;
897 
898     event DelegateAdded(address indexed delegate, uint32 indexed delegateID);
899 
900     function addDelegate(address delegate) public onlyOwner {
901         uint32 delegateID = uint32(delegateCount++);
902         // should never happen, but check anyway
903         require(delegates[delegateID] == address(0), "delegate is already set for collectable type");
904         delegates[delegateID] = delegate;
905         emit DelegateAdded(delegate, delegateID);
906     }
907 
908     function mint(uint32 delegateID, address to) public {
909         Delegate delegate = getDelegate(delegateID);
910         require(delegate.mint(msg.sender, to), "delegate could not mint token");
911         uint id = collectables.push(delegateID) - 1;
912         super._mint(to, id);
913     }
914 
915     function transferFrom(address from, address to, uint256 tokenId) public {
916         Delegate delegate = getTokenDelegate(tokenId);
917         require(delegate.transferFrom(msg.sender, from, to, tokenId), "could not transfer token");
918         super.transferFrom(from, to, tokenId);
919     }
920 
921     function approve(address to, uint256 tokenId) public {
922         Delegate delegate = getTokenDelegate(tokenId);
923         require(delegate.approve(msg.sender, to, tokenId), "could not approve token");
924         super.approve(to, tokenId);
925     }
926 
927     function safeTransferFrom(address from, address to, uint256 tokenId, bytes data) public {
928         Delegate delegate = getTokenDelegate(tokenId);
929         require(delegate.safeTransferFrom(msg.sender, from, to, tokenId, data), "could not safe transfer token");
930         super.safeTransferFrom(from, to, tokenId, data);
931     }
932 
933     function safeTransferFrom(address from, address to, uint256 tokenId) public {
934         Delegate delegate = getTokenDelegate(tokenId);
935         require(delegate.safeTransferFrom(msg.sender, from, to, tokenId), "could not safe transfer token");
936         super.safeTransferFrom(from, to, tokenId);
937     }
938 
939     function getTokenDelegate(uint id) public view returns (Delegate) {
940         address d = delegates[collectables[id]];
941         require(d != address(0), "invalid delegate");
942         return Delegate(d);
943     }
944 
945     function getDelegate(uint32 id) public view returns (Delegate) {
946         address d = delegates[id];
947         require(d != address(0), "invalid delegate");
948         return Delegate(d);
949     }
950 
951     string public constant tokenMetadataBaseURI = "https://api.godsunchained.com/collectable/";
952 
953     function tokenURI(uint256 _tokenId) public view returns (string memory) {
954         require(_exists(_tokenId), "token doesn't exist");
955         return Strings.strConcat(
956             tokenMetadataBaseURI,
957             Strings.uint2str(_tokenId)
958         );
959     }
960 
961     
962 
963 }