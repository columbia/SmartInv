1 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
70 
71 pragma solidity ^0.5.0;
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79     address private _owner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85      * account.
86      */
87     constructor () internal {
88         _owner = msg.sender;
89         emit OwnershipTransferred(address(0), _owner);
90     }
91 
92     /**
93      * @return the address of the owner.
94      */
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(isOwner());
104         _;
105     }
106 
107     /**
108      * @return true if `msg.sender` is the owner of the contract.
109      */
110     function isOwner() public view returns (bool) {
111         return msg.sender == _owner;
112     }
113 
114     /**
115      * @dev Allows the current owner to relinquish control of the contract.
116      * @notice Renouncing to ownership will leave the contract without an owner.
117      * It will not be possible to call the functions with the `onlyOwner`
118      * modifier anymore.
119      */
120     function renounceOwnership() public onlyOwner {
121         emit OwnershipTransferred(_owner, address(0));
122         _owner = address(0);
123     }
124 
125     /**
126      * @dev Allows the current owner to transfer control of the contract to a newOwner.
127      * @param newOwner The address to transfer ownership to.
128      */
129     function transferOwnership(address newOwner) public onlyOwner {
130         _transferOwnership(newOwner);
131     }
132 
133     /**
134      * @dev Transfers control of the contract to a newOwner.
135      * @param newOwner The address to transfer ownership to.
136      */
137     function _transferOwnership(address newOwner) internal {
138         require(newOwner != address(0));
139         emit OwnershipTransferred(_owner, newOwner);
140         _owner = newOwner;
141     }
142 }
143 
144 // File: node_modules\openzeppelin-solidity\contracts\introspection\IERC165.sol
145 
146 pragma solidity ^0.5.0;
147 
148 /**
149  * @title IERC165
150  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
151  */
152 interface IERC165 {
153     /**
154      * @notice Query if a contract implements an interface
155      * @param interfaceId The interface identifier, as specified in ERC-165
156      * @dev Interface identification is specified in ERC-165. This function
157      * uses less than 30,000 gas.
158      */
159     function supportsInterface(bytes4 interfaceId) external view returns (bool);
160 }
161 
162 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721.sol
163 
164 pragma solidity ^0.5.0;
165 
166 
167 /**
168  * @title ERC721 Non-Fungible Token Standard basic interface
169  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
170  */
171 contract IERC721 is IERC165 {
172     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
173     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
174     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
175 
176     function balanceOf(address owner) public view returns (uint256 balance);
177     function ownerOf(uint256 tokenId) public view returns (address owner);
178 
179     function approve(address to, uint256 tokenId) public;
180     function getApproved(uint256 tokenId) public view returns (address operator);
181 
182     function setApprovalForAll(address operator, bool _approved) public;
183     function isApprovedForAll(address owner, address operator) public view returns (bool);
184 
185     function transferFrom(address from, address to, uint256 tokenId) public;
186     function safeTransferFrom(address from, address to, uint256 tokenId) public;
187 
188     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
189 }
190 
191 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721Enumerable.sol
192 
193 pragma solidity ^0.5.0;
194 
195 
196 /**
197  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
198  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
199  */
200 contract IERC721Enumerable is IERC721 {
201     function totalSupply() public view returns (uint256);
202     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
203 
204     function tokenByIndex(uint256 index) public view returns (uint256);
205 }
206 
207 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721Metadata.sol
208 
209 pragma solidity ^0.5.0;
210 
211 
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
214  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
215  */
216 contract IERC721Metadata is IERC721 {
217     function name() external view returns (string memory);
218     function symbol() external view returns (string memory);
219     function tokenURI(uint256 tokenId) external view returns (string memory);
220 }
221 
222 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721Full.sol
223 
224 pragma solidity ^0.5.0;
225 
226 
227 
228 
229 /**
230  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
231  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
232  */
233 contract IERC721Full is IERC721, IERC721Enumerable, IERC721Metadata {
234     // solhint-disable-previous-line no-empty-blocks
235 }
236 
237 // File: contracts\IMarketplace.sol
238 
239 pragma solidity 0.5.0;
240 
241 
242 contract IMarketplace {
243     function createAuction(
244         uint256 _tokenId,
245         uint128 startPrice,
246         uint128 endPrice,
247         uint128 duration
248     )
249         external;
250 }
251 
252 // File: contracts\AnimalMarketplace.sol
253 
254 pragma solidity 0.5.0;
255 
256 
257 
258 
259 
260 
261 contract AnimalMarketplace is Ownable, IMarketplace {
262     using SafeMath for uint256;
263     uint8 internal percentFee = 5;
264 
265     IERC721Full private erc721Contract;
266 
267     struct Auction {
268         address payable tokenOwner;
269         uint256 startTime;
270         uint128 startPrice;
271         uint128 endPrice;
272         uint128 duration;
273     }
274 
275     struct AuctionEntry {
276         uint256 keyIndex;
277         Auction value;
278     }
279 
280     struct TokenIdAuctionMap {
281         mapping(uint256 => AuctionEntry) data;
282         uint256[] keys;
283     }
284 
285     TokenIdAuctionMap private auctions;
286 
287     event AuctionBoughtEvent(
288         uint256 tokenId,
289         address previousOwner,
290         address newOwner,
291         uint256 pricePaid
292     );
293 
294     event AuctionCreatedEvent(
295         uint256 tokenId,
296         uint128 startPrice,
297         uint128 endPrice,
298         uint128 duration
299     );
300 
301     event AuctionCanceledEvent(uint256 tokenId);
302 
303     constructor(IERC721Full _erc721Contract) public {
304         erc721Contract = _erc721Contract;
305     }
306 
307     // "approve" in game contract will revert if sender is not token owner
308     function createAuction(
309         uint256 _tokenId,
310         uint128 _startPrice,
311         uint128 _endPrice,
312         uint128 _duration
313     )
314         external
315     {
316         // this can be only called from game contract
317         require(msg.sender == address(erc721Contract));
318 
319         AuctionEntry storage entry = auctions.data[_tokenId];
320         require(entry.keyIndex == 0);
321 
322         address payable tokenOwner = address(uint160(erc721Contract.ownerOf(_tokenId)));
323         erc721Contract.transferFrom(tokenOwner, address(this), _tokenId);
324 
325         entry.value = Auction({
326             tokenOwner: tokenOwner,
327             startTime: block.timestamp,
328             startPrice: _startPrice,
329             endPrice: _endPrice,
330             duration: _duration
331         });
332 
333         entry.keyIndex = ++auctions.keys.length;
334         auctions.keys[entry.keyIndex - 1] = _tokenId;
335 
336         emit AuctionCreatedEvent(_tokenId, _startPrice, _endPrice, _duration);
337     }
338 
339     function cancelAuction(uint256 _tokenId) external {
340         AuctionEntry storage entry = auctions.data[_tokenId];
341         Auction storage auction = entry.value;
342         address sender = msg.sender;
343         require(sender == auction.tokenOwner);
344         erc721Contract.transferFrom(address(this), sender, _tokenId);
345         deleteAuction(_tokenId, entry);
346         emit AuctionCanceledEvent(_tokenId);
347     }
348 
349     function buyAuction(uint256 _tokenId)
350         external
351         payable
352     {
353         AuctionEntry storage entry = auctions.data[_tokenId];
354         require(entry.keyIndex > 0);
355         Auction storage auction = entry.value;
356         address payable sender = msg.sender;
357         address payable tokenOwner = auction.tokenOwner;
358         uint256 auctionPrice = calculateCurrentPrice(auction);
359         uint256 pricePaid = msg.value;
360 
361         require(pricePaid >= auctionPrice);
362         deleteAuction(_tokenId, entry);
363 
364         refundSender(sender, pricePaid, auctionPrice);
365         payTokenOwner(tokenOwner, auctionPrice);
366         erc721Contract.transferFrom(address(this), sender, _tokenId);
367         emit AuctionBoughtEvent(_tokenId, tokenOwner, sender, auctionPrice);
368     }
369 
370     function getAuctionByTokenId(uint256 _tokenId)
371         external
372         view
373         returns (
374             uint256 tokenId,
375             address tokenOwner,
376             uint128 startPrice,
377             uint128 endPrice,
378             uint256 startTime,
379             uint128 duration,
380             uint256 currentPrice,
381             bool exists
382         )
383     {
384         AuctionEntry storage entry = auctions.data[_tokenId];
385         Auction storage auction = entry.value;
386         uint256 calculatedCurrentPrice = calculateCurrentPrice(auction);
387         return (
388             entry.keyIndex > 0 ? _tokenId : 0,
389             auction.tokenOwner,
390             auction.startPrice,
391             auction.endPrice,
392             auction.startTime,
393             auction.duration,
394             calculatedCurrentPrice,
395             entry.keyIndex > 0
396         );
397     }
398 
399     function getAuctionByIndex(uint256 _auctionIndex)
400         external
401         view
402         returns (
403             uint256 tokenId,
404             address tokenOwner,
405             uint128 startPrice,
406             uint128 endPrice,
407             uint256 startTime,
408             uint128 duration,
409             uint256 currentPrice,
410             bool exists
411         )
412     {
413         // for consistency with getAuctionByTokenId when returning invalid auction - otherwise it would throw error
414         if (_auctionIndex >= auctions.keys.length) {
415             return (0, address(0), 0, 0, 0, 0, 0, false);
416         }
417 
418         uint256 currentTokenId = auctions.keys[_auctionIndex];
419         Auction storage auction = auctions.data[currentTokenId].value;
420         uint256 calculatedCurrentPrice = calculateCurrentPrice(auction);
421         return (
422             currentTokenId,
423             auction.tokenOwner,
424             auction.startPrice,
425             auction.endPrice,
426             auction.startTime,
427             auction.duration,
428             calculatedCurrentPrice,
429             true
430         );
431     }
432 
433     function getAuctionsCount() external view returns (uint256 auctionsCount) {
434         return auctions.keys.length;
435     }
436 
437     function isOnAuction(uint256 _tokenId) public view returns (bool onAuction) {
438         return auctions.data[_tokenId].keyIndex > 0;
439     }
440 
441     function withdrawContract() public onlyOwner {
442         msg.sender.transfer(address(this).balance);
443     }
444 
445     function refundSender(address payable _sender, uint256 _pricePaid, uint256 _auctionPrice) private {
446         uint256 etherToRefund = _pricePaid.sub(_auctionPrice);
447         if (etherToRefund > 0) {
448             _sender.transfer(etherToRefund);
449         }
450     }
451 
452     function payTokenOwner(address payable _tokenOwner, uint256 _auctionPrice) private {
453         uint256 etherToPay = _auctionPrice.sub(_auctionPrice * percentFee / 100);
454         if (etherToPay > 0) {
455             _tokenOwner.transfer(etherToPay);
456         }
457     }
458 
459     function deleteAuction(uint256 _tokenId, AuctionEntry storage _entry) private {
460         uint256 keysLength = auctions.keys.length;
461         if (_entry.keyIndex <= keysLength) {
462             // Move an existing element into the vacated key slot.
463             auctions.data[auctions.keys[keysLength - 1]].keyIndex = _entry.keyIndex;
464             auctions.keys[_entry.keyIndex - 1] = auctions.keys[keysLength - 1];
465             auctions.keys.length = keysLength - 1;
466             delete auctions.data[_tokenId];
467         }
468     }
469 
470     function calculateCurrentPrice(Auction storage _auction) private view returns (uint256) {
471         uint256 secondsInProgress = block.timestamp - _auction.startTime;
472 
473         if (secondsInProgress >= _auction.duration) {
474             return _auction.endPrice;
475         }
476 
477         int256 totalPriceChange = int256(_auction.endPrice) - int256(_auction.startPrice);
478         int256 currentPriceChange =
479             totalPriceChange * int256(secondsInProgress) / int256(_auction.duration);
480 
481         int256 calculatedPrice = int256(_auction.startPrice) + int256(currentPriceChange);
482 
483         return uint256(calculatedPrice);
484     }
485 
486 }