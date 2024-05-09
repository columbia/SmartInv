1 pragma solidity ^0.5.3;
2 
3 library Strings {
4   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
5   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
6       bytes memory _ba = bytes(_a);
7       bytes memory _bb = bytes(_b);
8       bytes memory _bc = bytes(_c);
9       bytes memory _bd = bytes(_d);
10       bytes memory _be = bytes(_e);
11       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
12       bytes memory babcde = bytes(abcde);
13       uint k = 0;
14       uint i =0;
15       for (i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
16       for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
17       for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
18       for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
19       for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
20       return string(babcde);
21     }
22 
23     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
24         return strConcat(_a, _b, _c, _d, "");
25     }
26 
27     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
28         return strConcat(_a, _b, _c, "", "");
29     }
30 
31     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
32         return strConcat(_a, _b, "", "", "");
33     }
34 
35     function uint2str(uint i) internal pure returns (string memory) {
36         if (i == 0) return "0";
37         uint j = i;
38         uint len;
39         while (j != 0){
40             len++;
41             j /= 10;
42         }
43         bytes memory bstr = new bytes(len);
44         uint k = len - 1;
45         while (i != 0){
46             bstr[k--] = byte(uint8(48 + i % 10));
47             i /= 10;
48         }
49         return string(bstr);
50     }
51 }
52 contract AccessControl {
53     address payable public creatorAddress;
54     uint16 public totalSeraphims = 0;
55     mapping (address => bool) public seraphims;
56 
57     bool public isMaintenanceMode = true;
58  
59     modifier onlyCREATOR() {
60         require(msg.sender == creatorAddress);
61         _;
62     }
63 
64     modifier onlySERAPHIM() {
65       
66       require(seraphims[msg.sender] == true);
67         _;
68     }
69     modifier isContractActive {
70         require(!isMaintenanceMode);
71         _;
72     }
73     
74     // Constructor
75     constructor() public {
76         creatorAddress = msg.sender;
77     }
78     
79 //Seraphims are contracts or addresses that have write access
80     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
81         if (seraphims[_newSeraphim] == false) {
82             seraphims[_newSeraphim] = true;
83             totalSeraphims += 1;
84         }
85     }
86     
87     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
88         if (seraphims[_oldSeraphim] == true) {
89             seraphims[_oldSeraphim] = false;
90             totalSeraphims -= 1;
91         }
92     }
93 
94     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
95         isMaintenanceMode = _isMaintaining;
96     }
97 
98   
99 } 
100 
101 
102 
103 /**
104  * @title SafeMath
105  * @dev Unsigned math operations with safety checks that revert on error
106  */
107 library SafeMath {
108     /**
109     * @dev Multiplies two unsigned integers, reverts on overflow.
110     */
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
113         // benefit is lost if 'b' is also tested.
114         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
115         if (a == 0) {
116             return 0;
117         }
118 
119         uint256 c = a * b;
120         require(c / a == b);
121 
122         return c;
123     }
124 
125     /**
126     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
127     */
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         // Solidity only automatically asserts when dividing by 0
130         require(b > 0);
131         uint256 c = a / b;
132         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133 
134         return c;
135     }
136 
137     /**
138     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
139     */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b <= a);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148     * @dev Adds two unsigned integers, reverts on overflow.
149     */
150     function add(uint256 a, uint256 b) internal pure returns (uint256) {
151         uint256 c = a + b;
152         require(c >= a);
153 
154         return c;
155     }
156 
157     /**
158     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
159     * reverts when dividing by zero.
160     */
161     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162         require(b != 0);
163         return a % b;
164     }
165      function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) view public returns(uint8) {
166         uint256 genNum = uint256(blockhash(block.number-1)) + uint256(privateAddress);
167         return uint8(genNum % (maxRandom - min + 1)+min);
168     }
169 }
170 
171 
172 /**
173  * Utility library of inline functions on addresses
174  */
175 library Address {
176     /**
177      * Returns whether the target address is a contract
178      * @dev This function will return false if invoked during the constructor of a contract,
179      * as the code is not actually created until after the constructor finishes.
180      * @param account address of the account to check
181      * @return whether the target address is a contract
182      */
183     function isContract(address account) internal view returns (bool) {
184         uint256 size;
185         // XXX Currently there is no better way to check if there is a contract in an address
186         // than to check the size of the code at that address.
187         // See https://ethereum.stackexchange.com/a/14016/36603
188         // for more details about how this works.
189         // TODO Check this again before the Serenity release, because all addresses will be
190         // contracts then.
191         // solhint-disable-next-line no-inline-assembly
192         assembly { size := extcodesize(account) }
193         return size > 0;
194     }
195 }
196 
197 
198 /**
199  * @title IERC165
200  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
201  */
202 interface IERC165 {
203     /**
204      * @notice Query if a contract implements an interface
205      * @param interfaceId The interface identifier, as specified in ERC-165
206      * @dev Interface identification is specified in ERC-165. This function
207      * uses less than 30,000 gas.
208      */
209     function supportsInterface(bytes4 interfaceId) external view returns (bool);
210 }
211 
212 /**
213  * @title ERC165
214  * @author Matt Condon (@shrugs)
215  * @dev Implements ERC165 using a lookup table.
216  */
217 contract ERC165 is IERC165 {
218     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
219     /**
220      * 0x01ffc9a7 ===
221      *     bytes4(keccak256('supportsInterface(bytes4)'))
222      */
223 
224     /**
225      * @dev a mapping of interface id to whether or not it's supported
226      */
227     mapping(bytes4 => bool) private _supportedInterfaces;
228 
229     /**
230      * @dev A contract implementing SupportsInterfaceWithLookup
231      * implement ERC165 itself
232      */
233     constructor () internal {
234         _registerInterface(_INTERFACE_ID_ERC165);
235     }
236 
237     /**
238      * @dev implement supportsInterface(bytes4) using a lookup table
239      */
240     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
241         return _supportedInterfaces[interfaceId];
242     }
243 
244     /**
245      * @dev internal method for registering an interface
246      */
247     function _registerInterface(bytes4 interfaceId) internal {
248         require(interfaceId != 0xffffffff);
249         _supportedInterfaces[interfaceId] = true;
250     }
251 }
252 
253 /**
254  * @title ERC721 token receiver interface
255  * @dev Interface for any contract that wants to support safeTransfers
256  * from ERC721 asset contracts.
257  */
258 contract IERC721Receiver {
259     /**
260      * @notice Handle the receipt of an NFT
261      * @dev The ERC721 smart contract calls this function on the recipient
262      * after a `safeTransfer`. This function MUST return the function selector,
263      * otherwise the caller will revert the transaction. The selector to be
264      * returned can be obtained as `this.onERC721Received.selector`. This
265      * function MAY throw to revert and reject the transfer.
266      * Note: the ERC721 contract address is always the message sender.
267      * @param operator The address which called `safeTransferFrom` function
268      * @param from The address which previously owned the token
269      * @param tokenId The NFT identifier which is being transferred
270      * @param data Additional data with no specified format
271      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
272      */
273     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
274     public returns (bytes4);
275 }
276 
277 /**
278  * @title ERC721 Non-Fungible Token Standard basic interface
279  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
280  */
281 contract IERC721 is IERC165 {
282     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
283     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
284     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
285 
286     function balanceOf(address owner) public view returns (uint256 balance);
287     function ownerOf(uint256 tokenId) public view returns (address owner);
288 
289     function approve(address to, uint256 tokenId) public;
290     function getApproved(uint256 tokenId) public view returns (address operator);
291 
292     function setApprovalForAll(address operator, bool _approved) public;
293     function isApprovedForAll(address owner, address operator) public view returns (bool);
294 
295     function transferFrom(address from, address to, uint256 tokenId) public;
296     function safeTransferFrom(address from, address to, uint256 tokenId) public;
297 
298     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
299 }
300 
301 /**
302  * @title ERC721 token receiver interface
303  * @dev Interface for any contract that wants to support safeTransfers
304  * from ERC721 asset contracts.
305  */
306 contract ERC721Receiver {
307   /**
308    * @dev Magic value to be returned upon successful reception of an NFT
309    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
310    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
311    */
312   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
313 
314   /**
315    * @notice Handle the receipt of an NFT
316    * @dev The ERC721 smart contract calls this function on the recipient
317    * after a `safetransfer`. This function MAY throw to revert and reject the
318    * transfer. Return of other than the magic value MUST result in the
319    * transaction being reverted.
320    * Note: the contract address is always the message sender.
321    * @param _operator The address which called `safeTransferFrom` function
322    * @param _from The address which previously owned the token
323    * @param _tokenId The NFT identifier which is being transferred
324    * @param _data Additional data with no specified format
325    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
326    */
327   function onERC721Received(
328     address _operator,
329     address _from,
330     uint256 _tokenId,
331     bytes4 _data
332   )
333     public
334     returns(bytes4);
335 }
336 
337 contract OwnableDelegateProxy { }
338 
339 contract ProxyRegistry {
340     mapping(address => OwnableDelegateProxy) public proxies;
341 }
342 contract iABToken is AccessControl{
343  
344  
345     function balanceOf(address owner) public view returns (uint256);
346     function totalSupply() external view returns (uint256) ;
347     function ownerOf(uint256 tokenId) public view returns (address) ;
348     function setMaxAngels() external;
349     function setMaxAccessories() external;
350     function setMaxMedals()  external ;
351     function initAngelPrices() external;
352     function initAccessoryPrices() external ;
353     function setCardSeriesPrice(uint8 _cardSeriesId, uint _newPrice) external;
354     function approve(address to, uint256 tokenId) public;
355     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) view public returns(uint8) ;
356     function tokenURI(uint256 _tokenId) public pure returns (string memory) ;
357     function baseTokenURI() public pure returns (string memory) ;
358     function name() external pure returns (string memory _name) ;
359     function symbol() external pure returns (string memory _symbol) ;
360     function getApproved(uint256 tokenId) public view returns (address) ;
361     function setApprovalForAll(address to, bool approved) public ;
362     function isApprovedForAll(address owner, address operator) public view returns (bool);
363     function transferFrom(address from, address to, uint256 tokenId) public ;
364     function safeTransferFrom(address from, address to, uint256 tokenId) public ;
365     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public ;
366     function _exists(uint256 tokenId) internal view returns (bool) ;
367     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) ;
368     function _mint(address to, uint256 tokenId) internal ;
369     function mintABToken(address owner, uint8 _cardSeriesId, uint16 _power, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue, string memory _name, uint16 _experience, uint16 _oldId) public;
370     function addABTokenIdMapping(address _owner, uint256 _tokenId) private ;
371     function getPrice(uint8 _cardSeriesId) public view returns (uint);
372     function buyAngel(uint8 _angelSeriesId) public payable ;
373     function buyAccessory(uint8 _accessorySeriesId) public payable ;
374     function getAura(uint8 _angelSeriesId) pure public returns (uint8 auraRed, uint8 auraYellow, uint8 auraBlue) ;
375     function getAngelPower(uint8 _angelSeriesId) private view returns (uint16) ;
376     function getABToken(uint256 tokenId) view public returns(uint8 cardSeriesId, uint16 power, uint16 auraRed, uint16 auraYellow, uint16 auraBlue, string memory name, uint16 experience, uint64 lastBattleTime, uint16 lastBattleResult, address owner, uint16 oldId);
377     function setAuras(uint256 tokenId, uint16 _red, uint16 _blue, uint16 _yellow) external;
378     function setName(uint256 tokenId,string memory namechange) public ;
379     function setExperience(uint256 tokenId, uint16 _experience) external;
380     function setLastBattleResult(uint256 tokenId, uint16 _result) external ;
381     function setLastBattleTime(uint256 tokenId) external;
382     function setLastBreedingTime(uint256 tokenId) external ;
383     function setoldId(uint256 tokenId, uint16 _oldId) external;
384     function getABTokenByIndex(address _owner, uint64 _index) view external returns(uint256) ;
385     function _burn(address owner, uint256 tokenId) internal ;
386     function _burn(uint256 tokenId) internal ;
387     function _transferFrom(address from, address to, uint256 tokenId) internal ;
388     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) internal returns (bool);
389     function _clearApproval(uint256 tokenId) private ;
390 }
391 
392 /**
393  * @title ERC721 Non-Fungible Token Standard basic implementation
394  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
395  */
396 contract ABToken is IERC721, iABToken, ERC165 {
397     using SafeMath for uint256;
398     using SafeMath for uint8;
399     using Address for address;
400     uint256 public totalTokens;
401     
402     //Mapping or which IDs each address owns
403     mapping(address => uint256[]) public ownerABTokenCollection;
404     
405 
406     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
407     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
408     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
409 
410     // Mapping from token ID to owner
411     mapping (uint256 => address) private _tokenOwner;
412 
413     // Mapping from token ID to approved address
414     mapping (uint256 => address) private _tokenApprovals;
415 
416     // Mapping from owner to number of owned token
417     mapping (address => uint256) private _ownedTokensCount;
418 
419     // Mapping from owner to operator approvals
420     mapping (address => mapping (address => bool)) private _operatorApprovals;
421 
422     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
423     /*
424      * 0x80ac58cd ===
425      *     bytes4(keccak256('balanceOf(address)')) ^
426      *     bytes4(keccak256('ownerOf(uint256)')) ^
427      *     bytes4(keccak256('approve(address,uint256)')) ^
428      *     bytes4(keccak256('getApproved(uint256)')) ^
429      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
430      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
431      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
432      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
433      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
434      */
435      
436      
437        //current and max numbers of issued tokens for each series 
438     uint32[100] public currentTokenNumbers;
439     uint32[100] public maxTokenNumbers;
440     
441     //current price of each angel and accessory series
442     uint[24] public angelPrice;
443     uint[18] public accessoryPrice;
444  
445      address proxyRegistryAddress; 
446      
447    //  Main data structure for each token 
448 struct ABCard {
449     uint256 tokenId;       
450         uint8 cardSeriesId;
451         //This is 0 to 23 for angels, 24 to 42 for pets, 43 to 60 for accessories, 61 to 72 for medals
452         //address owner; 
453         //already accounted in mapping. 
454         uint16 power;
455         //This number is luck for pets and battlepower for angels
456         uint16 auraRed;
457         uint16 auraYellow;
458         uint16 auraBlue;
459         string name;
460         uint16 experience;
461         uint64 lastBattleTime;
462         uint64 lastBreedingTime;
463         uint16 lastBattleResult;
464         uint16 oldId; //for cards transfered from the first version of the game. 
465     }
466      //Main mapping storing an ABCard for each token ID
467       mapping(uint256 => ABCard) public ABTokenCollection;
468   
469     constructor() public {
470         // register the supported interfaces to conform to ERC721 via ERC165
471         _registerInterface(_INTERFACE_ID_ERC721);
472     }
473 
474     /**
475      * @dev Gets the balance of the specified address
476      * @param owner address to query the balance of
477      * @return uint256 representing the amount owned by the passed address
478      */
479     function balanceOf(address owner) public view returns (uint256) {
480         require(owner != address(0));
481         return _ownedTokensCount[owner];
482     }
483 
484  function totalSupply() external view returns (uint256) {
485      return totalTokens;
486  }
487     /**
488      * @dev Gets the owner of the specified token ID
489      * @param tokenId uint256 ID of the token to query the owner of
490      * @return owner address currently marked as the owner of the given token ID
491      */
492     function ownerOf(uint256 tokenId) public view returns (address) {
493         address owner = _tokenOwner[tokenId];
494         require(owner != address(0));
495         return owner;
496     }
497     
498     //Initial function to set the maximum numbers of each angel card
499 
500 function setMaxAngels() external onlyCREATOR {
501     uint i =0;
502    
503      //Angels 0 and 1 have no max
504      //Lucifer and Michael have max numbers 250
505      maxTokenNumbers[2] = 250;
506      maxTokenNumbers[3] = 250;
507      maxTokenNumbers[4] = 45;
508      maxTokenNumbers[5] = 50;
509      
510     for (i=6; i<15; i++) {
511         maxTokenNumbers[i]= 45;
512     }
513      for (i=15; i<24; i++) {
514         maxTokenNumbers[i]= 65;
515     }
516    
517     
518 }
519 
520 //Initial function to set the maximum number of accessories
521 function setMaxAccessories() external onlyCREATOR {
522      uint i = 0;
523      for (i=43; i<60; i++) {
524         maxTokenNumbers[i]= 200;
525     }
526 }
527 
528 //Initial function to set the max number of medals
529   function setMaxMedals() onlyCREATOR external  {
530       maxTokenNumbers[61] = 5000;
531       maxTokenNumbers[62] = 5000;
532       maxTokenNumbers[63] = 5000;
533       maxTokenNumbers[64] = 5000;
534       maxTokenNumbers[65] = 500;
535       maxTokenNumbers[66] = 500;
536       maxTokenNumbers[67] = 200;
537       maxTokenNumbers[68] = 200;
538       maxTokenNumbers[69] = 200;
539       maxTokenNumbers[70] = 100;
540       maxTokenNumbers[71] = 100;
541       maxTokenNumbers[72] = 50;
542   }
543     //Function called once at the beginning to set the prices of all the angel cards. 
544     function initAngelPrices() external onlyCREATOR {
545        angelPrice[0] = 0;
546        angelPrice[1] = 30000000000000000;
547        angelPrice[2] = 666000000000000000;
548        angelPrice[3] = 800000000000000000;
549        angelPrice[4] = 10000000000000000;
550        angelPrice[5] = 10000000000000000;
551        angelPrice[6] = 20000000000000000;
552        angelPrice[7] = 25000000000000000;
553        angelPrice[8] = 16000000000000000;
554        angelPrice[9] = 18000000000000000;
555        angelPrice[10] = 14000000000000000;
556        angelPrice[11] = 20000000000000000;
557        angelPrice[12] = 24000000000000000;
558        angelPrice[13] = 28000000000000000;
559        angelPrice[14] = 40000000000000000;
560        angelPrice[15] = 50000000000000000;
561        angelPrice[16] = 53000000000000000;
562        angelPrice[17] = 60000000000000000;
563        angelPrice[18] = 65000000000000000;
564        angelPrice[19] = 70000000000000000;
565        angelPrice[20] = 75000000000000000;
566        angelPrice[21] = 80000000000000000;
567        angelPrice[22] = 85000000000000000;
568        angelPrice[23] = 90000000000000000;
569       
570     }
571     
572         //Function called once at the beginning to set the prices of all the accessory cards. 
573     function initAccessoryPrices() external onlyCREATOR {
574        accessoryPrice[0] = 20000000000000000;
575        accessoryPrice[1] = 60000000000000000;
576        accessoryPrice[2] = 40000000000000000;
577        accessoryPrice[3] = 90000000000000000;
578        accessoryPrice[4] = 80000000000000000;
579        accessoryPrice[5] = 160000000000000000;
580        accessoryPrice[6] = 60000000000000000;
581        accessoryPrice[7] = 120000000000000000;
582        accessoryPrice[8] = 60000000000000000;
583        accessoryPrice[9] = 120000000000000000;
584        accessoryPrice[10] = 60000000000000000;
585        accessoryPrice[11] = 120000000000000000;
586        accessoryPrice[12] = 200000000000000000;
587        accessoryPrice[13] = 200000000000000000;
588        accessoryPrice[14] = 200000000000000000;
589        accessoryPrice[15] = 200000000000000000;
590        accessoryPrice[16] = 500000000000000000;
591        accessoryPrice[17] = 600000000000000000;
592     }
593    
594     
595     // Developer function to change the price (in wei) for a card series. 
596     function setCardSeriesPrice(uint8 _cardSeriesId, uint _newPrice) external onlyCREATOR {
597         if (_cardSeriesId <24) {angelPrice[_cardSeriesId] = _newPrice;} else {
598         if ((_cardSeriesId >42) && (_cardSeriesId < 61)) {accessoryPrice[(_cardSeriesId-43)] = _newPrice;}
599         }
600         
601         
602     }
603 
604    function withdrawEther() external onlyCREATOR {
605     creatorAddress.transfer(address(this).balance);
606 }
607 
608     /**
609      * @dev Approves another address to transfer the given token ID
610      * The zero address indicates there is no approved address.
611      * There can only be one approved address per token at a given time.
612      * Can only be called by the token owner or an approved operator.
613      * @param to address to be approved for the given token ID
614      * @param tokenId uint256 ID of the token to be approved
615      */
616     function approve(address to, uint256 tokenId) public {
617         address owner = ownerOf(tokenId);
618         require(to != owner);
619         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
620 
621         _tokenApprovals[tokenId] = to;
622         emit Approval(owner, to, tokenId);
623     }
624     
625         function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) view public returns(uint8) {
626         uint256 genNum = uint256(blockhash(block.number-1)) + uint256(privateAddress);
627         return uint8(genNum % (maxRandom - min + 1)+min);
628     }
629 
630    /**
631    * @dev Returns an URI for a given token ID
632    */
633   function tokenURI(uint256 _tokenId) public pure returns (string memory) {
634     return Strings.strConcat(
635         baseTokenURI(),
636         Strings.uint2str(_tokenId)
637     );
638   }
639   
640   function baseTokenURI() public pure returns (string memory) {
641     return "https://www.angelbattles.com/URI/";
642   }
643   
644    /// @notice A descriptive name for a collection of NFTs in this contract
645     function name() external pure returns (string memory _name) {
646         return "Angel Battle Token";
647     }
648 
649     /// @notice An abbreviated name for NFTs in this contract
650     function symbol() external pure returns (string memory _symbol) {
651         return "ABT";
652     }
653   
654   
655     
656 
657     /**
658      * @dev Gets the approved address for a token ID, or zero if no address set
659      * Reverts if the token ID does not exist.
660      * @param tokenId uint256 ID of the token to query the approval of
661      * @return address currently approved for the given token ID
662      */
663     function getApproved(uint256 tokenId) public view returns (address) {
664         require(_exists(tokenId));
665         return _tokenApprovals[tokenId];
666     }
667 
668     /**
669      * @dev Sets or unsets the approval of a given operator
670      * An operator is allowed to transfer all tokens of the sender on their behalf
671      * @param to operator address to set the approval
672      * @param approved representing the status of the approval to be set
673      */
674     function setApprovalForAll(address to, bool approved) public {
675         require(to != msg.sender);
676         _operatorApprovals[msg.sender][to] = approved;
677         emit ApprovalForAll(msg.sender, to, approved);
678     }
679 
680     /**
681      * @dev Tells whether an operator is approved by a given owner
682      * @param owner owner address which you want to query the approval of
683      * @param operator operator address which you want to query the approval of
684      * @return bool whether the given operator is approved by the given owner
685      */
686     function isApprovedForAll(address owner, address operator) public view returns (bool) {
687         return _operatorApprovals[owner][operator];
688     }
689     
690     /**
691    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
692    */
693  
694 
695 
696     /**
697      * @dev Transfers the ownership of a given token ID to another address
698      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
699      * Requires the msg sender to be the owner, approved, or operator
700      * @param from current owner of the token
701      * @param to address to receive the ownership of the given token ID
702      * @param tokenId uint256 ID of the token to be transferred
703     */
704     function transferFrom(address from, address to, uint256 tokenId) public {
705         require(_isApprovedOrOwner(msg.sender, tokenId));
706 
707         _transferFrom(from, to, tokenId);
708     }
709 
710     /**
711      * @dev Safely transfers the ownership of a given token ID to another address
712      * If the target address is a contract, it must implement `onERC721Received`,
713      * which is called upon a safe transfer, and return the magic value
714      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
715      * the transfer is reverted.
716      *
717      * Requires the msg sender to be the owner, approved, or operator
718      * @param from current owner of the token
719      * @param to address to receive the ownership of the given token ID
720      * @param tokenId uint256 ID of the token to be transferred
721     */
722     function safeTransferFrom(address from, address to, uint256 tokenId) public {
723         safeTransferFrom(from, to, tokenId, "");
724     }
725 
726     /**
727      * @dev Safely transfers the ownership of a given token ID to another address
728      * If the target address is a contract, it must implement `onERC721Received`,
729      * which is called upon a safe transfer, and return the magic value
730      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
731      * the transfer is reverted.
732      * Requires the msg sender to be the owner, approved, or operator
733      * @param from current owner of the token
734      * @param to address to receive the ownership of the given token ID
735      * @param tokenId uint256 ID of the token to be transferred
736      * @param _data bytes data to send along with a safe transfer check
737      */
738     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
739         transferFrom(from, to, tokenId);
740         require(_checkOnERC721Received(from, to, tokenId, _data));
741     }
742 
743     /**
744      * @dev Returns whether the specified token exists
745      * @param tokenId uint256 ID of the token to query the existence of
746      * @return whether the token exists
747      */
748     function _exists(uint256 tokenId) internal view returns (bool) {
749         address owner = _tokenOwner[tokenId];
750         return owner != address(0);
751     }
752 
753     /**
754      * @dev Returns whether the given spender can transfer a given token ID
755      * @param spender address of the spender to query
756      * @param tokenId uint256 ID of the token to be transferred
757      * @return bool whether the msg.sender is approved for the given token ID,
758      *    is an operator of the owner, or is the owner of the token
759      */
760     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
761         address owner = ownerOf(tokenId);
762         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
763     }
764 
765     /**
766      * @dev Internal function to mint a new token
767      * Reverts if the given token ID already exists
768      * @param to The address that will own the minted token
769      * @param tokenId uint256 ID of the token to be minted
770      */
771     function _mint(address to, uint256 tokenId) internal {
772         require(to != address(0));
773         require(!_exists(tokenId));
774 
775         _tokenOwner[tokenId] = to;
776         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
777         addABTokenIdMapping(to, tokenId);
778         emit Transfer(address(0), to, tokenId);
779     }
780     function mintABToken(address owner, uint8 _cardSeriesId, uint16 _power, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue, string memory _name, uint16 _experience, uint16 _oldId) public onlySERAPHIM {
781         require((currentTokenNumbers[_cardSeriesId] < maxTokenNumbers[_cardSeriesId] || maxTokenNumbers[_cardSeriesId] == 0));
782         require(_cardSeriesId <100);
783            ABCard storage abcard = ABTokenCollection[totalTokens];
784            abcard.power = _power;
785            abcard.cardSeriesId= _cardSeriesId;
786            abcard.auraRed = _auraRed;
787            abcard.auraYellow= _auraYellow;
788            abcard.auraBlue= _auraBlue;
789            abcard.name = _name;
790            abcard.experience = _experience;
791            abcard.tokenId = totalTokens;
792            abcard.lastBattleTime = uint64(now);
793            abcard.lastBreedingTime = uint64(now);
794            abcard.lastBattleResult = 0;
795            abcard.oldId = _oldId;
796            _mint(owner, totalTokens);
797            totalTokens = totalTokens +1;
798            currentTokenNumbers[_cardSeriesId] ++;
799     }
800     
801     function addABTokenIdMapping(address _owner, uint256 _tokenId) private {
802             uint256[] storage owners = ownerABTokenCollection[_owner];
803             owners.push(_tokenId);
804     }
805     
806 
807     
808     function getPrice(uint8 _cardSeriesId) public view returns (uint) {
809         if (_cardSeriesId <24) {return angelPrice[_cardSeriesId];}
810         if ((_cardSeriesId >42) && (_cardSeriesId < 61)) {return accessoryPrice[(_cardSeriesId-43)];}
811         return 0;
812     }
813     
814     function buyAngel(uint8 _angelSeriesId) public payable {
815         //don't create another card if we are already at the max
816         if ((maxTokenNumbers[_angelSeriesId] <= currentTokenNumbers[_angelSeriesId]) && (_angelSeriesId >1 )) {revert();}
817         //don't create another card if they haven't sent enough money. 
818         if (msg.value < angelPrice[_angelSeriesId]) {revert();} 
819         //don't create an angel card if they are trying to create a different type of card. 
820          if ((_angelSeriesId<0) || (_angelSeriesId > 23)) {revert();}
821         uint8 auraRed;
822         uint8 auraYellow;
823         uint8 auraBlue;
824         uint16 power;
825         (auraRed, auraYellow, auraBlue) = getAura(_angelSeriesId);
826         (power) = getAngelPower(_angelSeriesId);
827     
828        mintABToken(msg.sender, _angelSeriesId, power, auraRed, auraYellow, auraBlue,"", 0, 0);
829        
830     }
831     
832     
833     function buyAccessory(uint8 _accessorySeriesId) public payable {
834         //don't create another card if we are already at the max
835         if (maxTokenNumbers[_accessorySeriesId] <= currentTokenNumbers[_accessorySeriesId]) {revert();}
836         //don't create another card if they haven't sent enough money. 
837         if (msg.value < accessoryPrice[_accessorySeriesId-43]) {revert();} 
838         //don't create a card if they are trying to create a different type of card. 
839         if ((_accessorySeriesId<43) || (_accessorySeriesId > 60)) {revert();}
840         mintABToken(msg.sender,_accessorySeriesId, 0, 0, 0, 0, "",0, 0);
841        
842      
843        
844     }
845     
846     //Returns the Aura color of each angel
847     function getAura(uint8 _angelSeriesId) pure public returns (uint8 auraRed, uint8 auraYellow, uint8 auraBlue) {
848         if (_angelSeriesId == 0) {return(0,0,1);}
849         if (_angelSeriesId == 1) {return(0,1,0);}
850         if (_angelSeriesId == 2) {return(1,0,1);}
851         if (_angelSeriesId == 3) {return(1,1,0);}
852         if (_angelSeriesId == 4) {return(1,0,0);}
853         if (_angelSeriesId == 5) {return(0,1,0);}
854         if (_angelSeriesId == 6) {return(1,0,1);}
855         if (_angelSeriesId == 7) {return(0,1,1);}
856         if (_angelSeriesId == 8) {return(1,1,0);}
857         if (_angelSeriesId == 9) {return(0,0,1);}
858         if (_angelSeriesId == 10)  {return(1,0,0);}
859         if (_angelSeriesId == 11) {return(0,1,0);}
860         if (_angelSeriesId == 12) {return(1,0,1);}
861         if (_angelSeriesId == 13) {return(0,1,1);}
862         if (_angelSeriesId == 14) {return(1,1,0);}
863         if (_angelSeriesId == 15) {return(0,0,1);}
864         if (_angelSeriesId == 16)  {return(1,0,0);}
865         if (_angelSeriesId == 17) {return(0,1,0);}
866         if (_angelSeriesId == 18) {return(1,0,1);}
867         if (_angelSeriesId == 19) {return(0,1,1);}
868         if (_angelSeriesId == 20) {return(1,1,0);}
869         if (_angelSeriesId == 21) {return(0,0,1);}
870         if (_angelSeriesId == 22)  {return(1,0,0);}
871         if (_angelSeriesId == 23) {return(0,1,1);}
872     }
873    
874     function getAngelPower(uint8 _angelSeriesId) private view returns (uint16) {
875         uint8 randomPower = getRandomNumber(10,0,msg.sender);
876         if (_angelSeriesId >=4) {
877         return (100 + 10 * ((_angelSeriesId - 4) + randomPower));
878         }
879         if (_angelSeriesId == 0 ) {
880         return (50 + randomPower);
881         }
882          if (_angelSeriesId == 1) {
883         return (120 + randomPower);
884         }
885          if (_angelSeriesId == 2) {
886         return (250 + randomPower);
887         }
888         if (_angelSeriesId == 3) {
889         return (300 + randomPower);
890         }
891         
892     }
893     
894     function getCurrentTokenNumbers(uint8 _cardSeriesId) view public returns (uint32) {
895         return currentTokenNumbers[_cardSeriesId];
896 }
897        function getMaxTokenNumbers(uint8 _cardSeriesId) view public returns (uint32) {
898         return maxTokenNumbers[_cardSeriesId];
899 }
900 
901 
902     function getABToken(uint256 tokenId) view public returns(uint8 cardSeriesId, uint16 power, uint16 auraRed, uint16 auraYellow, uint16 auraBlue, string memory name, uint16 experience, uint64 lastBattleTime, uint16 lastBattleResult, address owner, uint16 oldId) {
903         ABCard memory abcard = ABTokenCollection[tokenId];
904         cardSeriesId = abcard.cardSeriesId;
905         power = abcard.power;
906         experience = abcard.experience;
907         auraRed = abcard.auraRed;
908         auraBlue = abcard.auraBlue;
909         auraYellow = abcard.auraYellow;
910         name = abcard.name;
911         lastBattleTime = abcard.lastBattleTime;
912         lastBattleResult = abcard.lastBattleResult;
913         oldId = abcard.oldId;
914         owner = ownerOf(tokenId);
915     }
916     
917     
918      function setAuras(uint256 tokenId, uint16 _red, uint16 _blue, uint16 _yellow) external onlySERAPHIM {
919         ABCard storage abcard = ABTokenCollection[tokenId];
920         if (abcard.tokenId == tokenId) {
921             abcard.auraRed = _red;
922             abcard.auraYellow = _yellow;
923             abcard.auraBlue = _blue;
924     }
925     }
926     
927      function setName(uint256 tokenId,string memory namechange) public {
928         ABCard storage abcard = ABTokenCollection[tokenId];
929         if (msg.sender != ownerOf(tokenId)) {revert();}
930         if (abcard.tokenId == tokenId) {
931             abcard.name = namechange;
932     }
933     }
934     
935     function setExperience(uint256 tokenId, uint16 _experience) external onlySERAPHIM {
936         ABCard storage abcard = ABTokenCollection[tokenId];
937         if (abcard.tokenId == tokenId) {
938             abcard.experience = _experience;
939     }
940     }
941     
942     function setLastBattleResult(uint256 tokenId, uint16 _result) external onlySERAPHIM {
943         ABCard storage abcard = ABTokenCollection[tokenId];
944         if (abcard.tokenId == tokenId) {
945             abcard.lastBattleResult = _result;
946     }
947     }
948     
949      function setLastBattleTime(uint256 tokenId) external onlySERAPHIM {
950         ABCard storage abcard = ABTokenCollection[tokenId];
951         if (abcard.tokenId == tokenId) {
952             abcard.lastBattleTime = uint64(now);
953     }
954     }
955     
956        function setLastBreedingTime(uint256 tokenId) external onlySERAPHIM {
957         ABCard storage abcard = ABTokenCollection[tokenId];
958         if (abcard.tokenId == tokenId) {
959             abcard.lastBreedingTime = uint64(now);
960     }
961     }
962     
963       function setoldId(uint256 tokenId, uint16 _oldId) external onlySERAPHIM {
964         ABCard storage abcard = ABTokenCollection[tokenId];
965         if (abcard.tokenId == tokenId) {
966             abcard.oldId = _oldId;
967     }
968     }
969     
970     
971     function getABTokenByIndex(address _owner, uint64 _index) view external returns(uint256) {
972         if (_index >= ownerABTokenCollection[_owner].length) {
973             return 0; }
974         return ownerABTokenCollection[_owner][_index];
975     }
976 
977    /**
978      * @dev external function to burn a specific token
979      * Reverts if the token does not exist
980      * @param tokenId uint256 ID of the token being burned
981      * Only the owner can burn their token. 
982      */
983     function burn(uint256 tokenId) external {
984         require(ownerOf(tokenId) == msg.sender);
985         _clearApproval(tokenId);
986         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].sub(1);
987         _tokenOwner[tokenId] = address(0);
988         emit Transfer(msg.sender, address(0), tokenId);
989     }
990     
991      /**
992      * @dev external function to burn a specific token
993      * Reverts if the token does not exist
994      * @param tokenId uint256 ID of the token being burned
995      * Only the owner can burn their token. 
996      * This function allows a new token type to be reissued. This preserves rarity, while the burn functio increases rarity
997      */
998     function burnAndRecycle(uint256 tokenId) external {
999         require(ownerOf(tokenId) == msg.sender);
1000         uint8 cardSeriesId;
1001         _clearApproval(tokenId);
1002         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].sub(1);
1003         _tokenOwner[tokenId] = address(0);
1004         (cardSeriesId,,,,,,,,,,) = getABToken (tokenId);
1005         if (currentTokenNumbers[cardSeriesId] >= 1) {
1006             currentTokenNumbers[cardSeriesId] = currentTokenNumbers[cardSeriesId] - 1;
1007         }
1008         emit Transfer(msg.sender, address(0), tokenId);
1009     }
1010 
1011 
1012     /**
1013      * @dev Internal function to burn a specific token
1014      * Reverts if the token does not exist
1015      * Deprecated, use _burn(uint256) instead.
1016      * @param owner owner of the token to burn
1017      * @param tokenId uint256 ID of the token being burned
1018      */
1019     function _burn(address owner, uint256 tokenId) internal {
1020         require(ownerOf(tokenId) == owner);
1021 
1022         _clearApproval(tokenId);
1023 
1024         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
1025         _tokenOwner[tokenId] = address(0);
1026 
1027         emit Transfer(owner, address(0), tokenId);
1028     }
1029 
1030     /**
1031      * @dev Internal function to burn a specific token
1032      * Reverts if the token does not exist
1033      * @param tokenId uint256 ID of the token being burned
1034      */
1035     function _burn(uint256 tokenId) internal {
1036         _burn(ownerOf(tokenId), tokenId);
1037     }
1038 
1039     /**
1040      * @dev Internal function to transfer ownership of a given token ID to another address.
1041      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1042      * @param from current owner of the token
1043      * @param to address to receive the ownership of the given token ID
1044      * @param tokenId uint256 ID of the token to be transferred
1045     */
1046     function _transferFrom(address from, address to, uint256 tokenId) internal {
1047         require(ownerOf(tokenId) == from);
1048         require(to != address(0));
1049 
1050         _clearApproval(tokenId);
1051 
1052         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
1053         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
1054 
1055         _tokenOwner[tokenId] = to;
1056         addABTokenIdMapping(to, tokenId);
1057         emit Transfer(from, to, tokenId);
1058     }
1059 
1060     /**
1061      * @dev Internal function to invoke `onERC721Received` on a target address
1062      * The call is not executed if the target address is not a contract
1063      * @param from address representing the previous owner of the given token ID
1064      * @param to target address that will receive the tokens
1065      * @param tokenId uint256 ID of the token to be transferred
1066      * @param _data bytes optional data to send along with the call
1067      * @return whether the call correctly returned the expected magic value
1068      */
1069     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1070         internal returns (bool)
1071     {
1072         if (!to.isContract()) {
1073             return true;
1074         }
1075 
1076         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1077         return (retval == _ERC721_RECEIVED);
1078     }
1079 
1080     /**
1081      * @dev Private function to clear current approval of a given token ID
1082      * @param tokenId uint256 ID of the token to be transferred
1083      */
1084     function _clearApproval(uint256 tokenId) private {
1085         if (_tokenApprovals[tokenId] != address(0)) {
1086             _tokenApprovals[tokenId] = address(0);
1087         }
1088     }
1089 }