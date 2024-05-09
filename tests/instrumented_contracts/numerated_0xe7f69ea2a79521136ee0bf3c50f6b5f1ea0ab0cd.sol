1 pragma solidity 0.5.7;
2 pragma experimental ABIEncoderV2;
3 
4 
5 contract Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() pure returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) view public returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) public returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) public returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
45 
46     event Transfer(address _from, address _to, uint256 _value);
47     event Approval(address _owner, address _spender, uint256 _value);
48 }
49 
50 
51 contract ERC20Token is Token {
52 
53     function transfer(address _to, uint256 _value) public returns (bool success) {
54         //Default assumes totalSupply can't be over max (2^256 - 1).
55         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
56         //Replace the if with this one instead.
57         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
58         if (balances[msg.sender] >= _value && _value > 0) {
59             balances[msg.sender] -= _value;
60             balances[_to] += _value;
61             emit Transfer(msg.sender, _to, _value);
62             return true;
63         } else { return false; }
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
67         //same as above. Replace this line with the following if you want to protect against wrapping uints.
68         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
69         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
70             balances[_to] += _value;
71             balances[_from] -= _value;
72             allowed[_from][msg.sender] -= _value;
73             emit Transfer(_from, _to, _value);
74             return true;
75         } else { return false; }
76     }
77 
78     function balanceOf(address _owner) view public returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82     function approve(address _spender, uint256 _value) public returns (bool success) {
83         allowed[msg.sender][_spender] = _value;
84         emit Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
89       return allowed[_owner][_spender];
90     }
91 
92     mapping (address => uint256) balances;
93     mapping (address => mapping (address => uint256)) allowed;
94 }
95 
96 
97 
98 contract HumanStandardToken is ERC20Token {
99 
100     /* Public variables of the token */
101 
102     /*
103     NOTE:
104     The following variables are OPTIONAL vanities. One does not have to include them.
105     They allow one to customise the token contract & in no way influences the core functionality.
106     Some wallets/interfaces might not even bother to look at this information.
107     */
108     string public name;                   //fancy name: eg Simon Bucks
109     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
110     string public symbol;                 //An identifier: eg SBX
111     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
112 
113     constructor(
114         uint256 _initialAmount,
115         string memory _tokenName,
116         uint8 _decimalUnits,
117         string memory _tokenSymbol
118         ) public {
119         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
120         totalSupply = _initialAmount;                        // Update total supply
121         name = _tokenName;                                   // Set the name for display purposes
122         decimals = _decimalUnits;                            // Amount of decimals for display purposes
123         symbol = _tokenSymbol;                               // Set the symbol for display purposes
124     }
125     function transfer(address _to, uint256 _value) public returns (bool success) {
126         //Default assumes totalSupply can't be over max (2^256 - 1).
127         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
128         //Replace the if with this one instead.
129         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
130         if (balances[msg.sender] >= _value && _value > 0) {
131             balances[msg.sender] -= _value;
132             balances[_to] += _value;
133             emit Transfer(msg.sender, _to, _value);
134             return true;
135         } else { return false; }
136     }
137 
138     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
139         //same as above. Replace this line with the following if you want to protect against wrapping uints.
140         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
141         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
142             balances[_to] += _value;
143             balances[_from] -= _value;
144             allowed[_from][msg.sender] -= _value;
145             emit Transfer(_from, _to, _value);
146             return true;
147         } else { return false; }
148     }
149 
150     function balanceOf(address _owner) view public returns (uint256 balance) {
151         return balances[_owner];
152     }
153 
154     function approve(address _spender, uint256 _value) public returns (bool success) {
155         allowed[msg.sender][_spender] = _value;
156         emit Approval(msg.sender, _spender, _value);
157         return true;
158     }
159 
160     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
161       return allowed[_owner][_spender];
162     }
163 }
164 
165 /**
166  * @title SafeMath
167  * @dev Math operations with safety checks that throw on error
168  */
169 library SafeMath {
170 
171   /**
172   * @dev Multiplies two numbers, throws on overflow.
173   */
174   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
175     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
176     // benefit is lost if 'b' is also tested.
177     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
178     if (a == 0) {
179       return 0;
180     }
181 
182     c = a * b;
183     assert(c / a == b);
184     return c;
185   }
186 
187   /**
188   * @dev Integer division of two numbers, truncating the quotient.
189   */
190   function div(uint256 a, uint256 b) internal pure returns (uint256) {
191     // assert(b > 0); // Solidity automatically throws when dividing by 0
192     // uint256 c = a / b;
193     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194     return a / b;
195   }
196 
197   /**
198   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
199   */
200   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201     assert(b <= a);
202     return a - b;
203   }
204 
205   /**
206   * @dev Adds two numbers, throws on overflow.
207   */
208   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
209     c = a + b;
210     assert(c >= a);
211     return c;
212   }
213 }
214 
215 /**
216  * Utility library of inline functions on addresses
217  */
218 library AddressUtils {
219 
220   /**
221    * Returns whether the target address is a contract
222    * @dev This function will return false if invoked during the constructor of a contract,
223    * as the code is not actually created until after the constructor finishes.
224    * @param addr address to check
225    * @return whether the target address is a contract
226    */
227   function isContract(address addr) internal view returns (bool) {
228     uint256 size;
229     // XXX Currently there is no better way to check if there is a contract in an address
230     // than to check the size of the code at that address.
231     // See https://ethereum.stackexchange.com/a/14016/36603
232     // for more details about how this works.
233     // TODO Check this again before the Serenity release, because all addresses will be
234     // contracts then.
235     // solium-disable-next-line security/no-inline-assembly
236     assembly { size := extcodesize(addr) }
237     return size > 0;
238   }
239 
240 }
241 
242 /**
243  * @title ERC165
244  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
245  */
246 interface ERC165 {
247 
248   /**
249    * @notice Query if a contract implements an interface
250    * @param _interfaceId The interface identifier, as specified in ERC-165
251    * @dev Interface identification is specified in ERC-165. This function
252    * uses less than 30,000 gas.
253    */
254   function supportsInterface(bytes4 _interfaceId)
255     external
256     view
257     returns (bool);
258 }
259 
260 
261 /**
262  * @title SupportsInterfaceWithLookup
263  * @author Matt Condon (@shrugs)
264  * @dev Implements ERC165 using a lookup table.
265  */
266 contract SupportsInterfaceWithLookup is ERC165 {
267   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
268   /**
269    * 0x01ffc9a7 ===
270    *   bytes4(keccak256('supportsInterface(bytes4)'))
271    */
272 
273   /**
274    * @dev a mapping of interface id to whether or not it's supported
275    */
276   mapping(bytes4 => bool) internal supportedInterfaces;
277 
278   /**
279    * @dev A contract implementing SupportsInterfaceWithLookup
280    * implement ERC165 itself
281    */
282   constructor()
283     public
284   {
285     _registerInterface(InterfaceId_ERC165);
286   }
287 
288   /**
289    * @dev implement supportsInterface(bytes4) using a lookup table
290    */
291   function supportsInterface(bytes4 _interfaceId)
292     external
293     view
294     returns (bool)
295   {
296     return supportedInterfaces[_interfaceId];
297   }
298 
299   /**
300    * @dev private method for registering an interface
301    */
302   function _registerInterface(bytes4 _interfaceId)
303     internal
304   {
305     require(_interfaceId != 0xffffffff);
306     supportedInterfaces[_interfaceId] = true;
307   }
308 }
309 
310 /**
311  * @title ERC721 token receiver interface
312  * @dev Interface for any contract that wants to support safeTransfers
313  * from ERC721 asset contracts.
314  */
315 contract ERC721Receiver {
316   /**
317    * @dev Magic value to be returned upon successful reception of an NFT
318    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
319    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
320    */
321   bytes4 internal constant ERC721_RECEIVED = 0xf0b9e5ba;
322 
323   /**
324    * @notice Handle the receipt of an NFT
325    * @dev The ERC721 smart contract calls this function on the recipient
326    * after a `safetransfer`. This function MAY throw to revert and reject the
327    * transfer. This function MUST use 50,000 gas or less. Return of other
328    * than the magic value MUST result in the transaction being reverted.
329    * Note: the contract address is always the message sender.
330    * @param _from The sending address
331    * @param _tokenId The NFT identifier which is being transfered
332    * @param _data Additional data with no specified format
333    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
334    */
335   function onERC721Received(
336     address _from,
337     uint256 _tokenId,
338     bytes memory _data
339   )
340     public
341     returns(bytes4);
342 }
343 
344 /**
345  * @title ERC721 Non-Fungible Token Standard basic interface
346  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
347  */
348 contract ERC721Basic is ERC165 {
349   event Transfer(
350     address  _from,
351     address  _to,
352     uint256  _tokenId
353   );
354   event Approval(
355     address  _owner,
356     address  _approved,
357     uint256  _tokenId
358   );
359   event ApprovalForAll(
360     address  _owner,
361     address  _operator,
362     bool _approved
363   );
364 
365   function balanceOf(address _owner) public view returns (uint256 _balance);
366   function ownerOf(uint256 _tokenId) public view returns (address _owner);
367   function exists(uint256 _tokenId) public view returns (bool _exists);
368 
369   function approve(address _to, uint256 _tokenId) public;
370   function getApproved(uint256 _tokenId)
371     public view returns (address _operator);
372 
373   function setApprovalForAll(address _operator, bool _approved) public;
374   function isApprovedForAll(address _owner, address _operator)
375     public view returns (bool);
376 
377   function transferFrom(address _from, address _to, uint256 _tokenId) public;
378   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
379     public;
380 
381   function safeTransferFrom(
382     address _from,
383     address _to,
384     uint256 _tokenId,
385     bytes memory _data
386   )
387     public;
388 }
389 
390 /**
391  * @title ERC721 Non-Fungible Token Standard basic implementation
392  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
393  */
394 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
395 
396   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
397   /*
398    * 0x80ac58cd ===
399    *   bytes4(keccak256('balanceOf(address)')) ^
400    *   bytes4(keccak256('ownerOf(uint256)')) ^
401    *   bytes4(keccak256('approve(address,uint256)')) ^
402    *   bytes4(keccak256('getApproved(uint256)')) ^
403    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
404    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
405    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
406    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
407    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
408    */
409 
410   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
411   /*
412    * 0x4f558e79 ===
413    *   bytes4(keccak256('exists(uint256)'))
414    */
415 
416   using SafeMath for uint256;
417   using AddressUtils for address;
418 
419   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
420   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
421   bytes4 private constant ERC721_RECEIVED = 0xf0b9e5ba;
422 
423   // Mapping from token ID to owner
424   mapping (uint256 => address) internal tokenOwner;
425 
426   // Mapping from token ID to approved address
427   mapping (uint256 => address) internal tokenApprovals;
428 
429   // Mapping from owner to number of owned token
430   mapping (address => uint256) internal ownedTokensCount;
431 
432   // Mapping from owner to operator approvals
433   mapping (address => mapping (address => bool)) internal operatorApprovals;
434 
435 
436   uint public testint;
437   /**
438    * @dev Guarantees msg.sender is owner of the given token
439    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
440    */
441   modifier onlyOwnerOf(uint256 _tokenId) {
442     require(ownerOf(_tokenId) == msg.sender);
443     _;
444   }
445 
446   /**
447    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
448    * @param _tokenId uint256 ID of the token to validate
449    */
450   modifier canTransfer(uint256 _tokenId) {
451     require(isApprovedOrOwner(msg.sender, _tokenId));
452     _;
453   }
454 
455   constructor()
456     public
457   {
458     // register the supported interfaces to conform to ERC721 via ERC165
459     _registerInterface(InterfaceId_ERC721);
460     _registerInterface(InterfaceId_ERC721Exists);
461   }
462 
463   /**
464    * @dev Gets the balance of the specified address
465    * @param _owner address to query the balance of
466    * @return uint256 representing the amount owned by the passed address
467    */
468   function balanceOf(address _owner) public view returns (uint256) {
469     require(_owner != address(0));
470     return ownedTokensCount[_owner];
471   }
472 
473   /**
474    * @dev Gets the owner of the specified token ID
475    * @param _tokenId uint256 ID of the token to query the owner of
476    * @return owner address currently marked as the owner of the given token ID
477    */
478   function ownerOf(uint256 _tokenId) public view returns (address) {
479     address owner = tokenOwner[_tokenId];
480     require(owner != address(0));
481     return owner;
482   }
483 
484   /**
485    * @dev Returns whether the specified token exists
486    * @param _tokenId uint256 ID of the token to query the existence of
487    * @return whether the token exists
488    */
489   function exists(uint256 _tokenId) public view returns (bool) {
490     address owner = tokenOwner[_tokenId];
491     return owner != address(0);
492   }
493 
494   /**
495    * @dev Approves another address to transfer the given token ID
496    * The zero address indicates there is no approved address.
497    * There can only be one approved address per token at a given time.
498    * Can only be called by the token owner or an approved operator.
499    * @param _to address to be approved for the given token ID
500    * @param _tokenId uint256 ID of the token to be approved
501    */
502   function approve(address _to, uint256 _tokenId) public {
503     address owner = ownerOf(_tokenId);
504     require(_to != owner);
505     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
506 
507     tokenApprovals[_tokenId] = _to;
508     emit Approval(owner, _to, _tokenId);
509   }
510 
511   /**
512    * @dev Gets the approved address for a token ID, or zero if no address set
513    * @param _tokenId uint256 ID of the token to query the approval of
514    * @return address currently approved for the given token ID
515    */
516   function getApproved(uint256 _tokenId) public view returns (address) {
517     return tokenApprovals[_tokenId];
518   }
519 
520   /**
521    * @dev Sets or unsets the approval of a given operator
522    * An operator is allowed to transfer all tokens of the sender on their behalf
523    * @param _to operator address to set the approval
524    * @param _approved representing the status of the approval to be set
525    */
526   function setApprovalForAll(address _to, bool _approved) public {
527     require(_to != msg.sender);
528     operatorApprovals[msg.sender][_to] = _approved;
529     emit ApprovalForAll(msg.sender, _to, _approved);
530   }
531 
532   /**
533    * @dev Tells whether an operator is approved by a given owner
534    * @param _owner owner address which you want to query the approval of
535    * @param _operator operator address which you want to query the approval of
536    * @return bool whether the given operator is approved by the given owner
537    */
538   function isApprovedForAll(
539     address _owner,
540     address _operator
541   )
542     public
543     view
544     returns (bool)
545   {
546     return operatorApprovals[_owner][_operator];
547   }
548 
549   /**
550    * @dev Transfers the ownership of a given token ID to another address
551    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
552    * Requires the msg sender to be the owner, approved, or operator
553    * @param _from current owner of the token
554    * @param _to address to receive the ownership of the given token ID
555    * @param _tokenId uint256 ID of the token to be transferred
556   */
557   function transferFrom(
558     address _from,
559     address _to,
560     uint256 _tokenId
561   )
562     public
563     canTransfer(_tokenId)
564   {
565     require(_from != address(0));
566     require(_to != address(0));
567 
568     clearApproval(_from, _tokenId);
569     removeTokenFrom(_from, _tokenId);
570     addTokenTo(_to, _tokenId);
571 
572     emit Transfer(_from, _to, _tokenId);
573   }
574 
575   /**
576    * @dev Safely transfers the ownership of a given token ID to another address
577    * If the target address is a contract, it must implement `onERC721Received`,
578    * which is called upon a safe transfer, and return the magic value
579    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
580    * the transfer is reverted.
581    *
582    * Requires the msg sender to be the owner, approved, or operator
583    * @param _from current owner of the token
584    * @param _to address to receive the ownership of the given token ID
585    * @param _tokenId uint256 ID of the token to be transferred
586   */
587   function safeTransferFrom(
588     address _from,
589     address _to,
590     uint256 _tokenId
591   )
592     public
593     canTransfer(_tokenId)
594   {
595     // solium-disable-next-line arg-overflow
596     safeTransferFrom(_from, _to, _tokenId, "");
597   }
598 
599   /**
600    * @dev Safely transfers the ownership of a given token ID to another address
601    * If the target address is a contract, it must implement `onERC721Received`,
602    * which is called upon a safe transfer, and return the magic value
603    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
604    * the transfer is reverted.
605    * Requires the msg sender to be the owner, approved, or operator
606    * @param _from current owner of the token
607    * @param _to address to receive the ownership of the given token ID
608    * @param _tokenId uint256 ID of the token to be transferred
609    * @param _data bytes data to send along with a safe transfer check
610    */
611   function safeTransferFrom(
612     address _from,
613     address _to,
614     uint256 _tokenId,
615     bytes memory _data
616   )
617     public
618     canTransfer(_tokenId)
619   {
620     transferFrom(_from, _to, _tokenId);
621     // solium-disable-next-line arg-overflow
622     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
623   }
624 
625   /**
626    * @dev Returns whether the given spender can transfer a given token ID
627    * @param _spender address of the spender to query
628    * @param _tokenId uint256 ID of the token to be transferred
629    * @return bool whether the msg.sender is approved for the given token ID,
630    *  is an operator of the owner, or is the owner of the token
631    */
632   function isApprovedOrOwner(
633     address _spender,
634     uint256 _tokenId
635   )
636     internal
637     view
638     returns (bool)
639   {
640     address owner = ownerOf(_tokenId);
641     // Disable solium check because of
642     // https://github.com/duaraghav8/Solium/issues/175
643     // solium-disable-next-line operator-whitespace
644     return (
645       _spender == owner ||
646       getApproved(_tokenId) == _spender ||
647       isApprovedForAll(owner, _spender)
648     );
649   }
650 
651   /**
652    * @dev Internal function to mint a new token
653    * Reverts if the given token ID already exists
654    * @param _to The address that will own the minted token
655    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
656    */
657   function _mint(address _to, uint256 _tokenId) internal {
658     require(_to != address(0));
659     addTokenTo(_to, _tokenId);
660     emit Transfer(address(0), _to, _tokenId);
661   }
662 
663   /**
664    * @dev Internal function to burn a specific token
665    * Reverts if the token does not exist
666    * @param _tokenId uint256 ID of the token being burned by the msg.sender
667    */
668   function _burn(address _owner, uint256 _tokenId) internal {
669     clearApproval(_owner, _tokenId);
670     removeTokenFrom(_owner, _tokenId);
671     emit Transfer(_owner, address(0), _tokenId);
672   }
673 
674   /**
675    * @dev Internal function to clear current approval of a given token ID
676    * Reverts if the given address is not indeed the owner of the token
677    * @param _owner owner of the token
678    * @param _tokenId uint256 ID of the token to be transferred
679    */
680   function clearApproval(address _owner, uint256 _tokenId) internal {
681     require(ownerOf(_tokenId) == _owner);
682     if (tokenApprovals[_tokenId] != address(0)) {
683       tokenApprovals[_tokenId] = address(0);
684     }
685   }
686 
687   /**
688    * @dev Internal function to add a token ID to the list of a given address
689    * @param _to address representing the new owner of the given token ID
690    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
691    */
692   function addTokenTo(address _to, uint256 _tokenId) internal {
693     require(tokenOwner[_tokenId] == address(0));
694     tokenOwner[_tokenId] = _to;
695     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
696   }
697 
698   /**
699    * @dev Internal function to remove a token ID from the list of a given address
700    * @param _from address representing the previous owner of the given token ID
701    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
702    */
703   function removeTokenFrom(address _from, uint256 _tokenId) internal {
704     require(ownerOf(_tokenId) == _from);
705     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
706     tokenOwner[_tokenId] = address(0);
707   }
708 
709   /**
710    * @dev Internal function to invoke `onERC721Received` on a target address
711    * The call is not executed if the target address is not a contract
712    * @param _from address representing the previous owner of the given token ID
713    * @param _to target address that will receive the tokens
714    * @param _tokenId uint256 ID of the token to be transferred
715    * @param _data bytes optional data to send along with the call
716    * @return whether the call correctly returned the expected magic value
717    */
718   function checkAndCallSafeTransfer(
719     address _from,
720     address _to,
721     uint256 _tokenId,
722     bytes memory _data
723   )
724     internal
725     returns (bool)
726   {
727     if (!_to.isContract()) {
728       return true;
729     }
730     bytes4 retval = ERC721Receiver(_to).onERC721Received(
731       _from, _tokenId, _data);
732     return (retval == ERC721_RECEIVED);
733   }
734 }
735 
736 contract ERC721BasicTokenMock is ERC721BasicToken {
737   function mint(address _to, uint256 _tokenId) public {
738     super._mint(_to, _tokenId);
739   }
740 
741   function burn(uint256 _tokenId) public {
742     super._burn(ownerOf(_tokenId), _tokenId);
743   }
744 }
745 
746 contract StandardBounties {
747 
748   using SafeMath for uint256;
749 
750   /*
751    * Structs
752    */
753 
754   struct Bounty {
755     address payable [] issuers; // An array of individuals who have complete control over the bounty, and can edit any of its parameters
756     address [] approvers; // An array of individuals who are allowed to accept the fulfillments for a particular bounty
757     uint deadline; // The Unix timestamp before which all submissions must be made, and after which refunds may be processed
758     address token; // The address of the token associated with the bounty (should be disregarded if the tokenVersion is 0)
759     uint tokenVersion; // The version of the token being used for the bounty (0 for ETH, 20 for ERC20, 721 for ERC721)
760     uint balance; // The number of tokens which the bounty is able to pay out or refund
761     bool hasPaidOut; // A boolean storing whether or not the bounty has paid out at least once, meaning refunds are no longer allowed
762     Fulfillment [] fulfillments; // An array of Fulfillments which store the various submissions which have been made to the bounty
763     Contribution [] contributions; // An array of Contributions which store the contributions which have been made to the bounty
764   }
765 
766   struct Fulfillment {
767     address payable [] fulfillers; // An array of addresses who should receive payouts for a given submission
768     address submitter; // The address of the individual who submitted the fulfillment, who is able to update the submission as needed
769   }
770 
771   struct Contribution {
772     address payable contributor; // The address of the individual who contributed
773     uint amount; // The amount of tokens the user contributed
774     bool refunded; // A boolean storing whether or not the contribution has been refunded yet
775   }
776 
777   /*
778    * Storage
779    */
780 
781   uint public numBounties; // An integer storing the total number of bounties in the contract
782   mapping(uint => Bounty) public bounties; // A mapping of bountyIDs to bounties
783   mapping (uint => mapping (uint => bool)) public tokenBalances; // A mapping of bountyIds to tokenIds to booleans, storing whether a given bounty has a given ERC721 token in its balance
784 
785 
786   address public owner; // The address of the individual who's allowed to set the metaTxRelayer address
787   address public metaTxRelayer; // The address of the meta transaction relayer whose _sender is automatically trusted for all contract calls
788 
789   bool public callStarted; // Ensures mutex for the entire contract
790 
791   /*
792    * Modifiers
793    */
794 
795   modifier callNotStarted(){
796     require(!callStarted);
797     callStarted = true;
798     _;
799     callStarted = false;
800   }
801 
802   modifier validateBountyArrayIndex(
803     uint _index)
804   {
805     require(_index < numBounties);
806     _;
807   }
808 
809   modifier validateContributionArrayIndex(
810     uint _bountyId,
811     uint _index)
812   {
813     require(_index < bounties[_bountyId].contributions.length);
814     _;
815   }
816 
817   modifier validateFulfillmentArrayIndex(
818     uint _bountyId,
819     uint _index)
820   {
821     require(_index < bounties[_bountyId].fulfillments.length);
822     _;
823   }
824 
825   modifier validateIssuerArrayIndex(
826     uint _bountyId,
827     uint _index)
828   {
829     require(_index < bounties[_bountyId].issuers.length);
830     _;
831   }
832 
833   modifier validateApproverArrayIndex(
834     uint _bountyId,
835     uint _index)
836   {
837     require(_index < bounties[_bountyId].approvers.length);
838     _;
839   }
840 
841   modifier onlyIssuer(
842   address _sender,
843   uint _bountyId,
844   uint _issuerId)
845   {
846   require(_sender == bounties[_bountyId].issuers[_issuerId]);
847   _;
848   }
849 
850   modifier onlySubmitter(
851     address _sender,
852     uint _bountyId,
853     uint _fulfillmentId)
854   {
855     require(_sender ==
856             bounties[_bountyId].fulfillments[_fulfillmentId].submitter);
857     _;
858   }
859 
860   modifier onlyContributor(
861   address _sender,
862   uint _bountyId,
863   uint _contributionId)
864   {
865     require(_sender ==
866             bounties[_bountyId].contributions[_contributionId].contributor);
867     _;
868   }
869 
870   modifier isApprover(
871     address _sender,
872     uint _bountyId,
873     uint _approverId)
874   {
875     require(_sender == bounties[_bountyId].approvers[_approverId]);
876     _;
877   }
878 
879   modifier hasNotPaid(
880     uint _bountyId)
881   {
882     require(!bounties[_bountyId].hasPaidOut);
883     _;
884   }
885 
886   modifier hasNotRefunded(
887     uint _bountyId,
888     uint _contributionId)
889   {
890     require(!bounties[_bountyId].contributions[_contributionId].refunded);
891     _;
892   }
893 
894   modifier senderIsValid(
895     address _sender)
896   {
897     require(msg.sender == _sender || msg.sender == metaTxRelayer);
898     _;
899   }
900 
901  /*
902   * Public functions
903   */
904 
905   constructor() public {
906     // The owner of the contract is automatically designated to be the deployer of the contract
907     owner = msg.sender;
908   }
909 
910   /// @dev setMetaTxRelayer(): Sets the address of the meta transaction relayer
911   /// @param _relayer the address of the relayer
912   function setMetaTxRelayer(address _relayer)
913     external
914   {
915     require(msg.sender == owner); // Checks that only the owner can call
916     require(metaTxRelayer == address(0)); // Ensures the meta tx relayer can only be set once
917     metaTxRelayer = _relayer;
918   }
919 
920   /// @dev issueBounty(): creates a new bounty
921   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
922   /// @param _issuers the array of addresses who will be the issuers of the bounty
923   /// @param _approvers the array of addresses who will be the approvers of the bounty
924   /// @param _data the IPFS hash representing the JSON object storing the details of the bounty (see docs for schema details)
925   /// @param _deadline the timestamp which will become the deadline of the bounty
926   /// @param _token the address of the token which will be used for the bounty
927   /// @param _tokenVersion the version of the token being used for the bounty (0 for ETH, 20 for ERC20, 721 for ERC721)
928   function issueBounty(
929     address payable _sender,
930     address payable [] memory _issuers,
931     address [] memory _approvers,
932     string memory _data,
933     uint _deadline,
934     address _token,
935     uint _tokenVersion)
936     public
937     senderIsValid(_sender)
938     returns (uint)
939   {
940     require(_tokenVersion == 0 || _tokenVersion == 20 || _tokenVersion == 721); // Ensures a bounty can only be issued with a valid token version
941     require(_issuers.length > 0 || _approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck
942 
943     uint bountyId = numBounties; // The next bounty's index will always equal the number of existing bounties
944 
945     Bounty storage newBounty = bounties[bountyId];
946     newBounty.issuers = _issuers;
947     newBounty.approvers = _approvers;
948     newBounty.deadline = _deadline;
949     newBounty.tokenVersion = _tokenVersion;
950 
951     if (_tokenVersion != 0) {
952       newBounty.token = _token;
953     }
954 
955     numBounties = numBounties.add(1); // Increments the number of bounties, since a new one has just been added
956 
957     emit BountyIssued(bountyId,
958                       _sender,
959                       _issuers,
960                       _approvers,
961                       _data, // Instead of storing the string on-chain, it is emitted within the event for easy off-chain consumption
962                       _deadline,
963                       _token,
964                       _tokenVersion);
965 
966     return (bountyId);
967   }
968 
969   /// @param _depositAmount the amount of tokens being deposited to the bounty, which will create a new contribution to the bounty
970 
971 
972   function issueAndContribute(
973     address payable _sender,
974     address payable [] memory _issuers,
975     address [] memory _approvers,
976     string memory _data,
977     uint _deadline,
978     address _token,
979     uint _tokenVersion,
980     uint _depositAmount)
981     public
982     payable
983     returns(uint)
984   {
985     uint bountyId = issueBounty(_sender, _issuers, _approvers, _data, _deadline, _token, _tokenVersion);
986 
987     contribute(_sender, bountyId, _depositAmount);
988   }
989 
990 
991   /// @dev contribute(): Allows users to contribute tokens to a given bounty.
992   ///                    Contributing merits no privelages to administer the
993   ///                    funds in the bounty or accept submissions. Contributions
994   ///                    are refundable but only on the condition that the deadline
995   ///                    has elapsed, and the bounty has not yet paid out any funds.
996   ///                    All funds deposited in a bounty are at the mercy of a
997   ///                    bounty's issuers and approvers, so please be careful!
998   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
999   /// @param _bountyId the index of the bounty
1000   /// @param _amount the amount of tokens being contributed
1001   function contribute(
1002     address payable _sender,
1003     uint _bountyId,
1004     uint _amount)
1005     public
1006     payable
1007     senderIsValid(_sender)
1008     validateBountyArrayIndex(_bountyId)
1009     callNotStarted
1010   {
1011     require(_amount > 0); // Contributions of 0 tokens or token ID 0 should fail
1012 
1013     bounties[_bountyId].contributions.push(
1014       Contribution(_sender, _amount, false)); // Adds the contribution to the bounty
1015 
1016     if (bounties[_bountyId].tokenVersion == 0){
1017 
1018       bounties[_bountyId].balance = bounties[_bountyId].balance.add(_amount); // Increments the balance of the bounty
1019 
1020       require(msg.value == _amount);
1021     } else if (bounties[_bountyId].tokenVersion == 20) {
1022 
1023       bounties[_bountyId].balance = bounties[_bountyId].balance.add(_amount); // Increments the balance of the bounty
1024 
1025       require(msg.value == 0); // Ensures users don't accidentally send ETH alongside a token contribution, locking up funds
1026       require(ERC20Token(bounties[_bountyId].token).transferFrom(_sender,
1027                                                                  address(this),
1028                                                                  _amount));
1029     } else if (bounties[_bountyId].tokenVersion == 721) {
1030       tokenBalances[_bountyId][_amount] = true; // Adds the 721 token to the balance of the bounty
1031 
1032 
1033       require(msg.value == 0); // Ensures users don't accidentally send ETH alongside a token contribution, locking up funds
1034       ERC721BasicToken(bounties[_bountyId].token).transferFrom(_sender,
1035                                                                address(this),
1036                                                                _amount);
1037     } else {
1038       revert();
1039     }
1040 
1041     emit ContributionAdded(_bountyId,
1042                            bounties[_bountyId].contributions.length - 1, // The new contributionId
1043                            _sender,
1044                            _amount);
1045   }
1046 
1047   /// @dev refundContribution(): Allows users to refund the contributions they've
1048   ///                            made to a particular bounty, but only if the bounty
1049   ///                            has not yet paid out, and the deadline has elapsed.
1050   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1051   /// @param _bountyId the index of the bounty
1052   /// @param _contributionId the index of the contribution being refunded
1053   function refundContribution(
1054     address _sender,
1055     uint _bountyId,
1056     uint _contributionId)
1057     public
1058     senderIsValid(_sender)
1059     validateBountyArrayIndex(_bountyId)
1060     validateContributionArrayIndex(_bountyId, _contributionId)
1061     onlyContributor(_sender, _bountyId, _contributionId)
1062     hasNotPaid(_bountyId)
1063     hasNotRefunded(_bountyId, _contributionId)
1064     callNotStarted
1065   {
1066     require(now > bounties[_bountyId].deadline); // Refunds may only be processed after the deadline has elapsed
1067 
1068     Contribution storage contribution =
1069       bounties[_bountyId].contributions[_contributionId];
1070 
1071     contribution.refunded = true;
1072 
1073     transferTokens(_bountyId, contribution.contributor, contribution.amount); // Performs the disbursal of tokens to the contributor
1074 
1075     emit ContributionRefunded(_bountyId, _contributionId);
1076   }
1077 
1078   /// @dev refundMyContributions(): Allows users to refund their contributions in bulk
1079   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1080   /// @param _bountyId the index of the bounty
1081   /// @param _contributionIds the array of indexes of the contributions being refunded
1082   function refundMyContributions(
1083     address _sender,
1084     uint _bountyId,
1085     uint [] memory _contributionIds)
1086     public
1087     senderIsValid(_sender)
1088   {
1089     for (uint i = 0; i < _contributionIds.length; i++){
1090       refundContribution(_sender, _bountyId, _contributionIds[i]);
1091     }
1092   }
1093 
1094   /// @dev refundContributions(): Allows users to refund their contributions in bulk
1095   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1096   /// @param _bountyId the index of the bounty
1097   /// @param _issuerId the index of the issuer who is making the call
1098   /// @param _contributionIds the array of indexes of the contributions being refunded
1099   function refundContributions(
1100     address _sender,
1101     uint _bountyId,
1102     uint _issuerId,
1103     uint [] memory _contributionIds)
1104     public
1105     senderIsValid(_sender)
1106     validateBountyArrayIndex(_bountyId)
1107     onlyIssuer(_sender, _bountyId, _issuerId)
1108     callNotStarted
1109   {
1110     for (uint i = 0; i < _contributionIds.length; i++){
1111       require(_contributionIds[i] <= bounties[_bountyId].contributions.length);
1112 
1113       Contribution storage contribution =
1114         bounties[_bountyId].contributions[_contributionIds[i]];
1115 
1116       require(!contribution.refunded);
1117 
1118       transferTokens(_bountyId, contribution.contributor, contribution.amount); // Performs the disbursal of tokens to the contributor
1119     }
1120 
1121     emit ContributionsRefunded(_bountyId, _sender, _contributionIds);
1122   }
1123 
1124   /// @dev drainBounty(): Allows an issuer to drain the funds from the bounty
1125   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1126   /// @param _bountyId the index of the bounty
1127   /// @param _issuerId the index of the issuer who is making the call
1128   /// @param _amounts an array of amounts of tokens to be sent. The length of the array should be 1 if the bounty is in ETH or ERC20 tokens. If it's an ERC721 bounty, the array should be the list of tokenIDs.
1129   function drainBounty(
1130     address payable _sender,
1131     uint _bountyId,
1132     uint _issuerId,
1133     uint [] memory _amounts)
1134     public
1135     senderIsValid(_sender)
1136     validateBountyArrayIndex(_bountyId)
1137     onlyIssuer(_sender, _bountyId, _issuerId)
1138     callNotStarted
1139   {
1140     if (bounties[_bountyId].tokenVersion == 0 || bounties[_bountyId].tokenVersion == 20){
1141       require(_amounts.length == 1); // ensures there's only 1 amount of tokens to be returned
1142       require(_amounts[0] <= bounties[_bountyId].balance); // ensures an issuer doesn't try to drain the bounty of more tokens than their balance permits
1143       transferTokens(_bountyId, _sender, _amounts[0]); // Performs the draining of tokens to the issuer
1144     } else {
1145       for (uint i = 0; i < _amounts.length; i++){
1146         require(tokenBalances[_bountyId][_amounts[i]]);// ensures an issuer doesn't try to drain the bounty of a token it doesn't have in its balance
1147         transferTokens(_bountyId, _sender, _amounts[i]);
1148       }
1149     }
1150 
1151     emit BountyDrained(_bountyId, _sender, _amounts);
1152   }
1153 
1154   /// @dev performAction(): Allows users to perform any generalized action
1155   ///                       associated with a particular bounty, such as applying for it
1156   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1157   /// @param _bountyId the index of the bounty
1158   /// @param _data the IPFS hash corresponding to a JSON object which contains the details of the action being performed (see docs for schema details)
1159   function performAction(
1160     address _sender,
1161     uint _bountyId,
1162     string memory _data)
1163     public
1164     senderIsValid(_sender)
1165     validateBountyArrayIndex(_bountyId)
1166   {
1167     emit ActionPerformed(_bountyId, _sender, _data); // The _data string is emitted in an event for easy off-chain consumption
1168   }
1169 
1170   /// @dev fulfillBounty(): Allows users to fulfill the bounty to get paid out
1171   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1172   /// @param _bountyId the index of the bounty
1173   /// @param _fulfillers the array of addresses which will receive payouts for the submission
1174   /// @param _data the IPFS hash corresponding to a JSON object which contains the details of the submission (see docs for schema details)
1175   function fulfillBounty(
1176     address _sender,
1177     uint _bountyId,
1178     address payable [] memory  _fulfillers,
1179     string memory _data)
1180     public
1181     senderIsValid(_sender)
1182     validateBountyArrayIndex(_bountyId)
1183   {
1184     require(now < bounties[_bountyId].deadline); // Submissions are only allowed to be made before the deadline
1185     require(_fulfillers.length > 0); // Submissions with no fulfillers would mean no one gets paid out
1186 
1187     bounties[_bountyId].fulfillments.push(Fulfillment(_fulfillers, _sender));
1188 
1189     emit BountyFulfilled(_bountyId,
1190                          (bounties[_bountyId].fulfillments.length - 1),
1191                          _fulfillers,
1192                          _data, // The _data string is emitted in an event for easy off-chain consumption
1193                          _sender);
1194   }
1195 
1196   /// @dev updateFulfillment(): Allows the submitter of a fulfillment to update their submission
1197   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1198   /// @param _bountyId the index of the bounty
1199   /// @param _fulfillmentId the index of the fulfillment
1200   /// @param _fulfillers the new array of addresses which will receive payouts for the submission
1201   /// @param _data the new IPFS hash corresponding to a JSON object which contains the details of the submission (see docs for schema details)
1202   function updateFulfillment(
1203   address _sender,
1204   uint _bountyId,
1205   uint _fulfillmentId,
1206   address payable [] memory _fulfillers,
1207   string memory _data)
1208   public
1209   senderIsValid(_sender)
1210   validateBountyArrayIndex(_bountyId)
1211   validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)
1212   onlySubmitter(_sender, _bountyId, _fulfillmentId) // Only the original submitter of a fulfillment may update their submission
1213   {
1214     bounties[_bountyId].fulfillments[_fulfillmentId].fulfillers = _fulfillers;
1215     emit FulfillmentUpdated(_bountyId,
1216                             _fulfillmentId,
1217                             _fulfillers,
1218                             _data); // The _data string is emitted in an event for easy off-chain consumption
1219   }
1220 
1221   /// @dev acceptFulfillment(): Allows any of the approvers to accept a given submission
1222   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1223   /// @param _bountyId the index of the bounty
1224   /// @param _fulfillmentId the index of the fulfillment to be accepted
1225   /// @param _approverId the index of the approver which is making the call
1226   /// @param _tokenAmounts the array of token amounts which will be paid to the
1227   ///                      fulfillers, whose length should equal the length of the
1228   ///                      _fulfillers array of the submission. If the bounty pays
1229   ///                      in ERC721 tokens, then these should be the token IDs
1230   ///                      being sent to each of the individual fulfillers
1231   function acceptFulfillment(
1232     address _sender,
1233     uint _bountyId,
1234     uint _fulfillmentId,
1235     uint _approverId,
1236     uint[] memory _tokenAmounts)
1237     public
1238     senderIsValid(_sender)
1239     validateBountyArrayIndex(_bountyId)
1240     validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)
1241     isApprover(_sender, _bountyId, _approverId)
1242     callNotStarted
1243   {
1244     // now that the bounty has paid out at least once, refunds are no longer possible
1245     bounties[_bountyId].hasPaidOut = true;
1246 
1247     Fulfillment storage fulfillment =
1248       bounties[_bountyId].fulfillments[_fulfillmentId];
1249 
1250     require(_tokenAmounts.length == fulfillment.fulfillers.length); // Each fulfiller should get paid some amount of tokens (this can be 0)
1251 
1252     for (uint256 i = 0; i < fulfillment.fulfillers.length; i++){
1253         if (_tokenAmounts[i] > 0) {
1254           // for each fulfiller associated with the submission
1255           transferTokens(_bountyId, fulfillment.fulfillers[i], _tokenAmounts[i]);
1256         }
1257     }
1258     emit FulfillmentAccepted(_bountyId,
1259                              _fulfillmentId,
1260                              _sender,
1261                              _tokenAmounts);
1262   }
1263 
1264   /// @dev fulfillAndAccept(): Allows any of the approvers to fulfill and accept a submission simultaneously
1265   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1266   /// @param _bountyId the index of the bounty
1267   /// @param _fulfillers the array of addresses which will receive payouts for the submission
1268   /// @param _data the IPFS hash corresponding to a JSON object which contains the details of the submission (see docs for schema details)
1269   /// @param _approverId the index of the approver which is making the call
1270   /// @param _tokenAmounts the array of token amounts which will be paid to the
1271   ///                      fulfillers, whose length should equal the length of the
1272   ///                      _fulfillers array of the submission. If the bounty pays
1273   ///                      in ERC721 tokens, then these should be the token IDs
1274   ///                      being sent to each of the individual fulfillers
1275   function fulfillAndAccept(
1276     address _sender,
1277     uint _bountyId,
1278     address payable [] memory _fulfillers,
1279     string memory _data,
1280     uint _approverId,
1281     uint[] memory _tokenAmounts)
1282     public
1283     senderIsValid(_sender)
1284   {
1285     // first fulfills the bounty on behalf of the fulfillers
1286     fulfillBounty(_sender, _bountyId, _fulfillers, _data);
1287 
1288     // then accepts the fulfillment
1289     acceptFulfillment(_sender,
1290                       _bountyId,
1291                       bounties[_bountyId].fulfillments.length - 1,
1292                       _approverId,
1293                       _tokenAmounts);
1294   }
1295 
1296 
1297 
1298   /// @dev changeBounty(): Allows any of the issuers to change the bounty
1299   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1300   /// @param _bountyId the index of the bounty
1301   /// @param _issuerId the index of the issuer who is calling the function
1302   /// @param _issuers the new array of addresses who will be the issuers of the bounty
1303   /// @param _approvers the new array of addresses who will be the approvers of the bounty
1304   /// @param _data the new IPFS hash representing the JSON object storing the details of the bounty (see docs for schema details)
1305   /// @param _deadline the new timestamp which will become the deadline of the bounty
1306   function changeBounty(
1307     address _sender,
1308     uint _bountyId,
1309     uint _issuerId,
1310     address payable [] memory _issuers,
1311     address payable [] memory _approvers,
1312     string memory _data,
1313     uint _deadline)
1314     public
1315     senderIsValid(_sender)
1316   {
1317     require(_bountyId < numBounties); // makes the validateBountyArrayIndex modifier in-line to avoid stack too deep errors
1318     require(_issuerId < bounties[_bountyId].issuers.length); // makes the validateIssuerArrayIndex modifier in-line to avoid stack too deep errors
1319     require(_sender == bounties[_bountyId].issuers[_issuerId]); // makes the onlyIssuer modifier in-line to avoid stack too deep errors
1320 
1321     require(_issuers.length > 0 || _approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck
1322 
1323     bounties[_bountyId].issuers = _issuers;
1324     bounties[_bountyId].approvers = _approvers;
1325     bounties[_bountyId].deadline = _deadline;
1326     emit BountyChanged(_bountyId,
1327                        _sender,
1328                        _issuers,
1329                        _approvers,
1330                        _data,
1331                        _deadline);
1332   }
1333 
1334   /// @dev changeIssuer(): Allows any of the issuers to change a particular issuer of the bounty
1335   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1336   /// @param _bountyId the index of the bounty
1337   /// @param _issuerId the index of the issuer who is calling the function
1338   /// @param _issuerIdToChange the index of the issuer who is being changed
1339   /// @param _newIssuer the address of the new issuer
1340   function changeIssuer(
1341     address _sender,
1342     uint _bountyId,
1343     uint _issuerId,
1344     uint _issuerIdToChange,
1345     address payable _newIssuer)
1346     public
1347     senderIsValid(_sender)
1348     validateBountyArrayIndex(_bountyId)
1349     validateIssuerArrayIndex(_bountyId, _issuerIdToChange)
1350     onlyIssuer(_sender, _bountyId, _issuerId)
1351   {
1352     require(_issuerId < bounties[_bountyId].issuers.length || _issuerId == 0);
1353 
1354     bounties[_bountyId].issuers[_issuerIdToChange] = _newIssuer;
1355 
1356     emit BountyIssuersUpdated(_bountyId, _sender, bounties[_bountyId].issuers);
1357   }
1358 
1359   /// @dev changeApprover(): Allows any of the issuers to change a particular approver of the bounty
1360   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1361   /// @param _bountyId the index of the bounty
1362   /// @param _issuerId the index of the issuer who is calling the function
1363   /// @param _approverId the index of the approver who is being changed
1364   /// @param _approver the address of the new approver
1365   function changeApprover(
1366     address _sender,
1367     uint _bountyId,
1368     uint _issuerId,
1369     uint _approverId,
1370     address payable _approver)
1371     external
1372     senderIsValid(_sender)
1373     validateBountyArrayIndex(_bountyId)
1374     onlyIssuer(_sender, _bountyId, _issuerId)
1375     validateApproverArrayIndex(_bountyId, _approverId)
1376   {
1377     bounties[_bountyId].approvers[_approverId] = _approver;
1378 
1379     emit BountyApproversUpdated(_bountyId, _sender, bounties[_bountyId].approvers);
1380   }
1381 
1382   /// @dev changeData(): Allows any of the issuers to change the data the bounty
1383   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1384   /// @param _bountyId the index of the bounty
1385   /// @param _issuerId the index of the issuer who is calling the function
1386   /// @param _data the new IPFS hash representing the JSON object storing the details of the bounty (see docs for schema details)
1387   function changeData(
1388     address _sender,
1389     uint _bountyId,
1390     uint _issuerId,
1391     string memory _data)
1392     public
1393     senderIsValid(_sender)
1394     validateBountyArrayIndex(_bountyId)
1395     validateIssuerArrayIndex(_bountyId, _issuerId)
1396     onlyIssuer(_sender, _bountyId, _issuerId)
1397   {
1398     emit BountyDataChanged(_bountyId, _sender, _data); // The new _data is emitted within an event rather than being stored on-chain for minimized gas costs
1399   }
1400 
1401   /// @dev changeDeadline(): Allows any of the issuers to change the deadline the bounty
1402   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1403   /// @param _bountyId the index of the bounty
1404   /// @param _issuerId the index of the issuer who is calling the function
1405   /// @param _deadline the new timestamp which will become the deadline of the bounty
1406   function changeDeadline(
1407     address _sender,
1408     uint _bountyId,
1409     uint _issuerId,
1410     uint _deadline)
1411     external
1412     senderIsValid(_sender)
1413     validateBountyArrayIndex(_bountyId)
1414     validateIssuerArrayIndex(_bountyId, _issuerId)
1415     onlyIssuer(_sender, _bountyId, _issuerId)
1416   {
1417     bounties[_bountyId].deadline = _deadline;
1418 
1419     emit BountyDeadlineChanged(_bountyId, _sender, _deadline);
1420   }
1421 
1422   /// @dev addIssuers(): Allows any of the issuers to add more issuers to the bounty
1423   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1424   /// @param _bountyId the index of the bounty
1425   /// @param _issuerId the index of the issuer who is calling the function
1426   /// @param _issuers the array of addresses to add to the list of valid issuers
1427   function addIssuers(
1428     address _sender,
1429     uint _bountyId,
1430     uint _issuerId,
1431     address payable [] memory _issuers)
1432     public
1433     senderIsValid(_sender)
1434     validateBountyArrayIndex(_bountyId)
1435     validateIssuerArrayIndex(_bountyId, _issuerId)
1436     onlyIssuer(_sender, _bountyId, _issuerId)
1437   {
1438     for (uint i = 0; i < _issuers.length; i++){
1439       bounties[_bountyId].issuers.push(_issuers[i]);
1440     }
1441 
1442     emit BountyIssuersUpdated(_bountyId, _sender, bounties[_bountyId].issuers);
1443   }
1444 
1445   /// @dev replaceIssuers(): Allows any of the issuers to replace the issuers of the bounty
1446   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1447   /// @param _bountyId the index of the bounty
1448   /// @param _issuerId the index of the issuer who is calling the function
1449   /// @param _issuers the array of addresses to replace the list of valid issuers
1450   function replaceIssuers(
1451     address _sender,
1452     uint _bountyId,
1453     uint _issuerId,
1454     address payable [] memory _issuers)
1455     public
1456     senderIsValid(_sender)
1457     validateBountyArrayIndex(_bountyId)
1458     validateIssuerArrayIndex(_bountyId, _issuerId)
1459     onlyIssuer(_sender, _bountyId, _issuerId)
1460   {
1461     require(_issuers.length > 0 || bounties[_bountyId].approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck
1462 
1463     bounties[_bountyId].issuers = _issuers;
1464 
1465     emit BountyIssuersUpdated(_bountyId, _sender, bounties[_bountyId].issuers);
1466   }
1467 
1468   /// @dev addApprovers(): Allows any of the issuers to add more approvers to the bounty
1469   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1470   /// @param _bountyId the index of the bounty
1471   /// @param _issuerId the index of the issuer who is calling the function
1472   /// @param _approvers the array of addresses to add to the list of valid approvers
1473   function addApprovers(
1474     address _sender,
1475     uint _bountyId,
1476     uint _issuerId,
1477     address [] memory _approvers)
1478     public
1479     senderIsValid(_sender)
1480     validateBountyArrayIndex(_bountyId)
1481     validateIssuerArrayIndex(_bountyId, _issuerId)
1482     onlyIssuer(_sender, _bountyId, _issuerId)
1483   {
1484     for (uint i = 0; i < _approvers.length; i++){
1485       bounties[_bountyId].approvers.push(_approvers[i]);
1486     }
1487 
1488     emit BountyApproversUpdated(_bountyId, _sender, bounties[_bountyId].approvers);
1489   }
1490 
1491   /// @dev replaceApprovers(): Allows any of the issuers to replace the approvers of the bounty
1492   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1493   /// @param _bountyId the index of the bounty
1494   /// @param _issuerId the index of the issuer who is calling the function
1495   /// @param _approvers the array of addresses to replace the list of valid approvers
1496   function replaceApprovers(
1497     address _sender,
1498     uint _bountyId,
1499     uint _issuerId,
1500     address [] memory _approvers)
1501     public
1502     senderIsValid(_sender)
1503     validateBountyArrayIndex(_bountyId)
1504     validateIssuerArrayIndex(_bountyId, _issuerId)
1505     onlyIssuer(_sender, _bountyId, _issuerId)
1506   {
1507     require(bounties[_bountyId].issuers.length > 0 || _approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck
1508     bounties[_bountyId].approvers = _approvers;
1509 
1510     emit BountyApproversUpdated(_bountyId, _sender, bounties[_bountyId].approvers);
1511   }
1512 
1513   /// @dev getBounty(): Returns the details of the bounty
1514   /// @param _bountyId the index of the bounty
1515   /// @return Returns a tuple for the bounty
1516   function getBounty(uint _bountyId)
1517     external
1518     view
1519     returns (Bounty memory)
1520   {
1521     return bounties[_bountyId];
1522   }
1523 
1524 
1525   function transferTokens(uint _bountyId, address payable _to, uint _amount)
1526     internal
1527   {
1528     if (bounties[_bountyId].tokenVersion == 0){
1529       require(_amount > 0); // Sending 0 tokens should throw
1530       require(bounties[_bountyId].balance >= _amount);
1531 
1532       bounties[_bountyId].balance = bounties[_bountyId].balance.sub(_amount);
1533 
1534       _to.transfer(_amount);
1535     } else if (bounties[_bountyId].tokenVersion == 20) {
1536       require(_amount > 0); // Sending 0 tokens should throw
1537       require(bounties[_bountyId].balance >= _amount);
1538 
1539       bounties[_bountyId].balance = bounties[_bountyId].balance.sub(_amount);
1540 
1541       require(ERC20Token(bounties[_bountyId].token).transfer(_to, _amount));
1542     } else if (bounties[_bountyId].tokenVersion == 721) {
1543       require(tokenBalances[_bountyId][_amount]);
1544 
1545       tokenBalances[_bountyId][_amount] = false; // Removes the 721 token from the balance of the bounty
1546 
1547       ERC721BasicToken(bounties[_bountyId].token).transferFrom(address(this),
1548                                                                _to,
1549                                                                _amount);
1550     } else {
1551       revert();
1552     }
1553   }
1554 
1555   /*
1556    * Events
1557    */
1558 
1559   event BountyIssued(uint _bountyId, address payable _creator, address payable [] _issuers, address [] _approvers, string _data, uint _deadline, address _token, uint _tokenVersion);
1560   event ContributionAdded(uint _bountyId, uint _contributionId, address payable _contributor, uint _amount);
1561   event ContributionRefunded(uint _bountyId, uint _contributionId);
1562   event ContributionsRefunded(uint _bountyId, address _issuer, uint [] _contributionIds);
1563   event BountyDrained(uint _bountyId, address _issuer, uint [] _amounts);
1564   event ActionPerformed(uint _bountyId, address _fulfiller, string _data);
1565   event BountyFulfilled(uint _bountyId, uint _fulfillmentId, address payable [] _fulfillers, string _data, address _submitter);
1566   event FulfillmentUpdated(uint _bountyId, uint _fulfillmentId, address payable [] _fulfillers, string _data);
1567   event FulfillmentAccepted(uint _bountyId, uint  _fulfillmentId, address _approver, uint[] _tokenAmounts);
1568   event BountyChanged(uint _bountyId, address _changer, address payable [] _issuers, address payable [] _approvers, string _data, uint _deadline);
1569   event BountyIssuersUpdated(uint _bountyId, address _changer, address payable [] _issuers);
1570   event BountyApproversUpdated(uint _bountyId, address _changer, address [] _approvers);
1571   event BountyDataChanged(uint _bountyId, address _changer, string _data);
1572   event BountyDeadlineChanged(uint _bountyId, address _changer, uint _deadline);
1573 }