1 /**
2  *Submitted for verification at Etherscan.io on 2019-11-18
3 */
4 
5 pragma solidity 0.5.8;
6 pragma experimental ABIEncoderV2;
7 
8 contract Token {
9     /* This is a slight change to the ERC20 base standard.
10     function totalSupply() pure returns (uint256 supply);
11     is replaced with:
12     uint256 public totalSupply;
13     This automatically creates a getter function for the totalSupply.
14     This is moved to the base contract since public getter functions are not
15     currently recognised as an implementation of the matching abstract
16     function by the compiler.
17     */
18     /// total amount of tokens
19     uint256 public totalSupply;
20 
21     /// @param _owner The address from which the balance will be retrieved
22     /// @return The balance
23     function balanceOf(address _owner) view public returns (uint256 balance);
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) public returns (bool success);
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37 
38     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of tokens to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) public returns (bool success);
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
48 
49     event Transfer(address _from, address _to, uint256 _value);
50     event Approval(address _owner, address _spender, uint256 _value);
51 }
52 
53 contract ERC20Token is Token {
54 
55     function transfer(address _to, uint256 _value) public returns (bool success) {
56         //Default assumes totalSupply can't be over max (2^256 - 1).
57         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
58         //Replace the if with this one instead.
59         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60         if (balances[msg.sender] >= _value && _value > 0) {
61             balances[msg.sender] -= _value;
62             balances[_to] += _value;
63             emit Transfer(msg.sender, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
69         //same as above. Replace this line with the following if you want to protect against wrapping uints.
70         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
71         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
72             balances[_to] += _value;
73             balances[_from] -= _value;
74             allowed[_from][msg.sender] -= _value;
75             emit Transfer(_from, _to, _value);
76             return true;
77         } else { return false; }
78     }
79 
80     function balanceOf(address _owner) view public returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint256 _value) public returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         emit Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92     }
93 
94     mapping (address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96 }
97 
98 library SafeMath {
99 
100   /**
101   * @dev Multiplies two numbers, throws on overflow.
102   */
103   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
104     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
105     // benefit is lost if 'b' is also tested.
106     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
107     if (a == 0) {
108       return 0;
109     }
110 
111     c = a * b;
112     assert(c / a == b);
113     return c;
114   }
115 
116   /**
117   * @dev Integer division of two numbers, truncating the quotient.
118   */
119   function div(uint256 a, uint256 b) internal pure returns (uint256) {
120     // assert(b > 0); // Solidity automatically throws when dividing by 0
121     // uint256 c = a / b;
122     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123     return a / b;
124   }
125 
126   /**
127   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
128   */
129   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130     assert(b <= a);
131     return a - b;
132   }
133 
134   /**
135   * @dev Adds two numbers, throws on overflow.
136   */
137   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
138     c = a + b;
139     assert(c >= a);
140     return c;
141   }
142 }
143 
144 /**
145  * Utility library of inline functions on addresses
146  */
147 library AddressUtils {
148 
149   /**
150    * Returns whether the target address is a contract
151    * @dev This function will return false if invoked during the constructor of a contract,
152    * as the code is not actually created until after the constructor finishes.
153    * @param addr address to check
154    * @return whether the target address is a contract
155    */
156   function isContract(address addr) internal view returns (bool) {
157     uint256 size;
158     // XXX Currently there is no better way to check if there is a contract in an address
159     // than to check the size of the code at that address.
160     // See https://ethereum.stackexchange.com/a/14016/36603
161     // for more details about how this works.
162     // TODO Check this again before the Serenity release, because all addresses will be
163     // contracts then.
164     // solium-disable-next-line security/no-inline-assembly
165     assembly { size := extcodesize(addr) }
166     return size > 0;
167   }
168 
169 }
170 
171 /**
172  * @title ERC165
173  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
174  */
175 interface ERC165 {
176 
177   /**
178    * @notice Query if a contract implements an interface
179    * @param _interfaceId The interface identifier, as specified in ERC-165
180    * @dev Interface identification is specified in ERC-165. This function
181    * uses less than 30,000 gas.
182    */
183   function supportsInterface(bytes4 _interfaceId)
184     external
185     view
186     returns (bool);
187 }
188 
189 
190 /**
191  * @title SupportsInterfaceWithLookup
192  * @author Matt Condon (@shrugs)
193  * @dev Implements ERC165 using a lookup table.
194  */
195 contract SupportsInterfaceWithLookup is ERC165 {
196   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
197   /**
198    * 0x01ffc9a7 ===
199    *   bytes4(keccak256('supportsInterface(bytes4)'))
200    */
201 
202   /**
203    * @dev a mapping of interface id to whether or not it's supported
204    */
205   mapping(bytes4 => bool) internal supportedInterfaces;
206 
207   /**
208    * @dev A contract implementing SupportsInterfaceWithLookup
209    * implement ERC165 itself
210    */
211   constructor()
212     public
213   {
214     _registerInterface(InterfaceId_ERC165);
215   }
216 
217   /**
218    * @dev implement supportsInterface(bytes4) using a lookup table
219    */
220   function supportsInterface(bytes4 _interfaceId)
221     external
222     view
223     returns (bool)
224   {
225     return supportedInterfaces[_interfaceId];
226   }
227 
228   /**
229    * @dev private method for registering an interface
230    */
231   function _registerInterface(bytes4 _interfaceId)
232     internal
233   {
234     require(_interfaceId != 0xffffffff);
235     supportedInterfaces[_interfaceId] = true;
236   }
237 }
238 
239 /**
240  * @title ERC721 token receiver interface
241  * @dev Interface for any contract that wants to support safeTransfers
242  * from ERC721 asset contracts.
243  */
244 contract ERC721Receiver {
245   /**
246    * @dev Magic value to be returned upon successful reception of an NFT
247    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
248    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
249    */
250   bytes4 internal constant ERC721_RECEIVED = 0xf0b9e5ba;
251 
252   /**
253    * @notice Handle the receipt of an NFT
254    * @dev The ERC721 smart contract calls this function on the recipient
255    * after a `safetransfer`. This function MAY throw to revert and reject the
256    * transfer. This function MUST use 50,000 gas or less. Return of other
257    * than the magic value MUST result in the transaction being reverted.
258    * Note: the contract address is always the message sender.
259    * @param _from The sending address
260    * @param _tokenId The NFT identifier which is being transfered
261    * @param _data Additional data with no specified format
262    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
263    */
264   function onERC721Received(
265     address _from,
266     uint256 _tokenId,
267     bytes memory _data
268   )
269     public
270     returns(bytes4);
271 }
272 
273 /**
274  * @title ERC721 Non-Fungible Token Standard basic interface
275  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
276  */
277 contract ERC721Basic is ERC165 {
278   event Transfer(
279     address  _from,
280     address  _to,
281     uint256  _tokenId
282   );
283   event Approval(
284     address  _owner,
285     address  _approved,
286     uint256  _tokenId
287   );
288   event ApprovalForAll(
289     address  _owner,
290     address  _operator,
291     bool _approved
292   );
293 
294   function balanceOf(address _owner) public view returns (uint256 _balance);
295   function ownerOf(uint256 _tokenId) public view returns (address _owner);
296   function exists(uint256 _tokenId) public view returns (bool _exists);
297 
298   function approve(address _to, uint256 _tokenId) public;
299   function getApproved(uint256 _tokenId)
300     public view returns (address _operator);
301 
302   function setApprovalForAll(address _operator, bool _approved) public;
303   function isApprovedForAll(address _owner, address _operator)
304     public view returns (bool);
305 
306   function transferFrom(address _from, address _to, uint256 _tokenId) public;
307   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
308     public;
309 
310   function safeTransferFrom(
311     address _from,
312     address _to,
313     uint256 _tokenId,
314     bytes memory _data
315   )
316     public;
317 }
318 
319 /**
320  * @title ERC721 Non-Fungible Token Standard basic implementation
321  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
322  */
323 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
324 
325   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
326   /*
327    * 0x80ac58cd ===
328    *   bytes4(keccak256('balanceOf(address)')) ^
329    *   bytes4(keccak256('ownerOf(uint256)')) ^
330    *   bytes4(keccak256('approve(address,uint256)')) ^
331    *   bytes4(keccak256('getApproved(uint256)')) ^
332    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
333    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
334    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
335    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
336    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
337    */
338 
339   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
340   /*
341    * 0x4f558e79 ===
342    *   bytes4(keccak256('exists(uint256)'))
343    */
344 
345   using SafeMath for uint256;
346   using AddressUtils for address;
347 
348   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
349   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
350   bytes4 private constant ERC721_RECEIVED = 0xf0b9e5ba;
351 
352   // Mapping from token ID to owner
353   mapping (uint256 => address) internal tokenOwner;
354 
355   // Mapping from token ID to approved address
356   mapping (uint256 => address) internal tokenApprovals;
357 
358   // Mapping from owner to number of owned token
359   mapping (address => uint256) internal ownedTokensCount;
360 
361   // Mapping from owner to operator approvals
362   mapping (address => mapping (address => bool)) internal operatorApprovals;
363 
364 
365   uint public testint;
366   /**
367    * @dev Guarantees msg.sender is owner of the given token
368    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
369    */
370   modifier onlyOwnerOf(uint256 _tokenId) {
371     require(ownerOf(_tokenId) == msg.sender);
372     _;
373   }
374 
375   /**
376    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
377    * @param _tokenId uint256 ID of the token to validate
378    */
379   modifier canTransfer(uint256 _tokenId) {
380     require(isApprovedOrOwner(msg.sender, _tokenId));
381     _;
382   }
383 
384   constructor()
385     public
386   {
387     // register the supported interfaces to conform to ERC721 via ERC165
388     _registerInterface(InterfaceId_ERC721);
389     _registerInterface(InterfaceId_ERC721Exists);
390   }
391 
392   /**
393    * @dev Gets the balance of the specified address
394    * @param _owner address to query the balance of
395    * @return uint256 representing the amount owned by the passed address
396    */
397   function balanceOf(address _owner) public view returns (uint256) {
398     require(_owner != address(0));
399     return ownedTokensCount[_owner];
400   }
401 
402   /**
403    * @dev Gets the owner of the specified token ID
404    * @param _tokenId uint256 ID of the token to query the owner of
405    * @return owner address currently marked as the owner of the given token ID
406    */
407   function ownerOf(uint256 _tokenId) public view returns (address) {
408     address owner = tokenOwner[_tokenId];
409     require(owner != address(0));
410     return owner;
411   }
412 
413   /**
414    * @dev Returns whether the specified token exists
415    * @param _tokenId uint256 ID of the token to query the existence of
416    * @return whether the token exists
417    */
418   function exists(uint256 _tokenId) public view returns (bool) {
419     address owner = tokenOwner[_tokenId];
420     return owner != address(0);
421   }
422 
423   /**
424    * @dev Approves another address to transfer the given token ID
425    * The zero address indicates there is no approved address.
426    * There can only be one approved address per token at a given time.
427    * Can only be called by the token owner or an approved operator.
428    * @param _to address to be approved for the given token ID
429    * @param _tokenId uint256 ID of the token to be approved
430    */
431   function approve(address _to, uint256 _tokenId) public {
432     address owner = ownerOf(_tokenId);
433     require(_to != owner);
434     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
435 
436     tokenApprovals[_tokenId] = _to;
437     emit Approval(owner, _to, _tokenId);
438   }
439 
440   /**
441    * @dev Gets the approved address for a token ID, or zero if no address set
442    * @param _tokenId uint256 ID of the token to query the approval of
443    * @return address currently approved for the given token ID
444    */
445   function getApproved(uint256 _tokenId) public view returns (address) {
446     return tokenApprovals[_tokenId];
447   }
448 
449   /**
450    * @dev Sets or unsets the approval of a given operator
451    * An operator is allowed to transfer all tokens of the sender on their behalf
452    * @param _to operator address to set the approval
453    * @param _approved representing the status of the approval to be set
454    */
455   function setApprovalForAll(address _to, bool _approved) public {
456     require(_to != msg.sender);
457     operatorApprovals[msg.sender][_to] = _approved;
458     emit ApprovalForAll(msg.sender, _to, _approved);
459   }
460 
461   /**
462    * @dev Tells whether an operator is approved by a given owner
463    * @param _owner owner address which you want to query the approval of
464    * @param _operator operator address which you want to query the approval of
465    * @return bool whether the given operator is approved by the given owner
466    */
467   function isApprovedForAll(
468     address _owner,
469     address _operator
470   )
471     public
472     view
473     returns (bool)
474   {
475     return operatorApprovals[_owner][_operator];
476   }
477 
478   /**
479    * @dev Transfers the ownership of a given token ID to another address
480    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
481    * Requires the msg sender to be the owner, approved, or operator
482    * @param _from current owner of the token
483    * @param _to address to receive the ownership of the given token ID
484    * @param _tokenId uint256 ID of the token to be transferred
485   */
486   function transferFrom(
487     address _from,
488     address _to,
489     uint256 _tokenId
490   )
491     public
492     canTransfer(_tokenId)
493   {
494     require(_from != address(0));
495     require(_to != address(0));
496 
497     clearApproval(_from, _tokenId);
498     removeTokenFrom(_from, _tokenId);
499     addTokenTo(_to, _tokenId);
500 
501     emit Transfer(_from, _to, _tokenId);
502   }
503 
504   /**
505    * @dev Safely transfers the ownership of a given token ID to another address
506    * If the target address is a contract, it must implement `onERC721Received`,
507    * which is called upon a safe transfer, and return the magic value
508    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
509    * the transfer is reverted.
510    *
511    * Requires the msg sender to be the owner, approved, or operator
512    * @param _from current owner of the token
513    * @param _to address to receive the ownership of the given token ID
514    * @param _tokenId uint256 ID of the token to be transferred
515   */
516   function safeTransferFrom(
517     address _from,
518     address _to,
519     uint256 _tokenId
520   )
521     public
522     canTransfer(_tokenId)
523   {
524     // solium-disable-next-line arg-overflow
525     safeTransferFrom(_from, _to, _tokenId, "");
526   }
527 
528   /**
529    * @dev Safely transfers the ownership of a given token ID to another address
530    * If the target address is a contract, it must implement `onERC721Received`,
531    * which is called upon a safe transfer, and return the magic value
532    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
533    * the transfer is reverted.
534    * Requires the msg sender to be the owner, approved, or operator
535    * @param _from current owner of the token
536    * @param _to address to receive the ownership of the given token ID
537    * @param _tokenId uint256 ID of the token to be transferred
538    * @param _data bytes data to send along with a safe transfer check
539    */
540   function safeTransferFrom(
541     address _from,
542     address _to,
543     uint256 _tokenId,
544     bytes memory _data
545   )
546     public
547     canTransfer(_tokenId)
548   {
549     transferFrom(_from, _to, _tokenId);
550     // solium-disable-next-line arg-overflow
551     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
552   }
553 
554   /**
555    * @dev Returns whether the given spender can transfer a given token ID
556    * @param _spender address of the spender to query
557    * @param _tokenId uint256 ID of the token to be transferred
558    * @return bool whether the msg.sender is approved for the given token ID,
559    *  is an operator of the owner, or is the owner of the token
560    */
561   function isApprovedOrOwner(
562     address _spender,
563     uint256 _tokenId
564   )
565     internal
566     view
567     returns (bool)
568   {
569     address owner = ownerOf(_tokenId);
570     // Disable solium check because of
571     // https://github.com/duaraghav8/Solium/issues/175
572     // solium-disable-next-line operator-whitespace
573     return (
574       _spender == owner ||
575       getApproved(_tokenId) == _spender ||
576       isApprovedForAll(owner, _spender)
577     );
578   }
579 
580   /**
581    * @dev Internal function to mint a new token
582    * Reverts if the given token ID already exists
583    * @param _to The address that will own the minted token
584    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
585    */
586   function _mint(address _to, uint256 _tokenId) internal {
587     require(_to != address(0));
588     addTokenTo(_to, _tokenId);
589     emit Transfer(address(0), _to, _tokenId);
590   }
591 
592   /**
593    * @dev Internal function to burn a specific token
594    * Reverts if the token does not exist
595    * @param _tokenId uint256 ID of the token being burned by the msg.sender
596    */
597   function _burn(address _owner, uint256 _tokenId) internal {
598     clearApproval(_owner, _tokenId);
599     removeTokenFrom(_owner, _tokenId);
600     emit Transfer(_owner, address(0), _tokenId);
601   }
602 
603   /**
604    * @dev Internal function to clear current approval of a given token ID
605    * Reverts if the given address is not indeed the owner of the token
606    * @param _owner owner of the token
607    * @param _tokenId uint256 ID of the token to be transferred
608    */
609   function clearApproval(address _owner, uint256 _tokenId) internal {
610     require(ownerOf(_tokenId) == _owner);
611     if (tokenApprovals[_tokenId] != address(0)) {
612       tokenApprovals[_tokenId] = address(0);
613     }
614   }
615 
616   /**
617    * @dev Internal function to add a token ID to the list of a given address
618    * @param _to address representing the new owner of the given token ID
619    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
620    */
621   function addTokenTo(address _to, uint256 _tokenId) internal {
622     require(tokenOwner[_tokenId] == address(0));
623     tokenOwner[_tokenId] = _to;
624     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
625   }
626 
627   /**
628    * @dev Internal function to remove a token ID from the list of a given address
629    * @param _from address representing the previous owner of the given token ID
630    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
631    */
632   function removeTokenFrom(address _from, uint256 _tokenId) internal {
633     require(ownerOf(_tokenId) == _from);
634     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
635     tokenOwner[_tokenId] = address(0);
636   }
637 
638   /**
639    * @dev Internal function to invoke `onERC721Received` on a target address
640    * The call is not executed if the target address is not a contract
641    * @param _from address representing the previous owner of the given token ID
642    * @param _to target address that will receive the tokens
643    * @param _tokenId uint256 ID of the token to be transferred
644    * @param _data bytes optional data to send along with the call
645    * @return whether the call correctly returned the expected magic value
646    */
647   function checkAndCallSafeTransfer(
648     address _from,
649     address _to,
650     uint256 _tokenId,
651     bytes memory _data
652   )
653     internal
654     returns (bool)
655   {
656     if (!_to.isContract()) {
657       return true;
658     }
659     bytes4 retval = ERC721Receiver(_to).onERC721Received(
660       _from, _tokenId, _data);
661     return (retval == ERC721_RECEIVED);
662   }
663 }
664 
665 contract ERC721BasicTokenMock is ERC721BasicToken {
666   function mint(address _to, uint256 _tokenId) public {
667     super._mint(_to, _tokenId);
668   }
669 
670   function burn(uint256 _tokenId) public {
671     super._burn(ownerOf(_tokenId), _tokenId);
672   }
673 }
674 
675 /// @title StandardBounties
676 /// @dev A contract for issuing bounties on Ethereum paying in ETH, ERC20, or ERC721 tokens
677 /// @author Mark Beylin <mark.beylin@consensys.net>, Gonçalo Sá <goncalo.sa@consensys.net>, Kevin Owocki <kevin.owocki@consensys.net>, Ricardo Guilherme Schmidt (@3esmit), Matt Garnett <matt.garnett@consensys.net>, Craig Williams <craig.williams@consensys.net>
678 contract StandardBounties {
679 
680   using SafeMath for uint256;
681 
682   /*
683    * Structs
684    */
685 
686   struct Bounty {
687     address payable[] issuers; // An array of individuals who have complete control over the bounty, and can edit any of its parameters
688     address[] approvers; // An array of individuals who are allowed to accept the fulfillments for a particular bounty
689     uint deadline; // The Unix timestamp before which all submissions must be made, and after which refunds may be processed
690     address token; // The address of the token associated with the bounty (should be disregarded if the tokenVersion is 0)
691     uint tokenVersion; // The version of the token being used for the bounty (0 for ETH, 20 for ERC20, 721 for ERC721)
692     uint balance; // The number of tokens which the bounty is able to pay out or refund
693     bool hasPaidOut; // A boolean storing whether or not the bounty has paid out at least once, meaning refunds are no longer allowed
694     Fulfillment[] fulfillments; // An array of Fulfillments which store the various submissions which have been made to the bounty
695     Contribution[] contributions; // An array of Contributions which store the contributions which have been made to the bounty
696   }
697 
698   struct Fulfillment {
699     address payable[] fulfillers; // An array of addresses who should receive payouts for a given submission
700     address submitter; // The address of the individual who submitted the fulfillment, who is able to update the submission as needed
701   }
702 
703   struct Contribution {
704     address payable contributor; // The address of the individual who contributed
705     uint amount; // The amount of tokens the user contributed
706     bool refunded; // A boolean storing whether or not the contribution has been refunded yet
707   }
708 
709   /*
710    * Storage
711    */
712 
713   uint public numBounties; // An integer storing the total number of bounties in the contract
714   mapping(uint => Bounty) public bounties; // A mapping of bountyIDs to bounties
715   mapping (uint => mapping (uint => bool)) public tokenBalances; // A mapping of bountyIds to tokenIds to booleans, storing whether a given bounty has a given ERC721 token in its balance
716 
717 
718   address public owner; // The address of the individual who's allowed to set the metaTxRelayer address
719   address public metaTxRelayer; // The address of the meta transaction relayer whose _sender is automatically trusted for all contract calls
720 
721   bool public callStarted; // Ensures mutex for the entire contract
722 
723   /*
724    * Modifiers
725    */
726 
727   modifier callNotStarted(){
728     require(!callStarted);
729     callStarted = true;
730     _;
731     callStarted = false;
732   }
733 
734   modifier validateBountyArrayIndex(
735     uint _index)
736   {
737     require(_index < numBounties);
738     _;
739   }
740 
741   modifier validateContributionArrayIndex(
742     uint _bountyId,
743     uint _index)
744   {
745     require(_index < bounties[_bountyId].contributions.length);
746     _;
747   }
748 
749   modifier validateFulfillmentArrayIndex(
750     uint _bountyId,
751     uint _index)
752   {
753     require(_index < bounties[_bountyId].fulfillments.length);
754     _;
755   }
756 
757   modifier validateIssuerArrayIndex(
758     uint _bountyId,
759     uint _index)
760   {
761     require(_index < bounties[_bountyId].issuers.length);
762     _;
763   }
764 
765   modifier validateApproverArrayIndex(
766     uint _bountyId,
767     uint _index)
768   {
769     require(_index < bounties[_bountyId].approvers.length);
770     _;
771   }
772 
773   modifier onlyIssuer(
774   address _sender,
775   uint _bountyId,
776   uint _issuerId)
777   {
778   require(_sender == bounties[_bountyId].issuers[_issuerId]);
779   _;
780   }
781 
782   modifier onlySubmitter(
783     address _sender,
784     uint _bountyId,
785     uint _fulfillmentId)
786   {
787     require(_sender ==
788             bounties[_bountyId].fulfillments[_fulfillmentId].submitter);
789     _;
790   }
791 
792   modifier onlyContributor(
793   address _sender,
794   uint _bountyId,
795   uint _contributionId)
796   {
797     require(_sender ==
798             bounties[_bountyId].contributions[_contributionId].contributor);
799     _;
800   }
801 
802   modifier isApprover(
803     address _sender,
804     uint _bountyId,
805     uint _approverId)
806   {
807     require(_sender == bounties[_bountyId].approvers[_approverId]);
808     _;
809   }
810 
811   modifier hasNotPaid(
812     uint _bountyId)
813   {
814     require(!bounties[_bountyId].hasPaidOut);
815     _;
816   }
817 
818   modifier hasNotRefunded(
819     uint _bountyId,
820     uint _contributionId)
821   {
822     require(!bounties[_bountyId].contributions[_contributionId].refunded);
823     _;
824   }
825 
826   modifier senderIsValid(
827     address _sender)
828   {
829     require(msg.sender == _sender || msg.sender == metaTxRelayer);
830     _;
831   }
832 
833  /*
834   * Public functions
835   */
836 
837   constructor() public {
838     // The owner of the contract is automatically designated to be the deployer of the contract
839     owner = msg.sender;
840   }
841 
842   /// @dev setMetaTxRelayer(): Sets the address of the meta transaction relayer
843   /// @param _relayer the address of the relayer
844   function setMetaTxRelayer(address _relayer)
845     external
846   {
847     require(msg.sender == owner); // Checks that only the owner can call
848     require(metaTxRelayer == address(0)); // Ensures the meta tx relayer can only be set once
849     metaTxRelayer = _relayer;
850   }
851 
852   /// @dev issueBounty(): creates a new bounty
853   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
854   /// @param _issuers the array of addresses who will be the issuers of the bounty
855   /// @param _approvers the array of addresses who will be the approvers of the bounty
856   /// @param _data the IPFS hash representing the JSON object storing the details of the bounty (see docs for schema details)
857   /// @param _deadline the timestamp which will become the deadline of the bounty
858   /// @param _token the address of the token which will be used for the bounty
859   /// @param _tokenVersion the version of the token being used for the bounty (0 for ETH, 20 for ERC20, 721 for ERC721)
860   function issueBounty(
861     address payable _sender,
862     address payable[] memory _issuers,
863     address[] memory _approvers,
864     string memory _data,
865     uint _deadline,
866     address _token,
867     uint _tokenVersion)
868     public
869     senderIsValid(_sender)
870     returns (uint)
871   {
872     require(_tokenVersion == 0 || _tokenVersion == 20 || _tokenVersion == 721); // Ensures a bounty can only be issued with a valid token version
873     require(_issuers.length > 0 || _approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck
874 
875     uint bountyId = numBounties; // The next bounty's index will always equal the number of existing bounties
876 
877     Bounty storage newBounty = bounties[bountyId];
878     newBounty.issuers = _issuers;
879     newBounty.approvers = _approvers;
880     newBounty.deadline = _deadline;
881     newBounty.tokenVersion = _tokenVersion;
882 
883     if (_tokenVersion != 0){
884       newBounty.token = _token;
885     }
886 
887     numBounties = numBounties.add(1); // Increments the number of bounties, since a new one has just been added
888 
889     emit BountyIssued(bountyId,
890                       _sender,
891                       _issuers,
892                       _approvers,
893                       _data, // Instead of storing the string on-chain, it is emitted within the event for easy off-chain consumption
894                       _deadline,
895                       _token,
896                       _tokenVersion);
897 
898     return (bountyId);
899   }
900 
901   /// @param _depositAmount the amount of tokens being deposited to the bounty, which will create a new contribution to the bounty
902 
903 
904   function issueAndContribute(
905     address payable _sender,
906     address payable[] memory _issuers,
907     address[] memory _approvers,
908     string memory _data,
909     uint _deadline,
910     address _token,
911     uint _tokenVersion,
912     uint _depositAmount)
913     public
914     payable
915     returns(uint)
916   {
917     uint bountyId = issueBounty(_sender, _issuers, _approvers, _data, _deadline, _token, _tokenVersion);
918 
919     contribute(_sender, bountyId, _depositAmount);
920 
921     return (bountyId);
922   }
923 
924 
925   /// @dev contribute(): Allows users to contribute tokens to a given bounty.
926   ///                    Contributing merits no privelages to administer the
927   ///                    funds in the bounty or accept submissions. Contributions
928   ///                    are refundable but only on the condition that the deadline
929   ///                    has elapsed, and the bounty has not yet paid out any funds.
930   ///                    All funds deposited in a bounty are at the mercy of a
931   ///                    bounty's issuers and approvers, so please be careful!
932   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
933   /// @param _bountyId the index of the bounty
934   /// @param _amount the amount of tokens being contributed
935   function contribute(
936     address payable _sender,
937     uint _bountyId,
938     uint _amount)
939     public
940     payable
941     senderIsValid(_sender)
942     validateBountyArrayIndex(_bountyId)
943     callNotStarted
944   {
945     require(_amount > 0); // Contributions of 0 tokens or token ID 0 should fail
946 
947     bounties[_bountyId].contributions.push(
948       Contribution(_sender, _amount, false)); // Adds the contribution to the bounty
949 
950     if (bounties[_bountyId].tokenVersion == 0){
951 
952       bounties[_bountyId].balance = bounties[_bountyId].balance.add(_amount); // Increments the balance of the bounty
953 
954       require(msg.value == _amount);
955     } else if (bounties[_bountyId].tokenVersion == 20){
956 
957       bounties[_bountyId].balance = bounties[_bountyId].balance.add(_amount); // Increments the balance of the bounty
958 
959       require(msg.value == 0); // Ensures users don't accidentally send ETH alongside a token contribution, locking up funds
960       require(ERC20Token(bounties[_bountyId].token).transferFrom(_sender,
961                                                                  address(this),
962                                                                  _amount));
963     } else if (bounties[_bountyId].tokenVersion == 721){
964       tokenBalances[_bountyId][_amount] = true; // Adds the 721 token to the balance of the bounty
965 
966 
967       require(msg.value == 0); // Ensures users don't accidentally send ETH alongside a token contribution, locking up funds
968       ERC721BasicToken(bounties[_bountyId].token).transferFrom(_sender,
969                                                                address(this),
970                                                                _amount);
971     } else {
972       revert();
973     }
974 
975     emit ContributionAdded(_bountyId,
976                            bounties[_bountyId].contributions.length - 1, // The new contributionId
977                            _sender,
978                            _amount);
979   }
980 
981   /// @dev refundContribution(): Allows users to refund the contributions they've
982   ///                            made to a particular bounty, but only if the bounty
983   ///                            has not yet paid out, and the deadline has elapsed.
984   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
985   /// @param _bountyId the index of the bounty
986   /// @param _contributionId the index of the contribution being refunded
987   function refundContribution(
988     address _sender,
989     uint _bountyId,
990     uint _contributionId)
991     public
992     senderIsValid(_sender)
993     validateBountyArrayIndex(_bountyId)
994     validateContributionArrayIndex(_bountyId, _contributionId)
995     onlyContributor(_sender, _bountyId, _contributionId)
996     hasNotPaid(_bountyId)
997     hasNotRefunded(_bountyId, _contributionId)
998     callNotStarted
999   {
1000     require(now > bounties[_bountyId].deadline); // Refunds may only be processed after the deadline has elapsed
1001 
1002     Contribution storage contribution = bounties[_bountyId].contributions[_contributionId];
1003 
1004     contribution.refunded = true;
1005 
1006     transferTokens(_bountyId, contribution.contributor, contribution.amount); // Performs the disbursal of tokens to the contributor
1007 
1008     emit ContributionRefunded(_bountyId, _contributionId);
1009   }
1010 
1011   /// @dev refundMyContributions(): Allows users to refund their contributions in bulk
1012   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1013   /// @param _bountyId the index of the bounty
1014   /// @param _contributionIds the array of indexes of the contributions being refunded
1015   function refundMyContributions(
1016     address _sender,
1017     uint _bountyId,
1018     uint[] memory _contributionIds)
1019     public
1020     senderIsValid(_sender)
1021   {
1022     for (uint i = 0; i < _contributionIds.length; i++){
1023         refundContribution(_sender, _bountyId, _contributionIds[i]);
1024     }
1025   }
1026 
1027   /// @dev refundContributions(): Allows users to refund their contributions in bulk
1028   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1029   /// @param _bountyId the index of the bounty
1030   /// @param _issuerId the index of the issuer who is making the call
1031   /// @param _contributionIds the array of indexes of the contributions being refunded
1032   function refundContributions(
1033     address _sender,
1034     uint _bountyId,
1035     uint _issuerId,
1036     uint[] memory _contributionIds)
1037     public
1038     senderIsValid(_sender)
1039     validateBountyArrayIndex(_bountyId)
1040     onlyIssuer(_sender, _bountyId, _issuerId)
1041     callNotStarted
1042   {
1043     for (uint i = 0; i < _contributionIds.length; i++){
1044       require(_contributionIds[i] < bounties[_bountyId].contributions.length);
1045 
1046       Contribution storage contribution = bounties[_bountyId].contributions[_contributionIds[i]];
1047 
1048       require(!contribution.refunded);
1049 
1050       contribution.refunded = true;
1051 
1052       transferTokens(_bountyId, contribution.contributor, contribution.amount); // Performs the disbursal of tokens to the contributor
1053     }
1054 
1055     emit ContributionsRefunded(_bountyId, _sender, _contributionIds);
1056   }
1057 
1058   /// @dev drainBounty(): Allows an issuer to drain the funds from the bounty
1059   /// @notice when using this function, if an issuer doesn't drain the entire balance, some users may be able to refund their contributions, while others may not (which is unfair to them). Please use it wisely, only when necessary
1060   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1061   /// @param _bountyId the index of the bounty
1062   /// @param _issuerId the index of the issuer who is making the call
1063   /// @param _amounts an array of amounts of tokens to be sent. The length of the array should be 1 if the bounty is in ETH or ERC20 tokens. If it's an ERC721 bounty, the array should be the list of tokenIDs.
1064   function drainBounty(
1065     address payable _sender,
1066     uint _bountyId,
1067     uint _issuerId,
1068     uint[] memory _amounts)
1069     public
1070     senderIsValid(_sender)
1071     validateBountyArrayIndex(_bountyId)
1072     onlyIssuer(_sender, _bountyId, _issuerId)
1073     callNotStarted
1074   {
1075     if (bounties[_bountyId].tokenVersion == 0 || bounties[_bountyId].tokenVersion == 20){
1076       require(_amounts.length == 1); // ensures there's only 1 amount of tokens to be returned
1077       require(_amounts[0] <= bounties[_bountyId].balance); // ensures an issuer doesn't try to drain the bounty of more tokens than their balance permits
1078       transferTokens(_bountyId, _sender, _amounts[0]); // Performs the draining of tokens to the issuer
1079     } else {
1080       for (uint i = 0; i < _amounts.length; i++){
1081         require(tokenBalances[_bountyId][_amounts[i]]);// ensures an issuer doesn't try to drain the bounty of a token it doesn't have in its balance
1082         transferTokens(_bountyId, _sender, _amounts[i]);
1083       }
1084     }
1085 
1086     emit BountyDrained(_bountyId, _sender, _amounts);
1087   }
1088 
1089   /// @dev performAction(): Allows users to perform any generalized action
1090   ///                       associated with a particular bounty, such as applying for it
1091   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1092   /// @param _bountyId the index of the bounty
1093   /// @param _data the IPFS hash corresponding to a JSON object which contains the details of the action being performed (see docs for schema details)
1094   function performAction(
1095     address _sender,
1096     uint _bountyId,
1097     string memory _data)
1098     public
1099     senderIsValid(_sender)
1100     validateBountyArrayIndex(_bountyId)
1101   {
1102     emit ActionPerformed(_bountyId, _sender, _data); // The _data string is emitted in an event for easy off-chain consumption
1103   }
1104 
1105   /// @dev fulfillBounty(): Allows users to fulfill the bounty to get paid out
1106   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1107   /// @param _bountyId the index of the bounty
1108   /// @param _fulfillers the array of addresses which will receive payouts for the submission
1109   /// @param _data the IPFS hash corresponding to a JSON object which contains the details of the submission (see docs for schema details)
1110   function fulfillBounty(
1111     address _sender,
1112     uint _bountyId,
1113     address payable[] memory  _fulfillers,
1114     string memory _data)
1115     public
1116     senderIsValid(_sender)
1117     validateBountyArrayIndex(_bountyId)
1118   {
1119     require(now < bounties[_bountyId].deadline); // Submissions are only allowed to be made before the deadline
1120     require(_fulfillers.length > 0); // Submissions with no fulfillers would mean no one gets paid out
1121 
1122     bounties[_bountyId].fulfillments.push(Fulfillment(_fulfillers, _sender));
1123 
1124     emit BountyFulfilled(_bountyId,
1125                          (bounties[_bountyId].fulfillments.length - 1),
1126                          _fulfillers,
1127                          _data, // The _data string is emitted in an event for easy off-chain consumption
1128                          _sender);
1129   }
1130 
1131   /// @dev updateFulfillment(): Allows the submitter of a fulfillment to update their submission
1132   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1133   /// @param _bountyId the index of the bounty
1134   /// @param _fulfillmentId the index of the fulfillment
1135   /// @param _fulfillers the new array of addresses which will receive payouts for the submission
1136   /// @param _data the new IPFS hash corresponding to a JSON object which contains the details of the submission (see docs for schema details)
1137   function updateFulfillment(
1138   address _sender,
1139   uint _bountyId,
1140   uint _fulfillmentId,
1141   address payable[] memory _fulfillers,
1142   string memory _data)
1143   public
1144   senderIsValid(_sender)
1145   validateBountyArrayIndex(_bountyId)
1146   validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)
1147   onlySubmitter(_sender, _bountyId, _fulfillmentId) // Only the original submitter of a fulfillment may update their submission
1148   {
1149     bounties[_bountyId].fulfillments[_fulfillmentId].fulfillers = _fulfillers;
1150     emit FulfillmentUpdated(_bountyId,
1151                             _fulfillmentId,
1152                             _fulfillers,
1153                             _data); // The _data string is emitted in an event for easy off-chain consumption
1154   }
1155 
1156   /// @dev acceptFulfillment(): Allows any of the approvers to accept a given submission
1157   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1158   /// @param _bountyId the index of the bounty
1159   /// @param _fulfillmentId the index of the fulfillment to be accepted
1160   /// @param _approverId the index of the approver which is making the call
1161   /// @param _tokenAmounts the array of token amounts which will be paid to the
1162   ///                      fulfillers, whose length should equal the length of the
1163   ///                      _fulfillers array of the submission. If the bounty pays
1164   ///                      in ERC721 tokens, then these should be the token IDs
1165   ///                      being sent to each of the individual fulfillers
1166   function acceptFulfillment(
1167     address _sender,
1168     uint _bountyId,
1169     uint _fulfillmentId,
1170     uint _approverId,
1171     uint[] memory _tokenAmounts)
1172     public
1173     senderIsValid(_sender)
1174     validateBountyArrayIndex(_bountyId)
1175     validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)
1176     isApprover(_sender, _bountyId, _approverId)
1177     callNotStarted
1178   {
1179     // now that the bounty has paid out at least once, refunds are no longer possible
1180     bounties[_bountyId].hasPaidOut = true;
1181 
1182     Fulfillment storage fulfillment = bounties[_bountyId].fulfillments[_fulfillmentId];
1183 
1184     require(_tokenAmounts.length == fulfillment.fulfillers.length); // Each fulfiller should get paid some amount of tokens (this can be 0)
1185 
1186     for (uint256 i = 0; i < fulfillment.fulfillers.length; i++){
1187         if (_tokenAmounts[i] > 0){
1188           // for each fulfiller associated with the submission
1189           transferTokens(_bountyId, fulfillment.fulfillers[i], _tokenAmounts[i]);
1190         }
1191     }
1192     emit FulfillmentAccepted(_bountyId,
1193                              _fulfillmentId,
1194                              _sender,
1195                              _tokenAmounts);
1196   }
1197 
1198   /// @dev fulfillAndAccept(): Allows any of the approvers to fulfill and accept a submission simultaneously
1199   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1200   /// @param _bountyId the index of the bounty
1201   /// @param _fulfillers the array of addresses which will receive payouts for the submission
1202   /// @param _data the IPFS hash corresponding to a JSON object which contains the details of the submission (see docs for schema details)
1203   /// @param _approverId the index of the approver which is making the call
1204   /// @param _tokenAmounts the array of token amounts which will be paid to the
1205   ///                      fulfillers, whose length should equal the length of the
1206   ///                      _fulfillers array of the submission. If the bounty pays
1207   ///                      in ERC721 tokens, then these should be the token IDs
1208   ///                      being sent to each of the individual fulfillers
1209   function fulfillAndAccept(
1210     address _sender,
1211     uint _bountyId,
1212     address payable[] memory _fulfillers,
1213     string memory _data,
1214     uint _approverId,
1215     uint[] memory _tokenAmounts)
1216     public
1217     senderIsValid(_sender)
1218   {
1219     // first fulfills the bounty on behalf of the fulfillers
1220     fulfillBounty(_sender, _bountyId, _fulfillers, _data);
1221 
1222     // then accepts the fulfillment
1223     acceptFulfillment(_sender,
1224                       _bountyId,
1225                       bounties[_bountyId].fulfillments.length - 1,
1226                       _approverId,
1227                       _tokenAmounts);
1228   }
1229 
1230 
1231 
1232   /// @dev changeBounty(): Allows any of the issuers to change the bounty
1233   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1234   /// @param _bountyId the index of the bounty
1235   /// @param _issuerId the index of the issuer who is calling the function
1236   /// @param _issuers the new array of addresses who will be the issuers of the bounty
1237   /// @param _approvers the new array of addresses who will be the approvers of the bounty
1238   /// @param _data the new IPFS hash representing the JSON object storing the details of the bounty (see docs for schema details)
1239   /// @param _deadline the new timestamp which will become the deadline of the bounty
1240   function changeBounty(
1241     address _sender,
1242     uint _bountyId,
1243     uint _issuerId,
1244     address payable[] memory _issuers,
1245     address payable[] memory _approvers,
1246     string memory _data,
1247     uint _deadline)
1248     public
1249     senderIsValid(_sender)
1250   {
1251     require(_bountyId < numBounties); // makes the validateBountyArrayIndex modifier in-line to avoid stack too deep errors
1252     require(_issuerId < bounties[_bountyId].issuers.length); // makes the validateIssuerArrayIndex modifier in-line to avoid stack too deep errors
1253     require(_sender == bounties[_bountyId].issuers[_issuerId]); // makes the onlyIssuer modifier in-line to avoid stack too deep errors
1254 
1255     require(_issuers.length > 0 || _approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck
1256 
1257     bounties[_bountyId].issuers = _issuers;
1258     bounties[_bountyId].approvers = _approvers;
1259     bounties[_bountyId].deadline = _deadline;
1260     emit BountyChanged(_bountyId,
1261                        _sender,
1262                        _issuers,
1263                        _approvers,
1264                        _data,
1265                        _deadline);
1266   }
1267 
1268   /// @dev changeIssuer(): Allows any of the issuers to change a particular issuer of the bounty
1269   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1270   /// @param _bountyId the index of the bounty
1271   /// @param _issuerId the index of the issuer who is calling the function
1272   /// @param _issuerIdToChange the index of the issuer who is being changed
1273   /// @param _newIssuer the address of the new issuer
1274   function changeIssuer(
1275     address _sender,
1276     uint _bountyId,
1277     uint _issuerId,
1278     uint _issuerIdToChange,
1279     address payable _newIssuer)
1280     public
1281     senderIsValid(_sender)
1282     validateBountyArrayIndex(_bountyId)
1283     validateIssuerArrayIndex(_bountyId, _issuerIdToChange)
1284     onlyIssuer(_sender, _bountyId, _issuerId)
1285   {
1286     require(_issuerId < bounties[_bountyId].issuers.length || _issuerId == 0);
1287 
1288     bounties[_bountyId].issuers[_issuerIdToChange] = _newIssuer;
1289 
1290     emit BountyIssuersUpdated(_bountyId, _sender, bounties[_bountyId].issuers);
1291   }
1292 
1293   /// @dev changeApprover(): Allows any of the issuers to change a particular approver of the bounty
1294   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1295   /// @param _bountyId the index of the bounty
1296   /// @param _issuerId the index of the issuer who is calling the function
1297   /// @param _approverId the index of the approver who is being changed
1298   /// @param _approver the address of the new approver
1299   function changeApprover(
1300     address _sender,
1301     uint _bountyId,
1302     uint _issuerId,
1303     uint _approverId,
1304     address payable _approver)
1305     external
1306     senderIsValid(_sender)
1307     validateBountyArrayIndex(_bountyId)
1308     onlyIssuer(_sender, _bountyId, _issuerId)
1309     validateApproverArrayIndex(_bountyId, _approverId)
1310   {
1311     bounties[_bountyId].approvers[_approverId] = _approver;
1312 
1313     emit BountyApproversUpdated(_bountyId, _sender, bounties[_bountyId].approvers);
1314   }
1315 
1316   /// @dev changeData(): Allows any of the issuers to change the data the bounty
1317   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1318   /// @param _bountyId the index of the bounty
1319   /// @param _issuerId the index of the issuer who is calling the function
1320   /// @param _data the new IPFS hash representing the JSON object storing the details of the bounty (see docs for schema details)
1321   function changeData(
1322     address _sender,
1323     uint _bountyId,
1324     uint _issuerId,
1325     string memory _data)
1326     public
1327     senderIsValid(_sender)
1328     validateBountyArrayIndex(_bountyId)
1329     validateIssuerArrayIndex(_bountyId, _issuerId)
1330     onlyIssuer(_sender, _bountyId, _issuerId)
1331   {
1332     emit BountyDataChanged(_bountyId, _sender, _data); // The new _data is emitted within an event rather than being stored on-chain for minimized gas costs
1333   }
1334 
1335   /// @dev changeDeadline(): Allows any of the issuers to change the deadline the bounty
1336   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1337   /// @param _bountyId the index of the bounty
1338   /// @param _issuerId the index of the issuer who is calling the function
1339   /// @param _deadline the new timestamp which will become the deadline of the bounty
1340   function changeDeadline(
1341     address _sender,
1342     uint _bountyId,
1343     uint _issuerId,
1344     uint _deadline)
1345     external
1346     senderIsValid(_sender)
1347     validateBountyArrayIndex(_bountyId)
1348     validateIssuerArrayIndex(_bountyId, _issuerId)
1349     onlyIssuer(_sender, _bountyId, _issuerId)
1350   {
1351     bounties[_bountyId].deadline = _deadline;
1352 
1353     emit BountyDeadlineChanged(_bountyId, _sender, _deadline);
1354   }
1355 
1356   /// @dev addIssuers(): Allows any of the issuers to add more issuers to the bounty
1357   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1358   /// @param _bountyId the index of the bounty
1359   /// @param _issuerId the index of the issuer who is calling the function
1360   /// @param _issuers the array of addresses to add to the list of valid issuers
1361   function addIssuers(
1362     address _sender,
1363     uint _bountyId,
1364     uint _issuerId,
1365     address payable[] memory _issuers)
1366     public
1367     senderIsValid(_sender)
1368     validateBountyArrayIndex(_bountyId)
1369     validateIssuerArrayIndex(_bountyId, _issuerId)
1370     onlyIssuer(_sender, _bountyId, _issuerId)
1371   {
1372     for (uint i = 0; i < _issuers.length; i++){
1373       bounties[_bountyId].issuers.push(_issuers[i]);
1374     }
1375 
1376     emit BountyIssuersUpdated(_bountyId, _sender, bounties[_bountyId].issuers);
1377   }
1378 
1379   /// @dev replaceIssuers(): Allows any of the issuers to replace the issuers of the bounty
1380   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1381   /// @param _bountyId the index of the bounty
1382   /// @param _issuerId the index of the issuer who is calling the function
1383   /// @param _issuers the array of addresses to replace the list of valid issuers
1384   function replaceIssuers(
1385     address _sender,
1386     uint _bountyId,
1387     uint _issuerId,
1388     address payable[] memory _issuers)
1389     public
1390     senderIsValid(_sender)
1391     validateBountyArrayIndex(_bountyId)
1392     validateIssuerArrayIndex(_bountyId, _issuerId)
1393     onlyIssuer(_sender, _bountyId, _issuerId)
1394   {
1395     require(_issuers.length > 0 || bounties[_bountyId].approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck
1396 
1397     bounties[_bountyId].issuers = _issuers;
1398 
1399     emit BountyIssuersUpdated(_bountyId, _sender, bounties[_bountyId].issuers);
1400   }
1401 
1402   /// @dev addApprovers(): Allows any of the issuers to add more approvers to the bounty
1403   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1404   /// @param _bountyId the index of the bounty
1405   /// @param _issuerId the index of the issuer who is calling the function
1406   /// @param _approvers the array of addresses to add to the list of valid approvers
1407   function addApprovers(
1408     address _sender,
1409     uint _bountyId,
1410     uint _issuerId,
1411     address[] memory _approvers)
1412     public
1413     senderIsValid(_sender)
1414     validateBountyArrayIndex(_bountyId)
1415     validateIssuerArrayIndex(_bountyId, _issuerId)
1416     onlyIssuer(_sender, _bountyId, _issuerId)
1417   {
1418     for (uint i = 0; i < _approvers.length; i++){
1419       bounties[_bountyId].approvers.push(_approvers[i]);
1420     }
1421 
1422     emit BountyApproversUpdated(_bountyId, _sender, bounties[_bountyId].approvers);
1423   }
1424 
1425   /// @dev replaceApprovers(): Allows any of the issuers to replace the approvers of the bounty
1426   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1427   /// @param _bountyId the index of the bounty
1428   /// @param _issuerId the index of the issuer who is calling the function
1429   /// @param _approvers the array of addresses to replace the list of valid approvers
1430   function replaceApprovers(
1431     address _sender,
1432     uint _bountyId,
1433     uint _issuerId,
1434     address[] memory _approvers)
1435     public
1436     senderIsValid(_sender)
1437     validateBountyArrayIndex(_bountyId)
1438     validateIssuerArrayIndex(_bountyId, _issuerId)
1439     onlyIssuer(_sender, _bountyId, _issuerId)
1440   {
1441     require(bounties[_bountyId].issuers.length > 0 || _approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck
1442     bounties[_bountyId].approvers = _approvers;
1443 
1444     emit BountyApproversUpdated(_bountyId, _sender, bounties[_bountyId].approvers);
1445   }
1446 
1447   /// @dev getBounty(): Returns the details of the bounty
1448   /// @param _bountyId the index of the bounty
1449   /// @return Returns a tuple for the bounty
1450   function getBounty(uint _bountyId)
1451     external
1452     view
1453     returns (Bounty memory)
1454   {
1455     return bounties[_bountyId];
1456   }
1457 
1458 
1459   function transferTokens(uint _bountyId, address payable _to, uint _amount)
1460     internal
1461   {
1462     if (bounties[_bountyId].tokenVersion == 0){
1463       require(_amount > 0); // Sending 0 tokens should throw
1464       require(bounties[_bountyId].balance >= _amount);
1465 
1466       bounties[_bountyId].balance = bounties[_bountyId].balance.sub(_amount);
1467 
1468       _to.transfer(_amount);
1469     } else if (bounties[_bountyId].tokenVersion == 20){
1470       require(_amount > 0); // Sending 0 tokens should throw
1471       require(bounties[_bountyId].balance >= _amount);
1472 
1473       bounties[_bountyId].balance = bounties[_bountyId].balance.sub(_amount);
1474 
1475       require(ERC20Token(bounties[_bountyId].token).transfer(_to, _amount));
1476     } else if (bounties[_bountyId].tokenVersion == 721){
1477       require(tokenBalances[_bountyId][_amount]);
1478 
1479       tokenBalances[_bountyId][_amount] = false; // Removes the 721 token from the balance of the bounty
1480 
1481       ERC721BasicToken(bounties[_bountyId].token).transferFrom(address(this),
1482                                                                _to,
1483                                                                _amount);
1484     } else {
1485       revert();
1486     }
1487   }
1488 
1489   /*
1490    * Events
1491    */
1492 
1493   event BountyIssued(uint _bountyId, address payable _creator, address payable[] _issuers, address[] _approvers, string _data, uint _deadline, address _token, uint _tokenVersion);
1494   event ContributionAdded(uint _bountyId, uint _contributionId, address payable _contributor, uint _amount);
1495   event ContributionRefunded(uint _bountyId, uint _contributionId);
1496   event ContributionsRefunded(uint _bountyId, address _issuer, uint[] _contributionIds);
1497   event BountyDrained(uint _bountyId, address _issuer, uint[] _amounts);
1498   event ActionPerformed(uint _bountyId, address _fulfiller, string _data);
1499   event BountyFulfilled(uint _bountyId, uint _fulfillmentId, address payable[] _fulfillers, string _data, address _submitter);
1500   event FulfillmentUpdated(uint _bountyId, uint _fulfillmentId, address payable[] _fulfillers, string _data);
1501   event FulfillmentAccepted(uint _bountyId, uint  _fulfillmentId, address _approver, uint[] _tokenAmounts);
1502   event BountyChanged(uint _bountyId, address _changer, address payable[] _issuers, address payable[] _approvers, string _data, uint _deadline);
1503   event BountyIssuersUpdated(uint _bountyId, address _changer, address payable[] _issuers);
1504   event BountyApproversUpdated(uint _bountyId, address _changer, address[] _approvers);
1505   event BountyDataChanged(uint _bountyId, address _changer, string _data);
1506   event BountyDeadlineChanged(uint _bountyId, address _changer, uint _deadline);
1507 }