1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/AddressUtils.sol
4 
5 /**
6  * Utility library of inline functions on addresses
7  */
8 library AddressUtils {
9 
10   /**
11    * Returns whether the target address is a contract
12    * @dev This function will return false if invoked during the constructor of a contract,
13    * as the code is not actually created until after the constructor finishes.
14    * @param _addr address to check
15    * @return whether the target address is a contract
16    */
17   function isContract(address _addr) internal view returns (bool) {
18     uint256 size;
19     // XXX Currently there is no better way to check if there is a contract in an address
20     // than to check the size of the code at that address.
21     // See https://ethereum.stackexchange.com/a/14016/36603
22     // for more details about how this works.
23     // TODO Check this again before the Serenity release, because all addresses will be
24     // contracts then.
25     // solium-disable-next-line security/no-inline-assembly
26     assembly { size := extcodesize(_addr) }
27     return size > 0;
28   }
29 
30 }
31 
32 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
44     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
45     // benefit is lost if 'b' is also tested.
46     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47     if (_a == 0) {
48       return 0;
49     }
50 
51     c = _a * _b;
52     assert(c / _a == _b);
53     return c;
54   }
55 
56   /**
57   * @dev Integer division of two numbers, truncating the quotient.
58   */
59   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
60     // assert(_b > 0); // Solidity automatically throws when dividing by 0
61     // uint256 c = _a / _b;
62     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
63     return _a / _b;
64   }
65 
66   /**
67   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68   */
69   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
70     assert(_b <= _a);
71     return _a - _b;
72   }
73 
74   /**
75   * @dev Adds two numbers, throws on overflow.
76   */
77   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
78     c = _a + _b;
79     assert(c >= _a);
80     return c;
81   }
82 }
83 
84 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
85 
86 /**
87  * @title Ownable
88  * @dev The Ownable contract has an owner address, and provides basic authorization control
89  * functions, this simplifies the implementation of "user permissions".
90  */
91 contract Ownable {
92   address public owner;
93 
94 
95   event OwnershipRenounced(address indexed previousOwner);
96   event OwnershipTransferred(
97     address indexed previousOwner,
98     address indexed newOwner
99   );
100 
101 
102   /**
103    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
104    * account.
105    */
106   constructor() public {
107     owner = msg.sender;
108   }
109 
110   /**
111    * @dev Throws if called by any account other than the owner.
112    */
113   modifier onlyOwner() {
114     require(msg.sender == owner);
115     _;
116   }
117 
118   /**
119    * @dev Allows the current owner to relinquish control of the contract.
120    * @notice Renouncing to ownership will leave the contract without an owner.
121    * It will not be possible to call the functions with the `onlyOwner`
122    * modifier anymore.
123    */
124   function renounceOwnership() public onlyOwner {
125     emit OwnershipRenounced(owner);
126     owner = address(0);
127   }
128 
129   /**
130    * @dev Allows the current owner to transfer control of the contract to a newOwner.
131    * @param _newOwner The address to transfer ownership to.
132    */
133   function transferOwnership(address _newOwner) public onlyOwner {
134     _transferOwnership(_newOwner);
135   }
136 
137   /**
138    * @dev Transfers control of the contract to a newOwner.
139    * @param _newOwner The address to transfer ownership to.
140    */
141   function _transferOwnership(address _newOwner) internal {
142     require(_newOwner != address(0));
143     emit OwnershipTransferred(owner, _newOwner);
144     owner = _newOwner;
145   }
146 }
147 
148 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
149 
150 /**
151  * @title ERC165
152  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
153  */
154 interface ERC165 {
155 
156   /**
157    * @notice Query if a contract implements an interface
158    * @param _interfaceId The interface identifier, as specified in ERC-165
159    * @dev Interface identification is specified in ERC-165. This function
160    * uses less than 30,000 gas.
161    */
162   function supportsInterface(bytes4 _interfaceId)
163     external
164     view
165     returns (bool);
166 }
167 
168 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
169 
170 /**
171  * @title ERC721 Non-Fungible Token Standard basic interface
172  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
173  */
174 contract ERC721Basic is ERC165 {
175 
176   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
177   /*
178    * 0x80ac58cd ===
179    *   bytes4(keccak256('balanceOf(address)')) ^
180    *   bytes4(keccak256('ownerOf(uint256)')) ^
181    *   bytes4(keccak256('approve(address,uint256)')) ^
182    *   bytes4(keccak256('getApproved(uint256)')) ^
183    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
184    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
185    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
186    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
187    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
188    */
189 
190   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
191   /*
192    * 0x4f558e79 ===
193    *   bytes4(keccak256('exists(uint256)'))
194    */
195 
196   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
197   /**
198    * 0x780e9d63 ===
199    *   bytes4(keccak256('totalSupply()')) ^
200    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
201    *   bytes4(keccak256('tokenByIndex(uint256)'))
202    */
203 
204   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
205   /**
206    * 0x5b5e139f ===
207    *   bytes4(keccak256('name()')) ^
208    *   bytes4(keccak256('symbol()')) ^
209    *   bytes4(keccak256('tokenURI(uint256)'))
210    */
211 
212   event Transfer(
213     address indexed _from,
214     address indexed _to,
215     uint256 indexed _tokenId
216   );
217   event Approval(
218     address indexed _owner,
219     address indexed _approved,
220     uint256 indexed _tokenId
221   );
222   event ApprovalForAll(
223     address indexed _owner,
224     address indexed _operator,
225     bool _approved
226   );
227 
228   function balanceOf(address _owner) public view returns (uint256 _balance);
229   function ownerOf(uint256 _tokenId) public view returns (address _owner);
230   function exists(uint256 _tokenId) public view returns (bool _exists);
231 
232   function approve(address _to, uint256 _tokenId) public;
233   function getApproved(uint256 _tokenId)
234     public view returns (address _operator);
235 
236   function setApprovalForAll(address _operator, bool _approved) public;
237   function isApprovedForAll(address _owner, address _operator)
238     public view returns (bool);
239 
240   function transferFrom(address _from, address _to, uint256 _tokenId) public;
241   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
242     public;
243 
244   function safeTransferFrom(
245     address _from,
246     address _to,
247     uint256 _tokenId,
248     bytes _data
249   )
250     public;
251 }
252 
253 // File: contracts/IMarketplace.sol
254 
255 contract IMarketplace {
256     function createAuction(
257         uint256 _tokenId,
258         uint128 startPrice,
259         uint128 endPrice,
260         uint128 duration
261     )
262         external;
263 }
264 
265 // File: contracts/AnimalMarketplace.sol
266 
267 contract AnimalMarketplace is Ownable, IMarketplace {
268     using AddressUtils for address;
269     using SafeMath for uint256;
270     uint8 internal percentFee = 5;
271 
272     ERC721Basic private erc721Contract;
273 
274     struct Auction {
275         address tokenOwner;
276         uint256 startTime;
277         uint128 startPrice;
278         uint128 endPrice;
279         uint128 duration;
280     }
281 
282     struct AuctionEntry {
283         uint256 keyIndex;
284         Auction value;
285     }
286 
287     struct TokenIdAuctionMap {
288         mapping(uint256 => AuctionEntry) data;
289         uint256[] keys;
290     }
291 
292     TokenIdAuctionMap private auctions;
293 
294     event AuctionBoughtEvent(
295         uint256 tokenId,
296         address previousOwner,
297         address newOwner,
298         uint256 pricePaid
299     );
300 
301     event AuctionCreatedEvent(
302         uint256 tokenId,
303         uint128 startPrice,
304         uint128 endPrice,
305         uint128 duration
306     );
307 
308     event AuctionCanceledEvent(uint256 tokenId);
309 
310     modifier isNotFromContract() {
311         require(!msg.sender.isContract());
312         _;
313     }
314 
315     constructor(ERC721Basic _erc721Contract) public {
316         erc721Contract = _erc721Contract;
317     }
318 
319     // "approve" in game contract will revert if sender is not token owner
320     function createAuction(
321         uint256 _tokenId,
322         uint128 _startPrice,
323         uint128 _endPrice,
324         uint128 _duration
325     )
326         external
327     {
328         // this can be only called from game contract
329         require(msg.sender == address(erc721Contract));
330 
331         AuctionEntry storage entry = auctions.data[_tokenId];
332         require(entry.keyIndex == 0);
333 
334         address tokenOwner = erc721Contract.ownerOf(_tokenId);
335         erc721Contract.transferFrom(tokenOwner, address(this), _tokenId);
336 
337         entry.value = Auction({
338             tokenOwner: tokenOwner,
339             startTime: block.timestamp,
340             startPrice: _startPrice,
341             endPrice: _endPrice,
342             duration: _duration
343         });
344 
345         entry.keyIndex = ++auctions.keys.length;
346         auctions.keys[entry.keyIndex - 1] = _tokenId;
347 
348         emit AuctionCreatedEvent(_tokenId, _startPrice, _endPrice, _duration);
349     }
350 
351     function cancelAuction(uint256 _tokenId) external {
352         AuctionEntry storage entry = auctions.data[_tokenId];
353         Auction storage auction = entry.value;
354         address sender = msg.sender;
355         require(sender == auction.tokenOwner);
356         erc721Contract.transferFrom(address(this), sender, _tokenId);
357         deleteAuction(_tokenId, entry);
358         emit AuctionCanceledEvent(_tokenId);
359     }
360 
361     function buyAuction(uint256 _tokenId)
362         external
363         payable
364         isNotFromContract
365     {
366         AuctionEntry storage entry = auctions.data[_tokenId];
367         require(entry.keyIndex > 0);
368         Auction storage auction = entry.value;
369         address sender = msg.sender;
370         address tokenOwner = auction.tokenOwner;
371         uint256 auctionPrice = calculateCurrentPrice(auction);
372         uint256 pricePaid = msg.value;
373 
374         require(pricePaid >= auctionPrice);
375         deleteAuction(_tokenId, entry);
376 
377         refundSender(sender, pricePaid, auctionPrice);
378         payTokenOwner(tokenOwner, auctionPrice);
379         erc721Contract.transferFrom(address(this), sender, _tokenId);
380         emit AuctionBoughtEvent(_tokenId, tokenOwner, sender, auctionPrice);
381     }
382 
383     function getAuctionByTokenId(uint256 _tokenId)
384         external
385         view
386         returns (
387             uint256 tokenId,
388             address tokenOwner,
389             uint128 startPrice,
390             uint128 endPrice,
391             uint256 startTime,
392             uint128 duration,
393             uint256 currentPrice,
394             bool exists
395         )
396     {
397         AuctionEntry storage entry = auctions.data[_tokenId];
398         Auction storage auction = entry.value;
399         uint256 calculatedCurrentPrice = calculateCurrentPrice(auction);
400         return (
401             entry.keyIndex > 0 ? _tokenId : 0,
402             auction.tokenOwner,
403             auction.startPrice,
404             auction.endPrice,
405             auction.startTime,
406             auction.duration,
407             calculatedCurrentPrice,
408             entry.keyIndex > 0
409         );
410     }
411 
412     function getAuctionByIndex(uint256 _auctionIndex)
413         external
414         view
415         returns (
416             uint256 tokenId,
417             address tokenOwner,
418             uint128 startPrice,
419             uint128 endPrice,
420             uint256 startTime,
421             uint128 duration,
422             uint256 currentPrice,
423             bool exists
424         )
425     {
426         // for consistency with getAuctionByTokenId when returning invalid auction - otherwise it would throw error
427         if (_auctionIndex >= auctions.keys.length) {
428             return (0, address(0), 0, 0, 0, 0, 0, false);
429         }
430 
431         uint256 currentTokenId = auctions.keys[_auctionIndex];
432         Auction storage auction = auctions.data[currentTokenId].value;
433         uint256 calculatedCurrentPrice = calculateCurrentPrice(auction);
434         return (
435             currentTokenId,
436             auction.tokenOwner,
437             auction.startPrice,
438             auction.endPrice,
439             auction.startTime,
440             auction.duration,
441             calculatedCurrentPrice,
442             true
443         );
444     }
445 
446     function getAuctionsCount() external view returns (uint256 auctionsCount) {
447         return auctions.keys.length;
448     }
449 
450     function isOnAuction(uint256 _tokenId) public view returns (bool onAuction) {
451         return auctions.data[_tokenId].keyIndex > 0;
452     }
453 
454     function withdrawContract() public onlyOwner {
455         msg.sender.transfer(address(this).balance);
456     }
457 
458     function refundSender(address _sender, uint256 _pricePaid, uint256 _auctionPrice) private {
459         uint256 etherToRefund = _pricePaid.sub(_auctionPrice);
460         if (etherToRefund > 0) {
461             _sender.transfer(etherToRefund);
462         }
463     }
464 
465     function payTokenOwner(address _tokenOwner, uint256 _auctionPrice) private {
466         uint256 etherToPay = _auctionPrice.sub(_auctionPrice * percentFee / 100);
467         if (etherToPay > 0) {
468             _tokenOwner.transfer(etherToPay);
469         }
470     }
471 
472     function deleteAuction(uint256 _tokenId, AuctionEntry storage _entry) private {
473         uint256 keysLength = auctions.keys.length;
474         if (_entry.keyIndex <= keysLength) {
475             // Move an existing element into the vacated key slot.
476             auctions.data[auctions.keys[keysLength - 1]].keyIndex = _entry.keyIndex;
477             auctions.keys[_entry.keyIndex - 1] = auctions.keys[keysLength - 1];
478             auctions.keys.length = keysLength - 1;
479             delete auctions.data[_tokenId];
480         }
481     }
482 
483     function calculateCurrentPrice(Auction storage _auction) private view returns (uint256) {
484         uint256 secondsInProgress = block.timestamp - _auction.startTime;
485 
486         if (secondsInProgress >= _auction.duration) {
487             return _auction.endPrice;
488         }
489 
490         int256 totalPriceChange = int256(_auction.endPrice) - int256(_auction.startPrice);
491         int256 currentPriceChange =
492             totalPriceChange * int256(secondsInProgress) / int256(_auction.duration);
493 
494         int256 calculatedPrice = int256(_auction.startPrice) + int256(currentPriceChange);
495 
496         return uint256(calculatedPrice);
497     }
498 
499 }