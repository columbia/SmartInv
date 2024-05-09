1 pragma solidity ^0.4.11;
2 
3 
4 interface CommonWallet {
5     function receive() external payable;
6 }
7 
8 library StringUtils {
9     function concat(string _a, string _b)
10         internal
11         pure
12         returns (string)
13     {
14         bytes memory _ba = bytes(_a);
15         bytes memory _bb = bytes(_b);
16 
17         bytes memory bab = new bytes(_ba.length + _bb.length);
18         uint k = 0;
19         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
20         for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
21         return string(bab);
22     }
23 }
24 
25 library UintStringUtils {
26     function toString(uint i)
27         internal
28         pure
29         returns (string)
30     {
31         if (i == 0) return '0';
32         uint j = i;
33         uint len;
34         while (j != 0){
35             len++;
36             j /= 10;
37         }
38         bytes memory bstr = new bytes(len);
39         uint k = len - 1;
40         while (i != 0){
41             bstr[k--] = byte(48 + i % 10);
42             i /= 10;
43         }
44         return string(bstr);
45     }
46 }
47 
48 // @title AddressUtils
49 // @dev Utility library of inline functions on addresses
50 library AddressUtils {
51     // Returns whether the target address is a contract
52     // @dev This function will return false if invoked during the constructor of a contract,
53     // as the code is not actually created until after the constructor finishes.
54     // @param addr address to check
55     // @return whether the target address is a contract
56     function isContract(address addr)
57         internal
58         view
59         returns(bool)
60     {
61         uint256 size;
62         // XXX Currently there is no better way to check if there is a contract in an address
63         // than to check the size of the code at that address.
64         // See https://ethereum.stackexchange.com/a/14016/36603
65         // for more details about how this works.
66         // TODO Check this again before the Serenity release, because all addresses will be
67         // contracts then.
68         // solium-disable-next-line security/no-inline-assembly
69         assembly { size := extcodesize(addr) }
70         return size > 0;
71     }
72 }
73 
74  // @title SafeMath256
75  // @dev Math operations with safety checks that throw on error
76 library SafeMath256 {
77 
78   // @dev Multiplies two numbers, throws on overflow.
79   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
80     if (a == 0) {
81       return 0;
82     }
83     c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   // @dev Integer division of two numbers, truncating the quotient.
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     // uint256 c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93     return a / b;
94   }
95 
96 
97   // @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
98   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99     assert(b <= a);
100     return a - b;
101   }
102 
103 
104   // @dev Adds two numbers, throws on overflow.
105   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
106     c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 library SafeMath32 {
113   // @dev Multiplies two numbers, throws on overflow.
114   function mul(uint32 a, uint32 b) internal pure returns (uint32 c) {
115     if (a == 0) {
116       return 0;
117     }
118     c = a * b;
119     assert(c / a == b);
120     return c;
121   }
122 
123 
124   // @dev Integer division of two numbers, truncating the quotient.
125   function div(uint32 a, uint32 b) internal pure returns (uint32) {
126     // assert(b > 0); // Solidity automatically throws when dividing by 0
127     // uint32 c = a / b;
128     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
129     return a / b;
130   }
131 
132 
133   // @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
134   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
135     assert(b <= a);
136     return a - b;
137   }
138 
139 
140   // @dev Adds two numbers, throws on overflow.
141   function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
142     c = a + b;
143     assert(c >= a);
144     return c;
145   }
146 }
147 
148 library SafeMath8 {
149   // @dev Multiplies two numbers, throws on overflow.
150   function mul(uint8 a, uint8 b) internal pure returns (uint8 c) {
151     if (a == 0) {
152       return 0;
153     }
154     c = a * b;
155     assert(c / a == b);
156     return c;
157   }
158 
159 
160   // @dev Integer division of two numbers, truncating the quotient.
161   function div(uint8 a, uint8 b) internal pure returns (uint8) {
162     // assert(b > 0); // Solidity automatically throws when dividing by 0
163     // uint8 c = a / b;
164     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165     return a / b;
166   }
167 
168 
169   // @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
170   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
171     assert(b <= a);
172     return a - b;
173   }
174 
175 
176   // @dev Adds two numbers, throws on overflow.
177   function add(uint8 a, uint8 b) internal pure returns (uint8 c) {
178     c = a + b;
179     assert(c >= a);
180     return c;
181   }
182 }
183 
184 /// @title A facet of DragonCore that manages special access privileges.
185 contract DragonAccessControl 
186 {
187     // @dev Non Assigned address.
188     address constant NA = address(0);
189 
190     /// @dev Contract owner
191     address internal controller_;
192 
193     /// @dev Contract modes
194     enum Mode {TEST, PRESALE, OPERATE}
195 
196     /// @dev Contract state
197     Mode internal mode_ = Mode.TEST;
198 
199     /// @dev OffChain Server accounts ('minions') addresses
200     /// It's used for money withdrawal and export of tokens 
201     mapping(address => bool) internal minions_;
202     
203     /// @dev Presale contract address. Can call `presale` method.
204     address internal presale_;
205 
206     // Modifiers ---------------------------------------------------------------
207     /// @dev Limit execution to controller account only.
208     modifier controllerOnly() {
209         require(controller_ == msg.sender, "controller_only");
210         _;
211     }
212 
213     /// @dev Limit execution to minion account only.
214     modifier minionOnly() {
215         require(minions_[msg.sender], "minion_only");
216         _;
217     }
218 
219     /// @dev Limit execution to test time only.
220     modifier testModeOnly {
221         require(mode_ == Mode.TEST, "test_mode_only");
222         _;
223     }
224 
225     /// @dev Limit execution to presale time only.
226     modifier presaleModeOnly {
227         require(mode_ == Mode.PRESALE, "presale_mode_only");
228         _;
229     }
230 
231     /// @dev Limit execution to operate time only.
232     modifier operateModeOnly {
233         require(mode_ == Mode.OPERATE, "operate_mode_only");
234         _;
235     }
236 
237      /// @dev Limit execution to presale account only.
238     modifier presaleOnly() {
239         require(msg.sender == presale_, "presale_only");
240         _;
241     }
242 
243     /// @dev set state to Mode.OPERATE.
244     function setOperateMode()
245         external 
246         controllerOnly
247         presaleModeOnly
248     {
249         mode_ = Mode.OPERATE;
250     }
251 
252     /// @dev Set presale contract address. Becomes useless when presale is over.
253     /// @param _presale Presale contract address.
254     function setPresale(address _presale)
255         external
256         controllerOnly
257     {
258         presale_ = _presale;
259     }
260 
261     /// @dev set state to Mode.PRESALE.
262     function setPresaleMode()
263         external
264         controllerOnly
265         testModeOnly
266     {
267         mode_ = Mode.PRESALE;
268     }    
269 
270         /// @dev Get controller address.
271     /// @return Address of contract's controller.
272     function controller()
273         external
274         view
275         returns(address)
276     {
277         return controller_;
278     }
279 
280     /// @dev Transfer control to new address. Set controller an approvee for
281     /// tokens that managed by contract itself. Remove previous controller value
282     /// from contract's approvees.
283     /// @param _to New controller address.
284     function setController(address _to)
285         external
286         controllerOnly
287     {
288         require(_to != NA, "_to");
289         require(controller_ != _to, "already_controller");
290 
291         controller_ = _to;
292     }
293 
294     /// @dev Check if address is a minion.
295     /// @param _addr Address to check.
296     /// @return True if address is a minion.
297     function isMinion(address _addr)
298         public view returns(bool)
299     {
300         return minions_[_addr];
301     }   
302 
303     function getCurrentMode() 
304         public view returns (Mode) 
305     {
306         return mode_;
307     }    
308 }
309 
310 /// @dev token description, storage and transfer functions
311 contract DragonBase is DragonAccessControl
312 {
313     using SafeMath8 for uint8;
314     using SafeMath32 for uint32;
315     using SafeMath256 for uint256;
316     using StringUtils for string;
317     using UintStringUtils for uint;    
318 
319     /// @dev The Birth event is fired whenever a new dragon comes into existence. 
320     event Birth(address owner, uint256 petId, uint256 tokenId, uint256 parentA, uint256 parentB, string genes, string params);
321 
322     /// @dev Token name
323     string internal name_;
324     /// @dev Token symbol
325     string internal symbol_;
326     /// @dev Token resolving url
327     string internal url_;
328 
329     struct DragonToken {
330         // Constant Token params
331         uint8   genNum;  // generation number. uses for dragon view
332         string  genome;  // genome description
333         uint256 petId;   // offchain dragon identifier
334 
335         // Parents
336         uint256 parentA;
337         uint256 parentB;
338 
339         // Game-depening Token params
340         string  params;  // can change in export operation
341 
342         // State
343         address owner; 
344     }
345 
346     /// @dev Count of minted tokens
347     uint256 internal mintCount_;
348     /// @dev Maximum token supply
349     uint256 internal maxSupply_;
350      /// @dev Count of burn tokens
351     uint256 internal burnCount_;
352 
353     // Tokens state
354     /// @dev Token approvals values
355     mapping(uint256 => address) internal approvals_;
356     /// @dev Operator approvals
357     mapping(address => mapping(address => bool)) internal operatorApprovals_;
358     /// @dev Index of token in owner's token list
359     mapping(uint256 => uint256) internal ownerIndex_;
360     /// @dev Owner's tokens list
361     mapping(address => uint256[]) internal ownTokens_;
362     /// @dev Tokens
363     mapping(uint256 => DragonToken) internal tokens_;
364 
365     // @dev Non Assigned address.
366     address constant NA = address(0);
367 
368     /// @dev Add token to new owner. Increase owner's balance.
369     /// @param _to Token receiver.
370     /// @param _tokenId New token id.
371     function _addTo(address _to, uint256 _tokenId)
372         internal
373     {
374         DragonToken storage token = tokens_[_tokenId];
375         require(token.owner == NA, "taken");
376 
377         uint256 lastIndex = ownTokens_[_to].length;
378         ownTokens_[_to].push(_tokenId);
379         ownerIndex_[_tokenId] = lastIndex;
380 
381         token.owner = _to;
382     }
383 
384     /// @dev Create new token and increase mintCount.
385     /// @param _genome New token's genome.
386     /// @param _params Token params string. 
387     /// @param _parentA Token A parent.
388     /// @param _parentB Token B parent.
389     /// @return New token id.
390     function _createToken(
391         address _to,
392         
393         // Constant Token params
394         uint8   _genNum,
395         string   _genome,
396         uint256 _parentA,
397         uint256 _parentB,
398         
399         // Game-depening Token params
400         uint256 _petId,
401         string   _params        
402     )
403         internal returns(uint256)
404     {
405         uint256 tokenId = mintCount_.add(1);
406         mintCount_ = tokenId;
407 
408         DragonToken memory token = DragonToken(
409             _genNum,
410             _genome,
411             _petId,
412 
413             _parentA,
414             _parentB,
415 
416             _params,
417             NA
418         );
419         
420         tokens_[tokenId] = token;
421         
422         _addTo(_to, tokenId);
423         
424         emit Birth(_to, _petId, tokenId, _parentA, _parentB, _genome, _params);
425         
426         return tokenId;
427     }    
428  
429     /// @dev Get token genome.
430     /// @param _tokenId Token id.
431     /// @return Token's genome.
432     function getGenome(uint256 _tokenId)
433         external view returns(string)
434     {
435         return tokens_[_tokenId].genome;
436     }
437 
438     /// @dev Get token params.
439     /// @param _tokenId Token id.
440     /// @return Token's params.
441     function getParams(uint256 _tokenId)
442         external view returns(string)
443     {
444         return tokens_[_tokenId].params;
445     }
446 
447     /// @dev Get token parentA.
448     /// @param _tokenId Token id.
449     /// @return Parent token id.
450     function getParentA(uint256 _tokenId)
451         external view returns(uint256)
452     {
453         return tokens_[_tokenId].parentA;
454     }   
455 
456     /// @dev Get token parentB.
457     /// @param _tokenId Token id.
458     /// @return Parent token id.
459     function getParentB(uint256 _tokenId)
460         external view returns(uint256)
461     {
462         return tokens_[_tokenId].parentB;
463     }
464 
465     /// @dev Check if `_tokenId` exists. Check if owner is not addres(0).
466     /// @param _tokenId Token id
467     /// @return Return true if token owner is real.
468     function isExisting(uint256 _tokenId)
469         public view returns(bool)
470     {
471         return tokens_[_tokenId].owner != NA;
472     }    
473 
474     /// @dev Receive maxium token supply value.
475     /// @return Contracts `maxSupply_` variable.
476     function maxSupply()
477         external view returns(uint256)
478     {
479         return maxSupply_;
480     }
481 
482     /// @dev Set url prefix for tokenURI generation.
483     /// @param _url Url prefix value.
484     function setUrl(string _url)
485         external controllerOnly
486     {
487         url_ = _url;
488     }
489 
490     /// @dev Get token symbol.
491     /// @return Token symbol name.
492     function symbol()
493         external view returns(string)
494     {
495         return symbol_;
496     }
497 
498     /// @dev Get token URI to receive offchain information by it's id.
499     /// @param _tokenId Token id.
500     /// @return URL string. For example "http://erc721.tld/tokens/1".
501     function tokenURI(uint256 _tokenId)
502         external view returns(string)
503     {
504         return url_.concat(_tokenId.toString());
505     }
506 
507      /// @dev Get token name.
508     /// @return Token name string.
509     function name()
510         external view returns(string)
511     {
512         return name_;
513     }
514 
515     /// @dev return information about _owner tokens
516     function getTokens(address _owner)
517         external view  returns (uint256[], uint256[], byte[]) 
518     {
519         uint256[] memory tokens = ownTokens_[_owner];
520         uint256[] memory tokenIds = new uint256[](tokens.length);
521         uint256[] memory petIds = new uint256[](tokens.length);
522 
523         byte[] memory genomes = new byte[](tokens.length * 77);
524         uint index = 0;
525 
526         for(uint i = 0; i < tokens.length; i++) {
527             uint256 tokenId = tokens[i];
528             
529             DragonToken storage token = tokens_[tokenId];
530 
531             tokenIds[i] = tokenId;
532             petIds[i] = token.petId;
533             
534             bytes storage genome = bytes(token.genome);
535             
536             for(uint j = 0; j < genome.length; j++) {
537                 genomes[index++] = genome[j];
538             }
539         }
540         return (tokenIds, petIds, genomes);
541     }
542     
543 }
544 
545 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
546 /// @dev See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC721/ERC721.sol
547 
548 contract ERC721Basic 
549 {
550     /// @dev Emitted when token approvee is set
551     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
552     /// @dev Emitted when owner approve all own tokens to operator.
553     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
554     /// @dev Emitted when user deposit some funds.
555     event Deposit(address indexed _sender, uint256 _value);
556     /// @dev Emitted when user deposit some funds.
557     event Withdraw(address indexed _sender, uint256 _value);
558     /// @dev Emitted when token transferred to new owner
559     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
560 
561     // Required methods
562     function balanceOf(address _owner) external view returns (uint256 _balance);
563     function ownerOf(uint256 _tokenId) public view returns (address _owner);
564     function exists(uint256 _tokenId) public view returns (bool _exists);
565     
566     function approve(address _to, uint256 _tokenId) external;
567     function getApproved(uint256 _tokenId) public view returns (address _to);
568 
569     //function transfer(address _to, uint256 _tokenId) public;
570     function transferFrom(address _from, address _to, uint256 _tokenId) public;
571 
572     function totalSupply() public view returns (uint256 total);
573 
574     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
575     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
576 }
577 
578 /**
579  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
580  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
581  */
582 contract ERC721Metadata is ERC721Basic 
583 {
584     function name() external view returns (string _name);
585     function symbol() external view returns (string _symbol);
586     function tokenURI(uint256 _tokenId) external view returns (string);
587 }
588 
589 
590 /**
591  * @title ERC721 token receiver interface
592  * @dev Interface for any contract that wants to support safeTransfers
593  *  from ERC721 asset contracts.
594  */
595 contract ERC721Receiver 
596 {
597   /**
598    * @dev Magic value to be returned upon successful reception of an NFT
599    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
600    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
601    */
602     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
603 
604   /**
605    * @notice Handle the receipt of an NFT
606    * @dev The ERC721 smart contract calls this function on the recipient
607    *  after a `safetransfer`. This function MAY throw to revert and reject the
608    *  transfer. This function MUST use 50,000 gas or less. Return of other
609    *  than the magic value MUST result in the transaction being reverted.
610    *  Note: the contract address is always the message sender.
611    * @param _from The sending address
612    * @param _tokenId The NFT identifier which is being transfered
613    * @param _data Additional data with no specified format
614    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
615    */
616     function onERC721Received(address _from, uint256 _tokenId, bytes _data )
617         public returns(bytes4);
618 }
619 
620 /**
621  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
622  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
623  */
624 contract ERC721 is ERC721Basic, ERC721Metadata, ERC721Receiver 
625 {
626     /// @dev Interface signature 721 for interface detection.
627     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
628 
629     bytes4 constant InterfaceSignature_ERC165 = 0x01ffc9a7;
630     /*
631     bytes4(keccak256('supportsInterface(bytes4)'));
632     */
633 
634     bytes4 constant InterfaceSignature_ERC721Enumerable = 0x780e9d63;
635     /*
636     bytes4(keccak256('totalSupply()')) ^
637     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
638     bytes4(keccak256('tokenByIndex(uint256)'));
639     */
640 
641     bytes4 constant InterfaceSignature_ERC721Metadata = 0x5b5e139f;
642     /*
643     bytes4(keccak256('name()')) ^
644     bytes4(keccak256('symbol()')) ^
645     bytes4(keccak256('tokenURI(uint256)'));
646     */
647 
648     bytes4 constant InterfaceSignature_ERC721 = 0x80ac58cd;
649     /*
650     bytes4(keccak256('balanceOf(address)')) ^
651     bytes4(keccak256('ownerOf(uint256)')) ^
652     bytes4(keccak256('approve(address,uint256)')) ^
653     bytes4(keccak256('getApproved(uint256)')) ^
654     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
655     bytes4(keccak256('isApprovedForAll(address,address)')) ^
656     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
657     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
658     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'));
659     */
660 
661     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
662     {
663         return ((_interfaceID == InterfaceSignature_ERC165)
664             || (_interfaceID == InterfaceSignature_ERC721)
665             || (_interfaceID == InterfaceSignature_ERC721Enumerable)
666             || (_interfaceID == InterfaceSignature_ERC721Metadata));
667     }    
668 }
669 
670 /// @dev ERC721 methods
671 contract DragonOwnership is ERC721, DragonBase
672 {
673     using StringUtils for string;
674     using UintStringUtils for uint;    
675     using AddressUtils for address;
676 
677     /// @dev Emitted when token transferred to new owner. Additional fields is petId, genes, params
678     /// it uses for client-side indication
679     event TransferInfo(address indexed _from, address indexed _to, uint256 _tokenId, uint256 petId, string genes, string params);
680 
681     /// @dev Specify if _addr is token owner or approvee. Also check if `_addr`
682     /// is operator for token owner.
683     /// @param _tokenId Token to check ownership of.
684     /// @param _addr Address to check if it's an owner or an aprovee of `_tokenId`.
685     /// @return True if token can be managed by provided `_addr`.
686     function isOwnerOrApproved(uint256 _tokenId, address _addr)
687         public view returns(bool)
688     {
689         DragonToken memory token = tokens_[_tokenId];
690 
691         if (token.owner == _addr) {
692             return true;
693         }
694         else if (isApprovedFor(_tokenId, _addr)) {
695             return true;
696         }
697         else if (isApprovedForAll(token.owner, _addr)) {
698             return true;
699         }
700 
701         return false;
702     }
703 
704     /// @dev Limit execution to token owner or approvee only.
705     /// @param _tokenId Token to check ownership of.
706     modifier ownerOrApprovedOnly(uint256 _tokenId) {
707         require(isOwnerOrApproved(_tokenId, msg.sender), "tokenOwnerOrApproved_only");
708         _;
709     }
710 
711     /// @dev Contract's own token only acceptable.
712     /// @param _tokenId Contract's token id.
713     modifier ownOnly(uint256 _tokenId) {
714         require(tokens_[_tokenId].owner == address(this), "own_only");
715         _;
716     }
717 
718     /// @dev Determine if token is approved for specified approvee.
719     /// @param _tokenId Target token id.
720     /// @param _approvee Approvee address.
721     /// @return True if so.
722     function isApprovedFor(uint256 _tokenId, address _approvee)
723         public view returns(bool)
724     {
725         return approvals_[_tokenId] == _approvee;
726     }
727 
728     /// @dev Specify is given address set as operator with setApprovalForAll.
729     /// @param _owner Token owner.
730     /// @param _operator Address to check if it an operator.
731     /// @return True if operator is set.
732     function isApprovedForAll(address _owner, address _operator)
733         public view returns(bool)
734     {
735         return operatorApprovals_[_owner][_operator];
736     }
737 
738     /// @dev Check if `_tokenId` exists. Check if owner is not addres(0).
739     /// @param _tokenId Token id
740     /// @return Return true if token owner is real.
741     function exists(uint256 _tokenId)
742         public view returns(bool)
743     {
744         return tokens_[_tokenId].owner != NA;
745     }
746 
747     /// @dev Get owner of a token.
748     /// @param _tokenId Token owner id.
749     /// @return Token owner address.
750     function ownerOf(uint256 _tokenId)
751         public view returns(address)
752     {
753         return tokens_[_tokenId].owner;
754     }
755 
756     /// @dev Get approvee address. If there is not approvee returns 0x0.
757     /// @param _tokenId Token id to get approvee of.
758     /// @return Approvee address or 0x0.
759     function getApproved(uint256 _tokenId)
760         public view returns(address)
761     {
762         return approvals_[_tokenId];
763     }
764 
765     /// @dev Grant owner alike controll permissions to third party.
766     /// @param _to Permission receiver.
767     /// @param _tokenId Granted token id.
768     function approve(address _to, uint256 _tokenId)
769         external ownerOrApprovedOnly(_tokenId)
770     {
771         address owner = ownerOf(_tokenId);
772         require(_to != owner);
773 
774         if (getApproved(_tokenId) != NA || _to != NA) {
775             approvals_[_tokenId] = _to;
776 
777             emit Approval(owner, _to, _tokenId);
778         }
779     }
780 
781     /// @dev Current total tokens supply. Always less then maxSupply.
782     /// @return Difference between minted and burned tokens.
783     function totalSupply()
784         public view returns(uint256)
785     {
786         return mintCount_;
787     }    
788 
789     /// @dev Get number of tokens which `_owner` owns.
790     /// @param _owner Address to count own tokens.
791     /// @return Count of owned tokens.
792     function balanceOf(address _owner)
793         external view returns(uint256)
794     {
795         return ownTokens_[_owner].length;
796     }    
797 
798     /// @dev Internal set approval for all without _owner check.
799     /// @param _owner Granting user.
800     /// @param _to New account approvee.
801     /// @param _approved Set new approvee status.
802     function _setApprovalForAll(address _owner, address _to, bool _approved)
803         internal
804     {
805         operatorApprovals_[_owner][_to] = _approved;
806 
807         emit ApprovalForAll(_owner, _to, _approved);
808     }
809 
810     /// @dev Set approval for all account tokens.
811     /// @param _to Approvee address.
812     /// @param _approved Value true or false.
813     function setApprovalForAll(address _to, bool _approved)
814         external
815     {
816         require(_to != msg.sender);
817 
818         _setApprovalForAll(msg.sender, _to, _approved);
819     }
820 
821     /// @dev Remove approval bindings for token. Do nothing if no approval
822     /// exists.
823     /// @param _from Address of token owner.
824     /// @param _tokenId Target token id.
825     function _clearApproval(address _from, uint256 _tokenId)
826         internal
827     {
828         if (approvals_[_tokenId] == NA) {
829             return;
830         }
831 
832         approvals_[_tokenId] = NA;
833         emit Approval(_from, NA, _tokenId);
834     }
835 
836     /// @dev Check if contract was received by other side properly if receiver
837     /// is a ctontract.
838     /// @param _from Current token owner.
839     /// @param _to New token owner.
840     /// @param _tokenId token Id.
841     /// @param _data Transaction data.
842     /// @return True on success.
843     function _checkAndCallSafeTransfer(
844         address _from,
845         address _to,
846         uint256 _tokenId,
847         bytes _data
848     )
849         internal returns(bool)
850     {
851         if (! _to.isContract()) {
852             return true;
853         }
854 
855         bytes4 retval = ERC721Receiver(_to).onERC721Received(
856             _from, _tokenId, _data
857         );
858 
859         return (retval == ERC721_RECEIVED);
860     }
861 
862     /// @dev Remove token from owner. Unrecoverable.
863     /// @param _tokenId Removing token id.
864     function _remove(uint256 _tokenId)
865         internal
866     {
867         address owner = tokens_[_tokenId].owner;
868         _removeFrom(owner, _tokenId);
869     }
870 
871     /// @dev Completely remove token from the contract. Unrecoverable.
872     /// @param _owner Owner of removing token.
873     /// @param _tokenId Removing token id.
874     function _removeFrom(address _owner, uint256 _tokenId)
875         internal
876     {
877         uint256 lastIndex = ownTokens_[_owner].length.sub(1);
878         uint256 lastToken = ownTokens_[_owner][lastIndex];
879 
880         // Swap users token
881         ownTokens_[_owner][ownerIndex_[_tokenId]] = lastToken;
882         ownTokens_[_owner].length--;
883 
884         // Swap token indexes
885         ownerIndex_[lastToken] = ownerIndex_[_tokenId];
886         ownerIndex_[_tokenId] = 0;
887 
888         DragonToken storage token = tokens_[_tokenId];
889         token.owner = NA;
890     }
891 
892     /// @dev Transfer token from owner `_from` to another address or contract
893     /// `_to` by it's `_tokenId`.
894     /// @param _from Current token owner.
895     /// @param _to New token owner.
896     /// @param _tokenId token Id.
897     function transferFrom( address _from, address _to, uint256 _tokenId )
898         public ownerOrApprovedOnly(_tokenId)
899     {
900         require(_from != NA);
901         require(_to != NA);
902 
903         _clearApproval(_from, _tokenId);
904         _removeFrom(_from, _tokenId);
905         _addTo(_to, _tokenId);
906 
907         emit Transfer(_from, _to, _tokenId);
908 
909         DragonToken storage token = tokens_[_tokenId];
910         emit TransferInfo(_from, _to, _tokenId, token.petId, token.genome, token.params);
911     }
912 
913     /// @dev Update token params and transfer to new owner. Only contract's own
914     /// tokens could be updated. Also notifies receiver of the token.
915     /// @param _to Address to transfer token to.
916     /// @param _tokenId Id of token that should be transferred.
917     /// @param _params New token params.
918     function updateAndSafeTransferFrom(
919         address _to,
920         uint256 _tokenId,
921         string _params
922     )
923         public
924     {
925         updateAndSafeTransferFrom(_to, _tokenId, _params, "");
926     }
927 
928     /// @dev Update token params and transfer to new owner. Only contract's own
929     /// tokens could be updated. Also notifies receiver of the token and send
930     /// protion of _data to it.
931     /// @param _to Address to transfer token to.
932     /// @param _tokenId Id of token that should be transferred.
933     /// @param _params New token params.
934     /// @param _data Notification data.
935     function updateAndSafeTransferFrom(
936         address _to,
937         uint256 _tokenId,
938         string _params,
939         bytes _data
940     )
941         public
942     {
943         // Safe transfer from
944         updateAndTransferFrom(_to, _tokenId, _params, 0, 0);
945         require(_checkAndCallSafeTransfer(address(this), _to, _tokenId, _data));
946     }
947 
948     /// @dev Update token params and transfer to new owner. Only contract's own
949     /// tokens could be updated.
950     /// @param _to Address to transfer token to.
951     /// @param _tokenId Id of token that should be transferred.
952     /// @param _params New token params.
953     function updateAndTransferFrom(
954         address _to,
955         uint256 _tokenId,
956         string _params,
957         uint256 _petId, 
958         uint256 _transferCost
959     )
960         public
961         ownOnly(_tokenId)
962         minionOnly
963     {
964         require(bytes(_params).length > 0, "params_length");
965 
966         // Update
967         tokens_[_tokenId].params = _params;
968         if (tokens_[_tokenId].petId == 0 ) {
969             tokens_[_tokenId].petId = _petId;
970         }
971 
972         address from = tokens_[_tokenId].owner;
973 
974         // Transfer from
975         transferFrom(from, _to, _tokenId);
976 
977         // send to the server's wallet the transaction cost
978         // withdraw it from the balance of the contract. this amount must be withdrawn from the player
979         // on the side of the game server        
980         if (_transferCost > 0) {
981             msg.sender.transfer(_transferCost);
982         }
983     }
984 
985     /// @dev Transfer token from one owner to new one and check if it was
986     /// properly received if receiver is a contact.
987     /// @param _from Current token owner.
988     /// @param _to New token owner.
989     /// @param _tokenId token Id.
990     function safeTransferFrom(
991         address _from,
992         address _to,
993         uint256 _tokenId
994     )
995         public
996     {
997         safeTransferFrom(_from, _to, _tokenId, "");
998     }
999 
1000     /// @dev Transfer token from one owner to new one and check if it was
1001     /// properly received if receiver is a contact.
1002     /// @param _from Current token owner.
1003     /// @param _to New token owner.
1004     /// @param _tokenId token Id.
1005     /// @param _data Transaction data.
1006     function safeTransferFrom(
1007         address _from,
1008         address _to,
1009         uint256 _tokenId,
1010         bytes _data
1011     )
1012         public
1013     {
1014         transferFrom(_from, _to, _tokenId);
1015         require(_checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
1016     }
1017 
1018     /// @dev Burn owned token. Increases `burnCount_` and decrease `totalSupply`
1019     /// value.
1020     /// @param _tokenId Id of burning token.
1021     function burn(uint256 _tokenId)
1022         public
1023         ownerOrApprovedOnly(_tokenId)
1024     {
1025         address owner = tokens_[_tokenId].owner;
1026         _remove(_tokenId);
1027 
1028         burnCount_ += 1;
1029 
1030         emit Transfer(owner, NA, _tokenId);
1031     }
1032 
1033     /// @dev Receive count of burned tokens. Should be greater than `totalSupply`
1034     /// but less than `mintCount`.
1035     /// @return Number of burned tokens
1036     function burnCount()
1037         external
1038         view
1039         returns(uint256)
1040     {
1041         return burnCount_;
1042     }
1043 
1044     function onERC721Received(address, uint256, bytes)
1045         public returns(bytes4) 
1046     {
1047         return ERC721_RECEIVED;
1048     }
1049 }
1050 
1051 
1052 
1053 /// @title Managing contract. implements the logic of buying tokens, depositing / withdrawing funds 
1054 /// to the project account and importing / exporting tokens
1055 contract EtherDragonsCore is DragonOwnership 
1056 {
1057     using SafeMath8 for uint8;
1058     using SafeMath32 for uint32;
1059     using SafeMath256 for uint256;
1060     using AddressUtils for address;
1061     using StringUtils for string;
1062     using UintStringUtils for uint;
1063 
1064     // @dev Non Assigned address.
1065     address constant NA = address(0);
1066 
1067     /// @dev Bounty tokens count limit
1068     uint256 public constant BOUNTY_LIMIT = 2500;
1069     /// @dev Presale tokens count limit
1070     uint256 public constant PRESALE_LIMIT = 7500;
1071     ///@dev Total gen0tokens generation limit
1072     uint256 public constant GEN0_CREATION_LIMIT = 90000;
1073     
1074     /// @dev Number of tokens minted in presale stage
1075     uint256 internal presaleCount_;  
1076     /// @dev Number of tokens minted for bounty campaign
1077     uint256 internal bountyCount_;
1078    
1079     ///@dev Company bank address
1080     address internal bank_;
1081 
1082     // Extension ---------------------------------------------------------------
1083 
1084     /// @dev Contract is not payable. To fullfil balance method `depositTo`
1085     /// should be used.
1086     function ()
1087         public payable
1088     {
1089         revert();
1090     }
1091 
1092     /// @dev amount on the account of the contract. This amount consists of deposits  from players and the system reserve for payment of transactions
1093     /// the player at any time to withdraw the amount corresponding to his account in the game, minus the cost of the transaction 
1094     function getBalance() 
1095         public view returns (uint256)
1096     {
1097         return address(this).balance;
1098     }    
1099 
1100     /// @dev at the moment of creation of the contract we transfer the address of the bank
1101     /// presell contract address set later
1102     constructor(
1103         address _bank
1104     )
1105         public
1106     {
1107         require(_bank != NA);
1108         
1109         controller_ = msg.sender;
1110         bank_ = _bank;
1111         
1112         // Meta
1113         name_ = "EtherDragons";
1114         symbol_ = "ED";
1115         url_ = "https://game.etherdragons.world/token/";
1116 
1117         // Token mint limit
1118         maxSupply_ = GEN0_CREATION_LIMIT + BOUNTY_LIMIT + PRESALE_LIMIT;
1119     }
1120 
1121     /// Number of tokens minted in presale stage
1122     function totalPresaleCount()
1123         public view returns(uint256)
1124     {
1125         return presaleCount_;
1126     }    
1127 
1128     /// @dev Number of tokens minted for bounty campaign
1129     function totalBountyCount()
1130         public view returns(uint256)
1131     {
1132         return bountyCount_;
1133     }    
1134     
1135     /// @dev Check if new token could be minted. Return true if count of minted
1136     /// tokens less than could be minted through contract deploy.
1137     /// Also, tokens can not be created more often than once in mintDelay_ minutes
1138     /// @return True if current count is less then maximum tokens available for now.
1139     function canMint()
1140         public view returns(bool)
1141     {
1142         return (mintCount_ + presaleCount_ + bountyCount_) < maxSupply_;
1143     }
1144 
1145     /// @dev Here we write the addresses of the wallets of the server from which it is accessed
1146     /// to contract methods.
1147     /// @param _to New minion address
1148     function minionAdd(address _to)
1149         external controllerOnly
1150     {
1151         require(minions_[_to] == false, "already_minion");
1152         
1153         // разрешаем этому адресу пользоваться токенами контакта
1154         // allow the address to use contract tokens 
1155         _setApprovalForAll(address(this), _to, true);
1156         
1157         minions_[_to] = true;
1158     }
1159 
1160     /// @dev delete the address of the server wallet
1161     /// @param _to Minion address
1162     function minionRemove(address _to)
1163         external controllerOnly
1164     {
1165         require(minions_[_to], "not_a_minion");
1166 
1167         // and forbid this wallet to use tokens of the contract
1168         _setApprovalForAll(address(this), _to, false);
1169         minions_[_to] = false;
1170     }
1171 
1172     /// @dev Here the player can put funds to the account of the contract
1173     /// and get the same amount of in-game currency
1174     /// the game server understands who puts money at the wallet address
1175     function depositTo()
1176         public payable
1177     {
1178         emit Deposit(msg.sender, msg.value);
1179     }    
1180     
1181     /// @dev Transfer amount of Ethers to specified receiver. Only owner can
1182     // call this method.
1183     /// @param _to Transfer receiver.
1184     /// @param _amount Transfer value.
1185     /// @param _transferCost Transfer cost.
1186     function transferAmount(address _to, uint256 _amount, uint256 _transferCost)
1187         external minionOnly
1188     {
1189         require((_amount + _transferCost) <= address(this).balance, "not enough money!");
1190         _to.transfer(_amount);
1191 
1192         // send to the wallet of the server the transfer cost
1193         // withdraw  it from the balance of the contract. this amount must be withdrawn from the player
1194         // on the side of the game server
1195         if (_transferCost > 0) {
1196             msg.sender.transfer(_transferCost);
1197         }
1198 
1199         emit Withdraw(_to, _amount);
1200     }        
1201 
1202    /// @dev Mint new token with specified params. Transfer `_fee` to the
1203     /// `bank`. 
1204     /// @param _to New token owner.
1205     /// @param _fee Transaction fee.
1206     /// @param _genNum Generation number..
1207     /// @param _genome New genome unique value.
1208     /// @param _parentA Parent A.
1209     /// @param _parentB Parent B.
1210     /// @param _petId Pet identifier.
1211     /// @param _params List of parameters for pet.
1212     /// @param _transferCost Transfer cost.
1213     /// @return New token id.
1214     function mintRelease(
1215         address _to,
1216         uint256 _fee,
1217         
1218         // Constant Token params
1219         uint8   _genNum,
1220         string   _genome,
1221         uint256 _parentA,
1222         uint256 _parentB,
1223         
1224         // Game-depening Token params
1225         uint256 _petId,  //if petID = 0, then it was created outside of the server
1226         string   _params,
1227         uint256 _transferCost
1228     )
1229         external minionOnly operateModeOnly returns(uint256)
1230     {
1231         require(canMint(), "can_mint");
1232         require(_to != NA, "_to");
1233         require((_fee + _transferCost) <= address(this).balance, "_fee");
1234         require(bytes(_params).length != 0, "params_length");
1235         require(bytes(_genome).length == 77, "genome_length");
1236         
1237         // Parents should be both 0 or both not.
1238         if (_parentA != 0 && _parentB != 0) {
1239             require(_parentA != _parentB, "same_parent");
1240         }
1241         else if (_parentA == 0 && _parentB != 0) {
1242             revert("parentA_empty");
1243         }
1244         else if (_parentB == 0 && _parentA != 0) {
1245             revert("parentB_empty");
1246         }
1247 
1248         uint256 tokenId = _createToken(_to, _genNum, _genome, _parentA, _parentB, _petId, _params);
1249 
1250         require(_checkAndCallSafeTransfer(NA, _to, tokenId, ""), "safe_transfer");
1251 
1252         // Transfer mint fee to the fund
1253         CommonWallet(bank_).receive.value(_fee)();
1254 
1255         emit Transfer(NA, _to, tokenId);
1256 
1257         // send to the server wallet server the transfer cost,
1258         // withdraw it from the balance of the contract. this amount must be withdrawn from the player
1259         // on the side of the game server
1260         if (_transferCost > 0) {
1261             msg.sender.transfer(_transferCost);
1262         }
1263 
1264         return tokenId;
1265     }
1266 
1267     /// @dev Create new token via presale state
1268     /// @param _to New token owner.
1269     /// @param _genome New genome unique value.
1270     /// @return New token id.
1271     /// at the pre-sale stage we sell the zero-generation pets, which have only a genome.
1272     /// other attributes of such a token get when importing to the server
1273     function mintPresell(address _to, string _genome)
1274         external presaleOnly presaleModeOnly returns(uint256)
1275     {
1276         require(presaleCount_ < PRESALE_LIMIT, "presale_limit");
1277 
1278         // у пресейл пета нет параметров. Их он получит после ввода в игру.
1279         uint256 tokenId = _createToken(_to, 0, _genome, 0, 0, 0, "");
1280         presaleCount_ += 1;
1281 
1282         require(_checkAndCallSafeTransfer(NA, _to, tokenId, ""), "safe_transfer");
1283 
1284         emit Transfer(NA, _to, tokenId);
1285         
1286         return tokenId;
1287     }    
1288     
1289     /// @dev Create new token for bounty activity
1290     /// @param _to New token owner.
1291     /// @return New token id.
1292     function mintBounty(address _to, string _genome)
1293         external controllerOnly returns(uint256)
1294     {
1295         require(bountyCount_ < BOUNTY_LIMIT, "bounty_limit");
1296 
1297         // bounty pet has no parameters. They will receive them after importing to the game.
1298         uint256 tokenId = _createToken(_to, 0, _genome, 0, 0, 0, "");
1299     
1300         bountyCount_ += 1;
1301         require(_checkAndCallSafeTransfer(NA, _to, tokenId, ""), "safe_transfer");
1302 
1303         emit Transfer(NA, _to, tokenId);
1304 
1305         return tokenId;
1306     }        
1307 }
1308 
1309 contract Presale
1310 {
1311     // Extension ---------------------------------------------------------------
1312     using AddressUtils for address;
1313 
1314     // Events ------------------------------------------------------------------
1315     ///the event is fired when starting a new wave presale stage
1316     event StageBegin(uint8 stage, uint256 timestamp);
1317 
1318     ///the event is fired when token sold
1319     event TokensBought(address buyerAddr, uint256[] tokenIds, bytes genomes);
1320 
1321     // Types -------------------------------------------------------------------
1322     struct Stage {
1323         // Predefined values
1324         uint256 price;      // token's price on the stage
1325         uint16 softcap;     // stage softCap
1326         uint16 hardcap;     // stage hardCap
1327         
1328         // Unknown values
1329         uint16 bought;      // sold on stage
1330         uint32 startDate;   // stage's beginDate
1331         uint32 endDate;     // stage's endDate
1332     }
1333     
1334     // Constants ---------------------------------------------------------------
1335     // 10 stages of 5 genocodes
1336     uint8 public constant STAGES = 10;
1337     uint8 internal constant TOKENS_PER_STAGE = 5;
1338     address constant NA = address(0);
1339     
1340     // State -------------------------------------------------------------------
1341     address internal CEOAddress;    // contract owner
1342     address internal bank_;         // profit wallet address (not a contract)
1343     address internal erc721_;       // main contract address
1344     
1345     /// @dev genomes for bounty stage
1346     string[TOKENS_PER_STAGE][STAGES] internal genomes_;
1347 
1348     /// stages data
1349     Stage[STAGES] internal stages_;
1350     
1351     // internal transaction counter, it uses for random generator
1352     uint32  internal counter_;
1353     
1354     /// stage is over
1355     bool    internal isOver_;
1356 
1357     /// stage number
1358     uint8   internal stageIndex_;
1359 
1360     ///  stage start Data
1361     uint32  internal stageStart_;
1362 
1363     // Lifetime ----------------------------------------------------------------
1364     constructor(
1365         address _bank,  
1366         address _erc721
1367     )
1368         public
1369     {
1370         require(_bank != NA, '_bank');
1371         require(_erc721.isContract(), '_erc721');
1372 
1373         CEOAddress = msg.sender;
1374 
1375         // Addresses should not be the same.
1376         require(_bank != CEOAddress, "bank = CEO");
1377         require(CEOAddress != _erc721, "CEO = erc721");
1378         require(_erc721 != _bank, "bank = erc721");
1379 
1380         // Update state
1381         bank_ = _bank;
1382         erc721_ = _erc721;
1383        
1384         // stages data 
1385         stages_[0].price = 10 finney;
1386         stages_[0].softcap = 100;
1387         stages_[0].hardcap = 300;
1388         
1389         stages_[1].price = 20 finney;
1390         stages_[1].softcap = 156;
1391         stages_[1].hardcap = 400;
1392     
1393         stages_[2].price = 32 finney;
1394         stages_[2].softcap = 212;
1395         stages_[2].hardcap = 500;
1396         
1397         stages_[3].price = 45 finney;
1398         stages_[3].softcap = 268;
1399         stages_[3].hardcap = 600;
1400         
1401         stages_[4].price = 58 finney;
1402         stages_[4].softcap = 324;
1403         stages_[4].hardcap = 700;
1404     
1405         stages_[5].price = 73 finney;
1406         stages_[5].softcap = 380;
1407         stages_[5].hardcap = 800;
1408     
1409         stages_[6].price = 87 finney;
1410         stages_[6].softcap = 436;
1411         stages_[6].hardcap = 900;
1412     
1413         stages_[7].price = 102 finney;
1414         stages_[7].softcap = 492;
1415         stages_[7].hardcap = 1000;
1416     
1417         stages_[8].price = 118 finney;
1418         stages_[8].softcap = 548;
1419         stages_[8].hardcap = 1100;
1420         
1421         stages_[9].price = 129 finney;
1422         stages_[9].softcap = 604;
1423         stages_[9].hardcap = 1200;
1424     }
1425 
1426     /// fill the genomes data
1427     function setStageGenomes(
1428         uint8 _stage,
1429         string _genome0, 
1430         string _genome1,
1431         string _genome2, 
1432         string _genome3, 
1433         string _genome4
1434     ) 
1435         external controllerOnly
1436     {
1437         genomes_[_stage][0] = _genome0;
1438         genomes_[_stage][1] = _genome1;
1439         genomes_[_stage][2] = _genome2;
1440         genomes_[_stage][3] = _genome3;
1441         genomes_[_stage][4] = _genome4;
1442     }
1443 
1444     /// @dev Contract itself is non payable
1445     function ()
1446         public payable
1447     {
1448         revert();
1449     }
1450     
1451     // Modifiers ---------------------------------------------------------------
1452     
1453     /// only from contract owner
1454     modifier controllerOnly() {
1455         require(msg.sender == CEOAddress, 'controller_only');
1456         _;
1457     }
1458 
1459     /// only for active stage
1460     modifier notOverOnly() {
1461         require(isOver_ == false, 'notOver_only');
1462         _;
1463     }
1464 
1465     // Getters -----------------------------------------------------------------
1466     /// owner address
1467     function getCEOAddress()
1468         public view returns(address)
1469     {
1470         return CEOAddress;
1471     }
1472 
1473     /// counter from random number generator
1474     function counter()
1475         internal view returns(uint32)
1476     {
1477         return counter_;
1478     }
1479 
1480     // tokens sold by stage ...
1481     function stageTokensBought(uint8 _stage)
1482         public view returns(uint16)
1483     {
1484         return stages_[_stage].bought;
1485     }
1486 
1487     // stage softcap
1488     function stageSoftcap(uint8 _stage)
1489         public view returns(uint16)
1490     {
1491         return stages_[_stage].softcap;
1492     }
1493 
1494     /// stage hardcap
1495     function stageHardcap(uint8 _stage)
1496         public view returns(uint16)
1497     {
1498         return stages_[_stage].hardcap;
1499     }
1500 
1501     /// stage Start Date    
1502     function stageStartDate(uint8 _stage)
1503         public view returns(uint)
1504     {
1505         return stages_[_stage].startDate;
1506     }
1507     
1508     /// stage Finish Date
1509     function stageEndDate(uint8 _stage)
1510         public view returns(uint)
1511     {
1512         return stages_[_stage].endDate;
1513     }
1514 
1515     /// stage token price
1516     function stagePrice(uint _stage)
1517         public view returns(uint)
1518     {
1519         return stages_[_stage].price;
1520     }
1521     
1522     // Genome Logic -----------------------------------------------------------------
1523     /// within the prelase , the dragons are generated, which are the ancestors of the destiny
1524     /// newborns have a high chance of mutation and are unlikely to be purebred
1525     /// the player will have to collect the breed, crossing a lot of pets
1526     /// In addition, you will need to pick up combat abilities
1527     /// these characteristics are assigned to the pet when the dragon is imported to the game server.    
1528     function nextGenome()
1529         internal returns(string)
1530     {
1531         uint8 n = getPseudoRandomNumber();
1532 
1533         counter_ += 1;
1534         
1535         return genomes_[stageIndex_][n];
1536     }
1537 
1538     function getPseudoRandomNumber()
1539         internal view returns(uint8 index)
1540     {
1541         uint8 n = uint8(
1542             keccak256(abi.encode(msg.sender, block.timestamp + counter_))
1543         );
1544         return n % TOKENS_PER_STAGE;
1545     }
1546     
1547     // PreSale Logic -----------------------------------------------------------------
1548     /// Presale stage0 begin date set
1549     /// presale start is possible only once    
1550     function setStartDate(uint32 _startDate)
1551         external controllerOnly
1552     {
1553         require(stages_[0].startDate == 0, 'already_set');
1554         
1555         stages_[0].startDate = _startDate;
1556         stageStart_ = _startDate;
1557         stageIndex_ = 0;
1558         
1559         emit StageBegin(stageIndex_, stageStart_); 
1560     }
1561 
1562     /// current stage number
1563     /// switches to the next stage if the time has come
1564     function stageIndex()
1565         external view returns(uint8)
1566     {
1567         Stage memory stage = stages_[stageIndex_];
1568 
1569         if (stage.endDate > 0 && stage.endDate <= now) {
1570             return stageIndex_ + 1;
1571         }
1572         else {
1573             return stageIndex_;
1574         }
1575     }
1576     
1577     /// check whether the phase started
1578     /// switch to the next stage, if necessary    
1579     function beforeBuy()
1580         internal
1581     {
1582         if (stageStart_ == 0) {
1583             revert('presale_not_started');
1584         }
1585         else if (stageStart_ > now) {
1586             revert('stage_not_started');
1587         }
1588 
1589         Stage memory stage = stages_[stageIndex_];
1590         if (stage.endDate > 0 && stage.endDate <= now) 
1591         {
1592             stageIndex_ += 1;
1593             stageStart_ = stages_[stageIndex_].startDate;
1594 
1595             if (stageStart_ > now) {
1596                 revert('stage_not_started');
1597             }
1598         }
1599     }
1600     
1601     /// time to next midnight
1602     function midnight()
1603         public view returns(uint32)
1604     {
1605         uint32 tomorrow = uint32(now + 1 days);
1606         uint32 remain = uint32(tomorrow % 1 days);
1607         return tomorrow - remain;
1608     }
1609     
1610     /// buying a specified number of tokens
1611     function buyTokens(uint16 numToBuy)
1612         public payable notOverOnly returns(uint256[])
1613     {
1614         beforeBuy();
1615         
1616         require(numToBuy > 0 && numToBuy <= 10, "numToBuy error");
1617 
1618         Stage storage stage = stages_[stageIndex_];
1619         require((stage.price * numToBuy) <= msg.value, 'price');
1620         
1621         uint16 prevBought = stage.bought;
1622         require(prevBought + numToBuy <= stage.hardcap, "have required tokens");
1623         
1624         stage.bought += numToBuy;
1625         uint256[] memory tokenIds = new uint256[](numToBuy);
1626         
1627         bytes memory genomes = new bytes(numToBuy * 77);
1628         uint32 genomeByteIndex = 0;
1629 
1630         for(uint16 t = 0; t < numToBuy; t++) 
1631         {
1632             string memory genome = nextGenome();
1633             uint256 tokenId = EtherDragonsCore(erc721_).mintPresell(msg.sender, genome);
1634 
1635             bytes memory genomeBytes = bytes(genome);
1636             
1637             for(uint8 gi = 0; gi < genomeBytes.length; gi++) {
1638                 genomes[genomeByteIndex++] = genomeBytes[gi];
1639             }
1640 
1641             tokenIds[t] = tokenId;
1642         }
1643 
1644         // Transfer mint fee to the fund
1645         bank_.transfer(address(this).balance);
1646 
1647         if (stage.bought == stage.hardcap) {
1648             stage.endDate = uint32(now);
1649             stageStart_ = midnight() + 1 days + 1 seconds;
1650             if (stageIndex_ < STAGES - 1) {
1651                 stageIndex_ += 1;
1652             }
1653             else {
1654                 isOver_ = true;
1655             }
1656         }
1657         else if (stage.bought >= stage.softcap && prevBought < stage.softcap) {
1658             stage.endDate = midnight() + 1 days;
1659             if (stageIndex_ < STAGES - 1) {
1660                 stages_[stageIndex_ + 1].startDate = stage.endDate + 1 days;
1661             }
1662         }
1663 
1664         emit TokensBought(msg.sender, tokenIds, genomes);
1665 
1666         return tokenIds;
1667     }
1668 
1669     function currTime()
1670         public view returns(uint)
1671     {
1672         return now;
1673     }
1674     
1675     /// stages data
1676     function getStagesInfo() 
1677         public view returns (uint256[] prices, uint16[] softcaps, uint16[] hardcaps, uint16[] boughts) 
1678     {
1679             prices = new uint256[](STAGES);
1680             softcaps = new uint16[](STAGES);
1681             hardcaps = new uint16[](STAGES);
1682             boughts = new uint16[](STAGES);
1683             
1684             for(uint8 s = 0; s < STAGES; s++) {
1685                 prices[s] = stages_[s].price;
1686                 softcaps[s] = stages_[s].softcap;
1687                 hardcaps[s] = stages_[s].hardcap;
1688                 boughts[s] = stages_[s].bought;
1689             }
1690     }
1691     
1692     /// stages dates data
1693     function getStagesBeginEnd() 
1694         public view returns (uint32[] startDates, uint32[] endDates) 
1695     {
1696         startDates = new uint32[](STAGES);
1697         endDates = new uint32[](STAGES);
1698         
1699         for(uint8 s = 0; s < STAGES; s++) {
1700             startDates[s] = stages_[s].startDate;
1701             endDates[s] = stages_[s].endDate;
1702         }
1703     }
1704 
1705     /// returns data which genomes can be purchased at the stage
1706     function stageGenomes(uint8 _stage)
1707         public view returns(byte[])
1708     {
1709         byte[] memory genomes = new byte[](uint16(TOKENS_PER_STAGE) * 77);
1710         uint32 gbIndex = 0;
1711 
1712         for(uint8 tokenIndex = 0; tokenIndex < TOKENS_PER_STAGE; tokenIndex++) {
1713             
1714             bytes memory genomeBytes = bytes(genomes_[_stage][tokenIndex]);
1715             
1716             for(uint8 gi = 0; gi < genomeBytes.length; gi++) {
1717                 genomes[gbIndex++] = genomeBytes[gi];
1718             }
1719         }
1720 
1721         return genomes;
1722     }
1723 }