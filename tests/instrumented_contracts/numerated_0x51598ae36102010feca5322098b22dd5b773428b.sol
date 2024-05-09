1 pragma solidity 0.5.12;
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
49 contract ERC20Token is Token {
50 
51     function transfer(address _to, uint256 _value) public returns (bool success) {
52         //Default assumes totalSupply can't be over max (2^256 - 1).
53         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
54         //Replace the if with this one instead.
55         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
56         if (balances[msg.sender] >= _value && _value > 0) {
57             balances[msg.sender] -= _value;
58             balances[_to] += _value;
59             emit Transfer(msg.sender, _to, _value);
60             return true;
61         } else { return false; }
62     }
63 
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
65         //same as above. Replace this line with the following if you want to protect against wrapping uints.
66         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
67         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
68             balances[_to] += _value;
69             balances[_from] -= _value;
70             allowed[_from][msg.sender] -= _value;
71             emit Transfer(_from, _to, _value);
72             return true;
73         } else { return false; }
74     }
75 
76     function balanceOf(address _owner) view public returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80     function approve(address _spender, uint256 _value) public returns (bool success) {
81         allowed[msg.sender][_spender] = _value;
82         emit Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
87       return allowed[_owner][_spender];
88     }
89 
90     mapping (address => uint256) balances;
91     mapping (address => mapping (address => uint256)) allowed;
92 }
93 
94 library SafeMath {
95 
96   /**
97   * @dev Multiplies two numbers, throws on overflow.
98   */
99   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
100     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
101     // benefit is lost if 'b' is also tested.
102     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
103     if (a == 0) {
104       return 0;
105     }
106 
107     c = a * b;
108     assert(c / a == b);
109     return c;
110   }
111 
112   /**
113   * @dev Integer division of two numbers, truncating the quotient.
114   */
115   function div(uint256 a, uint256 b) internal pure returns (uint256) {
116     // assert(b > 0); // Solidity automatically throws when dividing by 0
117     // uint256 c = a / b;
118     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119     return a / b;
120   }
121 
122   /**
123   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
124   */
125   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126     assert(b <= a);
127     return a - b;
128   }
129 
130   /**
131   * @dev Adds two numbers, throws on overflow.
132   */
133   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
134     c = a + b;
135     assert(c >= a);
136     return c;
137   }
138 }
139 
140 /**
141  * Utility library of inline functions on addresses
142  */
143 library AddressUtils {
144 
145   /**
146    * Returns whether the target address is a contract
147    * @dev This function will return false if invoked during the constructor of a contract,
148    * as the code is not actually created until after the constructor finishes.
149    * @param addr address to check
150    * @return whether the target address is a contract
151    */
152   function isContract(address addr) internal view returns (bool) {
153     uint256 size;
154     // XXX Currently there is no better way to check if there is a contract in an address
155     // than to check the size of the code at that address.
156     // See https://ethereum.stackexchange.com/a/14016/36603
157     // for more details about how this works.
158     // TODO Check this again before the Serenity release, because all addresses will be
159     // contracts then.
160     // solium-disable-next-line security/no-inline-assembly
161     assembly { size := extcodesize(addr) }
162     return size > 0;
163   }
164 
165 }
166 
167 /**
168  * @title ERC165
169  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
170  */
171 interface ERC165 {
172 
173   /**
174    * @notice Query if a contract implements an interface
175    * @param _interfaceId The interface identifier, as specified in ERC-165
176    * @dev Interface identification is specified in ERC-165. This function
177    * uses less than 30,000 gas.
178    */
179   function supportsInterface(bytes4 _interfaceId)
180     external
181     view
182     returns (bool);
183 }
184 
185 
186 /**
187  * @title SupportsInterfaceWithLookup
188  * @author Matt Condon (@shrugs)
189  * @dev Implements ERC165 using a lookup table.
190  */
191 contract SupportsInterfaceWithLookup is ERC165 {
192   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
193   /**
194    * 0x01ffc9a7 ===
195    *   bytes4(keccak256('supportsInterface(bytes4)'))
196    */
197 
198   /**
199    * @dev a mapping of interface id to whether or not it's supported
200    */
201   mapping(bytes4 => bool) internal supportedInterfaces;
202 
203   /**
204    * @dev A contract implementing SupportsInterfaceWithLookup
205    * implement ERC165 itself
206    */
207   constructor()
208     public
209   {
210     _registerInterface(InterfaceId_ERC165);
211   }
212 
213   /**
214    * @dev implement supportsInterface(bytes4) using a lookup table
215    */
216   function supportsInterface(bytes4 _interfaceId)
217     external
218     view
219     returns (bool)
220   {
221     return supportedInterfaces[_interfaceId];
222   }
223 
224   /**
225    * @dev private method for registering an interface
226    */
227   function _registerInterface(bytes4 _interfaceId)
228     internal
229   {
230     require(_interfaceId != 0xffffffff);
231     supportedInterfaces[_interfaceId] = true;
232   }
233 }
234 
235 /**
236  * @title ERC721 token receiver interface
237  * @dev Interface for any contract that wants to support safeTransfers
238  * from ERC721 asset contracts.
239  */
240 contract ERC721Receiver {
241   /**
242    * @dev Magic value to be returned upon successful reception of an NFT
243    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
244    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
245    */
246   bytes4 internal constant ERC721_RECEIVED = 0xf0b9e5ba;
247 
248   /**
249    * @notice Handle the receipt of an NFT
250    * @dev The ERC721 smart contract calls this function on the recipient
251    * after a `safetransfer`. This function MAY throw to revert and reject the
252    * transfer. This function MUST use 50,000 gas or less. Return of other
253    * than the magic value MUST result in the transaction being reverted.
254    * Note: the contract address is always the message sender.
255    * @param _from The sending address
256    * @param _tokenId The NFT identifier which is being transfered
257    * @param _data Additional data with no specified format
258    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
259    */
260   function onERC721Received(
261     address _from,
262     uint256 _tokenId,
263     bytes memory _data
264   )
265     public
266     returns(bytes4);
267 }
268 
269 /**
270  * @title ERC721 Non-Fungible Token Standard basic interface
271  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
272  */
273 contract ERC721Basic is ERC165 {
274   event Transfer(
275     address  _from,
276     address  _to,
277     uint256  _tokenId
278   );
279   event Approval(
280     address  _owner,
281     address  _approved,
282     uint256  _tokenId
283   );
284   event ApprovalForAll(
285     address  _owner,
286     address  _operator,
287     bool _approved
288   );
289 
290   function balanceOf(address _owner) public view returns (uint256 _balance);
291   function ownerOf(uint256 _tokenId) public view returns (address _owner);
292   function exists(uint256 _tokenId) public view returns (bool _exists);
293 
294   function approve(address _to, uint256 _tokenId) public;
295   function getApproved(uint256 _tokenId)
296     public view returns (address _operator);
297 
298   function setApprovalForAll(address _operator, bool _approved) public;
299   function isApprovedForAll(address _owner, address _operator)
300     public view returns (bool);
301 
302   function transferFrom(address _from, address _to, uint256 _tokenId) public;
303   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
304     public;
305 
306   function safeTransferFrom(
307     address _from,
308     address _to,
309     uint256 _tokenId,
310     bytes memory _data
311   )
312     public;
313 }
314 
315 /**
316  * @title ERC721 Non-Fungible Token Standard basic implementation
317  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
318  */
319 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
320 
321   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
322   /*
323    * 0x80ac58cd ===
324    *   bytes4(keccak256('balanceOf(address)')) ^
325    *   bytes4(keccak256('ownerOf(uint256)')) ^
326    *   bytes4(keccak256('approve(address,uint256)')) ^
327    *   bytes4(keccak256('getApproved(uint256)')) ^
328    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
329    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
330    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
331    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
332    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
333    */
334 
335   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
336   /*
337    * 0x4f558e79 ===
338    *   bytes4(keccak256('exists(uint256)'))
339    */
340 
341   using SafeMath for uint256;
342   using AddressUtils for address;
343 
344   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
345   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
346   bytes4 private constant ERC721_RECEIVED = 0xf0b9e5ba;
347 
348   // Mapping from token ID to owner
349   mapping (uint256 => address) internal tokenOwner;
350 
351   // Mapping from token ID to approved address
352   mapping (uint256 => address) internal tokenApprovals;
353 
354   // Mapping from owner to number of owned token
355   mapping (address => uint256) internal ownedTokensCount;
356 
357   // Mapping from owner to operator approvals
358   mapping (address => mapping (address => bool)) internal operatorApprovals;
359 
360 
361   uint public testint;
362   /**
363    * @dev Guarantees msg.sender is owner of the given token
364    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
365    */
366   modifier onlyOwnerOf(uint256 _tokenId) {
367     require(ownerOf(_tokenId) == msg.sender);
368     _;
369   }
370 
371   /**
372    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
373    * @param _tokenId uint256 ID of the token to validate
374    */
375   modifier canTransfer(uint256 _tokenId) {
376     require(isApprovedOrOwner(msg.sender, _tokenId));
377     _;
378   }
379 
380   constructor()
381     public
382   {
383     // register the supported interfaces to conform to ERC721 via ERC165
384     _registerInterface(InterfaceId_ERC721);
385     _registerInterface(InterfaceId_ERC721Exists);
386   }
387 
388   /**
389    * @dev Gets the balance of the specified address
390    * @param _owner address to query the balance of
391    * @return uint256 representing the amount owned by the passed address
392    */
393   function balanceOf(address _owner) public view returns (uint256) {
394     require(_owner != address(0));
395     return ownedTokensCount[_owner];
396   }
397 
398   /**
399    * @dev Gets the owner of the specified token ID
400    * @param _tokenId uint256 ID of the token to query the owner of
401    * @return owner address currently marked as the owner of the given token ID
402    */
403   function ownerOf(uint256 _tokenId) public view returns (address) {
404     address owner = tokenOwner[_tokenId];
405     require(owner != address(0));
406     return owner;
407   }
408 
409   /**
410    * @dev Returns whether the specified token exists
411    * @param _tokenId uint256 ID of the token to query the existence of
412    * @return whether the token exists
413    */
414   function exists(uint256 _tokenId) public view returns (bool) {
415     address owner = tokenOwner[_tokenId];
416     return owner != address(0);
417   }
418 
419   /**
420    * @dev Approves another address to transfer the given token ID
421    * The zero address indicates there is no approved address.
422    * There can only be one approved address per token at a given time.
423    * Can only be called by the token owner or an approved operator.
424    * @param _to address to be approved for the given token ID
425    * @param _tokenId uint256 ID of the token to be approved
426    */
427   function approve(address _to, uint256 _tokenId) public {
428     address owner = ownerOf(_tokenId);
429     require(_to != owner);
430     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
431 
432     tokenApprovals[_tokenId] = _to;
433     emit Approval(owner, _to, _tokenId);
434   }
435 
436   /**
437    * @dev Gets the approved address for a token ID, or zero if no address set
438    * @param _tokenId uint256 ID of the token to query the approval of
439    * @return address currently approved for the given token ID
440    */
441   function getApproved(uint256 _tokenId) public view returns (address) {
442     return tokenApprovals[_tokenId];
443   }
444 
445   /**
446    * @dev Sets or unsets the approval of a given operator
447    * An operator is allowed to transfer all tokens of the sender on their behalf
448    * @param _to operator address to set the approval
449    * @param _approved representing the status of the approval to be set
450    */
451   function setApprovalForAll(address _to, bool _approved) public {
452     require(_to != msg.sender);
453     operatorApprovals[msg.sender][_to] = _approved;
454     emit ApprovalForAll(msg.sender, _to, _approved);
455   }
456 
457   /**
458    * @dev Tells whether an operator is approved by a given owner
459    * @param _owner owner address which you want to query the approval of
460    * @param _operator operator address which you want to query the approval of
461    * @return bool whether the given operator is approved by the given owner
462    */
463   function isApprovedForAll(
464     address _owner,
465     address _operator
466   )
467     public
468     view
469     returns (bool)
470   {
471     return operatorApprovals[_owner][_operator];
472   }
473 
474   /**
475    * @dev Transfers the ownership of a given token ID to another address
476    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
477    * Requires the msg sender to be the owner, approved, or operator
478    * @param _from current owner of the token
479    * @param _to address to receive the ownership of the given token ID
480    * @param _tokenId uint256 ID of the token to be transferred
481   */
482   function transferFrom(
483     address _from,
484     address _to,
485     uint256 _tokenId
486   )
487     public
488     canTransfer(_tokenId)
489   {
490     require(_from != address(0));
491     require(_to != address(0));
492 
493     clearApproval(_from, _tokenId);
494     removeTokenFrom(_from, _tokenId);
495     addTokenTo(_to, _tokenId);
496 
497     emit Transfer(_from, _to, _tokenId);
498   }
499 
500   /**
501    * @dev Safely transfers the ownership of a given token ID to another address
502    * If the target address is a contract, it must implement `onERC721Received`,
503    * which is called upon a safe transfer, and return the magic value
504    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
505    * the transfer is reverted.
506    *
507    * Requires the msg sender to be the owner, approved, or operator
508    * @param _from current owner of the token
509    * @param _to address to receive the ownership of the given token ID
510    * @param _tokenId uint256 ID of the token to be transferred
511   */
512   function safeTransferFrom(
513     address _from,
514     address _to,
515     uint256 _tokenId
516   )
517     public
518     canTransfer(_tokenId)
519   {
520     // solium-disable-next-line arg-overflow
521     safeTransferFrom(_from, _to, _tokenId, "");
522   }
523 
524   /**
525    * @dev Safely transfers the ownership of a given token ID to another address
526    * If the target address is a contract, it must implement `onERC721Received`,
527    * which is called upon a safe transfer, and return the magic value
528    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
529    * the transfer is reverted.
530    * Requires the msg sender to be the owner, approved, or operator
531    * @param _from current owner of the token
532    * @param _to address to receive the ownership of the given token ID
533    * @param _tokenId uint256 ID of the token to be transferred
534    * @param _data bytes data to send along with a safe transfer check
535    */
536   function safeTransferFrom(
537     address _from,
538     address _to,
539     uint256 _tokenId,
540     bytes memory _data
541   )
542     public
543     canTransfer(_tokenId)
544   {
545     transferFrom(_from, _to, _tokenId);
546     // solium-disable-next-line arg-overflow
547     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
548   }
549 
550   /**
551    * @dev Returns whether the given spender can transfer a given token ID
552    * @param _spender address of the spender to query
553    * @param _tokenId uint256 ID of the token to be transferred
554    * @return bool whether the msg.sender is approved for the given token ID,
555    *  is an operator of the owner, or is the owner of the token
556    */
557   function isApprovedOrOwner(
558     address _spender,
559     uint256 _tokenId
560   )
561     internal
562     view
563     returns (bool)
564   {
565     address owner = ownerOf(_tokenId);
566     // Disable solium check because of
567     // https://github.com/duaraghav8/Solium/issues/175
568     // solium-disable-next-line operator-whitespace
569     return (
570       _spender == owner ||
571       getApproved(_tokenId) == _spender ||
572       isApprovedForAll(owner, _spender)
573     );
574   }
575 
576   /**
577    * @dev Internal function to mint a new token
578    * Reverts if the given token ID already exists
579    * @param _to The address that will own the minted token
580    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
581    */
582   function _mint(address _to, uint256 _tokenId) internal {
583     require(_to != address(0));
584     addTokenTo(_to, _tokenId);
585     emit Transfer(address(0), _to, _tokenId);
586   }
587 
588   /**
589    * @dev Internal function to burn a specific token
590    * Reverts if the token does not exist
591    * @param _tokenId uint256 ID of the token being burned by the msg.sender
592    */
593   function _burn(address _owner, uint256 _tokenId) internal {
594     clearApproval(_owner, _tokenId);
595     removeTokenFrom(_owner, _tokenId);
596     emit Transfer(_owner, address(0), _tokenId);
597   }
598 
599   /**
600    * @dev Internal function to clear current approval of a given token ID
601    * Reverts if the given address is not indeed the owner of the token
602    * @param _owner owner of the token
603    * @param _tokenId uint256 ID of the token to be transferred
604    */
605   function clearApproval(address _owner, uint256 _tokenId) internal {
606     require(ownerOf(_tokenId) == _owner);
607     if (tokenApprovals[_tokenId] != address(0)) {
608       tokenApprovals[_tokenId] = address(0);
609     }
610   }
611 
612   /**
613    * @dev Internal function to add a token ID to the list of a given address
614    * @param _to address representing the new owner of the given token ID
615    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
616    */
617   function addTokenTo(address _to, uint256 _tokenId) internal {
618     require(tokenOwner[_tokenId] == address(0));
619     tokenOwner[_tokenId] = _to;
620     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
621   }
622 
623   /**
624    * @dev Internal function to remove a token ID from the list of a given address
625    * @param _from address representing the previous owner of the given token ID
626    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
627    */
628   function removeTokenFrom(address _from, uint256 _tokenId) internal {
629     require(ownerOf(_tokenId) == _from);
630     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
631     tokenOwner[_tokenId] = address(0);
632   }
633 
634   /**
635    * @dev Internal function to invoke `onERC721Received` on a target address
636    * The call is not executed if the target address is not a contract
637    * @param _from address representing the previous owner of the given token ID
638    * @param _to target address that will receive the tokens
639    * @param _tokenId uint256 ID of the token to be transferred
640    * @param _data bytes optional data to send along with the call
641    * @return whether the call correctly returned the expected magic value
642    */
643   function checkAndCallSafeTransfer(
644     address _from,
645     address _to,
646     uint256 _tokenId,
647     bytes memory _data
648   )
649     internal
650     returns (bool)
651   {
652     if (!_to.isContract()) {
653       return true;
654     }
655     bytes4 retval = ERC721Receiver(_to).onERC721Received(
656       _from, _tokenId, _data);
657     return (retval == ERC721_RECEIVED);
658   }
659 }
660 
661 contract ERC721BasicTokenMock is ERC721BasicToken {
662   function mint(address _to, uint256 _tokenId) public {
663     super._mint(_to, _tokenId);
664   }
665 
666   function burn(uint256 _tokenId) public {
667     super._burn(ownerOf(_tokenId), _tokenId);
668   }
669 }
670 
671 contract StandardBounties {
672 
673   using SafeMath for uint256;
674 
675   /*
676    * Structs
677    */
678 
679   struct Bounty {
680     address payable[] issuers; // An array of individuals who have complete control over the bounty, and can edit any of its parameters
681     address[] approvers; // An array of individuals who are allowed to accept the fulfillments for a particular bounty
682     uint deadline; // The Unix timestamp before which all submissions must be made, and after which refunds may be processed
683     address token; // The address of the token associated with the bounty (should be disregarded if the tokenVersion is 0)
684     uint tokenVersion; // The version of the token being used for the bounty (0 for ETH, 20 for ERC20, 721 for ERC721)
685     uint balance; // The number of tokens which the bounty is able to pay out or refund
686     bool hasPaidOut; // A boolean storing whether or not the bounty has paid out at least once, meaning refunds are no longer allowed
687     Fulfillment[] fulfillments; // An array of Fulfillments which store the various submissions which have been made to the bounty
688     Contribution[] contributions; // An array of Contributions which store the contributions which have been made to the bounty
689   }
690 
691   struct Fulfillment {
692     address payable[] fulfillers; // An array of addresses who should receive payouts for a given submission
693     address submitter; // The address of the individual who submitted the fulfillment, who is able to update the submission as needed
694   }
695 
696   struct Contribution {
697     address payable contributor; // The address of the individual who contributed
698     uint amount; // The amount of tokens the user contributed
699     bool refunded; // A boolean storing whether or not the contribution has been refunded yet
700   }
701 
702   /*
703    * Storage
704    */
705 
706   uint public numBounties; // An integer storing the total number of bounties in the contract
707   mapping(uint => Bounty) public bounties; // A mapping of bountyIDs to bounties
708   mapping (uint => mapping (uint => bool)) public tokenBalances; // A mapping of bountyIds to tokenIds to booleans, storing whether a given bounty has a given ERC721 token in its balance
709 
710 
711   address public owner; // The address of the individual who's allowed to set the metaTxRelayer address
712   address public metaTxRelayer; // The address of the meta transaction relayer whose _sender is automatically trusted for all contract calls
713 
714   bool public callStarted; // Ensures mutex for the entire contract
715 
716   /*
717    * Modifiers
718    */
719 
720   modifier callNotStarted(){
721     require(!callStarted);
722     callStarted = true;
723     _;
724     callStarted = false;
725   }
726 
727   modifier validateBountyArrayIndex(
728     uint _index)
729   {
730     require(_index < numBounties);
731     _;
732   }
733 
734   modifier validateContributionArrayIndex(
735     uint _bountyId,
736     uint _index)
737   {
738     require(_index < bounties[_bountyId].contributions.length);
739     _;
740   }
741 
742   modifier validateFulfillmentArrayIndex(
743     uint _bountyId,
744     uint _index)
745   {
746     require(_index < bounties[_bountyId].fulfillments.length);
747     _;
748   }
749 
750   modifier validateIssuerArrayIndex(
751     uint _bountyId,
752     uint _index)
753   {
754     require(_index < bounties[_bountyId].issuers.length);
755     _;
756   }
757 
758   modifier validateApproverArrayIndex(
759     uint _bountyId,
760     uint _index)
761   {
762     require(_index < bounties[_bountyId].approvers.length);
763     _;
764   }
765 
766   modifier onlyIssuer(
767   address _sender,
768   uint _bountyId,
769   uint _issuerId)
770   {
771   require(_sender == bounties[_bountyId].issuers[_issuerId]);
772   _;
773   }
774 
775   modifier onlySubmitter(
776     address _sender,
777     uint _bountyId,
778     uint _fulfillmentId)
779   {
780     require(_sender ==
781             bounties[_bountyId].fulfillments[_fulfillmentId].submitter);
782     _;
783   }
784 
785   modifier onlyContributor(
786   address _sender,
787   uint _bountyId,
788   uint _contributionId)
789   {
790     require(_sender ==
791             bounties[_bountyId].contributions[_contributionId].contributor);
792     _;
793   }
794 
795   modifier isApprover(
796     address _sender,
797     uint _bountyId,
798     uint _approverId)
799   {
800     require(_sender == bounties[_bountyId].approvers[_approverId]);
801     _;
802   }
803 
804   modifier hasNotPaid(
805     uint _bountyId)
806   {
807     require(!bounties[_bountyId].hasPaidOut);
808     _;
809   }
810 
811   modifier hasNotRefunded(
812     uint _bountyId,
813     uint _contributionId)
814   {
815     require(!bounties[_bountyId].contributions[_contributionId].refunded);
816     _;
817   }
818 
819   modifier senderIsValid(
820     address _sender)
821   {
822     require(msg.sender == _sender || msg.sender == metaTxRelayer);
823     _;
824   }
825 
826  /*
827   * Public functions
828   */
829 
830   constructor() public {
831     // The owner of the contract is automatically designated to be the deployer of the contract
832     owner = msg.sender;
833   }
834 
835   /// @dev setMetaTxRelayer(): Sets the address of the meta transaction relayer
836   /// @param _relayer the address of the relayer
837   function setMetaTxRelayer(address _relayer)
838     external
839   {
840     require(msg.sender == owner); // Checks that only the owner can call
841     require(metaTxRelayer == address(0)); // Ensures the meta tx relayer can only be set once
842     metaTxRelayer = _relayer;
843   }
844 
845   /// @dev issueBounty(): creates a new bounty
846   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
847   /// @param _issuers the array of addresses who will be the issuers of the bounty
848   /// @param _approvers the array of addresses who will be the approvers of the bounty
849   /// @param _data the IPFS hash representing the JSON object storing the details of the bounty (see docs for schema details)
850   /// @param _deadline the timestamp which will become the deadline of the bounty
851   /// @param _token the address of the token which will be used for the bounty
852   /// @param _tokenVersion the version of the token being used for the bounty (0 for ETH, 20 for ERC20, 721 for ERC721)
853   function issueBounty(
854     address payable _sender,
855     address payable[] memory _issuers,
856     address[] memory _approvers,
857     string memory _data,
858     uint _deadline,
859     address _token,
860     uint _tokenVersion)
861     public
862     senderIsValid(_sender)
863     returns (uint)
864   {
865     require(_tokenVersion == 0 || _tokenVersion == 20 || _tokenVersion == 721); // Ensures a bounty can only be issued with a valid token version
866     require(_issuers.length > 0 || _approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck
867 
868     uint bountyId = numBounties; // The next bounty's index will always equal the number of existing bounties
869 
870     Bounty storage newBounty = bounties[bountyId];
871     newBounty.issuers = _issuers;
872     newBounty.approvers = _approvers;
873     newBounty.deadline = _deadline;
874     newBounty.tokenVersion = _tokenVersion;
875 
876     if (_tokenVersion != 0){
877       newBounty.token = _token;
878     }
879 
880     numBounties = numBounties.add(1); // Increments the number of bounties, since a new one has just been added
881 
882     emit BountyIssued(bountyId,
883                       _sender,
884                       _issuers,
885                       _approvers,
886                       _data, // Instead of storing the string on-chain, it is emitted within the event for easy off-chain consumption
887                       _deadline,
888                       _token,
889                       _tokenVersion);
890 
891     return (bountyId);
892   }
893 
894   /// @param _depositAmount the amount of tokens being deposited to the bounty, which will create a new contribution to the bounty
895 
896 
897   function issueAndContribute(
898     address payable _sender,
899     address payable[] memory _issuers,
900     address[] memory _approvers,
901     string memory _data,
902     uint _deadline,
903     address _token,
904     uint _tokenVersion,
905     uint _depositAmount)
906     public
907     payable
908     returns(uint)
909   {
910     uint bountyId = issueBounty(_sender, _issuers, _approvers, _data, _deadline, _token, _tokenVersion);
911 
912     contribute(_sender, bountyId, _depositAmount);
913 
914     return (bountyId);
915   }
916 
917 
918   /// @dev contribute(): Allows users to contribute tokens to a given bounty.
919   ///                    Contributing merits no privelages to administer the
920   ///                    funds in the bounty or accept submissions. Contributions
921   ///                    are refundable but only on the condition that the deadline
922   ///                    has elapsed, and the bounty has not yet paid out any funds.
923   ///                    All funds deposited in a bounty are at the mercy of a
924   ///                    bounty's issuers and approvers, so please be careful!
925   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
926   /// @param _bountyId the index of the bounty
927   /// @param _amount the amount of tokens being contributed
928   function contribute(
929     address payable _sender,
930     uint _bountyId,
931     uint _amount)
932     public
933     payable
934     senderIsValid(_sender)
935     validateBountyArrayIndex(_bountyId)
936     callNotStarted
937   {
938     require(_amount > 0); // Contributions of 0 tokens or token ID 0 should fail
939 
940     bounties[_bountyId].contributions.push(
941       Contribution(_sender, _amount, false)); // Adds the contribution to the bounty
942 
943     if (bounties[_bountyId].tokenVersion == 0){
944 
945       bounties[_bountyId].balance = bounties[_bountyId].balance.add(_amount); // Increments the balance of the bounty
946 
947       require(msg.value == _amount);
948     } else if (bounties[_bountyId].tokenVersion == 20){
949 
950       bounties[_bountyId].balance = bounties[_bountyId].balance.add(_amount); // Increments the balance of the bounty
951 
952       require(msg.value == 0); // Ensures users don't accidentally send ETH alongside a token contribution, locking up funds
953       require(ERC20Token(bounties[_bountyId].token).transferFrom(_sender,
954                                                                  address(this),
955                                                                  _amount));
956     } else if (bounties[_bountyId].tokenVersion == 721){
957       tokenBalances[_bountyId][_amount] = true; // Adds the 721 token to the balance of the bounty
958 
959 
960       require(msg.value == 0); // Ensures users don't accidentally send ETH alongside a token contribution, locking up funds
961       ERC721BasicToken(bounties[_bountyId].token).transferFrom(_sender,
962                                                                address(this),
963                                                                _amount);
964     } else {
965       revert();
966     }
967 
968     emit ContributionAdded(_bountyId,
969                            bounties[_bountyId].contributions.length - 1, // The new contributionId
970                            _sender,
971                            _amount);
972   }
973 
974   /// @dev refundContribution(): Allows users to refund the contributions they've
975   ///                            made to a particular bounty, but only if the bounty
976   ///                            has not yet paid out, and the deadline has elapsed.
977   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
978   /// @param _bountyId the index of the bounty
979   /// @param _contributionId the index of the contribution being refunded
980   function refundContribution(
981     address _sender,
982     uint _bountyId,
983     uint _contributionId)
984     public
985     senderIsValid(_sender)
986     validateBountyArrayIndex(_bountyId)
987     validateContributionArrayIndex(_bountyId, _contributionId)
988     onlyContributor(_sender, _bountyId, _contributionId)
989     hasNotPaid(_bountyId)
990     hasNotRefunded(_bountyId, _contributionId)
991     callNotStarted
992   {
993     require(now > bounties[_bountyId].deadline); // Refunds may only be processed after the deadline has elapsed
994 
995     Contribution storage contribution = bounties[_bountyId].contributions[_contributionId];
996 
997     contribution.refunded = true;
998 
999     transferTokens(_bountyId, contribution.contributor, contribution.amount); // Performs the disbursal of tokens to the contributor
1000 
1001     emit ContributionRefunded(_bountyId, _contributionId);
1002   }
1003 
1004   /// @dev refundMyContributions(): Allows users to refund their contributions in bulk
1005   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1006   /// @param _bountyId the index of the bounty
1007   /// @param _contributionIds the array of indexes of the contributions being refunded
1008   function refundMyContributions(
1009     address _sender,
1010     uint _bountyId,
1011     uint[] memory _contributionIds)
1012     public
1013     senderIsValid(_sender)
1014   {
1015     for (uint i = 0; i < _contributionIds.length; i++){
1016         refundContribution(_sender, _bountyId, _contributionIds[i]);
1017     }
1018   }
1019 
1020   /// @dev refundContributions(): Allows users to refund their contributions in bulk
1021   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1022   /// @param _bountyId the index of the bounty
1023   /// @param _issuerId the index of the issuer who is making the call
1024   /// @param _contributionIds the array of indexes of the contributions being refunded
1025   function refundContributions(
1026     address _sender,
1027     uint _bountyId,
1028     uint _issuerId,
1029     uint[] memory _contributionIds)
1030     public
1031     senderIsValid(_sender)
1032     validateBountyArrayIndex(_bountyId)
1033     onlyIssuer(_sender, _bountyId, _issuerId)
1034     callNotStarted
1035   {
1036     for (uint i = 0; i < _contributionIds.length; i++){
1037       require(_contributionIds[i] < bounties[_bountyId].contributions.length);
1038 
1039       Contribution storage contribution = bounties[_bountyId].contributions[_contributionIds[i]];
1040 
1041       require(!contribution.refunded);
1042 
1043       contribution.refunded = true;
1044 
1045       transferTokens(_bountyId, contribution.contributor, contribution.amount); // Performs the disbursal of tokens to the contributor
1046     }
1047 
1048     emit ContributionsRefunded(_bountyId, _sender, _contributionIds);
1049   }
1050 
1051   /// @dev drainBounty(): Allows an issuer to drain the funds from the bounty
1052   /// @notice when using this function, if an issuer doesn't drain the entire balance, some users may be able to refund their contributions, while others may not (which is unfair to them). Please use it wisely, only when necessary
1053   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1054   /// @param _bountyId the index of the bounty
1055   /// @param _issuerId the index of the issuer who is making the call
1056   /// @param _amounts an array of amounts of tokens to be sent. The length of the array should be 1 if the bounty is in ETH or ERC20 tokens. If it's an ERC721 bounty, the array should be the list of tokenIDs.
1057   function drainBounty(
1058     address payable _sender,
1059     uint _bountyId,
1060     uint _issuerId,
1061     uint[] memory _amounts)
1062     public
1063     senderIsValid(_sender)
1064     validateBountyArrayIndex(_bountyId)
1065     onlyIssuer(_sender, _bountyId, _issuerId)
1066     callNotStarted
1067   {
1068     if (bounties[_bountyId].tokenVersion == 0 || bounties[_bountyId].tokenVersion == 20){
1069       require(_amounts.length == 1); // ensures there's only 1 amount of tokens to be returned
1070       require(_amounts[0] <= bounties[_bountyId].balance); // ensures an issuer doesn't try to drain the bounty of more tokens than their balance permits
1071       transferTokens(_bountyId, _sender, _amounts[0]); // Performs the draining of tokens to the issuer
1072     } else {
1073       for (uint i = 0; i < _amounts.length; i++){
1074         require(tokenBalances[_bountyId][_amounts[i]]);// ensures an issuer doesn't try to drain the bounty of a token it doesn't have in its balance
1075         transferTokens(_bountyId, _sender, _amounts[i]);
1076       }
1077     }
1078 
1079     emit BountyDrained(_bountyId, _sender, _amounts);
1080   }
1081 
1082   /// @dev performAction(): Allows users to perform any generalized action
1083   ///                       associated with a particular bounty, such as applying for it
1084   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1085   /// @param _bountyId the index of the bounty
1086   /// @param _data the IPFS hash corresponding to a JSON object which contains the details of the action being performed (see docs for schema details)
1087   function performAction(
1088     address _sender,
1089     uint _bountyId,
1090     string memory _data)
1091     public
1092     senderIsValid(_sender)
1093     validateBountyArrayIndex(_bountyId)
1094   {
1095     emit ActionPerformed(_bountyId, _sender, _data); // The _data string is emitted in an event for easy off-chain consumption
1096   }
1097 
1098   /// @dev fulfillBounty(): Allows users to fulfill the bounty to get paid out
1099   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1100   /// @param _bountyId the index of the bounty
1101   /// @param _fulfillers the array of addresses which will receive payouts for the submission
1102   /// @param _data the IPFS hash corresponding to a JSON object which contains the details of the submission (see docs for schema details)
1103   function fulfillBounty(
1104     address _sender,
1105     uint _bountyId,
1106     address payable[] memory  _fulfillers,
1107     string memory _data)
1108     public
1109     senderIsValid(_sender)
1110     validateBountyArrayIndex(_bountyId)
1111   {
1112     require(now < bounties[_bountyId].deadline); // Submissions are only allowed to be made before the deadline
1113     require(_fulfillers.length > 0); // Submissions with no fulfillers would mean no one gets paid out
1114 
1115     bounties[_bountyId].fulfillments.push(Fulfillment(_fulfillers, _sender));
1116 
1117     emit BountyFulfilled(_bountyId,
1118                          (bounties[_bountyId].fulfillments.length - 1),
1119                          _fulfillers,
1120                          _data, // The _data string is emitted in an event for easy off-chain consumption
1121                          _sender);
1122   }
1123 
1124   /// @dev updateFulfillment(): Allows the submitter of a fulfillment to update their submission
1125   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1126   /// @param _bountyId the index of the bounty
1127   /// @param _fulfillmentId the index of the fulfillment
1128   /// @param _fulfillers the new array of addresses which will receive payouts for the submission
1129   /// @param _data the new IPFS hash corresponding to a JSON object which contains the details of the submission (see docs for schema details)
1130   function updateFulfillment(
1131   address _sender,
1132   uint _bountyId,
1133   uint _fulfillmentId,
1134   address payable[] memory _fulfillers,
1135   string memory _data)
1136   public
1137   senderIsValid(_sender)
1138   validateBountyArrayIndex(_bountyId)
1139   validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)
1140   onlySubmitter(_sender, _bountyId, _fulfillmentId) // Only the original submitter of a fulfillment may update their submission
1141   {
1142     bounties[_bountyId].fulfillments[_fulfillmentId].fulfillers = _fulfillers;
1143     emit FulfillmentUpdated(_bountyId,
1144                             _fulfillmentId,
1145                             _fulfillers,
1146                             _data); // The _data string is emitted in an event for easy off-chain consumption
1147   }
1148 
1149   /// @dev acceptFulfillment(): Allows any of the approvers to accept a given submission
1150   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1151   /// @param _bountyId the index of the bounty
1152   /// @param _fulfillmentId the index of the fulfillment to be accepted
1153   /// @param _approverId the index of the approver which is making the call
1154   /// @param _tokenAmounts the array of token amounts which will be paid to the
1155   ///                      fulfillers, whose length should equal the length of the
1156   ///                      _fulfillers array of the submission. If the bounty pays
1157   ///                      in ERC721 tokens, then these should be the token IDs
1158   ///                      being sent to each of the individual fulfillers
1159   function acceptFulfillment(
1160     address _sender,
1161     uint _bountyId,
1162     uint _fulfillmentId,
1163     uint _approverId,
1164     uint[] memory _tokenAmounts)
1165     public
1166     senderIsValid(_sender)
1167     validateBountyArrayIndex(_bountyId)
1168     validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)
1169     isApprover(_sender, _bountyId, _approverId)
1170     callNotStarted
1171   {
1172     // now that the bounty has paid out at least once, refunds are no longer possible
1173     bounties[_bountyId].hasPaidOut = true;
1174 
1175     Fulfillment storage fulfillment = bounties[_bountyId].fulfillments[_fulfillmentId];
1176 
1177     require(_tokenAmounts.length == fulfillment.fulfillers.length); // Each fulfiller should get paid some amount of tokens (this can be 0)
1178 
1179     for (uint256 i = 0; i < fulfillment.fulfillers.length; i++){
1180         if (_tokenAmounts[i] > 0){
1181           // for each fulfiller associated with the submission
1182           transferTokens(_bountyId, fulfillment.fulfillers[i], _tokenAmounts[i]);
1183         }
1184     }
1185     emit FulfillmentAccepted(_bountyId,
1186                              _fulfillmentId,
1187                              _sender,
1188                              _tokenAmounts);
1189   }
1190 
1191   /// @dev fulfillAndAccept(): Allows any of the approvers to fulfill and accept a submission simultaneously
1192   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1193   /// @param _bountyId the index of the bounty
1194   /// @param _fulfillers the array of addresses which will receive payouts for the submission
1195   /// @param _data the IPFS hash corresponding to a JSON object which contains the details of the submission (see docs for schema details)
1196   /// @param _approverId the index of the approver which is making the call
1197   /// @param _tokenAmounts the array of token amounts which will be paid to the
1198   ///                      fulfillers, whose length should equal the length of the
1199   ///                      _fulfillers array of the submission. If the bounty pays
1200   ///                      in ERC721 tokens, then these should be the token IDs
1201   ///                      being sent to each of the individual fulfillers
1202   function fulfillAndAccept(
1203     address _sender,
1204     uint _bountyId,
1205     address payable[] memory _fulfillers,
1206     string memory _data,
1207     uint _approverId,
1208     uint[] memory _tokenAmounts)
1209     public
1210     senderIsValid(_sender)
1211   {
1212     // first fulfills the bounty on behalf of the fulfillers
1213     fulfillBounty(_sender, _bountyId, _fulfillers, _data);
1214 
1215     // then accepts the fulfillment
1216     acceptFulfillment(_sender,
1217                       _bountyId,
1218                       bounties[_bountyId].fulfillments.length - 1,
1219                       _approverId,
1220                       _tokenAmounts);
1221   }
1222 
1223 
1224 
1225   /// @dev changeBounty(): Allows any of the issuers to change the bounty
1226   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1227   /// @param _bountyId the index of the bounty
1228   /// @param _issuerId the index of the issuer who is calling the function
1229   /// @param _issuers the new array of addresses who will be the issuers of the bounty
1230   /// @param _approvers the new array of addresses who will be the approvers of the bounty
1231   /// @param _data the new IPFS hash representing the JSON object storing the details of the bounty (see docs for schema details)
1232   /// @param _deadline the new timestamp which will become the deadline of the bounty
1233   function changeBounty(
1234     address _sender,
1235     uint _bountyId,
1236     uint _issuerId,
1237     address payable[] memory _issuers,
1238     address payable[] memory _approvers,
1239     string memory _data,
1240     uint _deadline)
1241     public
1242     senderIsValid(_sender)
1243   {
1244     require(_bountyId < numBounties); // makes the validateBountyArrayIndex modifier in-line to avoid stack too deep errors
1245     require(_issuerId < bounties[_bountyId].issuers.length); // makes the validateIssuerArrayIndex modifier in-line to avoid stack too deep errors
1246     require(_sender == bounties[_bountyId].issuers[_issuerId]); // makes the onlyIssuer modifier in-line to avoid stack too deep errors
1247 
1248     require(_issuers.length > 0 || _approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck
1249 
1250     bounties[_bountyId].issuers = _issuers;
1251     bounties[_bountyId].approvers = _approvers;
1252     bounties[_bountyId].deadline = _deadline;
1253     emit BountyChanged(_bountyId,
1254                        _sender,
1255                        _issuers,
1256                        _approvers,
1257                        _data,
1258                        _deadline);
1259   }
1260 
1261   /// @dev changeIssuer(): Allows any of the issuers to change a particular issuer of the bounty
1262   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1263   /// @param _bountyId the index of the bounty
1264   /// @param _issuerId the index of the issuer who is calling the function
1265   /// @param _issuerIdToChange the index of the issuer who is being changed
1266   /// @param _newIssuer the address of the new issuer
1267   function changeIssuer(
1268     address _sender,
1269     uint _bountyId,
1270     uint _issuerId,
1271     uint _issuerIdToChange,
1272     address payable _newIssuer)
1273     public
1274     senderIsValid(_sender)
1275     validateBountyArrayIndex(_bountyId)
1276     validateIssuerArrayIndex(_bountyId, _issuerIdToChange)
1277     onlyIssuer(_sender, _bountyId, _issuerId)
1278   {
1279     require(_issuerId < bounties[_bountyId].issuers.length || _issuerId == 0);
1280 
1281     bounties[_bountyId].issuers[_issuerIdToChange] = _newIssuer;
1282 
1283     emit BountyIssuersUpdated(_bountyId, _sender, bounties[_bountyId].issuers);
1284   }
1285 
1286   /// @dev changeApprover(): Allows any of the issuers to change a particular approver of the bounty
1287   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1288   /// @param _bountyId the index of the bounty
1289   /// @param _issuerId the index of the issuer who is calling the function
1290   /// @param _approverId the index of the approver who is being changed
1291   /// @param _approver the address of the new approver
1292   function changeApprover(
1293     address _sender,
1294     uint _bountyId,
1295     uint _issuerId,
1296     uint _approverId,
1297     address payable _approver)
1298     external
1299     senderIsValid(_sender)
1300     validateBountyArrayIndex(_bountyId)
1301     onlyIssuer(_sender, _bountyId, _issuerId)
1302     validateApproverArrayIndex(_bountyId, _approverId)
1303   {
1304     bounties[_bountyId].approvers[_approverId] = _approver;
1305 
1306     emit BountyApproversUpdated(_bountyId, _sender, bounties[_bountyId].approvers);
1307   }
1308 
1309   /// @dev changeIssuerAndApprover(): Allows any of the issuers to change a particular approver of the bounty
1310   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1311   /// @param _bountyId the index of the bounty
1312   /// @param _issuerId the index of the issuer who is calling the function
1313   /// @param _issuerIdToChange the index of the issuer who is being changed
1314   /// @param _approverIdToChange the index of the approver who is being changed
1315   /// @param _issuer the address of the new approver
1316   function changeIssuerAndApprover(
1317     address _sender,
1318     uint _bountyId,
1319     uint _issuerId,
1320     uint _issuerIdToChange,
1321     uint _approverIdToChange,
1322     address payable _issuer)
1323     external
1324     senderIsValid(_sender)
1325     onlyIssuer(_sender, _bountyId, _issuerId)
1326   {
1327     require(_bountyId < numBounties);
1328     require(_approverIdToChange < bounties[_bountyId].approvers.length);
1329     require(_issuerIdToChange < bounties[_bountyId].issuers.length);
1330 
1331     bounties[_bountyId].issuers[_issuerIdToChange] = _issuer;
1332     bounties[_bountyId].approvers[_approverIdToChange] = _issuer;
1333 
1334     emit BountyIssuersUpdated(_bountyId, _sender, bounties[_bountyId].issuers);
1335     emit BountyApproversUpdated(_bountyId, _sender, bounties[_bountyId].approvers);
1336   }
1337 
1338   /// @dev changeData(): Allows any of the issuers to change the data the bounty
1339   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1340   /// @param _bountyId the index of the bounty
1341   /// @param _issuerId the index of the issuer who is calling the function
1342   /// @param _data the new IPFS hash representing the JSON object storing the details of the bounty (see docs for schema details)
1343   function changeData(
1344     address _sender,
1345     uint _bountyId,
1346     uint _issuerId,
1347     string memory _data)
1348     public
1349     senderIsValid(_sender)
1350     validateBountyArrayIndex(_bountyId)
1351     validateIssuerArrayIndex(_bountyId, _issuerId)
1352     onlyIssuer(_sender, _bountyId, _issuerId)
1353   {
1354     emit BountyDataChanged(_bountyId, _sender, _data); // The new _data is emitted within an event rather than being stored on-chain for minimized gas costs
1355   }
1356 
1357   /// @dev changeDeadline(): Allows any of the issuers to change the deadline the bounty
1358   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1359   /// @param _bountyId the index of the bounty
1360   /// @param _issuerId the index of the issuer who is calling the function
1361   /// @param _deadline the new timestamp which will become the deadline of the bounty
1362   function changeDeadline(
1363     address _sender,
1364     uint _bountyId,
1365     uint _issuerId,
1366     uint _deadline)
1367     external
1368     senderIsValid(_sender)
1369     validateBountyArrayIndex(_bountyId)
1370     validateIssuerArrayIndex(_bountyId, _issuerId)
1371     onlyIssuer(_sender, _bountyId, _issuerId)
1372   {
1373     bounties[_bountyId].deadline = _deadline;
1374 
1375     emit BountyDeadlineChanged(_bountyId, _sender, _deadline);
1376   }
1377 
1378   /// @dev addIssuers(): Allows any of the issuers to add more issuers to the bounty
1379   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1380   /// @param _bountyId the index of the bounty
1381   /// @param _issuerId the index of the issuer who is calling the function
1382   /// @param _issuers the array of addresses to add to the list of valid issuers
1383   function addIssuers(
1384     address _sender,
1385     uint _bountyId,
1386     uint _issuerId,
1387     address payable[] memory _issuers)
1388     public
1389     senderIsValid(_sender)
1390     validateBountyArrayIndex(_bountyId)
1391     validateIssuerArrayIndex(_bountyId, _issuerId)
1392     onlyIssuer(_sender, _bountyId, _issuerId)
1393   {
1394     for (uint i = 0; i < _issuers.length; i++){
1395       bounties[_bountyId].issuers.push(_issuers[i]);
1396     }
1397 
1398     emit BountyIssuersUpdated(_bountyId, _sender, bounties[_bountyId].issuers);
1399   }
1400 
1401   /// @dev addApprovers(): Allows any of the issuers to add more approvers to the bounty
1402   /// @param _sender the sender of the transaction issuing the bounty (should be the same as msg.sender unless the txn is called by the meta tx relayer)
1403   /// @param _bountyId the index of the bounty
1404   /// @param _issuerId the index of the issuer who is calling the function
1405   /// @param _approvers the array of addresses to add to the list of valid approvers
1406   function addApprovers(
1407     address _sender,
1408     uint _bountyId,
1409     uint _issuerId,
1410     address[] memory _approvers)
1411     public
1412     senderIsValid(_sender)
1413     validateBountyArrayIndex(_bountyId)
1414     validateIssuerArrayIndex(_bountyId, _issuerId)
1415     onlyIssuer(_sender, _bountyId, _issuerId)
1416   {
1417     for (uint i = 0; i < _approvers.length; i++){
1418       bounties[_bountyId].approvers.push(_approvers[i]);
1419     }
1420 
1421     emit BountyApproversUpdated(_bountyId, _sender, bounties[_bountyId].approvers);
1422   }
1423 
1424   /// @dev getBounty(): Returns the details of the bounty
1425   /// @param _bountyId the index of the bounty
1426   /// @return Returns a tuple for the bounty
1427   function getBounty(uint _bountyId)
1428     external
1429     view
1430     returns (Bounty memory)
1431   {
1432     return bounties[_bountyId];
1433   }
1434 
1435 
1436   function transferTokens(uint _bountyId, address payable _to, uint _amount)
1437     internal
1438   {
1439     if (bounties[_bountyId].tokenVersion == 0){
1440       require(_amount > 0); // Sending 0 tokens should throw
1441       require(bounties[_bountyId].balance >= _amount);
1442 
1443       bounties[_bountyId].balance = bounties[_bountyId].balance.sub(_amount);
1444 
1445       _to.transfer(_amount);
1446     } else if (bounties[_bountyId].tokenVersion == 20){
1447       require(_amount > 0); // Sending 0 tokens should throw
1448       require(bounties[_bountyId].balance >= _amount);
1449 
1450       bounties[_bountyId].balance = bounties[_bountyId].balance.sub(_amount);
1451 
1452       require(ERC20Token(bounties[_bountyId].token).transfer(_to, _amount));
1453     } else if (bounties[_bountyId].tokenVersion == 721){
1454       require(tokenBalances[_bountyId][_amount]);
1455 
1456       tokenBalances[_bountyId][_amount] = false; // Removes the 721 token from the balance of the bounty
1457 
1458       ERC721BasicToken(bounties[_bountyId].token).transferFrom(address(this),
1459                                                                _to,
1460                                                                _amount);
1461     } else {
1462       revert();
1463     }
1464   }
1465 
1466   /*
1467    * Events
1468    */
1469 
1470   event BountyIssued(uint _bountyId, address payable _creator, address payable[] _issuers, address[] _approvers, string _data, uint _deadline, address _token, uint _tokenVersion);
1471   event ContributionAdded(uint _bountyId, uint _contributionId, address payable _contributor, uint _amount);
1472   event ContributionRefunded(uint _bountyId, uint _contributionId);
1473   event ContributionsRefunded(uint _bountyId, address _issuer, uint[] _contributionIds);
1474   event BountyDrained(uint _bountyId, address _issuer, uint[] _amounts);
1475   event ActionPerformed(uint _bountyId, address _fulfiller, string _data);
1476   event BountyFulfilled(uint _bountyId, uint _fulfillmentId, address payable[] _fulfillers, string _data, address _submitter);
1477   event FulfillmentUpdated(uint _bountyId, uint _fulfillmentId, address payable[] _fulfillers, string _data);
1478   event FulfillmentAccepted(uint _bountyId, uint  _fulfillmentId, address _approver, uint[] _tokenAmounts);
1479   event BountyChanged(uint _bountyId, address _changer, address payable[] _issuers, address payable[] _approvers, string _data, uint _deadline);
1480   event BountyIssuersUpdated(uint _bountyId, address _changer, address payable[] _issuers);
1481   event BountyApproversUpdated(uint _bountyId, address _changer, address[] _approvers);
1482   event BountyDataChanged(uint _bountyId, address _changer, string _data);
1483   event BountyDeadlineChanged(uint _bountyId, address _changer, uint _deadline);
1484 }