1 // ___________      ___.   .__                                          
2 // \_   _____/ _____\_ |__ |  |   ____   _____                          
3 //  |    __)_ /     \| __ \|  | _/ __ \ /     \                         
4 //  |        \  Y Y  \ \_\ \  |_\  ___/|  Y Y  \                        
5 // /_______  /__|_|  /___  /____/\___  >__|_|  /                        
6 //         \/      \/    \/          \/      \/                         
7 //     ____   ____            .__   __                                  
8 //     \   \ /   /____   __ __|  |_/  |_                                
9 //      \   Y   /\__  \ |  |  \  |\   __\                               
10 //       \     /  / __ \|  |  /  |_|  |                                 
11 //       \___/  (____  /____/|____/__|                                 
12 //                   \/                                                
13 //   ___ ___                    .___.__                          _________
14 //  /   |   \_____    ____    __| _/|  |   ___________  ___  __ |  ____  /
15 // /    ~    \__  \  /    \  / __ | |  | _/ __ \_  __ \ \  \/   /    / /
16 // \    Y    // __ \|   |  \/ /_/ | |  |_\  ___/|  | \/  \    /    / /
17 //  \___|_  /(____  /___|  /\____ | |____/\___  >__|      \_/    /_/
18 //       \/      \/     \/      \/           \/                     
19 
20   
21 // File: browser/ReentrancyGuard.sol
22 
23 // SPDX-License-Identifier: MIT
24 
25 pragma solidity ^0.6.0;
26 
27 /**
28  * @dev Contract module that helps prevent reentrant calls to a function.
29  *
30  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
31  * available, which can be applied to functions to make sure there are no nested
32  * (reentrant) calls to them.
33  *
34  * Note that because there is a single `nonReentrant` guard, functions marked as
35  * `nonReentrant` may not call one another. This can be worked around by making
36  * those functions `private`, and then adding `external` `nonReentrant` entry
37  * points to them.
38  *
39  * TIP: If you would like to learn more about reentrancy and alternative ways
40  * to protect against it, check out our blog post
41  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
42  */
43 contract ReentrancyGuard {
44     // Booleans are more expensive than uint256 or any type that takes up a full
45     // word because each write operation emits an extra SLOAD to first read the
46     // slot's contents, replace the bits taken up by the boolean, and then write
47     // back. This is the compiler's defense against contract upgrades and
48     // pointer aliasing, and it cannot be disabled.
49 
50     // The values being non-zero value makes deployment a bit more expensive,
51     // but in exchange the refund on every call to nonReentrant will be lower in
52     // amount. Since refunds are capped to a percentage of the total
53     // transaction's gas, it is best to keep them low in cases like this one, to
54     // increase the likelihood of the full refund coming into effect.
55     uint256 private constant _NOT_ENTERED = 1;
56     uint256 private constant _ENTERED = 2;
57 
58     uint256 private _status;
59 
60     constructor () internal {
61         _status = _NOT_ENTERED;
62     }
63 
64     /**
65      * @dev Prevents a contract from calling itself, directly or indirectly.
66      * Calling a `nonReentrant` function from another `nonReentrant`
67      * function is not supported. It is possible to prevent this from happening
68      * by making the `nonReentrant` function external, and make it call a
69      * `private` function that does the actual work.
70      */
71     modifier nonReentrant() {
72         // On the first call to nonReentrant, _notEntered will be true
73         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
74 
75         // Any calls to nonReentrant after this point will fail
76         _status = _ENTERED;
77 
78         _;
79 
80         // By storing the original value once again, a refund is triggered (see
81         // https://eips.ethereum.org/EIPS/eip-2200)
82         _status = _NOT_ENTERED;
83     }
84 }
85 // File: browser/IERC20Token.sol
86 
87 pragma solidity ^0.6.11;
88 interface IERC20Token {
89     function transfer(address to, uint256 value) external returns (bool);
90     function approve(address spender, uint256 value) external returns (bool);
91     function transferFrom(address from, address to, uint256 value) external returns (bool);
92     function totalSupply() external view returns (uint256);
93     function balanceOf(address who) external view returns (uint256);
94     function allowance(address owner, address spender) external view returns (uint256);
95     event Transfer(address indexed from, address indexed to, uint256 value);
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 // File: browser/SafeMath.sol
99 
100 pragma solidity ^0.6.11;
101 
102 /**
103  * @dev Wrappers over Solidity's arithmetic operations with added overflow
104  * checks.
105  *
106  * Arithmetic operations in Solidity wrap on overflow. This can easily result
107  * in bugs, because programmers usually assume that an overflow raises an
108  * error, which is the standard behavior in high level programming languages.
109  * `SafeMath` restores this intuition by reverting the transaction when an
110  * operation overflows.
111  *
112  * Using this library instead of the unchecked operations eliminates an entire
113  * class of bugs, so it's recommended to use it always.
114  */
115 library SafeMath {
116     /**
117      * @dev Returns the addition of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `+` operator.
121      *
122      * Requirements:
123      *
124      * - Addition cannot overflow.
125      */
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         require(c >= a, "SafeMath: addition overflow");
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b <= a, errorMessage);
159         uint256 c = a - b;
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the multiplication of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `*` operator.
169      *
170      * Requirements:
171      *
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b != 0, errorMessage);
254         return a % b;
255     }
256 }
257 // File: browser/VaultHandler_v4.sol
258 
259 pragma experimental ABIEncoderV2;
260 pragma solidity ^0.6.11;
261 
262 
263 interface IERC721 {
264     function burn(uint256 tokenId) external;
265     function transferFrom(address from, address to, uint256 tokenId) external;
266     function mint( address _to, uint256 _tokenId, string calldata _uri, string calldata _payload) external;
267     function changeName(string calldata name, string calldata symbol) external;
268     function updateTokenUri(uint256 _tokenId,string memory _uri) external;
269     function tokenPayload(uint256 _tokenId) external view returns (string memory);
270     function ownerOf(uint256 _tokenId) external returns (address _owner);
271     function getApproved(uint256 _tokenId) external returns (address);
272     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
273 }
274 
275 interface Ownable {
276     function transferOwnership(address newOwner) external;
277 }
278 
279 interface BasicERC20 {
280     function burn(uint256 value) external;
281     function mint(address account, uint256 amount) external;
282     function decimals() external view returns (uint8);
283 }
284 
285 contract Context {
286     constructor() internal {}
287 
288     // solhint-disable-previous-line no-empty-blocks
289 
290     function _msgSender() internal view returns (address payable) {
291         return msg.sender;
292     }
293 }
294 
295 
296 contract Bridged is Context {
297     using SafeMath for uint256;
298     using SafeMath for uint8;
299     using SafeMath for uint;
300 
301     address public paymentAddress;
302     
303     mapping(uint => bool) public chainIds;
304     mapping(uint => uint256) public chainBalances;
305     
306     constructor () public {
307         chainIds[1] = true;
308         chainBalances[1] = 200000000000000000;
309         chainIds[137] = true;
310         chainBalances[137] = 200000000000000000;
311         chainIds[80001] = true;
312         chainBalances[80001] = 200000000000000000;
313         chainIds[100] = true;
314         chainBalances[100] = 200000000000000000;
315         chainIds[56] = true;
316         chainBalances[56] = 200000000000000000;
317         chainIds[250] = true;
318         chainBalances[250] = 200000000000000000;
319     }
320     
321     function transferToChain(uint chainId, uint256 amount) public returns (bool) {
322         require(chainIds[chainId], 'Invalid Chain ID');
323         IERC20Token paymentToken = IERC20Token(paymentAddress);
324         require(paymentToken.allowance(_msgSender(), address(this)) >= amount, 'Handler unable to spend ');
325         require(paymentToken.transferFrom(_msgSender(), address(this), amount), 'Transfer ERROR');
326         BasicERC20(paymentAddress).burn(amount);
327         chainBalances[chainId] = chainBalances[chainId].add(amount);
328         emit BridgeDeposit(_msgSender(), amount, chainId);
329         
330         return true;
331     }
332     
333     function _transferFromChain(address _to, uint chainId, uint256 amount) internal returns (bool) {
334         require(chainBalances[chainId] >= amount, 'Can not transfer more than deposited');
335         require(chainIds[chainId], 'Invalid Chain ID');
336         BasicERC20 paymentToken = BasicERC20(paymentAddress);
337         paymentToken.mint(_to, amount);
338         chainBalances[chainId] = chainBalances[chainId].sub(amount);
339         emit BridgeWithdrawal(_msgSender(), amount, chainId);
340         
341         return true;
342     }
343     
344     event BridgeDeposit(address indexed sender, uint256 indexed amount, uint chainId);
345     event BridgeWithdrawal(address indexed sender, uint256 indexed amount, uint chainId);
346     
347     function _addChainId(uint chainId) internal returns (bool) {
348         chainIds[chainId] = true;
349         return true;
350     }
351     
352     function _removeChainId(uint chainId) internal returns (bool) {
353         chainIds[chainId] = false;
354         return true;
355     }
356     
357 }
358 
359 contract VaultHandlerV7 is ReentrancyGuard, Bridged {
360     
361     using SafeMath for uint256;
362     using SafeMath for uint8;
363     address payable private owner;
364     string public metadataBaseUri;
365     bool public initialized;
366     address public nftAddress;
367     address public recipientAddress;
368     // address public couponAddress;
369     uint256 public price;
370     // uint256 public offerPrice = 0;
371     // bool public payToAcceptOffer = false;
372     // bool public payToMakeOffer = false;
373     bool public shouldBurn = false;
374     
375     struct PreMint {
376         string payload;
377         bytes32 preImage;
378     }
379     
380     struct PreTransfer {
381         string payload;
382         bytes32 preImage;
383         address _from;
384     }
385     
386     struct Offer {
387         uint tokenId;
388         address _from;
389     }
390 
391     
392     // mapping(uint => PreMint) public tokenIdToPreMint;
393     mapping(address => mapping(uint => PreMint)) preMints;
394     mapping(address => mapping(uint => PreMint)) preMintsByIndex;
395     mapping(address => uint) preMintCounts;
396     
397     mapping(uint => PreTransfer) preTransfers;
398     mapping(uint => mapping(uint => PreTransfer)) preTransfersByIndex;
399     mapping(uint => uint) preTransferCounts;
400     
401     mapping(uint => Offer[]) offers;
402     mapping(uint => Offer[]) rejected;
403     mapping(address => mapping(uint => Offer)) offered;
404     
405     mapping(address => bool) public witnesses;
406     mapping(uint256 => bool) usedNonces;
407     
408     // event for EVM logging
409     event OwnerSet(address indexed oldOwner, address indexed newOwner);
410     
411     // modifier to check if caller is owner
412     modifier isOwner() {
413         // If the first argument of 'require' evaluates to 'false', execution terminates and all
414         // changes to the state and to Ether balances are reverted.
415         // This used to consume all gas in old EVM versions, but not anymore.
416         // It is often a good idea to use 'require' to check if functions are called correctly.
417         // As a second argument, you can also provide an explanation about what went wrong.
418         require(msg.sender == owner, "Caller is not owner");
419         _;
420     }
421     
422     /**
423      * @dev Change owner
424      * @param newOwner address of new owner
425      */
426     function transferOwnership(address payable newOwner) public isOwner {
427         emit OwnerSet(owner, newOwner);
428         owner = newOwner;
429     }
430     
431     /**
432      * @dev Return owner address 
433      * @return address of owner
434      */
435     function getOwner() external view returns (address) {
436         return owner;
437     }
438     
439     constructor(address _nftAddress, address _paymentAddress, address _recipientAddress, uint256 _price) public {
440         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
441         emit OwnerSet(address(0), owner);
442         addWitness(owner);
443         metadataBaseUri = "https://api.emblemvault.io/s:evmetadata/meta/";
444         nftAddress = _nftAddress;
445         paymentAddress = _paymentAddress;
446         recipientAddress = _recipientAddress;
447         initialized = true;
448         uint decimals = BasicERC20(paymentAddress).decimals();
449         price = _price * 10 ** decimals;
450     }
451     
452     function claim(uint256 tokenId) public isOwner {
453         IERC721 token = IERC721(nftAddress);
454         token.burn(tokenId);
455     }
456     
457     function buyWithPaymentOnly(address _to, uint256 _tokenId, string calldata image) public payable {
458         IERC20Token paymentToken = IERC20Token(paymentAddress);
459         IERC721 nftToken = IERC721(nftAddress);
460         PreMint memory preMint = preMints[msg.sender][_tokenId];
461         require(preMint.preImage == sha256(abi.encodePacked(image)), 'Payload does not match'); // Payload should match
462         if (shouldBurn) {
463             require(paymentToken.transferFrom(msg.sender, address(this), price), 'Transfer ERROR'); // Payment sent to recipient
464             BasicERC20(paymentAddress).burn(price);
465         } else {
466             require(paymentToken.transferFrom(msg.sender, address(recipientAddress), price), 'Transfer ERROR'); // Payment sent to recipient
467         }
468         string memory _uri = concat(metadataBaseUri, uintToStr(_tokenId));
469         nftToken.mint(_to, _tokenId, _uri, preMint.payload);
470         delete preMintsByIndex[msg.sender][preMintCounts[msg.sender]];
471         delete preMints[msg.sender][_tokenId];
472         preMintCounts[msg.sender] = preMintCounts[msg.sender].sub(1);
473     }
474     
475     function buyWithSignature(address _to, uint256 _tokenId, string calldata _payload, uint256 _nonce, bytes calldata _signature) public payable {
476         IERC20Token paymentToken = IERC20Token(paymentAddress);
477         IERC721 nftToken = IERC721(nftAddress);
478         if (shouldBurn) {
479             require(paymentToken.transferFrom(msg.sender, address(this), price), 'Transfer ERROR'); // Payment sent to recipient
480             BasicERC20(paymentAddress).burn(price);
481         } else {
482             require(paymentToken.transferFrom(msg.sender, address(recipientAddress), price), 'Transfer ERROR'); // Payment sent to recipient
483         }
484         
485         address signer = getAddressFromSignature(_tokenId, _nonce, _payload, _signature);
486         require(witnesses[signer], 'Not Witnessed');
487         usedNonces[_nonce] = true;
488         string memory _uri = concat(metadataBaseUri, uintToStr(_tokenId));
489         nftToken.mint(_to, _tokenId, _uri, _payload);
490     }
491     
492     
493     function addPreMint(address _for, string calldata _payload, uint256 _tokenId, bytes32 preImage) public isOwner {
494         try IERC721(nftAddress).tokenPayload(_tokenId) returns (string memory) {
495             revert('NFT Exists with this ID');
496         } catch {
497             require(!_duplicatePremint(_for, _tokenId), 'Duplicate PreMint');
498             preMintCounts[_for] = preMintCounts[_for].add(1);
499             preMints[_for][_tokenId] = PreMint(_payload, preImage);
500             preMintsByIndex[_for][preMintCounts[_for]] = preMints[_for][_tokenId];
501         }
502     }
503     
504     function _duplicatePremint(address _for, uint256 _tokenId) internal view returns (bool) {
505         string memory data = preMints[_for][_tokenId].payload;
506         bytes32 NULL = keccak256(bytes(''));
507         return keccak256(bytes(data)) != NULL;
508     }
509     
510     function deletePreMint(address _for, uint256 _tokenId) public isOwner {
511         delete preMintsByIndex[_for][preMintCounts[_for]];
512         preMintCounts[_for] = preMintCounts[_for].sub(1);
513         delete preMints[_for][_tokenId];
514     }
515     
516     function getPreMint(address _for, uint256 _tokenId) public view returns (PreMint memory) {
517         return preMints[_for][_tokenId];
518     }
519     
520     function checkPreMintImage(string memory image, bytes32 preImage) public pure returns (bytes32, bytes32, bool) {
521         bytes32 calculated = sha256(abi.encodePacked(image));
522         bytes32 preBytes = preImage;
523         return (calculated, preBytes, calculated == preBytes);
524     }
525     
526     function getPreMintCount(address _for) public view returns (uint length) {
527         return preMintCounts[_for];
528     }
529     
530     function getPreMintByIndex(address _for, uint index) public view returns (PreMint memory) {
531         return preMintsByIndex[_for][index];
532     }
533     
534     function toggleShouldBurn() public {
535         shouldBurn = !shouldBurn;
536     }
537     
538     /* Transfer with code */
539     function addWitness(address _witness) public isOwner {
540         witnesses[_witness] = true;
541     }
542 
543     function removeWitness(address _witness) public isOwner {
544         witnesses[_witness] = false;
545     }
546     
547     function getAddressFromSignature(uint256 _tokenId, uint256 _nonce, bytes memory signature) public view returns (address) {
548         require(!usedNonces[_nonce]);
549         bytes32 hash = keccak256(abi.encodePacked(concat(uintToStr(_tokenId), uintToStr(_nonce))));
550         address addressFromSig = recoverSigner(hash, signature);
551         return addressFromSig;
552     }
553     
554     function getAddressFromSignature(uint256 _tokenId, uint256 _nonce, string calldata payload, bytes memory signature) public view returns (address) {
555         require(!usedNonces[_nonce]);
556         string memory combined = concat(uintToStr(_tokenId), payload);
557         bytes32 hash = keccak256(abi.encodePacked(concat(combined, uintToStr(_nonce))));
558         address addressFromSig = recoverSigner(hash, signature);
559         return addressFromSig;
560     }
561     
562     function getAddressFromSignature(bytes32 _hash, bytes calldata signature) public pure returns (address) {
563         address addressFromSig = recoverSigner(_hash, signature);
564         return addressFromSig;
565     }
566     
567     function getHash(string calldata _payload) public pure returns (bytes32) {
568         bytes32 hash = keccak256(abi.encodePacked(_payload));
569         return hash;
570     }
571     
572     function transferWithCode(uint256 _tokenId, string calldata code, address _to, uint256 _nonce,  bytes memory signature) public payable {
573         require(witnesses[getAddressFromSignature(_tokenId, _nonce, signature)], 'Not Witnessed');
574         IERC721 nftToken = IERC721(nftAddress);
575         PreTransfer memory preTransfer = preTransfers[_tokenId];
576         require(preTransfer.preImage == sha256(abi.encodePacked(code)), 'Code does not match'); // Payload should match
577         nftToken.transferFrom(preTransfer._from, _to,  _tokenId);
578         delete preTransfers[_tokenId];
579         delete preTransfersByIndex[_tokenId][preTransferCounts[_tokenId]];
580         preTransferCounts[_tokenId] = preTransferCounts[_tokenId].sub(1);
581         usedNonces[_nonce] = true;
582     }
583     
584     function addPreTransfer(uint256 _tokenId, bytes32 preImage) public {
585         require(!_duplicatePretransfer(_tokenId), 'Duplicate PreTransfer');
586         preTransferCounts[_tokenId] = preTransferCounts[_tokenId].add(1);
587         preTransfers[_tokenId] = PreTransfer("payload", preImage, msg.sender);
588         preTransfersByIndex[_tokenId][preTransferCounts[_tokenId]] = preTransfers[_tokenId];
589     }
590     
591     function _duplicatePretransfer(uint256 _tokenId) internal view returns (bool) {
592         string memory data = preTransfers[_tokenId].payload;
593         bytes32 NULL = keccak256(bytes(''));
594         return keccak256(bytes(data)) != NULL;
595     }
596     
597     function deletePreTransfer(uint256 _tokenId) public {
598         require(preTransfers[_tokenId]._from == msg.sender, 'PreTransfer does not belong to sender');
599         delete preTransfersByIndex[_tokenId][preTransferCounts[_tokenId]];
600         preTransferCounts[_tokenId] = preTransferCounts[_tokenId].sub(1);
601         delete preTransfers[_tokenId];
602     }
603     
604     function getPreTransfer(uint256 _tokenId) public view returns (PreTransfer memory) {
605         return preTransfers[_tokenId];
606     }
607     
608     function checkPreTransferImage(string memory image, bytes32 preImage) public pure returns (bytes32, bytes32, bool) {
609         bytes32 calculated = sha256(abi.encodePacked(image));
610         bytes32 preBytes = preImage;
611         return (calculated, preBytes, calculated == preBytes);
612     }
613     
614     function getPreTransferCount(uint256 _tokenId) public view returns (uint length) {
615         return preTransferCounts[_tokenId];
616     }
617     
618     function getPreTransferByIndex(uint256 _tokenId, uint index) public view returns (PreTransfer memory) {
619         return preTransfersByIndex[_tokenId][index];
620     }
621     
622     function changeMetadataBaseUri(string calldata _uri) public isOwner {
623         metadataBaseUri = _uri;
624     }
625     
626     function transferPaymentOwnership(address newOwner) external isOwner {
627         Ownable paymentToken = Ownable(paymentAddress);
628         paymentToken.transferOwnership(newOwner);
629     }
630     
631     function transferNftOwnership(address newOwner) external isOwner {
632         Ownable nftToken = Ownable(nftAddress);
633         nftToken.transferOwnership(newOwner);
634     }
635     
636     function mint( address _to, uint256 _tokenId, string calldata _uri, string calldata _payload) external isOwner {
637         IERC721 nftToken = IERC721(nftAddress);
638         nftToken.mint(_to, _tokenId, _uri, _payload);
639     }
640     
641     function changeName(string calldata name, string calldata symbol) external isOwner {
642         IERC721 nftToken = IERC721(nftAddress);
643         nftToken.changeName(name, symbol);
644     }
645     
646     function updateTokenUri(uint256 _tokenId,string memory _uri) external isOwner {
647         IERC721 nftToken = IERC721(nftAddress);
648         nftToken.updateTokenUri(_tokenId, _uri);
649     }
650     
651     function getPaymentDecimals() public view returns (uint8){
652         BasicERC20 token = BasicERC20(paymentAddress);
653         return token.decimals();
654     }
655     
656     function changePayment(address payment) public isOwner {
657        paymentAddress = payment;
658     }
659     
660     // function changeCoupon(address coupon) public isOwner {
661     //   couponAddress = coupon;
662     // }
663     
664     function changeRecipient(address _recipient) public isOwner {
665        recipientAddress = _recipient;
666     }
667     
668     function changeNft(address token) public isOwner {
669         nftAddress = token;
670     }
671     
672     function changePrice(uint256 _price) public isOwner {
673         uint decimals = BasicERC20(paymentAddress).decimals();
674         price = _price * 10 ** decimals;
675     }
676     
677     // function changeOfferPrice(uint256 _price) public isOwner {
678     //     uint decimals = BasicERC20(couponAddress).decimals();
679     //     offerPrice = _price * 10 ** decimals;
680     // }
681     
682     function addChainId(uint chainId) public isOwner returns (bool) {
683         return (_addChainId(chainId));
684     }
685     
686     function removeChainId(uint chainId) public isOwner returns (bool) {
687         return (_removeChainId(chainId));
688     }
689     
690     function transferFromChain(address _to, uint chainId, uint256 amount) public isOwner returns (bool) {
691         return _transferFromChain(_to, chainId, amount);
692     }
693     
694     function concat(string memory a, string memory b) internal pure returns (string memory) {
695         return string(abi.encodePacked(a, b));
696     }
697     /**
698     * @dev Recover signer address from a message by using their signature
699     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
700     * @param sig bytes signature, the signature is generated using web3.eth.sign(). Inclusive "0x..."
701     */
702     function recoverSigner(bytes32 hash, bytes memory sig) internal pure returns (address) {
703         require(sig.length == 65, "Require correct length");
704 
705         bytes32 r;
706         bytes32 s;
707         uint8 v;
708 
709         // Divide the signature in r, s and v variables
710         assembly {
711             r := mload(add(sig, 32))
712             s := mload(add(sig, 64))
713             v := byte(0, mload(add(sig, 96)))
714         }
715 
716         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
717         if (v < 27) {
718             v += 27;
719         }
720 
721         require(v == 27 || v == 28, "Signature version not match");
722 
723         return recoverSigner2(hash, v, r, s);
724     }
725 
726     function recoverSigner2(bytes32 h, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
727         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
728         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, h));
729         address addr = ecrecover(prefixedHash, v, r, s);
730 
731         return addr;
732     }
733     
734     /// @notice converts number to string
735     /// @dev source: https://github.com/provable-things/ethereum-api/blob/master/oraclizeAPI_0.5.sol#L1045
736     /// @param _i integer to convert
737     /// @return _uintAsString
738     function uintToStr(uint _i) internal pure returns (string memory _uintAsString) {
739         uint number = _i;
740         if (number == 0) {
741             return "0";
742         }
743         uint j = number;
744         uint len;
745         while (j != 0) {
746             len++;
747             j /= 10;
748         }
749         bytes memory bstr = new bytes(len);
750         uint k = len - 1;
751         while (number != 0) {
752             bstr[k--] = byte(uint8(48 + number % 10));
753             number /= 10;
754         }
755         return string(bstr);
756     }
757     
758     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
759         bytes memory tempEmptyStringTest = bytes(source);
760         if (tempEmptyStringTest.length == 0) {
761             return 0x0;
762         }
763     
764         assembly {
765             result := mload(add(source, 32))
766         }
767     }
768     function bytes32ToStr(bytes32 _bytes32) internal pure returns (string memory) {
769 
770         // string memory str = string(_bytes32);
771         // TypeError: Explicit type conversion not allowed from "bytes32" to "string storage pointer"
772         // thus we should fist convert bytes32 to bytes (to dynamically-sized byte array)
773     
774         bytes memory bytesArray = new bytes(32);
775         for (uint256 i; i < 32; i++) {
776             bytesArray[i] = _bytes32[i];
777             }
778         return string(bytesArray);
779     }
780     function asciiToInteger(bytes32 x) public pure returns (uint256) {
781         uint256 y;
782         for (uint256 i = 0; i < 32; i++) {
783             uint256 c = (uint256(x) >> (i * 8)) & 0xff;
784             if (48 <= c && c <= 57)
785                 y += (c - 48) * 10 ** i;
786             else
787                 break;
788         }
789         return y;
790     }
791     function toString(address account) public pure returns(string memory) {
792         return toString(abi.encodePacked(account));
793     }
794     
795     function toString(uint256 value) public pure returns(string memory) {
796         return toString(abi.encodePacked(value));
797     }
798     
799     function toString(bytes32 value) public pure returns(string memory) {
800         return toString(abi.encodePacked(value));
801     }
802     
803     function toString(bytes memory data) public pure returns(string memory) {
804         bytes memory alphabet = "0123456789abcdef";
805     
806         bytes memory str = new bytes(2 + data.length * 2);
807         str[0] = "0";
808         str[1] = "x";
809         for (uint i = 0; i < data.length; i++) {
810             str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
811             str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
812         }
813         return string(str);
814     }
815 }