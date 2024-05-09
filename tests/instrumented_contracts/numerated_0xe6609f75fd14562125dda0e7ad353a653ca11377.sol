1 pragma solidity ^0.4.18;
2 /* ==================================================================== */
3 /* Copyright (c) 2018 The Priate Conquest Project.  All rights reserved.
4 /* 
5 /* https://www.pirateconquest.com One of the world's slg games of blockchain 
6 /*  
7 /* authors rainy@livestar.com/Jonny.Fu@livestar.com
8 /*                 
9 /* ==================================================================== */
10 /**
11  * @title Ownable
12  * @dev The Ownable contract has an owner address, and provides basic authorization control
13  * functions, this simplifies the implementation of "user permissions".
14  */
15 contract Ownable {
16   address public owner;
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20   /*
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 }
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev modifier to allow actions only when the contract IS paused
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev modifier to allow actions only when the contract IS NOT paused
68    */
69   modifier whenPaused {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() external onlyOwner whenNotPaused returns (bool) {
78     paused = true;
79     Pause();
80     return true;
81   }
82 
83   /**
84    * @dev called by the owner to unpause, returns to normal state
85    */
86   function unpause() external onlyOwner whenPaused returns (bool) {
87     paused = false;
88     Unpause();
89     return true;
90   }
91 }
92 
93 contract AccessAdmin is Pausable {
94 
95   /// @dev Admin Address
96   mapping (address => bool) adminContracts;
97 
98   /// @dev Trust contract
99   mapping (address => bool) actionContracts;
100 
101   function setAdminContract(address _addr, bool _useful) public onlyOwner {
102     require(_addr != address(0));
103     adminContracts[_addr] = _useful;
104   }
105 
106   modifier onlyAdmin {
107     require(adminContracts[msg.sender]); 
108     _;
109   }
110 
111   function setActionContract(address _actionAddr, bool _useful) public onlyAdmin {
112     actionContracts[_actionAddr] = _useful;
113   }
114 
115   modifier onlyAccess() {
116     require(actionContracts[msg.sender]);
117     _;
118   }
119 }
120 
121 
122 /// @title ERC-721 Non-Fungible Token Standard
123 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
124 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd
125 contract ERC721 /* is ERC165 */ {
126   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
127   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
128   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
129 
130   function balanceOf(address _owner) external view returns (uint256);
131   function ownerOf(uint256 _tokenId) external view returns (address);
132   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
133   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
134   function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
135   function approve(address _approved, uint256 _tokenId) external payable;
136   function setApprovalForAll(address _operator, bool _approved) external;
137   function getApproved(uint256 _tokenId) external view returns (address);
138   function isApprovedForAll(address _owner, address _operator) external view returns (bool);
139 }
140 
141 interface ERC165 {
142      function supportsInterface(bytes4 interfaceID) external view returns (bool);
143 }
144 
145 /// @title ERC-721 Non-Fungible Token Standard
146 interface ERC721TokenReceiver {
147 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
148 }
149 
150 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
151 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
152 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f
153 interface ERC721Metadata /* is ERC721 */ {
154     function name() external view returns (string _name);
155     function symbol() external view returns (string _symbol);
156     function tokenURI(uint256 _tokenId) external view returns (string);
157 }
158 
159 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
160 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
161 ///  Note: the ERC-165 identifier for this interface is 0x780e9d63
162 interface ERC721Enumerable /* is ERC721 */ {
163     function totalSupply() external view returns (uint256);
164     function tokenByIndex(uint256 _index) external view returns (uint256);
165     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
166 }
167 
168 contract CaptainToken is AccessAdmin, ERC721 {
169   using SafeMath for SafeMath;
170   //event 
171   event CreateCaptain(uint tokenId,uint32 captainId, address _owner, uint256 _price);
172   //ERC721
173   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
174   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
175   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
176 
177   struct Captain {
178     uint32 captainId;  
179     uint32 color;   
180     uint32 atk; 
181     uint32 defense;
182     uint32 atk_min;
183     uint32 atk_max;
184   }
185 
186 
187   Captain[] public captains; //dynamic Array
188   function CaptainToken() public {
189     captains.length += 1;
190     setAdminContract(msg.sender,true);
191     setActionContract(msg.sender,true);
192   }
193 
194   /**MAPPING**/
195   /// @dev tokenId to owner  tokenId -> address
196   mapping (uint256 => address) public captainTokenIdToOwner;
197   /// @dev Equipment token ID search in owner array captainId -> tokenId
198   mapping (uint256 => uint256) captainIdToOwnerIndex;  
199   /// @dev captains owner by the owner (array)
200   mapping (address => uint256[]) ownerToCaptainArray;
201   /// @dev price of each token
202   mapping (uint256 => uint256) captainTokenIdToPrice;
203   /// @dev token count of captain
204   mapping (uint32 => uint256) tokenCountOfCaptain;
205   /// @dev tokens by the captain
206   mapping (uint256 => uint32) IndexToCaptain;
207   /// @dev The authorized address for each Captain
208   mapping (uint256 => address) captainTokenIdToApprovals;
209   /// @dev The authorized operators for each address
210   mapping (address => mapping (address => bool)) operatorToApprovals;
211   mapping(uint256 => bool) tokenToSell;
212   /// @dev captain by the owner (array)
213   mapping (address => uint256[]) ownerToCaptainsArray;
214   
215 
216   /*** CONSTRUCTOR ***/
217   /// @dev Amount of tokens destroyed
218   uint256 destroyCaptainCount;
219   
220   // modifier
221   /// @dev Check if token ID is valid
222   modifier isValidToken(uint256 _tokenId) {
223     require(_tokenId >= 1 && _tokenId <= captains.length);
224     require(captainTokenIdToOwner[_tokenId] != address(0)); 
225     _;
226   }
227   modifier canTransfer(uint256 _tokenId) {
228     require(msg.sender == captainTokenIdToOwner[_tokenId] || msg.sender == captainTokenIdToApprovals[_tokenId]);
229     _;
230   }
231   /// @dev Creates a new Captain with the given name.
232   function CreateCaptainToken(address _owner,uint256 _price, uint32 _captainId, uint32 _color,uint32 _atk,uint32 _defense,uint32 _atk_min,uint32 _atk_max) public onlyAccess {
233     _createCaptainToken(_owner,_price,_captainId,_color,_atk,_defense,_atk_min,_atk_max);
234   }
235 
236   function checkCaptain(address _owner,uint32 _captainId) external view returns (bool) {
237     uint256 len = ownerToCaptainsArray[_owner].length;
238     bool bexist = false;
239     for (uint256 i=0;i<len;i++) {
240       if (ownerToCaptainsArray[_owner][i] == _captainId) {
241         bexist = true;
242       }
243       }
244     return bexist;
245   }
246 
247   /// For creating CaptainToken
248   function _createCaptainToken(address _owner, uint256 _price, uint32 _captainId, uint32 _color, uint32 _atk, uint32 _defense,uint32 _atk_min, uint32 _atk_max) 
249   internal {
250     uint256 newTokenId = captains.length;
251     Captain memory _captain = Captain({
252       captainId: _captainId,
253       color: _color,
254       atk: _atk,
255       defense: _defense,
256       atk_min: _atk_min,
257       atk_max: _atk_max
258     });
259     captains.push(_captain);
260     //event
261     CreateCaptain(newTokenId, _captainId, _owner, _price);
262     captainTokenIdToPrice[newTokenId] = _price;
263     IndexToCaptain[newTokenId] = _captainId;
264     ownerToCaptainsArray[_owner].push(_captainId);
265     tokenCountOfCaptain[_captainId] = SafeMath.add(tokenCountOfCaptain[_captainId],1);
266     // This will assign ownership, and also emit the Transfer event as
267     // per ERC721 draft
268     _transfer(address(0), _owner, newTokenId);
269   } 
270   /// @dev set the token price
271   function setTokenPrice(uint256 _tokenId, uint256 _price) external onlyAccess {
272     captainTokenIdToPrice[_tokenId] = _price;
273   }
274 
275   /// @dev let owner set the token price
276   function setTokenPriceByOwner(uint256 _tokenId, uint256 _price) external {
277     require(captainTokenIdToOwner[_tokenId] == msg.sender);
278     captainTokenIdToPrice[_tokenId] = _price;
279   }
280 
281   /// @dev set sellable
282   function setSelled(uint256 _tokenId, bool fsell) external onlyAccess {
283     tokenToSell[_tokenId] = fsell;
284   }
285 
286   function getSelled(uint256 _tokenId) external view returns (bool) {
287     return tokenToSell[_tokenId];
288   }
289 
290   /// @dev Do the real transfer with out any condition checking
291   /// @param _from The old owner of this Captain(If created: 0x0)
292   /// @param _to The new owner of this Captain 
293   /// @param _tokenId The tokenId of the Captain
294   function _transfer(address _from, address _to, uint256 _tokenId) internal {
295     if (_from != address(0)) {
296       uint256 indexFrom = captainIdToOwnerIndex[_tokenId];  // tokenId -> captainId
297       uint256[] storage cpArray = ownerToCaptainArray[_from];
298       require(cpArray[indexFrom] == _tokenId);
299 
300       // If the Captain is not the element of array, change it to with the last
301       if (indexFrom != cpArray.length - 1) {
302         uint256 lastTokenId = cpArray[cpArray.length - 1];
303         cpArray[indexFrom] = lastTokenId; 
304         captainIdToOwnerIndex[lastTokenId] = indexFrom;
305       }
306       cpArray.length -= 1; 
307     
308       if (captainTokenIdToApprovals[_tokenId] != address(0)) {
309         delete captainTokenIdToApprovals[_tokenId];
310       }      
311     }
312 
313     // Give the Captain to '_to'
314     captainTokenIdToOwner[_tokenId] = _to;
315     ownerToCaptainArray[_to].push(_tokenId);
316     captainIdToOwnerIndex[_tokenId] = ownerToCaptainArray[_to].length - 1;
317         
318     Transfer(_from != address(0) ? _from : this, _to, _tokenId);
319   }
320 
321 
322   /// @notice Returns all the relevant information about a specific tokenId.
323   /// @param _tokenId The tokenId of the captain
324   function getCaptainInfo(uint256 _tokenId) external view returns (
325     uint32 captainId,  
326     uint32 color, 
327     uint32 atk,
328     uint32 atk_min,
329     uint32 atk_max,
330     uint32 defense,
331     uint256 price,
332     address owner,
333     bool selled
334   ) {
335     Captain storage captain = captains[_tokenId];
336     captainId = captain.captainId;
337     color = captain.color;
338     atk = captain.atk;
339     atk_min = captain.atk_min;
340     atk_max = captain.atk_max;
341     defense = captain.defense;
342     price = captainTokenIdToPrice[_tokenId];
343     owner = captainTokenIdToOwner[_tokenId];
344     selled = tokenToSell[_tokenId];
345   }
346 
347   /// ERC721 
348 
349   function balanceOf(address _owner) external view returns (uint256) {
350     require(_owner != address(0));
351     return ownerToCaptainArray[_owner].length;
352   }
353 
354   function ownerOf(uint256 _tokenId) external view returns (address) {
355     return captainTokenIdToOwner[_tokenId];
356   }
357   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable {
358     _safeTransferFrom(_from, _to, _tokenId, data);
359   }
360   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
361     _safeTransferFrom(_from, _to, _tokenId, "");
362   }
363 
364   /// @dev Actually perform the safeTransferFrom
365   function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
366     internal
367     isValidToken(_tokenId) 
368     canTransfer(_tokenId)
369     {
370     address owner = captainTokenIdToOwner[_tokenId];
371     require(owner != address(0) && owner == _from);
372     require(_to != address(0));
373         
374     _transfer(_from, _to, _tokenId);
375 
376     // Do the callback after everything is done to avoid reentrancy attack
377     /*uint256 codeSize;
378     assembly { codeSize := extcodesize(_to) }
379     if (codeSize == 0) {
380       return;
381     }*/
382     bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
383     // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
384     require(retval == 0xf0b9e5ba);
385   }
386     
387   /// @dev Transfer ownership of an Captain, '_to' must be a vaild address, or the WAR will lost
388   /// @param _from The current owner of the Captain
389   /// @param _to The new owner
390   /// @param _tokenId The Captain to transfer
391   function transferFrom(address _from, address _to, uint256 _tokenId)
392         external
393         whenNotPaused
394         isValidToken(_tokenId)
395         canTransfer(_tokenId)
396         payable
397     {
398     address owner = captainTokenIdToOwner[_tokenId];
399     require(owner != address(0));
400     require(owner == _from);
401     require(_to != address(0));
402         
403     _transfer(_from, _to, _tokenId);
404   }
405 
406   /// @dev Safe transfer by trust contracts
407   function safeTransferByContract(address _from,address _to, uint256 _tokenId) 
408   external
409   whenNotPaused
410   {
411     require(actionContracts[msg.sender]);
412 
413     require(_tokenId >= 1 && _tokenId <= captains.length);
414     address owner = captainTokenIdToOwner[_tokenId];
415     require(owner != address(0));
416     require(_to != address(0));
417     require(owner != _to);
418     require(_from == owner);
419 
420     _transfer(owner, _to, _tokenId);
421   }
422 
423   /// @dev Set or reaffirm the approved address for an captain
424   /// @param _approved The new approved captain controller
425   /// @param _tokenId The captain to approve
426   function approve(address _approved, uint256 _tokenId)
427     external
428     whenNotPaused 
429     payable
430   {
431     address owner = captainTokenIdToOwner[_tokenId];
432     require(owner != address(0));
433     require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
434 
435     captainTokenIdToApprovals[_tokenId] = _approved;
436     Approval(owner, _approved, _tokenId);
437   }
438 
439   /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
440   /// @param _operator Address to add to the set of authorized operators.
441   /// @param _approved True if the operators is approved, false to revoke approval
442   function setApprovalForAll(address _operator, bool _approved) 
443     external 
444     whenNotPaused
445   {
446     operatorToApprovals[msg.sender][_operator] = _approved;
447     ApprovalForAll(msg.sender, _operator, _approved);
448   }
449 
450   /// @dev Get the approved address for a single Captain
451   /// @param _tokenId The WAR to find the approved address for
452   /// @return The approved address for this WAR, or the zero address if there is none
453   function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
454     return captainTokenIdToApprovals[_tokenId];
455   }
456   
457   /// @dev Query if an address is an authorized operator for another address
458   /// @param _owner The address that owns the WARs
459   /// @param _operator The address that acts on behalf of the owner
460   /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
461   function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
462     return operatorToApprovals[_owner][_operator];
463   }
464   /// @notice A descriptive name for a collection of NFTs in this contract
465   function name() public pure returns(string) {
466     return "Pirate Conquest Token";
467   }
468   /// @notice An abbreviated name for NFTs in this contract
469   function symbol() public pure returns(string) {
470     return "PCT";
471   }
472   /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
473   /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
474   ///  3986. The URI may point to a JSON file that conforms to the "ERC721
475   ///  Metadata JSON Schema".
476   //function tokenURI(uint256 _tokenId) external view returns (string);
477 
478   /// @notice Count NFTs tracked by this contract
479   /// @return A count of valid NFTs tracked by this contract, where each one of
480   ///  them has an assigned and queryable owner not equal to the zero address
481   function totalSupply() external view returns (uint256) {
482     return captains.length - destroyCaptainCount -1;
483   }
484   /// @notice Enumerate valid NFTs
485   /// @dev Throws if `_index` >= `totalSupply()`.
486   /// @param _index A counter less than `totalSupply()`
487   /// @return The token identifier for the `_index`th NFT,
488   ///  (sort order not specified)
489   function tokenByIndex(uint256 _index) external view returns (uint256) {
490     require(_index<(captains.length - destroyCaptainCount));
491     //return captainIdToOwnerIndex[_index];
492     return _index;
493   }
494   /// @notice Enumerate NFTs assigned to an owner
495   /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
496   ///  `_owner` is the zero address, representing invalid NFTs.
497   /// @param _owner An address where we are interested in NFTs owned by them
498   /// @param _index A counter less than `balanceOf(_owner)`
499   /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
500   ///   (sort order not specified)
501   function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
502     require(_index < ownerToCaptainArray[_owner].length);
503     if (_owner != address(0)) {
504       uint256 tokenId = ownerToCaptainArray[_owner][_index];
505       return tokenId;
506     }
507   }
508 
509   /// @param _owner The owner whose celebrity tokens we are interested in.
510   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
511   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
512   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
513   ///  not contract-to-contract calls.
514   function tokensOfOwner(address _owner) external view returns (uint256[],uint32[]) {
515     uint256 len = ownerToCaptainArray[_owner].length;
516     uint256[] memory tokens = new uint256[](len);
517     uint32[] memory captainss = new uint32[](len);
518     uint256 icount;
519     if (_owner != address(0)) {
520       for (uint256 i=0;i<len;i++) {
521         tokens[i] = ownerToCaptainArray[_owner][icount];
522         captainss[i] = IndexToCaptain[ownerToCaptainArray[_owner][icount]];
523         icount++;
524       }
525     }
526     return (tokens,captainss);
527   }
528 
529   /// @param _captainId The captain whose celebrity tokens we are interested in.
530   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
531   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
532   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
533   ///  not contract-to-contract calls.
534   function tokensOfCaptain(uint32 _captainId) public view returns(uint256[] captainTokens) {
535     uint256 tokenCount = tokenCountOfCaptain[_captainId];
536     if (tokenCount == 0) {
537         // Return an empty array
538       return new uint256[](0);
539     } else {
540       uint256[] memory result = new uint256[](tokenCount);
541       uint256 totalcaptains = captains.length - destroyCaptainCount - 1;
542       uint256 resultIndex = 0;
543 
544       uint256 tokenId;
545       for (tokenId = 0; tokenId <= totalcaptains; tokenId++) {
546         if (IndexToCaptain[tokenId] == _captainId) {
547           result[resultIndex] = tokenId;
548           resultIndex++;
549         }
550       }
551       return result;
552     }
553   } 
554 
555   function tokensOfSell() external view returns (uint256[],bool[],address[],uint32[]) {
556     uint256 len = captains.length - destroyCaptainCount -1;
557     uint256[] memory tokens = new uint256[](len);
558     bool[] memory captainss = new bool[](len);
559     address[] memory owner = new address[](len);
560     uint32[] memory captainId = new uint32[](len);
561     uint256 icount;
562     for (uint256 i=0;i<len;i++) {
563       icount++;
564       tokens[i] = icount;
565       owner[i] = captainTokenIdToOwner[icount];
566       captainId[i] = IndexToCaptain[icount];
567       if (tokenToSell[icount] == true) {
568         captainss[i] = true;
569       }else{
570         captainss[i] = false;
571       }
572     }
573     
574     return (tokens,captainss,owner,captainId);
575   }
576 }
577 
578 library SafeMath {
579 
580   /**
581   * @dev Multiplies two numbers, throws on overflow.
582   */
583   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
584     if (a == 0) {
585       return 0;
586     }
587     uint256 c = a * b;
588     assert(c / a == b);
589     return c;
590   }
591 
592   function mul32(uint32 a, uint32 b) internal pure returns (uint32) {
593     if (a == 0) {
594       return 0;
595     }
596     uint32 c = a * b;
597     assert(c / a == b);
598     return c;
599   }
600 
601   /**
602   * @dev Integer division of two numbers, truncating the quotient.
603   */
604   function div(uint256 a, uint256 b) internal pure returns (uint256) {
605     // assert(b > 0); // Solidity automatically throws when dividing by 0
606     uint256 c = a / b;
607     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
608     return c;
609   }
610 
611   function div32(uint32 a, uint32 b) internal pure returns (uint32) {
612     // assert(b > 0); // Solidity automatically throws when dividing by 0
613     uint32 c = a / b;
614     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
615     return c;
616   }
617 
618   /**
619   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
620   */
621   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
622     assert(b <= a);
623     return a - b;
624   }
625 
626   function sub32(uint32 a, uint32 b) internal pure returns (uint32) {
627     assert(b <= a);
628     return a - b;
629   }
630 
631   /**
632   * @dev Adds two numbers, throws on overflow.
633   */
634   function add(uint256 a, uint256 b) internal pure returns (uint256) {
635     uint256 c = a + b;
636     assert(c >= a);
637     return c;
638   }
639 
640   function add32(uint32 a, uint32 b) internal pure returns (uint32) {
641     uint32 c = a + b;
642     assert(c >= a);
643     return c;
644   }
645 }