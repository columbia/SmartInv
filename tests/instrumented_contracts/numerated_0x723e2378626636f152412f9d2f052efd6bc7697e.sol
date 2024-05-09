1 pragma solidity ^0.5.16;
2 
3 /**
4  * @title ERC721 token receiver interface
5  * @dev Interface for any contract that wants to support safeTransfers
6  * from ERC721 asset contracts.
7  */
8 contract IERC721Receiver {
9     /**
10      * @notice Handle the receipt of an NFT
11      * @dev The ERC721 smart contract calls this function on the recipient
12      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
13      * otherwise the caller will revert the transaction. The selector to be
14      * returned can be obtained as `this.onERC721Received.selector`. This
15      * function MAY throw to revert and reject the transfer.
16      * Note: the ERC721 contract address is always the message sender.
17      * @param operator The address which called `safeTransferFrom` function
18      * @param from The address which previously owned the token
19      * @param tokenId The NFT identifier which is being transferred
20      * @param data Additional data with no specified format
21      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
22      */
23     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
24     public returns (bytes4);
25 }
26 
27 library SafeMath {
28     /**
29      * @dev Returns the addition of two unsigned integers, reverting on
30      * overflow.
31      *
32      * Counterpart to Solidity's `+` operator.
33      *
34      * Requirements:
35      * - Addition cannot overflow.
36      */
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     /**
45      * @dev Returns the subtraction of two unsigned integers, reverting on
46      * overflow (when the result is negative).
47      *
48      * Counterpart to Solidity's `-` operator.
49      *
50      * Requirements:
51      * - Subtraction cannot overflow.
52      */
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      * - Subtraction cannot overflow.
65      *
66      * _Available since v2.4.0._
67      */
68     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b <= a, errorMessage);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the multiplication of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `*` operator.
80      *
81      * Requirements:
82      * - Multiplication cannot overflow.
83      */
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86         // benefit is lost if 'b' is also tested.
87         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b, "SafeMath: multiplication overflow");
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the integer division of two unsigned integers. Reverts on
100      * division by zero. The result is rounded towards zero.
101      *
102      * Counterpart to Solidity's `/` operator. Note: this function uses a
103      * `revert` opcode (which leaves remaining gas untouched) while Solidity
104      * uses an invalid opcode to revert (consuming all remaining gas).
105      *
106      * Requirements:
107      * - The divisor cannot be zero.
108      */
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, "SafeMath: division by zero");
111     }
112 
113     /**
114      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
115      * division by zero. The result is rounded towards zero.
116      *
117      * Counterpart to Solidity's `/` operator. Note: this function uses a
118      * `revert` opcode (which leaves remaining gas untouched) while Solidity
119      * uses an invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      * - The divisor cannot be zero.
123      *
124      * _Available since v2.4.0._
125      */
126     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         // Solidity only automatically asserts when dividing by 0
128         require(b > 0, errorMessage);
129         uint256 c = a / b;
130         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      * - The divisor cannot be zero.
145      */
146     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
147         return mod(a, b, "SafeMath: modulo by zero");
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * Reverts with custom message when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      * - The divisor cannot be zero.
160      *
161      * _Available since v2.4.0._
162      */
163     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b != 0, errorMessage);
165         return a % b;
166     }
167 }
168 
169 
170 /**
171  * @dev Collection of functions related to the address type
172  */
173 library Address {
174     /**
175      * @dev Returns true if `account` is a contract.
176      *
177      * [IMPORTANT]
178      * ====
179      * It is unsafe to assume that an address for which this function returns
180      * false is an externally-owned account (EOA) and not a contract.
181      *
182      * Among others, `isContract` will return false for the following 
183      * types of addresses:
184      *
185      *  - an externally-owned account
186      *  - a contract in construction
187      *  - an address where a contract will be created
188      *  - an address where a contract lived, but was destroyed
189      * ====
190      */
191     function isContract(address account) internal view returns (bool) {
192         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
193         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
194         // for accounts without code, i.e. `keccak256('')`
195         bytes32 codehash;
196         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
197         // solhint-disable-next-line no-inline-assembly
198         assembly { codehash := extcodehash(account) }
199         return (codehash != accountHash && codehash != 0x0);
200     }
201 
202     /**
203      * @dev Converts an `address` into `address payable`. Note that this is
204      * simply a type cast: the actual underlying value is not changed.
205      *
206      * _Available since v2.4.0._
207      */
208     function toPayable(address account) internal pure returns (address payable) {
209         return address(uint160(account));
210     }
211 
212     /**
213      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
214      * `recipient`, forwarding all available gas and reverting on errors.
215      *
216      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
217      * of certain opcodes, possibly making contracts go over the 2300 gas limit
218      * imposed by `transfer`, making them unable to receive funds via
219      * `transfer`. {sendValue} removes this limitation.
220      *
221      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
222      *
223      * IMPORTANT: because control is transferred to `recipient`, care must be
224      * taken to not create reentrancy vulnerabilities. Consider using
225      * {ReentrancyGuard} or the
226      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
227      *
228      * _Available since v2.4.0._
229      */
230     function sendValue(address payable recipient, uint256 amount) internal {
231         require(address(this).balance >= amount, "Address: insufficient balance");
232 
233         // solhint-disable-next-line avoid-call-value
234         (bool success, ) = recipient.call.value(amount)("");
235         require(success, "Address: unable to send value, recipient may have reverted");
236     }
237 }
238 
239 
240 contract Governance {
241 
242     address public _governance;
243 
244     constructor() public {
245         _governance = tx.origin;
246     }
247 
248     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
249 
250     modifier onlyGovernance {
251         require(msg.sender == _governance, "not governance");
252         _;
253     }
254 
255     function setGovernance(address governance)  public  onlyGovernance
256     {
257         require(governance != address(0), "new governance the zero address");
258         emit GovernanceTransferred(_governance, governance);
259         _governance = governance;
260     }
261 
262 
263 }
264 
265 
266 
267 
268 interface NFTFactory{
269    function claimbyrelay() external;
270 }
271 
272 interface AnftToken {
273     function transferFrom(address from, address to, uint256 tokenId) external;
274     function safeTransferFrom(address from, address to, uint256 tokenId) external;
275     function burn(uint256 tokenId) external;
276 }
277 
278 interface AToken {
279   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) ;    
280   function transfer(address dst, uint rawAmount) external returns (bool);
281   function balanceOf(address account) external view returns (uint);
282   
283 } 
284 
285 interface ApwrToken {
286   function transfer(address recipient, uint256 amount) external returns (bool);
287   function balanceOf(address account) external view returns (uint256);
288 } 
289 
290 interface RandomSeed {
291   function random_get9999( address sender, uint256 random ) external view returns (uint);
292 }
293 
294 contract NftRelay is Governance{
295     
296     using SafeMath for uint256;
297     using Address for address;
298     
299     address public _anft =  address(0x99a7e1188CE9a0b7514d084878DFb8A405D8529F);
300     address public _apwr = address(0xb60F072494c7f1b5a8ba46bc735C71A83D940D1A);  
301     address public _nftfactory = address(0xc826a85C5D0CEEBA726f63fB06B32a8Dad4C9e29);
302     address private _randseed = address(0x2eE24b976564f9625de80dCd7b96c3306ff7607B);
303 
304     // A token
305     address public _token =  address(0x77dF79539083DCd4a8898dbA296d899aFef20067); 
306     address public _teamWallet = address(0x3b2b4f84cFE480289df651bE153c147fa417Fb8A);
307     address public _nextRelayPool = address(0);
308     address public _burnPool = 0x6666666666666666666666666666666666666666;
309     
310     uint256 private releaseDate;
311     uint256 public _claimrate = 1.0 * 1e18;
312     uint256 public apwr_amount = 8* 1e15;   // 0.008
313     
314     uint256 public _claimdays = 100 days;
315     uint  private nonce = 0;
316     
317     uint256[] private _allNft;
318     
319     // Mapping from NFT-id to position in the allNft array
320     mapping(uint256 => uint256) private _allNftIndex;
321 
322     // Mapping from airdrop receiver to boolean 
323     mapping (address => bool) public hasClaimed;
324     
325     // Throws when msg.sender has already claimed the airdrop 
326     modifier hasNotClaimed() {
327         require(hasClaimed[msg.sender] == false);
328         _;
329     }
330     
331     // Throws when the 30 day airdrop period has passed 
332     modifier canClaim() {
333         require(releaseDate + _claimdays >= now);
334         _;
335     }
336     
337     event NFTReceived(address operator, address from, uint256 tokenId, bytes data);
338     event TransferNFT(address to, uint count);
339     
340     constructor() public {
341         // Set releaseDate
342         releaseDate = now;
343     }
344     
345     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4) 
346     {
347         _addNft( tokenId );
348         emit NFTReceived(operator, from, tokenId, data);
349         return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
350     }
351     
352     function setNftFactory( address newfactory ) external onlyGovernance {
353         _nftfactory = newfactory;
354     }
355 
356     function setnextRelayPool( address newrelaypool ) external onlyGovernance {
357         _nextRelayPool = newrelaypool;
358     }
359     
360     function setclaimDays( uint256 claimdays ) external onlyGovernance {
361         _claimdays = claimdays;
362     }
363  
364     function setuseToken( address token ) external onlyGovernance {
365         _token = token;
366     }
367 
368     function setclaimRate( uint256 claimrate ) external onlyGovernance {
369         _claimrate = claimrate;
370     }
371     
372     function getclaimRate() public view returns (uint256) {
373         return _claimrate;
374     }
375     
376     function IsClaimed( address account ) public view returns (bool) {
377         return hasClaimed[account];
378     }
379     
380     function mintNft( ) external 
381     {
382             NFTFactory _nftfactoryx =  NFTFactory(_nftfactory);
383             _nftfactoryx.claimbyrelay( );
384     }
385     
386     function claimNFTbytokens(  uint256 amount ) external  canClaim()
387     {
388         
389         require( amount >= _claimrate, "ARTTamount not enough");
390         
391         if( amount > 0 )
392         {
393             AToken _tokenx =  AToken(_token);
394             _tokenx.transferFrom(msg.sender, address(this), amount );
395         }
396         
397         RandomSeed _rc = RandomSeed(_randseed);
398         uint randnum = _rc.random_get9999(msg.sender,nonce);  
399         nonce = nonce + 1;
400         
401         uint256 total = _allNft.length;
402         uint256 md = SafeMath.mod( randnum, total );
403         uint id = nftByIndex(md);
404         
405         _removeNft( id );
406         AnftToken _anftx =  AnftToken(_anft);
407         _anftx.safeTransferFrom( address(this), msg.sender, id );
408         
409         ApwrToken _apwrx = ApwrToken(_apwr);
410         _apwrx.transfer( msg.sender, apwr_amount );
411 
412         // Set boolean for hasClaimed
413         hasClaimed[msg.sender] = true;
414     }
415  
416 
417     function claim() external hasNotClaimed()  canClaim()
418     {
419             require( _claimrate == 0, "No Free, to pay Atoken is needed");
420             
421             RandomSeed _rc = RandomSeed(_randseed);
422             uint randnum = _rc.random_get9999(msg.sender,nonce);  
423             nonce = nonce + 1;
424             
425             uint256 total = _allNft.length;
426             uint256 md = SafeMath.mod( randnum, total );
427             uint id = nftByIndex(md);
428             
429             _removeNft( id );
430             AnftToken _anftx =  AnftToken(_anft);
431             _anftx.safeTransferFrom( address(this), msg.sender, id );
432     
433             ApwrToken _apwrx = ApwrToken(_apwr);
434             _apwrx.transfer( msg.sender, apwr_amount );
435             
436             // Set boolean for hasClaimed
437             hasClaimed[msg.sender] = true;
438     }
439      
440     
441     /**
442      * @dev Private function to remove a token from this extension's token tracking data structures.
443      * This has O(1) time complexity, but alters the order of the _allTokens array.
444      * @param nftId uint256 ID of the token to be removed from the tokens list
445      */
446      
447     function _removeNft(uint256 nftId) private {
448 
449         uint256 lastNftIndex = _allNft.length.sub(1);
450         uint256 NftIndex = _allNftIndex[nftId];
451 
452         uint256 lastNftId = _allNft[lastNftIndex];
453 
454         _allNft[NftIndex] = lastNftId; 
455         _allNftIndex[lastNftId] = NftIndex; 
456 
457         _allNft.length--;
458         _allNftIndex[nftId] = 0;
459     }
460         
461     /**
462      * @dev Private function to add a token to this extension's token tracking data structures.
463      * @param tokenId uint256 ID of the token to be added to the tokens list
464      */
465     function _addNft(uint256 tokenId) private {
466         _allNftIndex[tokenId] = _allNft.length;
467         _allNft.push(tokenId);
468     }
469     
470     /**
471      * @dev Gets the total amount of NFT stored by the contract.
472      * @return uint256 representing the total amount of NFT
473      */
474     function totalNFTs() public view returns (uint256) {
475         return _allNft.length;
476     }
477 
478     /**
479      * @dev Gets the total amount of ArtPower stored by the contract.
480      * @return uint256 representing the total amount of APWR
481      */
482     function totalAPWR() public view returns (uint256) {
483         ApwrToken _apwrx = ApwrToken(_apwr);
484         return _apwrx.balanceOf(address(this));
485     }
486 
487     /**
488      * @dev Gets the token ID at a given index of all the NFT in this contract
489      * Reverts if the index is greater or equal to the total number of NFT.
490      * @param index uint256 representing the index to be accessed of the NFT list
491      * @return uint256 token ID at the given index of the NFT list
492      */
493     function nftByIndex(uint256 index) public view returns (uint256) {
494         require(index < totalNFTs(), "ERC721: global index out of bounds");
495         return _allNft[index];
496     }
497  
498     function MigrateNFT() external onlyGovernance 
499     {
500          uint count =  _allNft.length;
501          uint id = 0;
502          if( count >= 1 )
503          {
504             AnftToken _anftx =  AnftToken(_anft);
505             id = _allNft[0];
506             _removeNft( id );
507             _anftx.safeTransferFrom( address(this), _nextRelayPool, id );
508 
509             ApwrToken _apwrx = ApwrToken(_apwr);
510             _apwrx.transfer( _nextRelayPool, apwr_amount );
511          }
512          
513          emit TransferNFT( _nextRelayPool, count );
514     }
515     
516     // Transfer Atoken to _teamWallet
517     function seizeAtoken() external  
518     {
519         AToken _tokenx =  AToken(_token);
520         uint _currentBalance =  _tokenx.balanceOf(address(this));
521         _tokenx.transfer(_teamWallet, _currentBalance );
522     }
523 
524     function setPoweramount( uint256 amount ) external onlyGovernance
525     {
526         apwr_amount = amount;
527     }
528     
529 }