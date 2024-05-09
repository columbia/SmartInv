1 pragma solidity 0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 contract Token {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() pure returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) view public returns (uint256 balance);
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) public returns (bool success);
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
33 
34     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of tokens to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) public returns (bool success);
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
44 
45     event Transfer(address _from, address _to, uint256 _value);
46     event Approval(address _owner, address _spender, uint256 _value);
47 }
48 
49 
50 contract ERC20Token is Token {
51 
52     function transfer(address _to, uint256 _value) public returns (bool success) {
53         //Default assumes totalSupply can't be over max (2^256 - 1).
54         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
55         //Replace the if with this one instead.
56         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
57         if (balances[msg.sender] >= _value && _value > 0) {
58             balances[msg.sender] -= _value;
59             balances[_to] += _value;
60             emit Transfer(msg.sender, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66         //same as above. Replace this line with the following if you want to protect against wrapping uints.
67         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
69             balances[_to] += _value;
70             balances[_from] -= _value;
71             allowed[_from][msg.sender] -= _value;
72             emit Transfer(_from, _to, _value);
73             return true;
74         } else { return false; }
75     }
76 
77     function balanceOf(address _owner) view public returns (uint256 balance) {
78         return balances[_owner];
79     }
80 
81     function approve(address _spender, uint256 _value) public returns (bool success) {
82         allowed[msg.sender][_spender] = _value;
83         emit Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
88       return allowed[_owner][_spender];
89     }
90 
91     mapping (address => uint256) balances;
92     mapping (address => mapping (address => uint256)) allowed;
93 }
94 
95 
96 
97 contract HumanStandardToken is ERC20Token {
98 
99     /* Public variables of the token */
100 
101     /*
102     NOTE:
103     The following variables are OPTIONAL vanities. One does not have to include them.
104     They allow one to customise the token contract & in no way influences the core functionality.
105     Some wallets/interfaces might not even bother to look at this information.
106     */
107     string public name;                   //fancy name: eg Simon Bucks
108     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
109     string public symbol;                 //An identifier: eg SBX
110     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
111 
112     constructor(
113         uint256 _initialAmount,
114         string memory _tokenName,
115         uint8 _decimalUnits,
116         string memory _tokenSymbol
117         ) public {
118         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
119         totalSupply = _initialAmount;                        // Update total supply
120         name = _tokenName;                                   // Set the name for display purposes
121         decimals = _decimalUnits;                            // Amount of decimals for display purposes
122         symbol = _tokenSymbol;                               // Set the symbol for display purposes
123     }
124     function transfer(address _to, uint256 _value) public returns (bool success) {
125         //Default assumes totalSupply can't be over max (2^256 - 1).
126         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
127         //Replace the if with this one instead.
128         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
129         if (balances[msg.sender] >= _value && _value > 0) {
130             balances[msg.sender] -= _value;
131             balances[_to] += _value;
132             emit Transfer(msg.sender, _to, _value);
133             return true;
134         } else { return false; }
135     }
136 
137     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
138         //same as above. Replace this line with the following if you want to protect against wrapping uints.
139         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
140         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
141             balances[_to] += _value;
142             balances[_from] -= _value;
143             allowed[_from][msg.sender] -= _value;
144             emit Transfer(_from, _to, _value);
145             return true;
146         } else { return false; }
147     }
148 
149     function balanceOf(address _owner) view public returns (uint256 balance) {
150         return balances[_owner];
151     }
152 
153     function approve(address _spender, uint256 _value) public returns (bool success) {
154         allowed[msg.sender][_spender] = _value;
155         emit Approval(msg.sender, _spender, _value);
156         return true;
157     }
158 
159     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
160       return allowed[_owner][_spender];
161     }
162 }
163 
164 /**
165  * @title SafeMath
166  * @dev Math operations with safety checks that throw on error
167  */
168 library SafeMath {
169 
170   /**
171   * @dev Multiplies two numbers, throws on overflow.
172   */
173   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
174     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
175     // benefit is lost if 'b' is also tested.
176     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
177     if (a == 0) {
178       return 0;
179     }
180 
181     c = a * b;
182     assert(c / a == b);
183     return c;
184   }
185 
186   /**
187   * @dev Integer division of two numbers, truncating the quotient.
188   */
189   function div(uint256 a, uint256 b) internal pure returns (uint256) {
190     // assert(b > 0); // Solidity automatically throws when dividing by 0
191     // uint256 c = a / b;
192     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193     return a / b;
194   }
195 
196   /**
197   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
198   */
199   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200     assert(b <= a);
201     return a - b;
202   }
203 
204   /**
205   * @dev Adds two numbers, throws on overflow.
206   */
207   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
208     c = a + b;
209     assert(c >= a);
210     return c;
211   }
212 }
213 
214 /**
215  * Utility library of inline functions on addresses
216  */
217 library AddressUtils {
218 
219   /**
220    * Returns whether the target address is a contract
221    * @dev This function will return false if invoked during the constructor of a contract,
222    * as the code is not actually created until after the constructor finishes.
223    * @param addr address to check
224    * @return whether the target address is a contract
225    */
226   function isContract(address addr) internal view returns (bool) {
227     uint256 size;
228     // XXX Currently there is no better way to check if there is a contract in an address
229     // than to check the size of the code at that address.
230     // See https://ethereum.stackexchange.com/a/14016/36603
231     // for more details about how this works.
232     // TODO Check this again before the Serenity release, because all addresses will be
233     // contracts then.
234     // solium-disable-next-line security/no-inline-assembly
235     assembly { size := extcodesize(addr) }
236     return size > 0;
237   }
238 
239 }
240 
241 /**
242  * @title ERC165
243  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
244  */
245 interface ERC165 {
246 
247   /**
248    * @notice Query if a contract implements an interface
249    * @param _interfaceId The interface identifier, as specified in ERC-165
250    * @dev Interface identification is specified in ERC-165. This function
251    * uses less than 30,000 gas.
252    */
253   function supportsInterface(bytes4 _interfaceId)
254     external
255     view
256     returns (bool);
257 }
258 
259 
260 /**
261  * @title SupportsInterfaceWithLookup
262  * @author Matt Condon (@shrugs)
263  * @dev Implements ERC165 using a lookup table.
264  */
265 contract SupportsInterfaceWithLookup is ERC165 {
266   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
267   /**
268    * 0x01ffc9a7 ===
269    *   bytes4(keccak256('supportsInterface(bytes4)'))
270    */
271 
272   /**
273    * @dev a mapping of interface id to whether or not it's supported
274    */
275   mapping(bytes4 => bool) internal supportedInterfaces;
276 
277   /**
278    * @dev A contract implementing SupportsInterfaceWithLookup
279    * implement ERC165 itself
280    */
281   constructor()
282     public
283   {
284     _registerInterface(InterfaceId_ERC165);
285   }
286 
287   /**
288    * @dev implement supportsInterface(bytes4) using a lookup table
289    */
290   function supportsInterface(bytes4 _interfaceId)
291     external
292     view
293     returns (bool)
294   {
295     return supportedInterfaces[_interfaceId];
296   }
297 
298   /**
299    * @dev private method for registering an interface
300    */
301   function _registerInterface(bytes4 _interfaceId)
302     internal
303   {
304     require(_interfaceId != 0xffffffff);
305     supportedInterfaces[_interfaceId] = true;
306   }
307 }
308 
309 /**
310  * @title ERC721 token receiver interface
311  * @dev Interface for any contract that wants to support safeTransfers
312  * from ERC721 asset contracts.
313  */
314 contract ERC721Receiver {
315   /**
316    * @dev Magic value to be returned upon successful reception of an NFT
317    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
318    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
319    */
320   bytes4 internal constant ERC721_RECEIVED = 0xf0b9e5ba;
321 
322   /**
323    * @notice Handle the receipt of an NFT
324    * @dev The ERC721 smart contract calls this function on the recipient
325    * after a `safetransfer`. This function MAY throw to revert and reject the
326    * transfer. This function MUST use 50,000 gas or less. Return of other
327    * than the magic value MUST result in the transaction being reverted.
328    * Note: the contract address is always the message sender.
329    * @param _from The sending address
330    * @param _tokenId The NFT identifier which is being transfered
331    * @param _data Additional data with no specified format
332    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
333    */
334   function onERC721Received(
335     address _from,
336     uint256 _tokenId,
337     bytes memory _data
338   )
339     public
340     returns(bytes4);
341 }
342 
343 /**
344  * @title ERC721 Non-Fungible Token Standard basic interface
345  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
346  */
347 contract ERC721Basic is ERC165 {
348   event Transfer(
349     address  _from,
350     address  _to,
351     uint256  _tokenId
352   );
353   event Approval(
354     address  _owner,
355     address  _approved,
356     uint256  _tokenId
357   );
358   event ApprovalForAll(
359     address  _owner,
360     address  _operator,
361     bool _approved
362   );
363 
364   function balanceOf(address _owner) public view returns (uint256 _balance);
365   function ownerOf(uint256 _tokenId) public view returns (address _owner);
366   function exists(uint256 _tokenId) public view returns (bool _exists);
367 
368   function approve(address _to, uint256 _tokenId) public;
369   function getApproved(uint256 _tokenId)
370     public view returns (address _operator);
371 
372   function setApprovalForAll(address _operator, bool _approved) public;
373   function isApprovedForAll(address _owner, address _operator)
374     public view returns (bool);
375 
376   function transferFrom(address _from, address _to, uint256 _tokenId) public;
377   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
378     public;
379 
380   function safeTransferFrom(
381     address _from,
382     address _to,
383     uint256 _tokenId,
384     bytes memory _data
385   )
386     public;
387 }
388 
389 /**
390  * @title ERC721 Non-Fungible Token Standard basic implementation
391  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
392  */
393 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
394 
395   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
396   /*
397    * 0x80ac58cd ===
398    *   bytes4(keccak256('balanceOf(address)')) ^
399    *   bytes4(keccak256('ownerOf(uint256)')) ^
400    *   bytes4(keccak256('approve(address,uint256)')) ^
401    *   bytes4(keccak256('getApproved(uint256)')) ^
402    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
403    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
404    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
405    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
406    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
407    */
408 
409   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
410   /*
411    * 0x4f558e79 ===
412    *   bytes4(keccak256('exists(uint256)'))
413    */
414 
415   using SafeMath for uint256;
416   using AddressUtils for address;
417 
418   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
419   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
420   bytes4 private constant ERC721_RECEIVED = 0xf0b9e5ba;
421 
422   // Mapping from token ID to owner
423   mapping (uint256 => address) internal tokenOwner;
424 
425   // Mapping from token ID to approved address
426   mapping (uint256 => address) internal tokenApprovals;
427 
428   // Mapping from owner to number of owned token
429   mapping (address => uint256) internal ownedTokensCount;
430 
431   // Mapping from owner to operator approvals
432   mapping (address => mapping (address => bool)) internal operatorApprovals;
433 
434 
435   uint public testint;
436   /**
437    * @dev Guarantees msg.sender is owner of the given token
438    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
439    */
440   modifier onlyOwnerOf(uint256 _tokenId) {
441     require(ownerOf(_tokenId) == msg.sender);
442     _;
443   }
444 
445   /**
446    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
447    * @param _tokenId uint256 ID of the token to validate
448    */
449   modifier canTransfer(uint256 _tokenId) {
450     require(isApprovedOrOwner(msg.sender, _tokenId));
451     _;
452   }
453 
454   constructor()
455     public
456   {
457     // register the supported interfaces to conform to ERC721 via ERC165
458     _registerInterface(InterfaceId_ERC721);
459     _registerInterface(InterfaceId_ERC721Exists);
460   }
461 
462   /**
463    * @dev Gets the balance of the specified address
464    * @param _owner address to query the balance of
465    * @return uint256 representing the amount owned by the passed address
466    */
467   function balanceOf(address _owner) public view returns (uint256) {
468     require(_owner != address(0));
469     return ownedTokensCount[_owner];
470   }
471 
472   /**
473    * @dev Gets the owner of the specified token ID
474    * @param _tokenId uint256 ID of the token to query the owner of
475    * @return owner address currently marked as the owner of the given token ID
476    */
477   function ownerOf(uint256 _tokenId) public view returns (address) {
478     address owner = tokenOwner[_tokenId];
479     require(owner != address(0));
480     return owner;
481   }
482 
483   /**
484    * @dev Returns whether the specified token exists
485    * @param _tokenId uint256 ID of the token to query the existence of
486    * @return whether the token exists
487    */
488   function exists(uint256 _tokenId) public view returns (bool) {
489     address owner = tokenOwner[_tokenId];
490     return owner != address(0);
491   }
492 
493   /**
494    * @dev Approves another address to transfer the given token ID
495    * The zero address indicates there is no approved address.
496    * There can only be one approved address per token at a given time.
497    * Can only be called by the token owner or an approved operator.
498    * @param _to address to be approved for the given token ID
499    * @param _tokenId uint256 ID of the token to be approved
500    */
501   function approve(address _to, uint256 _tokenId) public {
502     address owner = ownerOf(_tokenId);
503     require(_to != owner);
504     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
505 
506     tokenApprovals[_tokenId] = _to;
507     emit Approval(owner, _to, _tokenId);
508   }
509 
510   /**
511    * @dev Gets the approved address for a token ID, or zero if no address set
512    * @param _tokenId uint256 ID of the token to query the approval of
513    * @return address currently approved for the given token ID
514    */
515   function getApproved(uint256 _tokenId) public view returns (address) {
516     return tokenApprovals[_tokenId];
517   }
518 
519   /**
520    * @dev Sets or unsets the approval of a given operator
521    * An operator is allowed to transfer all tokens of the sender on their behalf
522    * @param _to operator address to set the approval
523    * @param _approved representing the status of the approval to be set
524    */
525   function setApprovalForAll(address _to, bool _approved) public {
526     require(_to != msg.sender);
527     operatorApprovals[msg.sender][_to] = _approved;
528     emit ApprovalForAll(msg.sender, _to, _approved);
529   }
530 
531   /**
532    * @dev Tells whether an operator is approved by a given owner
533    * @param _owner owner address which you want to query the approval of
534    * @param _operator operator address which you want to query the approval of
535    * @return bool whether the given operator is approved by the given owner
536    */
537   function isApprovedForAll(
538     address _owner,
539     address _operator
540   )
541     public
542     view
543     returns (bool)
544   {
545     return operatorApprovals[_owner][_operator];
546   }
547 
548   /**
549    * @dev Transfers the ownership of a given token ID to another address
550    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
551    * Requires the msg sender to be the owner, approved, or operator
552    * @param _from current owner of the token
553    * @param _to address to receive the ownership of the given token ID
554    * @param _tokenId uint256 ID of the token to be transferred
555   */
556   function transferFrom(
557     address _from,
558     address _to,
559     uint256 _tokenId
560   )
561     public
562     canTransfer(_tokenId)
563   {
564     require(_from != address(0));
565     require(_to != address(0));
566 
567     clearApproval(_from, _tokenId);
568     removeTokenFrom(_from, _tokenId);
569     addTokenTo(_to, _tokenId);
570 
571     emit Transfer(_from, _to, _tokenId);
572   }
573 
574   /**
575    * @dev Safely transfers the ownership of a given token ID to another address
576    * If the target address is a contract, it must implement `onERC721Received`,
577    * which is called upon a safe transfer, and return the magic value
578    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
579    * the transfer is reverted.
580    *
581    * Requires the msg sender to be the owner, approved, or operator
582    * @param _from current owner of the token
583    * @param _to address to receive the ownership of the given token ID
584    * @param _tokenId uint256 ID of the token to be transferred
585   */
586   function safeTransferFrom(
587     address _from,
588     address _to,
589     uint256 _tokenId
590   )
591     public
592     canTransfer(_tokenId)
593   {
594     // solium-disable-next-line arg-overflow
595     safeTransferFrom(_from, _to, _tokenId, "");
596   }
597 
598   /**
599    * @dev Safely transfers the ownership of a given token ID to another address
600    * If the target address is a contract, it must implement `onERC721Received`,
601    * which is called upon a safe transfer, and return the magic value
602    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
603    * the transfer is reverted.
604    * Requires the msg sender to be the owner, approved, or operator
605    * @param _from current owner of the token
606    * @param _to address to receive the ownership of the given token ID
607    * @param _tokenId uint256 ID of the token to be transferred
608    * @param _data bytes data to send along with a safe transfer check
609    */
610   function safeTransferFrom(
611     address _from,
612     address _to,
613     uint256 _tokenId,
614     bytes memory _data
615   )
616     public
617     canTransfer(_tokenId)
618   {
619     transferFrom(_from, _to, _tokenId);
620     // solium-disable-next-line arg-overflow
621     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
622   }
623 
624   /**
625    * @dev Returns whether the given spender can transfer a given token ID
626    * @param _spender address of the spender to query
627    * @param _tokenId uint256 ID of the token to be transferred
628    * @return bool whether the msg.sender is approved for the given token ID,
629    *  is an operator of the owner, or is the owner of the token
630    */
631   function isApprovedOrOwner(
632     address _spender,
633     uint256 _tokenId
634   )
635     internal
636     view
637     returns (bool)
638   {
639     address owner = ownerOf(_tokenId);
640     // Disable solium check because of
641     // https://github.com/duaraghav8/Solium/issues/175
642     // solium-disable-next-line operator-whitespace
643     return (
644       _spender == owner ||
645       getApproved(_tokenId) == _spender ||
646       isApprovedForAll(owner, _spender)
647     );
648   }
649 
650   /**
651    * @dev Internal function to mint a new token
652    * Reverts if the given token ID already exists
653    * @param _to The address that will own the minted token
654    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
655    */
656   function _mint(address _to, uint256 _tokenId) internal {
657     require(_to != address(0));
658     addTokenTo(_to, _tokenId);
659     emit Transfer(address(0), _to, _tokenId);
660   }
661 
662   /**
663    * @dev Internal function to burn a specific token
664    * Reverts if the token does not exist
665    * @param _tokenId uint256 ID of the token being burned by the msg.sender
666    */
667   function _burn(address _owner, uint256 _tokenId) internal {
668     clearApproval(_owner, _tokenId);
669     removeTokenFrom(_owner, _tokenId);
670     emit Transfer(_owner, address(0), _tokenId);
671   }
672 
673   /**
674    * @dev Internal function to clear current approval of a given token ID
675    * Reverts if the given address is not indeed the owner of the token
676    * @param _owner owner of the token
677    * @param _tokenId uint256 ID of the token to be transferred
678    */
679   function clearApproval(address _owner, uint256 _tokenId) internal {
680     require(ownerOf(_tokenId) == _owner);
681     if (tokenApprovals[_tokenId] != address(0)) {
682       tokenApprovals[_tokenId] = address(0);
683     }
684   }
685 
686   /**
687    * @dev Internal function to add a token ID to the list of a given address
688    * @param _to address representing the new owner of the given token ID
689    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
690    */
691   function addTokenTo(address _to, uint256 _tokenId) internal {
692     require(tokenOwner[_tokenId] == address(0));
693     tokenOwner[_tokenId] = _to;
694     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
695   }
696 
697   /**
698    * @dev Internal function to remove a token ID from the list of a given address
699    * @param _from address representing the previous owner of the given token ID
700    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
701    */
702   function removeTokenFrom(address _from, uint256 _tokenId) internal {
703     require(ownerOf(_tokenId) == _from);
704     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
705     tokenOwner[_tokenId] = address(0);
706   }
707 
708   /**
709    * @dev Internal function to invoke `onERC721Received` on a target address
710    * The call is not executed if the target address is not a contract
711    * @param _from address representing the previous owner of the given token ID
712    * @param _to target address that will receive the tokens
713    * @param _tokenId uint256 ID of the token to be transferred
714    * @param _data bytes optional data to send along with the call
715    * @return whether the call correctly returned the expected magic value
716    */
717   function checkAndCallSafeTransfer(
718     address _from,
719     address _to,
720     uint256 _tokenId,
721     bytes memory _data
722   )
723     internal
724     returns (bool)
725   {
726     if (!_to.isContract()) {
727       return true;
728     }
729     bytes4 retval = ERC721Receiver(_to).onERC721Received(
730       _from, _tokenId, _data);
731     return (retval == ERC721_RECEIVED);
732   }
733 }
734 
735 contract ERC721BasicTokenMock is ERC721BasicToken {
736   function mint(address _to, uint256 _tokenId) public {
737     super._mint(_to, _tokenId);
738   }
739 
740   function burn(uint256 _tokenId) public {
741     super._burn(ownerOf(_tokenId), _tokenId);
742   }
743 }
744 
745 
746 /// @title StandardBounties
747 /// @dev A contract for issuing bounties on Ethereum paying in ETH, ERC20, or ERC721 tokens
748 /// @author Mark Beylin <mark.beylin@consensys.net>, Gonçalo Sá <goncalo.sa@consensys.net>, Kevin Owocki <kevin.owocki@consensys.net>, Ricardo Guilherme Schmidt (@3esmit), Matt Garnett <matt.garnett@consensys.net>, Craig Williams <craig.williams@consensys.net>
749 contract StandardBounties {
750 
751   using SafeMath for uint256;
752 
753   /*
754    * Structs
755    */
756 
757   struct Bounty {
758     address payable [] issuers; // An array of individuals who have complete control over the bounty, and can edit any of its parameters
759     address [] approvers; // An array of individuals who are allowed to accept the fulfillments for a particular bounty
760     uint deadline; // The Unix timestamp before which all submissions must be made, and after which refunds may be processed
761     address token; // The address of the token associated with the bounty (should be disregarded if the tokenVersion is 0)
762     uint tokenVersion; // The version of the token being used for the bounty (0 for ETH, 20 for ERC20, 721 for ERC721)
763     uint balance; // The number of tokens which the bounty is able to pay out or refund
764     bool hasPaidOut; // A boolean storing whether or not the bounty has paid out at least once, meaning refunds are no longer allowed
765     Fulfillment [] fulfillments; // An array of Fulfillments which store the various submissions which have been made to the bounty
766     Contribution [] contributions; // An array of Contributions which store the contributions which have been made to the bounty
767   }
768 
769   struct Fulfillment {
770     address payable [] fulfillers; // An array of addresses who should receive payouts for a given submission
771     address submitter; // The address of the individual who submitted the fulfillment, who is able to update the submission as needed
772   }
773 
774   struct Contribution {
775     address payable contributor; // The address of the individual who contributed
776     uint amount; // The amount of tokens the user contributed
777     bool refunded; // A boolean storing whether or not the contribution has been refunded yet
778   }
779 
780   /*
781    * Storage
782    */
783 
784   uint public numBounties; // An integer storing the total number of bounties in the contract
785   mapping(uint => Bounty) public bounties; // A mapping of bountyIDs to bounties
786   mapping (uint => mapping (uint => bool)) public tokenBalances; // A mapping of bountyIds to tokenIds to booleans, storing whether a given bounty has a given ERC721 token in its balance
787 
788 
789   address public owner; // The address of the individual who's allowed to set the metaTxRelayer address
790   address public metaTxRelayer; // The address of the meta transaction relayer whose _sender is automatically trusted for all contract calls
791 
792   bool public callStarted; // Ensures mutex for the entire contract
793 
794   /*
795    * Modifiers
796    */
797 
798   modifier callNotStarted(){
799     require(!callStarted);
800     callStarted = true;
801     _;
802     callStarted = false;
803   }
804 
805   modifier validateBountyArrayIndex(
806     uint _index)
807   {
808     require(_index < numBounties);
809     _;
810   }
811 
812   modifier validateContributionArrayIndex(
813     uint _bountyId,
814     uint _index)
815   {
816     require(_index < bounties[_bountyId].contributions.length);
817     _;
818   }
819 
820   modifier validateFulfillmentArrayIndex(
821     uint _bountyId,
822     uint _index)
823   {
824     require(_index < bounties[_bountyId].fulfillments.length);
825     _;
826   }
827 
828   modifier validateIssuerArrayIndex(
829     uint _bountyId,
830     uint _index)
831   {
832     require(_index < bounties[_bountyId].issuers.length);
833     _;
834   }
835 
836   modifier validateApproverArrayIndex(
837     uint _bountyId,
838     uint _index)
839   {
840     require(_index < bounties[_bountyId].approvers.length);
841     _;
842   }
843 
844   modifier onlyIssuer(
845   address _sender,
846   uint _bountyId,
847   uint _issuerId)
848   {
849   require(_sender == bounties[_bountyId].issuers[_issuerId]);
850   _;
851   }
852 
853   modifier onlySubmitter(
854     address _sender,
855     uint _bountyId,
856     uint _fulfillmentId)
857   {
858     require(_sender ==
859             bounties[_bountyId].fulfillments[_fulfillmentId].submitter);
860     _;
861   }
862 
863   modifier onlyContributor(
864   address _sender,
865   uint _bountyId,
866   uint _contributionId)
867   {
868     require(_sender ==
869             bounties[_bountyId].contributions[_contributionId].contributor);
870     _;
871   }
872 
873   modifier isApprover(
874     address _sender,
875     uint _bountyId,
876     uint _approverId)
877   {
878     require(_sender == bounties[_bountyId].approvers[_approverId]);
879     _;
880   }
881 
882   modifier hasNotPaid(
883     uint _bountyId)
884   {
885     require(!bounties[_bountyId].hasPaidOut);
886     _;
887   }
888 
889   modifier hasNotRefunded(
890     uint _bountyId,
891     uint _contributionId)
892   {
893     require(!bounties[_bountyId].contributions[_contributionId].refunded);
894     _;
895   }
896 
897   modifier senderIsValid(
898     address _sender)
899   {
900     require(msg.sender == _sender || msg.sender == metaTxRelayer);
901     _;
902   }
903 
904  /*
905   * Public functions
906   */
907 
908   constructor() public {
909     // The owner of the contract is automatically designated to be the deployer of the contract
910     owner = msg.sender;
911   }
912 
913   /// @dev setMetaTxRelayer(): Sets the address of the meta transaction relayer
914   /// @param _relayer the address of the relayer
915   function setMetaTxRelayer(address _relayer)
916     external
917   {
918     require(msg.sender == owner); // Checks that only the owner can call
919     require(metaTxRelayer == address(0)); // Ensures the meta tx relayer can only be set once
920     metaTxRelayer = _relayer;
921   }
922 
923   /// @dev issueBounty(): creates a new bounty
924   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
925   /// @param _issuers the array of addresses who will be the issuers of the bounty
926   /// @param _approvers the array of addresses who will be the approvers of the bounty
927   /// @param _data the IPFS hash representing the JSON object storing the details of the bounty (see docs for schema details)
928   /// @param _deadline the timestamp which will become the deadline of the bounty
929   /// @param _token the address of the token which will be used for the bounty
930   /// @param _tokenVersion the version of the token being used for the bounty (0 for ETH, 20 for ERC20, 721 for ERC721)
931   function issueBounty(
932     address payable _sender,
933     address payable [] memory _issuers,
934     address [] memory _approvers,
935     string memory _data,
936     uint _deadline,
937     address _token,
938     uint _tokenVersion)
939     public
940     senderIsValid(_sender)
941     returns (uint)
942   {
943     require(_tokenVersion == 0 || _tokenVersion == 20 || _tokenVersion == 721); // Ensures a bounty can only be issued with a valid token version
944     require(_issuers.length > 0 || _approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck
945 
946     uint bountyId = numBounties; // The next bounty's index will always equal the number of existing bounties
947 
948     Bounty storage newBounty = bounties[bountyId];
949     newBounty.issuers = _issuers;
950     newBounty.approvers = _approvers;
951     newBounty.deadline = _deadline;
952     newBounty.tokenVersion = _tokenVersion;
953 
954     if (_tokenVersion != 0) {
955       newBounty.token = _token;
956     }
957 
958     numBounties = numBounties.add(1); // Increments the number of bounties, since a new one has just been added
959 
960     emit BountyIssued(bountyId,
961                       _sender,
962                       _issuers,
963                       _approvers,
964                       _data, // Instead of storing the string on-chain, it is emitted within the event for easy off-chain consumption
965                       _deadline,
966                       _token,
967                       _tokenVersion);
968 
969     return (bountyId);
970   }
971 
972   /// @param _depositAmount the amount of tokens being deposited to the bounty, which will create a new contribution to the bounty
973 
974 
975   function issueAndContribute(
976     address payable _sender,
977     address payable [] memory _issuers,
978     address [] memory _approvers,
979     string memory _data,
980     uint _deadline,
981     address _token,
982     uint _tokenVersion,
983     uint _depositAmount)
984     public
985     payable
986     returns(uint)
987   {
988     uint bountyId = issueBounty(_sender, _issuers, _approvers, _data, _deadline, _token, _tokenVersion);
989 
990     contribute(_sender, bountyId, _depositAmount);
991 
992     return (bountyId);
993   }
994 
995 
996   /// @dev contribute(): Allows users to contribute tokens to a given bounty.
997   ///                    Contributing merits no privelages to administer the
998   ///                    funds in the bounty or accept submissions. Contributions
999   ///                    are refundable but only on the condition that the deadline
1000   ///                    has elapsed, and the bounty has not yet paid out any funds.
1001   ///                    All funds deposited in a bounty are at the mercy of a
1002   ///                    bounty's issuers and approvers, so please be careful!
1003   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1004   /// @param _bountyId the index of the bounty
1005   /// @param _amount the amount of tokens being contributed
1006   function contribute(
1007     address payable _sender,
1008     uint _bountyId,
1009     uint _amount)
1010     public
1011     payable
1012     senderIsValid(_sender)
1013     validateBountyArrayIndex(_bountyId)
1014     callNotStarted
1015   {
1016     require(_amount > 0); // Contributions of 0 tokens or token ID 0 should fail
1017 
1018     bounties[_bountyId].contributions.push(
1019       Contribution(_sender, _amount, false)); // Adds the contribution to the bounty
1020 
1021     if (bounties[_bountyId].tokenVersion == 0){
1022 
1023       bounties[_bountyId].balance = bounties[_bountyId].balance.add(_amount); // Increments the balance of the bounty
1024 
1025       require(msg.value == _amount);
1026     } else if (bounties[_bountyId].tokenVersion == 20) {
1027 
1028       bounties[_bountyId].balance = bounties[_bountyId].balance.add(_amount); // Increments the balance of the bounty
1029 
1030       require(msg.value == 0); // Ensures users don't accidentally send ETH alongside a token contribution, locking up funds
1031       require(ERC20Token(bounties[_bountyId].token).transferFrom(_sender,
1032                                                                  address(this),
1033                                                                  _amount));
1034     } else if (bounties[_bountyId].tokenVersion == 721) {
1035       tokenBalances[_bountyId][_amount] = true; // Adds the 721 token to the balance of the bounty
1036 
1037 
1038       require(msg.value == 0); // Ensures users don't accidentally send ETH alongside a token contribution, locking up funds
1039       ERC721BasicToken(bounties[_bountyId].token).transferFrom(_sender,
1040                                                                address(this),
1041                                                                _amount);
1042     } else {
1043       revert();
1044     }
1045 
1046     emit ContributionAdded(_bountyId,
1047                            bounties[_bountyId].contributions.length - 1, // The new contributionId
1048                            _sender,
1049                            _amount);
1050   }
1051 
1052   /// @dev refundContribution(): Allows users to refund the contributions they've
1053   ///                            made to a particular bounty, but only if the bounty
1054   ///                            has not yet paid out, and the deadline has elapsed.
1055   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1056   /// @param _bountyId the index of the bounty
1057   /// @param _contributionId the index of the contribution being refunded
1058   function refundContribution(
1059     address _sender,
1060     uint _bountyId,
1061     uint _contributionId)
1062     public
1063     senderIsValid(_sender)
1064     validateBountyArrayIndex(_bountyId)
1065     validateContributionArrayIndex(_bountyId, _contributionId)
1066     onlyContributor(_sender, _bountyId, _contributionId)
1067     hasNotPaid(_bountyId)
1068     hasNotRefunded(_bountyId, _contributionId)
1069     callNotStarted
1070   {
1071     require(now > bounties[_bountyId].deadline); // Refunds may only be processed after the deadline has elapsed
1072 
1073     Contribution storage contribution =
1074       bounties[_bountyId].contributions[_contributionId];
1075 
1076     contribution.refunded = true;
1077 
1078     transferTokens(_bountyId, contribution.contributor, contribution.amount); // Performs the disbursal of tokens to the contributor
1079 
1080     emit ContributionRefunded(_bountyId, _contributionId);
1081   }
1082 
1083   /// @dev refundMyContributions(): Allows users to refund their contributions in bulk
1084   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1085   /// @param _bountyId the index of the bounty
1086   /// @param _contributionIds the array of indexes of the contributions being refunded
1087   function refundMyContributions(
1088     address _sender,
1089     uint _bountyId,
1090     uint [] memory _contributionIds)
1091     public
1092     senderIsValid(_sender)
1093   {
1094     for (uint i = 0; i < _contributionIds.length; i++){
1095       refundContribution(_sender, _bountyId, _contributionIds[i]);
1096     }
1097   }
1098 
1099   /// @dev refundContributions(): Allows users to refund their contributions in bulk
1100   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1101   /// @param _bountyId the index of the bounty
1102   /// @param _issuerId the index of the issuer who is making the call
1103   /// @param _contributionIds the array of indexes of the contributions being refunded
1104   function refundContributions(
1105     address _sender,
1106     uint _bountyId,
1107     uint _issuerId,
1108     uint [] memory _contributionIds)
1109     public
1110     senderIsValid(_sender)
1111     validateBountyArrayIndex(_bountyId)
1112     onlyIssuer(_sender, _bountyId, _issuerId)
1113     callNotStarted
1114   {
1115     for (uint i = 0; i < _contributionIds.length; i++){
1116       require(_contributionIds[i] < bounties[_bountyId].contributions.length);
1117 
1118       Contribution storage contribution =
1119         bounties[_bountyId].contributions[_contributionIds[i]];
1120 
1121       require(!contribution.refunded);
1122 
1123       contribution.refunded = true;
1124 
1125       transferTokens(_bountyId, contribution.contributor, contribution.amount); // Performs the disbursal of tokens to the contributor
1126     }
1127 
1128     emit ContributionsRefunded(_bountyId, _sender, _contributionIds);
1129   }
1130 
1131   /// @dev drainBounty(): Allows an issuer to drain the funds from the bounty
1132   /// @notice when using this function, if an issuer doesn't drain the entire balance, some users may be able to refund their contributions, while others may not (which is unfair to them). Please use it wisely, only when necessary
1133   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1134   /// @param _bountyId the index of the bounty
1135   /// @param _issuerId the index of the issuer who is making the call
1136   /// @param _amounts an array of amounts of tokens to be sent. The length of the array should be 1 if the bounty is in ETH or ERC20 tokens. If it's an ERC721 bounty, the array should be the list of tokenIDs.
1137   function drainBounty(
1138     address payable _sender,
1139     uint _bountyId,
1140     uint _issuerId,
1141     uint [] memory _amounts)
1142     public
1143     senderIsValid(_sender)
1144     validateBountyArrayIndex(_bountyId)
1145     onlyIssuer(_sender, _bountyId, _issuerId)
1146     callNotStarted
1147   {
1148     if (bounties[_bountyId].tokenVersion == 0 || bounties[_bountyId].tokenVersion == 20){
1149       require(_amounts.length == 1); // ensures there's only 1 amount of tokens to be returned
1150       require(_amounts[0] <= bounties[_bountyId].balance); // ensures an issuer doesn't try to drain the bounty of more tokens than their balance permits
1151       transferTokens(_bountyId, _sender, _amounts[0]); // Performs the draining of tokens to the issuer
1152     } else {
1153       for (uint i = 0; i < _amounts.length; i++){
1154         require(tokenBalances[_bountyId][_amounts[i]]);// ensures an issuer doesn't try to drain the bounty of a token it doesn't have in its balance
1155         transferTokens(_bountyId, _sender, _amounts[i]);
1156       }
1157     }
1158 
1159     emit BountyDrained(_bountyId, _sender, _amounts);
1160   }
1161 
1162   /// @dev performAction(): Allows users to perform any generalized action
1163   ///                       associated with a particular bounty, such as applying for it
1164   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1165   /// @param _bountyId the index of the bounty
1166   /// @param _data the IPFS hash corresponding to a JSON object which contains the details of the action being performed (see docs for schema details)
1167   function performAction(
1168     address _sender,
1169     uint _bountyId,
1170     string memory _data)
1171     public
1172     senderIsValid(_sender)
1173     validateBountyArrayIndex(_bountyId)
1174   {
1175     emit ActionPerformed(_bountyId, _sender, _data); // The _data string is emitted in an event for easy off-chain consumption
1176   }
1177 
1178   /// @dev fulfillBounty(): Allows users to fulfill the bounty to get paid out
1179   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1180   /// @param _bountyId the index of the bounty
1181   /// @param _fulfillers the array of addresses which will receive payouts for the submission
1182   /// @param _data the IPFS hash corresponding to a JSON object which contains the details of the submission (see docs for schema details)
1183   function fulfillBounty(
1184     address _sender,
1185     uint _bountyId,
1186     address payable [] memory  _fulfillers,
1187     string memory _data)
1188     public
1189     senderIsValid(_sender)
1190     validateBountyArrayIndex(_bountyId)
1191   {
1192     require(now < bounties[_bountyId].deadline); // Submissions are only allowed to be made before the deadline
1193     require(_fulfillers.length > 0); // Submissions with no fulfillers would mean no one gets paid out
1194 
1195     bounties[_bountyId].fulfillments.push(Fulfillment(_fulfillers, _sender));
1196 
1197     emit BountyFulfilled(_bountyId,
1198                          (bounties[_bountyId].fulfillments.length - 1),
1199                          _fulfillers,
1200                          _data, // The _data string is emitted in an event for easy off-chain consumption
1201                          _sender);
1202   }
1203 
1204   /// @dev updateFulfillment(): Allows the submitter of a fulfillment to update their submission
1205   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1206   /// @param _bountyId the index of the bounty
1207   /// @param _fulfillmentId the index of the fulfillment
1208   /// @param _fulfillers the new array of addresses which will receive payouts for the submission
1209   /// @param _data the new IPFS hash corresponding to a JSON object which contains the details of the submission (see docs for schema details)
1210   function updateFulfillment(
1211   address _sender,
1212   uint _bountyId,
1213   uint _fulfillmentId,
1214   address payable [] memory _fulfillers,
1215   string memory _data)
1216   public
1217   senderIsValid(_sender)
1218   validateBountyArrayIndex(_bountyId)
1219   validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)
1220   onlySubmitter(_sender, _bountyId, _fulfillmentId) // Only the original submitter of a fulfillment may update their submission
1221   {
1222     bounties[_bountyId].fulfillments[_fulfillmentId].fulfillers = _fulfillers;
1223     emit FulfillmentUpdated(_bountyId,
1224                             _fulfillmentId,
1225                             _fulfillers,
1226                             _data); // The _data string is emitted in an event for easy off-chain consumption
1227   }
1228 
1229   /// @dev acceptFulfillment(): Allows any of the approvers to accept a given submission
1230   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1231   /// @param _bountyId the index of the bounty
1232   /// @param _fulfillmentId the index of the fulfillment to be accepted
1233   /// @param _approverId the index of the approver which is making the call
1234   /// @param _tokenAmounts the array of token amounts which will be paid to the
1235   ///                      fulfillers, whose length should equal the length of the
1236   ///                      _fulfillers array of the submission. If the bounty pays
1237   ///                      in ERC721 tokens, then these should be the token IDs
1238   ///                      being sent to each of the individual fulfillers
1239   function acceptFulfillment(
1240     address _sender,
1241     uint _bountyId,
1242     uint _fulfillmentId,
1243     uint _approverId,
1244     uint[] memory _tokenAmounts)
1245     public
1246     senderIsValid(_sender)
1247     validateBountyArrayIndex(_bountyId)
1248     validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)
1249     isApprover(_sender, _bountyId, _approverId)
1250     callNotStarted
1251   {
1252     // now that the bounty has paid out at least once, refunds are no longer possible
1253     bounties[_bountyId].hasPaidOut = true;
1254 
1255     Fulfillment storage fulfillment =
1256       bounties[_bountyId].fulfillments[_fulfillmentId];
1257 
1258     require(_tokenAmounts.length == fulfillment.fulfillers.length); // Each fulfiller should get paid some amount of tokens (this can be 0)
1259 
1260     for (uint256 i = 0; i < fulfillment.fulfillers.length; i++){
1261         if (_tokenAmounts[i] > 0) {
1262           // for each fulfiller associated with the submission
1263           transferTokens(_bountyId, fulfillment.fulfillers[i], _tokenAmounts[i]);
1264         }
1265     }
1266     emit FulfillmentAccepted(_bountyId,
1267                              _fulfillmentId,
1268                              _sender,
1269                              _tokenAmounts);
1270   }
1271 
1272   /// @dev fulfillAndAccept(): Allows any of the approvers to fulfill and accept a submission simultaneously
1273   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1274   /// @param _bountyId the index of the bounty
1275   /// @param _fulfillers the array of addresses which will receive payouts for the submission
1276   /// @param _data the IPFS hash corresponding to a JSON object which contains the details of the submission (see docs for schema details)
1277   /// @param _approverId the index of the approver which is making the call
1278   /// @param _tokenAmounts the array of token amounts which will be paid to the
1279   ///                      fulfillers, whose length should equal the length of the
1280   ///                      _fulfillers array of the submission. If the bounty pays
1281   ///                      in ERC721 tokens, then these should be the token IDs
1282   ///                      being sent to each of the individual fulfillers
1283   function fulfillAndAccept(
1284     address _sender,
1285     uint _bountyId,
1286     address payable [] memory _fulfillers,
1287     string memory _data,
1288     uint _approverId,
1289     uint[] memory _tokenAmounts)
1290     public
1291     senderIsValid(_sender)
1292   {
1293     // first fulfills the bounty on behalf of the fulfillers
1294     fulfillBounty(_sender, _bountyId, _fulfillers, _data);
1295 
1296     // then accepts the fulfillment
1297     acceptFulfillment(_sender,
1298                       _bountyId,
1299                       bounties[_bountyId].fulfillments.length - 1,
1300                       _approverId,
1301                       _tokenAmounts);
1302   }
1303 
1304 
1305 
1306   /// @dev changeBounty(): Allows any of the issuers to change the bounty
1307   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1308   /// @param _bountyId the index of the bounty
1309   /// @param _issuerId the index of the issuer who is calling the function
1310   /// @param _issuers the new array of addresses who will be the issuers of the bounty
1311   /// @param _approvers the new array of addresses who will be the approvers of the bounty
1312   /// @param _data the new IPFS hash representing the JSON object storing the details of the bounty (see docs for schema details)
1313   /// @param _deadline the new timestamp which will become the deadline of the bounty
1314   function changeBounty(
1315     address _sender,
1316     uint _bountyId,
1317     uint _issuerId,
1318     address payable [] memory _issuers,
1319     address payable [] memory _approvers,
1320     string memory _data,
1321     uint _deadline)
1322     public
1323     senderIsValid(_sender)
1324   {
1325     require(_bountyId < numBounties); // makes the validateBountyArrayIndex modifier in-line to avoid stack too deep errors
1326     require(_issuerId < bounties[_bountyId].issuers.length); // makes the validateIssuerArrayIndex modifier in-line to avoid stack too deep errors
1327     require(_sender == bounties[_bountyId].issuers[_issuerId]); // makes the onlyIssuer modifier in-line to avoid stack too deep errors
1328 
1329     require(_issuers.length > 0 || _approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck
1330 
1331     bounties[_bountyId].issuers = _issuers;
1332     bounties[_bountyId].approvers = _approvers;
1333     bounties[_bountyId].deadline = _deadline;
1334     emit BountyChanged(_bountyId,
1335                        _sender,
1336                        _issuers,
1337                        _approvers,
1338                        _data,
1339                        _deadline);
1340   }
1341 
1342   /// @dev changeIssuer(): Allows any of the issuers to change a particular issuer of the bounty
1343   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1344   /// @param _bountyId the index of the bounty
1345   /// @param _issuerId the index of the issuer who is calling the function
1346   /// @param _issuerIdToChange the index of the issuer who is being changed
1347   /// @param _newIssuer the address of the new issuer
1348   function changeIssuer(
1349     address _sender,
1350     uint _bountyId,
1351     uint _issuerId,
1352     uint _issuerIdToChange,
1353     address payable _newIssuer)
1354     public
1355     senderIsValid(_sender)
1356     validateBountyArrayIndex(_bountyId)
1357     validateIssuerArrayIndex(_bountyId, _issuerIdToChange)
1358     onlyIssuer(_sender, _bountyId, _issuerId)
1359   {
1360     require(_issuerId < bounties[_bountyId].issuers.length || _issuerId == 0);
1361 
1362     bounties[_bountyId].issuers[_issuerIdToChange] = _newIssuer;
1363 
1364     emit BountyIssuersUpdated(_bountyId, _sender, bounties[_bountyId].issuers);
1365   }
1366 
1367   /// @dev changeApprover(): Allows any of the issuers to change a particular approver of the bounty
1368   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1369   /// @param _bountyId the index of the bounty
1370   /// @param _issuerId the index of the issuer who is calling the function
1371   /// @param _approverId the index of the approver who is being changed
1372   /// @param _approver the address of the new approver
1373   function changeApprover(
1374     address _sender,
1375     uint _bountyId,
1376     uint _issuerId,
1377     uint _approverId,
1378     address payable _approver)
1379     external
1380     senderIsValid(_sender)
1381     validateBountyArrayIndex(_bountyId)
1382     onlyIssuer(_sender, _bountyId, _issuerId)
1383     validateApproverArrayIndex(_bountyId, _approverId)
1384   {
1385     bounties[_bountyId].approvers[_approverId] = _approver;
1386 
1387     emit BountyApproversUpdated(_bountyId, _sender, bounties[_bountyId].approvers);
1388   }
1389 
1390   /// @dev changeData(): Allows any of the issuers to change the data the bounty
1391   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1392   /// @param _bountyId the index of the bounty
1393   /// @param _issuerId the index of the issuer who is calling the function
1394   /// @param _data the new IPFS hash representing the JSON object storing the details of the bounty (see docs for schema details)
1395   function changeData(
1396     address _sender,
1397     uint _bountyId,
1398     uint _issuerId,
1399     string memory _data)
1400     public
1401     senderIsValid(_sender)
1402     validateBountyArrayIndex(_bountyId)
1403     validateIssuerArrayIndex(_bountyId, _issuerId)
1404     onlyIssuer(_sender, _bountyId, _issuerId)
1405   {
1406     emit BountyDataChanged(_bountyId, _sender, _data); // The new _data is emitted within an event rather than being stored on-chain for minimized gas costs
1407   }
1408 
1409   /// @dev changeDeadline(): Allows any of the issuers to change the deadline the bounty
1410   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1411   /// @param _bountyId the index of the bounty
1412   /// @param _issuerId the index of the issuer who is calling the function
1413   /// @param _deadline the new timestamp which will become the deadline of the bounty
1414   function changeDeadline(
1415     address _sender,
1416     uint _bountyId,
1417     uint _issuerId,
1418     uint _deadline)
1419     external
1420     senderIsValid(_sender)
1421     validateBountyArrayIndex(_bountyId)
1422     validateIssuerArrayIndex(_bountyId, _issuerId)
1423     onlyIssuer(_sender, _bountyId, _issuerId)
1424   {
1425     bounties[_bountyId].deadline = _deadline;
1426 
1427     emit BountyDeadlineChanged(_bountyId, _sender, _deadline);
1428   }
1429 
1430   /// @dev addIssuers(): Allows any of the issuers to add more issuers to the bounty
1431   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1432   /// @param _bountyId the index of the bounty
1433   /// @param _issuerId the index of the issuer who is calling the function
1434   /// @param _issuers the array of addresses to add to the list of valid issuers
1435   function addIssuers(
1436     address _sender,
1437     uint _bountyId,
1438     uint _issuerId,
1439     address payable [] memory _issuers)
1440     public
1441     senderIsValid(_sender)
1442     validateBountyArrayIndex(_bountyId)
1443     validateIssuerArrayIndex(_bountyId, _issuerId)
1444     onlyIssuer(_sender, _bountyId, _issuerId)
1445   {
1446     for (uint i = 0; i < _issuers.length; i++){
1447       bounties[_bountyId].issuers.push(_issuers[i]);
1448     }
1449 
1450     emit BountyIssuersUpdated(_bountyId, _sender, bounties[_bountyId].issuers);
1451   }
1452 
1453   /// @dev replaceIssuers(): Allows any of the issuers to replace the issuers of the bounty
1454   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1455   /// @param _bountyId the index of the bounty
1456   /// @param _issuerId the index of the issuer who is calling the function
1457   /// @param _issuers the array of addresses to replace the list of valid issuers
1458   function replaceIssuers(
1459     address _sender,
1460     uint _bountyId,
1461     uint _issuerId,
1462     address payable [] memory _issuers)
1463     public
1464     senderIsValid(_sender)
1465     validateBountyArrayIndex(_bountyId)
1466     validateIssuerArrayIndex(_bountyId, _issuerId)
1467     onlyIssuer(_sender, _bountyId, _issuerId)
1468   {
1469     require(_issuers.length > 0 || bounties[_bountyId].approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck
1470 
1471     bounties[_bountyId].issuers = _issuers;
1472 
1473     emit BountyIssuersUpdated(_bountyId, _sender, bounties[_bountyId].issuers);
1474   }
1475 
1476   /// @dev addApprovers(): Allows any of the issuers to add more approvers to the bounty
1477   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1478   /// @param _bountyId the index of the bounty
1479   /// @param _issuerId the index of the issuer who is calling the function
1480   /// @param _approvers the array of addresses to add to the list of valid approvers
1481   function addApprovers(
1482     address _sender,
1483     uint _bountyId,
1484     uint _issuerId,
1485     address [] memory _approvers)
1486     public
1487     senderIsValid(_sender)
1488     validateBountyArrayIndex(_bountyId)
1489     validateIssuerArrayIndex(_bountyId, _issuerId)
1490     onlyIssuer(_sender, _bountyId, _issuerId)
1491   {
1492     for (uint i = 0; i < _approvers.length; i++){
1493       bounties[_bountyId].approvers.push(_approvers[i]);
1494     }
1495 
1496     emit BountyApproversUpdated(_bountyId, _sender, bounties[_bountyId].approvers);
1497   }
1498 
1499   /// @dev replaceApprovers(): Allows any of the issuers to replace the approvers of the bounty
1500   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1501   /// @param _bountyId the index of the bounty
1502   /// @param _issuerId the index of the issuer who is calling the function
1503   /// @param _approvers the array of addresses to replace the list of valid approvers
1504   function replaceApprovers(
1505     address _sender,
1506     uint _bountyId,
1507     uint _issuerId,
1508     address [] memory _approvers)
1509     public
1510     senderIsValid(_sender)
1511     validateBountyArrayIndex(_bountyId)
1512     validateIssuerArrayIndex(_bountyId, _issuerId)
1513     onlyIssuer(_sender, _bountyId, _issuerId)
1514   {
1515     require(bounties[_bountyId].issuers.length > 0 || _approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck
1516     bounties[_bountyId].approvers = _approvers;
1517 
1518     emit BountyApproversUpdated(_bountyId, _sender, bounties[_bountyId].approvers);
1519   }
1520 
1521   /// @dev getBounty(): Returns the details of the bounty
1522   /// @param _bountyId the index of the bounty
1523   /// @return Returns a tuple for the bounty
1524   function getBounty(uint _bountyId)
1525     external
1526     view
1527     returns (Bounty memory)
1528   {
1529     return bounties[_bountyId];
1530   }
1531 
1532 
1533   function transferTokens(uint _bountyId, address payable _to, uint _amount)
1534     internal
1535   {
1536     if (bounties[_bountyId].tokenVersion == 0){
1537       require(_amount > 0); // Sending 0 tokens should throw
1538       require(bounties[_bountyId].balance >= _amount);
1539 
1540       bounties[_bountyId].balance = bounties[_bountyId].balance.sub(_amount);
1541 
1542       _to.transfer(_amount);
1543     } else if (bounties[_bountyId].tokenVersion == 20) {
1544       require(_amount > 0); // Sending 0 tokens should throw
1545       require(bounties[_bountyId].balance >= _amount);
1546 
1547       bounties[_bountyId].balance = bounties[_bountyId].balance.sub(_amount);
1548 
1549       require(ERC20Token(bounties[_bountyId].token).transfer(_to, _amount));
1550     } else if (bounties[_bountyId].tokenVersion == 721) {
1551       require(tokenBalances[_bountyId][_amount]);
1552 
1553       tokenBalances[_bountyId][_amount] = false; // Removes the 721 token from the balance of the bounty
1554 
1555       ERC721BasicToken(bounties[_bountyId].token).transferFrom(address(this),
1556                                                                _to,
1557                                                                _amount);
1558     } else {
1559       revert();
1560     }
1561   }
1562 
1563   /*
1564    * Events
1565    */
1566 
1567   event BountyIssued(uint _bountyId, address payable _creator, address payable [] _issuers, address [] _approvers, string _data, uint _deadline, address _token, uint _tokenVersion);
1568   event ContributionAdded(uint _bountyId, uint _contributionId, address payable _contributor, uint _amount);
1569   event ContributionRefunded(uint _bountyId, uint _contributionId);
1570   event ContributionsRefunded(uint _bountyId, address _issuer, uint [] _contributionIds);
1571   event BountyDrained(uint _bountyId, address _issuer, uint [] _amounts);
1572   event ActionPerformed(uint _bountyId, address _fulfiller, string _data);
1573   event BountyFulfilled(uint _bountyId, uint _fulfillmentId, address payable [] _fulfillers, string _data, address _submitter);
1574   event FulfillmentUpdated(uint _bountyId, uint _fulfillmentId, address payable [] _fulfillers, string _data);
1575   event FulfillmentAccepted(uint _bountyId, uint  _fulfillmentId, address _approver, uint[] _tokenAmounts);
1576   event BountyChanged(uint _bountyId, address _changer, address payable [] _issuers, address payable [] _approvers, string _data, uint _deadline);
1577   event BountyIssuersUpdated(uint _bountyId, address _changer, address payable [] _issuers);
1578   event BountyApproversUpdated(uint _bountyId, address _changer, address [] _approvers);
1579   event BountyDataChanged(uint _bountyId, address _changer, string _data);
1580   event BountyDeadlineChanged(uint _bountyId, address _changer, uint _deadline);
1581 }