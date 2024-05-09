1 pragma solidity ^0.4.11;
2 
3 interface CommonWallet {
4     function receive() external payable;
5 }
6 
7 library StringUtils {
8     function concat(string _a, string _b)
9         internal
10         pure
11         returns (string)
12     {
13         bytes memory _ba = bytes(_a);
14         bytes memory _bb = bytes(_b);
15 
16         bytes memory bab = new bytes(_ba.length + _bb.length);
17         uint k = 0;
18         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
19         for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
20         return string(bab);
21     }
22 }
23 
24 library UintStringUtils {
25     function toString(uint i)
26         internal
27         pure
28         returns (string)
29     {
30         if (i == 0) return '0';
31         uint j = i;
32         uint len;
33         while (j != 0){
34             len++;
35             j /= 10;
36         }
37         bytes memory bstr = new bytes(len);
38         uint k = len - 1;
39         while (i != 0){
40             bstr[k--] = byte(48 + i % 10);
41             i /= 10;
42         }
43         return string(bstr);
44     }
45 }
46 
47 // @title AddressUtils
48 // @dev Utility library of inline functions on addresses
49 library AddressUtils {
50     // Returns whether the target address is a contract
51     // @dev This function will return false if invoked during the constructor of a contract,
52     // as the code is not actually created until after the constructor finishes.
53     // @param addr address to check
54     // @return whether the target address is a contract
55     function isContract(address addr)
56         internal
57         view
58         returns(bool)
59     {
60         uint256 size;
61         // XXX Currently there is no better way to check if there is a contract in an address
62         // than to check the size of the code at that address.
63         // See https://ethereum.stackexchange.com/a/14016/36603
64         // for more details about how this works.
65         // TODO Check this again before the Serenity release, because all addresses will be
66         // contracts then.
67         // solium-disable-next-line security/no-inline-assembly
68         assembly { size := extcodesize(addr) }
69         return size > 0;
70     }
71 }
72 
73  // @title SafeMath256
74  // @dev Math operations with safety checks that throw on error
75 library SafeMath256 {
76 
77   // @dev Multiplies two numbers, throws on overflow.
78   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
79     if (a == 0) {
80       return 0;
81     }
82     c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   // @dev Integer division of two numbers, truncating the quotient.
88   function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     // assert(b > 0); // Solidity automatically throws when dividing by 0
90     // uint256 c = a / b;
91     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92     return a / b;
93   }
94 
95 
96   // @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102 
103   // @dev Adds two numbers, throws on overflow.
104   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
105     c = a + b;
106     assert(c >= a);
107     return c;
108   }
109 }
110 
111 library SafeMath32 {
112   // @dev Multiplies two numbers, throws on overflow.
113   function mul(uint32 a, uint32 b) internal pure returns (uint32 c) {
114     if (a == 0) {
115       return 0;
116     }
117     c = a * b;
118     assert(c / a == b);
119     return c;
120   }
121 
122 
123   // @dev Integer division of two numbers, truncating the quotient.
124   function div(uint32 a, uint32 b) internal pure returns (uint32) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     // uint32 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return a / b;
129   }
130 
131 
132   // @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
133   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
134     assert(b <= a);
135     return a - b;
136   }
137 
138 
139   // @dev Adds two numbers, throws on overflow.
140   function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
141     c = a + b;
142     assert(c >= a);
143     return c;
144   }
145 }
146 
147 library SafeMath8 {
148   // @dev Multiplies two numbers, throws on overflow.
149   function mul(uint8 a, uint8 b) internal pure returns (uint8 c) {
150     if (a == 0) {
151       return 0;
152     }
153     c = a * b;
154     assert(c / a == b);
155     return c;
156   }
157 
158 
159   // @dev Integer division of two numbers, truncating the quotient.
160   function div(uint8 a, uint8 b) internal pure returns (uint8) {
161     // assert(b > 0); // Solidity automatically throws when dividing by 0
162     // uint8 c = a / b;
163     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
164     return a / b;
165   }
166 
167 
168   // @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
169   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
170     assert(b <= a);
171     return a - b;
172   }
173 
174 
175   // @dev Adds two numbers, throws on overflow.
176   function add(uint8 a, uint8 b) internal pure returns (uint8 c) {
177     c = a + b;
178     assert(c >= a);
179     return c;
180   }
181 }
182 
183 /// @title A facet of DragonCore that manages special access privileges.
184 contract DragonAccessControl 
185 {
186     // @dev Non Assigned address.
187     address constant NA = address(0);
188 
189     /// @dev Contract owner
190     address internal controller_;
191 
192     /// @dev Contract modes
193     enum Mode {TEST, PRESALE, OPERATE}
194 
195     /// @dev Contract state
196     Mode internal mode_ = Mode.TEST;
197 
198     /// @dev OffChain Server accounts ('minions') addresses
199     /// It's used for money withdrawal and export of tokens 
200     mapping(address => bool) internal minions_;
201     
202     /// @dev Presale contract address. Can call `presale` method.
203     address internal presale_;
204 
205     // Modifiers ---------------------------------------------------------------
206     /// @dev Limit execution to controller account only.
207     modifier controllerOnly() {
208         require(controller_ == msg.sender, "controller_only");
209         _;
210     }
211 
212     /// @dev Limit execution to minion account only.
213     modifier minionOnly() {
214         require(minions_[msg.sender], "minion_only");
215         _;
216     }
217 
218     /// @dev Limit execution to test time only.
219     modifier testModeOnly {
220         require(mode_ == Mode.TEST, "test_mode_only");
221         _;
222     }
223 
224     /// @dev Limit execution to presale time only.
225     modifier presaleModeOnly {
226         require(mode_ == Mode.PRESALE, "presale_mode_only");
227         _;
228     }
229 
230     /// @dev Limit execution to operate time only.
231     modifier operateModeOnly {
232         require(mode_ == Mode.OPERATE, "operate_mode_only");
233         _;
234     }
235 
236      /// @dev Limit execution to presale account only.
237     modifier presaleOnly() {
238         require(msg.sender == presale_, "presale_only");
239         _;
240     }
241 
242     /// @dev set state to Mode.OPERATE.
243     function setOperateMode()
244         external 
245         controllerOnly
246         presaleModeOnly
247     {
248         mode_ = Mode.OPERATE;
249     }
250 
251     /// @dev Set presale contract address. Becomes useless when presale is over.
252     /// @param _presale Presale contract address.
253     function setPresale(address _presale)
254         external
255         controllerOnly
256     {
257         presale_ = _presale;
258     }
259 
260     /// @dev set state to Mode.PRESALE.
261     function setPresaleMode()
262         external
263         controllerOnly
264         testModeOnly
265     {
266         mode_ = Mode.PRESALE;
267     }    
268 
269         /// @dev Get controller address.
270     /// @return Address of contract's controller.
271     function controller()
272         external
273         view
274         returns(address)
275     {
276         return controller_;
277     }
278 
279     /// @dev Transfer control to new address. Set controller an approvee for
280     /// tokens that managed by contract itself. Remove previous controller value
281     /// from contract's approvees.
282     /// @param _to New controller address.
283     function setController(address _to)
284         external
285         controllerOnly
286     {
287         require(_to != NA, "_to");
288         require(controller_ != _to, "already_controller");
289 
290         controller_ = _to;
291     }
292 
293     /// @dev Check if address is a minion.
294     /// @param _addr Address to check.
295     /// @return True if address is a minion.
296     function isMinion(address _addr)
297         public view returns(bool)
298     {
299         return minions_[_addr];
300     }   
301 
302     function getCurrentMode() 
303         public view returns (Mode) 
304     {
305         return mode_;
306     }    
307 }
308 
309 /// @dev token description, storage and transfer functions
310 contract DragonBase is DragonAccessControl
311 {
312     using SafeMath8 for uint8;
313     using SafeMath32 for uint32;
314     using SafeMath256 for uint256;
315     using StringUtils for string;
316     using UintStringUtils for uint;    
317 
318     /// @dev The Birth event is fired whenever a new dragon comes into existence. 
319     event Birth(address owner, uint256 petId, uint256 tokenId, uint256 parentA, uint256 parentB, string genes, string params);
320 
321     /// @dev Token name
322     string internal name_;
323     /// @dev Token symbol
324     string internal symbol_;
325     /// @dev Token resolving url
326     string internal url_;
327 
328     struct DragonToken {
329         // Constant Token params
330         uint8   genNum;  // generation number. uses for dragon view
331         string  genome;  // genome description
332         uint256 petId;   // offchain dragon identifier
333 
334         // Parents
335         uint256 parentA;
336         uint256 parentB;
337 
338         // Game-depening Token params
339         string  params;  // can change in export operation
340 
341         // State
342         address owner; 
343     }
344 
345     /// @dev Count of minted tokens
346     uint256 internal mintCount_;
347     /// @dev Maximum token supply
348     uint256 internal maxSupply_;
349      /// @dev Count of burn tokens
350     uint256 internal burnCount_;
351 
352     // Tokens state
353     /// @dev Token approvals values
354     mapping(uint256 => address) internal approvals_;
355     /// @dev Operator approvals
356     mapping(address => mapping(address => bool)) internal operatorApprovals_;
357     /// @dev Index of token in owner's token list
358     mapping(uint256 => uint256) internal ownerIndex_;
359     /// @dev Owner's tokens list
360     mapping(address => uint256[]) internal ownTokens_;
361     /// @dev Tokens
362     mapping(uint256 => DragonToken) internal tokens_;
363 
364     // @dev Non Assigned address.
365     address constant NA = address(0);
366 
367     /// @dev Add token to new owner. Increase owner's balance.
368     /// @param _to Token receiver.
369     /// @param _tokenId New token id.
370     function _addTo(address _to, uint256 _tokenId)
371         internal
372     {
373         DragonToken storage token = tokens_[_tokenId];
374         require(token.owner == NA, "taken");
375 
376         uint256 lastIndex = ownTokens_[_to].length;
377         ownTokens_[_to].push(_tokenId);
378         ownerIndex_[_tokenId] = lastIndex;
379 
380         token.owner = _to;
381     }
382 
383     /// @dev Create new token and increase mintCount.
384     /// @param _genome New token's genome.
385     /// @param _params Token params string. 
386     /// @param _parentA Token A parent.
387     /// @param _parentB Token B parent.
388     /// @return New token id.
389     function _createToken(
390         address _to,
391         
392         // Constant Token params
393         uint8   _genNum,
394         string   _genome,
395         uint256 _parentA,
396         uint256 _parentB,
397         
398         // Game-depening Token params
399         uint256 _petId,
400         string   _params        
401     )
402         internal returns(uint256)
403     {
404         uint256 tokenId = mintCount_.add(1);
405         mintCount_ = tokenId;
406 
407         DragonToken memory token = DragonToken(
408             _genNum,
409             _genome,
410             _petId,
411 
412             _parentA,
413             _parentB,
414 
415             _params,
416             NA
417         );
418         
419         tokens_[tokenId] = token;
420         
421         _addTo(_to, tokenId);
422         
423         emit Birth(_to, _petId, tokenId, _parentA, _parentB, _genome, _params);
424         
425         return tokenId;
426     }    
427  
428     /// @dev Get token genome.
429     /// @param _tokenId Token id.
430     /// @return Token's genome.
431     function getGenome(uint256 _tokenId)
432         external view returns(string)
433     {
434         return tokens_[_tokenId].genome;
435     }
436 
437     /// @dev Get token params.
438     /// @param _tokenId Token id.
439     /// @return Token's params.
440     function getParams(uint256 _tokenId)
441         external view returns(string)
442     {
443         return tokens_[_tokenId].params;
444     }
445 
446     /// @dev Get token parentA.
447     /// @param _tokenId Token id.
448     /// @return Parent token id.
449     function getParentA(uint256 _tokenId)
450         external view returns(uint256)
451     {
452         return tokens_[_tokenId].parentA;
453     }   
454 
455     /// @dev Get token parentB.
456     /// @param _tokenId Token id.
457     /// @return Parent token id.
458     function getParentB(uint256 _tokenId)
459         external view returns(uint256)
460     {
461         return tokens_[_tokenId].parentB;
462     }
463 
464     /// @dev Check if `_tokenId` exists. Check if owner is not addres(0).
465     /// @param _tokenId Token id
466     /// @return Return true if token owner is real.
467     function isExisting(uint256 _tokenId)
468         public view returns(bool)
469     {
470         return tokens_[_tokenId].owner != NA;
471     }    
472 
473     /// @dev Receive maxium token supply value.
474     /// @return Contracts `maxSupply_` variable.
475     function maxSupply()
476         external view returns(uint256)
477     {
478         return maxSupply_;
479     }
480 
481     /// @dev Set url prefix for tokenURI generation.
482     /// @param _url Url prefix value.
483     function setUrl(string _url)
484         external controllerOnly
485     {
486         url_ = _url;
487     }
488 
489     /// @dev Get token symbol.
490     /// @return Token symbol name.
491     function symbol()
492         external view returns(string)
493     {
494         return symbol_;
495     }
496 
497     /// @dev Get token URI to receive offchain information by it's id.
498     /// @param _tokenId Token id.
499     /// @return URL string. For example "http://erc721.tld/tokens/1".
500     function tokenURI(uint256 _tokenId)
501         external view returns(string)
502     {
503         return url_.concat(_tokenId.toString());
504     }
505 
506      /// @dev Get token name.
507     /// @return Token name string.
508     function name()
509         external view returns(string)
510     {
511         return name_;
512     }
513 
514     /// @dev return information about _owner tokens
515     function getTokens(address _owner)
516         external view  returns (uint256[], uint256[], byte[]) 
517     {
518         uint256[] memory tokens = ownTokens_[_owner];
519         uint256[] memory tokenIds = new uint256[](tokens.length);
520         uint256[] memory petIds = new uint256[](tokens.length);
521 
522         byte[] memory genomes = new byte[](tokens.length * 77);
523         uint index = 0;
524 
525         for(uint i = 0; i < tokens.length; i++) {
526             uint256 tokenId = tokens[i];
527             
528             DragonToken storage token = tokens_[tokenId];
529 
530             tokenIds[i] = tokenId;
531             petIds[i] = token.petId;
532             
533             bytes storage genome = bytes(token.genome);
534             
535             for(uint j = 0; j < genome.length; j++) {
536                 genomes[index++] = genome[j];
537             }
538         }
539         return (tokenIds, petIds, genomes);
540     }
541     
542 }
543 
544 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
545 /// @dev See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC721/ERC721.sol
546 
547 contract ERC721Basic 
548 {
549     /// @dev Emitted when token approvee is set
550     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
551     /// @dev Emitted when owner approve all own tokens to operator.
552     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
553     /// @dev Emitted when user deposit some funds.
554     event Deposit(address indexed _sender, uint256 _value);
555     /// @dev Emitted when user deposit some funds.
556     event Withdraw(address indexed _sender, uint256 _value);
557     /// @dev Emitted when token transferred to new owner
558     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
559 
560     // Required methods
561     function balanceOf(address _owner) external view returns (uint256 _balance);
562     function ownerOf(uint256 _tokenId) public view returns (address _owner);
563     function exists(uint256 _tokenId) public view returns (bool _exists);
564     
565     function approve(address _to, uint256 _tokenId) external;
566     function getApproved(uint256 _tokenId) public view returns (address _to);
567 
568     //function transfer(address _to, uint256 _tokenId) public;
569     function transferFrom(address _from, address _to, uint256 _tokenId) public;
570 
571     function totalSupply() public view returns (uint256 total);
572 
573     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
574     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
575 }
576 
577 /**
578  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
579  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
580  */
581 contract ERC721Metadata is ERC721Basic 
582 {
583     function name() external view returns (string _name);
584     function symbol() external view returns (string _symbol);
585     function tokenURI(uint256 _tokenId) external view returns (string);
586 }
587 
588 
589 /**
590  * @title ERC721 token receiver interface
591  * @dev Interface for any contract that wants to support safeTransfers
592  *  from ERC721 asset contracts.
593  */
594 contract ERC721Receiver 
595 {
596   /**
597    * @dev Magic value to be returned upon successful reception of an NFT
598    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
599    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
600    */
601     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
602 
603   /**
604    * @notice Handle the receipt of an NFT
605    * @dev The ERC721 smart contract calls this function on the recipient
606    *  after a `safetransfer`. This function MAY throw to revert and reject the
607    *  transfer. This function MUST use 50,000 gas or less. Return of other
608    *  than the magic value MUST result in the transaction being reverted.
609    *  Note: the contract address is always the message sender.
610    * @param _from The sending address
611    * @param _tokenId The NFT identifier which is being transfered
612    * @param _data Additional data with no specified format
613    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
614    */
615     function onERC721Received(address _from, uint256 _tokenId, bytes _data )
616         public returns(bytes4);
617 }
618 
619 /**
620  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
621  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
622  */
623 contract ERC721 is ERC721Basic, ERC721Metadata, ERC721Receiver 
624 {
625     /// @dev Interface signature 721 for interface detection.
626     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
627 
628     bytes4 constant InterfaceSignature_ERC165 = 0x01ffc9a7;
629     /*
630     bytes4(keccak256('supportsInterface(bytes4)'));
631     */
632 
633     bytes4 constant InterfaceSignature_ERC721Enumerable = 0x780e9d63;
634     /*
635     bytes4(keccak256('totalSupply()')) ^
636     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
637     bytes4(keccak256('tokenByIndex(uint256)'));
638     */
639 
640     bytes4 constant InterfaceSignature_ERC721Metadata = 0x5b5e139f;
641     /*
642     bytes4(keccak256('name()')) ^
643     bytes4(keccak256('symbol()')) ^
644     bytes4(keccak256('tokenURI(uint256)'));
645     */
646 
647     bytes4 constant InterfaceSignature_ERC721 = 0x80ac58cd;
648     /*
649     bytes4(keccak256('balanceOf(address)')) ^
650     bytes4(keccak256('ownerOf(uint256)')) ^
651     bytes4(keccak256('approve(address,uint256)')) ^
652     bytes4(keccak256('getApproved(uint256)')) ^
653     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
654     bytes4(keccak256('isApprovedForAll(address,address)')) ^
655     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
656     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
657     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'));
658     */
659 
660     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
661     {
662         return ((_interfaceID == InterfaceSignature_ERC165)
663             || (_interfaceID == InterfaceSignature_ERC721)
664             || (_interfaceID == InterfaceSignature_ERC721Enumerable)
665             || (_interfaceID == InterfaceSignature_ERC721Metadata));
666     }    
667 }
668 
669 /// @dev ERC721 methods
670 contract DragonOwnership is ERC721, DragonBase
671 {
672     using StringUtils for string;
673     using UintStringUtils for uint;    
674     using AddressUtils for address;
675 
676     /// @dev Emitted when token transferred to new owner. Additional fields is petId, genes, params
677     /// it uses for client-side indication
678     event TransferInfo(address indexed _from, address indexed _to, uint256 _tokenId, uint256 petId, string genes, string params);
679 
680     /// @dev Specify if _addr is token owner or approvee. Also check if `_addr`
681     /// is operator for token owner.
682     /// @param _tokenId Token to check ownership of.
683     /// @param _addr Address to check if it's an owner or an aprovee of `_tokenId`.
684     /// @return True if token can be managed by provided `_addr`.
685     function isOwnerOrApproved(uint256 _tokenId, address _addr)
686         public view returns(bool)
687     {
688         DragonToken memory token = tokens_[_tokenId];
689 
690         if (token.owner == _addr) {
691             return true;
692         }
693         else if (isApprovedFor(_tokenId, _addr)) {
694             return true;
695         }
696         else if (isApprovedForAll(token.owner, _addr)) {
697             return true;
698         }
699 
700         return false;
701     }
702 
703     /// @dev Limit execution to token owner or approvee only.
704     /// @param _tokenId Token to check ownership of.
705     modifier ownerOrApprovedOnly(uint256 _tokenId) {
706         require(isOwnerOrApproved(_tokenId, msg.sender), "tokenOwnerOrApproved_only");
707         _;
708     }
709 
710     /// @dev Contract's own token only acceptable.
711     /// @param _tokenId Contract's token id.
712     modifier ownOnly(uint256 _tokenId) {
713         require(tokens_[_tokenId].owner == address(this), "own_only");
714         _;
715     }
716 
717     /// @dev Determine if token is approved for specified approvee.
718     /// @param _tokenId Target token id.
719     /// @param _approvee Approvee address.
720     /// @return True if so.
721     function isApprovedFor(uint256 _tokenId, address _approvee)
722         public view returns(bool)
723     {
724         return approvals_[_tokenId] == _approvee;
725     }
726 
727     /// @dev Specify is given address set as operator with setApprovalForAll.
728     /// @param _owner Token owner.
729     /// @param _operator Address to check if it an operator.
730     /// @return True if operator is set.
731     function isApprovedForAll(address _owner, address _operator)
732         public view returns(bool)
733     {
734         return operatorApprovals_[_owner][_operator];
735     }
736 
737     /// @dev Check if `_tokenId` exists. Check if owner is not addres(0).
738     /// @param _tokenId Token id
739     /// @return Return true if token owner is real.
740     function exists(uint256 _tokenId)
741         public view returns(bool)
742     {
743         return tokens_[_tokenId].owner != NA;
744     }
745 
746     /// @dev Get owner of a token.
747     /// @param _tokenId Token owner id.
748     /// @return Token owner address.
749     function ownerOf(uint256 _tokenId)
750         public view returns(address)
751     {
752         return tokens_[_tokenId].owner;
753     }
754 
755     /// @dev Get approvee address. If there is not approvee returns 0x0.
756     /// @param _tokenId Token id to get approvee of.
757     /// @return Approvee address or 0x0.
758     function getApproved(uint256 _tokenId)
759         public view returns(address)
760     {
761         return approvals_[_tokenId];
762     }
763 
764     /// @dev Grant owner alike controll permissions to third party.
765     /// @param _to Permission receiver.
766     /// @param _tokenId Granted token id.
767     function approve(address _to, uint256 _tokenId)
768         external ownerOrApprovedOnly(_tokenId)
769     {
770         address owner = ownerOf(_tokenId);
771         require(_to != owner);
772 
773         if (getApproved(_tokenId) != NA || _to != NA) {
774             approvals_[_tokenId] = _to;
775 
776             emit Approval(owner, _to, _tokenId);
777         }
778     }
779 
780     /// @dev Current total tokens supply. Always less then maxSupply.
781     /// @return Difference between minted and burned tokens.
782     function totalSupply()
783         public view returns(uint256)
784     {
785         return mintCount_;
786     }    
787 
788     /// @dev Get number of tokens which `_owner` owns.
789     /// @param _owner Address to count own tokens.
790     /// @return Count of owned tokens.
791     function balanceOf(address _owner)
792         external view returns(uint256)
793     {
794         return ownTokens_[_owner].length;
795     }    
796 
797     /// @dev Internal set approval for all without _owner check.
798     /// @param _owner Granting user.
799     /// @param _to New account approvee.
800     /// @param _approved Set new approvee status.
801     function _setApprovalForAll(address _owner, address _to, bool _approved)
802         internal
803     {
804         operatorApprovals_[_owner][_to] = _approved;
805 
806         emit ApprovalForAll(_owner, _to, _approved);
807     }
808 
809     /// @dev Set approval for all account tokens.
810     /// @param _to Approvee address.
811     /// @param _approved Value true or false.
812     function setApprovalForAll(address _to, bool _approved)
813         external
814     {
815         require(_to != msg.sender);
816 
817         _setApprovalForAll(msg.sender, _to, _approved);
818     }
819 
820     /// @dev Remove approval bindings for token. Do nothing if no approval
821     /// exists.
822     /// @param _from Address of token owner.
823     /// @param _tokenId Target token id.
824     function _clearApproval(address _from, uint256 _tokenId)
825         internal
826     {
827         if (approvals_[_tokenId] == NA) {
828             return;
829         }
830 
831         approvals_[_tokenId] = NA;
832         emit Approval(_from, NA, _tokenId);
833     }
834 
835     /// @dev Check if contract was received by other side properly if receiver
836     /// is a ctontract.
837     /// @param _from Current token owner.
838     /// @param _to New token owner.
839     /// @param _tokenId token Id.
840     /// @param _data Transaction data.
841     /// @return True on success.
842     function _checkAndCallSafeTransfer(
843         address _from,
844         address _to,
845         uint256 _tokenId,
846         bytes _data
847     )
848         internal returns(bool)
849     {
850         if (! _to.isContract()) {
851             return true;
852         }
853 
854         bytes4 retval = ERC721Receiver(_to).onERC721Received(
855             _from, _tokenId, _data
856         );
857 
858         return (retval == ERC721_RECEIVED);
859     }
860 
861     /// @dev Remove token from owner. Unrecoverable.
862     /// @param _tokenId Removing token id.
863     function _remove(uint256 _tokenId)
864         internal
865     {
866         address owner = tokens_[_tokenId].owner;
867         _removeFrom(owner, _tokenId);
868     }
869 
870     /// @dev Completely remove token from the contract. Unrecoverable.
871     /// @param _owner Owner of removing token.
872     /// @param _tokenId Removing token id.
873     function _removeFrom(address _owner, uint256 _tokenId)
874         internal
875     {
876         uint256 lastIndex = ownTokens_[_owner].length.sub(1);
877         uint256 lastToken = ownTokens_[_owner][lastIndex];
878 
879         // Swap users token
880         ownTokens_[_owner][ownerIndex_[_tokenId]] = lastToken;
881         ownTokens_[_owner].length--;
882 
883         // Swap token indexes
884         ownerIndex_[lastToken] = ownerIndex_[_tokenId];
885         ownerIndex_[_tokenId] = 0;
886 
887         DragonToken storage token = tokens_[_tokenId];
888         token.owner = NA;
889     }
890 
891     /// @dev Transfer token from owner `_from` to another address or contract
892     /// `_to` by it's `_tokenId`.
893     /// @param _from Current token owner.
894     /// @param _to New token owner.
895     /// @param _tokenId token Id.
896     function transferFrom( address _from, address _to, uint256 _tokenId )
897         public ownerOrApprovedOnly(_tokenId)
898     {
899         require(_from != NA);
900         require(_to != NA);
901 
902         _clearApproval(_from, _tokenId);
903         _removeFrom(_from, _tokenId);
904         _addTo(_to, _tokenId);
905 
906         emit Transfer(_from, _to, _tokenId);
907 
908         DragonToken storage token = tokens_[_tokenId];
909         emit TransferInfo(_from, _to, _tokenId, token.petId, token.genome, token.params);
910     }
911 
912     /// @dev Update token params and transfer to new owner. Only contract's own
913     /// tokens could be updated. Also notifies receiver of the token.
914     /// @param _to Address to transfer token to.
915     /// @param _tokenId Id of token that should be transferred.
916     /// @param _params New token params.
917     function updateAndSafeTransferFrom(
918         address _to,
919         uint256 _tokenId,
920         string _params
921     )
922         public
923     {
924         updateAndSafeTransferFrom(_to, _tokenId, _params, "");
925     }
926 
927     /// @dev Update token params and transfer to new owner. Only contract's own
928     /// tokens could be updated. Also notifies receiver of the token and send
929     /// protion of _data to it.
930     /// @param _to Address to transfer token to.
931     /// @param _tokenId Id of token that should be transferred.
932     /// @param _params New token params.
933     /// @param _data Notification data.
934     function updateAndSafeTransferFrom(
935         address _to,
936         uint256 _tokenId,
937         string _params,
938         bytes _data
939     )
940         public
941     {
942         // Safe transfer from
943         updateAndTransferFrom(_to, _tokenId, _params, 0, 0);
944         require(_checkAndCallSafeTransfer(address(this), _to, _tokenId, _data));
945     }
946 
947     /// @dev Update token params and transfer to new owner. Only contract's own
948     /// tokens could be updated.
949     /// @param _to Address to transfer token to.
950     /// @param _tokenId Id of token that should be transferred.
951     /// @param _params New token params.
952     function updateAndTransferFrom(
953         address _to,
954         uint256 _tokenId,
955         string _params,
956         uint256 _petId, 
957         uint256 _transferCost
958     )
959         public
960         ownOnly(_tokenId)
961         minionOnly
962     {
963         require(bytes(_params).length > 0, "params_length");
964 
965         // Update
966         tokens_[_tokenId].params = _params;
967         if (tokens_[_tokenId].petId == 0 ) {
968             tokens_[_tokenId].petId = _petId;
969         }
970 
971         address from = tokens_[_tokenId].owner;
972 
973         // Transfer from
974         transferFrom(from, _to, _tokenId);
975 
976         // send to the server's wallet the transaction cost
977         // withdraw it from the balance of the contract. this amount must be withdrawn from the player
978         // on the side of the game server        
979         if (_transferCost > 0) {
980             msg.sender.transfer(_transferCost);
981         }
982     }
983 
984     /// @dev Transfer token from one owner to new one and check if it was
985     /// properly received if receiver is a contact.
986     /// @param _from Current token owner.
987     /// @param _to New token owner.
988     /// @param _tokenId token Id.
989     function safeTransferFrom(
990         address _from,
991         address _to,
992         uint256 _tokenId
993     )
994         public
995     {
996         safeTransferFrom(_from, _to, _tokenId, "");
997     }
998 
999     /// @dev Transfer token from one owner to new one and check if it was
1000     /// properly received if receiver is a contact.
1001     /// @param _from Current token owner.
1002     /// @param _to New token owner.
1003     /// @param _tokenId token Id.
1004     /// @param _data Transaction data.
1005     function safeTransferFrom(
1006         address _from,
1007         address _to,
1008         uint256 _tokenId,
1009         bytes _data
1010     )
1011         public
1012     {
1013         transferFrom(_from, _to, _tokenId);
1014         require(_checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
1015     }
1016 
1017     /// @dev Burn owned token. Increases `burnCount_` and decrease `totalSupply`
1018     /// value.
1019     /// @param _tokenId Id of burning token.
1020     function burn(uint256 _tokenId)
1021         public
1022         ownerOrApprovedOnly(_tokenId)
1023     {
1024         address owner = tokens_[_tokenId].owner;
1025         _remove(_tokenId);
1026 
1027         burnCount_ += 1;
1028 
1029         emit Transfer(owner, NA, _tokenId);
1030     }
1031 
1032     /// @dev Receive count of burned tokens. Should be greater than `totalSupply`
1033     /// but less than `mintCount`.
1034     /// @return Number of burned tokens
1035     function burnCount()
1036         external
1037         view
1038         returns(uint256)
1039     {
1040         return burnCount_;
1041     }
1042 
1043     function onERC721Received(address, uint256, bytes)
1044         public returns(bytes4) 
1045     {
1046         return ERC721_RECEIVED;
1047     }
1048 }
1049 
1050 
1051 
1052 /// @title Managing contract. implements the logic of buying tokens, depositing / withdrawing funds 
1053 /// to the project account and importing / exporting tokens
1054 contract EtherDragonsCore is DragonOwnership 
1055 {
1056     using SafeMath8 for uint8;
1057     using SafeMath32 for uint32;
1058     using SafeMath256 for uint256;
1059     using AddressUtils for address;
1060     using StringUtils for string;
1061     using UintStringUtils for uint;
1062 
1063     // @dev Non Assigned address.
1064     address constant NA = address(0);
1065 
1066     /// @dev Bounty tokens count limit
1067     uint256 public constant BOUNTY_LIMIT = 2500;
1068     /// @dev Presale tokens count limit
1069     uint256 public constant PRESALE_LIMIT = 7500;
1070     ///@dev Total gen0tokens generation limit
1071     uint256 public constant GEN0_CREATION_LIMIT = 90000;
1072     
1073     /// @dev Number of tokens minted in presale stage
1074     uint256 internal presaleCount_;  
1075     /// @dev Number of tokens minted for bounty campaign
1076     uint256 internal bountyCount_;
1077    
1078     ///@dev Company bank address
1079     address internal bank_;
1080 
1081     // Extension ---------------------------------------------------------------
1082 
1083     /// @dev Contract is not payable. To fullfil balance method `depositTo`
1084     /// should be used.
1085     function ()
1086         public payable
1087     {
1088         revert();
1089     }
1090 
1091     /// @dev amount on the account of the contract. This amount consists of deposits  from players and the system reserve for payment of transactions
1092     /// the player at any time to withdraw the amount corresponding to his account in the game, minus the cost of the transaction 
1093     function getBalance() 
1094         public view returns (uint256)
1095     {
1096         return address(this).balance;
1097     }    
1098 
1099     /// @dev at the moment of creation of the contract we transfer the address of the bank
1100     /// presell contract address set later
1101     constructor(
1102         address _bank
1103     )
1104         public
1105     {
1106         require(_bank != NA);
1107         
1108         controller_ = msg.sender;
1109         bank_ = _bank;
1110         
1111         // Meta
1112         name_ = "EtherDragons";
1113         symbol_ = "ED";
1114         url_ = "https://game.etherdragons.world/token/";
1115 
1116         // Token mint limit
1117         maxSupply_ = GEN0_CREATION_LIMIT + BOUNTY_LIMIT + PRESALE_LIMIT;
1118     }
1119 
1120     /// Number of tokens minted in presale stage
1121     function totalPresaleCount()
1122         public view returns(uint256)
1123     {
1124         return presaleCount_;
1125     }    
1126 
1127     /// @dev Number of tokens minted for bounty campaign
1128     function totalBountyCount()
1129         public view returns(uint256)
1130     {
1131         return bountyCount_;
1132     }    
1133     
1134     /// @dev Check if new token could be minted. Return true if count of minted
1135     /// tokens less than could be minted through contract deploy.
1136     /// Also, tokens can not be created more often than once in mintDelay_ minutes
1137     /// @return True if current count is less then maximum tokens available for now.
1138     function canMint()
1139         public view returns(bool)
1140     {
1141         return (mintCount_ + presaleCount_ + bountyCount_) < maxSupply_;
1142     }
1143 
1144     /// @dev Here we write the addresses of the wallets of the server from which it is accessed
1145     /// to contract methods.
1146     /// @param _to New minion address
1147     function minionAdd(address _to)
1148         external controllerOnly
1149     {
1150         require(minions_[_to] == false, "already_minion");
1151         
1152         // разрешаем этому адресу пользоваться токенами контакта
1153         // allow the address to use contract tokens 
1154         _setApprovalForAll(address(this), _to, true);
1155         
1156         minions_[_to] = true;
1157     }
1158 
1159     /// @dev delete the address of the server wallet
1160     /// @param _to Minion address
1161     function minionRemove(address _to)
1162         external controllerOnly
1163     {
1164         require(minions_[_to], "not_a_minion");
1165 
1166         // and forbid this wallet to use tokens of the contract
1167         _setApprovalForAll(address(this), _to, false);
1168         minions_[_to] = false;
1169     }
1170 
1171     /// @dev Here the player can put funds to the account of the contract
1172     /// and get the same amount of in-game currency
1173     /// the game server understands who puts money at the wallet address
1174     function depositTo()
1175         public payable
1176     {
1177         emit Deposit(msg.sender, msg.value);
1178     }    
1179     
1180     /// @dev Transfer amount of Ethers to specified receiver. Only owner can
1181     // call this method.
1182     /// @param _to Transfer receiver.
1183     /// @param _amount Transfer value.
1184     /// @param _transferCost Transfer cost.
1185     function transferAmount(address _to, uint256 _amount, uint256 _transferCost)
1186         external minionOnly
1187     {
1188         require((_amount + _transferCost) <= address(this).balance, "not enough money!");
1189         _to.transfer(_amount);
1190 
1191         // send to the wallet of the server the transfer cost
1192         // withdraw  it from the balance of the contract. this amount must be withdrawn from the player
1193         // on the side of the game server
1194         if (_transferCost > 0) {
1195             msg.sender.transfer(_transferCost);
1196         }
1197 
1198         emit Withdraw(_to, _amount);
1199     }        
1200 
1201    /// @dev Mint new token with specified params. Transfer `_fee` to the
1202     /// `bank`. 
1203     /// @param _to New token owner.
1204     /// @param _fee Transaction fee.
1205     /// @param _genNum Generation number..
1206     /// @param _genome New genome unique value.
1207     /// @param _parentA Parent A.
1208     /// @param _parentB Parent B.
1209     /// @param _petId Pet identifier.
1210     /// @param _params List of parameters for pet.
1211     /// @param _transferCost Transfer cost.
1212     /// @return New token id.
1213     function mintRelease(
1214         address _to,
1215         uint256 _fee,
1216         
1217         // Constant Token params
1218         uint8   _genNum,
1219         string   _genome,
1220         uint256 _parentA,
1221         uint256 _parentB,
1222         
1223         // Game-depening Token params
1224         uint256 _petId,  //if petID = 0, then it was created outside of the server
1225         string   _params,
1226         uint256 _transferCost
1227     )
1228         external minionOnly operateModeOnly returns(uint256)
1229     {
1230         require(canMint(), "can_mint");
1231         require(_to != NA, "_to");
1232         require((_fee + _transferCost) <= address(this).balance, "_fee");
1233         require(bytes(_params).length != 0, "params_length");
1234         require(bytes(_genome).length == 77, "genome_length");
1235         
1236         // Parents should be both 0 or both not.
1237         if (_parentA != 0 && _parentB != 0) {
1238             require(_parentA != _parentB, "same_parent");
1239         }
1240         else if (_parentA == 0 && _parentB != 0) {
1241             revert("parentA_empty");
1242         }
1243         else if (_parentB == 0 && _parentA != 0) {
1244             revert("parentB_empty");
1245         }
1246 
1247         uint256 tokenId = _createToken(_to, _genNum, _genome, _parentA, _parentB, _petId, _params);
1248 
1249         require(_checkAndCallSafeTransfer(NA, _to, tokenId, ""), "safe_transfer");
1250 
1251         // Transfer mint fee to the fund
1252         CommonWallet(bank_).receive.value(_fee)();
1253 
1254         emit Transfer(NA, _to, tokenId);
1255 
1256         // send to the server wallet server the transfer cost,
1257         // withdraw it from the balance of the contract. this amount must be withdrawn from the player
1258         // on the side of the game server
1259         if (_transferCost > 0) {
1260             msg.sender.transfer(_transferCost);
1261         }
1262 
1263         return tokenId;
1264     }
1265 
1266     /// @dev Create new token via presale state
1267     /// @param _to New token owner.
1268     /// @param _genome New genome unique value.
1269     /// @return New token id.
1270     /// at the pre-sale stage we sell the zero-generation pets, which have only a genome.
1271     /// other attributes of such a token get when importing to the server
1272     function mintPresell(address _to, string _genome)
1273         external presaleOnly presaleModeOnly returns(uint256)
1274     {
1275         require(presaleCount_ < PRESALE_LIMIT, "presale_limit");
1276 
1277         // у пресейл пета нет параметров. Их он получит после ввода в игру.
1278         uint256 tokenId = _createToken(_to, 0, _genome, 0, 0, 0, "");
1279         presaleCount_ += 1;
1280 
1281         require(_checkAndCallSafeTransfer(NA, _to, tokenId, ""), "safe_transfer");
1282 
1283         emit Transfer(NA, _to, tokenId);
1284         
1285         return tokenId;
1286     }    
1287     
1288     /// @dev Create new token for bounty activity
1289     /// @param _to New token owner.
1290     /// @return New token id.
1291     function mintBounty(address _to, string _genome)
1292         external controllerOnly returns(uint256)
1293     {
1294         require(bountyCount_ < BOUNTY_LIMIT, "bounty_limit");
1295 
1296         // bounty pet has no parameters. They will receive them after importing to the game.
1297         uint256 tokenId = _createToken(_to, 0, _genome, 0, 0, 0, "");
1298     
1299         bountyCount_ += 1;
1300         require(_checkAndCallSafeTransfer(NA, _to, tokenId, ""), "safe_transfer");
1301 
1302         emit Transfer(NA, _to, tokenId);
1303 
1304         return tokenId;
1305     }        
1306 }