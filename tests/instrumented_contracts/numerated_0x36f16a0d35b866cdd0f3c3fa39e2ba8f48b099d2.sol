1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC165
6  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
7  */
8 interface ERC165 {
9 
10   /**
11    * @notice Query if a contract implements an interface
12    * @param _interfaceId The interface identifier, as specified in ERC-165
13    * @dev Interface identification is specified in ERC-165. This function
14    * uses less than 30,000 gas.
15    */
16   function supportsInterface(bytes4 _interfaceId)
17     external
18     view
19     returns (bool);
20 }
21 
22 
23 /**
24  * @title ERC721 Non-Fungible Token Standard basic interface
25  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
26  */
27 contract ERC721Basic is ERC165 {
28 
29   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
30   /*
31    * 0x80ac58cd ===
32    *   bytes4(keccak256('balanceOf(address)')) ^
33    *   bytes4(keccak256('ownerOf(uint256)')) ^
34    *   bytes4(keccak256('approve(address,uint256)')) ^
35    *   bytes4(keccak256('getApproved(uint256)')) ^
36    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
37    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
38    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
39    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
40    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
41    */
42 
43   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
44   /*
45    * 0x4f558e79 ===
46    *   bytes4(keccak256('exists(uint256)'))
47    */
48 
49   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
50   /**
51    * 0x780e9d63 ===
52    *   bytes4(keccak256('totalSupply()')) ^
53    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
54    *   bytes4(keccak256('tokenByIndex(uint256)'))
55    */
56 
57   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
58   /**
59    * 0x5b5e139f ===
60    *   bytes4(keccak256('name()')) ^
61    *   bytes4(keccak256('symbol()')) ^
62    *   bytes4(keccak256('tokenURI(uint256)'))
63    */
64 
65   event Transfer(
66     address indexed _from,
67     address indexed _to,
68     uint256 indexed _tokenId
69   );
70   event Approval(
71     address indexed _owner,
72     address indexed _approved,
73     uint256 indexed _tokenId
74   );
75   event ApprovalForAll(
76     address indexed _owner,
77     address indexed _operator,
78     bool _approved
79   );
80 
81   function balanceOf(address _owner) public view returns (uint256 _balance);
82   function ownerOf(uint256 _tokenId) public view returns (address _owner);
83   function exists(uint256 _tokenId) public view returns (bool _exists);
84 
85   function approve(address _to, uint256 _tokenId) public;
86   function getApproved(uint256 _tokenId)
87     public view returns (address _operator);
88 
89   function setApprovalForAll(address _operator, bool _approved) public;
90   function isApprovedForAll(address _owner, address _operator)
91     public view returns (bool);
92 
93   function transferFrom(address _from, address _to, uint256 _tokenId) public;
94   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
95     public;
96 
97   function safeTransferFrom(
98     address _from,
99     address _to,
100     uint256 _tokenId,
101     bytes _data
102   )
103     public;
104 }
105 
106 
107 /**
108  * @title Ownable
109  * @dev The Ownable contract has an owner address, and provides basic authorization control
110  * functions, this simplifies the implementation of "user permissions".
111  */
112 contract Ownable {
113   address public owner;
114 
115 
116   event OwnershipRenounced(address indexed previousOwner);
117   event OwnershipTransferred(
118     address indexed previousOwner,
119     address indexed newOwner
120   );
121 
122 
123   /**
124    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
125    * account.
126    */
127   constructor() public {
128     owner = msg.sender;
129   }
130 
131   /**
132    * @dev Throws if called by any account other than the owner.
133    */
134   modifier onlyOwner() {
135     require(msg.sender == owner);
136     _;
137   }
138 
139   /**
140    * @dev Allows the current owner to relinquish control of the contract.
141    * @notice Renouncing to ownership will leave the contract without an owner.
142    * It will not be possible to call the functions with the `onlyOwner`
143    * modifier anymore.
144    */
145   function renounceOwnership() public onlyOwner {
146     emit OwnershipRenounced(owner);
147     owner = address(0);
148   }
149 
150   /**
151    * @dev Allows the current owner to transfer control of the contract to a newOwner.
152    * @param _newOwner The address to transfer ownership to.
153    */
154   function transferOwnership(address _newOwner) public onlyOwner {
155     _transferOwnership(_newOwner);
156   }
157 
158   /**
159    * @dev Transfers control of the contract to a newOwner.
160    * @param _newOwner The address to transfer ownership to.
161    */
162   function _transferOwnership(address _newOwner) internal {
163     require(_newOwner != address(0));
164     emit OwnershipTransferred(owner, _newOwner);
165     owner = _newOwner;
166   }
167 }
168 
169 
170 interface POUInterface {
171 
172     function totalStaked(address) external view returns(uint256);
173     function numApplications(address) external view returns(uint256);
174 
175 }
176 
177 
178 /*
179 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
180 .*/
181 
182 
183 
184 
185 // Abstract contract for the full ERC 20 Token standard
186 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
187 
188 
189 
190 contract EIP20Interface {
191     /* This is a slight change to the ERC20 base standard.
192     function totalSupply() constant returns (uint256 supply);
193     is replaced with:
194     uint256 public totalSupply;
195     This automatically creates a getter function for the totalSupply.
196     This is moved to the base contract since public getter functions are not
197     currently recognised as an implementation of the matching abstract
198     function by the compiler.
199     */
200     /// total amount of tokens
201     uint256 public totalSupply;
202 
203     /// @param _owner The address from which the balance will be retrieved
204     /// @return The balance
205     function balanceOf(address _owner) public view returns (uint256 balance);
206 
207     /// @notice send `_value` token to `_to` from `msg.sender`
208     /// @param _to The address of the recipient
209     /// @param _value The amount of token to be transferred
210     /// @return Whether the transfer was successful or not
211     function transfer(address _to, uint256 _value) public returns (bool success);
212 
213     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
214     /// @param _from The address of the sender
215     /// @param _to The address of the recipient
216     /// @param _value The amount of token to be transferred
217     /// @return Whether the transfer was successful or not
218     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
219 
220     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
221     /// @param _spender The address of the account able to transfer the tokens
222     /// @param _value The amount of tokens to be approved for transfer
223     /// @return Whether the approval was successful or not
224     function approve(address _spender, uint256 _value) public returns (bool success);
225 
226     /// @param _owner The address of the account owning tokens
227     /// @param _spender The address of the account able to transfer the tokens
228     /// @return Amount of remaining tokens allowed to spent
229     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
230 
231     // solhint-disable-next-line no-simple-event-func-name
232     event Transfer(address indexed _from, address indexed _to, uint256 _value);
233     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
234 }
235 
236 
237 
238 contract EIP20 is EIP20Interface {
239 
240     uint256 constant private MAX_UINT256 = 2**256 - 1;
241     mapping (address => uint256) public balances;
242     mapping (address => mapping (address => uint256)) public allowed;
243     /*
244     NOTE:
245     The following variables are OPTIONAL vanities. One does not have to include them.
246     They allow one to customise the token contract & in no way influences the core functionality.
247     Some wallets/interfaces might not even bother to look at this information.
248     */
249     string public name;                   //fancy name: eg Simon Bucks
250     uint8 public decimals;                //How many decimals to show.
251     string public symbol;                 //An identifier: eg SBX
252 
253     function EIP20(
254         uint256 _initialAmount,
255         string _tokenName,
256         uint8 _decimalUnits,
257         string _tokenSymbol
258     ) public {
259         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
260         totalSupply = _initialAmount;                        // Update total supply
261         name = _tokenName;                                   // Set the name for display purposes
262         decimals = _decimalUnits;                            // Amount of decimals for display purposes
263         symbol = _tokenSymbol;                               // Set the symbol for display purposes
264     }
265 
266     function transfer(address _to, uint256 _value) public returns (bool success) {
267         require(balances[msg.sender] >= _value);
268         balances[msg.sender] -= _value;
269         balances[_to] += _value;
270         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
271         return true;
272     }
273 
274     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
275         uint256 allowance = allowed[_from][msg.sender];
276         require(balances[_from] >= _value && allowance >= _value);
277         balances[_to] += _value;
278         balances[_from] -= _value;
279         if (allowance < MAX_UINT256) {
280             allowed[_from][msg.sender] -= _value;
281         }
282         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
283         return true;
284     }
285 
286     function balanceOf(address _owner) public view returns (uint256 balance) {
287         return balances[_owner];
288     }
289 
290     function approve(address _spender, uint256 _value) public returns (bool success) {
291         allowed[msg.sender][_spender] = _value;
292         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
293         return true;
294     }
295 
296     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
297         return allowed[_owner][_spender];
298     }
299 }
300 
301 
302 
303 
304 
305 
306 
307 
308 
309 
310 /// @title Interface for token controllers. The controller specifies whether a transfer can be done.
311 contract TokenControllerI {
312 
313     /// @dev Specifies whether a transfer is allowed or not.
314     /// @return True if the transfer is allowed
315     function transferAllowed(address _from, address _to)
316         external
317         view 
318         returns (bool);
319 }
320 
321 
322 
323 
324 
325 
326 
327 /**
328  * @title ERC721 token receiver interface
329  * @dev Interface for any contract that wants to support safeTransfers
330  * from ERC721 asset contracts.
331  */
332 contract ERC721Receiver {
333   /**
334    * @dev Magic value to be returned upon successful reception of an NFT
335    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
336    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
337    */
338   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
339 
340   /**
341    * @notice Handle the receipt of an NFT
342    * @dev The ERC721 smart contract calls this function on the recipient
343    * after a `safetransfer`. This function MAY throw to revert and reject the
344    * transfer. Return of other than the magic value MUST result in the
345    * transaction being reverted.
346    * Note: the contract address is always the message sender.
347    * @param _operator The address which called `safeTransferFrom` function
348    * @param _from The address which previously owned the token
349    * @param _tokenId The NFT identifier which is being transferred
350    * @param _data Additional data with no specified format
351    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
352    */
353   function onERC721Received(
354     address _operator,
355     address _from,
356     uint256 _tokenId,
357     bytes _data
358   )
359     public
360     returns(bytes4);
361 }
362 
363 
364 
365 
366 
367 /**
368  * Utility library of inline functions on addresses
369  */
370 library AddressUtils {
371 
372   /**
373    * Returns whether the target address is a contract
374    * @dev This function will return false if invoked during the constructor of a contract,
375    * as the code is not actually created until after the constructor finishes.
376    * @param _addr address to check
377    * @return whether the target address is a contract
378    */
379   function isContract(address _addr) internal view returns (bool) {
380     uint256 size;
381     // XXX Currently there is no better way to check if there is a contract in an address
382     // than to check the size of the code at that address.
383     // See https://ethereum.stackexchange.com/a/14016/36603
384     // for more details about how this works.
385     // TODO Check this again before the Serenity release, because all addresses will be
386     // contracts then.
387     // solium-disable-next-line security/no-inline-assembly
388     assembly { size := extcodesize(_addr) }
389     return size > 0;
390   }
391 
392 }
393 
394 
395 
396 
397 
398 
399 /**
400  * @title SupportsInterfaceWithLookup
401  * @author Matt Condon (@shrugs)
402  * @dev Implements ERC165 using a lookup table.
403  */
404 contract SupportsInterfaceWithLookup is ERC165 {
405 
406   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
407   /**
408    * 0x01ffc9a7 ===
409    *   bytes4(keccak256('supportsInterface(bytes4)'))
410    */
411 
412   /**
413    * @dev a mapping of interface id to whether or not it's supported
414    */
415   mapping(bytes4 => bool) internal supportedInterfaces;
416 
417   /**
418    * @dev A contract implementing SupportsInterfaceWithLookup
419    * implement ERC165 itself
420    */
421   constructor()
422     public
423   {
424     _registerInterface(InterfaceId_ERC165);
425   }
426 
427   /**
428    * @dev implement supportsInterface(bytes4) using a lookup table
429    */
430   function supportsInterface(bytes4 _interfaceId)
431     external
432     view
433     returns (bool)
434   {
435     return supportedInterfaces[_interfaceId];
436   }
437 
438   /**
439    * @dev private method for registering an interface
440    */
441   function _registerInterface(bytes4 _interfaceId)
442     internal
443   {
444     require(_interfaceId != 0xffffffff);
445     supportedInterfaces[_interfaceId] = true;
446   }
447 }
448 
449 
450 
451 /**
452  * @title ERC721 Non-Fungible Token Standard basic implementation
453  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
454  */
455 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
456 
457   using SafeMath for uint256;
458   using AddressUtils for address;
459 
460   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
461   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
462   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
463 
464   // Mapping from token ID to owner
465   mapping (uint256 => address) internal tokenOwner;
466 
467   // Mapping from token ID to approved address
468   mapping (uint256 => address) internal tokenApprovals;
469 
470   // Mapping from owner to number of owned token
471   mapping (address => uint256) internal ownedTokensCount;
472 
473   // Mapping from owner to operator approvals
474   mapping (address => mapping (address => bool)) internal operatorApprovals;
475 
476   constructor()
477     public
478   {
479     // register the supported interfaces to conform to ERC721 via ERC165
480     _registerInterface(InterfaceId_ERC721);
481     _registerInterface(InterfaceId_ERC721Exists);
482   }
483 
484   /**
485    * @dev Gets the balance of the specified address
486    * @param _owner address to query the balance of
487    * @return uint256 representing the amount owned by the passed address
488    */
489   function balanceOf(address _owner) public view returns (uint256) {
490     require(_owner != address(0));
491     return ownedTokensCount[_owner];
492   }
493 
494   /**
495    * @dev Gets the owner of the specified token ID
496    * @param _tokenId uint256 ID of the token to query the owner of
497    * @return owner address currently marked as the owner of the given token ID
498    */
499   function ownerOf(uint256 _tokenId) public view returns (address) {
500     address owner = tokenOwner[_tokenId];
501     require(owner != address(0));
502     return owner;
503   }
504 
505   /**
506    * @dev Returns whether the specified token exists
507    * @param _tokenId uint256 ID of the token to query the existence of
508    * @return whether the token exists
509    */
510   function exists(uint256 _tokenId) public view returns (bool) {
511     address owner = tokenOwner[_tokenId];
512     return owner != address(0);
513   }
514 
515   /**
516    * @dev Approves another address to transfer the given token ID
517    * The zero address indicates there is no approved address.
518    * There can only be one approved address per token at a given time.
519    * Can only be called by the token owner or an approved operator.
520    * @param _to address to be approved for the given token ID
521    * @param _tokenId uint256 ID of the token to be approved
522    */
523   function approve(address _to, uint256 _tokenId) public {
524     address owner = ownerOf(_tokenId);
525     require(_to != owner);
526     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
527 
528     tokenApprovals[_tokenId] = _to;
529     emit Approval(owner, _to, _tokenId);
530   }
531 
532   /**
533    * @dev Gets the approved address for a token ID, or zero if no address set
534    * @param _tokenId uint256 ID of the token to query the approval of
535    * @return address currently approved for the given token ID
536    */
537   function getApproved(uint256 _tokenId) public view returns (address) {
538     return tokenApprovals[_tokenId];
539   }
540 
541   /**
542    * @dev Sets or unsets the approval of a given operator
543    * An operator is allowed to transfer all tokens of the sender on their behalf
544    * @param _to operator address to set the approval
545    * @param _approved representing the status of the approval to be set
546    */
547   function setApprovalForAll(address _to, bool _approved) public {
548     require(_to != msg.sender);
549     operatorApprovals[msg.sender][_to] = _approved;
550     emit ApprovalForAll(msg.sender, _to, _approved);
551   }
552 
553   /**
554    * @dev Tells whether an operator is approved by a given owner
555    * @param _owner owner address which you want to query the approval of
556    * @param _operator operator address which you want to query the approval of
557    * @return bool whether the given operator is approved by the given owner
558    */
559   function isApprovedForAll(
560     address _owner,
561     address _operator
562   )
563     public
564     view
565     returns (bool)
566   {
567     return operatorApprovals[_owner][_operator];
568   }
569 
570   /**
571    * @dev Transfers the ownership of a given token ID to another address
572    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
573    * Requires the msg sender to be the owner, approved, or operator
574    * @param _from current owner of the token
575    * @param _to address to receive the ownership of the given token ID
576    * @param _tokenId uint256 ID of the token to be transferred
577   */
578   function transferFrom(
579     address _from,
580     address _to,
581     uint256 _tokenId
582   )
583     public
584   {
585     require(isApprovedOrOwner(msg.sender, _tokenId));
586     require(_from != address(0));
587     require(_to != address(0));
588 
589     clearApproval(_from, _tokenId);
590     removeTokenFrom(_from, _tokenId);
591     addTokenTo(_to, _tokenId);
592 
593     emit Transfer(_from, _to, _tokenId);
594   }
595 
596   /**
597    * @dev Safely transfers the ownership of a given token ID to another address
598    * If the target address is a contract, it must implement `onERC721Received`,
599    * which is called upon a safe transfer, and return the magic value
600    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
601    * the transfer is reverted.
602    *
603    * Requires the msg sender to be the owner, approved, or operator
604    * @param _from current owner of the token
605    * @param _to address to receive the ownership of the given token ID
606    * @param _tokenId uint256 ID of the token to be transferred
607   */
608   function safeTransferFrom(
609     address _from,
610     address _to,
611     uint256 _tokenId
612   )
613     public
614   {
615     // solium-disable-next-line arg-overflow
616     safeTransferFrom(_from, _to, _tokenId, "");
617   }
618 
619   /**
620    * @dev Safely transfers the ownership of a given token ID to another address
621    * If the target address is a contract, it must implement `onERC721Received`,
622    * which is called upon a safe transfer, and return the magic value
623    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
624    * the transfer is reverted.
625    * Requires the msg sender to be the owner, approved, or operator
626    * @param _from current owner of the token
627    * @param _to address to receive the ownership of the given token ID
628    * @param _tokenId uint256 ID of the token to be transferred
629    * @param _data bytes data to send along with a safe transfer check
630    */
631   function safeTransferFrom(
632     address _from,
633     address _to,
634     uint256 _tokenId,
635     bytes _data
636   )
637     public
638   {
639     transferFrom(_from, _to, _tokenId);
640     // solium-disable-next-line arg-overflow
641     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
642   }
643 
644   /**
645    * @dev Returns whether the given spender can transfer a given token ID
646    * @param _spender address of the spender to query
647    * @param _tokenId uint256 ID of the token to be transferred
648    * @return bool whether the msg.sender is approved for the given token ID,
649    *  is an operator of the owner, or is the owner of the token
650    */
651   function isApprovedOrOwner(
652     address _spender,
653     uint256 _tokenId
654   )
655     internal
656     view
657     returns (bool)
658   {
659     address owner = ownerOf(_tokenId);
660     // Disable solium check because of
661     // https://github.com/duaraghav8/Solium/issues/175
662     // solium-disable-next-line operator-whitespace
663     return (
664       _spender == owner ||
665       getApproved(_tokenId) == _spender ||
666       isApprovedForAll(owner, _spender)
667     );
668   }
669 
670   /**
671    * @dev Internal function to mint a new token
672    * Reverts if the given token ID already exists
673    * @param _to The address that will own the minted token
674    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
675    */
676   function _mint(address _to, uint256 _tokenId) internal {
677     require(_to != address(0));
678     addTokenTo(_to, _tokenId);
679     emit Transfer(address(0), _to, _tokenId);
680   }
681 
682   /**
683    * @dev Internal function to burn a specific token
684    * Reverts if the token does not exist
685    * @param _tokenId uint256 ID of the token being burned by the msg.sender
686    */
687   function _burn(address _owner, uint256 _tokenId) internal {
688     clearApproval(_owner, _tokenId);
689     removeTokenFrom(_owner, _tokenId);
690     emit Transfer(_owner, address(0), _tokenId);
691   }
692 
693   /**
694    * @dev Internal function to clear current approval of a given token ID
695    * Reverts if the given address is not indeed the owner of the token
696    * @param _owner owner of the token
697    * @param _tokenId uint256 ID of the token to be transferred
698    */
699   function clearApproval(address _owner, uint256 _tokenId) internal {
700     require(ownerOf(_tokenId) == _owner);
701     if (tokenApprovals[_tokenId] != address(0)) {
702       tokenApprovals[_tokenId] = address(0);
703     }
704   }
705 
706   /**
707    * @dev Internal function to add a token ID to the list of a given address
708    * @param _to address representing the new owner of the given token ID
709    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
710    */
711   function addTokenTo(address _to, uint256 _tokenId) internal {
712     require(tokenOwner[_tokenId] == address(0));
713     tokenOwner[_tokenId] = _to;
714     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
715   }
716 
717   /**
718    * @dev Internal function to remove a token ID from the list of a given address
719    * @param _from address representing the previous owner of the given token ID
720    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
721    */
722   function removeTokenFrom(address _from, uint256 _tokenId) internal {
723     require(ownerOf(_tokenId) == _from);
724     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
725     tokenOwner[_tokenId] = address(0);
726   }
727 
728   /**
729    * @dev Internal function to invoke `onERC721Received` on a target address
730    * The call is not executed if the target address is not a contract
731    * @param _from address representing the previous owner of the given token ID
732    * @param _to target address that will receive the tokens
733    * @param _tokenId uint256 ID of the token to be transferred
734    * @param _data bytes optional data to send along with the call
735    * @return whether the call correctly returned the expected magic value
736    */
737   function checkAndCallSafeTransfer(
738     address _from,
739     address _to,
740     uint256 _tokenId,
741     bytes _data
742   )
743     internal
744     returns (bool)
745   {
746     if (!_to.isContract()) {
747       return true;
748     }
749     bytes4 retval = ERC721Receiver(_to).onERC721Received(
750       msg.sender, _from, _tokenId, _data);
751     return (retval == ERC721_RECEIVED);
752   }
753 }
754 
755 
756 /**
757  * @title Controllable ERC721Basic token
758  *
759  * @dev Token that queries a token controller contract to check if a transfer is allowed.
760  * @dev controller state var is going to be set with the address of a TokenControllerI contract that has
761  * implemented transferAllowed() function.
762  */
763 
764 contract ERC721Controllable is Ownable, ERC721BasicToken {
765     TokenControllerI public controller;
766 
767     /// @dev Executes transferAllowed() function from the Controller.
768     modifier isAllowed(address _from, address _to) {
769         require(controller.transferAllowed(_from, _to), "controller must allow the transfer");
770         _;
771     }
772 
773     /// @dev Sets the controller that is going to be used by isAllowed modifier
774     function setController(TokenControllerI _controller) public onlyOwner {
775         require(_controller != address(0), "controller must be a valid address");
776         controller = _controller;
777     }
778 
779      /// @dev It calls parent StandardToken.transferFrom() function. It will transfer from an address a certain amount of tokens to another address
780     /// @return True if the token is transfered with success
781     function transferFrom(address _from, address _to, uint256 _tokenID)
782         public
783         isAllowed(_from, _to)
784     {
785         super.transferFrom(_from, _to, _tokenID);
786     }
787 }
788 
789 
790 
791 
792 
793 /**
794  * @title SafeMath
795  * @dev Math operations with safety checks that throw on error
796  */
797 library SafeMath {
798 
799   /**
800   * @dev Multiplies two numbers, throws on overflow.
801   */
802   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
803     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
804     // benefit is lost if 'b' is also tested.
805     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
806     if (_a == 0) {
807       return 0;
808     }
809 
810     c = _a * _b;
811     assert(c / _a == _b);
812     return c;
813   }
814 
815   /**
816   * @dev Integer division of two numbers, truncating the quotient.
817   */
818   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
819     // assert(_b > 0); // Solidity automatically throws when dividing by 0
820     // uint256 c = _a / _b;
821     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
822     return _a / _b;
823   }
824 
825   /**
826   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
827   */
828   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
829     assert(_b <= _a);
830     return _a - _b;
831   }
832 
833   /**
834   * @dev Adds two numbers, throws on overflow.
835   */
836   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
837     c = _a + _b;
838     assert(c >= _a);
839     return c;
840   }
841 }
842 
843 
844 contract StakeToken is ERC721Controllable, POUInterface {
845   EIP20Interface intrinsicToken;
846   uint256 nftNonce;
847 
848   using SafeMath for uint;
849 
850 
851   function numApplications(address prover) external view returns(uint256) {
852     return balanceOf(prover);
853   }
854 
855   function totalStaked(address prover) external view returns(uint256) {
856     return _totalStaked[prover];
857   }
858 
859   mapping (address => uint256) _totalStaked;
860   mapping (uint256 => uint256) public tokenStake;
861   mapping (uint256 => uint256) public tokenMintedOn;
862   mapping (uint256 => uint256) public tokenBurntOn;
863 
864   constructor(EIP20Interface _token) public {
865     intrinsicToken = _token;
866   }
867 
868   function mint(address mintedTokenOwner, uint256 stake) public returns (uint256 tokenID) {
869     require(msg.sender == mintedTokenOwner, "msg.sender == mintedTokenOwner");
870 
871     nftNonce += 1;
872     tokenID = nftNonce;
873     tokenStake[tokenID] = stake;
874     tokenMintedOn[tokenID] = block.timestamp;
875     super._mint(mintedTokenOwner, tokenID);
876 
877     require(intrinsicToken.transferFrom(mintedTokenOwner, this, stake), "transferFrom");
878 
879     return tokenID;
880   }
881 
882   function burn(uint256 tokenID) public {
883     address burntTokenOwner = tokenOwner[tokenID];
884     require(msg.sender == burntTokenOwner, "msg.sender == burntTokenOwner"); // _burn doesn't do any ownership checks...
885     uint256 stake = tokenStake[tokenID];
886     super._burn(burntTokenOwner, tokenID);
887     tokenBurntOn[tokenID] = block.timestamp;
888     require(intrinsicToken.transfer(burntTokenOwner, stake), "transfer");
889   }
890 
891   function removeTokenFrom(address _from, uint256 _tokenId) internal {
892     super.removeTokenFrom(_from, _tokenId);
893     _totalStaked[_from] = _totalStaked[_from].sub(tokenStake[_tokenId]);
894   }
895 
896   function addTokenTo(address _to, uint256 _tokenId) internal {
897     super.addTokenTo(_to, _tokenId);
898     _totalStaked[_to] = _totalStaked[_to].add(tokenStake[_tokenId]);
899   }
900 }
901 
902 
903 
904 
905 
906 
907 
908 
909 
910 
911 
912 
913 contract CSTRegistry {
914   function getGeohash(bytes32 cst) public view returns (bytes32 geohash);
915   function getRadius(bytes32 cst) public view returns (uint256 radius);
916   function getCreatedOn(bytes32 cst) public view returns (uint256 timestamp);
917   function getDeletedOn(bytes32 cst) public view returns (uint256 timestamp);
918 
919   function isTracked(bytes32 cst) public view returns (bool);
920 
921   event TrackedToken(bytes32 cst, address indexed nftAddress, uint256 tokenID, bytes32 geohash, uint256 radius);
922 
923 /*
924   function trackToken(ERC721Basic nftContract, uint256 tokenID, bytes32 geohash, uint256 radius) public returns (bytes32) {
925     require(radius > 0, "radius must be nonzero");
926 
927     address tokenOwner = nftContract.ownerOf(tokenID);
928     require(    msg.sender == address(this) // so that contracts which inherit from this registry and also mint can track without doing approve/transfer gymnastics
929              || tokenOwner == msg.sender // the rest are basically nftContract.isApprovedOrOwner(tokenID, msg.sender), since they made it internal for some bizarre reason
930              || nftContract.getApproved(tokenID) == msg.sender
931              || nftContract.isApprovedForAll(tokenOwner, msg.sender)
932            , "msg.sender must have control over the token or be the registry itself");
933 
934     bytes32 cst = computeCST(nftContract, tokenID);
935     require(!isTracked(cst), "CST is already tracked");
936 
937     TrackedToken storage theToken = trackedTokens[cst];
938     theToken.geohash = geohash;
939     theToken.radius = radius;
940 
941     return cst;
942   } */
943 
944 
945   function computeCST(address nftContract, uint256 tokenID) public pure returns (bytes32) {
946     return keccak256(abi.encodePacked(nftContract, tokenID));
947   }
948 }
949 
950 
951 contract SignalToken is StakeToken, CSTRegistry {
952   mapping (uint256 => bytes32) public tokenGeohash;
953   mapping (uint256 => uint256) public tokenRadius;
954   mapping (bytes32 => uint256) public cstToID;
955 
956   constructor(EIP20Interface _token) StakeToken(_token) public { }
957 
958   function mint(address, uint256) public returns (uint256) {
959     revert("use mintSignal(address,uint256,bytes32,uint256) instead");
960   }
961 
962   function mintSignal(address owner, uint256 stake, bytes32 geohash, uint256 radius) public returns (uint256 tokenID) {
963     tokenID = super.mint(owner, stake);
964     tokenGeohash[tokenID] = geohash;
965     tokenRadius[tokenID] = radius;
966 
967     bytes32 cst = computeCST(address(this), tokenID);
968     cstToID[cst] = tokenID;
969 
970     // To know the stake in a Signal
971     // `stake` will have to be looked up through a join on
972     // `SignalToken.TrackedToken.tokenID` and
973     // `ERC721BasicToken.Transfer(address(0), _, tokenID)` and
974     // `ERC20.Transfer(_, address(nftToken), value)`
975     emit TrackedToken(cst, this, tokenID, geohash, radius);
976 
977     return tokenID;
978   }
979 
980   // implement CSTRegistry
981   function getGeohash(bytes32 cst) public view returns (bytes32 geohash) {
982     return tokenGeohash[cstToID[cst]];
983   }
984 
985   function getRadius(bytes32 cst) public view returns (uint256 radius) {
986     return tokenRadius[cstToID[cst]];
987   }
988 
989   function getCreatedOn(bytes32 cst) public view returns (uint256 timestamp) {
990     return tokenMintedOn[cstToID[cst]];
991   }
992 
993   function getDeletedOn(bytes32 cst) public view returns (uint256 timestamp) {
994     return tokenBurntOn[cstToID[cst]];
995   }
996 
997   function isTracked(bytes32 cst) public view returns (bool) {
998     return cstToID[cst] != 0;
999   }
1000 
1001   function name() external pure returns (string) {
1002     return "FOAM Signal";
1003   }
1004 
1005   function symbol() external pure returns (string) {
1006     return "FSX";
1007   }
1008 }