1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title IERC165
5  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
6  */
7 interface IERC165 {
8 
9   /**
10    * @notice Query if a contract implements an interface
11    * @param interfaceId The interface identifier, as specified in ERC-165
12    * @dev Interface identification is specified in ERC-165. This function
13    * uses less than 30,000 gas.
14    */
15   function supportsInterface(bytes4 interfaceId)
16     external
17     view
18     returns (bool);
19 }
20 
21 
22 /**
23  * @title ERC721 Non-Fungible Token Standard basic interface
24  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
25  */
26 contract IERC721 is IERC165 {
27 
28   event Transfer(
29     address indexed from,
30     address indexed to,
31     uint256 indexed tokenId
32   );
33   event Approval(
34     address indexed owner,
35     address indexed approved,
36     uint256 indexed tokenId
37   );
38   event ApprovalForAll(
39     address indexed owner,
40     address indexed operator,
41     bool approved
42   );
43 
44   function balanceOf(address owner) public view returns (uint256 balance);
45   function ownerOf(uint256 tokenId) public view returns (address owner);
46 
47   function approve(address to, uint256 tokenId) public;
48   function getApproved(uint256 tokenId)
49     public view returns (address operator);
50 
51   function setApprovalForAll(address operator, bool _approved) public;
52   function isApprovedForAll(address owner, address operator)
53     public view returns (bool);
54 
55   function transferFrom(address from, address to, uint256 tokenId) public;
56   function safeTransferFrom(address from, address to, uint256 tokenId)
57     public;
58 
59   function safeTransferFrom(
60     address from,
61     address to,
62     uint256 tokenId,
63     bytes data
64   )
65     public;
66 }
67 
68 
69 /**
70  * @title ERC721 token receiver interface
71  * @dev Interface for any contract that wants to support safeTransfers
72  * from ERC721 asset contracts.
73  */
74 contract IERC721Receiver {
75   /**
76    * @notice Handle the receipt of an NFT
77    * @dev The ERC721 smart contract calls this function on the recipient
78    * after a `safeTransfer`. This function MUST return the function selector,
79    * otherwise the caller will revert the transaction. The selector to be
80    * returned can be obtained as `this.onERC721Received.selector`. This
81    * function MAY throw to revert and reject the transfer.
82    * Note: the ERC721 contract address is always the message sender.
83    * @param operator The address which called `safeTransferFrom` function
84    * @param from The address which previously owned the token
85    * @param tokenId The NFT identifier which is being transferred
86    * @param data Additional data with no specified format
87    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
88    */
89   function onERC721Received(
90     address operator,
91     address from,
92     uint256 tokenId,
93     bytes data
94   )
95     public
96     returns(bytes4);
97 }
98 
99 
100 /**
101  * @title SafeMath
102  * @dev Math operations with safety checks that revert on error
103  */
104 library SafeMath {
105 
106   /**
107   * @dev Multiplies two numbers, reverts on overflow.
108   */
109   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
111     // benefit is lost if 'b' is also tested.
112     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
113     if (a == 0) {
114       return 0;
115     }
116 
117     uint256 c = a * b;
118     require(c / a == b);
119 
120     return c;
121   }
122 
123   /**
124   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
125   */
126   function div(uint256 a, uint256 b) internal pure returns (uint256) {
127     require(b > 0); // Solidity only automatically asserts when dividing by 0
128     uint256 c = a / b;
129     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130 
131     return c;
132   }
133 
134   /**
135   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
136   */
137   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138     require(b <= a);
139     uint256 c = a - b;
140 
141     return c;
142   }
143 
144   /**
145   * @dev Adds two numbers, reverts on overflow.
146   */
147   function add(uint256 a, uint256 b) internal pure returns (uint256) {
148     uint256 c = a + b;
149     require(c >= a);
150 
151     return c;
152   }
153 
154   /**
155   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
156   * reverts when dividing by zero.
157   */
158   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159     require(b != 0);
160     return a % b;
161   }
162 }
163 
164 
165 /**
166  * Utility library of inline functions on addresses
167  */
168 library Address {
169 
170   /**
171    * Returns whether the target address is a contract
172    * @dev This function will return false if invoked during the constructor of a contract,
173    * as the code is not actually created until after the constructor finishes.
174    * @param account address of the account to check
175    * @return whether the target address is a contract
176    */
177   function isContract(address account) internal view returns (bool) {
178     uint256 size;
179     // XXX Currently there is no better way to check if there is a contract in an address
180     // than to check the size of the code at that address.
181     // See https://ethereum.stackexchange.com/a/14016/36603
182     // for more details about how this works.
183     // TODO Check this again before the Serenity release, because all addresses will be
184     // contracts then.
185     // solium-disable-next-line security/no-inline-assembly
186     assembly { size := extcodesize(account) }
187     return size > 0;
188   }
189 
190 }
191 
192 
193 /**
194  * @title ERC165
195  * @author Matt Condon (@shrugs)
196  * @dev Implements ERC165 using a lookup table.
197  */
198 contract ERC165 is IERC165 {
199 
200   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
201   /**
202    * 0x01ffc9a7 ===
203    *   bytes4(keccak256('supportsInterface(bytes4)'))
204    */
205 
206   /**
207    * @dev a mapping of interface id to whether or not it's supported
208    */
209   mapping(bytes4 => bool) private _supportedInterfaces;
210 
211   /**
212    * @dev A contract implementing SupportsInterfaceWithLookup
213    * implement ERC165 itself
214    */
215   constructor()
216     internal
217   {
218     _registerInterface(_InterfaceId_ERC165);
219   }
220 
221   /**
222    * @dev implement supportsInterface(bytes4) using a lookup table
223    */
224   function supportsInterface(bytes4 interfaceId)
225     external
226     view
227     returns (bool)
228   {
229     return _supportedInterfaces[interfaceId];
230   }
231 
232   /**
233    * @dev internal method for registering an interface
234    */
235   function _registerInterface(bytes4 interfaceId)
236     internal
237   {
238     require(interfaceId != 0xffffffff);
239     _supportedInterfaces[interfaceId] = true;
240   }
241 }
242 
243 
244 /**
245  * @title ERC721 Non-Fungible Token Standard basic implementation
246  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
247  */
248 contract ERC721 is ERC165, IERC721 {
249 
250   using SafeMath for uint256;
251   using Address for address;
252 
253   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
254   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
255   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
256 
257   // Mapping from token ID to owner
258   mapping (uint256 => address) private _tokenOwner;
259 
260   // Mapping from token ID to approved address
261   mapping (uint256 => address) private _tokenApprovals;
262 
263   // Mapping from owner to number of owned token
264   mapping (address => uint256) private _ownedTokensCount;
265 
266   // Mapping from owner to operator approvals
267   mapping (address => mapping (address => bool)) private _operatorApprovals;
268 
269   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
270   /*
271    * 0x80ac58cd ===
272    *   bytes4(keccak256('balanceOf(address)')) ^
273    *   bytes4(keccak256('ownerOf(uint256)')) ^
274    *   bytes4(keccak256('approve(address,uint256)')) ^
275    *   bytes4(keccak256('getApproved(uint256)')) ^
276    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
277    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
278    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
279    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
280    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
281    */
282 
283   constructor()
284     public
285   {
286     // register the supported interfaces to conform to ERC721 via ERC165
287     _registerInterface(_InterfaceId_ERC721);
288   }
289 
290   /**
291    * @dev Gets the balance of the specified address
292    * @param owner address to query the balance of
293    * @return uint256 representing the amount owned by the passed address
294    */
295   function balanceOf(address owner) public view returns (uint256) {
296     require(owner != address(0));
297     return _ownedTokensCount[owner];
298   }
299 
300   /**
301    * @dev Gets the owner of the specified token ID
302    * @param tokenId uint256 ID of the token to query the owner of
303    * @return owner address currently marked as the owner of the given token ID
304    */
305   function ownerOf(uint256 tokenId) public view returns (address) {
306     address owner = _tokenOwner[tokenId];
307     require(owner != address(0));
308     return owner;
309   }
310 
311   /**
312    * @dev Approves another address to transfer the given token ID
313    * The zero address indicates there is no approved address.
314    * There can only be one approved address per token at a given time.
315    * Can only be called by the token owner or an approved operator.
316    * @param to address to be approved for the given token ID
317    * @param tokenId uint256 ID of the token to be approved
318    */
319   function approve(address to, uint256 tokenId) public {
320     address owner = ownerOf(tokenId);
321     require(to != owner);
322     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
323 
324     _tokenApprovals[tokenId] = to;
325     emit Approval(owner, to, tokenId);
326   }
327 
328   /**
329    * @dev Gets the approved address for a token ID, or zero if no address set
330    * Reverts if the token ID does not exist.
331    * @param tokenId uint256 ID of the token to query the approval of
332    * @return address currently approved for the given token ID
333    */
334   function getApproved(uint256 tokenId) public view returns (address) {
335     require(_exists(tokenId));
336     return _tokenApprovals[tokenId];
337   }
338 
339   /**
340    * @dev Sets or unsets the approval of a given operator
341    * An operator is allowed to transfer all tokens of the sender on their behalf
342    * @param to operator address to set the approval
343    * @param approved representing the status of the approval to be set
344    */
345   function setApprovalForAll(address to, bool approved) public {
346     require(to != msg.sender);
347     _operatorApprovals[msg.sender][to] = approved;
348     emit ApprovalForAll(msg.sender, to, approved);
349   }
350 
351   /**
352    * @dev Tells whether an operator is approved by a given owner
353    * @param owner owner address which you want to query the approval of
354    * @param operator operator address which you want to query the approval of
355    * @return bool whether the given operator is approved by the given owner
356    */
357   function isApprovedForAll(
358     address owner,
359     address operator
360   )
361     public
362     view
363     returns (bool)
364   {
365     return _operatorApprovals[owner][operator];
366   }
367 
368   /**
369    * @dev Transfers the ownership of a given token ID to another address
370    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
371    * Requires the msg sender to be the owner, approved, or operator
372    * @param from current owner of the token
373    * @param to address to receive the ownership of the given token ID
374    * @param tokenId uint256 ID of the token to be transferred
375   */
376   function transferFrom(
377     address from,
378     address to,
379     uint256 tokenId
380   )
381     public
382   {
383     require(_isApprovedOrOwner(msg.sender, tokenId));
384     require(to != address(0));
385 
386     _clearApproval(from, tokenId);
387     _removeTokenFrom(from, tokenId);
388     _addTokenTo(to, tokenId);
389 
390     emit Transfer(from, to, tokenId);
391   }
392 
393   /**
394    * @dev Safely transfers the ownership of a given token ID to another address
395    * If the target address is a contract, it must implement `onERC721Received`,
396    * which is called upon a safe transfer, and return the magic value
397    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
398    * the transfer is reverted.
399    *
400    * Requires the msg sender to be the owner, approved, or operator
401    * @param from current owner of the token
402    * @param to address to receive the ownership of the given token ID
403    * @param tokenId uint256 ID of the token to be transferred
404   */
405   function safeTransferFrom(
406     address from,
407     address to,
408     uint256 tokenId
409   )
410     public
411   {
412     // solium-disable-next-line arg-overflow
413     safeTransferFrom(from, to, tokenId, "");
414   }
415 
416   /**
417    * @dev Safely transfers the ownership of a given token ID to another address
418    * If the target address is a contract, it must implement `onERC721Received`,
419    * which is called upon a safe transfer, and return the magic value
420    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
421    * the transfer is reverted.
422    * Requires the msg sender to be the owner, approved, or operator
423    * @param from current owner of the token
424    * @param to address to receive the ownership of the given token ID
425    * @param tokenId uint256 ID of the token to be transferred
426    * @param _data bytes data to send along with a safe transfer check
427    */
428   function safeTransferFrom(
429     address from,
430     address to,
431     uint256 tokenId,
432     bytes _data
433   )
434     public
435   {
436     transferFrom(from, to, tokenId);
437     // solium-disable-next-line arg-overflow
438     require(_checkOnERC721Received(from, to, tokenId, _data));
439   }
440 
441   /**
442    * @dev Returns whether the specified token exists
443    * @param tokenId uint256 ID of the token to query the existence of
444    * @return whether the token exists
445    */
446   function _exists(uint256 tokenId) internal view returns (bool) {
447     address owner = _tokenOwner[tokenId];
448     return owner != address(0);
449   }
450 
451   /**
452    * @dev Returns whether the given spender can transfer a given token ID
453    * @param spender address of the spender to query
454    * @param tokenId uint256 ID of the token to be transferred
455    * @return bool whether the msg.sender is approved for the given token ID,
456    *  is an operator of the owner, or is the owner of the token
457    */
458   function _isApprovedOrOwner(
459     address spender,
460     uint256 tokenId
461   )
462     internal
463     view
464     returns (bool)
465   {
466     address owner = ownerOf(tokenId);
467     // Disable solium check because of
468     // https://github.com/duaraghav8/Solium/issues/175
469     // solium-disable-next-line operator-whitespace
470     return (
471       spender == owner ||
472       getApproved(tokenId) == spender ||
473       isApprovedForAll(owner, spender)
474     );
475   }
476 
477   /**
478    * @dev Internal function to mint a new token
479    * Reverts if the given token ID already exists
480    * @param to The address that will own the minted token
481    * @param tokenId uint256 ID of the token to be minted by the msg.sender
482    */
483   function _mint(address to, uint256 tokenId) internal {
484     require(to != address(0));
485     _addTokenTo(to, tokenId);
486     emit Transfer(address(0), to, tokenId);
487   }
488 
489   /**
490    * @dev Internal function to burn a specific token
491    * Reverts if the token does not exist
492    * @param tokenId uint256 ID of the token being burned by the msg.sender
493    */
494   function _burn(address owner, uint256 tokenId) internal {
495     _clearApproval(owner, tokenId);
496     _removeTokenFrom(owner, tokenId);
497     emit Transfer(owner, address(0), tokenId);
498   }
499 
500   /**
501    * @dev Internal function to add a token ID to the list of a given address
502    * Note that this function is left internal to make ERC721Enumerable possible, but is not
503    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
504    * @param to address representing the new owner of the given token ID
505    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
506    */
507   function _addTokenTo(address to, uint256 tokenId) internal {
508     require(_tokenOwner[tokenId] == address(0));
509     _tokenOwner[tokenId] = to;
510     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
511   }
512 
513   /**
514    * @dev Internal function to remove a token ID from the list of a given address
515    * Note that this function is left internal to make ERC721Enumerable possible, but is not
516    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
517    * and doesn't clear approvals.
518    * @param from address representing the previous owner of the given token ID
519    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
520    */
521   function _removeTokenFrom(address from, uint256 tokenId) internal {
522     require(ownerOf(tokenId) == from);
523     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
524     _tokenOwner[tokenId] = address(0);
525   }
526 
527   /**
528    * @dev Internal function to invoke `onERC721Received` on a target address
529    * The call is not executed if the target address is not a contract
530    * @param from address representing the previous owner of the given token ID
531    * @param to target address that will receive the tokens
532    * @param tokenId uint256 ID of the token to be transferred
533    * @param _data bytes optional data to send along with the call
534    * @return whether the call correctly returned the expected magic value
535    */
536   function _checkOnERC721Received(
537     address from,
538     address to,
539     uint256 tokenId,
540     bytes _data
541   )
542     internal
543     returns (bool)
544   {
545     if (!to.isContract()) {
546       return true;
547     }
548     bytes4 retval = IERC721Receiver(to).onERC721Received(
549       msg.sender, from, tokenId, _data);
550     return (retval == _ERC721_RECEIVED);
551   }
552 
553   /**
554    * @dev Private function to clear current approval of a given token ID
555    * Reverts if the given address is not indeed the owner of the token
556    * @param owner owner of the token
557    * @param tokenId uint256 ID of the token to be transferred
558    */
559   function _clearApproval(address owner, uint256 tokenId) private {
560     require(ownerOf(tokenId) == owner);
561     if (_tokenApprovals[tokenId] != address(0)) {
562       _tokenApprovals[tokenId] = address(0);
563     }
564   }
565 }
566 
567 
568 /**
569  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
570  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
571  */
572 contract IERC721Metadata is IERC721 {
573   function name() external view returns (string);
574   function symbol() external view returns (string);
575   function tokenURI(uint256 tokenId) external view returns (string);
576 }
577 
578 
579 
580 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
581   // Token name
582   string private _name;
583 
584   // Token symbol
585   string private _symbol;
586 
587   // Optional mapping for token URIs
588   mapping(uint256 => string) private _tokenURIs;
589 
590   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
591   /**
592    * 0x5b5e139f ===
593    *   bytes4(keccak256('name()')) ^
594    *   bytes4(keccak256('symbol()')) ^
595    *   bytes4(keccak256('tokenURI(uint256)'))
596    */
597 
598   /**
599    * @dev Constructor function
600    */
601   constructor(string name, string symbol) public {
602     _name = name;
603     _symbol = symbol;
604 
605     // register the supported interfaces to conform to ERC721 via ERC165
606     _registerInterface(InterfaceId_ERC721Metadata);
607   }
608 
609   /**
610    * @dev Gets the token name
611    * @return string representing the token name
612    */
613   function name() external view returns (string) {
614     return _name;
615   }
616 
617   /**
618    * @dev Gets the token symbol
619    * @return string representing the token symbol
620    */
621   function symbol() external view returns (string) {
622     return _symbol;
623   }
624 
625   /**
626    * @dev Returns an URI for a given token ID
627    * Throws if the token ID does not exist. May return an empty string.
628    * @param tokenId uint256 ID of the token to query
629    */
630   function tokenURI(uint256 tokenId) external view returns (string) {
631     require(_exists(tokenId));
632     return _tokenURIs[tokenId];
633   }
634 
635   /**
636    * @dev Internal function to set the token URI for a given token
637    * Reverts if the token ID does not exist
638    * @param tokenId uint256 ID of the token to set its URI
639    * @param uri string URI to assign
640    */
641   function _setTokenURI(uint256 tokenId, string uri) internal {
642     require(_exists(tokenId));
643     _tokenURIs[tokenId] = uri;
644   }
645 
646   /**
647    * @dev Internal function to burn a specific token
648    * Reverts if the token does not exist
649    * @param owner owner of the token to burn
650    * @param tokenId uint256 ID of the token being burned by the msg.sender
651    */
652   function _burn(address owner, uint256 tokenId) internal {
653     super._burn(owner, tokenId);
654 
655     // Clear metadata (if any)
656     if (bytes(_tokenURIs[tokenId]).length != 0) {
657       delete _tokenURIs[tokenId];
658     }
659   }
660 }
661 
662 /**
663  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
664  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
665  */
666 contract IERC721Enumerable is IERC721 {
667   function totalSupply() public view returns (uint256);
668   function tokenOfOwnerByIndex(
669     address owner,
670     uint256 index
671   )
672     public
673     view
674     returns (uint256 tokenId);
675 
676   function tokenByIndex(uint256 index) public view returns (uint256);
677 }
678 
679 
680 
681 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
682   // Mapping from owner to list of owned token IDs
683   mapping(address => uint256[]) private _ownedTokens;
684 
685   // Mapping from token ID to index of the owner tokens list
686   mapping(uint256 => uint256) private _ownedTokensIndex;
687 
688   // Array with all token ids, used for enumeration
689   uint256[] private _allTokens;
690 
691   // Mapping from token id to position in the allTokens array
692   mapping(uint256 => uint256) private _allTokensIndex;
693 
694   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
695   /**
696    * 0x780e9d63 ===
697    *   bytes4(keccak256('totalSupply()')) ^
698    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
699    *   bytes4(keccak256('tokenByIndex(uint256)'))
700    */
701 
702   /**
703    * @dev Constructor function
704    */
705   constructor() public {
706     // register the supported interface to conform to ERC721 via ERC165
707     _registerInterface(_InterfaceId_ERC721Enumerable);
708   }
709 
710   /**
711    * @dev Gets the token ID at a given index of the tokens list of the requested owner
712    * @param owner address owning the tokens list to be accessed
713    * @param index uint256 representing the index to be accessed of the requested tokens list
714    * @return uint256 token ID at the given index of the tokens list owned by the requested address
715    */
716   function tokenOfOwnerByIndex(
717     address owner,
718     uint256 index
719   )
720     public
721     view
722     returns (uint256)
723   {
724     require(index < balanceOf(owner));
725     return _ownedTokens[owner][index];
726   }
727 
728   /**
729    * @dev Gets the total amount of tokens stored by the contract
730    * @return uint256 representing the total amount of tokens
731    */
732   function totalSupply() public view returns (uint256) {
733     return _allTokens.length;
734   }
735 
736   /**
737    * @dev Gets the token ID at a given index of all the tokens in this contract
738    * Reverts if the index is greater or equal to the total number of tokens
739    * @param index uint256 representing the index to be accessed of the tokens list
740    * @return uint256 token ID at the given index of the tokens list
741    */
742   function tokenByIndex(uint256 index) public view returns (uint256) {
743     require(index < totalSupply());
744     return _allTokens[index];
745   }
746 
747   /**
748    * @dev Internal function to add a token ID to the list of a given address
749    * This function is internal due to language limitations, see the note in ERC721.sol.
750    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
751    * @param to address representing the new owner of the given token ID
752    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
753    */
754   function _addTokenTo(address to, uint256 tokenId) internal {
755     super._addTokenTo(to, tokenId);
756     uint256 length = _ownedTokens[to].length;
757     _ownedTokens[to].push(tokenId);
758     _ownedTokensIndex[tokenId] = length;
759   }
760 
761   /**
762    * @dev Internal function to remove a token ID from the list of a given address
763    * This function is internal due to language limitations, see the note in ERC721.sol.
764    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
765    * and doesn't clear approvals.
766    * @param from address representing the previous owner of the given token ID
767    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
768    */
769   function _removeTokenFrom(address from, uint256 tokenId) internal {
770     super._removeTokenFrom(from, tokenId);
771 
772     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
773     // then delete the last slot.
774     uint256 tokenIndex = _ownedTokensIndex[tokenId];
775     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
776     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
777 
778     _ownedTokens[from][tokenIndex] = lastToken;
779     // This also deletes the contents at the last position of the array
780     _ownedTokens[from].length--;
781 
782     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
783     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
784     // the lastToken to the first position, and then dropping the element placed in the last position of the list
785 
786     _ownedTokensIndex[tokenId] = 0;
787     _ownedTokensIndex[lastToken] = tokenIndex;
788   }
789 
790   /**
791    * @dev Internal function to mint a new token
792    * Reverts if the given token ID already exists
793    * @param to address the beneficiary that will own the minted token
794    * @param tokenId uint256 ID of the token to be minted by the msg.sender
795    */
796   function _mint(address to, uint256 tokenId) internal {
797     super._mint(to, tokenId);
798 
799     _allTokensIndex[tokenId] = _allTokens.length;
800     _allTokens.push(tokenId);
801   }
802 
803   /**
804    * @dev Internal function to burn a specific token
805    * Reverts if the token does not exist
806    * @param owner owner of the token to burn
807    * @param tokenId uint256 ID of the token being burned by the msg.sender
808    */
809   function _burn(address owner, uint256 tokenId) internal {
810     super._burn(owner, tokenId);
811 
812     // Reorg all tokens array
813     uint256 tokenIndex = _allTokensIndex[tokenId];
814     uint256 lastTokenIndex = _allTokens.length.sub(1);
815     uint256 lastToken = _allTokens[lastTokenIndex];
816 
817     _allTokens[tokenIndex] = lastToken;
818     _allTokens[lastTokenIndex] = 0;
819 
820     _allTokens.length--;
821     _allTokensIndex[tokenId] = 0;
822     _allTokensIndex[lastToken] = tokenIndex;
823   }
824 }
825 
826 
827 
828 
829 
830 /**
831  * @title Full ERC721 Token
832  * This implementation includes all the required and some optional functionality of the ERC721 standard
833  * Moreover, it includes approve all functionality using operator terminology
834  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
835  */
836 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
837   constructor(string name, string symbol) ERC721Metadata(name, symbol)
838     public
839   {
840   }
841 }
842 
843 
844 /**
845  * @title Ownable
846  * @dev The Ownable contract has an owner address, and provides basic authorization control
847  * functions, this simplifies the implementation of "user permissions".
848  */
849 contract Ownable {
850   address private _owner;
851 
852   event OwnershipTransferred(
853     address indexed previousOwner,
854     address indexed newOwner
855   );
856 
857   /**
858    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
859    * account.
860    */
861   constructor() internal {
862     _owner = msg.sender;
863     emit OwnershipTransferred(address(0), _owner);
864   }
865 
866   /**
867    * @return the address of the owner.
868    */
869   function owner() public view returns(address) {
870     return _owner;
871   }
872 
873   /**
874    * @dev Throws if called by any account other than the owner.
875    */
876   modifier onlyOwner() {
877     require(isOwner());
878     _;
879   }
880 
881   /**
882    * @return true if `msg.sender` is the owner of the contract.
883    */
884   function isOwner() public view returns(bool) {
885     return msg.sender == _owner;
886   }
887 
888   /**
889    * @dev Allows the current owner to relinquish control of the contract.
890    * @notice Renouncing to ownership will leave the contract without an owner.
891    * It will not be possible to call the functions with the `onlyOwner`
892    * modifier anymore.
893    */
894   function renounceOwnership() public onlyOwner {
895     emit OwnershipTransferred(_owner, address(0));
896     _owner = address(0);
897   }
898 
899   /**
900    * @dev Allows the current owner to transfer control of the contract to a newOwner.
901    * @param newOwner The address to transfer ownership to.
902    */
903   function transferOwnership(address newOwner) public onlyOwner {
904     _transferOwnership(newOwner);
905   }
906 
907   /**
908    * @dev Transfers control of the contract to a newOwner.
909    * @param newOwner The address to transfer ownership to.
910    */
911   function _transferOwnership(address newOwner) internal {
912     require(newOwner != address(0));
913     emit OwnershipTransferred(_owner, newOwner);
914     _owner = newOwner;
915   }
916 }
917 
918 
919 contract SuperStarsCardInfo is Ownable {
920     using SafeMath for uint64;
921     using SafeMath for uint256;
922 
923     struct CardInfo {
924         // The Hash value of crypto asset
925         bytes32 cardHash;
926         // Card Type
927         string cardType;
928         // Card name
929         string name;
930         // Total issue amount
931         uint64 totalIssue;
932         // Timestamp of issued card
933         uint64 issueTime;
934     }
935 
936     // All of issued card info
937     CardInfo[] cardInfos;
938     // Mapping from cardinfo id to position in the cardInfos array
939     mapping(uint256 => uint256) cardInfosIndex;
940 
941     // An array of card type string
942     string[] cardTypes;
943 
944     // The mapping value that checking card info exist.
945     mapping(bytes32 => bool) cardHashToExist;
946     mapping(uint256 => uint64) cardInfoIdToIssueCnt;
947     mapping(uint256 => mapping(uint64 => bool)) cardInfoIdToIssueNumToExist;
948 
949     constructor() public
950     {
951         CardInfo memory _cardInfo = CardInfo({
952             cardHash: 0,
953             name: "",
954             cardType: "",
955             totalIssue: 0,
956             issueTime: uint64(now)
957         });
958         cardInfos.push(_cardInfo);
959 
960         _addCardType("None");
961         _addCardType("Normal1");
962         _addCardType("Normal2");
963         _addCardType("Rare");
964         _addCardType("Epic");
965 
966     }
967 
968     function _addCardType(string _cardType) internal onlyOwner returns (uint256) {
969         require(bytes(_cardType).length > 0, "_cardType length must be greater than 0.");
970         return cardTypes.push(_cardType);
971     }
972 
973     function addCardType(string _cardType) external onlyOwner returns (uint256) {
974         return _addCardType(_cardType);
975     }
976 
977     function getCardTypeCount() external view returns (uint256) {
978         return cardTypes.length;
979     }
980 
981     function getCardTypeByIndex(uint64 _index) external view returns (string) {
982         return cardTypes[_index];
983     }
984 
985     // Internal function that add new card info
986     function _addCardInfo(
987         uint256 _cardInfoId,
988         bytes32 _cardHash,
989         string _name,
990         uint64 _cardTypeIndex,
991         uint64 _totalIssue
992     )
993         internal
994     {
995         // Input value can NOT exceed cardTypes length
996         require(_cardTypeIndex < cardTypes.length, "CardTypeIndex can NOT exceed the cardTypes length.");
997         // Only allow adding card infos that have NOT already been added.
998         require(cardHashToExist[_cardHash] == false, "Only allow adding card info that have NOT already been added.");
999 
1000         CardInfo memory _cardInfo = CardInfo({
1001             cardHash: _cardHash,
1002             name: _name,
1003             cardType: cardTypes[_cardTypeIndex],
1004             totalIssue: _totalIssue,
1005             issueTime: uint64(now)
1006         });
1007 
1008         // Mapping for prevent additional issuance of already issued cards.
1009         cardHashToExist[_cardHash] = true;
1010 
1011         cardInfosIndex[_cardInfoId] = cardInfos.length;
1012         cardInfos.push(_cardInfo);
1013         cardInfoIdToIssueCnt[_cardInfoId] = 0;
1014     }
1015 
1016     // External function that add card info
1017     // Only allow to admin(Owner)
1018     function addCardInfo(
1019         uint256 _cardInfoId,
1020         bytes32 _cardHash,
1021         string _name,
1022         uint64 _cardTypeIndex,
1023         uint64 _totalIssue
1024     )
1025         external
1026         onlyOwner
1027     {
1028         _addCardInfo(_cardInfoId, _cardHash, _name, _cardTypeIndex, _totalIssue);
1029     }
1030 
1031     function getCardInfo(
1032         uint256 _cardInfoId
1033     )
1034         external
1035         view
1036         returns (
1037             bytes32 cardHash,
1038             string name,
1039             string cardType,
1040             uint64 totalIssue,
1041             uint64 issueTime
1042     ) {
1043         CardInfo memory cardInfo = cardInfos[cardInfosIndex[_cardInfoId]];
1044         cardHash = cardInfo.cardHash;
1045         name = cardInfo.name;
1046         cardType = cardInfo.cardType;
1047         totalIssue = cardInfo.totalIssue;
1048         issueTime = cardInfo.issueTime;
1049     }
1050 
1051     function getInfosLength() external view returns (uint256) {
1052         return cardInfos.length.sub(1);
1053     }
1054 
1055 }
1056 
1057 library Strings {
1058 
1059   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1060   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1061       bytes memory _ba = bytes(_a);
1062       bytes memory _bb = bytes(_b);
1063       bytes memory _bc = bytes(_c);
1064       bytes memory _bd = bytes(_d);
1065       bytes memory _be = bytes(_e);
1066       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1067       bytes memory babcde = bytes(abcde);
1068       uint k = 0;
1069       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1070       for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1071       for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1072       for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1073       for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1074       return string(babcde);
1075     }
1076 
1077     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1078         return strConcat(_a, _b, _c, _d, "");
1079     }
1080 
1081     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1082         return strConcat(_a, _b, _c, "", "");
1083     }
1084 
1085     function strConcat(string _a, string _b) internal pure returns (string) {
1086         return strConcat(_a, _b, "", "", "");
1087     }
1088 
1089     function uint2str(uint i) internal pure returns (string) {
1090         if (i == 0) return "0";
1091         uint j = i;
1092         uint len;
1093         while (j != 0){
1094             len++;
1095             j /= 10;
1096         }
1097         bytes memory bstr = new bytes(len);
1098         uint k = len - 1;
1099         while (i != 0){
1100             bstr[k--] = byte(48 + i % 10);
1101             i /= 10;
1102         }
1103         return string(bstr);
1104     }
1105 }
1106 
1107 
1108 // New Conract begin here
1109 contract SuperStarsCard is SuperStarsCardInfo, ERC721Full {
1110 
1111     using Strings for string;
1112 
1113     struct Card {
1114         // CardInfo ID
1115         uint256 cardInfoId;
1116         // Issue Number
1117         uint64 issueNumber;
1118     }
1119 
1120     /*** STORAGE ***/
1121     // An array containing the card struct for all cards (all issued NFT) in existence.
1122     Card[] private cards;
1123     // Mapping from cardinfo id to position in the cards array
1124     mapping(uint256 => uint256) private cardsIndex;
1125 
1126     constructor(
1127         string name,
1128         string symbol
1129     )
1130         ERC721Full(name, symbol)
1131         public
1132     {
1133         require(bytes(name).length > 0 && bytes(symbol).length > 0, "Token name and symbol required.");
1134 
1135         Card memory _card = Card({
1136             cardInfoId: 0,
1137             issueNumber: 0
1138         });
1139         cards.push(_card);
1140     }
1141 
1142     // Base Token URI
1143     string private baseTokenURI;
1144 
1145     function getBaseTokenURI() public view returns (string) {
1146         return baseTokenURI;
1147     }
1148 
1149     function setBaseTokenURI(string _baseTokenURI) external onlyOwner {
1150         baseTokenURI = _baseTokenURI;
1151     }
1152 
1153     // test
1154     function getIssueNumberExist(uint256 _cardInfoId, uint64 _issueNumber) public view returns (bool) {
1155         return cardInfoIdToIssueNumToExist[_cardInfoId][_issueNumber];
1156     }
1157 
1158     function mintSuperStarsCard(
1159         uint256 _cardId,
1160         uint256 _cardInfoId,
1161         uint64 _issueNumber,
1162         address _receiver
1163     )
1164         external
1165         onlyOwner
1166         returns (bool)
1167     {
1168         CardInfo memory cardInfo = cardInfos[cardInfosIndex[_cardInfoId]];
1169         require(cardInfoIdToIssueCnt[_cardInfoId] < cardInfo.totalIssue, "Can NOT exceed total issue limit.");
1170         require(cardInfoIdToIssueNumToExist[_cardInfoId][_issueNumber] == false, "Issue number already exist.");
1171         require(_receiver != address(0), "Invalid receiver address.");
1172 
1173         cardInfoIdToIssueCnt[_cardInfoId] = cardInfoIdToIssueCnt[_cardInfoId] + 1;
1174         cardInfoIdToIssueNumToExist[_cardInfoId][_issueNumber] = true;
1175 
1176         require(bytes(baseTokenURI).length > 0, "You must enter the baseTokenURI first before issuing the card.");
1177 
1178         Card memory _card = Card({
1179             cardInfoId: _cardInfoId,
1180             issueNumber: _issueNumber
1181         });
1182 
1183         cardsIndex[_cardId] = cards.length;
1184         cards.push(_card);
1185         // uint256 cardTokenId = tokenId.next();
1186         _mint(_receiver, _cardId);
1187         _setTokenURI(_cardId, Strings.strConcat(getBaseTokenURI(), Strings.uint2str(_cardId)));
1188 
1189         return true;
1190     }
1191 
1192     function getCard(
1193         uint256 _cardTokenId
1194     )
1195         external
1196         view
1197         returns (
1198             string cardType,
1199             string name,
1200             bytes32 cardHash,
1201             uint64 totalIssue,
1202             uint64 issueNumber,
1203             uint64 issueTime
1204     ) {
1205         Card memory card = cards[cardsIndex[_cardTokenId]];
1206         CardInfo memory cardInfo = cardInfos[cardInfosIndex[card.cardInfoId]];
1207 
1208         cardType = cardInfo.cardType;
1209         name = cardInfo.name;
1210         cardHash = cardInfo.cardHash;
1211         totalIssue = cardInfo.totalIssue;
1212         issueNumber = card.issueNumber;
1213         issueTime = cardInfo.issueTime;
1214     }
1215 
1216 }