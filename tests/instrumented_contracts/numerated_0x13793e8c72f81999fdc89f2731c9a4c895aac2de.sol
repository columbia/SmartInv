1 pragma solidity ^0.4.24;
2 
3 
4 
5 
6 contract ERC20Basic {
7   function totalSupply() public view returns (uint256);
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 contract ERC20 is ERC20Basic {
14   function allowance(address owner, address spender)
15     public view returns (uint256);
16 
17   function transferFrom(address from, address to, uint256 value)
18     public returns (bool);
19 
20   function approve(address spender, uint256 value) public returns (bool);
21   event Approval(
22     address indexed owner,
23     address indexed spender,
24     uint256 value
25   );
26 }
27 contract DetailedERC20 is ERC20 {
28   string public name;
29   string public symbol;
30   uint8 public decimals;
31 
32   constructor(string _name, string _symbol, uint8 _decimals) public {
33     name = _name;
34     symbol = _symbol;
35     decimals = _decimals;
36   }
37 }
38 
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipRenounced(address indexed previousOwner);
44   event OwnershipTransferred(
45     address indexed previousOwner,
46     address indexed newOwner
47   );
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   constructor() public {
55     owner = msg.sender;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   /**
67    * @dev Allows the current owner to relinquish control of the contract.
68    */
69   function renounceOwnership() public onlyOwner {
70     emit OwnershipRenounced(owner);
71     owner = address(0);
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param _newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address _newOwner) public onlyOwner {
79     _transferOwnership(_newOwner);
80   }
81 
82   /**
83    * @dev Transfers control of the contract to a newOwner.
84    * @param _newOwner The address to transfer ownership to.
85    */
86   function _transferOwnership(address _newOwner) internal {
87     require(_newOwner != address(0));
88     emit OwnershipTransferred(owner, _newOwner);
89     owner = _newOwner;
90   }
91 }
92 
93 library SafeMath {
94   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
95     if (a == 0) {
96       return 0;
97     }
98 
99     c = a * b;
100     assert(c / a == b);
101     return c;
102   }
103 
104   /**
105   * @dev Integer division of two numbers, truncating the quotient.
106   */
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     // assert(b > 0); // Solidity automatically throws when dividing by 0
109     // uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111     return a / b;
112   }
113 
114   /**
115   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
116   */
117   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118     assert(b <= a);
119     return a - b;
120   }
121 
122   /**
123   * @dev Adds two numbers, throws on overflow.
124   */
125   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
126     c = a + b;
127     assert(c >= a);
128     return c;
129   }
130 }
131 
132 /**
133  * Utility library of inline functions on addresses
134  */
135 library AddressUtils {
136 
137   /**
138    * Returns whether the target address is a contract
139    * @dev This function will return false if invoked during the constructor of a contract,
140    *  as the code is not actually created until after the constructor finishes.
141    * @param addr address to check
142    * @return whether the target address is a contract
143    */
144   function isContract(address addr) internal view returns (bool) {
145     uint256 size;
146     // XXX Currently there is no better way to check if there is a contract in an address
147     // than to check the size of the code at that address.
148     // See https://ethereum.stackexchange.com/a/14016/36603
149     // for more details about how this works.
150     // TODO Check this again before the Serenity release, because all addresses will be
151     // contracts then.
152     // solium-disable-next-line security/no-inline-assembly
153     assembly { size := extcodesize(addr) }
154     return size > 0;
155   }
156 
157 }
158 /**
159  * @title ERC721 Non-Fungible Token Standard basic interface
160  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
161  */
162 contract ERC721Basic {
163   event Transfer(
164     address indexed _from,
165     address indexed _to,
166     uint256 _tokenId
167   );
168   event Approval(
169     address indexed _owner,
170     address indexed _approved,
171     uint256 _tokenId
172   );
173   event ApprovalForAll(
174     address indexed _owner,
175     address indexed _operator,
176     bool _approved
177   );
178 
179   function balanceOf(address _owner) public view returns (uint256 _balance);
180   function ownerOf(uint256 _tokenId) public view returns (address _owner);
181   function exists(uint256 _tokenId) public view returns (bool _exists);
182 
183   function approve(address _to, uint256 _tokenId) public;
184   function getApproved(uint256 _tokenId)
185     public view returns (address _operator);
186 
187   function setApprovalForAll(address _operator, bool _approved) public;
188   function isApprovedForAll(address _owner, address _operator)
189     public view returns (bool);
190 
191   function transferFrom(address _from, address _to, uint256 _tokenId) public;
192   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
193     public;
194 
195   function safeTransferFrom(
196     address _from,
197     address _to,
198     uint256 _tokenId,
199     bytes _data
200   )
201     public;
202 }
203 /**
204  * @title ERC721 token receiver interface
205  * @dev Interface for any contract that wants to support safeTransfers
206  *  from ERC721 asset contracts.
207  */
208 contract ERC721Receiver {
209   /**
210    * @dev Magic value to be returned upon successful reception of an NFT
211    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
212    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
213    */
214   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
215 
216   /**
217    * @notice Handle the receipt of an NFT
218    * @dev The ERC721 smart contract calls this function on the recipient
219    *  after a `safetransfer`. This function MAY throw to revert and reject the
220    *  transfer. This function MUST use 50,000 gas or less. Return of other
221    *  than the magic value MUST result in the transaction being reverted.
222    *  Note: the contract address is always the message sender.
223    * @param _from The sending address
224    * @param _tokenId The NFT identifier which is being transfered
225    * @param _data Additional data with no specified format
226    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
227    */
228   function onERC721Received(
229     address _from,
230     uint256 _tokenId,
231     bytes _data
232   )
233     public
234     returns(bytes4);
235 }
236 
237 /**
238  * @title ERC721 Non-Fungible Token Standard basic implementation
239  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
240  */
241 contract ERC721BasicToken is ERC721Basic {
242   using SafeMath for uint256;
243   using AddressUtils for address;
244 
245   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
246   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
247   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
248 
249   // Mapping from token ID to owner
250   mapping (uint256 => address) internal tokenOwner;
251 
252   // Mapping from token ID to approved address
253   mapping (uint256 => address) internal tokenApprovals;
254 
255   // Mapping from owner to number of owned token
256   mapping (address => uint256) internal ownedTokensCount;
257 
258   // Mapping from owner to operator approvals
259   mapping (address => mapping (address => bool)) internal operatorApprovals;
260 
261   /**
262    * @dev Guarantees msg.sender is owner of the given token
263    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
264    */
265   modifier onlyOwnerOf(uint256 _tokenId) {
266     require(ownerOf(_tokenId) == msg.sender);
267     _;
268   }
269 
270   /**
271    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
272    * @param _tokenId uint256 ID of the token to validate
273    */
274   modifier canTransfer(uint256 _tokenId) {
275     require(isApprovedOrOwner(msg.sender, _tokenId));
276     _;
277   }
278 
279   /**
280    * @dev Gets the balance of the specified address
281    * @param _owner address to query the balance of
282    * @return uint256 representing the amount owned by the passed address
283    */
284   function balanceOf(address _owner) public view returns (uint256) {
285     require(_owner != address(0));
286     return ownedTokensCount[_owner];
287   }
288 
289   /**
290    * @dev Gets the owner of the specified token ID
291    * @param _tokenId uint256 ID of the token to query the owner of
292    * @return owner address currently marked as the owner of the given token ID
293    */
294   function ownerOf(uint256 _tokenId) public view returns (address) {
295     address owner = tokenOwner[_tokenId];
296     require(owner != address(0));
297     return owner;
298   }
299 
300   /**
301    * @dev Returns whether the specified token exists
302    * @param _tokenId uint256 ID of the token to query the existence of
303    * @return whether the token exists
304    */
305   function exists(uint256 _tokenId) public view returns (bool) {
306     address owner = tokenOwner[_tokenId];
307     return owner != address(0);
308   }
309 
310   /**
311    * @dev Approves another address to transfer the given token ID
312    * @dev The zero address indicates there is no approved address.
313    * @dev There can only be one approved address per token at a given time.
314    * @dev Can only be called by the token owner or an approved operator.
315    * @param _to address to be approved for the given token ID
316    * @param _tokenId uint256 ID of the token to be approved
317    */
318   function approve(address _to, uint256 _tokenId) public {
319     address owner = ownerOf(_tokenId);
320     require(_to != owner);
321     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
322 
323     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
324       tokenApprovals[_tokenId] = _to;
325       emit Approval(owner, _to, _tokenId);
326     }
327   }
328 
329   /**
330    * @dev Gets the approved address for a token ID, or zero if no address set
331    * @param _tokenId uint256 ID of the token to query the approval of
332    * @return address currently approved for the given token ID
333    */
334   function getApproved(uint256 _tokenId) public view returns (address) {
335     return tokenApprovals[_tokenId];
336   }
337 
338   /**
339    * @dev Sets or unsets the approval of a given operator
340    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
341    * @param _to operator address to set the approval
342    * @param _approved representing the status of the approval to be set
343    */
344   function setApprovalForAll(address _to, bool _approved) public {
345     require(_to != msg.sender);
346     operatorApprovals[msg.sender][_to] = _approved;
347     emit ApprovalForAll(msg.sender, _to, _approved);
348   }
349 
350   /**
351    * @dev Tells whether an operator is approved by a given owner
352    * @param _owner owner address which you want to query the approval of
353    * @param _operator operator address which you want to query the approval of
354    * @return bool whether the given operator is approved by the given owner
355    */
356   function isApprovedForAll(
357     address _owner,
358     address _operator
359   )
360     public
361     view
362     returns (bool)
363   {
364     return operatorApprovals[_owner][_operator];
365   }
366 
367   /**
368    * @dev Transfers the ownership of a given token ID to another address
369    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
370    * @dev Requires the msg sender to be the owner, approved, or operator
371    * @param _from current owner of the token
372    * @param _to address to receive the ownership of the given token ID
373    * @param _tokenId uint256 ID of the token to be transferred
374   */
375   function transferFrom(
376     address _from,
377     address _to,
378     uint256 _tokenId
379   )
380     public
381     canTransfer(_tokenId)
382   {
383     require(_from != address(0));
384     require(_to != address(0));
385 
386     clearApproval(_from, _tokenId);
387     removeTokenFrom(_from, _tokenId);
388     addTokenTo(_to, _tokenId);
389 
390     emit Transfer(_from, _to, _tokenId);
391   }
392 
393   /**
394    * @dev Safely transfers the ownership of a given token ID to another address
395    * @dev If the target address is a contract, it must implement `onERC721Received`,
396    *  which is called upon a safe transfer, and return the magic value
397    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
398    *  the transfer is reverted.
399    * @dev Requires the msg sender to be the owner, approved, or operator
400    * @param _from current owner of the token
401    * @param _to address to receive the ownership of the given token ID
402    * @param _tokenId uint256 ID of the token to be transferred
403   */
404   function safeTransferFrom(
405     address _from,
406     address _to,
407     uint256 _tokenId
408   )
409     public
410     canTransfer(_tokenId)
411   {
412     // solium-disable-next-line arg-overflow
413     safeTransferFrom(_from, _to, _tokenId, "");
414   }
415 
416   /**
417    * @dev Safely transfers the ownership of a given token ID to another address
418    * @dev If the target address is a contract, it must implement `onERC721Received`,
419    *  which is called upon a safe transfer, and return the magic value
420    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
421    *  the transfer is reverted.
422    * @dev Requires the msg sender to be the owner, approved, or operator
423    * @param _from current owner of the token
424    * @param _to address to receive the ownership of the given token ID
425    * @param _tokenId uint256 ID of the token to be transferred
426    * @param _data bytes data to send along with a safe transfer check
427    */
428   function safeTransferFrom(
429     address _from,
430     address _to,
431     uint256 _tokenId,
432     bytes _data
433   )
434     public
435     canTransfer(_tokenId)
436   {
437     transferFrom(_from, _to, _tokenId);
438     // solium-disable-next-line arg-overflow
439     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
440   }
441 
442   /**
443    * @dev Returns whether the given spender can transfer a given token ID
444    * @param _spender address of the spender to query
445    * @param _tokenId uint256 ID of the token to be transferred
446    * @return bool whether the msg.sender is approved for the given token ID,
447    *  is an operator of the owner, or is the owner of the token
448    */
449   function isApprovedOrOwner(
450     address _spender,
451     uint256 _tokenId
452   )
453     internal
454     view
455     returns (bool)
456   {
457     address owner = ownerOf(_tokenId);
458     // Disable solium check because of
459     // https://github.com/duaraghav8/Solium/issues/175
460     // solium-disable-next-line operator-whitespace
461     return (
462       _spender == owner ||
463       getApproved(_tokenId) == _spender ||
464       isApprovedForAll(owner, _spender)
465     );
466   }
467 
468   /**
469    * @dev Internal function to mint a new token
470    * @dev Reverts if the given token ID already exists
471    * @param _to The address that will own the minted token
472    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
473    */
474   function _mint(address _to, uint256 _tokenId) internal {
475     require(_to != address(0));
476     addTokenTo(_to, _tokenId);
477     emit Transfer(address(0), _to, _tokenId);
478   }
479 
480   /**
481    * @dev Internal function to burn a specific token
482    * @dev Reverts if the token does not exist
483    * @param _tokenId uint256 ID of the token being burned by the msg.sender
484    */
485   function _burn(address _owner, uint256 _tokenId) internal {
486     clearApproval(_owner, _tokenId);
487     removeTokenFrom(_owner, _tokenId);
488     emit Transfer(_owner, address(0), _tokenId);
489   }
490 
491   /**
492    * @dev Internal function to clear current approval of a given token ID
493    * @dev Reverts if the given address is not indeed the owner of the token
494    * @param _owner owner of the token
495    * @param _tokenId uint256 ID of the token to be transferred
496    */
497   function clearApproval(address _owner, uint256 _tokenId) internal {
498     require(ownerOf(_tokenId) == _owner);
499     if (tokenApprovals[_tokenId] != address(0)) {
500       tokenApprovals[_tokenId] = address(0);
501       emit Approval(_owner, address(0), _tokenId);
502     }
503   }
504 
505   /**
506    * @dev Internal function to add a token ID to the list of a given address
507    * @param _to address representing the new owner of the given token ID
508    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
509    */
510   function addTokenTo(address _to, uint256 _tokenId) internal {
511     require(tokenOwner[_tokenId] == address(0));
512     tokenOwner[_tokenId] = _to;
513     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
514   }
515 
516   /**
517    * @dev Internal function to remove a token ID from the list of a given address
518    * @param _from address representing the previous owner of the given token ID
519    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
520    */
521   function removeTokenFrom(address _from, uint256 _tokenId) internal {
522     require(ownerOf(_tokenId) == _from);
523     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
524     tokenOwner[_tokenId] = address(0);
525   }
526 
527   /**
528    * @dev Internal function to invoke `onERC721Received` on a target address
529    * @dev The call is not executed if the target address is not a contract
530    * @param _from address representing the previous owner of the given token ID
531    * @param _to target address that will receive the tokens
532    * @param _tokenId uint256 ID of the token to be transferred
533    * @param _data bytes optional data to send along with the call
534    * @return whether the call correctly returned the expected magic value
535    */
536   function checkAndCallSafeTransfer(
537     address _from,
538     address _to,
539     uint256 _tokenId,
540     bytes _data
541   )
542     internal
543     returns (bool)
544   {
545     if (!_to.isContract()) {
546       return true;
547     }
548     bytes4 retval = ERC721Receiver(_to).onERC721Received(
549       _from, _tokenId, _data);
550     return (retval == ERC721_RECEIVED);
551   }
552 }
553 
554 
555 /**
556  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
557  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
558  */
559 contract ERC721Enumerable is ERC721Basic {
560   function totalSupply() public view returns (uint256);
561   function tokenOfOwnerByIndex(
562     address _owner,
563     uint256 _index
564   )
565     public
566     view
567     returns (uint256 _tokenId);
568 
569   function tokenByIndex(uint256 _index) public view returns (uint256);
570 }
571 
572 
573 /**
574  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
575  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
576  */
577 contract ERC721Metadata is ERC721Basic {
578   function name() public view returns (string _name);
579   function symbol() public view returns (string _symbol);
580   function tokenURI(uint256 _tokenId) public view returns (string);
581 }
582 
583 
584 /**
585  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
586  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
587  */
588 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
589 }
590 
591 
592 contract ERC721Token is ERC721, ERC721BasicToken {
593   // Token name
594     string internal name_;
595 
596   // Token symbol
597     string internal symbol_;
598 
599   // Mapping from owner to list of owned token IDs
600     mapping(address => uint256[]) internal ownedTokens;
601 
602   // Mapping from token ID to index of the owner tokens list
603     mapping(uint256 => uint256) internal ownedTokensIndex;
604 
605   // Array with all token ids, used for enumeration
606     uint256[] internal allTokens;
607 
608   // Mapping from token id to position in the allTokens array
609     mapping(uint256 => uint256) internal allTokensIndex;
610 
611 
612   /**
613    * @dev Constructor function
614    */
615     constructor(string _name, string _symbol) public {
616         name_ = _name;
617         symbol_ = _symbol;
618     }
619 
620   /**
621    * @dev Gets the token name
622    * @return string representing the token name
623    */
624     function name() public view returns (string) {
625         return name_;
626     }
627 
628   /**
629    * @dev Gets the token symbol
630    * @return string representing the token symbol
631    */
632     function symbol() public view returns (string) {
633         return symbol_;
634     }
635 
636 
637   /**
638    * @dev Gets the token ID at a given index of the tokens list of the requested owner
639    * @param _owner address owning the tokens list to be accessed
640    * @param _index uint256 representing the index to be accessed of the requested tokens list
641    * @return uint256 token ID at the given index of the tokens list owned by the requested address
642    */
643     function tokenOfOwnerByIndex(
644         address _owner,
645         uint256 _index
646     )
647         public
648         view
649         returns (uint256)
650     {
651         require(_index < balanceOf(_owner));
652         return ownedTokens[_owner][_index];
653     }
654 
655   /**
656    * @dev Gets the total amount of tokens stored by the contract
657    * @return uint256 representing the total amount of tokens
658    */
659     function totalSupply() public view returns (uint256) {
660         return allTokens.length;
661     }
662 
663   /**
664    * @dev Gets the token ID at a given index of all the tokens in this contract
665    * @dev Reverts if the index is greater or equal to the total number of tokens
666    * @param _index uint256 representing the index to be accessed of the tokens list
667    * @return uint256 token ID at the given index of the tokens list
668    */
669     function tokenByIndex(uint256 _index) public view returns (uint256) {
670         require(_index < totalSupply());
671         return allTokens[_index];
672     }
673 
674 
675   /**
676    * @dev Internal function to add a token ID to the list of a given address
677    * @param _to address representing the new owner of the given token ID
678    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
679    */
680     function addTokenTo(address _to, uint256 _tokenId) internal {
681         super.addTokenTo(_to, _tokenId);
682         uint256 length = ownedTokens[_to].length;
683         ownedTokens[_to].push(_tokenId);
684         ownedTokensIndex[_tokenId] = length;
685     }
686 
687   /**
688    * @dev Internal function to remove a token ID from the list of a given address
689    * @param _from address representing the previous owner of the given token ID
690    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
691    */
692     function removeTokenFrom(address _from, uint256 _tokenId) internal {
693         super.removeTokenFrom(_from, _tokenId);
694 
695         uint256 tokenIndex = ownedTokensIndex[_tokenId];
696         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
697         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
698 
699         ownedTokens[_from][tokenIndex] = lastToken;
700         ownedTokens[_from][lastTokenIndex] = 0;
701         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
702         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
703         // the lastToken to the first position, and then dropping the element placed in the last position of the list
704 
705         ownedTokens[_from].length--;
706         ownedTokensIndex[_tokenId] = 0;
707         ownedTokensIndex[lastToken] = tokenIndex;
708     }
709 
710   /**
711    * @dev Internal function to mint a new token
712    * @dev Reverts if the given token ID already exists
713    * @param _to address the beneficiary that will own the minted token
714    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
715    */
716     function _mint(address _to, uint256 _tokenId) internal {
717         super._mint(_to, _tokenId);
718 
719         allTokensIndex[_tokenId] = allTokens.length;
720         allTokens.push(_tokenId);
721     }
722 
723  
724 
725 }
726 
727 contract DatesNFT is ERC721Token, Ownable {
728     using SafeMath for uint256;
729 
730     constructor () public
731     ERC721Token("Crypto Dates", "CD")
732     { }
733     
734     uint256 public price;
735 
736     function withdrawBalance() onlyOwner external {
737         assert(owner.send(address(this).balance));
738     }
739     function approveToken(address token, uint256 amount) onlyOwner external {
740         assert(DetailedERC20(token).approve(owner, amount));
741     }
742 
743     function() external payable { }
744 
745     function updatePrice(uint256 newPrice) external onlyOwner {
746         price = newPrice;
747     }
748 
749     string public tokenURIPrefix = "https://api.cryptodate.io/date/";
750 
751     function updateTokenURIPrefix(string newPrefix) external onlyOwner {
752         tokenURIPrefix = newPrefix;
753     }
754 
755     function mint(address _to, uint256 _tokenId) external payable {
756         require(_tokenId > 9991231 && _tokenId < 29991232);
757         if (_to != owner){
758             require(msg.value == price);
759         }
760         super._mint (_to, _tokenId);
761     }
762 
763    
764     function tokenURI(uint256 _tokenId) public view returns (string) {
765         return string(abi.encodePacked(tokenURIPrefix,uint2str(_tokenId)));
766     }
767   
768     function uint2str(uint i) internal pure returns (string) {
769         if (i == 0) return "0";
770         uint j = i;
771         uint length;
772         while (j != 0){
773             length++;
774             j /= 10;
775         }
776 
777         bytes memory bstr = new bytes(length);
778     
779         uint k = length - 1;
780         while (i != 0){
781             bstr[k--] = byte(48 + i % 10);
782             i /= 10;
783         }
784     
785         return string(bstr);
786     
787     }
788 
789 }