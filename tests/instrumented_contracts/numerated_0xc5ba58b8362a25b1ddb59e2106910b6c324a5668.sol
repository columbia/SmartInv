1 /*
2  * Crypto stamp On-Chain Shop
3  * Selling NFTs directly and handling shipping of connected physical assets
4  *
5  * Developed by capacity.at
6  * for post.at
7  */
8 
9 // File: openzeppelin-solidity\contracts\token\ERC721\IERC721Receiver.sol
10 
11 pragma solidity ^0.5.0;
12 
13 /**
14  * @title ERC721 token receiver interface
15  * @dev Interface for any contract that wants to support safeTransfers
16  * from ERC721 asset contracts.
17  */
18 contract IERC721Receiver {
19     /**
20      * @notice Handle the receipt of an NFT
21      * @dev The ERC721 smart contract calls this function on the recipient
22      * after a `safeTransfer`. This function MUST return the function selector,
23      * otherwise the caller will revert the transaction. The selector to be
24      * returned can be obtained as `this.onERC721Received.selector`. This
25      * function MAY throw to revert and reject the transfer.
26      * Note: the ERC721 contract address is always the message sender.
27      * @param operator The address which called `safeTransferFrom` function
28      * @param from The address which previously owned the token
29      * @param tokenId The NFT identifier which is being transferred
30      * @param data Additional data with no specified format
31      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
32      */
33     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
34     public returns (bytes4);
35 }
36 
37 // File: node_modules\openzeppelin-solidity\contracts\introspection\IERC165.sol
38 
39 pragma solidity ^0.5.0;
40 
41 /**
42  * @title IERC165
43  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
44  */
45 interface IERC165 {
46     /**
47      * @notice Query if a contract implements an interface
48      * @param interfaceId The interface identifier, as specified in ERC-165
49      * @dev Interface identification is specified in ERC-165. This function
50      * uses less than 30,000 gas.
51      */
52     function supportsInterface(bytes4 interfaceId) external view returns (bool);
53 }
54 
55 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721.sol
56 
57 pragma solidity ^0.5.0;
58 
59 
60 /**
61  * @title ERC721 Non-Fungible Token Standard basic interface
62  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
63  */
64 contract IERC721 is IERC165 {
65     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
66     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
67     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
68 
69     function balanceOf(address owner) public view returns (uint256 balance);
70     function ownerOf(uint256 tokenId) public view returns (address owner);
71 
72     function approve(address to, uint256 tokenId) public;
73     function getApproved(uint256 tokenId) public view returns (address operator);
74 
75     function setApprovalForAll(address operator, bool _approved) public;
76     function isApprovedForAll(address owner, address operator) public view returns (bool);
77 
78     function transferFrom(address from, address to, uint256 tokenId) public;
79     function safeTransferFrom(address from, address to, uint256 tokenId) public;
80 
81     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
82 }
83 
84 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721Enumerable.sol
85 
86 pragma solidity ^0.5.0;
87 
88 
89 /**
90  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
91  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
92  */
93 contract IERC721Enumerable is IERC721 {
94     function totalSupply() public view returns (uint256);
95     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
96 
97     function tokenByIndex(uint256 index) public view returns (uint256);
98 }
99 
100 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721Metadata.sol
101 
102 pragma solidity ^0.5.0;
103 
104 
105 /**
106  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
107  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
108  */
109 contract IERC721Metadata is IERC721 {
110     function name() external view returns (string memory);
111     function symbol() external view returns (string memory);
112     function tokenURI(uint256 tokenId) external view returns (string memory);
113 }
114 
115 // File: openzeppelin-solidity\contracts\token\ERC721\IERC721Full.sol
116 
117 pragma solidity ^0.5.0;
118 
119 
120 
121 
122 /**
123  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
124  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
125  */
126 contract IERC721Full is IERC721, IERC721Enumerable, IERC721Metadata {
127     // solhint-disable-previous-line no-empty-blocks
128 }
129 
130 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
131 
132 pragma solidity ^0.5.0;
133 
134 /**
135  * @title ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/20
137  */
138 interface IERC20 {
139     function transfer(address to, uint256 value) external returns (bool);
140 
141     function approve(address spender, uint256 value) external returns (bool);
142 
143     function transferFrom(address from, address to, uint256 value) external returns (bool);
144 
145     function totalSupply() external view returns (uint256);
146 
147     function balanceOf(address who) external view returns (uint256);
148 
149     function allowance(address owner, address spender) external view returns (uint256);
150 
151     event Transfer(address indexed from, address indexed to, uint256 value);
152 
153     event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
157 
158 pragma solidity ^0.5.0;
159 
160 /**
161  * @title SafeMath
162  * @dev Unsigned math operations with safety checks that revert on error
163  */
164 library SafeMath {
165     /**
166     * @dev Multiplies two unsigned integers, reverts on overflow.
167     */
168     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
169         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
170         // benefit is lost if 'b' is also tested.
171         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
172         if (a == 0) {
173             return 0;
174         }
175 
176         uint256 c = a * b;
177         require(c / a == b);
178 
179         return c;
180     }
181 
182     /**
183     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
184     */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         // Solidity only automatically asserts when dividing by 0
187         require(b > 0);
188         uint256 c = a / b;
189         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
190 
191         return c;
192     }
193 
194     /**
195     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
196     */
197     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
198         require(b <= a);
199         uint256 c = a - b;
200 
201         return c;
202     }
203 
204     /**
205     * @dev Adds two unsigned integers, reverts on overflow.
206     */
207     function add(uint256 a, uint256 b) internal pure returns (uint256) {
208         uint256 c = a + b;
209         require(c >= a);
210 
211         return c;
212     }
213 
214     /**
215     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
216     * reverts when dividing by zero.
217     */
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         require(b != 0);
220         return a % b;
221     }
222 }
223 
224 // File: contracts\OracleRequest.sol
225 
226 /*
227 Interface for requests to the rate oracle (for EUR/ETH)
228 Copy this to projects that need to access the oracle.
229 See rate-oracle project for implementation.
230 */
231 pragma solidity ^0.5.0;
232 
233 
234 contract OracleRequest {
235 
236     uint256 public EUR_WEI; //number of wei per EUR
237 
238     uint256 public lastUpdate; //timestamp of when the last update occurred
239 
240     function ETH_EUR() public view returns (uint256); //number of EUR per ETH (rounded down!)
241 
242     function ETH_EURCENT() public view returns (uint256); //number of EUR cent per ETH (rounded down!)
243 
244 }
245 
246 // File: contracts\PricingStrategy.sol
247 
248 pragma solidity ^0.5.0;
249 
250 
251 contract PricingStrategy {
252 
253     function adjustPrice(uint256 oldprice, uint256 remainingPieces) public view returns (uint256); //returns the new price
254 
255 }
256 
257 // File: contracts\Last100PricingStrategy.sol
258 
259 /*
260 
261 */
262 pragma solidity ^0.5.0;
263 
264 
265 
266 
267 contract Last100PricingStrategy is PricingStrategy {
268 
269     /**
270     calculates a new price based on the old price and other params referenced
271     */
272     function adjustPrice(uint256 _oldPrice, uint256 _remainingPieces) public view returns (uint256){
273         if (_remainingPieces < 100) {
274             return _oldPrice * 110 / 100;
275         } else {
276             return _oldPrice;
277         }
278     }
279 }
280 
281 // File: contracts\OnChainShop.sol
282 
283 /*
284 Implements an on-chain shop for crypto stamp
285 */
286 pragma solidity ^0.5.0;
287 
288 
289 
290 
291 
292 
293 
294 
295 contract OnChainShop is IERC721Receiver {
296     using SafeMath for uint256;
297 
298     IERC721Full internal cryptostamp;
299     OracleRequest internal oracle;
300     PricingStrategy internal pricingStrategy;
301 
302     address payable public beneficiary;
303     address public shippingControl;
304     address public tokenAssignmentControl;
305 
306     uint256 public priceEurCent;
307 
308     bool internal _isOpen = true;
309 
310     enum Status{
311         Initial,
312         Sold,
313         ShippingSubmitted,
314         ShippingConfirmed
315     }
316 
317     event AssetSold(address indexed buyer, uint256 indexed tokenId, uint256 priceWei);
318     event ShippingSubmitted(address indexed owner, uint256 indexed tokenId, string deliveryInfo);
319     event ShippingFailed(address indexed owner, uint256 indexed tokenId, string reason);
320     event ShippingConfirmed(address indexed owner, uint256 indexed tokenId);
321 
322     mapping(uint256 => Status) public deliveryStatus;
323 
324     constructor(OracleRequest _oracle,
325         uint256 _priceEurCent,
326         address payable _beneficiary,
327         address _shippingControl,
328         address _tokenAssignmentControl)
329     public
330     {
331         oracle = _oracle;
332         require(address(oracle) != address(0x0), "You need to provide an actual Oracle contract.");
333         beneficiary = _beneficiary;
334         require(address(beneficiary) != address(0x0), "You need to provide an actual beneficiary address.");
335         tokenAssignmentControl = _tokenAssignmentControl;
336         require(address(tokenAssignmentControl) != address(0x0), "You need to provide an actual tokenAssignmentControl address.");
337         shippingControl = _shippingControl;
338         require(address(shippingControl) != address(0x0), "You need to provide an actual shippingControl address.");
339         priceEurCent = _priceEurCent;
340         require(priceEurCent > 0, "You need to provide a non-zero price.");
341         pricingStrategy = new Last100PricingStrategy();
342     }
343 
344     modifier onlyBeneficiary() {
345         require(msg.sender == beneficiary, "Only the current benefinicary can call this function.");
346         _;
347     }
348 
349     modifier onlyTokenAssignmentControl() {
350         require(msg.sender == tokenAssignmentControl, "tokenAssignmentControl key required for this function.");
351         _;
352     }
353 
354     modifier onlyShippingControl() {
355         require(msg.sender == shippingControl, "shippingControl key required for this function.");
356         _;
357     }
358 
359     modifier requireOpen() {
360         require(isOpen() == true, "This call only works when the shop is open.");
361         _;
362     }
363 
364     modifier requireCryptostamp() {
365         require(address(cryptostamp) != address(0x0), "You need to provide an actual Cryptostamp contract.");
366         _;
367     }
368 
369     /*** Enable adjusting variables after deployment ***/
370 
371     function setCryptostamp(IERC721Full _newCryptostamp)
372     public
373     onlyBeneficiary
374     {
375         require(address(_newCryptostamp) != address(0x0), "You need to provide an actual Cryptostamp contract.");
376         cryptostamp = _newCryptostamp;
377     }
378 
379     function setPrice(uint256 _newPriceEurCent)
380     public
381     onlyBeneficiary
382     {
383         require(_newPriceEurCent > 0, "You need to provide a non-zero price.");
384         priceEurCent = _newPriceEurCent;
385     }
386 
387     function setBeneficiary(address payable _newBeneficiary)
388     public
389     onlyBeneficiary
390     {
391         beneficiary = _newBeneficiary;
392     }
393 
394     function setOracle(OracleRequest _newOracle)
395     public
396     onlyBeneficiary
397     {
398         require(address(_newOracle) != address(0x0), "You need to provide an actual Oracle contract.");
399         oracle = _newOracle;
400     }
401 
402     function setPricingStrategy(PricingStrategy _newPricingStrategy)
403     public
404     onlyBeneficiary
405     {
406         require(address(_newPricingStrategy) != address(0x0), "You need to provide an actual PricingStrategy contract.");
407         pricingStrategy = _newPricingStrategy;
408     }
409 
410     function openShop()
411     public
412     onlyBeneficiary
413     requireCryptostamp
414     {
415         _isOpen = true;
416     }
417 
418     function closeShop()
419     public
420     onlyBeneficiary
421     {
422         _isOpen = false;
423     }
424 
425     /*** Actual shopping functionality ***/
426 
427     // return true if shop is currently open for purchases.
428     function isOpen()
429     public view
430     requireCryptostamp
431     returns (bool)
432     {
433         return _isOpen;
434     }
435 
436     // Calculate current asset price in wei.
437     // Note: Price in EUR cent is available from public var getter priceEurCent().
438     function priceWei()
439     public view
440     returns (uint256)
441     {
442         return priceEurCent.mul(oracle.EUR_WEI()).div(100);
443     }
444 
445     // For buying a single asset, just send enough ether to this contract.
446     function()
447     external payable
448     requireOpen
449     {
450         //get from eurocents to wei
451         uint256 curPriceWei = priceWei();
452         //update the price according to the strategy for the following buyer.
453         uint256 remaining = cryptostamp.balanceOf(address(this));
454         priceEurCent = pricingStrategy.adjustPrice(priceEurCent, remaining);
455 
456         require(msg.value >= curPriceWei, "You need to send enough currency to actually pay the item.");
457         // Transfer the actual price to the beneficiary
458         beneficiary.transfer(curPriceWei);
459         // Find the next stamp and transfer it.
460         uint256 tokenId = cryptostamp.tokenOfOwnerByIndex(address(this), 0);
461         cryptostamp.safeTransferFrom(address(this), msg.sender, tokenId);
462         emit AssetSold(msg.sender, tokenId, curPriceWei);
463         deliveryStatus[tokenId] = Status.Sold;
464 
465         /*send back change money. last */
466         if (msg.value > curPriceWei) {
467             msg.sender.transfer(msg.value.sub(curPriceWei));
468         }
469     }
470 
471     /*** Handle physical shipping ***/
472 
473     // For token owner (after successful purchase): Request shipping.
474     // _deliveryInfo is a postal address encrypted with a public key on the client side.
475     function shipToMe(string memory _deliveryInfo, uint256 _tokenId)
476     public
477     requireOpen
478     {
479         require(cryptostamp.ownerOf(_tokenId) == msg.sender, "You can only request shipping for your own tokens.");
480         require(deliveryStatus[_tokenId] == Status.Sold, "Shipping was already requested for this token or it was not sold by this shop.");
481         emit ShippingSubmitted(msg.sender, _tokenId, _deliveryInfo);
482         deliveryStatus[_tokenId] = Status.ShippingSubmitted;
483     }
484 
485     // For shipping service: Mark shipping as completed/confirmed.
486     function confirmShipping(uint256 _tokenId)
487     public
488     onlyShippingControl
489     requireCryptostamp
490     {
491         deliveryStatus[_tokenId] = Status.ShippingConfirmed;
492         emit ShippingConfirmed(cryptostamp.ownerOf(_tokenId), _tokenId);
493     }
494 
495     // For shipping service: Mark shipping as failed/rejected (due to invalid address).
496     function rejectShipping(uint256 _tokenId, string memory _reason)
497     public
498     onlyShippingControl
499     requireCryptostamp
500     {
501         deliveryStatus[_tokenId] = Status.Sold;
502         emit ShippingFailed(cryptostamp.ownerOf(_tokenId), _tokenId, _reason);
503     }
504 
505     /*** Make sure currency or NFT doesn't get stranded in this contract ***/
506 
507     // Override ERC721Receiver to special-case receiving ERC721 tokens:
508     // We will prevent accepting a cryptostamp from others,
509     // so we can make sure that we only sell physically shippable items.
510     // We make an exception for "beneficiary", in case we decide to increase its stock in the future.
511     // Also, comment out all params that are in the interface but not actually used, to quiet compiler warnings.
512     function onERC721Received(address /*_operator*/, address _from, uint256 /*_tokenId*/, bytes memory /*_data*/)
513     public
514     requireCryptostamp
515     returns (bytes4)
516     {
517         require(_from == beneficiary, "Only the current benefinicary can send assets to the shop.");
518         return this.onERC721Received.selector;
519     }
520 
521     // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.
522     function rescueToken(IERC20 _foreignToken, address _to)
523     external
524     onlyTokenAssignmentControl
525     {
526         _foreignToken.transfer(_to, _foreignToken.balanceOf(address(this)));
527     }
528 }