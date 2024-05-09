1 pragma solidity 0.4.24;
2 
3 // ERC20 Token with ERC223 Token compatibility
4 // SafeMath from OpenZeppelin Standard
5 // Added burn functions from Ethereum Token 
6 // - https://theethereum.wiki/w/index.php/ERC20_Token_Standard
7 // - https://github.com/Dexaran/ERC23-tokens/blob/Recommended/ERC223_Token.sol
8 // - https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
9 // - https://www.ethereum.org/token (uncontrolled, non-standard)
10 
11 
12 // ERC223
13 interface ContractReceiver {
14   function tokenFallback( address from, uint value, bytes data ) external;
15 }
16 
17 // SafeMath
18 contract SafeMath2 {
19 
20     function safeSub(uint a, uint b) internal pure returns (uint) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function safeAdd(uint a, uint b) internal pure returns (uint) {
26         uint c = a + b;
27         assert(c >= a);
28         return c;
29     }
30     
31     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
32         return a >= b ? a : b;
33     }
34 
35     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
36         return a < b ? a : b;
37     }
38 
39     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
40         return a >= b ? a : b;
41     }
42 
43     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
44         return a < b ? a : b;
45 }
46 }
47 
48 
49 contract RUNEToken is SafeMath2
50 {
51     
52     // Rune Characteristics
53     string  public name = "Rune";
54     string  public symbol  = "RUNE";
55     uint256   public decimals  = 18;
56     uint256 public totalSupply  = 1000000000 * (10 ** decimals);
57 
58     // Mapping
59     mapping( address => uint256 ) balances_;
60     mapping( address => mapping(address => uint256) ) allowances_;
61     
62     // Minting event
63     function RUNEToken() public {
64             balances_[msg.sender] = totalSupply;
65                 emit Transfer( address(0), msg.sender, totalSupply );
66         }
67 
68     function() public payable { revert(); } // does not accept money
69     
70     // ERC20
71     event Approval( address indexed owner,
72                     address indexed spender,
73                     uint value );
74 
75     event Transfer( address indexed from,
76                     address indexed to,
77                     uint256 value );
78 
79 
80     // ERC20
81     function balanceOf( address owner ) public constant returns (uint) {
82         return balances_[owner];
83     }
84 
85     // ERC20
86     function approve( address spender, uint256 value ) public
87     returns (bool success)
88     {
89         allowances_[msg.sender][spender] = value;
90         emit Approval( msg.sender, spender, value );
91         return true;
92     }
93     
94     // recommended fix for known attack on any ERC20
95     function safeApprove( address _spender,
96                             uint256 _currentValue,
97                             uint256 _value ) public
98                             returns (bool success) {
99 
100         // If current allowance for _spender is equal to _currentValue, then
101         // overwrite it with _value and return true, otherwise return false.
102 
103         if (allowances_[msg.sender][_spender] == _currentValue)
104         return approve(_spender, _value);
105 
106         return false;
107     }
108 
109     // ERC20
110     function allowance( address owner, address spender ) public constant
111     returns (uint256 remaining)
112     {
113         return allowances_[owner][spender];
114     }
115 
116     // ERC20
117     function transfer(address to, uint256 value) public returns (bool success)
118     {
119         bytes memory empty; // null
120         _transfer( msg.sender, to, value, empty );
121         return true;
122     }
123 
124     // ERC20
125     function transferFrom( address from, address to, uint256 value ) public
126     returns (bool success)
127     {
128         require( value <= allowances_[from][msg.sender] );
129 
130         allowances_[from][msg.sender] -= value;
131         bytes memory empty;
132         _transfer( from, to, value, empty );
133 
134         return true;
135     }
136 
137     // ERC223 Transfer and invoke specified callback
138     function transfer( address to,
139                         uint value,
140                         bytes data,
141                         string custom_fallback ) public returns (bool success)
142     {
143         _transfer( msg.sender, to, value, data );
144 
145         if ( isContract(to) )
146         {
147         ContractReceiver rx = ContractReceiver( to );
148         require( address(rx).call.value(0)(bytes4(keccak256(custom_fallback)),
149                 msg.sender,
150                 value,
151                 data) );
152         }
153 
154         return true;
155     }
156 
157     // ERC223 Transfer to a contract or externally-owned account
158     function transfer( address to, uint value, bytes data ) public
159     returns (bool success)
160     {
161         if (isContract(to)) {
162         return transferToContract( to, value, data );
163         }
164 
165         _transfer( msg.sender, to, value, data );
166         return true;
167     }
168 
169     // ERC223 Transfer to contract and invoke tokenFallback() method
170     function transferToContract( address to, uint value, bytes data ) private
171     returns (bool success)
172     {
173         _transfer( msg.sender, to, value, data );
174 
175         ContractReceiver rx = ContractReceiver(to);
176         rx.tokenFallback( msg.sender, value, data );
177 
178         return true;
179     }
180 
181     // ERC223 fetch contract size (must be nonzero to be a contract)
182     function isContract( address _addr ) private constant returns (bool)
183     {
184         uint length;
185         assembly { length := extcodesize(_addr) }
186         return (length > 0);
187     }
188 
189     function _transfer( address from,
190                         address to,
191                         uint value,
192                         bytes data ) internal
193     {
194         require( to != 0x0 );
195         require( balances_[from] >= value );
196         require( balances_[to] + value > balances_[to] ); // catch overflow
197 
198         balances_[from] -= value;
199         balances_[to] += value;
200 
201         //Transfer( from, to, value, data ); ERC223-compat version
202         bytes memory empty;
203         empty = data;
204         emit Transfer( from, to, value ); // ERC20-compat version
205     }
206     
207     
208         // Ethereum Token
209     event Burn( address indexed from, uint256 value );
210     
211         // Ethereum Token
212     function burn( uint256 value ) public
213     returns (bool success)
214     {
215         require( balances_[msg.sender] >= value );
216         balances_[msg.sender] -= value;
217         totalSupply -= value;
218 
219         emit Burn( msg.sender, value );
220         return true;
221     }
222 
223     // Ethereum Token
224     function burnFrom( address from, uint256 value ) public
225     returns (bool success)
226     {
227         require( balances_[from] >= value );
228         require( value <= allowances_[from][msg.sender] );
229 
230         balances_[from] -= value;
231         allowances_[from][msg.sender] -= value;
232         totalSupply -= value;
233 
234         emit Burn( from, value );
235         return true;
236     }
237   
238   
239 }
240 
241 
242 
243 
244 /**
245  * @title ERC165
246  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
247  */
248 interface ERC165 {
249 
250   /**
251    * @notice Query if a contract implements an interface
252    * @param _interfaceId The interface identifier, as specified in ERC-165
253    * @dev Interface identification is specified in ERC-165. This function
254    * uses less than 30,000 gas.
255    */
256   function supportsInterface(bytes4 _interfaceId)
257     external
258     view
259     returns (bool);
260 }
261 
262 
263 
264 /**
265  * @title SupportsInterfaceWithLookup
266  * @author Matt Condon (@shrugs)
267  * @dev Implements ERC165 using a lookup table.
268  */
269 contract SupportsInterfaceWithLookup is ERC165 {
270 
271   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
272   /**
273    * 0x01ffc9a7 ===
274    *   bytes4(keccak256('supportsInterface(bytes4)'))
275    */
276 
277   /**
278    * @dev a mapping of interface id to whether or not it's supported
279    */
280   mapping(bytes4 => bool) internal supportedInterfaces;
281 
282   /**
283    * @dev A contract implementing SupportsInterfaceWithLookup
284    * implement ERC165 itself
285    */
286   constructor()
287     public
288   {
289     _registerInterface(InterfaceId_ERC165);
290   }
291 
292   /**
293    * @dev implement supportsInterface(bytes4) using a lookup table
294    */
295   function supportsInterface(bytes4 _interfaceId)
296     external
297     view
298     returns (bool)
299   {
300     return supportedInterfaces[_interfaceId];
301   }
302 
303   /**
304    * @dev private method for registering an interface
305    */
306   function _registerInterface(bytes4 _interfaceId)
307     internal
308   {
309     require(_interfaceId != 0xffffffff);
310     supportedInterfaces[_interfaceId] = true;
311   }
312 }
313 
314 
315 /**
316  * @title ERC721 Non-Fungible Token Standard basic interface
317  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
318  */
319 contract ERC721Basic is ERC165 {
320 
321   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
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
335   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
336   /**
337    * 0x780e9d63 ===
338    *   bytes4(keccak256('totalSupply()')) ^
339    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
340    *   bytes4(keccak256('tokenByIndex(uint256)'))
341    */
342 
343   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
344   /**
345    * 0x5b5e139f ===
346    *   bytes4(keccak256('name()')) ^
347    *   bytes4(keccak256('symbol()')) ^
348    *   bytes4(keccak256('tokenURI(uint256)'))
349    */
350 
351   event Transfer(
352     address indexed _from,
353     address indexed _to,
354     uint256 indexed _tokenId
355   );
356   event Approval(
357     address indexed _owner,
358     address indexed _approved,
359     uint256 indexed _tokenId
360   );
361   event ApprovalForAll(
362     address indexed _owner,
363     address indexed _operator,
364     bool _approved
365   );
366 
367   function balanceOf(address _owner) public view returns (uint256 _balance);
368   function ownerOf(uint256 _tokenId) public view returns (address _owner);
369 
370   function approve(address _to, uint256 _tokenId) public;
371   function getApproved(uint256 _tokenId)
372     public view returns (address _operator);
373 
374   function setApprovalForAll(address _operator, bool _approved) public;
375   function isApprovedForAll(address _owner, address _operator)
376     public view returns (bool);
377 
378   function transferFrom(address _from, address _to, uint256 _tokenId) public;
379   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
380     public;
381 
382   function safeTransferFrom(
383     address _from,
384     address _to,
385     uint256 _tokenId,
386     bytes _data
387   )
388     public;
389 }
390 
391 
392 
393 contract THORChain721Receiver {
394   /**
395    * @dev Magic value to be returned upon successful reception of an NFT
396    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
397    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
398    */
399   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
400 
401   bytes4 retval;
402   bool reverts;
403 
404   constructor(bytes4 _retval, bool _reverts) public {
405     retval = _retval;
406     reverts = _reverts;
407   }
408 
409   event Received(
410     address _operator,
411     address _from,
412     uint256 _tokenId,
413     bytes _data,
414     uint256 _gas
415   );
416 
417   function onERC721Received(
418     address _operator,
419     address _from,
420     uint256 _tokenId,
421     bytes _data
422   )
423     public
424     returns(bytes4)
425   {
426     require(!reverts);
427     emit Received(
428       _operator,
429       _from,
430       _tokenId,
431       _data,
432       gasleft()
433     );
434     return retval;
435   }
436 }
437 
438 
439 
440 /**
441  * @title SafeMath
442  * @dev Math operations with safety checks that revert on error
443  */
444 library SafeMath {
445 
446   /**
447   * @dev Multiplies two numbers, reverts on overflow.
448   */
449   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
450     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
451     // benefit is lost if 'b' is also tested.
452     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
453     if (_a == 0) {
454       return 0;
455     }
456 
457     uint256 c = _a * _b;
458     require(c / _a == _b);
459 
460     return c;
461   }
462 
463   /**
464   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
465   */
466   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
467     require(_b > 0); // Solidity only automatically asserts when dividing by 0
468     uint256 c = _a / _b;
469     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
470 
471     return c;
472   }
473 
474   /**
475   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
476   */
477   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
478     require(_b <= _a);
479     uint256 c = _a - _b;
480 
481     return c;
482   }
483 
484   /**
485   * @dev Adds two numbers, reverts on overflow.
486   */
487   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
488     uint256 c = _a + _b;
489     require(c >= _a);
490 
491     return c;
492   }
493 
494   /**
495   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
496   * reverts when dividing by zero.
497   */
498   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
499     require(b != 0);
500     return a % b;
501   }
502 }
503 
504 
505 /**
506  * Utility library of inline functions on addresses
507  */
508 library AddressUtils {
509 
510   /**
511    * Returns whether the target address is a contract
512    * @dev This function will return false if invoked during the constructor of a contract,
513    * as the code is not actually created until after the constructor finishes.
514    * @param _account address of the account to check
515    * @return whether the target address is a contract
516    */
517   function isContract(address _account) internal view returns (bool) {
518     uint256 size;
519     // XXX Currently there is no better way to check if there is a contract in an address
520     // than to check the size of the code at that address.
521     // See https://ethereum.stackexchange.com/a/14016/36603
522     // for more details about how this works.
523     // TODO Check this again before the Serenity release, because all addresses will be
524     // contracts then.
525     // solium-disable-next-line security/no-inline-assembly
526     assembly { size := extcodesize(_account) }
527     return size > 0;
528   }
529 
530 }
531 
532 
533 /**
534  * @title ERC721 Non-Fungible Token Standard basic implementation
535  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
536  */
537 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
538 
539   using SafeMath for uint256;
540   using AddressUtils for address;
541 
542   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
543   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
544   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
545 
546   // Mapping from token ID to owner
547   mapping (uint256 => address) internal tokenOwner;
548 
549   // Mapping from token ID to approved address
550   mapping (uint256 => address) internal tokenApprovals;
551 
552   // Mapping from owner to number of owned token
553   mapping (address => uint256) internal ownedTokensCount;
554 
555   // Mapping from owner to operator approvals
556   mapping (address => mapping (address => bool)) internal operatorApprovals;
557 
558   constructor()
559     public
560   {
561     // register the supported interfaces to conform to ERC721 via ERC165
562     _registerInterface(InterfaceId_ERC721);
563   }
564 
565   /**
566    * @dev Gets the balance of the specified address
567    * @param _owner address to query the balance of
568    * @return uint256 representing the amount owned by the passed address
569    */
570   function balanceOf(address _owner) public view returns (uint256) {
571     require(_owner != address(0));
572     return ownedTokensCount[_owner];
573   }
574 
575   /**
576    * @dev Gets the owner of the specified token ID
577    * @param _tokenId uint256 ID of the token to query the owner of
578    * @return owner address currently marked as the owner of the given token ID
579    */
580   function ownerOf(uint256 _tokenId) public view returns (address) {
581     address owner = tokenOwner[_tokenId];
582     require(owner != address(0));
583     return owner;
584   }
585 
586   /**
587    * @dev Approves another address to transfer the given token ID
588    * The zero address indicates there is no approved address.
589    * There can only be one approved address per token at a given time.
590    * Can only be called by the token owner or an approved operator.
591    * @param _to address to be approved for the given token ID
592    * @param _tokenId uint256 ID of the token to be approved
593    */
594   function approve(address _to, uint256 _tokenId) public {
595     address owner = ownerOf(_tokenId);
596     require(_to != owner);
597     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
598 
599     tokenApprovals[_tokenId] = _to;
600     emit Approval(owner, _to, _tokenId);
601   }
602 
603   /**
604    * @dev Gets the approved address for a token ID, or zero if no address set
605    * @param _tokenId uint256 ID of the token to query the approval of
606    * @return address currently approved for the given token ID
607    */
608   function getApproved(uint256 _tokenId) public view returns (address) {
609     return tokenApprovals[_tokenId];
610   }
611 
612   /**
613    * @dev Sets or unsets the approval of a given operator
614    * An operator is allowed to transfer all tokens of the sender on their behalf
615    * @param _to operator address to set the approval
616    * @param _approved representing the status of the approval to be set
617    */
618   function setApprovalForAll(address _to, bool _approved) public {
619     require(_to != msg.sender);
620     operatorApprovals[msg.sender][_to] = _approved;
621     emit ApprovalForAll(msg.sender, _to, _approved);
622   }
623 
624   /**
625    * @dev Tells whether an operator is approved by a given owner
626    * @param _owner owner address which you want to query the approval of
627    * @param _operator operator address which you want to query the approval of
628    * @return bool whether the given operator is approved by the given owner
629    */
630   function isApprovedForAll(
631     address _owner,
632     address _operator
633   )
634     public
635     view
636     returns (bool)
637   {
638     return operatorApprovals[_owner][_operator];
639   }
640 
641   /**
642    * @dev Transfers the ownership of a given token ID to another address
643    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
644    * Requires the msg sender to be the owner, approved, or operator
645    * @param _from current owner of the token
646    * @param _to address to receive the ownership of the given token ID
647    * @param _tokenId uint256 ID of the token to be transferred
648   */
649   function transferFrom(
650     address _from,
651     address _to,
652     uint256 _tokenId
653   )
654     public
655   {
656     require(isApprovedOrOwner(msg.sender, _tokenId));
657     require(_to != address(0));
658 
659     clearApproval(_from, _tokenId);
660     removeTokenFrom(_from, _tokenId);
661     addTokenTo(_to, _tokenId);
662 
663     emit Transfer(_from, _to, _tokenId);
664   }
665 
666   /**
667    * @dev Safely transfers the ownership of a given token ID to another address
668    * If the target address is a contract, it must implement `onERC721Received`,
669    * which is called upon a safe transfer, and return the magic value
670    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
671    * the transfer is reverted.
672    *
673    * Requires the msg sender to be the owner, approved, or operator
674    * @param _from current owner of the token
675    * @param _to address to receive the ownership of the given token ID
676    * @param _tokenId uint256 ID of the token to be transferred
677   */
678   function safeTransferFrom(
679     address _from,
680     address _to,
681     uint256 _tokenId
682   )
683     public
684   {
685     // solium-disable-next-line arg-overflow
686     safeTransferFrom(_from, _to, _tokenId, "");
687   }
688 
689   /**
690    * @dev Safely transfers the ownership of a given token ID to another address
691    * If the target address is a contract, it must implement `onERC721Received`,
692    * which is called upon a safe transfer, and return the magic value
693    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
694    * the transfer is reverted.
695    * Requires the msg sender to be the owner, approved, or operator
696    * @param _from current owner of the token
697    * @param _to address to receive the ownership of the given token ID
698    * @param _tokenId uint256 ID of the token to be transferred
699    * @param _data bytes data to send along with a safe transfer check
700    */
701   function safeTransferFrom(
702     address _from,
703     address _to,
704     uint256 _tokenId,
705     bytes _data
706   )
707     public
708   {
709     transferFrom(_from, _to, _tokenId);
710     // solium-disable-next-line arg-overflow
711     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
712   }
713 
714   /**
715    * @dev Returns whether the specified token exists
716    * @param _tokenId uint256 ID of the token to query the existence of
717    * @return whether the token exists
718    */
719   function _exists(uint256 _tokenId) internal view returns (bool) {
720     address owner = tokenOwner[_tokenId];
721     return owner != address(0);
722   }
723 
724   /**
725    * @dev Returns whether the given spender can transfer a given token ID
726    * @param _spender address of the spender to query
727    * @param _tokenId uint256 ID of the token to be transferred
728    * @return bool whether the msg.sender is approved for the given token ID,
729    *  is an operator of the owner, or is the owner of the token
730    */
731   function isApprovedOrOwner(
732     address _spender,
733     uint256 _tokenId
734   )
735     internal
736     view
737     returns (bool)
738   {
739     address owner = ownerOf(_tokenId);
740     // Disable solium check because of
741     // https://github.com/duaraghav8/Solium/issues/175
742     // solium-disable-next-line operator-whitespace
743     return (
744       _spender == owner ||
745       getApproved(_tokenId) == _spender ||
746       isApprovedForAll(owner, _spender)
747     );
748   }
749 
750   /**
751    * @dev Internal function to mint a new token
752    * Reverts if the given token ID already exists
753    * @param _to The address that will own the minted token
754    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
755    */
756   function _mint(address _to, uint256 _tokenId) internal {
757     require(_to != address(0));
758     addTokenTo(_to, _tokenId);
759     emit Transfer(address(0), _to, _tokenId);
760   }
761 
762   /**
763    * @dev Internal function to burn a specific token
764    * Reverts if the token does not exist
765    * @param _tokenId uint256 ID of the token being burned by the msg.sender
766    */
767   function _burn(address _owner, uint256 _tokenId) internal {
768     clearApproval(_owner, _tokenId);
769     removeTokenFrom(_owner, _tokenId);
770     emit Transfer(_owner, address(0), _tokenId);
771   }
772 
773   /**
774    * @dev Internal function to clear current approval of a given token ID
775    * Reverts if the given address is not indeed the owner of the token
776    * @param _owner owner of the token
777    * @param _tokenId uint256 ID of the token to be transferred
778    */
779   function clearApproval(address _owner, uint256 _tokenId) internal {
780     require(ownerOf(_tokenId) == _owner);
781     if (tokenApprovals[_tokenId] != address(0)) {
782       tokenApprovals[_tokenId] = address(0);
783     }
784   }
785 
786   /**
787    * @dev Internal function to add a token ID to the list of a given address
788    * @param _to address representing the new owner of the given token ID
789    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
790    */
791   function addTokenTo(address _to, uint256 _tokenId) internal {
792     require(tokenOwner[_tokenId] == address(0));
793     tokenOwner[_tokenId] = _to;
794     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
795   }
796 
797   /**
798    * @dev Internal function to remove a token ID from the list of a given address
799    * @param _from address representing the previous owner of the given token ID
800    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
801    */
802   function removeTokenFrom(address _from, uint256 _tokenId) internal {
803     require(ownerOf(_tokenId) == _from);
804     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
805     tokenOwner[_tokenId] = address(0);
806   }
807 
808   /**
809    * @dev Internal function to invoke `onERC721Received` on a target address
810    * The call is not executed if the target address is not a contract
811    * @param _from address representing the previous owner of the given token ID
812    * @param _to target address that will receive the tokens
813    * @param _tokenId uint256 ID of the token to be transferred
814    * @param _data bytes optional data to send along with the call
815    * @return whether the call correctly returned the expected magic value
816    */
817   function checkAndCallSafeTransfer(
818     address _from,
819     address _to,
820     uint256 _tokenId,
821     bytes _data
822   )
823     internal
824     returns (bool)
825   {
826     if (!_to.isContract()) {
827       return true;
828     }
829     bytes4 retval = THORChain721Receiver(_to).onERC721Received(
830       msg.sender, _from, _tokenId, _data);
831     return (retval == ERC721_RECEIVED);
832   }
833 }
834 
835 
836 
837 
838 
839 
840 /**
841  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
842  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
843  */
844 contract ERC721Enumerable is ERC721Basic {
845   function totalSupply() public view returns (uint256);
846   function tokenOfOwnerByIndex(
847     address _owner,
848     uint256 _index
849   )
850     public
851     view
852     returns (uint256 _tokenId);
853 
854   function tokenByIndex(uint256 _index) public view returns (uint256);
855 }
856 
857 
858 /**
859  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
860  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
861  */
862 contract ERC721Metadata is ERC721Basic {
863   function name() external view returns (string _name);
864   function symbol() external view returns (string _symbol);
865   function tokenURI(uint256 _tokenId) public view returns (string);
866 }
867 
868 
869 /**
870  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
871  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
872  */
873 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
874 }
875 
876 
877 
878 
879 /**
880  * @title Full ERC721 Token
881  * This implementation includes all the required and some optional functionality of the ERC721 standard
882  * Moreover, it includes approve all functionality using operator terminology
883  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
884  */
885 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
886 
887   // Token name
888   string internal name_;
889 
890   // Token symbol
891   string internal symbol_;
892 
893   // Mapping from owner to list of owned token IDs
894   mapping(address => uint256[]) internal ownedTokens;
895 
896   // Mapping from token ID to index of the owner tokens list
897   mapping(uint256 => uint256) internal ownedTokensIndex;
898 
899   // Array with all token ids, used for enumeration
900   uint256[] internal allTokens;
901 
902   // Mapping from token id to position in the allTokens array
903   mapping(uint256 => uint256) internal allTokensIndex;
904 
905   // Optional mapping for token URIs
906   mapping(uint256 => string) internal tokenURIs;
907 
908   /**
909    * @dev Constructor function
910    */
911   constructor(string _name, string _symbol) public {
912     name_ = _name;
913     symbol_ = _symbol;
914 
915     // register the supported interfaces to conform to ERC721 via ERC165
916     _registerInterface(InterfaceId_ERC721Enumerable);
917     _registerInterface(InterfaceId_ERC721Metadata);
918   }
919 
920   /**
921    * @dev Gets the token name
922    * @return string representing the token name
923    */
924   function name() external view returns (string) {
925     return name_;
926   }
927 
928   /**
929    * @dev Gets the token symbol
930    * @return string representing the token symbol
931    */
932   function symbol() external view returns (string) {
933     return symbol_;
934   }
935 
936   /**
937    * @dev Returns an URI for a given token ID
938    * Throws if the token ID does not exist. May return an empty string.
939    * @param _tokenId uint256 ID of the token to query
940    */
941   function tokenURI(uint256 _tokenId) public view returns (string) {
942     require(_exists(_tokenId));
943     return tokenURIs[_tokenId];
944   }
945 
946   /**
947    * @dev Gets the token ID at a given index of the tokens list of the requested owner
948    * @param _owner address owning the tokens list to be accessed
949    * @param _index uint256 representing the index to be accessed of the requested tokens list
950    * @return uint256 token ID at the given index of the tokens list owned by the requested address
951    */
952   function tokenOfOwnerByIndex(
953     address _owner,
954     uint256 _index
955   )
956     public
957     view
958     returns (uint256)
959   {
960     require(_index < balanceOf(_owner));
961     return ownedTokens[_owner][_index];
962   }
963 
964   /**
965    * @dev Gets the total amount of tokens stored by the contract
966    * @return uint256 representing the total amount of tokens
967    */
968   function totalSupply() public view returns (uint256) {
969     return allTokens.length;
970   }
971 
972   /**
973    * @dev Gets the token ID at a given index of all the tokens in this contract
974    * Reverts if the index is greater or equal to the total number of tokens
975    * @param _index uint256 representing the index to be accessed of the tokens list
976    * @return uint256 token ID at the given index of the tokens list
977    */
978   function tokenByIndex(uint256 _index) public view returns (uint256) {
979     require(_index < totalSupply());
980     return allTokens[_index];
981   }
982 
983   /**
984    * @dev Internal function to set the token URI for a given token
985    * Reverts if the token ID does not exist
986    * @param _tokenId uint256 ID of the token to set its URI
987    * @param _uri string URI to assign
988    */
989   function _setTokenURI(uint256 _tokenId, string _uri) internal {
990     require(_exists(_tokenId));
991     tokenURIs[_tokenId] = _uri;
992   }
993 
994   /**
995    * @dev Internal function to add a token ID to the list of a given address
996    * @param _to address representing the new owner of the given token ID
997    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
998    */
999   function addTokenTo(address _to, uint256 _tokenId) internal {
1000     super.addTokenTo(_to, _tokenId);
1001     uint256 length = ownedTokens[_to].length;
1002     ownedTokens[_to].push(_tokenId);
1003     ownedTokensIndex[_tokenId] = length;
1004   }
1005 
1006   /**
1007    * @dev Internal function to remove a token ID from the list of a given address
1008    * @param _from address representing the previous owner of the given token ID
1009    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1010    */
1011   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1012     super.removeTokenFrom(_from, _tokenId);
1013 
1014     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
1015     // then delete the last slot.
1016     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1017     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1018     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1019 
1020     ownedTokens[_from][tokenIndex] = lastToken;
1021     // This also deletes the contents at the last position of the array
1022     ownedTokens[_from].length--;
1023 
1024     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1025     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1026     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1027 
1028     ownedTokensIndex[_tokenId] = 0;
1029     ownedTokensIndex[lastToken] = tokenIndex;
1030   }
1031 
1032   /**
1033    * @dev Internal function to mint a new token
1034    * Reverts if the given token ID already exists
1035    * @param _to address the beneficiary that will own the minted token
1036    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1037    */
1038   function _mint(address _to, uint256 _tokenId) internal {
1039     super._mint(_to, _tokenId);
1040 
1041     allTokensIndex[_tokenId] = allTokens.length;
1042     allTokens.push(_tokenId);
1043   }
1044 
1045   /**
1046    * @dev Internal function to burn a specific token
1047    * Reverts if the token does not exist
1048    * @param _owner owner of the token to burn
1049    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1050    */
1051   function _burn(address _owner, uint256 _tokenId) internal {
1052     super._burn(_owner, _tokenId);
1053 
1054     // Clear metadata (if any)
1055     if (bytes(tokenURIs[_tokenId]).length != 0) {
1056       delete tokenURIs[_tokenId];
1057     }
1058 
1059     // Reorg all tokens array
1060     uint256 tokenIndex = allTokensIndex[_tokenId];
1061     uint256 lastTokenIndex = allTokens.length.sub(1);
1062     uint256 lastToken = allTokens[lastTokenIndex];
1063 
1064     allTokens[tokenIndex] = lastToken;
1065     allTokens[lastTokenIndex] = 0;
1066 
1067     allTokens.length--;
1068     allTokensIndex[_tokenId] = 0;
1069     allTokensIndex[lastToken] = tokenIndex;
1070   }
1071 
1072 }
1073 
1074 contract THORChain721 is ERC721Token {
1075     
1076     address public owner;
1077 
1078     modifier onlyOwner {
1079         require(msg.sender == owner);
1080         _;
1081     }
1082 
1083     constructor () public ERC721Token("testTC1", "testTC1") {
1084         owner = msg.sender;
1085     }
1086 
1087     // Revert any transaction to this contract.
1088     function() public payable { 
1089         revert(); 
1090     }
1091     
1092     function mint(address _to, uint256 _tokenId) public onlyOwner {
1093         super._mint(_to, _tokenId);
1094     }
1095 
1096     function burn(uint256 _tokenId) public onlyOwner {
1097         super._burn(ownerOf(_tokenId), _tokenId);
1098     }
1099 
1100     function setTokenURI(uint256 _tokenId, string _uri) public onlyOwner {
1101         super._setTokenURI(_tokenId, _uri);
1102     }
1103 
1104     function _removeTokenFrom(address _from, uint256 _tokenId) public {
1105         super.removeTokenFrom(_from, _tokenId);
1106     }
1107 }
1108 
1109 contract Whitelist {
1110 
1111     address public owner;
1112     mapping(address => bool) public whitelistAdmins;
1113     mapping(address => bool) public whitelist;
1114 
1115     constructor () public {
1116         owner = msg.sender;
1117         whitelistAdmins[owner] = true;
1118     }
1119 
1120     modifier onlyOwner () {
1121         require(msg.sender == owner, "Only owner");
1122         _;
1123     }
1124 
1125     modifier onlyWhitelistAdmin () {
1126         require(whitelistAdmins[msg.sender], "Only whitelist admin");
1127         _;
1128     }
1129 
1130     function isWhitelisted(address _addr) public view returns (bool) {
1131         return whitelist[_addr];
1132     }
1133 
1134     function addWhitelistAdmin(address _admin) public onlyOwner {
1135         whitelistAdmins[_admin] = true;
1136     }
1137 
1138     function removeWhitelistAdmin(address _admin) public onlyOwner {
1139         require(_admin != owner, "Cannot remove contract owner");
1140         whitelistAdmins[_admin] = false;
1141     }
1142 
1143     function whitelistAddress(address _user) public onlyWhitelistAdmin  {
1144         whitelist[_user] = true;
1145     }
1146 
1147     function whitelistAddresses(address[] _users) public onlyWhitelistAdmin {
1148         for (uint256 i = 0; i < _users.length; i++) {
1149             whitelist[_users[i]] = true;
1150         }
1151     }
1152 
1153     function unWhitelistAddress(address _user) public onlyWhitelistAdmin  {
1154         whitelist[_user] = false;
1155     }
1156 
1157     function unWhitelistAddresses(address[] _users) public onlyWhitelistAdmin {
1158         for (uint256 i = 0; i < _users.length; i++) {
1159             whitelist[_users[i]] = false;
1160         }
1161     }
1162 
1163 }
1164 
1165 contract Sale1 is Whitelist {
1166     
1167     using SafeMath for uint256;
1168 
1169     uint256 public maximumNonWhitelistAmount = 5000 * 50 ether; // in minimum units of rune
1170 
1171     // in minimum units of rune (1000 = 0.000000000000001000 RUNE per WEI)
1172     // note that this only works if the amount of rune per wei is more than 1
1173     uint256 public runeToWeiRatio = 5000;
1174     bool public withdrawalsAllowed = false;
1175     bool public tokensWithdrawn = false;
1176     address public owner;
1177     address public proceedsAddress = 0xd46cac034f44ac93049f8f1109b6b74f79b3e5e6;
1178     RUNEToken public RuneToken = RUNEToken(0xdEE02D94be4929d26f67B64Ada7aCf1914007F10);
1179     Whitelist public WhitelistContract = Whitelist(0x395Eb47d46F7fFa7Dd4b27e1B64FC6F21d5CC4C7);
1180     THORChain721 public ERC721Token = THORChain721(0x52A9700551128585f0d68B6D4D2FA322a2AeeE47);
1181 
1182     uint256 public CollectibleIndex0 = 0;
1183     uint256 public CollectibleIndex1 = 1;
1184     uint256 public CollectibleIndex2 = 2;
1185     uint256 public CollectibleIndex3 = 3;
1186     uint256 public CollectibleIndex4 = 4;
1187     uint256 public CollectibleIndex5 = 5;
1188 
1189     uint public winAmount0 = 1666.666666666666666667 ether;
1190     uint public winAmount1 = 3333.333333333333333333 ether;
1191     uint public winAmount2 = 5000.0 ether;
1192     uint public winAmount3 = 6666.666666666666666667 ether;
1193     uint public winAmount4 = 8333.333333333333333333 ether;
1194     uint public winAmount5 = 10000.0 ether;
1195 
1196     mapping (uint256 => address) public collectibleAllocation;
1197     mapping (address => uint256) public runeAllocation;
1198 
1199     uint256 public totalRunePurchased;
1200     uint256 public totalRuneWithdrawn;
1201 
1202     event TokenWon(uint256 tokenId, address winner);
1203 
1204     modifier onlyOwner () {
1205         require(owner == msg.sender, "Only the owner can use this function");
1206         _;
1207     }
1208 
1209     constructor () public {
1210         owner = msg.sender;
1211     }
1212 
1213     function () public payable {
1214         require(!tokensWithdrawn, "Tokens withdrawn. No more purchases possible.");
1215         // Make sure we have enough tokens to sell
1216         uint runeRemaining = (RuneToken.balanceOf(this).add(totalRuneWithdrawn)).sub(totalRunePurchased);
1217         uint toForward = msg.value;
1218         uint weiToReturn = 0;
1219         uint purchaseAmount = msg.value * runeToWeiRatio;
1220         if(runeRemaining < purchaseAmount) {
1221             purchaseAmount = runeRemaining;
1222             uint price = purchaseAmount.div(runeToWeiRatio);
1223             weiToReturn = msg.value.sub(price);
1224             toForward = toForward.sub(weiToReturn);
1225         }
1226 
1227         // Assign NFTs
1228         uint ethBefore = totalRunePurchased.div(runeToWeiRatio);
1229         uint ethAfter = ethBefore.add(toForward);
1230 
1231         if(ethBefore <= winAmount0 && ethAfter > winAmount0) {
1232             collectibleAllocation[CollectibleIndex0] = msg.sender;
1233             emit TokenWon(CollectibleIndex0, msg.sender);
1234         } if(ethBefore < winAmount1 && ethAfter >= winAmount1) {
1235             collectibleAllocation[CollectibleIndex1] = msg.sender;
1236             emit TokenWon(CollectibleIndex1, msg.sender);
1237         } if(ethBefore < winAmount2 && ethAfter >= winAmount2) {
1238             collectibleAllocation[CollectibleIndex2] = msg.sender;
1239             emit TokenWon(CollectibleIndex2, msg.sender);
1240         } if(ethBefore < winAmount3 && ethAfter >= winAmount3) {
1241             collectibleAllocation[CollectibleIndex3] = msg.sender;
1242             emit TokenWon(CollectibleIndex3, msg.sender);
1243         } if(ethBefore < winAmount4 && ethAfter >= winAmount4) {
1244             collectibleAllocation[CollectibleIndex4] = msg.sender;
1245             emit TokenWon(CollectibleIndex4, msg.sender);
1246         } if(ethBefore < winAmount5 && ethAfter >= winAmount5) {
1247             collectibleAllocation[CollectibleIndex5] = msg.sender;
1248             emit TokenWon(CollectibleIndex5, msg.sender);
1249         } 
1250 
1251         runeAllocation[msg.sender] = runeAllocation[msg.sender].add(purchaseAmount);
1252         totalRunePurchased = totalRunePurchased.add(purchaseAmount);
1253         // Withdraw  ETH 
1254         proceedsAddress.transfer(toForward);
1255         if(weiToReturn > 0) {
1256             address(msg.sender).transfer(weiToReturn);
1257         }
1258     }
1259 
1260     function setMaximumNonWhitelistAmount (uint256 _newAmount) public onlyOwner {
1261         maximumNonWhitelistAmount = _newAmount;
1262     }
1263 
1264     function withdrawRune () public {
1265         require(withdrawalsAllowed, "Withdrawals are not allowed.");
1266         uint256 runeToWithdraw;
1267         if (WhitelistContract.isWhitelisted(msg.sender)) {
1268             runeToWithdraw = runeAllocation[msg.sender];
1269         } else {
1270             runeToWithdraw = (
1271                 runeAllocation[msg.sender] > maximumNonWhitelistAmount
1272             ) ? maximumNonWhitelistAmount : runeAllocation[msg.sender];
1273         }
1274 
1275         runeAllocation[msg.sender] = runeAllocation[msg.sender].sub(runeToWithdraw);
1276         totalRuneWithdrawn = totalRuneWithdrawn.add(runeToWithdraw);
1277         RuneToken.transfer(msg.sender, runeToWithdraw); // ERC20 method
1278         distributeCollectiblesTo(msg.sender);
1279     }
1280 
1281     function ownerWithdrawRune () public onlyOwner {
1282         tokensWithdrawn = true;
1283         RuneToken.transfer(owner, RuneToken.balanceOf(this).sub(totalRunePurchased.sub(totalRuneWithdrawn)));
1284     }
1285 
1286     function allowWithdrawals () public onlyOwner {
1287         withdrawalsAllowed = true;
1288     }
1289 
1290     function distributeTo (address _receiver) public onlyOwner {
1291         require(runeAllocation[_receiver] > 0, "Receiver has not purchased any RUNE.");
1292         uint balance = runeAllocation[_receiver];
1293         delete runeAllocation[_receiver];
1294         RuneToken.transfer(_receiver, balance);
1295         distributeCollectiblesTo(_receiver);
1296     }
1297 
1298     function distributeCollectiblesTo (address _receiver) internal {
1299         if(collectibleAllocation[CollectibleIndex0] == _receiver) {
1300             delete collectibleAllocation[CollectibleIndex0];
1301             ERC721Token.safeTransferFrom(owner, _receiver, CollectibleIndex0);
1302         } 
1303         if(collectibleAllocation[CollectibleIndex1] == _receiver) {
1304             delete collectibleAllocation[CollectibleIndex1];
1305             ERC721Token.safeTransferFrom(owner, _receiver, CollectibleIndex1);
1306         } 
1307         if(collectibleAllocation[CollectibleIndex2] == _receiver) {
1308             delete collectibleAllocation[CollectibleIndex2];
1309             ERC721Token.safeTransferFrom(owner, _receiver, CollectibleIndex2);
1310         } 
1311         if(collectibleAllocation[CollectibleIndex3] == _receiver) {
1312             delete collectibleAllocation[CollectibleIndex3];
1313             ERC721Token.safeTransferFrom(owner, _receiver, CollectibleIndex3);
1314         } 
1315         if(collectibleAllocation[CollectibleIndex4] == _receiver) {
1316             delete collectibleAllocation[CollectibleIndex4];
1317             ERC721Token.safeTransferFrom(owner, _receiver, CollectibleIndex4);
1318         } 
1319         if(collectibleAllocation[CollectibleIndex5] == _receiver) {
1320             delete collectibleAllocation[CollectibleIndex5];
1321             ERC721Token.safeTransferFrom(owner, _receiver, CollectibleIndex5);
1322         }
1323     }
1324 }