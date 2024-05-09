1 pragma solidity ^0.5.16;
2 
3 /**
4   * @title ArtDeco Finance
5   *
6   * @notice ArtDeco NFT Relay: ERC-721 NFTs stored in contract for promote  
7   * 
8   */
9   
10 /***
11 * 
12 * MIT License
13 * ===========
14 * 
15 *  Copyright (c) 2020 ArtDeco
16 * 
17 * Permission is hereby granted, free of charge, to any person obtaining a copy
18 * of this software and associated documentation files (the "Software"), to deal
19 * in the Software without restriction, including without limitation the rights
20 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
21 * copies of the Software, and to permit persons to whom the Software is
22 * furnished to do so, subject to the following conditions:
23 *
24 * The above copyright notice and this permission notice shall be included in all
25 * copies or substantial portions of the Software.
26 *
27 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
30 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
33 */
34 /**
35  * @title ERC721 token receiver interface
36  * @dev Interface for any contract that wants to support safeTransfers
37  * from ERC721 asset contracts.
38  */
39 contract IERC721Receiver {
40     /**
41      * @notice Handle the receipt of an NFT
42      * @dev The ERC721 smart contract calls this function on the recipient
43      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
44      * otherwise the caller will revert the transaction. The selector to be
45      * returned can be obtained as `this.onERC721Received.selector`. This
46      * function MAY throw to revert and reject the transfer.
47      * Note: the ERC721 contract address is always the message sender.
48      * @param operator The address which called `safeTransferFrom` function
49      * @param from The address which previously owned the token
50      * @param tokenId The NFT identifier which is being transferred
51      * @param data Additional data with no specified format
52      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
53      */
54     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
55     public returns (bytes4);
56 }
57 
58 library SafeMath {
59     /**
60      * @dev Returns the addition of two unsigned integers, reverting on
61      * overflow.
62      *
63      * Counterpart to Solidity's `+` operator.
64      *
65      * Requirements:
66      * - Addition cannot overflow.
67      */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a, "SafeMath: addition overflow");
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the subtraction of two unsigned integers, reverting on
77      * overflow (when the result is negative).
78      *
79      * Counterpart to Solidity's `-` operator.
80      *
81      * Requirements:
82      * - Subtraction cannot overflow.
83      */
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87 
88     /**
89      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
90      * overflow (when the result is negative).
91      *
92      * Counterpart to Solidity's `-` operator.
93      *
94      * Requirements:
95      * - Subtraction cannot overflow.
96      *
97      * _Available since v2.4.0._
98      */
99     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      * - Multiplication cannot overflow.
114      */
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
117         // benefit is lost if 'b' is also tested.
118         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
119         if (a == 0) {
120             return 0;
121         }
122 
123         uint256 c = a * b;
124         require(c / a == b, "SafeMath: multiplication overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers. Reverts on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator. Note: this function uses a
134      * `revert` opcode (which leaves remaining gas untouched) while Solidity
135      * uses an invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         return div(a, b, "SafeMath: division by zero");
142     }
143 
144     /**
145      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
146      * division by zero. The result is rounded towards zero.
147      *
148      * Counterpart to Solidity's `/` operator. Note: this function uses a
149      * `revert` opcode (which leaves remaining gas untouched) while Solidity
150      * uses an invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      * - The divisor cannot be zero.
154      *
155      * _Available since v2.4.0._
156      */
157     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         // Solidity only automatically asserts when dividing by 0
159         require(b > 0, errorMessage);
160         uint256 c = a / b;
161         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * Reverts when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
178         return mod(a, b, "SafeMath: modulo by zero");
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
183      * Reverts with custom message when dividing by zero.
184      *
185      * Counterpart to Solidity's `%` operator. This function uses a `revert`
186      * opcode (which leaves remaining gas untouched) while Solidity uses an
187      * invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      * - The divisor cannot be zero.
191      *
192      * _Available since v2.4.0._
193      */
194     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b != 0, errorMessage);
196         return a % b;
197     }
198 }
199 
200 
201 /**
202  * @dev Collection of functions related to the address type
203  */
204 library Address {
205     /**
206      * @dev Returns true if `account` is a contract.
207      *
208      * [IMPORTANT]
209      * ====
210      * It is unsafe to assume that an address for which this function returns
211      * false is an externally-owned account (EOA) and not a contract.
212      *
213      * Among others, `isContract` will return false for the following 
214      * types of addresses:
215      *
216      *  - an externally-owned account
217      *  - a contract in construction
218      *  - an address where a contract will be created
219      *  - an address where a contract lived, but was destroyed
220      * ====
221      */
222     function isContract(address account) internal view returns (bool) {
223         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
224         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
225         // for accounts without code, i.e. `keccak256('')`
226         bytes32 codehash;
227         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
228         // solhint-disable-next-line no-inline-assembly
229         assembly { codehash := extcodehash(account) }
230         return (codehash != accountHash && codehash != 0x0);
231     }
232 
233     /**
234      * @dev Converts an `address` into `address payable`. Note that this is
235      * simply a type cast: the actual underlying value is not changed.
236      *
237      * _Available since v2.4.0._
238      */
239     function toPayable(address account) internal pure returns (address payable) {
240         return address(uint160(account));
241     }
242 
243     /**
244      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
245      * `recipient`, forwarding all available gas and reverting on errors.
246      *
247      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
248      * of certain opcodes, possibly making contracts go over the 2300 gas limit
249      * imposed by `transfer`, making them unable to receive funds via
250      * `transfer`. {sendValue} removes this limitation.
251      *
252      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
253      *
254      * IMPORTANT: because control is transferred to `recipient`, care must be
255      * taken to not create reentrancy vulnerabilities. Consider using
256      * {ReentrancyGuard} or the
257      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
258      *
259      * _Available since v2.4.0._
260      */
261     function sendValue(address payable recipient, uint256 amount) internal {
262         require(address(this).balance >= amount, "Address: insufficient balance");
263 
264         // solhint-disable-next-line avoid-call-value
265         (bool success, ) = recipient.call.value(amount)("");
266         require(success, "Address: unable to send value, recipient may have reverted");
267     }
268 }
269 
270 
271 contract Governance {
272 
273     address public _governance;
274 
275     constructor() public {
276         _governance = tx.origin;
277     }
278 
279     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
280 
281     modifier onlyGovernance {
282         require(msg.sender == _governance, "not governance");
283         _;
284     }
285 
286     function setGovernance(address governance)  public  onlyGovernance
287     {
288         require(governance != address(0), "new governance the zero address");
289         emit GovernanceTransferred(_governance, governance);
290         _governance = governance;
291     }
292 
293 
294 }
295 
296 
297 
298 
299 interface NFTFactory{
300    function claimbyrelay() external;
301 }
302 
303 interface AnftToken {
304     function transferFrom(address from, address to, uint256 tokenId) external;
305     function safeTransferFrom(address from, address to, uint256 tokenId) external;
306 }
307 
308 interface AToken {
309   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) ;    
310   function transfer(address dst, uint rawAmount) external returns (bool);
311   function balanceOf(address account) external view returns (uint);
312   
313 } 
314 
315 interface ApwrToken {
316   function transfer(address recipient, uint256 amount) external returns (bool);
317   function balanceOf(address account) external view returns (uint256);
318 } 
319 
320 interface RandomSeed {
321   function random_get9999( address sender, uint256 random ) external view returns (uint);
322 }
323 
324 contract NftRelay is Governance{
325     
326     using SafeMath for uint256;
327     using Address for address;
328     
329     address public _anft =  address(0x99a7e1188CE9a0b7514d084878DFb8A405D8529F);
330     address public _apwr = address(0xb60F072494c7f1b5a8ba46bc735C71A83D940D1A);  
331     address public _nftfactory = address(0x694D7054bc8993Ac15F9E42be364dccCBD576724);
332     address private _randseed = address(0x75A7c0f3c7E59D0Aa323cc8832EaF2729Fe2127C);
333     
334     // A token
335     address public _token =  address(0x77dF79539083DCd4a8898dbA296d899aFef20067); 
336     address public _teamWallet = address(0x3b2b4f84cFE480289df651bE153c147fa417Fb8A);
337     address public _nextRelayPool = address(0);
338     address public _burnPool = 0x6666666666666666666666666666666666666666;
339     
340     uint256 private releaseDate;
341     uint256 public _claimrate = 0;  //1.0 * 1e18;
342     
343     uint256 public _claimdays = 0 days;
344     uint  private nonce = 0;
345     
346     uint256[] private _allNft;
347     
348     // Mapping from NFT-id to position in the allNft array
349     mapping(uint256 => uint256) private _allNftIndex;
350 
351     // Mapping from airdrop receiver to boolean 
352     mapping (address => bool) public hasClaimed;
353     
354     // Throws when msg.sender has already claimed the airdrop 
355     modifier hasNotClaimed() {
356         require(hasClaimed[msg.sender] == false);
357         _;
358     }
359     
360     // Throws when the 30 day airdrop period has passed 
361     modifier canClaim() {
362         require(releaseDate + _claimdays >= now);
363         _;
364     }
365     
366     event NFTReceived(address operator, address from, uint256 tokenId, bytes data);
367     event TransferNFT(address to, uint count);
368     
369     constructor() public {
370         // Set releaseDate
371         releaseDate = now;
372     }
373     
374     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4) 
375     {
376         _addNft( tokenId );
377         emit NFTReceived(operator, from, tokenId, data);
378         return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
379     }
380     
381     function setNftFactory( address newfactory ) external onlyGovernance {
382         _nftfactory = newfactory;
383     }
384 
385     function setnextRelayPool( address newrelaypool ) external onlyGovernance {
386         _nextRelayPool = newrelaypool;
387     }
388     
389     function setclaimDays( uint256 claimdays ) external onlyGovernance {
390         _claimdays = claimdays;
391     }
392  
393     function setuseToken( address token ) external onlyGovernance {
394         _token = token;
395     }
396 
397     function setclaimRate( uint256 claimrate ) external onlyGovernance {
398         _claimrate = claimrate;
399     }
400     
401     function getclaimRate() public view returns (uint256) {
402         return _claimrate;
403     }
404     
405     function IsClaimed( address account ) public view returns (bool) {
406         return hasClaimed[account];
407     }
408     
409     function mintNft( ) external 
410     {
411             NFTFactory _nftfactoryx =  NFTFactory(_nftfactory);
412             _nftfactoryx.claimbyrelay( );
413     }
414 
415     function claimNFTbytokens(  uint256 amount ) external hasNotClaimed()  canClaim()
416     {
417         
418         require( amount >= _claimrate, "ARTTamount not enough");
419         
420         if( amount > 0 )
421         {
422             AToken _tokenx =  AToken(_token);
423             _tokenx.transferFrom(msg.sender, address(this), amount );
424         }
425         
426         RandomSeed _rc = RandomSeed(_randseed);
427         uint randnum = _rc.random_get9999(msg.sender,nonce);  
428         nonce = nonce + 1;
429         
430         uint256 total = _allNft.length;
431         uint256 md = SafeMath.mod( randnum, total );
432         uint id = nftByIndex(md);
433         
434         _removeNft( id );
435         AnftToken _anftx =  AnftToken(_anft);
436         _anftx.safeTransferFrom( address(this), msg.sender, id );
437         
438         ApwrToken _apwrx = ApwrToken(_apwr);
439         _apwrx.transfer( msg.sender, 1* 1e16 );
440 
441         // Set boolean for hasClaimed
442         hasClaimed[msg.sender] = true;
443     }
444  
445 
446     function claim() external hasNotClaimed()  canClaim()
447     {
448             require( _claimrate == 0, "No Free, to pay Atoken is needed");
449             
450             RandomSeed _rc = RandomSeed(_randseed);
451             uint randnum = _rc.random_get9999(msg.sender,nonce);  
452             nonce = nonce + 1;
453             
454             uint256 total = _allNft.length;
455             uint256 md = SafeMath.mod( randnum, total );
456             uint id = nftByIndex(md);
457             
458             _removeNft( id );
459             AnftToken _anftx =  AnftToken(_anft);
460             _anftx.safeTransferFrom( address(this), msg.sender, id );
461     
462             ApwrToken _apwrx = ApwrToken(_apwr);
463             _apwrx.transfer( msg.sender, 1* 1e16 );
464             
465             // Set boolean for hasClaimed
466             hasClaimed[msg.sender] = true;
467     }
468      
469     
470     /**
471      * @dev Private function to remove a token from this extension's token tracking data structures.
472      * This has O(1) time complexity, but alters the order of the _allTokens array.
473      * @param nftId uint256 ID of the token to be removed from the tokens list
474      */
475      
476     function _removeNft(uint256 nftId) private {
477 
478         uint256 lastNftIndex = _allNft.length.sub(1);
479         uint256 NftIndex = _allNftIndex[nftId];
480 
481         uint256 lastNftId = _allNft[lastNftIndex];
482 
483         _allNft[NftIndex] = lastNftId; 
484         _allNftIndex[lastNftId] = NftIndex; 
485 
486         _allNft.length--;
487         _allNftIndex[nftId] = 0;
488     }
489         
490     /**
491      * @dev Private function to add a token to this extension's token tracking data structures.
492      * @param tokenId uint256 ID of the token to be added to the tokens list
493      */
494     function _addNft(uint256 tokenId) private {
495         _allNftIndex[tokenId] = _allNft.length;
496         _allNft.push(tokenId);
497     }
498     
499     /**
500      * @dev Gets the total amount of NFT stored by the contract.
501      * @return uint256 representing the total amount of NFT
502      */
503     function totalNFTs() public view returns (uint256) {
504         return _allNft.length;
505     }
506 
507     /**
508      * @dev Gets the total amount of ArtPower stored by the contract.
509      * @return uint256 representing the total amount of APWR
510      */
511     function totalAPWR() public view returns (uint256) {
512         ApwrToken _apwrx = ApwrToken(_apwr);
513         return _apwrx.balanceOf(address(this));
514     }
515 
516     /**
517      * @dev Gets the token ID at a given index of all the NFT in this contract
518      * Reverts if the index is greater or equal to the total number of NFT.
519      * @param index uint256 representing the index to be accessed of the NFT list
520      * @return uint256 token ID at the given index of the NFT list
521      */
522     function nftByIndex(uint256 index) public view returns (uint256) {
523         require(index < totalNFTs(), "ERC721: global index out of bounds");
524         return _allNft[index];
525     }
526  
527     function MigrateNFT() external onlyGovernance 
528     {
529          uint count =  _allNft.length;
530          uint id = 0;
531          if( count >= 1 )
532          {
533             AnftToken _anftx =  AnftToken(_anft);
534             id = _allNft[0];
535             _removeNft( id );
536             _anftx.safeTransferFrom( address(this), _nextRelayPool, id );
537 
538             ApwrToken _apwrx = ApwrToken(_apwr);
539             _apwrx.transfer( _nextRelayPool, 1* 1e16 );
540          }
541          
542          emit TransferNFT( _nextRelayPool, count );
543     }
544     
545     // Transfer Atoken to _teamWallet
546     function seizeAtoken() external  
547     {
548         AToken _tokenx =  AToken(_token);
549         uint _currentBalance =  _tokenx.balanceOf(address(this));
550         _tokenx.transfer(_teamWallet, _currentBalance );
551     }
552     
553     
554 }