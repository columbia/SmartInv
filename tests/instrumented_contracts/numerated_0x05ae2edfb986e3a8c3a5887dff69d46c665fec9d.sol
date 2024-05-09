1 //Copyright CryptoDiamond srl
2 //Luigi Di Benedetto | Brescia (Italy) | CEO CryptoDiamond srl
3 
4 //social:   fb          - https://www.facebook.com/LuigiDiBenedettoBS
5 //          linkedin    - https://www.linkedin.com/in/luigi-di-benedetto
6 
7 //          website     - https://www.cryptodiamond.it/
8 
9 //ERC-721 TOKEN - CRYPTOWATCHES PROJECT
10 pragma solidity ^0.4.24;
11 
12 
13 /**
14  * @title ERC165
15  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
16  */
17 interface ERC165 {
18 
19   /**
20    * @notice Query if a contract implements an interface
21    * @param _interfaceId The interface identifier, as specified in ERC-165
22    * @dev Interface identification is specified in ERC-165. This function
23    * uses less than 30,000 gas.
24    */
25   function supportsInterface(bytes4 _interfaceId)
26     external
27     view
28     returns (bool);
29 }
30 
31 
32 
33 
34 contract SupportsInterfaceWithLookup is ERC165 {
35   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
36 
37   mapping(bytes4 => bool) internal supportedInterfaces;
38 
39 
40   constructor()
41     public
42   {
43     _registerInterface(InterfaceId_ERC165);
44   }
45 
46   function supportsInterface(bytes4 _interfaceId)
47     external
48     view
49     returns (bool)
50   {
51     return supportedInterfaces[_interfaceId];
52   }
53 
54   function _registerInterface(bytes4 _interfaceId)
55     internal
56   {
57     require(_interfaceId != 0xffffffff);
58     supportedInterfaces[_interfaceId] = true;
59   }
60 }
61 
62 
63 
64 /**
65  * Utility library of inline functions on addresses
66  */
67 library AddressUtils {
68 
69   /**
70    * Returns whether the target address is a contract
71    * @dev This function will return false if invoked during the constructor of a contract,
72    * as the code is not actually created until after the constructor finishes.
73    * @param addr address to check
74    * @return whether the target address is a contract
75    */
76   function isContract(address addr) internal view returns (bool) {
77     uint256 size;
78     // XXX Currently there is no better way to check if there is a contract in an address
79     // than to check the size of the code at that address.
80     // See https://ethereum.stackexchange.com/a/14016/36603
81     // for more details about how this works.
82     // TODO Check this again before the Serenity release, because all addresses will be
83     // contracts then.
84     // solium-disable-next-line security/no-inline-assembly
85     assembly { size := extcodesize(addr) }
86     return size > 0;
87   }
88 
89 }
90 
91 
92 /**
93  * @title SafeMath
94  * @dev Math operations with safety checks that throw on error
95  */
96 library SafeMath {
97 
98   /**
99   * @dev Multiplies two numbers, throws on overflow.
100   */
101   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
102     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
103     // benefit is lost if 'b' is also tested.
104     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
105     if (a == 0) {
106       return 0;
107     }
108 
109     c = a * b;
110     assert(c / a == b);
111     return c;
112   }
113 
114   /**
115   * @dev Integer division of two numbers, truncating the quotient.
116   */
117   function div(uint256 a, uint256 b) internal pure returns (uint256) {
118     // assert(b > 0); // Solidity automatically throws when dividing by 0
119     // uint256 c = a / b;
120     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121     return a / b;
122   }
123 
124   /**
125   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
126   */
127   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128     assert(b <= a);
129     return a - b;
130   }
131 
132   /**
133   * @dev Adds two numbers, throws on overflow.
134   */
135   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
136     c = a + b;
137     assert(c >= a);
138     return c;
139   }
140 }
141 
142 
143 /**
144  * @title ERC721 token receiver interface
145  * @dev Interface for any contract that wants to support safeTransfers
146  * from ERC721 asset contracts.
147  */
148 contract ERC721Receiver {
149   /**
150    * @dev Magic value to be returned upon successful reception of an NFT
151    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
152    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
153    */
154   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
155 
156   /**
157    * @notice Handle the receipt of an NFT
158    * @dev The ERC721 smart contract calls this function on the recipient
159    * after a `safetransfer`. This function MAY throw to revert and reject the
160    * transfer. Return of other than the magic value MUST result in the 
161    * transaction being reverted.
162    * Note: the contract address is always the message sender.
163    * @param _operator The address which called `safeTransferFrom` function
164    * @param _from The address which previously owned the token
165    * @param _tokenId The NFT identifier which is being transfered
166    * @param _data Additional data with no specified format
167    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
168    */
169   function onERC721Received(
170     address _operator,
171     address _from,
172     uint256 _tokenId,
173     bytes _data
174   )
175     public
176     returns(bytes4);
177 }
178 
179 
180 contract ERC721Basic is ERC165 {
181   event Transfer(
182     address indexed _from,
183     address indexed _to,
184     uint256 indexed _tokenId
185   );
186   event Approval(
187     address indexed _owner,
188     address indexed _approved,
189     uint256 indexed _tokenId
190   );
191   event ApprovalForAll(
192     address indexed _owner,
193     address indexed _operator,
194     bool _approved
195   );
196 
197   function balanceOf(address _owner) public view returns (uint256 _balance);
198   function ownerOf(uint256 _tokenId) public view returns (address _owner);
199   function exists(uint256 _tokenId) public view returns (bool _exists);
200 
201   function approve(address _to, uint256 _tokenId) public;
202   function getApproved(uint256 _tokenId)
203     public view returns (address _operator);
204 
205   function setApprovalForAll(address _operator, bool _approved) public;
206   function isApprovedForAll(address _owner, address _operator)
207     public view returns (bool);
208 
209   function transferFrom(address _from, address _to, uint256 _tokenId) public;
210   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
211     public;
212 
213   function safeTransferFrom(
214     address _from,
215     address _to,
216     uint256 _tokenId,
217     bytes _data
218   )
219     public;
220 }
221 
222 
223 contract ERC721Enumerable is ERC721Basic {
224   function totalSupply() public view returns (uint256);
225   function tokenOfOwnerByIndex(
226     address _owner,
227     uint256 _index
228   )
229     public
230     view
231     returns (uint256 _tokenId);
232 
233   function tokenByIndex(uint256 _index) public view returns (uint256);
234 }
235 
236 
237 contract ERC721Metadata is ERC721Basic {
238   function name() external view returns (string _name);
239   function symbol() external view returns (string _symbol);
240   function tokenURI(uint256 _tokenId) public view returns (string);
241 }
242 
243 
244 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
245 }
246 
247 contract cryptodiamondwatch{
248     function transferOwnershipTo(address _newOwner, string _comment) external;
249     function getAmount() external constant returns (uint);
250 }
251 
252 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
253     
254     
255   address private cryptodiamondAddress;
256   
257   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
258   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
259 
260 
261   using SafeMath for uint256;
262   using AddressUtils for address;
263 
264   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
265   
266   
267   //Associo ad ogni id l'indirizzo del contratto corrispondente
268   mapping (uint256 => address) internal cryptodiamondID;
269 
270   mapping (uint256 => address) internal tokenOwner;
271 
272   mapping (uint256 => address) internal tokenApprovals;
273 
274   mapping (address => uint256) internal ownedTokensCount;
275 
276   mapping (address => mapping (address => bool)) internal operatorApprovals;
277 
278 
279   modifier onlyOwnerOf(uint256 _tokenId) {
280     require(ownerOf(_tokenId) == msg.sender);
281     _;
282   }
283 
284   modifier canTransfer(uint256 _tokenId) {
285     require(isApprovedOrOwner(msg.sender, _tokenId));
286     _;
287   }
288 
289   constructor()
290     public
291   {
292     // register the supported interfaces to conform to ERC721 via ERC165
293     _registerInterface(InterfaceId_ERC721);
294     _registerInterface(InterfaceId_ERC721Exists);
295   }
296   
297   modifier onlyCryptodiamond() { 
298       require (msg.sender == cryptodiamondAddress); 
299       _; 
300     }
301 
302 
303   function balanceOf(address _owner) public view returns (uint256) {
304     require(_owner != address(0));
305     return ownedTokensCount[_owner];
306   }
307 
308 
309   function ownerOf(uint256 _tokenId) public view returns (address) {
310     address owner = tokenOwner[_tokenId];
311     require(owner != address(0));
312     return owner;
313   }
314 
315 
316   function exists(uint256 _tokenId) public view returns (bool) {
317     address owner = tokenOwner[_tokenId];
318     return owner != address(0);
319   }
320 
321   function approve(address _to, uint256 _tokenId) public {
322     address owner = ownerOf(_tokenId);
323     require(_to != owner);
324     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
325 
326     tokenApprovals[_tokenId] = _to;
327     emit Approval(owner, _to, _tokenId);
328   }
329 
330 
331   function getApproved(uint256 _tokenId) public view returns (address) {
332     return tokenApprovals[_tokenId];
333   }
334 
335 
336   function setApprovalForAll(address _to, bool _approved) public {
337     require(_to != msg.sender);
338     operatorApprovals[msg.sender][_to] = _approved;
339     emit ApprovalForAll(msg.sender, _to, _approved);
340   }
341 
342   function isApprovedForAll(
343     address _owner,
344     address _operator
345   )
346     public
347     view
348     returns (bool)
349   {
350     return operatorApprovals[_owner][_operator];
351   }
352 
353   function transferFrom(
354     address _from,
355     address _to,
356     uint256 _tokenId
357   )
358     public
359     canTransfer(_tokenId)
360   {
361     require(_from != address(0));
362     require(_to != address(0));
363 
364     clearApproval(_from, _tokenId);
365     removeTokenFrom(_from, _tokenId);
366     addTokenTo(_to, _tokenId);
367     
368     cryptodiamondwatch cryptowatch = cryptodiamondwatch(cryptodiamondID[_tokenId]);
369     cryptowatch.transferOwnershipTo(_to,"Trasferimento proprietà dal token");
370     
371     emit Transfer(_from, _to, _tokenId);
372   }
373   
374   function getCryptoWatchETHAmountById(uint256 _tokenId) public constant returns(uint256){
375     cryptodiamondwatch cryptowatch = cryptodiamondwatch(cryptodiamondID[_tokenId]);
376     return cryptowatch.getAmount();
377   }
378 
379   function safeTransferFrom(address _from,address _to,uint256 _tokenId) public canTransfer(_tokenId)
380   {
381     // solium-disable-next-line arg-overflow
382     safeTransferFrom(_from, _to, _tokenId, "");
383   }
384 
385   function safeTransferFrom(
386     address _from,
387     address _to,
388     uint256 _tokenId,
389     bytes _data
390   )
391     public
392     canTransfer(_tokenId)
393   {
394     transferFrom(_from, _to, _tokenId);
395     // solium-disable-next-line arg-overflow
396     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
397   }
398 
399   function isApprovedOrOwner(
400     address _spender,
401     uint256 _tokenId
402   )
403     internal
404     view
405     returns (bool)
406   {
407     address owner = ownerOf(_tokenId);
408     // Disable solium check because of
409     // https://github.com/duaraghav8/Solium/issues/175
410     // solium-disable-next-line operator-whitespace
411     return (
412       _spender == owner ||
413       getApproved(_tokenId) == _spender ||
414       isApprovedForAll(owner, _spender)
415     );
416   }
417 
418 
419   function _mint(address _to, uint256 _tokenId, address _cryptodiamondWatchAddress) public onlyCryptodiamond{
420     require(_to != address(0));
421     addTokenTo(_to, _tokenId);
422     cryptodiamondID[_tokenId]=_cryptodiamondWatchAddress;
423     emit Transfer(address(0), _to, _tokenId);
424   }
425   
426   function getCryptodiamondWatchAddressById(uint256 _tokenId) constant public returns(address){
427       return cryptodiamondID[_tokenId];
428   }
429 
430   function _burn(address _owner, uint256 _tokenId) public onlyCryptodiamond {
431     clearApproval(_owner, _tokenId);
432     removeTokenFrom(_owner, _tokenId);
433     emit Transfer(_owner, address(0), _tokenId);
434   }
435 
436   function clearApproval(address _owner, uint256 _tokenId) internal {
437     require(ownerOf(_tokenId) == _owner);
438     if (tokenApprovals[_tokenId] != address(0)) {
439       tokenApprovals[_tokenId] = address(0);
440     }
441   }
442 
443   
444   function addTokenTo(address _to, uint256 _tokenId) internal {
445     require(tokenOwner[_tokenId] == address(0));
446     tokenOwner[_tokenId] = _to;
447     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
448   }
449 
450 
451   function removeTokenFrom(address _from, uint256 _tokenId) internal {
452     require(ownerOf(_tokenId) == _from);
453     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
454     tokenOwner[_tokenId] = address(0);
455   }
456 
457   function checkAndCallSafeTransfer(
458     address _from,
459     address _to,
460     uint256 _tokenId,
461     bytes _data
462   )
463     internal
464     returns (bool)
465   {
466     if (!_to.isContract()) {
467       return true;
468     }
469     bytes4 retval = ERC721Receiver(_to).onERC721Received(
470       msg.sender, _from, _tokenId, _data);
471     return (retval == ERC721_RECEIVED);
472   }
473 }
474 
475 
476 contract CryptoWatchesToken is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
477 
478   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
479   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
480   
481   address private cryptodiamondAddress;
482   
483   event ChangeOwnership(address _oldAddress, address _newAddress);
484   
485   
486   // Token name
487   string internal name_;
488 
489   // Token symbol
490   string internal symbol_;
491 
492 
493   mapping(address => uint256[]) internal ownedTokens;
494   mapping(uint256 => uint256) internal ownedTokensIndex;
495   uint256[] internal allTokens;
496   mapping(uint256 => uint256) internal allTokensIndex;
497   mapping(uint256 => string) internal tokenURIs;
498 
499 
500   constructor(string _name, string _symbol) public {
501     name_ = _name;
502     symbol_ = _symbol;
503     
504     cryptodiamondAddress = msg.sender;
505 
506     // register the supported interfaces to conform to ERC721 via ERC165
507     _registerInterface(InterfaceId_ERC721Enumerable);
508     _registerInterface(InterfaceId_ERC721Metadata);
509   }
510   
511   modifier onlyCryptodiamond() { 
512       require (msg.sender == cryptodiamondAddress); 
513       _; 
514     }
515 
516   function name() external view returns (string) {
517     return name_;
518   }
519 
520   function symbol() external view returns (string) {
521     return symbol_;
522   }
523 
524   function tokenURI(uint256 _tokenId) public view returns (string) {
525     require(exists(_tokenId));
526     return tokenURIs[_tokenId];
527   }
528 
529   function tokenOfOwnerByIndex(
530     address _owner,
531     uint256 _index
532   )
533     public
534     view
535     returns (uint256)
536   {
537     require(_index < balanceOf(_owner));
538     return ownedTokens[_owner][_index];
539   }
540 
541 
542   function totalSupply() public view returns (uint256) {
543     return allTokens.length;
544   }
545 
546   function tokenByIndex(uint256 _index) public view returns (uint256) {
547     require(_index < totalSupply());
548     return allTokens[_index];
549   }
550 
551 
552   function _setTokenURI(uint256 _tokenId, string _uri) public onlyCryptodiamond{
553     require(exists(_tokenId));
554     tokenURIs[_tokenId] = _uri;
555   }
556 
557   function addTokenTo(address _to, uint256 _tokenId) internal {
558     super.addTokenTo(_to, _tokenId);
559     uint256 length = ownedTokens[_to].length;
560     ownedTokens[_to].push(_tokenId);
561     ownedTokensIndex[_tokenId] = length;
562   }
563 
564   function removeTokenFrom(address _from, uint256 _tokenId) internal {
565     super.removeTokenFrom(_from, _tokenId);
566 
567     uint256 tokenIndex = ownedTokensIndex[_tokenId];
568     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
569     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
570 
571     ownedTokens[_from][tokenIndex] = lastToken;
572     ownedTokens[_from][lastTokenIndex] = 0;
573     ownedTokens[_from].length--;
574     ownedTokensIndex[_tokenId] = 0;
575     ownedTokensIndex[lastToken] = tokenIndex;
576   }
577 
578   function _mint(address _to, uint256 _tokenId, address _cryptodiamondWatchAddress) public onlyCryptodiamond{
579     super._mint(_to, _tokenId, _cryptodiamondWatchAddress);
580 
581     allTokensIndex[_tokenId] = allTokens.length;
582     allTokens.push(_tokenId);
583   }
584 
585 
586   function _burn(address _owner, uint256 _tokenId) public onlyCryptodiamond{
587     super._burn(_owner, _tokenId);
588 
589     // Clear metadata (if any)
590     if (bytes(tokenURIs[_tokenId]).length != 0) {
591       delete tokenURIs[_tokenId];
592     }
593 
594     // Reorg all tokens array
595     uint256 tokenIndex = allTokensIndex[_tokenId];
596     uint256 lastTokenIndex = allTokens.length.sub(1);
597     uint256 lastToken = allTokens[lastTokenIndex];
598 
599     allTokens[tokenIndex] = lastToken;
600     allTokens[lastTokenIndex] = 0;
601 
602     allTokens.length--;
603     allTokensIndex[_tokenId] = 0;
604     allTokensIndex[lastToken] = tokenIndex;
605   }
606   
607   //cambio la proprietà di chi può gestire il token.
608   function CO(address _address) public onlyCryptodiamond returns(bool){
609       require(_address != address(0));
610       require(_address!= cryptodiamondAddress);
611       emit ChangeOwnership(cryptodiamondAddress,_address);
612       cryptodiamondAddress = _address;
613       return true;
614   }
615   function getCryptodiamondAddress() public constant returns(address){
616       return cryptodiamondAddress;
617   }
618 
619 }