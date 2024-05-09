1 pragma solidity ^0.5.11;
2 
3 
4 // via https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0, "SafeMath: division by zero");
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96      * Reverts when dividing by zero.
97      *
98      * Counterpart to Solidity's `%` operator. This function uses a `revert`
99      * opcode (which leaves remaining gas untouched) while Solidity uses an
100      * invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0, "SafeMath: modulo by zero");
107         return a % b;
108     }
109 }
110 
111 /**
112  * @title Ownable
113  * @dev The Ownable contract has an owner address, and provides basic authorization control
114  * functions, this simplifies the implementation of "user permissions".
115  */
116 contract Ownable {
117     address private _owner;
118 
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121     /**
122      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
123      * account.
124      */
125     constructor () internal {
126         _owner = msg.sender;
127         emit OwnershipTransferred(address(0), _owner);
128     }
129 
130     /**
131      * @return the address of the owner.
132      */
133     function owner() public view returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(isOwner());
142         _;
143     }
144 
145     /**
146      * @return true if `msg.sender` is the owner of the contract.
147      */
148     function isOwner() public view returns (bool) {
149         return msg.sender == _owner;
150     }
151 
152     /**
153      * @dev Allows the current owner to relinquish control of the contract.
154      * @notice Renouncing to ownership will leave the contract without an owner.
155      * It will not be possible to call the functions with the `onlyOwner`
156      * modifier anymore.
157      */
158     function renounceOwnership() public onlyOwner {
159         emit OwnershipTransferred(_owner, address(0));
160         _owner = address(0);
161     }
162 
163     /**
164      * @dev Allows the current owner to transfer control of the contract to a newOwner.
165      * @param newOwner The address to transfer ownership to.
166      */
167     function transferOwnership(address newOwner) public onlyOwner {
168         _transferOwnership(newOwner);
169     }
170 
171     /**
172      * @dev Transfers control of the contract to a newOwner.
173      * @param newOwner The address to transfer ownership to.
174      */
175     function _transferOwnership(address newOwner) internal {
176         require(newOwner != address(0));
177         emit OwnershipTransferred(_owner, newOwner);
178         _owner = newOwner;
179     }
180 }
181 
182 interface IERC1155 {
183   // Events
184 
185   /**
186    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
187    *   Operator MUST be msg.sender
188    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
189    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
190    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
191    *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
192    */
193   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
194 
195   /**
196    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
197    *   Operator MUST be msg.sender
198    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
199    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
200    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
201    *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
202    */
203   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
204 
205   /**
206    * @dev MUST emit when an approval is updated
207    */
208   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
209 
210   /**
211    * @dev MUST emit when the URI is updated for a token ID
212    *   URIs are defined in RFC 3986
213    *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
214    */
215   event URI(string _amount, uint256 indexed _id);
216 
217   /**
218    * @notice Transfers amount of an _id from the _from address to the _to address specified
219    * @dev MUST emit TransferSingle event on success
220    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
221    * MUST throw if `_to` is the zero address
222    * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
223    * MUST throw on any other error
224    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
225    * @param _from    Source address
226    * @param _to      Target address
227    * @param _id      ID of the token type
228    * @param _amount  Transfered amount
229    * @param _data    Additional data with no specified format, sent in call to `_to`
230    */
231   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
232 
233   /**
234    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
235    * @dev MUST emit TransferBatch event on success
236    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
237    * MUST throw if `_to` is the zero address
238    * MUST throw if length of `_ids` is not the same as length of `_amounts`
239    * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
240    * MUST throw on any other error
241    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
242    * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
243    * @param _from     Source addresses
244    * @param _to       Target addresses
245    * @param _ids      IDs of each token type
246    * @param _amounts  Transfer amounts per token type
247    * @param _data     Additional data with no specified format, sent in call to `_to`
248   */
249   function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
250   
251   /**
252    * @notice Get the balance of an account's Tokens
253    * @param _owner  The address of the token holder
254    * @param _id     ID of the Token
255    * @return        The _owner's balance of the Token type requested
256    */
257   function balanceOf(address _owner, uint256 _id) external view returns (uint256);
258 
259   /**
260    * @notice Get the balance of multiple account/token pairs
261    * @param _owners The addresses of the token holders
262    * @param _ids    ID of the Tokens
263    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
264    */
265   function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
266 
267   /**
268    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
269    * @dev MUST emit the ApprovalForAll event on success
270    * @param _operator  Address to add to the set of authorized operators
271    * @param _approved  True if the operator is approved, false to revoke approval
272    */
273   function setApprovalForAll(address _operator, bool _approved) external;
274 
275   /**
276    * @notice Queries the approval status of an operator for a given owner
277    * @param _owner     The owner of the Tokens
278    * @param _operator  Address of authorized operator
279    * @return           True if the operator is approved, false if not
280    */
281   function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
282 
283 }
284 
285 contract SaleTokens is Ownable {
286     using SafeMath for uint256;
287 
288     IERC1155 public erc1155Collection;
289 
290     // Address where funds are collected
291     address payable private walletStoredFunds;
292     address private walletStoredNFT;
293 
294     // prices in MANA by token id
295     mapping(uint256 => uint256) public priceByTokenId;
296 
297     uint256 public rateMANAETH;
298 
299     uint256 public referralPercent = 25;
300 
301     address[] public referralList;
302 
303     event SoldNFT(
304         address indexed _caller,
305         uint256 indexed _tokenId,
306         uint256 indexed _count
307     );
308 
309     /**
310      * @dev Constructor of the contract.
311      * @param _walletStoredFunds - Address of the recipient of the funds
312      * @param _walletStoredNFT - Address stored NFTs
313      * @param _erc1155Collection - Address of the collection
314      * @param _tokenIds - List token ids for prices
315      * @param _prices - prices in MANA
316      * @param _rateMANAETH - rate of MANA in WEI (1e18 = 1eth)
317      */
318     constructor(
319         address payable _walletStoredFunds,
320         address payable _walletStoredNFT,
321         IERC1155 _erc1155Collection,
322         uint256[] memory _tokenIds,
323         uint256[] memory _prices,
324         uint256 _rateMANAETH
325     )
326     public {
327         require(_tokenIds.length == _prices.length, "length for tokenIds and prices arrays must equals");
328         walletStoredFunds = _walletStoredFunds;
329         walletStoredNFT = _walletStoredNFT;
330         erc1155Collection = _erc1155Collection;
331         for (uint256 i = 0; i < _tokenIds.length; i++) {
332             uint256 id = _tokenIds[i];
333             uint256 price = _prices[i];
334             priceByTokenId[id] = price;
335         }
336         rateMANAETH = _rateMANAETH;
337     }
338 
339     /**
340 * @dev Buy NFT for ETH
341 * @param _nftId - nft id
342 * @param _count - count
343 * @param _data - Data to pass if receiver is contract
344 * @param _referral -referral address
345 */
346     function buyNFTForETHWithReferral(uint256 _nftId, uint256 _count, bytes memory _data, address payable _referral) public payable {
347         require(_count >= 1, "Count must more or equal 1");
348 
349         uint256 currentBalance = erc1155Collection.balanceOf(walletStoredNFT, _nftId);
350         require(_count <= currentBalance, "Not enough NFTs");
351 
352         uint256 price = SafeMath.mul(priceByTokenId[_nftId], rateMANAETH);
353         require(price > 0, "Price not correct");
354         require(msg.value == SafeMath.mul(price, _count), "Received ETH value not correct");
355 
356         if (_referral == address(0)) {
357             walletStoredFunds.transfer(msg.value);
358         } else {
359             bool referralRegistered = false;
360 
361             for (uint256 i = 0; i < referralList.length; i++) {
362                 if (_referral == referralList[i]) {
363                     referralRegistered = true;
364                     break;
365                 }
366             }
367             if (referralRegistered) {
368                 require(referralPercent < 50 || referralPercent >= 1, "referral Percent not correct");
369                 uint256 referralFee = SafeMath.div(SafeMath.mul(msg.value, referralPercent), 100);
370                 require(referralFee < msg.value, "referral Percent not correct");
371                 _referral.transfer(referralFee);
372                 walletStoredFunds.transfer(msg.value - referralFee);
373             } else {
374                 walletStoredFunds.transfer(msg.value);
375             }
376         }
377 
378         erc1155Collection.safeTransferFrom(walletStoredNFT, msg.sender, _nftId, _count, _data);
379 
380         emit SoldNFT(msg.sender, _nftId, _count);
381     }
382 
383     /**
384     * @dev Buy NFT for ETH
385     * @param _nftId - nft id
386     * @param _count - count
387     * @param _data -Data to pass if receiver is contract
388     */
389     function buyNFTForETH(uint256 _nftId, uint256 _count, bytes calldata _data) external payable {
390         return buyNFTForETHWithReferral(_nftId, _count, _data, address(0));
391     }
392 
393     function setPrices(
394         uint256[] memory _tokenIds,
395         uint256[] memory _prices
396     ) public onlyOwner {
397         for (uint256 i = 0; i < _tokenIds.length; i++) {
398             uint256 id = _tokenIds[i];
399             uint256 price = _prices[i];
400             priceByTokenId[id] = price;
401         }
402     }
403 
404     function getPrices(uint256[] memory _tokenIds)
405     public view returns (uint256[] memory prices)
406     {
407         prices = new uint256[](_tokenIds.length);
408         for (uint256 i = 0; i < _tokenIds.length; i++) {
409             prices[i] = priceByTokenId[_tokenIds[i]] * rateMANAETH;
410         }
411         return prices;
412     }
413 
414     function setRate(
415         uint256 _rateMANAETH
416     ) public onlyOwner {
417         rateMANAETH = _rateMANAETH;
418     }
419 
420     function setReferralPercent(
421         uint256 _val
422     ) public onlyOwner {
423         require(referralPercent < 50, "referral Percent not correct");
424         require(referralPercent >= 1, "referral Percent not correct");
425         referralPercent = _val;
426     }
427 
428     function setWallet(
429         address payable _wallet
430     ) public onlyOwner {
431         walletStoredFunds = _wallet;
432     }
433 
434     function setWalletStoredNFT(
435         address payable _wallet
436     ) public onlyOwner {
437         walletStoredNFT = _wallet;
438     }
439 
440     function addReferrals(
441         address[] memory _referralList
442     ) public onlyOwner {
443         for (uint256 i = 0; i < _referralList.length; i++) {
444             referralList.push(_referralList[i]);
445         }
446     }
447 }