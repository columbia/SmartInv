1 pragma solidity ^0.4.19;
2 
3 contract ADM312 {
4 
5   address public COO;
6   address public CTO;
7   address public CFO;
8   address private coreAddress;
9   address public logicAddress;
10   address public superAddress;
11 
12   modifier onlyAdmin() {
13     require(msg.sender == COO || msg.sender == CTO || msg.sender == CFO);
14     _;
15   }
16   
17   modifier onlyContract() {
18     require(msg.sender == coreAddress || msg.sender == logicAddress || msg.sender == superAddress);
19     _;
20   }
21     
22   modifier onlyContractAdmin() {
23     require(msg.sender == coreAddress || msg.sender == logicAddress || msg.sender == superAddress || msg.sender == COO || msg.sender == CTO || msg.sender == CFO);
24      _;
25   }
26   
27   function transferAdmin(address _newAdminAddress1, address _newAdminAddress2) public onlyAdmin {
28     if(msg.sender == COO)
29     {
30         CTO = _newAdminAddress1;
31         CFO = _newAdminAddress2;
32     }
33     if(msg.sender == CTO)
34     {
35         COO = _newAdminAddress1;
36         CFO = _newAdminAddress2;
37     }
38     if(msg.sender == CFO)
39     {
40         COO = _newAdminAddress1;
41         CTO = _newAdminAddress2;
42     }
43   }
44   
45   function transferContract(address _newCoreAddress, address _newLogicAddress, address _newSuperAddress) external onlyAdmin {
46     coreAddress  = _newCoreAddress;
47     logicAddress = _newLogicAddress;
48     superAddress = _newSuperAddress;
49     SetCoreInterface(_newLogicAddress).setCoreContract(_newCoreAddress);
50     SetCoreInterface(_newSuperAddress).setCoreContract(_newCoreAddress);
51   }
52 
53 
54 }
55 
56 contract ERC721 {
57     
58   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
59   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
60 
61   function totalSupply() public view returns (uint256 total);
62   function balanceOf(address _owner) public view returns (uint256 balance);
63   function ownerOf(uint256 _tokenId) public view returns (address owner);
64   function transfer(address _to, uint256 _tokenId) public;
65   function approve(address _to, uint256 _tokenId) public;
66   function takeOwnership(uint256 _tokenId) public;
67   
68 }
69 
70 contract SetCoreInterface {
71    function setCoreContract(address _neWCoreAddress) external; 
72 }
73 
74 contract CaData is ADM312, ERC721 {
75     
76     function CaData() public {
77         COO = msg.sender;
78         CTO = msg.sender;
79         CFO = msg.sender;
80         createCustomAtom(0,0,4,0,0,0,0);
81     }
82     
83     function kill() external
84 	{
85 	    require(msg.sender == COO);
86 		selfdestruct(msg.sender);
87 	}
88     
89     function() public payable{}
90     
91     uint public randNonce  = 0;
92     
93     struct Atom 
94     {
95       uint64   dna;
96       uint8    gen;
97       uint8    lev;
98       uint8    cool;
99       uint32   sons;
100       uint64   fath;
101 	  uint64   moth;
102 	  uint128  isRent;
103 	  uint128  isBuy;
104 	  uint32   isReady;
105     }
106     
107     Atom[] public atoms;
108     
109     mapping (uint64  => bool) public dnaExist;
110     mapping (address => bool) public bonusReceived;
111     mapping (address => uint) public ownerAtomsCount;
112     mapping (uint => address) public atomOwner;
113     
114     event NewWithdraw(address sender, uint balance);
115     
116     function createCustomAtom(uint64 _dna, uint8 _gen, uint8 _lev, uint8 _cool, uint128 _isRent, uint128 _isBuy, uint32 _isReady) public onlyAdmin {
117         require(dnaExist[_dna]==false && _cool+_lev>=4);
118         Atom memory newAtom = Atom(_dna, _gen, _lev, _cool, 0, 2**50, 2**50, _isRent, _isBuy, _isReady);
119         uint id = atoms.push(newAtom) - 1;
120         atomOwner[id] = msg.sender;
121         ownerAtomsCount[msg.sender]++;
122         dnaExist[_dna] = true;
123     }
124     
125     function withdrawBalance() public payable onlyAdmin {
126 		NewWithdraw(msg.sender, address(this).balance);
127         CFO.transfer(address(this).balance);
128     }
129         
130     function incRandNonce() external onlyContract {
131         randNonce++;
132     }
133     
134     function setDnaExist(uint64 _dna, bool _newDnaLocking) external onlyContractAdmin {
135         dnaExist[_dna] = _newDnaLocking;
136     }
137     
138     function setBonusReceived(address _add, bool _newBonusLocking) external onlyContractAdmin {
139         bonusReceived[_add] = _newBonusLocking;
140     }
141     
142     function setOwnerAtomsCount(address _owner, uint _newCount) external onlyContract {
143         ownerAtomsCount[_owner] = _newCount;
144     }
145     
146     function setAtomOwner(uint _atomId, address _owner) external onlyContract {
147         atomOwner[_atomId] = _owner;
148     }
149         
150     function pushAtom(uint64 _dna, uint8 _gen, uint8 _lev, uint8 _cool, uint32 _sons, uint64 _fathId, uint64 _mothId, uint128 _isRent, uint128 _isBuy, uint32 _isReady) external onlyContract returns (uint id) {
151         Atom memory newAtom = Atom(_dna, _gen, _lev, _cool, _sons, _fathId, _mothId, _isRent, _isBuy, _isReady);
152         id = atoms.push(newAtom) -1;
153     }
154 	
155 	function setAtomDna(uint _atomId, uint64 _dna) external onlyAdmin {
156         atoms[_atomId].dna = _dna;
157     }
158 	
159 	function setAtomGen(uint _atomId, uint8 _gen) external onlyAdmin {
160         atoms[_atomId].gen = _gen;
161     }
162     
163     function setAtomLev(uint _atomId, uint8 _lev) external onlyContract {
164         atoms[_atomId].lev = _lev;
165     }
166     
167     function setAtomCool(uint _atomId, uint8 _cool) external onlyContract {
168         atoms[_atomId].cool = _cool;
169     }
170     
171     function setAtomSons(uint _atomId, uint32 _sons) external onlyContract {
172         atoms[_atomId].sons = _sons;
173     }
174     
175     function setAtomFath(uint _atomId, uint64 _fath) external onlyContract {
176         atoms[_atomId].fath = _fath;
177     }
178     
179     function setAtomMoth(uint _atomId, uint64 _moth) external onlyContract {
180         atoms[_atomId].moth = _moth;
181     }
182     
183     function setAtomIsRent(uint _atomId, uint128 _isRent) external onlyContract {
184         atoms[_atomId].isRent = _isRent;
185     }
186     
187     function setAtomIsBuy(uint _atomId, uint128 _isBuy) external onlyContract {
188         atoms[_atomId].isBuy = _isBuy;
189     }
190     
191     function setAtomIsReady(uint _atomId, uint32 _isReady) external onlyContractAdmin {
192         atoms[_atomId].isReady = _isReady;
193     }
194     
195     //ERC721
196     
197     mapping (uint => address) tokenApprovals;
198     
199     function totalSupply() public view returns (uint256 total){
200   	    return atoms.length;
201   	}
202   	
203   	function balanceOf(address _owner) public view returns (uint256 balance) {
204         return ownerAtomsCount[_owner];
205     }
206     
207     function ownerOf(uint256 _tokenId) public view returns (address owner) {
208         return atomOwner[_tokenId];
209     }
210       
211     function _transfer(address _from, address _to, uint256 _tokenId) private {
212         atoms[_tokenId].isBuy  = 0;
213         atoms[_tokenId].isRent = 0;
214         ownerAtomsCount[_to]++;
215         ownerAtomsCount[_from]--;
216         atomOwner[_tokenId] = _to;
217         Transfer(_from, _to, _tokenId);
218     }
219   
220     function transfer(address _to, uint256 _tokenId) public {
221         require(msg.sender == atomOwner[_tokenId]);
222         _transfer(msg.sender, _to, _tokenId);
223     }
224     
225     function approve(address _to, uint256 _tokenId) public {
226         require(msg.sender == atomOwner[_tokenId]);
227         tokenApprovals[_tokenId] = _to;
228         Approval(msg.sender, _to, _tokenId);
229     }
230     
231     function takeOwnership(uint256 _tokenId) public {
232         require(tokenApprovals[_tokenId] == msg.sender);
233         _transfer(ownerOf(_tokenId), msg.sender, _tokenId);
234     }
235     
236 }
237 
238 contract Ownable {
239     
240     address private _owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244     /**
245      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
246      * account.
247      */
248     constructor () internal {
249         _owner = msg.sender;
250         emit OwnershipTransferred(address(0), _owner);
251     }
252 
253     /**
254      * @return the address of the owner.
255      */
256     function owner() public view returns (address) {
257         return _owner;
258     }
259 
260     /**
261      * @dev Throws if called by any account other than the owner.
262      */
263     modifier onlyOwner() {
264         require(isOwner());
265         _;
266     }
267 
268     /**
269      * @return true if `msg.sender` is the owner of the contract.
270      */
271     function isOwner() public view returns (bool) {
272         return msg.sender == _owner;
273     }
274 
275     /**
276      * @dev Allows the current owner to relinquish control of the contract.
277      * @notice Renouncing to ownership will leave the contract without an owner.
278      * It will not be possible to call the functions with the `onlyOwner`
279      * modifier anymore.
280      */
281     function renounceOwnership() public onlyOwner {
282         emit OwnershipTransferred(_owner, address(0));
283         _owner = address(0);
284     }
285 
286     /**
287      * @dev Allows the current owner to transfer control of the contract to a newOwner.
288      * @param newOwner The address to transfer ownership to.
289      */
290     function transferOwnership(address newOwner) public onlyOwner {
291         _transferOwnership(newOwner);
292     }
293 
294     /**
295      * @dev Transfers control of the contract to a newOwner.
296      * @param newOwner The address to transfer ownership to.
297      */
298     function _transferOwnership(address newOwner) internal {
299         require(newOwner != address(0));
300         emit OwnershipTransferred(_owner, newOwner);
301         _owner = newOwner;
302     }
303 }
304 
305 interface ERC165 {
306     function supportsInterface(bytes4 interfaceID) external view returns (bool);
307 }
308 
309 interface ERC721TokenReceiver {
310     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
311 }
312 
313 interface ERC721Metadata {
314     function name() external view returns (string _name);
315     function symbol() external view returns (string _symbol);
316     function tokenURI(uint256 _tokenId) external view returns (string);
317 }
318 
319 interface ERC721Enumerable {
320     function totalSupply() external view returns (uint256);
321     function tokenByIndex(uint256 _index) external view returns (uint256);
322     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
323 }
324           
325 contract CryptoAtomsToken is Ownable {
326     
327     address public CaDataAddress = 0x9b3554E6FC4F81531F6D43b611258bd1058ef6D5;
328     CaData public CaDataContract = CaData(CaDataAddress);
329 
330     function kill() external
331 	{
332 	    require(msg.sender == CaDataContract.COO());
333 		selfdestruct(msg.sender);
334 	}
335     
336     function() public payable{}
337     
338     function withdrawBalance() public payable {
339         require(msg.sender == CaDataContract.COO() || msg.sender == CaDataContract.CTO() || msg.sender == CaDataContract.CFO());
340         CaDataContract.CFO().transfer(address(this).balance);
341     }
342     
343     mapping (address => bool) transferEmittables;
344     
345     function setTransferEmittables(address _addr, bool _bool) external {
346         require(msg.sender == CaDataContract.COO() || msg.sender == CaDataContract.CTO() || msg.sender == CaDataContract.CFO());
347         transferEmittables[_addr] = _bool;
348     }
349     
350     function emitTransfer(address _from, address _to, uint256 _tokenId) external{
351         require(transferEmittables[msg.sender]);
352         Transfer(_from, _to, _tokenId);
353     }
354     
355     //ERC721
356     
357         event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
358         event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
359         event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
360     
361         mapping (uint => address) tokenApprovals;
362         mapping (uint => address) tokenOperators;
363         mapping (address => mapping (address => bool)) ownerOperators;
364     
365         function _transfer(address _from, address _to, uint256 _tokenId) private {
366             CaDataContract.setAtomIsBuy(_tokenId,0);
367             CaDataContract.setAtomIsRent(_tokenId,0);
368             CaDataContract.setOwnerAtomsCount(_to,CaDataContract.ownerAtomsCount(_to)+1);
369             CaDataContract.setOwnerAtomsCount(_from,CaDataContract.ownerAtomsCount(_from)-1);
370             CaDataContract.setAtomOwner(_tokenId,_to);
371             Transfer(_from, _to, _tokenId);
372         }
373         
374         function _isContract(address _addr) private returns (bool check) {
375             uint size;
376             assembly { size := extcodesize(_addr) }
377             return size > 0;
378         }
379         
380       	function balanceOf(address _owner) external view returns (uint256 balance) {
381             return CaDataContract.balanceOf(_owner);
382         }
383     
384         function ownerOf(uint256 _tokenId) external view returns (address owner) {
385             return CaDataContract.ownerOf(_tokenId);
386         }
387         
388         /// @notice Transfers the ownership of an NFT from one address to another address
389         /// @dev Throws unless `msg.sender` is the current owner, an authorized
390         ///  operator, or the approved address for this NFT. Throws if `_from` is
391         ///  not the current owner. Throws if `_to` is the zero address. Throws if
392         ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
393         ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
394         ///  `onERC721Received` on `_to` and throws if the return value is not
395         ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
396         /// @param _from The current owner of the NFT
397         /// @param _to The new owner
398         /// @param _tokenId The NFT to transfer
399         /// @param _data Additional data with no specified format, sent in call to `_to`
400         function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external payable{
401             require(msg.sender == CaDataContract.ownerOf(_tokenId) || ownerOperators[CaDataContract.atomOwner(_tokenId)][msg.sender] == true || msg.sender == tokenApprovals[_tokenId]);
402             require(_from == CaDataContract.ownerOf(_tokenId) && _to != 0x0);
403             require(_tokenId < totalSupply());
404             _transfer(_from, _to, _tokenId);
405             if(_isContract(_to))
406             {
407                 require(ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data) == ERC721_RECEIVED);
408             }
409         }
410     
411         /// @notice Transfers the ownership of an NFT from one address to another address
412         /// @dev This works identically to the other function with an extra data parameter,
413         ///  except this function just sets data to ""
414         /// @param _from The current owner of the NFT
415         /// @param _to The new owner
416         /// @param _tokenId The NFT to transfer
417         function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable{
418             require(msg.sender == CaDataContract.ownerOf(_tokenId) || ownerOperators[CaDataContract.atomOwner(_tokenId)][msg.sender] == true || msg.sender == tokenApprovals[_tokenId]);
419             require(_from == CaDataContract.ownerOf(_tokenId) && _to != 0x0);
420             require(_tokenId < totalSupply());
421             _transfer(_from, _to, _tokenId);
422             if(_isContract(_to))
423             {
424                 require(ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, "") == ERC721_RECEIVED);
425             }
426         }
427         
428         
429         /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
430         ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
431         ///  THEY MAY BE PERMANENTLY LOST
432         /// @dev Throws unless `msg.sender` is the current owner, an authorized
433         ///  operator, or the approved address for this NFT. Throws if `_from` is
434         ///  not the current owner. Throws if `_to` is the zero address. Throws if
435         ///  `_tokenId` is not a valid NFT.
436         /// @param _from The current owner of the NFT
437         /// @param _to The new owner
438         /// @param _tokenId The NFT to transfer
439         function transferFrom(address _from, address _to, uint256 _tokenId) external payable{
440             require(msg.sender == CaDataContract.ownerOf(_tokenId) || ownerOperators[CaDataContract.atomOwner(_tokenId)][msg.sender] == true || msg.sender == tokenApprovals[_tokenId]);
441             require(_from == CaDataContract.ownerOf(_tokenId) && _to != 0x0);
442             require(_tokenId < totalSupply());
443             _transfer(_from, _to, _tokenId);
444         }
445         
446         
447         /// @notice Set or reaffirm the approved address for an NFT
448         /// @dev The zero address indicates there is no approved address.
449         /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
450         ///  operator of the current owner.
451         /// @param _approved The new approved NFT controller
452         /// @param _tokenId The NFT to approve
453         function approve(address _approved, uint256 _tokenId) external payable {
454             require(msg.sender == CaDataContract.atomOwner(_tokenId) || ownerOperators[CaDataContract.atomOwner(_tokenId)][msg.sender]);
455             tokenApprovals[_tokenId] = _approved;
456             Approval(CaDataContract.atomOwner(_tokenId), _approved, _tokenId);
457         }
458         
459         /// @notice Enable or disable approval for a third party ("operator") to manage
460         ///  all of `msg.sender`'s assets.
461         /// @dev Emits the ApprovalForAll event. The contract MUST allow
462         ///  multiple operators per owner.
463         /// @param _operator Address to add to the set of authorized operators.
464         /// @param _approved True if the operator is approved, false to revoke approval
465         function setApprovalForAll(address _operator, bool _approved) external {
466             ownerOperators[msg.sender][_operator] = _approved;
467             ApprovalForAll(msg.sender, _operator, _approved);
468         }
469     
470         /// @notice Get the approved address for a single NFT
471         /// @dev Throws if `_tokenId` is not a valid NFT
472         /// @param _tokenId The NFT to find the approved address for
473         /// @return The approved address for this NFT, or the zero address if there is none
474         function getApproved(uint256 _tokenId) external view returns (address) {
475             return tokenApprovals[_tokenId];
476         }
477     
478         /// @notice Query if an address is an authorized operator for another address
479         /// @param _owner The address that owns the NFTs
480         /// @param _operator The address that acts on behalf of the owner
481         /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
482         function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
483             return ownerOperators[_owner][_operator];
484         }
485     
486     //ERC165
487 
488         bytes4 constant Sign_ERC165 =
489             bytes4(keccak256('supportsInterface(bytes4)'));
490         
491         bytes4 constant Sign_ERC721 =
492             bytes4(keccak256('balanceOf(address)')) ^
493             bytes4(keccak256('ownerOf(uint256)')) ^
494             bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) ^
495             bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
496             bytes4(keccak256('transferFrom(address,address,uint256)')) ^
497             bytes4(keccak256('approve(address,uint256)')) ^
498             bytes4(keccak256('setApprovalForAll(address,bool)')) ^
499             bytes4(keccak256('getApproved(uint256)')) ^
500             bytes4(keccak256('isApprovedForAll(address,address)'));
501             
502         function supportsInterface(bytes4 interfaceID) external view returns (bool)
503         {
504             return ((interfaceID == Sign_ERC165) || (interfaceID == Sign_ERC721));
505         }
506     
507     //ERC721TokenReceiver
508     
509         /// @notice Handle the receipt of an NFT
510         /// @dev The ERC721 smart contract calls this function on the
511         /// recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
512         /// of other than the magic value MUST result in the transaction being reverted.
513         /// @notice The contract address is always the message sender. 
514         /// @param _operator The address which called `safeTransferFrom` function
515         /// @param _from The address which previously owned the token
516         /// @param _tokenId The NFT identifier which is being transferred
517         /// @param _data Additional data with no specified format
518         /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
519         /// unless throwing 
520         
521         bytes4 constant ERC721_RECEIVED = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
522         
523         function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4){
524             return ERC721_RECEIVED;
525         }
526     
527     //ERC721MetaData
528     
529         string baseUri = "https://www.cryptoatoms.org/cres/uri/";
530     
531         function name() external view returns (string _name) {
532             return "Atom";
533         }
534     
535         function symbol() external view returns (string _symbol){
536             return "ATH";
537         }
538     
539         /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
540         /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
541         ///  3986. The URI may point to a JSON file that conforms to the "ERC721
542         ///  Metadata JSON Schema".
543         function tokenURI(uint256 _tokenId) external view returns (string){
544             require(_tokenId < totalSupply());
545             uint256 uid;
546             bytes32 bid;
547             uid = _tokenId;
548             if (uid == 0) 
549             {
550                 bid = '0';
551             }
552             else 
553             {
554                 while (uid > 0) 
555                 {
556                     bid = bytes32(uint(bid) / (2 ** 8));
557                     bid |= bytes32(((uid % 10) + 48) * 2 ** (8 * 31));
558                     uid /= 10;
559                 }
560             }
561             return string(abi.encodePacked(baseUri, bid));
562         }
563         
564         function setBaseUri (string _newBaseUri) external {
565             require(msg.sender == CaDataContract.COO() || msg.sender == CaDataContract.CTO() || msg.sender == CaDataContract.CFO());
566             baseUri = _newBaseUri;
567         }
568     
569     //ERC721Enumerable
570         
571         function totalSupply() public view returns (uint256 total){
572       	    return CaDataContract.totalSupply();
573       	}
574       	   
575       	/// @notice Enumerate valid NFTs
576         /// @dev Throws if `_index` >= `totalSupply()`.
577         /// @param _index A counter less than `totalSupply()`
578         /// @return The token identifier for the `_index`th NFT,
579         ///  (sort order not specified)
580         function tokenByIndex(uint256 _index) external view returns (uint256){
581             require(_index < totalSupply());
582             return _index;
583         }
584     
585         /// @notice Enumerate NFTs assigned to an owner
586         /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
587         ///  `_owner` is the zero address, representing invalid NFTs.
588         /// @param _owner An address where we are interested in NFTs owned by them
589         /// @param _index A counter less than `balanceOf(_owner)`
590         /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
591         ///   (sort order not specified)
592         function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256){
593             require(_index < CaDataContract.balanceOf(_owner));
594             uint64 counter = 0;
595             for (uint64 i = 0; i < CaDataContract.totalSupply(); i++)
596             {
597                 if (CaDataContract.atomOwner(i) == _owner) {
598                     if(counter == _index)
599                     {
600                         uint256 result = i;
601                         i = uint64(CaDataContract.totalSupply());
602                     }
603                     else
604                     {
605                         counter++;
606                     }
607                 }
608             }
609             return result;
610         }
611     
612     
613     //ERC20
614         
615         function decimals() external view returns (uint8 _decimals){
616             return 0;
617         }
618         
619         function implementsERC721() public pure returns (bool){
620             return true;
621         }
622         
623 }