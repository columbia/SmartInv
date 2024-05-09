1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-28
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-02-24
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2021-11-03
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2021-11-01
15 */
16 
17 // File: contracts/Proxy/IERC1538.sol
18 
19 pragma solidity ^0.5.0;
20 
21 /// @title ERC1538 Transparent Contract Standard
22 /// @dev Required interface
23 ///  Note: the ERC-165 identifier for this interface is 0x61455567
24 interface IERC1538 {
25 
26     /// @dev This emits when one or a set of functions are updated in a transparent contract.
27     ///  The message string should give a short description of the change and why
28     ///  the change was made.
29     event CommitMessage(string message);
30 
31     /// @dev This emits for each function that is updated in a transparent contract.
32     ///  functionId is the bytes4 of the keccak256 of the function signature.
33     ///  oldDelegate is the delegate contract address of the old delegate contract if
34     ///  the function is being replaced or removed.
35     ///  oldDelegate is the zero value address(0) if a function is being added for the
36     ///  first time.
37     ///  newDelegate is the delegate contract address of the new delegate contract if
38     ///  the function is being added for the first time or if the function is being
39     ///  replaced.
40     ///  newDelegate is the zero value address(0) if the function is being removed.
41     event FunctionUpdate(bytes4 indexed functionId, address indexed oldDelegate, address indexed newDelegate, string functionSignature);
42 
43     /// @notice Updates functions in a transparent contract.
44     /// @dev If the value of _delegate is zero then the functions specified
45     ///  in _functionSignatures are removed.
46     ///  If the value of _delegate is a delegate contract address then the functions
47     ///  specified in _functionSignatures will be delegated to that address.
48     /// @param _delegate The address of a delegate contract to delegate to or zero
49     ///        to remove functions.
50     /// @param _functionSignatures A list of function signatures listed one after the other
51     /// @param _commitMessage A short description of the change and why it is made
52     ///        This message is passed to the CommitMessage event.
53     function updateContract(address _delegate, string calldata _functionSignatures, string calldata _commitMessage) external;
54 }
55 
56 // File: contracts/Proxy/ProxyBaseStorage.sol
57 
58 pragma solidity ^0.5.0;
59 
60 ///////////////////////////////////////////////////////////////////////////////////////////////////
61 /**
62  * @title ProxyBaseStorage
63  * @dev Defining base storage for the proxy contract.
64  */
65 ///////////////////////////////////////////////////////////////////////////////////////////////////
66 
67 contract ProxyBaseStorage {
68 
69     //////////////////////////////////////////// VARS /////////////////////////////////////////////
70 
71     // maps functions to the delegate contracts that execute the functions.
72     // funcId => delegate contract
73     mapping(bytes4 => address) public delegates;
74 
75     // array of function signatures supported by the contract.
76     bytes[] public funcSignatures;
77 
78     // maps each function signature to its position in the funcSignatures array.
79     // signature => index+1
80     mapping(bytes => uint256) internal funcSignatureToIndex;
81 
82     // proxy address of itself, can be used for cross-delegate calls but also safety checking.
83     address proxy;
84 
85     ///////////////////////////////////////////////////////////////////////////////////////////////
86 
87 }
88 
89 // File: contracts/IERC20.sol
90 
91 pragma solidity ^0.5.0;
92 /**
93  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
94  * the optional functions; to access them see {ERC20Detailed}.
95  */
96 interface IERC20 {
97     /**
98      * @dev Returns the amount of tokens in existence.
99      */
100     function totalSupply() external view returns (uint256);
101     /**
102      * @dev Returns the amount of tokens owned by `account`.
103      */
104     function balanceOf(address account) external view returns (uint256);
105     /**
106      * @dev Moves `amount` tokens from the caller's account to `recipient`.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transfer(address recipient, uint256 amount) external returns (bool);
113     /**
114      * @dev Returns the remaining number of tokens that `spender` will be
115      * allowed to spend on behalf of `owner` through {transferFrom}. This is
116      * zero by default.
117      *
118      * This value changes when {approve} or {transferFrom} are called.
119      */
120     function allowance(address owner, address spender) external view returns (uint256);
121     /**
122      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * IMPORTANT: Beware that changing an allowance with this method brings the risk
127      * that someone may use both the old and the new allowance by unfortunate
128      * transaction ordering. One possible solution to mitigate this race
129      * condition is to first reduce the spender's allowance to 0 and set the
130      * desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      *
133      * Emits an {Approval} event.
134      */
135     function approve(address spender, uint256 amount) external returns (bool);
136     /**
137      * @dev Moves `amount` tokens from `sender` to `recipient` using the
138      * allowance mechanism. `amount` is then deducted from the caller's
139      * allowance.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
146     function mint(address recipient, uint256 amount) external returns(bool);
147     /**
148      * @dev Emitted when `value` tokens are moved from one account (`from`) to
149      * another (`to`).
150      *
151      * Note that `value` may be zero.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 value);
154     /**
155      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
156      * a call to {approve}. `value` is the new allowance.
157      */
158     event Approval(address indexed owner, address indexed spender, uint256 value);
159       function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
160     function blindBox(address seller, string calldata tokenURI, bool flag, address to, string calldata ownerId) external returns (uint256);
161     function mintAliaForNonCrypto(uint256 price, address from) external returns (bool);
162     function nonCryptoNFTVault() external returns(address);
163     function mainPerecentage() external returns(uint256);
164     function authorPercentage() external returns(uint256);
165     function platformPerecentage() external returns(uint256);
166     function updateAliaBalance(string calldata stringId, uint256 amount) external returns(bool);
167     function getSellDetail(uint256 tokenId) external view returns (address, uint256, uint256, address, uint256, uint256, uint256);
168     function getNonCryptoWallet(string calldata ownerId) external view returns(uint256);
169     function getNonCryptoOwner(uint256 tokenId) external view returns(string memory);
170     function adminOwner(address _address) external view returns(bool);
171      function getAuthor(uint256 tokenIdFunction) external view returns (address);
172      function _royality(uint256 tokenId) external view returns (uint256);
173      function getrevenueAddressBlindBox(string calldata info) external view returns(address);
174      function getboxNameByToken(uint256 token) external view returns(string memory);
175     //Revenue share
176     function addNonCryptoAuthor(string calldata artistId, uint256 tokenId, bool _isArtist) external returns(bool);
177     function transferAliaArtist(address buyer, uint256 price, address nftVaultAddress, uint256 tokenId ) external returns(bool);
178     function checkArtistOwner(string calldata artistId, uint256 tokenId) external returns(bool);
179     function checkTokenAuthorIsArtist(uint256 tokenId) external returns(bool);
180     function withdraw(uint) external;
181     function deposit() payable external;
182     // function approve(address spender, uint256 rawAmount) external;
183 
184     // BlindBox ref:https://noborderz.slack.com/archives/C0236PBG601/p1633942033011800?thread_ts=1633941154.010300&cid=C0236PBG601
185     function isSellable (string calldata name) external view returns(bool);
186 
187     function tokenURI(uint256 tokenId) external view returns (string memory);
188 
189     function ownerOf(uint256 tokenId) external view returns (address);
190 
191     function burn (uint256 tokenId) external;
192 
193 }
194 
195 // File: contracts/INFT.sol
196 
197 pragma solidity ^0.5.0;
198 
199 // import "../openzeppelin-solidity/contracts/token/ERC721/IERC721Full.sol";
200 
201 interface INFT {
202     function transferFromAdmin(address owner, address to, uint256 tokenId) external;
203     function mintWithTokenURI(address to, string calldata tokenURI) external returns (uint256);
204     function getAuthor(uint256 tokenIdFunction) external view returns (address);
205     function updateTokenURI(uint256 tokenIdT, string calldata uriT) external;
206     //
207     function mint(address to, string calldata tokenURI) external returns (uint256);
208     function transferOwnership(address newOwner) external;
209     function ownerOf(uint256 tokenId) external view returns(address);
210     function transferFrom(address owner, address to, uint256 tokenId) external;
211 }
212 
213 // File: contracts/IFactory.sol
214 
215 pragma solidity ^0.5.0;
216 
217 
218 contract IFactory {
219     function create(string calldata name_, string calldata symbol_, address owner_) external returns(address);
220     function getCollections(address owner_) external view returns(address [] memory);
221 }
222 
223 // File: contracts/LPInterface.sol
224 
225 pragma solidity ^0.5.0;
226 
227 /**
228  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
229  * the optional functions; to access them see {ERC20Detailed}.
230  */
231 interface LPInterface {
232     /**
233      * @dev Returns the amount of tokens in existence.
234      */
235     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
236 
237    
238 }
239 
240 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
241 
242 pragma solidity ^0.5.0;
243 
244 /**
245  * @dev Wrappers over Solidity's arithmetic operations with added overflow
246  * checks.
247  *
248  * Arithmetic operations in Solidity wrap on overflow. This can easily result
249  * in bugs, because programmers usually assume that an overflow raises an
250  * error, which is the standard behavior in high level programming languages.
251  * `SafeMath` restores this intuition by reverting the transaction when an
252  * operation overflows.
253  *
254  * Using this library instead of the unchecked operations eliminates an entire
255  * class of bugs, so it's recommended to use it always.
256  */
257 library SafeMath {
258     /**
259      * @dev Returns the addition of two unsigned integers, reverting on
260      * overflow.
261      *
262      * Counterpart to Solidity's `+` operator.
263      *
264      * Requirements:
265      * - Addition cannot overflow.
266      */
267     function add(uint256 a, uint256 b) internal pure returns (uint256) {
268         uint256 c = a + b;
269         require(c >= a, "SafeMath: addition overflow");
270 
271         return c;
272     }
273 
274     /**
275      * @dev Returns the subtraction of two unsigned integers, reverting on
276      * overflow (when the result is negative).
277      *
278      * Counterpart to Solidity's `-` operator.
279      *
280      * Requirements:
281      * - Subtraction cannot overflow.
282      */
283     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
284         require(b <= a, "SafeMath: subtraction overflow");
285         uint256 c = a - b;
286 
287         return c;
288     }
289 
290     /**
291      * @dev Returns the multiplication of two unsigned integers, reverting on
292      * overflow.
293      *
294      * Counterpart to Solidity's `*` operator.
295      *
296      * Requirements:
297      * - Multiplication cannot overflow.
298      */
299     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
300         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
301         // benefit is lost if 'b' is also tested.
302         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
303         if (a == 0) {
304             return 0;
305         }
306 
307         uint256 c = a * b;
308         require(c / a == b, "SafeMath: multiplication overflow");
309 
310         return c;
311     }
312 
313     /**
314      * @dev Returns the integer division of two unsigned integers. Reverts on
315      * division by zero. The result is rounded towards zero.
316      *
317      * Counterpart to Solidity's `/` operator. Note: this function uses a
318      * `revert` opcode (which leaves remaining gas untouched) while Solidity
319      * uses an invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      * - The divisor cannot be zero.
323      */
324     function div(uint256 a, uint256 b) internal pure returns (uint256) {
325         // Solidity only automatically asserts when dividing by 0
326         require(b > 0, "SafeMath: division by zero");
327         uint256 c = a / b;
328         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
329 
330         return c;
331     }
332 
333     /**
334      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
335      * Reverts when dividing by zero.
336      *
337      * Counterpart to Solidity's `%` operator. This function uses a `revert`
338      * opcode (which leaves remaining gas untouched) while Solidity uses an
339      * invalid opcode to revert (consuming all remaining gas).
340      *
341      * Requirements:
342      * - The divisor cannot be zero.
343      */
344     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
345         require(b != 0, "SafeMath: modulo by zero");
346         return a % b;
347     }
348 }
349 
350 // File: contracts/Proxy/DexStorage.sol
351 
352 pragma solidity ^0.5.0;
353 
354 
355 
356 
357 
358 
359 ///////////////////////////////////////////////////////////////////////////////////////////////////
360 /**
361  * @title DexStorage
362  * @dev Defining dex storage for the proxy contract.
363  */
364 ///////////////////////////////////////////////////////////////////////////////////////////////////
365 
366 contract DexStorage {
367   using SafeMath for uint256;
368    address x; // dummy variable, never set or use its value in any logic contracts. It keeps garbage value & append it with any value set on it.
369    IERC20 ALIA;
370    INFT XNFT;
371    IFactory factory;
372    IERC20 OldNFTDex;
373    IERC20 BUSD;
374    IERC20 BNB;
375    struct RDetails {
376        address _address;
377        uint256 percentage;
378    }
379   struct AuthorDetails {
380     address _address;
381     uint256 royalty;
382     string ownerId;
383     bool isSecondry;
384   }
385   // uint256[] public sellList; // this violates generlization as not tracking tokenIds agains nftContracts/collections but ignoring as not using it in logic anywhere (uncommented)
386   mapping (uint256 => mapping(address => AuthorDetails)) internal _tokenAuthors;
387   mapping (address => bool) public adminOwner;
388   address payable public platform;
389   address payable public authorVault;
390   uint256 internal platformPerecentage;
391   struct fixedSell {
392   //  address nftContract; // adding to support multiple NFT contracts buy/sell 
393     address seller;
394     uint256 price;
395     uint256 timestamp;
396     bool isDollar;
397     uint256 currencyType;
398   }
399   // stuct for auction
400   struct auctionSell {
401     address seller;
402     address nftContract;
403     address bidder;
404     uint256 minPrice;
405     uint256 startTime;
406     uint256 endTime;
407     uint256 bidAmount;
408     bool isDollar;
409     uint256 currencyType;
410     // address nftAddress;
411   }
412 
413   
414   // tokenId => nftContract => fixedSell
415   mapping (uint256 => mapping (address  => fixedSell)) internal _saleTokens;
416   mapping(address => bool) public _supportNft;
417   // tokenId => nftContract => auctionSell
418   mapping(uint256 => mapping ( address => auctionSell)) internal _auctionTokens;
419   address payable public nonCryptoNFTVault;
420   // tokenId => nftContract => ownerId
421   mapping (uint256=> mapping (address => string)) internal _nonCryptoOwners;
422   struct balances{
423     uint256 bnb;
424     uint256 Alia;
425     uint256 BUSD;
426   }
427   mapping (string => balances) internal _nonCryptoWallet;
428  
429   LPInterface LPAlia;
430   LPInterface LPBNB;
431   uint256 public adminDiscount;
432   address admin;
433   mapping (string => address) internal revenueAddressBlindBox;
434   mapping (uint256=>string) internal boxNameByToken;
435    bool public collectionConfig;
436   uint256 public countCopy;
437   mapping (uint256=> mapping( address => mapping(uint256 => bool))) _allowedCurrencies;
438   IERC20 token;
439 //   struct offer {
440 //       address _address;
441 //       string ownerId;
442 //       uint256 currencyType;
443 //       uint256 price;
444 //   }
445 //   struct offers {
446 //       uint256 count;
447 //       mapping (uint256 => offer) _offer;
448 //   }
449 //   mapping(uint256 => mapping(address => offers)) _offers;
450   uint256[] allowedArray;
451 
452 }
453 
454 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
455 
456 pragma solidity ^0.5.0;
457 
458 /**
459  * @dev Contract module which provides a basic access control mechanism, where
460  * there is an account (an owner) that can be granted exclusive access to
461  * specific functions.
462  *
463  * This module is used through inheritance. It will make available the modifier
464  * `onlyOwner`, which can be aplied to your functions to restrict their use to
465  * the owner.
466  */
467 contract Ownable {
468     address internal _owner;
469 
470     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
471 
472     /**
473      * @dev Initializes the contract setting the deployer as the initial owner.
474      */
475     constructor () internal {
476         _owner = msg.sender;
477         emit OwnershipTransferred(address(0), _owner);
478     }
479 
480     /**
481      * @dev Returns the address of the current owner.
482      */
483     function owner() public view returns (address) {
484         return _owner;
485     }
486 
487     /**
488      * @dev Throws if called by any account other than the owner.
489      */
490     modifier onlyOwner() {
491         require(isOwner(), "Ownable: caller is not the owner");
492         _;
493     }
494 
495     /**
496      * @dev Returns true if the caller is the current owner.
497      */
498     function isOwner() public view returns (bool) {
499         return msg.sender == _owner;
500     }
501 
502     /**
503      * @dev Leaves the contract without owner. It will not be possible to call
504      * `onlyOwner` functions anymore. Can only be called by the current owner.
505      *
506      * > Note: Renouncing ownership will leave the contract without an owner,
507      * thereby removing any functionality that is only available to the owner.
508      */
509     function renounceOwnership() public onlyOwner {
510         emit OwnershipTransferred(_owner, address(0));
511         _owner = address(0);
512     }
513 
514     /**
515      * @dev Transfers ownership of the contract to a new account (`newOwner`).
516      * Can only be called by the current owner.
517      */
518     function transferOwnership(address newOwner) public onlyOwner {
519         _transferOwnership(newOwner);
520     }
521 
522     /**
523      * @dev Transfers ownership of the contract to a new account (`newOwner`).
524      */
525     function _transferOwnership(address newOwner) internal {
526         require(newOwner != address(0), "Ownable: new owner is the zero address");
527         emit OwnershipTransferred(_owner, newOwner);
528         _owner = newOwner;
529     }
530 }
531 
532 // File: contracts/Proxy/DexProxy.sol
533 
534 pragma solidity ^0.5.0;
535 
536 
537 
538 
539 
540 ///////////////////////////////////////////////////////////////////////////////////////////////////
541 /**
542  * @title ProxyReceiver Contract
543  * @dev Handles forwarding calls to receiver delegates while offering transparency of updates.
544  *      Follows ERC-1538 standard.
545  *
546  *    NOTE: Not recommended for direct use in a production contract, as no security control.
547  *          Provided as simple example only.
548  */
549 ///////////////////////////////////////////////////////////////////////////////////////////////////
550 
551 contract DexProxy is ProxyBaseStorage, DexStorage, IERC1538, Ownable {
552 
553 
554     constructor() public {
555 
556         proxy = address(this);
557 
558         //Adding ERC1538 updateContract function
559         bytes memory signature = "updateContract(address,string,string)";
560         bytes4 funcId = bytes4(keccak256(signature));
561         delegates[funcId] = proxy;
562         funcSignatures.push(signature);
563         funcSignatureToIndex[signature] = funcSignatures.length;
564         emit FunctionUpdate(funcId, address(0), proxy, string(signature));
565         emit CommitMessage("Added ERC1538 updateContract function at contract creation");
566     }
567 
568     ///////////////////////////////////////////////////////////////////////////////////////////////
569 
570     function() external payable {
571         if (msg.sig == bytes4(0) && msg.value != uint(0)) { // skipping ethers/BNB received to delegate
572             return;
573         }
574         address delegate = delegates[msg.sig];
575         require(delegate != address(0), "Function does not exist.");
576         assembly {
577             let ptr := mload(0x40)
578             calldatacopy(ptr, 0, calldatasize)
579             let result := delegatecall(gas, delegate, ptr, calldatasize, 0, 0)
580             let size := returndatasize
581             returndatacopy(ptr, 0, size)
582             switch result
583             case 0 {revert(ptr, size)}
584             default {return (ptr, size)}
585         }
586     }
587 
588     ///////////////////////////////////////////////////////////////////////////////////////////////
589 
590     /// @notice Updates functions in a transparent contract.
591     /// @dev If the value of _delegate is zero then the functions specified
592     ///  in _functionSignatures are removed.
593     ///  If the value of _delegate is a delegate contract address then the functions
594     ///  specified in _functionSignatures will be delegated to that address.
595     /// @param _delegate The address of a delegate contract to delegate to or zero
596     /// @param _functionSignatures A list of function signatures listed one after the other
597     /// @param _commitMessage A short description of the change and why it is made
598     ///        This message is passed to the CommitMessage event.
599     function updateContract(address _delegate, string calldata _functionSignatures, string calldata _commitMessage) onlyOwner external {
600         // pos is first used to check the size of the delegate contract.
601         // After that pos is the current memory location of _functionSignatures.
602         // It is used to move through the characters of _functionSignatures
603         uint256 pos;
604         if(_delegate != address(0)) {
605             assembly {
606                 pos := extcodesize(_delegate)
607             }
608             require(pos > 0, "_delegate address is not a contract and is not address(0)");
609         }
610 
611         // creates a bytes version of _functionSignatures
612         bytes memory signatures = bytes(_functionSignatures);
613         // stores the position in memory where _functionSignatures ends.
614         uint256 signaturesEnd;
615         // stores the starting position of a function signature in _functionSignatures
616         uint256 start;
617         assembly {
618             pos := add(signatures,32)
619             start := pos
620             signaturesEnd := add(pos,mload(signatures))
621         }
622         // the function id of the current function signature
623         bytes4 funcId;
624         // the delegate address that is being replaced or address(0) if removing functions
625         address oldDelegate;
626         // the length of the current function signature in _functionSignatures
627         uint256 num;
628         // the current character in _functionSignatures
629         uint256 char;
630         // the position of the current function signature in the funcSignatures array
631         uint256 index;
632         // the last position in the funcSignatures array
633         uint256 lastIndex;
634         // parse the _functionSignatures string and handle each function
635         for (; pos < signaturesEnd; pos++) {
636             assembly {char := byte(0,mload(pos))}
637             // 0x29 == )
638             if (char == 0x29) {
639                 pos++;
640                 num = (pos - start);
641                 start = pos;
642                 assembly {
643                     mstore(signatures,num)
644                 }
645                 funcId = bytes4(keccak256(signatures));
646                 oldDelegate = delegates[funcId];
647                 if(_delegate == address(0)) {
648                     index = funcSignatureToIndex[signatures];
649                     require(index != 0, "Function does not exist.");
650                     index--;
651                     lastIndex = funcSignatures.length - 1;
652                     if (index != lastIndex) {
653                         funcSignatures[index] = funcSignatures[lastIndex];
654                         funcSignatureToIndex[funcSignatures[lastIndex]] = index + 1;
655                     }
656                     funcSignatures.length--;
657                     delete funcSignatureToIndex[signatures];
658                     delete delegates[funcId];
659                     emit FunctionUpdate(funcId, oldDelegate, address(0), string(signatures));
660                 }
661                 else if (funcSignatureToIndex[signatures] == 0) {
662                     require(oldDelegate == address(0), "FuncId clash.");
663                     delegates[funcId] = _delegate;
664                     funcSignatures.push(signatures);
665                     funcSignatureToIndex[signatures] = funcSignatures.length;
666                     emit FunctionUpdate(funcId, address(0), _delegate, string(signatures));
667                 }
668                 else if (delegates[funcId] != _delegate) {
669                     delegates[funcId] = _delegate;
670                     emit FunctionUpdate(funcId, oldDelegate, _delegate, string(signatures));
671 
672                 }
673                 assembly {signatures := add(signatures,num)}
674             }
675         }
676         emit CommitMessage(_commitMessage);
677     }
678 
679     ///////////////////////////////////////////////////////////////////////////////////////////////
680 
681 }
682 
683 ///////////////////////////////////////////////////////////////////////////////////////////////////