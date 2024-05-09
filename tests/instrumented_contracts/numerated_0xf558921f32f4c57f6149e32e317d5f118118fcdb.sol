1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
4 
5 /**
6  * @title IERC165
7  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
8  */
9 interface IERC165 {
10 
11   /**
12    * @notice Query if a contract implements an interface
13    * @param interfaceId The interface identifier, as specified in ERC-165
14    * @dev Interface identification is specified in ERC-165. This function
15    * uses less than 30,000 gas.
16    */
17   function supportsInterface(bytes4 interfaceId)
18     external
19     view
20     returns (bool);
21 }
22 
23 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
24 
25 /**
26  * @title ERC165
27  * @author Matt Condon (@shrugs)
28  * @dev Implements ERC165 using a lookup table.
29  */
30 contract ERC165 is IERC165 {
31 
32   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
33   /**
34    * 0x01ffc9a7 ===
35    *   bytes4(keccak256('supportsInterface(bytes4)'))
36    */
37 
38   /**
39    * @dev a mapping of interface id to whether or not it's supported
40    */
41   mapping(bytes4 => bool) private _supportedInterfaces;
42 
43   /**
44    * @dev A contract implementing SupportsInterfaceWithLookup
45    * implement ERC165 itself
46    */
47   constructor()
48     internal
49   {
50     _registerInterface(_InterfaceId_ERC165);
51   }
52 
53   /**
54    * @dev implement supportsInterface(bytes4) using a lookup table
55    */
56   function supportsInterface(bytes4 interfaceId)
57     external
58     view
59     returns (bool)
60   {
61     return _supportedInterfaces[interfaceId];
62   }
63 
64   /**
65    * @dev internal method for registering an interface
66    */
67   function _registerInterface(bytes4 interfaceId)
68     internal
69   {
70     require(interfaceId != 0xffffffff);
71     _supportedInterfaces[interfaceId] = true;
72   }
73 }
74 
75 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
76 
77 /**
78  * @title ERC721 Non-Fungible Token Standard basic interface
79  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
80  */
81 contract IERC721 is IERC165 {
82 
83   event Transfer(
84     address indexed from,
85     address indexed to,
86     uint256 indexed tokenId
87   );
88   event Approval(
89     address indexed owner,
90     address indexed approved,
91     uint256 indexed tokenId
92   );
93   event ApprovalForAll(
94     address indexed owner,
95     address indexed operator,
96     bool approved
97   );
98 
99   function balanceOf(address owner) public view returns (uint256 balance);
100   function ownerOf(uint256 tokenId) public view returns (address owner);
101 
102   function approve(address to, uint256 tokenId) public;
103   function getApproved(uint256 tokenId)
104     public view returns (address operator);
105 
106   function setApprovalForAll(address operator, bool _approved) public;
107   function isApprovedForAll(address owner, address operator)
108     public view returns (bool);
109 
110   function transferFrom(address from, address to, uint256 tokenId) public;
111   function safeTransferFrom(address from, address to, uint256 tokenId)
112     public;
113 
114   function safeTransferFrom(
115     address from,
116     address to,
117     uint256 tokenId,
118     bytes data
119   )
120     public;
121 }
122 
123 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
124 
125 /**
126  * @title ERC721 token receiver interface
127  * @dev Interface for any contract that wants to support safeTransfers
128  * from ERC721 asset contracts.
129  */
130 contract IERC721Receiver {
131   /**
132    * @notice Handle the receipt of an NFT
133    * @dev The ERC721 smart contract calls this function on the recipient
134    * after a `safeTransfer`. This function MUST return the function selector,
135    * otherwise the caller will revert the transaction. The selector to be
136    * returned can be obtained as `this.onERC721Received.selector`. This
137    * function MAY throw to revert and reject the transfer.
138    * Note: the ERC721 contract address is always the message sender.
139    * @param operator The address which called `safeTransferFrom` function
140    * @param from The address which previously owned the token
141    * @param tokenId The NFT identifier which is being transferred
142    * @param data Additional data with no specified format
143    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
144    */
145   function onERC721Received(
146     address operator,
147     address from,
148     uint256 tokenId,
149     bytes data
150   )
151     public
152     returns(bytes4);
153 }
154 
155 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
156 
157 /**
158  * @title SafeMath
159  * @dev Math operations with safety checks that revert on error
160  */
161 library SafeMath {
162 
163   /**
164   * @dev Multiplies two numbers, reverts on overflow.
165   */
166   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168     // benefit is lost if 'b' is also tested.
169     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
170     if (a == 0) {
171       return 0;
172     }
173 
174     uint256 c = a * b;
175     require(c / a == b);
176 
177     return c;
178   }
179 
180   /**
181   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
182   */
183   function div(uint256 a, uint256 b) internal pure returns (uint256) {
184     require(b > 0); // Solidity only automatically asserts when dividing by 0
185     uint256 c = a / b;
186     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
187 
188     return c;
189   }
190 
191   /**
192   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
193   */
194   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
195     require(b <= a);
196     uint256 c = a - b;
197 
198     return c;
199   }
200 
201   /**
202   * @dev Adds two numbers, reverts on overflow.
203   */
204   function add(uint256 a, uint256 b) internal pure returns (uint256) {
205     uint256 c = a + b;
206     require(c >= a);
207 
208     return c;
209   }
210 
211   /**
212   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
213   * reverts when dividing by zero.
214   */
215   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216     require(b != 0);
217     return a % b;
218   }
219 }
220 
221 // File: openzeppelin-solidity/contracts/utils/Address.sol
222 
223 /**
224  * Utility library of inline functions on addresses
225  */
226 library Address {
227 
228   /**
229    * Returns whether the target address is a contract
230    * @dev This function will return false if invoked during the constructor of a contract,
231    * as the code is not actually created until after the constructor finishes.
232    * @param account address of the account to check
233    * @return whether the target address is a contract
234    */
235   function isContract(address account) internal view returns (bool) {
236     uint256 size;
237     // XXX Currently there is no better way to check if there is a contract in an address
238     // than to check the size of the code at that address.
239     // See https://ethereum.stackexchange.com/a/14016/36603
240     // for more details about how this works.
241     // TODO Check this again before the Serenity release, because all addresses will be
242     // contracts then.
243     // solium-disable-next-line security/no-inline-assembly
244     assembly { size := extcodesize(account) }
245     return size > 0;
246   }
247 
248 }
249 
250 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
251 
252 /**
253  * @title ERC721 Non-Fungible Token Standard basic implementation
254  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
255  */
256 contract ERC721 is ERC165, IERC721 {
257 
258   using SafeMath for uint256;
259   using Address for address;
260 
261   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
262   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
263   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
264 
265   // Mapping from token ID to owner
266   mapping (uint256 => address) private _tokenOwner;
267 
268   // Mapping from token ID to approved address
269   mapping (uint256 => address) private _tokenApprovals;
270 
271   // Mapping from owner to number of owned token
272   mapping (address => uint256) private _ownedTokensCount;
273 
274   // Mapping from owner to operator approvals
275   mapping (address => mapping (address => bool)) private _operatorApprovals;
276 
277   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
278   /*
279    * 0x80ac58cd ===
280    *   bytes4(keccak256('balanceOf(address)')) ^
281    *   bytes4(keccak256('ownerOf(uint256)')) ^
282    *   bytes4(keccak256('approve(address,uint256)')) ^
283    *   bytes4(keccak256('getApproved(uint256)')) ^
284    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
285    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
286    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
287    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
288    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
289    */
290 
291   constructor()
292     public
293   {
294     // register the supported interfaces to conform to ERC721 via ERC165
295     _registerInterface(_InterfaceId_ERC721);
296   }
297 
298   /**
299    * @dev Gets the balance of the specified address
300    * @param owner address to query the balance of
301    * @return uint256 representing the amount owned by the passed address
302    */
303   function balanceOf(address owner) public view returns (uint256) {
304     require(owner != address(0));
305     return _ownedTokensCount[owner];
306   }
307 
308   /**
309    * @dev Gets the owner of the specified token ID
310    * @param tokenId uint256 ID of the token to query the owner of
311    * @return owner address currently marked as the owner of the given token ID
312    */
313   function ownerOf(uint256 tokenId) public view returns (address) {
314     address owner = _tokenOwner[tokenId];
315     require(owner != address(0));
316     return owner;
317   }
318 
319   /**
320    * @dev Approves another address to transfer the given token ID
321    * The zero address indicates there is no approved address.
322    * There can only be one approved address per token at a given time.
323    * Can only be called by the token owner or an approved operator.
324    * @param to address to be approved for the given token ID
325    * @param tokenId uint256 ID of the token to be approved
326    */
327   function approve(address to, uint256 tokenId) public {
328     address owner = ownerOf(tokenId);
329     require(to != owner);
330     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
331 
332     _tokenApprovals[tokenId] = to;
333     emit Approval(owner, to, tokenId);
334   }
335 
336   /**
337    * @dev Gets the approved address for a token ID, or zero if no address set
338    * Reverts if the token ID does not exist.
339    * @param tokenId uint256 ID of the token to query the approval of
340    * @return address currently approved for the given token ID
341    */
342   function getApproved(uint256 tokenId) public view returns (address) {
343     require(_exists(tokenId));
344     return _tokenApprovals[tokenId];
345   }
346 
347   /**
348    * @dev Sets or unsets the approval of a given operator
349    * An operator is allowed to transfer all tokens of the sender on their behalf
350    * @param to operator address to set the approval
351    * @param approved representing the status of the approval to be set
352    */
353   function setApprovalForAll(address to, bool approved) public {
354     require(to != msg.sender);
355     _operatorApprovals[msg.sender][to] = approved;
356     emit ApprovalForAll(msg.sender, to, approved);
357   }
358 
359   /**
360    * @dev Tells whether an operator is approved by a given owner
361    * @param owner owner address which you want to query the approval of
362    * @param operator operator address which you want to query the approval of
363    * @return bool whether the given operator is approved by the given owner
364    */
365   function isApprovedForAll(
366     address owner,
367     address operator
368   )
369     public
370     view
371     returns (bool)
372   {
373     return _operatorApprovals[owner][operator];
374   }
375 
376   /**
377    * @dev Transfers the ownership of a given token ID to another address
378    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
379    * Requires the msg sender to be the owner, approved, or operator
380    * @param from current owner of the token
381    * @param to address to receive the ownership of the given token ID
382    * @param tokenId uint256 ID of the token to be transferred
383   */
384   function transferFrom(
385     address from,
386     address to,
387     uint256 tokenId
388   )
389     public
390   {
391     require(_isApprovedOrOwner(msg.sender, tokenId));
392     require(to != address(0));
393 
394     _clearApproval(from, tokenId);
395     _removeTokenFrom(from, tokenId);
396     _addTokenTo(to, tokenId);
397 
398     emit Transfer(from, to, tokenId);
399   }
400 
401   /**
402    * @dev Safely transfers the ownership of a given token ID to another address
403    * If the target address is a contract, it must implement `onERC721Received`,
404    * which is called upon a safe transfer, and return the magic value
405    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
406    * the transfer is reverted.
407    *
408    * Requires the msg sender to be the owner, approved, or operator
409    * @param from current owner of the token
410    * @param to address to receive the ownership of the given token ID
411    * @param tokenId uint256 ID of the token to be transferred
412   */
413   function safeTransferFrom(
414     address from,
415     address to,
416     uint256 tokenId
417   )
418     public
419   {
420     // solium-disable-next-line arg-overflow
421     safeTransferFrom(from, to, tokenId, "");
422   }
423 
424   /**
425    * @dev Safely transfers the ownership of a given token ID to another address
426    * If the target address is a contract, it must implement `onERC721Received`,
427    * which is called upon a safe transfer, and return the magic value
428    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
429    * the transfer is reverted.
430    * Requires the msg sender to be the owner, approved, or operator
431    * @param from current owner of the token
432    * @param to address to receive the ownership of the given token ID
433    * @param tokenId uint256 ID of the token to be transferred
434    * @param _data bytes data to send along with a safe transfer check
435    */
436   function safeTransferFrom(
437     address from,
438     address to,
439     uint256 tokenId,
440     bytes _data
441   )
442     public
443   {
444     transferFrom(from, to, tokenId);
445     // solium-disable-next-line arg-overflow
446     require(_checkOnERC721Received(from, to, tokenId, _data));
447   }
448 
449   /**
450    * @dev Returns whether the specified token exists
451    * @param tokenId uint256 ID of the token to query the existence of
452    * @return whether the token exists
453    */
454   function _exists(uint256 tokenId) internal view returns (bool) {
455     address owner = _tokenOwner[tokenId];
456     return owner != address(0);
457   }
458 
459   /**
460    * @dev Returns whether the given spender can transfer a given token ID
461    * @param spender address of the spender to query
462    * @param tokenId uint256 ID of the token to be transferred
463    * @return bool whether the msg.sender is approved for the given token ID,
464    *  is an operator of the owner, or is the owner of the token
465    */
466   function _isApprovedOrOwner(
467     address spender,
468     uint256 tokenId
469   )
470     internal
471     view
472     returns (bool)
473   {
474     address owner = ownerOf(tokenId);
475     // Disable solium check because of
476     // https://github.com/duaraghav8/Solium/issues/175
477     // solium-disable-next-line operator-whitespace
478     return (
479       spender == owner ||
480       getApproved(tokenId) == spender ||
481       isApprovedForAll(owner, spender)
482     );
483   }
484 
485   /**
486    * @dev Internal function to mint a new token
487    * Reverts if the given token ID already exists
488    * @param to The address that will own the minted token
489    * @param tokenId uint256 ID of the token to be minted by the msg.sender
490    */
491   function _mint(address to, uint256 tokenId) internal {
492     require(to != address(0));
493     _addTokenTo(to, tokenId);
494     emit Transfer(address(0), to, tokenId);
495   }
496 
497   /**
498    * @dev Internal function to burn a specific token
499    * Reverts if the token does not exist
500    * @param tokenId uint256 ID of the token being burned by the msg.sender
501    */
502   function _burn(address owner, uint256 tokenId) internal {
503     _clearApproval(owner, tokenId);
504     _removeTokenFrom(owner, tokenId);
505     emit Transfer(owner, address(0), tokenId);
506   }
507 
508   /**
509    * @dev Internal function to add a token ID to the list of a given address
510    * Note that this function is left internal to make ERC721Enumerable possible, but is not
511    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
512    * @param to address representing the new owner of the given token ID
513    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
514    */
515   function _addTokenTo(address to, uint256 tokenId) internal {
516     require(_tokenOwner[tokenId] == address(0));
517     _tokenOwner[tokenId] = to;
518     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
519   }
520 
521   /**
522    * @dev Internal function to remove a token ID from the list of a given address
523    * Note that this function is left internal to make ERC721Enumerable possible, but is not
524    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
525    * and doesn't clear approvals.
526    * @param from address representing the previous owner of the given token ID
527    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
528    */
529   function _removeTokenFrom(address from, uint256 tokenId) internal {
530     require(ownerOf(tokenId) == from);
531     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
532     _tokenOwner[tokenId] = address(0);
533   }
534 
535   /**
536    * @dev Internal function to invoke `onERC721Received` on a target address
537    * The call is not executed if the target address is not a contract
538    * @param from address representing the previous owner of the given token ID
539    * @param to target address that will receive the tokens
540    * @param tokenId uint256 ID of the token to be transferred
541    * @param _data bytes optional data to send along with the call
542    * @return whether the call correctly returned the expected magic value
543    */
544   function _checkOnERC721Received(
545     address from,
546     address to,
547     uint256 tokenId,
548     bytes _data
549   )
550     internal
551     returns (bool)
552   {
553     if (!to.isContract()) {
554       return true;
555     }
556     bytes4 retval = IERC721Receiver(to).onERC721Received(
557       msg.sender, from, tokenId, _data);
558     return (retval == _ERC721_RECEIVED);
559   }
560 
561   /**
562    * @dev Private function to clear current approval of a given token ID
563    * Reverts if the given address is not indeed the owner of the token
564    * @param owner owner of the token
565    * @param tokenId uint256 ID of the token to be transferred
566    */
567   function _clearApproval(address owner, uint256 tokenId) private {
568     require(ownerOf(tokenId) == owner);
569     if (_tokenApprovals[tokenId] != address(0)) {
570       _tokenApprovals[tokenId] = address(0);
571     }
572   }
573 }
574 
575 // File: contracts/library/token/ERC721Manager.sol
576 
577 /**
578  * @title ERC721Manager
579  *
580  * @dev This library implements OpenZepellin's ERC721 implementation (as of 7/31/2018) as
581  * an external library, in order to keep contract sizes smaller.
582  *
583  * Released under the MIT License.
584  *
585  *
586  * The MIT License (MIT)
587  *
588  * Copyright (c) 2016 Smart Contract Solutions, Inc.
589  *
590  * Permission is hereby granted, free of charge, to any person obtaining
591  * a copy of this software and associated documentation files (the
592  * "Software"), to deal in the Software without restriction, including
593  * without limitation the rights to use, copy, modify, merge, publish,
594  * distribute, sublicense, and/or sell copies of the Software, and to
595  * permit persons to whom the Software is furnished to do so, subject to
596  * the following conditions:
597  *
598  * The above copyright notice and this permission notice shall be included
599  * in all copies or substantial portions of the Software.
600  *
601  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
602  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
603  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
604  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
605  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
606  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
607  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
608  *
609  */
610 library ERC721Manager {
611 
612     using SafeMath for uint256;
613 
614     // We define the events on both the library and the client, so that the events emitted here are detected
615     // as if they had been emitted by the client
616     event Transfer(
617         address indexed _from,
618         address indexed _to,
619         uint256 indexed _tokenId
620     );
621     event Approval(
622         address indexed _owner,
623         address indexed _approved,
624         uint256 indexed _tokenId
625     );
626     event ApprovalForAll(
627         address indexed _owner,
628         address indexed _operator,
629         bool _approved
630     );
631 
632     struct ERC721Data {
633         // List of supported interfaces
634         mapping (bytes4 => bool) supportedInterfaces;
635 
636         // Mapping from token ID to owner
637         mapping (uint256 => address) tokenOwner;
638 
639         // Mapping from token ID to approved address
640         mapping (uint256 => address) tokenApprovals;
641 
642         // Mapping from owner to number of owned token
643         mapping (address => uint256) ownedTokensCount;
644 
645         // Mapping from owner to operator approvals
646         mapping (address => mapping (address => bool)) operatorApprovals;
647 
648 
649         // Token name
650         string name_;
651 
652         // Token symbol
653         string symbol_;
654 
655         // Mapping from owner to list of owned token IDs
656         mapping(address => uint256[]) ownedTokens;
657 
658         // Mapping from token ID to index of the owner tokens list
659         mapping(uint256 => uint256) ownedTokensIndex;
660 
661         // Array with all token ids, used for enumeration
662         uint256[] allTokens;
663 
664         // Mapping from token id to position in the allTokens array
665         mapping(uint256 => uint256) allTokensIndex;
666 
667         // Optional mapping for token URIs
668         mapping(uint256 => string) tokenURIs;
669     }
670 
671     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
672     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
673     bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
674 
675 
676     bytes4 private constant InterfaceId_ERC165 = 0x01ffc9a7;
677     /**
678      * 0x01ffc9a7 ===
679      *   bytes4(keccak256('supportsInterface(bytes4)'))
680      */
681 
682     bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
683     /*
684      * 0x80ac58cd ===
685      *   bytes4(keccak256('balanceOf(address)')) ^
686      *   bytes4(keccak256('ownerOf(uint256)')) ^
687      *   bytes4(keccak256('approve(address,uint256)')) ^
688      *   bytes4(keccak256('getApproved(uint256)')) ^
689      *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
690      *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
691      *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
692      *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
693      *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
694      */
695 
696     bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
697     /*
698      * 0x4f558e79 ===
699      *   bytes4(keccak256('exists(uint256)'))
700      */
701 
702     bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
703     /**
704      * 0x780e9d63 ===
705      *   bytes4(keccak256('totalSupply()')) ^
706      *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
707      *   bytes4(keccak256('tokenByIndex(uint256)'))
708      */
709 
710     bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
711     /**
712      * 0x5b5e139f ===
713      *   bytes4(keccak256('name()')) ^
714      *   bytes4(keccak256('symbol()')) ^
715      *   bytes4(keccak256('tokenURI(uint256)'))
716      */
717 
718 
719     function initialize(ERC721Data storage self, string _name, string _symbol) external {
720         self.name_ = _name;
721         self.symbol_ = _symbol;
722 
723         // register the supported interface to conform to ERC165
724         _registerInterface(self, InterfaceId_ERC165);
725 
726         // register the supported interfaces to conform to ERC721 via ERC165
727         _registerInterface(self, InterfaceId_ERC721);
728         _registerInterface(self, InterfaceId_ERC721Exists);
729         _registerInterface(self, InterfaceId_ERC721Enumerable);
730         _registerInterface(self, InterfaceId_ERC721Metadata);
731     }
732 
733     function _registerInterface(ERC721Data storage self, bytes4 _interfaceId) private {
734         self.supportedInterfaces[_interfaceId] = true;
735     }
736 
737     function supportsInterface(ERC721Data storage self, bytes4 _interfaceId) external view returns (bool) {
738         return self.supportedInterfaces[_interfaceId];
739     }
740 
741     /**
742      * @dev Gets the balance of the specified address
743      * @param _owner address to query the balance of
744      * @return uint256 representing the amount owned by the passed address
745      */
746     function balanceOf(ERC721Data storage self, address _owner) public view returns (uint256) {
747         require(_owner != address(0));
748         return self.ownedTokensCount[_owner];
749     }
750 
751     /**
752      * @dev Gets the owner of the specified token ID
753      * @param _tokenId uint256 ID of the token to query the owner of
754      * @return owner address currently marked as the owner of the given token ID
755      */
756     function ownerOf(ERC721Data storage self, uint256 _tokenId) public view returns (address) {
757         address owner = self.tokenOwner[_tokenId];
758         require(owner != address(0));
759         return owner;
760     }
761 
762     /**
763      * @dev Returns whether the specified token exists
764      * @param _tokenId uint256 ID of the token to query the existence of
765      * @return whether the token exists
766      */
767     function exists(ERC721Data storage self, uint256 _tokenId) public view returns (bool) {
768         address owner = self.tokenOwner[_tokenId];
769         return owner != address(0);
770     }
771 
772     /**
773      * @dev Approves another address to transfer the given token ID
774      * The zero address indicates there is no approved address.
775      * There can only be one approved address per token at a given time.
776      * Can only be called by the token owner or an approved operator.
777      * @param _to address to be approved for the given token ID
778      * @param _tokenId uint256 ID of the token to be approved
779      */
780     function approve(ERC721Data storage self, address _to, uint256 _tokenId) external {
781         address owner = ownerOf(self, _tokenId);
782         require(_to != owner);
783         require(msg.sender == owner || isApprovedForAll(self, owner, msg.sender));
784 
785         self.tokenApprovals[_tokenId] = _to;
786 
787         emit Approval(owner, _to, _tokenId);
788     }
789 
790     /**
791      * @dev Gets the approved address for a token ID, or zero if no address set
792      * @param _tokenId uint256 ID of the token to query the approval of
793      * @return address currently approved for the given token ID
794      */
795     function getApproved(ERC721Data storage self, uint256 _tokenId) public view returns (address) {
796         return self.tokenApprovals[_tokenId];
797     }
798 
799     /**
800      * @dev Sets or unsets the approval of a given operator
801      * An operator is allowed to transfer all tokens of the sender on their behalf
802      * @param _to operator address to set the approval
803      * @param _approved representing the status of the approval to be set
804      */
805     function setApprovalForAll(ERC721Data storage self, address _to, bool _approved) external {
806         require(_to != msg.sender);
807         self.operatorApprovals[msg.sender][_to] = _approved;
808         emit ApprovalForAll(msg.sender, _to, _approved);
809     }
810 
811     /**
812      * @dev Tells whether an operator is approved by a given owner
813      * @param _owner owner address which you want to query the approval of
814      * @param _operator operator address which you want to query the approval of
815      * @return bool whether the given operator is approved by the given owner
816      */
817     function isApprovedForAll(
818         ERC721Data storage self,
819         address _owner,
820         address _operator
821     ) public view returns (bool) {
822         return self.operatorApprovals[_owner][_operator];
823     }
824 
825     /**
826      * @dev Transfers the ownership of a given token ID to another address
827      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
828      * Requires the msg sender to be the owner, approved, or operator
829      * @param _from current owner of the token
830      * @param _to address to receive the ownership of the given token ID
831      * @param _tokenId uint256 ID of the token to be transferred
832     */
833     function transferFrom(
834         ERC721Data storage self,
835         address _from,
836         address _to,
837         uint256 _tokenId
838     ) public {
839         require(isApprovedOrOwner(self, msg.sender, _tokenId));
840         require(_from != address(0));
841         require(_to != address(0));
842 
843         _clearApproval(self, _from, _tokenId);
844         _removeTokenFrom(self, _from, _tokenId);
845         _addTokenTo(self, _to, _tokenId);
846 
847         emit Transfer(_from, _to, _tokenId);
848     }
849 
850     /**
851      * @dev Safely transfers the ownership of a given token ID to another address
852      * If the target address is a contract, it must implement `onERC721Received`,
853      * which is called upon a safe transfer, and return the magic value
854      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
855      * the transfer is reverted.
856      *
857      * Requires the msg sender to be the owner, approved, or operator
858      * @param _from current owner of the token
859      * @param _to address to receive the ownership of the given token ID
860      * @param _tokenId uint256 ID of the token to be transferred
861     */
862     function safeTransferFrom(
863         ERC721Data storage self,
864         address _from,
865         address _to,
866         uint256 _tokenId
867     ) external {
868         // solium-disable-next-line arg-overflow
869         safeTransferFrom(self, _from, _to, _tokenId, "");
870     }
871 
872     /**
873      * @dev Safely transfers the ownership of a given token ID to another address
874      * If the target address is a contract, it must implement `onERC721Received`,
875      * which is called upon a safe transfer, and return the magic value
876      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
877      * the transfer is reverted.
878      * Requires the msg sender to be the owner, approved, or operator
879      * @param _from current owner of the token
880      * @param _to address to receive the ownership of the given token ID
881      * @param _tokenId uint256 ID of the token to be transferred
882      * @param _data bytes data to send along with a safe transfer check
883      */
884     function safeTransferFrom(
885         ERC721Data storage self,
886         address _from,
887         address _to,
888         uint256 _tokenId,
889         bytes _data
890     ) public {
891         transferFrom(self, _from, _to, _tokenId);
892         // solium-disable-next-line arg-overflow
893         require(_checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
894     }
895 
896     /**
897      * @dev Internal function to clear current approval of a given token ID
898      * Reverts if the given address is not indeed the owner of the token
899      * @param _owner owner of the token
900      * @param _tokenId uint256 ID of the token to be transferred
901      */
902     function _clearApproval(ERC721Data storage self, address _owner, uint256 _tokenId) internal {
903         require(ownerOf(self, _tokenId) == _owner);
904         if (self.tokenApprovals[_tokenId] != address(0)) {
905             self.tokenApprovals[_tokenId] = address(0);
906         }
907     }
908 
909     /**
910      * @dev Internal function to invoke `onERC721Received` on a target address
911      * The call is not executed if the target address is not a contract
912      * @param _from address representing the previous owner of the given token ID
913      * @param _to target address that will receive the tokens
914      * @param _tokenId uint256 ID of the token to be transferred
915      * @param _data bytes optional data to send along with the call
916      * @return whether the call correctly returned the expected magic value
917      */
918     function _checkAndCallSafeTransfer(
919         address _from,
920         address _to,
921         uint256 _tokenId,
922         bytes _data
923     ) internal returns (bool) {
924         if (!_isContract(_to)) {
925             return true;
926         }
927         bytes4 retval = IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
928         return (retval == ERC721_RECEIVED);
929     }
930 
931     /**
932      * Returns whether the target address is a contract
933      * @dev This function will return false if invoked during the constructor of a contract,
934      * as the code is not actually created until after the constructor finishes.
935      * @param _addr address to check
936      * @return whether the target address is a contract
937      */
938     function _isContract(address _addr) internal view returns (bool) {
939         uint256 size;
940         // XXX Currently there is no better way to check if there is a contract in an address
941         // than to check the size of the code at that address.
942         // See https://ethereum.stackexchange.com/a/14016/36603
943         // for more details about how this works.
944         // TODO Check this again before the Serenity release, because all addresses will be
945         // contracts then.
946         // solium-disable-next-line security/no-inline-assembly
947         assembly { size := extcodesize(_addr) }
948         return size > 0;
949     }
950 
951 
952     /**
953      * @dev Gets the token name
954      * @return string representing the token name
955      */
956     function name(ERC721Data storage self) external view returns (string) {
957         return self.name_;
958     }
959 
960     /**
961      * @dev Gets the token symbol
962      * @return string representing the token symbol
963      */
964     function symbol(ERC721Data storage self) external view returns (string) {
965         return self.symbol_;
966     }
967 
968     /**
969      * @dev Returns an URI for a given token ID
970      * Throws if the token ID does not exist. May return an empty string.
971      * @param _tokenId uint256 ID of the token to query
972      */
973     function tokenURI(ERC721Data storage self, uint256 _tokenId) external view returns (string) {
974         require(exists(self, _tokenId));
975         return self.tokenURIs[_tokenId];
976     }
977 
978     /**
979      * @dev Gets the token ID at a given index of the tokens list of the requested owner
980      * @param _owner address owning the tokens list to be accessed
981      * @param _index uint256 representing the index to be accessed of the requested tokens list
982      * @return uint256 token ID at the given index of the tokens list owned by the requested address
983      */
984     function tokenOfOwnerByIndex(
985         ERC721Data storage self,
986         address _owner,
987         uint256 _index
988     ) external view returns (uint256) {
989         require(_index < balanceOf(self, _owner));
990         return self.ownedTokens[_owner][_index];
991     }
992 
993     /**
994      * @dev Gets the total amount of tokens stored by the contract
995      * @return uint256 representing the total amount of tokens
996      */
997     function totalSupply(ERC721Data storage self) external view returns (uint256) {
998         return self.allTokens.length;
999     }
1000 
1001     /**
1002      * @dev Gets the token ID at a given index of all the tokens in this contract
1003      * Reverts if the index is greater or equal to the total number of tokens
1004      * @param _index uint256 representing the index to be accessed of the tokens list
1005      * @return uint256 token ID at the given index of the tokens list
1006      */
1007     function tokenByIndex(ERC721Data storage self, uint256 _index) external view returns (uint256) {
1008         require(_index < self.allTokens.length);
1009         return self.allTokens[_index];
1010     }
1011 
1012     /**
1013      * @dev Function to set the token URI for a given token
1014      * Reverts if the token ID does not exist
1015      * @param _tokenId uint256 ID of the token to set its URI
1016      * @param _uri string URI to assign
1017      */
1018     function setTokenURI(ERC721Data storage self, uint256 _tokenId, string _uri) external {
1019         require(exists(self, _tokenId));
1020         self.tokenURIs[_tokenId] = _uri;
1021     }
1022 
1023     /**
1024      * @dev Internal function to add a token ID to the list of a given address
1025      * @param _to address representing the new owner of the given token ID
1026      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1027      */
1028     function _addTokenTo(ERC721Data storage self, address _to, uint256 _tokenId) internal {
1029         require(self.tokenOwner[_tokenId] == address(0));
1030         self.tokenOwner[_tokenId] = _to;
1031         self.ownedTokensCount[_to] = self.ownedTokensCount[_to].add(1);
1032 
1033         uint256 length = self.ownedTokens[_to].length;
1034         self.ownedTokens[_to].push(_tokenId);
1035         self.ownedTokensIndex[_tokenId] = length;
1036     }
1037 
1038     /**
1039      * @dev Internal function to remove a token ID from the list of a given address
1040      * @param _from address representing the previous owner of the given token ID
1041      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1042      */
1043     function _removeTokenFrom(ERC721Data storage self, address _from, uint256 _tokenId) internal {
1044         require(ownerOf(self, _tokenId) == _from);
1045         self.ownedTokensCount[_from] = self.ownedTokensCount[_from].sub(1);
1046         self.tokenOwner[_tokenId] = address(0);
1047 
1048         // To prevent a gap in the array, we store the last token in the index of the token to delete, and
1049         // then delete the last slot.
1050         uint256 tokenIndex = self.ownedTokensIndex[_tokenId];
1051         uint256 lastTokenIndex = self.ownedTokens[_from].length.sub(1);
1052         uint256 lastToken = self.ownedTokens[_from][lastTokenIndex];
1053 
1054         self.ownedTokens[_from][tokenIndex] = lastToken;
1055         self.ownedTokens[_from].length--;
1056         // ^ This also deletes the contents at the last position of the array
1057 
1058         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1059         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1060         // the lastToken to the first position, and then dropping the element placed in the last position of the list
1061 
1062         self.ownedTokensIndex[_tokenId] = 0;
1063         self.ownedTokensIndex[lastToken] = tokenIndex;
1064     }
1065 
1066     /**
1067      * @dev Function to mint a new token
1068      * Reverts if the given token ID already exists
1069      * @param _to address the beneficiary that will own the minted token
1070      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1071      */
1072     function mint(ERC721Data storage self, address _to, uint256 _tokenId) external {
1073         require(_to != address(0));
1074         _addTokenTo(self, _to, _tokenId);
1075         emit Transfer(address(0), _to, _tokenId);
1076 
1077         self.allTokensIndex[_tokenId] = self.allTokens.length;
1078         self.allTokens.push(_tokenId);
1079     }
1080 
1081     /**
1082      * @dev Function to burn a specific token
1083      * Reverts if the token does not exist
1084      * @param _owner owner of the token to burn
1085      * @param _tokenId uint256 ID of the token being burned by the msg.sender
1086      */
1087     function burn(ERC721Data storage self, address _owner, uint256 _tokenId) external {
1088         _clearApproval(self, _owner, _tokenId);
1089         _removeTokenFrom(self, _owner, _tokenId);
1090         emit Transfer(_owner, address(0), _tokenId);
1091 
1092         // Clear metadata (if any)
1093         if (bytes(self.tokenURIs[_tokenId]).length != 0) {
1094             delete self.tokenURIs[_tokenId];
1095         }
1096 
1097         // Reorg all tokens array
1098         uint256 tokenIndex = self.allTokensIndex[_tokenId];
1099         uint256 lastTokenIndex = self.allTokens.length.sub(1);
1100         uint256 lastToken = self.allTokens[lastTokenIndex];
1101 
1102         self.allTokens[tokenIndex] = lastToken;
1103         self.allTokens[lastTokenIndex] = 0;
1104 
1105         self.allTokens.length--;
1106         self.allTokensIndex[_tokenId] = 0;
1107         self.allTokensIndex[lastToken] = tokenIndex;
1108     }
1109 
1110     /**
1111      * @dev Returns whether the given spender can transfer a given token ID
1112      * @param _spender address of the spender to query
1113      * @param _tokenId uint256 ID of the token to be transferred
1114      * @return bool whether the msg.sender is approved for the given token ID,
1115      *  is an operator of the owner, or is the owner of the token
1116      */
1117     function isApprovedOrOwner(
1118         ERC721Data storage self,
1119         address _spender,
1120         uint256 _tokenId
1121     ) public view returns (bool) {
1122         address owner = ownerOf(self, _tokenId);
1123         // Disable solium check because of
1124         // https://github.com/duaraghav8/Solium/issues/175
1125         // solium-disable-next-line operator-whitespace
1126         return (
1127             _spender == owner
1128             || getApproved(self, _tokenId) == _spender
1129             || isApprovedForAll(self, owner, _spender)
1130         );
1131     }
1132 
1133 }
1134 
1135 // File: contracts/library/token/ERC721Token.sol
1136 
1137 /**
1138  * @title ERC721Token
1139  *
1140  * @dev This token interfaces with the OpenZepellin's ERC721 implementation (as of 7/31/2018) as
1141  * an external library, in order to keep contract sizes smaller.  Intended for use with the
1142  * ERC721Manager.sol, also provided.
1143  *
1144  * Both files are released under the MIT License.
1145  *
1146  *
1147  * The MIT License (MIT)
1148  *
1149  * Copyright (c) 2016 Smart Contract Solutions, Inc.
1150  *
1151  * Permission is hereby granted, free of charge, to any person obtaining
1152  * a copy of this software and associated documentation files (the
1153  * "Software"), to deal in the Software without restriction, including
1154  * without limitation the rights to use, copy, modify, merge, publish,
1155  * distribute, sublicense, and/or sell copies of the Software, and to
1156  * permit persons to whom the Software is furnished to do so, subject to
1157  * the following conditions:
1158  *
1159  * The above copyright notice and this permission notice shall be included
1160  * in all copies or substantial portions of the Software.
1161  *
1162  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
1163  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
1164  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
1165  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
1166  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
1167  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
1168  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
1169  *
1170  */
1171 contract ERC721Token is ERC165, ERC721 {
1172 
1173     ERC721Manager.ERC721Data internal erc721Data;
1174 
1175     // We define the events on both the library and the client, so that the events emitted here are detected
1176     // as if they had been emitted by the client
1177     event Transfer(
1178         address indexed _from,
1179         address indexed _to,
1180         uint256 indexed _tokenId
1181     );
1182     event Approval(
1183         address indexed _owner,
1184         address indexed _approved,
1185         uint256 indexed _tokenId
1186     );
1187     event ApprovalForAll(
1188         address indexed _owner,
1189         address indexed _operator,
1190         bool _approved
1191     );
1192 
1193 
1194     constructor(string _name, string _symbol) public {
1195         ERC721Manager.initialize(erc721Data, _name, _symbol);
1196     }
1197 
1198     function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
1199         return ERC721Manager.supportsInterface(erc721Data, _interfaceId);
1200     }
1201 
1202     function balanceOf(address _owner) public view returns (uint256 _balance) {
1203         return ERC721Manager.balanceOf(erc721Data, _owner);
1204     }
1205 
1206     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
1207         return ERC721Manager.ownerOf(erc721Data, _tokenId);
1208     }
1209 
1210     function exists(uint256 _tokenId) public view returns (bool _exists) {
1211         return ERC721Manager.exists(erc721Data, _tokenId);
1212     }
1213 
1214     function approve(address _to, uint256 _tokenId) public {
1215         ERC721Manager.approve(erc721Data, _to, _tokenId);
1216     }
1217 
1218     function getApproved(uint256 _tokenId) public view returns (address _operator) {
1219         return ERC721Manager.getApproved(erc721Data, _tokenId);
1220     }
1221 
1222     function setApprovalForAll(address _to, bool _approved) public {
1223         ERC721Manager.setApprovalForAll(erc721Data, _to, _approved);
1224     }
1225 
1226     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
1227         return ERC721Manager.isApprovedForAll(erc721Data, _owner, _operator);
1228     }
1229 
1230     function transferFrom(address _from, address _to, uint256 _tokenId) public {
1231         ERC721Manager.transferFrom(erc721Data, _from, _to, _tokenId);
1232     }
1233 
1234     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
1235         ERC721Manager.safeTransferFrom(erc721Data, _from, _to, _tokenId);
1236     }
1237 
1238     function safeTransferFrom(
1239         address _from,
1240         address _to,
1241         uint256 _tokenId,
1242         bytes _data
1243     ) public {
1244         ERC721Manager.safeTransferFrom(erc721Data, _from, _to, _tokenId, _data);
1245     }
1246 
1247 
1248     function totalSupply() public view returns (uint256) {
1249         return ERC721Manager.totalSupply(erc721Data);
1250     }
1251 
1252     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId) {
1253         return ERC721Manager.tokenOfOwnerByIndex(erc721Data, _owner, _index);
1254     }
1255 
1256     function tokenByIndex(uint256 _index) public view returns (uint256) {
1257         return ERC721Manager.tokenByIndex(erc721Data, _index);
1258     }
1259 
1260     function name() external view returns (string _name) {
1261         return erc721Data.name_;
1262     }
1263 
1264     function symbol() external view returns (string _symbol) {
1265         return erc721Data.symbol_;
1266     }
1267 
1268     function tokenURI(uint256 _tokenId) public view returns (string) {
1269         return ERC721Manager.tokenURI(erc721Data, _tokenId);
1270     }
1271 
1272 
1273     function _mint(address _to, uint256 _tokenId) internal {
1274         ERC721Manager.mint(erc721Data, _to, _tokenId);
1275     }
1276 
1277     function _burn(address _owner, uint256 _tokenId) internal {
1278         ERC721Manager.burn(erc721Data, _owner, _tokenId);
1279     }
1280 
1281     function _setTokenURI(uint256 _tokenId, string _uri) internal {
1282         ERC721Manager.setTokenURI(erc721Data, _tokenId, _uri);
1283     }
1284 
1285     function isApprovedOrOwner(
1286         address _spender,
1287         uint256 _tokenId
1288     ) public view returns (bool) {
1289         return ERC721Manager.isApprovedOrOwner(erc721Data, _spender, _tokenId);
1290     }
1291 }
1292 
1293 // File: contracts/library/data/PRNG.sol
1294 
1295 /**
1296  * Implementation of the xorshift128+ PRNG
1297  */
1298 library PRNG {
1299 
1300     struct Data {
1301         uint64 s0;
1302         uint64 s1;
1303     }
1304 
1305     function next(Data storage self) external returns (uint64) {
1306         uint64 x = self.s0;
1307         uint64 y = self.s1;
1308 
1309         self.s0 = y;
1310         x ^= x << 23; // a
1311         self.s1 = x ^ y ^ (x >> 17) ^ (y >> 26); // b, c
1312         return self.s1 + y;
1313     }
1314 }
1315 
1316 // File: contracts/library/data/EnumerableSetAddress.sol
1317 
1318 /**
1319  * @title EnumerableSetAddress
1320  * @dev Library containing logic for an enumerable set of address values -- supports checking for presence, adding,
1321  * removing elements, and enumerating elements (without preserving order between mutable operations).
1322  */
1323 library EnumerableSetAddress {
1324 
1325     struct Data {
1326         address[] elements;
1327         mapping(address => uint160) elementToIndex;
1328     }
1329 
1330     /**
1331      * @dev Returns whether the set contains a given element
1332      *
1333      * @param self Data storage Reference to set data
1334      * @param value address Value being checked for existence
1335      * @return bool
1336      */
1337     function contains(Data storage self, address value) external view returns (bool) {
1338         uint160 mappingIndex = self.elementToIndex[value];
1339         return (mappingIndex < self.elements.length) && (self.elements[mappingIndex] == value);
1340     }
1341 
1342     /**
1343      * @dev Adds a new element to the set.  Element must not belong to set yet.
1344      *
1345      * @param self Data storage Reference to set data
1346      * @param value address Value being added
1347      */
1348     function add(Data storage self, address value) external {
1349         uint160 mappingIndex = self.elementToIndex[value];
1350         require(!((mappingIndex < self.elements.length) && (self.elements[mappingIndex] == value)));
1351 
1352         self.elementToIndex[value] = uint160(self.elements.length);
1353         self.elements.push(value);
1354     }
1355 
1356     /**
1357      * @dev Removes an element from the set.  Element must already belong to set.
1358      *
1359      * @param self Data storage Reference to set data
1360      * @param value address Value being removed
1361      */
1362     function remove(Data storage self, address value) external {
1363         uint160 currentElementIndex = self.elementToIndex[value];
1364         require((currentElementIndex < self.elements.length) && (self.elements[currentElementIndex] == value));
1365 
1366         uint160 lastElementIndex = uint160(self.elements.length - 1);
1367         address lastElement = self.elements[lastElementIndex];
1368 
1369         self.elements[currentElementIndex] = lastElement;
1370         self.elements[lastElementIndex] = 0;
1371         self.elements.length--;
1372 
1373         self.elementToIndex[lastElement] = currentElementIndex;
1374         self.elementToIndex[value] = 0;
1375     }
1376 
1377     /**
1378      * @dev Gets the number of elements on the set.
1379      *
1380      * @param self Data storage Reference to set data
1381      * @return uint160
1382      */
1383     function size(Data storage self) external view returns (uint160) {
1384         return uint160(self.elements.length);
1385     }
1386 
1387     /**
1388      * @dev Gets the N-th element from the set, 0-indexed.  Note that the ordering is not necessarily consistent
1389      * before and after add, remove operations.
1390      *
1391      * @param self Data storage Reference to set data
1392      * @param index uint160 0-indexed position of the element being queried
1393      * @return address
1394      */
1395     function get(Data storage self, uint160 index) external view returns (address) {
1396         return self.elements[index];
1397     }
1398 
1399     /**
1400      * @dev Mark the set as empty (not containing any further elements).
1401      *
1402      * @param self Data storage Reference to set data
1403      */
1404     function clear(Data storage self) external {
1405         self.elements.length = 0;
1406     }
1407 
1408     /**
1409      * @dev Copy all data from a source set to a target set
1410      *
1411      * @param source Data storage Reference to source data
1412      * @param target Data storage Reference to target data
1413      */
1414     function copy(Data storage source, Data storage target) external {
1415         uint160 numElements = uint160(source.elements.length);
1416 
1417         target.elements.length = numElements;
1418         for (uint160 index = 0; index < numElements; index++) {
1419             address element = source.elements[index];
1420             target.elements[index] = element;
1421             target.elementToIndex[element] = index;
1422         }
1423     }
1424 
1425     /**
1426      * @dev Adds all elements from another set into this set, if they are not already present
1427      *
1428      * @param self Data storage Reference to set being edited
1429      * @param other Data storage Reference to set items are being added from
1430      */
1431     function addAll(Data storage self, Data storage other) external {
1432         uint160 numElements = uint160(other.elements.length);
1433 
1434         for (uint160 index = 0; index < numElements; index++) {
1435             address value = other.elements[index];
1436 
1437             uint160 mappingIndex = self.elementToIndex[value];
1438             if (!((mappingIndex < self.elements.length) && (self.elements[mappingIndex] == value))) {
1439                 self.elementToIndex[value] = uint160(self.elements.length);
1440                 self.elements.push(value);
1441             }
1442         }
1443     }
1444 
1445 }
1446 
1447 // File: contracts/library/data/EnumerableSet256.sol
1448 
1449 /**
1450  * @title EnumerableSet256
1451  * @dev Library containing logic for an enumerable set of uint256 values -- supports checking for presence, adding,
1452  * removing elements, and enumerating elements (without preserving order between mutable operations).
1453  */
1454 library EnumerableSet256 {
1455 
1456     struct Data {
1457         uint256[] elements;
1458         mapping(uint256 => uint256) elementToIndex;
1459     }
1460 
1461     /**
1462      * @dev Returns whether the set contains a given element
1463      *
1464      * @param self Data storage Reference to set data
1465      * @param value uint256 Value being checked for existence
1466      * @return bool
1467      */
1468     function contains(Data storage self, uint256 value) external view returns (bool) {
1469         uint256 mappingIndex = self.elementToIndex[value];
1470         return (mappingIndex < self.elements.length) && (self.elements[mappingIndex] == value);
1471     }
1472 
1473     /**
1474      * @dev Adds a new element to the set.  Element must not belong to set yet.
1475      *
1476      * @param self Data storage Reference to set data
1477      * @param value uint256 Value being added
1478      */
1479     function add(Data storage self, uint256 value) external {
1480         uint256 mappingIndex = self.elementToIndex[value];
1481         require(!((mappingIndex < self.elements.length) && (self.elements[mappingIndex] == value)));
1482 
1483         self.elementToIndex[value] = uint256(self.elements.length);
1484         self.elements.push(value);
1485     }
1486 
1487     /**
1488      * @dev Removes an element from the set.  Element must already belong to set yet.
1489      *
1490      * @param self Data storage Reference to set data
1491      * @param value uint256 Value being added
1492      */
1493     function remove(Data storage self, uint256 value) external {
1494         uint256 currentElementIndex = self.elementToIndex[value];
1495         require((currentElementIndex < self.elements.length) && (self.elements[currentElementIndex] == value));
1496 
1497         uint256 lastElementIndex = uint256(self.elements.length - 1);
1498         uint256 lastElement = self.elements[lastElementIndex];
1499 
1500         self.elements[currentElementIndex] = lastElement;
1501         self.elements[lastElementIndex] = 0;
1502         self.elements.length--;
1503 
1504         self.elementToIndex[lastElement] = currentElementIndex;
1505         self.elementToIndex[value] = 0;
1506     }
1507 
1508     /**
1509      * @dev Gets the number of elements on the set.
1510      *
1511      * @param self Data storage Reference to set data
1512      * @return uint256
1513      */
1514     function size(Data storage self) external view returns (uint256) {
1515         return uint256(self.elements.length);
1516     }
1517 
1518     /**
1519      * @dev Gets the N-th element from the set, 0-indexed.  Note that the ordering is not necessarily consistent
1520      * before and after add, remove operations.
1521      *
1522      * @param self Data storage Reference to set data
1523      * @param index uint256 0-indexed position of the element being queried
1524      * @return uint256
1525      */
1526     function get(Data storage self, uint256 index) external view returns (uint256) {
1527         return self.elements[index];
1528     }
1529 
1530     /**
1531      * @dev Mark the set as empty (not containing any further elements).
1532      *
1533      * @param self Data storage Reference to set data
1534      */
1535     function clear(Data storage self) external {
1536         self.elements.length = 0;
1537     }
1538 }
1539 
1540 // File: contracts/library/data/URIDistribution.sol
1541 
1542 /**
1543  * @title URIDistribution
1544  * @dev Library responsible for maintaining a weighted distribution of URIs
1545  */
1546 library URIDistribution {
1547 
1548     struct Data {
1549         uint16[] cumulativeWeights;
1550         mapping(uint16 => string) uris;
1551     }
1552 
1553     /**
1554      * @dev Adds a URI to the distribution, with a given weight
1555      *
1556      * @param self Data storage Distribution data reference
1557      * @param weight uint16 Relative distribution weight
1558      * @param uri string URI to be stored
1559      */
1560     function addURI(Data storage self, uint16 weight, string uri) external {
1561         if (weight == 0) return;
1562 
1563         if (self.cumulativeWeights.length == 0) {
1564             self.cumulativeWeights.push(weight);
1565         } else {
1566             self.cumulativeWeights.push(self.cumulativeWeights[uint16(self.cumulativeWeights.length - 1)] + weight);
1567         }
1568         self.uris[uint16(self.cumulativeWeights.length - 1)] = uri;
1569     }
1570 
1571     /**
1572      * @dev Gets an URI from the distribution, with the given random seed
1573      *
1574      * @param self Data storage Distribution data reference
1575      * @param seed uint64
1576      * @return string
1577      */
1578     function getURI(Data storage self, uint64 seed) external view returns (string) {
1579         uint16 n = uint16(self.cumulativeWeights.length);
1580         uint16 modSeed = uint16(seed % uint64(self.cumulativeWeights[n - 1]));
1581 
1582         uint16 left = 0;
1583         uint16 right = n;
1584         uint16 mid;
1585 
1586         while (left < right) {
1587             mid = uint16((uint24(left) + uint24(right)) / 2);
1588             if (self.cumulativeWeights[mid] <= modSeed) {
1589                 left = mid + 1;
1590             } else {
1591                 right = mid;
1592             }
1593         }
1594         return self.uris[left];
1595     }
1596 }
1597 
1598 // File: contracts/library/game/GameDataLib.sol
1599 
1600 /**
1601  * @title GameDataLib
1602  *
1603  * Library containing data structures and logic for game entities.
1604  */
1605 library GameDataLib {
1606 
1607     /** Data structures */
1608 
1609     struct Butterfly {
1610         // data encoding butterfly appearance
1611         uint64 gene;
1612 
1613         // time this butterfly was created
1614         uint64 createdTimestamp;
1615 
1616         // last time this butterfly changed owner
1617         uint64 lastTimestamp;
1618 
1619         // set of owners, current and former
1620         EnumerableSetAddress.Data previousAddresses;
1621     }
1622 
1623     struct Heart {
1624         // ID of butterfly that generated this heart
1625         uint256 butterflyId;
1626 
1627         // time this heart was generated
1628         uint64 snapshotTimestamp;
1629 
1630         // set of owners, current and former, at time heart was generated
1631         EnumerableSetAddress.Data previousAddresses;
1632     }
1633 
1634     struct Flower {
1635         // Whether this address has ever claimed a butterfly
1636         bool isClaimed;
1637 
1638         // Data encoding flower appearance
1639         uint64 gene;
1640 
1641         // Data encoding the garden's timezone
1642         uint64 gardenTimezone;
1643 
1644         // Data encoding the creation timestamp
1645         uint64 createdTimestamp;
1646 
1647         // index of the flower registration
1648         uint160 flowerIndex;
1649     }
1650 
1651     struct URIMappingData {
1652         URIDistribution.Data flowerURIs;
1653         string whiteFlowerURI;
1654 
1655         URIDistribution.Data butterflyLiveURIs;
1656         URIDistribution.Data butterflyDeadURIs;
1657         URIDistribution.Data heartURIs;
1658     }
1659 
1660     // possible types of NFT
1661     enum TokenType {
1662         Butterfly,
1663         Heart
1664     }
1665 
1666     struct Data {
1667         // global pseudo-randomization seed
1668         PRNG.Data seed;
1669 
1670         // next ID available for token generation
1671         uint256 nextId;
1672 
1673         // token type data
1674         mapping (uint256 => TokenType) tokenToType;
1675         mapping (uint8 => mapping (address => EnumerableSet256.Data)) typedOwnedTokens;
1676         mapping (uint8 => EnumerableSet256.Data) typedTokens;
1677 
1678         // token data
1679         mapping (uint256 => Butterfly) butterflyData;
1680         mapping (uint256 => Heart) heartData;
1681 
1682         // owner data
1683         mapping (address => Flower) flowerData;
1684         address[] claimedFlowers;
1685 
1686         // URI mapping data
1687         URIMappingData uriMappingData;
1688     }
1689 
1690     /** Viewer methods */
1691 
1692     /**
1693      * @dev Gets game information associated with a specific butterfly.
1694      * Requires ID to be a valid butterfly.
1695      *
1696      * @param self Data storage Reference to game data
1697      * @param butterflyId uint256 ID of butterfly being queried
1698      *
1699      * @return gene uint64
1700      * @return createdTimestamp uint64
1701      * @return lastTimestamp uint64
1702      * @return numOwners uint160
1703      */
1704     function getButterflyInfo(
1705         Data storage self,
1706         uint256 butterflyId
1707     ) external view returns (
1708         uint64 gene,
1709         uint64 createdTimestamp,
1710         uint64 lastTimestamp,
1711         uint160 numOwners
1712     ) {
1713         Butterfly storage butterfly = self.butterflyData[butterflyId];
1714         require(butterfly.createdTimestamp != 0);
1715 
1716         gene = butterfly.gene;
1717         createdTimestamp = butterfly.createdTimestamp;
1718         lastTimestamp = butterfly.lastTimestamp;
1719         numOwners = uint160(butterfly.previousAddresses.elements.length);
1720     }
1721 
1722     /**
1723      * @dev Gets game information associated with a specific heart.
1724      * Requires ID to be a valid heart.
1725      *
1726      * @param self Data storage Reference to game data
1727      * @param heartId uint256 ID of heart being queried
1728      *
1729      * @return butterflyId uint256
1730      * @return gene uint64
1731      * @return snapshotTimestamp uint64
1732      * @return numOwners uint160
1733      */
1734     function getHeartInfo(
1735         Data storage self,
1736         uint256 heartId
1737     ) external view returns (
1738         uint256 butterflyId,
1739         uint64 gene,
1740         uint64 snapshotTimestamp,
1741         uint160 numOwners
1742     ) {
1743         Heart storage heart = self.heartData[heartId];
1744         require(heart.snapshotTimestamp != 0);
1745 
1746         butterflyId = heart.butterflyId;
1747         gene = self.butterflyData[butterflyId].gene;
1748         snapshotTimestamp = heart.snapshotTimestamp;
1749         numOwners = uint160(heart.previousAddresses.elements.length);
1750     }
1751 
1752     /**
1753      * @dev Gets game information associated with a specific flower.
1754      *
1755      * @param self Data storage Reference to game data
1756      * @param flowerAddress address Address of the flower being queried
1757      *
1758      * @return isClaimed bool
1759      * @return gene uint64
1760      * @return gardenTimezone uint64
1761      * @return createdTimestamp uint64
1762      * @return flowerIndex uint160
1763      */
1764     function getFlowerInfo(
1765         Data storage self,
1766         address flowerAddress
1767     ) external view returns (
1768         bool isClaimed,
1769         uint64 gene,
1770         uint64 gardenTimezone,
1771         uint64 createdTimestamp,
1772         uint160 flowerIndex
1773     ) {
1774         Flower storage flower = self.flowerData[flowerAddress];
1775 
1776         isClaimed = flower.isClaimed;
1777         if (isClaimed) {
1778             gene = flower.gene;
1779             gardenTimezone = flower.gardenTimezone;
1780             createdTimestamp = flower.createdTimestamp;
1781             flowerIndex = flower.flowerIndex;
1782         }
1783     }
1784 
1785     /**
1786      * @dev Returns the N-th owner associated with a butterfly.
1787      * Requires ID to be a valid butterfly, and owner index to be smaller than the number of owners.
1788      *
1789      * @param self Data storage Reference to game data
1790      * @param butterflyId uint256 ID of butterfly being queried
1791      * @param index uint160 Index of owner being queried
1792      *
1793      * @return address
1794      */
1795     function getButterflyOwnerByIndex(
1796         Data storage self,
1797         uint256 butterflyId,
1798         uint160 index
1799     ) external view returns (address) {
1800         Butterfly storage butterfly = self.butterflyData[butterflyId];
1801         require(butterfly.createdTimestamp != 0);
1802 
1803         return butterfly.previousAddresses.elements[index];
1804     }
1805 
1806     /**
1807      * @dev Returns the N-th owner associated with a heart's snapshot.
1808      * Requires ID to be a valid butterfly, and owner index to be smaller than the number of owners.
1809      *
1810      * @param self Data storage Reference to game data
1811      * @param heartId uint256 ID of heart being queried
1812      * @param index uint160 Index of owner being queried
1813      *
1814      * @return address
1815      */
1816     function getHeartOwnerByIndex(
1817         Data storage self,
1818         uint256 heartId,
1819         uint160 index
1820     ) external view returns (address) {
1821         Heart storage heart = self.heartData[heartId];
1822         require(heart.snapshotTimestamp != 0);
1823 
1824         return heart.previousAddresses.elements[index];
1825     }
1826 
1827     /**
1828      * @dev Determines whether the game logic allows a transfer of a butterfly to another address.
1829      * Conditions:
1830      * - The receiver address must have already claimed a butterfly
1831      * - The butterfly's last timestamp is within the last 24 hours
1832      * - The receiver address must have never claimed *this* butterfly
1833      * OR
1834      * - The receiver is 0x0
1835      *
1836      * @param self Data storage Reference to game data
1837      * @param butterflyId uint256 ID of butterfly being queried
1838      * @param receiver address Address of potential receiver
1839      * @param currentTimestamp uint64
1840      */
1841     function canReceiveButterfly(
1842         Data storage self,
1843         uint256 butterflyId,
1844         address receiver,
1845         uint64 currentTimestamp
1846     ) public view returns (bool) {
1847         Butterfly storage butterfly = self.butterflyData[butterflyId];
1848 
1849         // butterfly must exist
1850         if (butterfly.createdTimestamp == 0)
1851             return false;
1852 
1853         // can always transfer to 0 (destroying it)
1854         if (receiver == address(0x0))
1855             return true;
1856 
1857         // butterfly must have been last updated on the last day
1858         if (currentTimestamp < butterfly.lastTimestamp || currentTimestamp - butterfly.lastTimestamp > 1 days)
1859             return false;
1860 
1861         // receiver must have already claimed
1862         Flower storage flower = self.flowerData[receiver];
1863         if (!flower.isClaimed) return false;
1864 
1865         // receiver must have never owned this butterfly
1866         return !EnumerableSetAddress.contains(butterfly.previousAddresses, receiver);
1867     }
1868 
1869 
1870     /** Editor methods */
1871 
1872     /**
1873      * @dev Claims a flower and an initial butterfly for a given address.
1874      * Requires address to have not claimed previously
1875      *
1876      * @param self Data storage Reference to game data
1877      * @param claimer address Address making the claim
1878      * @param gardenTimezone uint64
1879      * @param currentTimestamp uint64
1880      *
1881      * @return butterflyId uint256 ID for the new butterfly
1882      */
1883     function claim(
1884         Data storage self,
1885         address claimer,
1886         uint64 gardenTimezone,
1887         uint64 currentTimestamp
1888     ) external returns (uint256 butterflyId) {
1889         Flower storage flower = self.flowerData[claimer];
1890 
1891         // require address has not claimed before
1892         require(!flower.isClaimed);
1893         // assert no overflow on IDs
1894         require(self.nextId + 1 != 0);
1895 
1896         // get butterfly ID
1897         butterflyId = self.nextId;
1898         // assert ID is not being reused
1899         Butterfly storage butterfly = self.butterflyData[butterflyId];
1900         require(butterfly.createdTimestamp == 0);
1901         // update counter
1902         self.nextId++;
1903 
1904         // update flower data
1905         flower.isClaimed = true;
1906         flower.gardenTimezone = gardenTimezone;
1907         flower.createdTimestamp = currentTimestamp;
1908         flower.gene = PRNG.next(self.seed);
1909         flower.flowerIndex = uint160(self.claimedFlowers.length);
1910 
1911         // update butterfly data
1912         butterfly.gene = PRNG.next(self.seed);
1913         butterfly.createdTimestamp = currentTimestamp;
1914         butterfly.lastTimestamp = currentTimestamp;
1915         EnumerableSetAddress.add(butterfly.previousAddresses, claimer);
1916 
1917         // update butterfly token data
1918         self.tokenToType[butterflyId] = TokenType.Butterfly;
1919 
1920         // register butterfly token
1921         EnumerableSet256.add(self.typedOwnedTokens[uint8(TokenType.Butterfly)][claimer], butterflyId);
1922         EnumerableSet256.add(self.typedTokens[uint8(TokenType.Butterfly)], butterflyId);
1923 
1924         // register address
1925         self.claimedFlowers.push(claimer);
1926     }
1927 
1928     /**
1929      * @dev Logs a transfer of a butterfly between two addresses, leaving a heart behind.
1930      *
1931      * Conditions:
1932      * - The receiver address must have already claimed a butterfly
1933      * - The butterfly's last timestamp is within the last 24 hours
1934      *
1935      * @param self Data storage Reference to game data
1936      * @param butterflyId uint256 ID of butterfly being queried
1937      * @param sender Address of sender
1938      * @param receiver address Address of potential receiver
1939      * @param currentTimestamp uint64
1940      *
1941      * @return heartId uint256 ID for the new heart
1942      */
1943     function transferButterfly(
1944         Data storage self,
1945         uint256 butterflyId,
1946         address sender,
1947         address receiver,
1948         uint64 currentTimestamp
1949     ) external returns (uint256 heartId) {
1950         // require transfer conditions to be satisfied
1951         require(canReceiveButterfly(self, butterflyId, receiver, currentTimestamp));
1952 
1953         // require no overflow on IDs
1954         require(self.nextId + 1 != 0);
1955         // get heart ID
1956         heartId = self.nextId;
1957         // assert ID is not being reused
1958         Heart storage heart = self.heartData[heartId];
1959         require(heart.snapshotTimestamp == 0);
1960         // update counter
1961         self.nextId++;
1962 
1963         // update heart data
1964         heart.butterflyId = butterflyId;
1965         heart.snapshotTimestamp = currentTimestamp;
1966         Butterfly storage butterfly = self.butterflyData[butterflyId];
1967 
1968         // update heart token heartId
1969         self.tokenToType[heartId] = TokenType.Heart;
1970 
1971         // update butterfly data
1972         butterfly.lastTimestamp = currentTimestamp;
1973         EnumerableSetAddress.add(butterfly.previousAddresses, receiver);
1974 
1975         // update heart addresses
1976         EnumerableSetAddress.copy(butterfly.previousAddresses, heart.previousAddresses);
1977 
1978         // update butterfly register
1979         EnumerableSet256.remove(self.typedOwnedTokens[uint8(TokenType.Butterfly)][sender], butterflyId);
1980         EnumerableSet256.add(self.typedOwnedTokens[uint8(TokenType.Butterfly)][receiver], butterflyId);
1981 
1982         // update heart register
1983         EnumerableSet256.add(self.typedOwnedTokens[uint8(TokenType.Heart)][sender], heartId);
1984         EnumerableSet256.add(self.typedTokens[uint8(TokenType.Heart)], heartId);
1985     }
1986 
1987     /**
1988      * @dev Logs a transfer of a heart between two addresses
1989      *
1990      * @param self Data storage Reference to game data
1991      * @param heartId uint256 ID of heart being queried
1992      * @param sender Address of sender
1993      * @param receiver address Address of potential receiver
1994      */
1995     function transferHeart(
1996         Data storage self,
1997         uint256 heartId,
1998         address sender,
1999         address receiver
2000     ) external {
2001         // update heart register
2002         EnumerableSet256.remove(self.typedOwnedTokens[uint8(TokenType.Heart)][sender], heartId);
2003         EnumerableSet256.add(self.typedOwnedTokens[uint8(TokenType.Heart)][receiver], heartId);
2004     }
2005 
2006     /**
2007      * @dev Returns the total number of tokens for a given type, owned by a specific address
2008      *
2009      * @param self Data storage Reference to game data
2010      * @param tokenType uint8
2011      * @param _owner address
2012      *
2013      * @return uint256
2014      */
2015     function typedBalanceOf(Data storage self, uint8 tokenType, address _owner) public view returns (uint256) {
2016         return self.typedOwnedTokens[tokenType][_owner].elements.length;
2017     }
2018 
2019     /**
2020      * @dev Returns the total number of tokens for a given type
2021      *
2022      * @param self Data storage Reference to game data
2023      * @param tokenType uint8
2024      *
2025      * @return uint256
2026      */
2027     function typedTotalSupply(Data storage self, uint8 tokenType) public view returns (uint256) {
2028         return self.typedTokens[tokenType].elements.length;
2029     }
2030 
2031 
2032     /**
2033      * @dev Returns the I-th token of a specific type owned by an index
2034      *
2035      * @param self Data storage Reference to game data
2036      * @param tokenType uint8
2037      * @param _owner address
2038      * @param _index uint256
2039      *
2040      * @return uint256
2041      */
2042     function typedTokenOfOwnerByIndex(
2043         Data storage self,
2044         uint8 tokenType,
2045         address _owner,
2046         uint256 _index
2047     ) external view returns (uint256) {
2048         return self.typedOwnedTokens[tokenType][_owner].elements[_index];
2049     }
2050 
2051     /**
2052      * @dev Returns the I-th token of a specific type
2053      *
2054      * @param self Data storage Reference to game data
2055      * @param tokenType uint8
2056      * @param _index uint256
2057      *
2058      * @return uint256
2059      */
2060     function typedTokenByIndex(
2061         Data storage self,
2062         uint8 tokenType,
2063         uint256 _index
2064     ) external view returns (uint256) {
2065         return self.typedTokens[tokenType].elements[_index];
2066     }
2067 
2068     /**
2069      * @dev Gets the total number of claimed flowers
2070      *
2071      * @param self Data storage Reference to game data
2072      * @return uint160
2073      */
2074     function totalFlowers(Data storage self) external view returns (uint160) {
2075         return uint160(self.claimedFlowers.length);
2076     }
2077 
2078     /**
2079      * @dev Gets the address of the N-th flower
2080      *
2081      * @param self Data storage Reference to game data
2082      * @return address
2083      */
2084     function getFlowerByIndex(Data storage self, uint160 index) external view returns (address) {
2085         return self.claimedFlowers[index];
2086     }
2087 
2088     /** Admin methods **/
2089 
2090     /**
2091      * @dev Registers a new flower URI with the corresponding weight
2092      *
2093      * @param self Data storage Reference to game data
2094      * @param weight uint16 Relative weight for the occurrence of this URI
2095      * @param uri string
2096      */
2097     function addFlowerURI(Data storage self, uint16 weight, string uri) external {
2098         URIDistribution.addURI(self.uriMappingData.flowerURIs, weight, uri);
2099     }
2100 
2101     /**
2102      * @dev Registers the flower URI for address 0
2103      *
2104      * @param self Data storage Reference to game data
2105      * @param uri string
2106      */
2107     function setWhiteFlowerURI(Data storage self, string uri) external {
2108         self.uriMappingData.whiteFlowerURI = uri;
2109     }
2110 
2111     /**
2112      * @dev Gets the flower URI for address 0
2113      *
2114      * @param self Data storage Reference to game data
2115      * @return string
2116      */
2117     function getWhiteFlowerURI(Data storage self) external view returns (string) {
2118         return self.uriMappingData.whiteFlowerURI;
2119     }
2120 
2121     /**
2122      * @dev Registers a new butterfly URI with the corresponding weight
2123      *
2124      * @param self Data storage Reference to game data
2125      * @param weight uint16 Relative weight for the occurrence of this URI
2126      * @param liveUri string
2127      * @param deadUri string
2128      * @param heartUri string
2129      */
2130     function addButterflyURI(Data storage self, uint16 weight, string liveUri, string deadUri, string heartUri) external {
2131         URIDistribution.addURI(self.uriMappingData.butterflyLiveURIs, weight, liveUri);
2132         URIDistribution.addURI(self.uriMappingData.butterflyDeadURIs, weight, deadUri);
2133         URIDistribution.addURI(self.uriMappingData.heartURIs, weight, heartUri);
2134     }
2135 
2136     /**
2137      * @dev Returns the URI mapped to a particular flower.
2138      * Requires flower to be claimed / exist.
2139      *
2140      * @param self Data storage Reference to game data
2141      * @param flowerAddress address Flower being queried
2142      * @return string
2143      */
2144     function getFlowerURI(Data storage self, address flowerAddress) external view returns (string) {
2145         Flower storage flower = self.flowerData[flowerAddress];
2146         require(flower.isClaimed);
2147         return URIDistribution.getURI(self.uriMappingData.flowerURIs, flower.gene);
2148     }
2149 
2150     /**
2151      * @dev Returns the URI mapped to a particular butterfly -- selecting the URI for it being alive
2152      * or dead based on the current timestamp.
2153      * Requires butterfly to exist.
2154      *
2155      * @param self Data storage Reference to game data
2156      * @param erc721Data ERC721Manager.ERC721Data storage Reference to ownership data
2157      * @param butterflyId uint256 ID of the butterfly being queried
2158      * @param currentTimestamp uint64
2159      * @return string
2160      */
2161     function getButterflyURI(
2162         Data storage self,
2163         ERC721Manager.ERC721Data storage erc721Data,
2164         uint256 butterflyId,
2165         uint64 currentTimestamp
2166     ) external view returns (string) {
2167         Butterfly storage butterfly = self.butterflyData[butterflyId];
2168         require(butterfly.createdTimestamp != 0);
2169 
2170         if (erc721Data.tokenOwner[butterflyId] == 0
2171             || currentTimestamp < butterfly.lastTimestamp
2172             || currentTimestamp - butterfly.lastTimestamp > 1 days) {
2173             return URIDistribution.getURI(self.uriMappingData.butterflyDeadURIs, butterfly.gene);
2174         }
2175         return URIDistribution.getURI(self.uriMappingData.butterflyLiveURIs, butterfly.gene);
2176     }
2177 
2178     /**
2179      * @dev Returns the URI for a particular butterfly gene -- useful for seeing the butterfly "as it was"
2180      * when it dropped a heart
2181      *
2182      * @param self Daata storage Reference to game data
2183      * @param gene uint64
2184      * @param isAlive bool
2185      * @return string
2186      */
2187     function getButterflyURIFromGene(
2188         Data storage self,
2189         uint64 gene,
2190         bool isAlive
2191     ) external view returns (string) {
2192         if (isAlive) {
2193             return URIDistribution.getURI(self.uriMappingData.butterflyLiveURIs, gene);
2194         }
2195         return URIDistribution.getURI(self.uriMappingData.butterflyDeadURIs, gene);
2196     }
2197 
2198     /**
2199      * @dev Returns the URI mapped to hearts
2200      *
2201      * @param self Data storage Reference to game data
2202      * @param heartId uint256 ID of heart being queried
2203      * @return string
2204      */
2205     function getHeartURI(Data storage self, uint256 heartId) external view returns (string) {
2206         Heart storage heart = self.heartData[heartId];
2207         require(heart.snapshotTimestamp != 0);
2208 
2209         uint64 gene = self.butterflyData[heart.butterflyId].gene;
2210         return URIDistribution.getURI(self.uriMappingData.heartURIs, gene);
2211     }
2212 
2213 }
2214 
2215 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2216 
2217 /**
2218  * @title Ownable
2219  * @dev The Ownable contract has an owner address, and provides basic authorization control
2220  * functions, this simplifies the implementation of "user permissions".
2221  */
2222 contract Ownable {
2223   address private _owner;
2224 
2225   event OwnershipTransferred(
2226     address indexed previousOwner,
2227     address indexed newOwner
2228   );
2229 
2230   /**
2231    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
2232    * account.
2233    */
2234   constructor() internal {
2235     _owner = msg.sender;
2236     emit OwnershipTransferred(address(0), _owner);
2237   }
2238 
2239   /**
2240    * @return the address of the owner.
2241    */
2242   function owner() public view returns(address) {
2243     return _owner;
2244   }
2245 
2246   /**
2247    * @dev Throws if called by any account other than the owner.
2248    */
2249   modifier onlyOwner() {
2250     require(isOwner());
2251     _;
2252   }
2253 
2254   /**
2255    * @return true if `msg.sender` is the owner of the contract.
2256    */
2257   function isOwner() public view returns(bool) {
2258     return msg.sender == _owner;
2259   }
2260 
2261   /**
2262    * @dev Allows the current owner to relinquish control of the contract.
2263    * @notice Renouncing to ownership will leave the contract without an owner.
2264    * It will not be possible to call the functions with the `onlyOwner`
2265    * modifier anymore.
2266    */
2267   function renounceOwnership() public onlyOwner {
2268     emit OwnershipTransferred(_owner, address(0));
2269     _owner = address(0);
2270   }
2271 
2272   /**
2273    * @dev Allows the current owner to transfer control of the contract to a newOwner.
2274    * @param newOwner The address to transfer ownership to.
2275    */
2276   function transferOwnership(address newOwner) public onlyOwner {
2277     _transferOwnership(newOwner);
2278   }
2279 
2280   /**
2281    * @dev Transfers control of the contract to a newOwner.
2282    * @param newOwner The address to transfer ownership to.
2283    */
2284   function _transferOwnership(address newOwner) internal {
2285     require(newOwner != address(0));
2286     emit OwnershipTransferred(_owner, newOwner);
2287     _owner = newOwner;
2288   }
2289 }
2290 
2291 // File: contracts\game\Main.sol
2292 
2293 /**
2294  * @title Main
2295  *
2296  * Main contract for LittleButterflies.  Implements the ERC721 EIP for Non-Fungible Tokens.
2297  */
2298 contract Main is ERC721Token, Ownable {
2299 
2300     GameDataLib.Data internal data;
2301 
2302     // Set our token name and symbol
2303     constructor() ERC721Token("LittleButterfly", "BFLY") public {
2304         // initialize PRNG values
2305         data.seed.s0 = uint64(now);
2306         data.seed.s1 = uint64(msg.sender);
2307     }
2308 
2309 
2310     /** Token viewer methods **/
2311 
2312 
2313     /**
2314      * @dev Gets game information associated with a specific butterfly.
2315      * Requires ID to be a valid butterfly.
2316      *
2317      * @param butterflyId uint256 ID of butterfly being queried
2318      *
2319      * @return gene uint64
2320      * @return createdTimestamp uint64
2321      * @return lastTimestamp uint64
2322      * @return numOwners uint160
2323      */
2324     function getButterflyInfo(uint256 butterflyId) public view returns (
2325         uint64 gene,
2326         uint64 createdTimestamp,
2327         uint64 lastTimestamp,
2328         uint160 numOwners
2329     ) {
2330        (gene, createdTimestamp, lastTimestamp, numOwners) = GameDataLib.getButterflyInfo(data, butterflyId);
2331     }
2332 
2333     /**
2334      * @dev Returns the N-th owner associated with a butterfly.
2335      * Requires ID to be a valid butterfly, and owner index to be smaller than the number of owners.
2336      *
2337      * @param butterflyId uint256 ID of butterfly being queried
2338      * @param index uint160 Index of owner being queried
2339      *
2340      * @return address
2341      */
2342     function getButterflyOwnerByIndex(
2343         uint256 butterflyId,
2344         uint160 index
2345     ) external view returns (address) {
2346         return GameDataLib.getButterflyOwnerByIndex(data, butterflyId, index);
2347     }
2348 
2349 
2350     /**
2351      * @dev Gets game information associated with a specific heart.
2352      * Requires ID to be a valid heart.
2353      *
2354      * @param heartId uint256 ID of heart being queried
2355      *
2356      * @return butterflyId uint256
2357      * @return gene uint64
2358      * @return snapshotTimestamp uint64
2359      * @return numOwners uint160
2360      */
2361     function getHeartInfo(uint256 heartId) public view returns (
2362         uint256 butterflyId,
2363         uint64 gene,
2364         uint64 snapshotTimestamp,
2365         uint160 numOwners
2366     ) {
2367         (butterflyId, gene, snapshotTimestamp, numOwners) = GameDataLib.getHeartInfo(data, heartId);
2368     }
2369 
2370     /**
2371      * @dev Returns the N-th owner associated with a heart's snapshot.
2372      * Requires ID to be a valid butterfly, and owner index to be smaller than the number of owners.
2373      *
2374      * @param heartId uint256 ID of heart being queried
2375      * @param index uint160 Index of owner being queried
2376      *
2377      * @return address
2378      */
2379     function getHeartOwnerByIndex(
2380         uint256 heartId,
2381         uint160 index
2382     ) external view returns (address) {
2383         return GameDataLib.getHeartOwnerByIndex(data, heartId, index);
2384     }
2385 
2386 
2387     /**
2388      * @dev Gets game information associated with a specific flower.
2389      *
2390      * @param flowerAddress address Address of the flower being queried
2391      *
2392      * @return isClaimed bool
2393      * @return gene uint64
2394      * @return gardenTimezone uint64
2395      * @return createdTimestamp uint64
2396      * @return flowerIndex uint160
2397      */
2398     function getFlowerInfo(
2399         address flowerAddress
2400     ) external view returns (
2401         bool isClaimed,
2402         uint64 gene,
2403         uint64 gardenTimezone,
2404         uint64 createdTimestamp,
2405         uint160 flowerIndex
2406     ) {
2407         (isClaimed, gene, gardenTimezone, createdTimestamp, flowerIndex) = GameDataLib.getFlowerInfo(data, flowerAddress);
2408     }
2409 
2410 
2411     /**
2412      * @dev Determines whether the game logic allows a transfer of a butterfly to another address.
2413      * Conditions:
2414      * - The receiver address must have already claimed a butterfly
2415      * - The butterfly's last timestamp is within the last 24 hours
2416      * - The receiver address must have never claimed *this* butterfly
2417      *
2418      * @param butterflyId uint256 ID of butterfly being queried
2419      * @param receiver address Address of potential receiver
2420      */
2421     function canReceiveButterfly(
2422         uint256 butterflyId,
2423         address receiver
2424     ) external view returns (bool) {
2425         return GameDataLib.canReceiveButterfly(data, butterflyId, receiver, uint64(now));
2426     }
2427 
2428 
2429     /** Override token methods **/
2430 
2431     /**
2432      * @dev Override the default ERC721 transferFrom implementation in order to check game conditions and
2433      * generate side effects
2434      */
2435     function transferFrom(address _from, address _to, uint256 _tokenId) public {
2436         _setupTransferFrom(_from, _to, _tokenId, uint64(now));
2437         ERC721Manager.transferFrom(erc721Data, _from, _to, _tokenId);
2438     }
2439 
2440     /**
2441      * @dev Override the default ERC721 safeTransferFrom implementation in order to check game conditions and
2442      * generate side effects
2443      */
2444     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
2445         _setupTransferFrom(_from, _to, _tokenId, uint64(now));
2446         ERC721Manager.safeTransferFrom(erc721Data, _from, _to, _tokenId);
2447     }
2448 
2449     /**
2450      * @dev Override the default ERC721 safeTransferFrom implementation in order to check game conditions and
2451      * generate side effects
2452      */
2453     function safeTransferFrom(
2454         address _from,
2455         address _to,
2456         uint256 _tokenId,
2457         bytes _data
2458     ) public {
2459         _setupTransferFrom(_from, _to, _tokenId, uint64(now));
2460         ERC721Manager.safeTransferFrom(erc721Data, _from, _to, _tokenId, _data);
2461     }
2462 
2463 
2464     /**
2465     * @dev Execute before transfer, preventing token transfer in some circumstances.
2466     * Requirements:
2467     *  - Caller is owner, approved, or operator for the token
2468     *  - To has claimed a token before
2469     *  - Token is a Heart, or Token's last activity was in the last 24 hours
2470     *
2471     * @param from current owner of the token
2472     * @param to address to receive the ownership of the given token ID
2473     * @param tokenId uint256 ID of the token to be transferred
2474     * @param currentTimestamp uint64
2475     */
2476     function _setupTransferFrom(
2477         address from,
2478         address to,
2479         uint256 tokenId,
2480         uint64 currentTimestamp
2481     ) private {
2482         if (data.tokenToType[tokenId] == GameDataLib.TokenType.Butterfly) {
2483             // try to do transfer and mint a heart
2484             uint256 heartId = GameDataLib.transferButterfly(data, tokenId, from, to, currentTimestamp);
2485             ERC721Manager.mint(erc721Data, from, heartId);
2486         } else {
2487             GameDataLib.transferHeart(data, tokenId, from, to);
2488         }
2489     }
2490 
2491     /**
2492      * @dev Overrides the default tokenURI method to lookup from the stored table of URIs -- rather than
2493      * storing a copy of the URI for each instance
2494      *
2495      * @param _tokenId uint256
2496      * @return string
2497      */
2498     function tokenURI(uint256 _tokenId) public view returns (string) {
2499         if (data.tokenToType[_tokenId] == GameDataLib.TokenType.Heart) {
2500             return GameDataLib.getHeartURI(data, _tokenId);
2501         }
2502         return GameDataLib.getButterflyURI(data, erc721Data, _tokenId, uint64(now));
2503     }
2504 
2505     /**
2506      * @dev Returns the URI mapped to a particular account / flower
2507      *
2508      * @param accountAddress address
2509      * @return string
2510      */
2511     function accountURI(address accountAddress) public view returns (string) {
2512         return GameDataLib.getFlowerURI(data, accountAddress);
2513     }
2514 
2515     /**
2516      * @dev Returns the URI mapped to account 0
2517      *
2518      * @return string
2519      */
2520     function accountZeroURI() public view returns (string) {
2521         return GameDataLib.getWhiteFlowerURI(data);
2522     }
2523 
2524     /**
2525      * @dev Returns the URI for a particular butterfly gene -- useful for seeing the butterfly "as it was"
2526      * when it dropped a heart
2527      *
2528      * @param gene uint64
2529      * @param isAlive bool
2530      * @return string
2531      */
2532     function getButterflyURIFromGene(uint64 gene, bool isAlive) public view returns (string) {
2533         return GameDataLib.getButterflyURIFromGene(data, gene, isAlive);
2534     }
2535 
2536 
2537     /** Extra token methods **/
2538 
2539     /**
2540      * @dev Claims a flower and an initial butterfly for a given address.
2541      * Requires address to have not claimed previously
2542      *
2543      * @param gardenTimezone uint64
2544      */
2545     function claim(uint64 gardenTimezone) external {
2546         address claimer = msg.sender;
2547 
2548         // claim a butterfly
2549         uint256 butterflyId = GameDataLib.claim(data, claimer, gardenTimezone, uint64(now));
2550 
2551         // mint its token
2552         ERC721Manager.mint(erc721Data, claimer, butterflyId);
2553     }
2554 
2555     /**
2556      * @dev Burns a token.  Caller must be owner or approved.
2557      *
2558      * @param _tokenId uint256 ID of token to burn
2559      */
2560     function burn(uint256 _tokenId) public {
2561         require(ERC721Manager.isApprovedOrOwner(erc721Data, msg.sender, _tokenId));
2562 
2563         address _owner = ERC721Manager.ownerOf(erc721Data, _tokenId);
2564 
2565         _setupTransferFrom(_owner, address(0x0), _tokenId, uint64(now));
2566         ERC721Manager.burn(erc721Data, _owner, _tokenId);
2567     }
2568 
2569 
2570 
2571     /**
2572      * @dev Returns the total number of tokens for a given type, owned by a specific address
2573      *
2574      * @param tokenType uint8
2575      * @param _owner address
2576      *
2577      * @return uint256
2578      */
2579     function typedBalanceOf(uint8 tokenType, address _owner) public view returns (uint256) {
2580         return GameDataLib.typedBalanceOf(data, tokenType, _owner);
2581     }
2582 
2583     /**
2584      * @dev Returns the total number of tokens for a given type
2585      *
2586      * @param tokenType uint8
2587      *
2588      * @return uint256
2589      */
2590     function typedTotalSupply(uint8 tokenType) public view returns (uint256) {
2591         return GameDataLib.typedTotalSupply(data, tokenType);
2592     }
2593 
2594 
2595     /**
2596      * @dev Returns the I-th token of a specific type owned by an index
2597      *
2598      * @param tokenType uint8
2599      * @param _owner address
2600      * @param _index uint256
2601      *
2602      * @return uint256
2603      */
2604     function typedTokenOfOwnerByIndex(
2605         uint8 tokenType,
2606         address _owner,
2607         uint256 _index
2608     ) external view returns (uint256) {
2609         return GameDataLib.typedTokenOfOwnerByIndex(data, tokenType, _owner, _index);
2610     }
2611 
2612     /**
2613      * @dev Returns the I-th token of a specific type
2614      *
2615      * @param tokenType uint8
2616      * @param _index uint256
2617      *
2618      * @return uint256
2619      */
2620     function typedTokenByIndex(
2621         uint8 tokenType,
2622         uint256 _index
2623     ) external view returns (uint256) {
2624         return GameDataLib.typedTokenByIndex(data, tokenType, _index);
2625     }
2626 
2627     /**
2628      * @dev Gets the total number of claimed flowers
2629      *
2630      * @return uint160
2631      */
2632     function totalFlowers() external view returns (uint160) {
2633         return GameDataLib.totalFlowers(data);
2634     }
2635 
2636     /**
2637      * @dev Gets the address of the N-th flower
2638      *
2639      * @return address
2640      */
2641     function getFlowerByIndex(uint160 index) external view returns (address) {
2642         return GameDataLib.getFlowerByIndex(data, index);
2643     }
2644 
2645 
2646     /** Admin setup methods */
2647 
2648     /*
2649     * Methods intended for initial contract setup, to be called at deployment.
2650     * Call renounceOwnership() to make the contract have no owner after setup is complete.
2651     */
2652 
2653     /**
2654      * @dev Registers a new flower URI with the corresponding weight
2655      *
2656      * @param weight uint16 Relative weight for the occurrence of this URI
2657      * @param uri string
2658      */
2659     function addFlowerURI(uint16 weight, string uri) external onlyOwner {
2660         GameDataLib.addFlowerURI(data, weight, uri);
2661     }
2662 
2663     /**
2664      * @dev Registers the flower URI for address 0
2665      *
2666      * @param uri string
2667      */
2668     function setWhiteFlowerURI(string uri) external onlyOwner {
2669         GameDataLib.setWhiteFlowerURI(data, uri);
2670     }
2671 
2672     /**
2673      * @dev Registers a new butterfly URI with the corresponding weight
2674      *
2675      * @param weight uint16 Relative weight for the occurrence of this URI
2676      * @param liveUri string
2677      * @param deadUri string
2678      * @param heartUri string
2679      */
2680     function addButterflyURI(uint16 weight, string liveUri, string deadUri, string heartUri) external onlyOwner {
2681         GameDataLib.addButterflyURI(data, weight, liveUri, deadUri, heartUri);
2682     }
2683 
2684 }