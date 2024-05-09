1 pragma solidity ^0.5.6;
2 
3 interface ILinkdropERC20 {
4 
5     function verifyLinkdropSignerSignature
6     (
7         uint _weiAmount,
8         address _tokenAddress,
9         uint _tokenAmount,
10         uint _expiration,
11         address _linkId,
12         bytes calldata _signature
13     )
14     external view returns (bool);
15 
16     function verifyReceiverSignature
17     (
18         address _linkId,
19 	    address _receiver,
20 		bytes calldata _signature
21     )
22     external view returns (bool);
23 
24     function checkClaimParams
25     (
26         uint _weiAmount,
27         address _tokenAddress,
28         uint _tokenAmount,
29         uint _expiration,
30         address _linkId,
31         bytes calldata _linkdropSignerSignature,
32         address _receiver,
33         bytes calldata _receiverSignature,
34         uint _fee
35     )
36     external view returns (bool);
37 
38     function claim
39     (
40         uint _weiAmount,
41         address _tokenAddress,
42         uint _tokenAmount,
43         uint _expiration,
44         address _linkId,
45         bytes calldata _linkdropSignerSignature,
46         address payable _receiver,
47         bytes calldata _receiverSignature,
48         address payable _feeReceiver,
49         uint _fee
50     )
51     external returns (bool);
52 
53 }
54 
55 interface ILinkdropFactoryERC20 {
56 
57     function checkClaimParams
58     (
59         uint _weiAmount,
60         address _tokenAddress,
61         uint _tokenAmount,
62         uint _expiration,
63         address _linkId,
64         address payable _linkdropMaster,
65         uint _campaignId,
66         bytes calldata _linkdropSignerSignature,
67         address _receiver,
68         bytes calldata _receiverSignature
69     )
70     external view
71     returns (bool);
72 
73     function claim
74     (
75         uint _weiAmount,
76         address _tokenAddress,
77         uint _tokenAmount,
78         uint _expiration,
79         address _linkId,
80         address payable _linkdropMaster,
81         uint _campaignId,
82         bytes calldata _linkdropSignerSignature,
83         address payable _receiver,
84         bytes calldata _receiverSignature
85     )
86     external
87     returns (bool);
88 
89 }
90 
91 /**
92  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
93  * the optional functions; to access them see `ERC20Detailed`.
94  */
95 interface IERC20 {
96     /**
97      * @dev Returns the amount of tokens in existence.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     /**
102      * @dev Returns the amount of tokens owned by `account`.
103      */
104     function balanceOf(address account) external view returns (uint256);
105 
106     /**
107      * @dev Moves `amount` tokens from the caller's account to `recipient`.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * Emits a `Transfer` event.
112      */
113     function transfer(address recipient, uint256 amount) external returns (bool);
114 
115     /**
116      * @dev Returns the remaining number of tokens that `spender` will be
117      * allowed to spend on behalf of `owner` through `transferFrom`. This is
118      * zero by default.
119      *
120      * This value changes when `approve` or `transferFrom` are called.
121      */
122     function allowance(address owner, address spender) external view returns (uint256);
123 
124     /**
125      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * > Beware that changing an allowance with this method brings the risk
130      * that someone may use both the old and the new allowance by unfortunate
131      * transaction ordering. One possible solution to mitigate this race
132      * condition is to first reduce the spender's allowance to 0 and set the
133      * desired value afterwards:
134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135      *
136      * Emits an `Approval` event.
137      */
138     function approve(address spender, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Moves `amount` tokens from `sender` to `recipient` using the
142      * allowance mechanism. `amount` is then deducted from the caller's
143      * allowance.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a `Transfer` event.
148      */
149     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Emitted when `value` tokens are moved from one account (`from`) to
153      * another (`to`).
154      *
155      * Note that `value` may be zero.
156      */
157     event Transfer(address indexed from, address indexed to, uint256 value);
158 
159     /**
160      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
161      * a call to `approve`. `value` is the new allowance.
162      */
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 
167 interface ILinkdropERC721 {
168 
169     function verifyLinkdropSignerSignatureERC721
170     (
171         uint _weiAmount,
172         address _nftAddress,
173         uint _tokenId,
174         uint _expiration,
175         address _linkId,
176         bytes calldata _signature
177     )
178     external view returns (bool);
179 
180     function verifyReceiverSignatureERC721
181     (
182         address _linkId,
183 	    address _receiver,
184 		bytes calldata _signature
185     )
186     external view returns (bool);
187 
188     function checkClaimParamsERC721
189     (
190         uint _weiAmount,
191         address _nftAddress,
192         uint _tokenId,
193         uint _expiration,
194         address _linkId,
195         bytes calldata _linkdropSignerSignature,
196         address _receiver,
197         bytes calldata _receiverSignature,
198         uint _fee
199     )
200     external view returns (bool);
201 
202     function claimERC721
203     (
204         uint _weiAmount,
205         address _nftAddress,
206         uint _tokenId,
207         uint _expiration,
208         address _linkId,
209         bytes calldata _linkdropSignerSignature,
210         address payable _receiver,
211         bytes calldata _receiverSignature,
212         address payable _feeReceiver,
213         uint _fee
214     )
215     external returns (bool);
216 
217 }
218 
219 
220 interface ILinkdropFactoryERC721 {
221 
222     function checkClaimParamsERC721
223     (
224         uint _weiAmount,
225         address _nftAddress,
226         uint _tokenId,
227         uint _expiration,
228         address _linkId,
229         address payable _linkdropMaster,
230         uint _campaignId,
231         bytes calldata _linkdropSignerSignature,
232         address _receiver,
233         bytes calldata _receiverSignature
234     )
235     external view
236     returns (bool);
237 
238     function claimERC721
239     (
240         uint _weiAmount,
241         address _nftAddress,
242         uint _tokenId,
243         uint _expiration,
244         address _linkId,
245         address payable _linkdropMaster,
246         uint _campaignId,
247         bytes calldata _linkdropSignerSignature,
248         address payable _receiver,
249         bytes calldata _receiverSignature
250     )
251     external
252     returns (bool);
253 
254 }
255 
256 interface ILinkdropCommon {
257 
258     function initialize
259     (
260         address _owner,
261         address payable _linkdropMaster,
262         uint _version,
263         uint _chainId
264     )
265     external returns (bool);
266 
267     function isClaimedLink(address _linkId) external view returns (bool);
268     function isCanceledLink(address _linkId) external view returns (bool);
269     function paused() external view returns (bool);
270     function cancel(address _linkId) external  returns (bool);
271     function withdraw() external returns (bool);
272     function pause() external returns (bool);
273     function unpause() external returns (bool);
274     function addSigner(address _linkdropSigner) external payable returns (bool);
275     function removeSigner(address _linkdropSigner) external returns (bool);
276     function destroy() external;
277     function getMasterCopyVersion() external view returns (uint);
278     function () external payable;
279 
280 }
281 
282 /**
283  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
284  *
285  * These functions can be used to verify that a message was signed by the holder
286  * of the private keys of a given address.
287  */
288 library ECDSA {
289     /**
290      * @dev Returns the address that signed a hashed message (`hash`) with
291      * `signature`. This address can then be used for verification purposes.
292      *
293      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
294      * this function rejects them by requiring the `s` value to be in the lower
295      * half order, and the `v` value to be either 27 or 28.
296      *
297      * (.note) This call _does not revert_ if the signature is invalid, or
298      * if the signer is otherwise unable to be retrieved. In those scenarios,
299      * the zero address is returned.
300      *
301      * (.warning) `hash` _must_ be the result of a hash operation for the
302      * verification to be secure: it is possible to craft signatures that
303      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
304      * this is by receiving a hash of the original message (which may otherwise)
305      * be too long), and then calling `toEthSignedMessageHash` on it.
306      */
307     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
308         // Check the signature length
309         if (signature.length != 65) {
310             return (address(0));
311         }
312 
313         // Divide the signature in r, s and v variables
314         bytes32 r;
315         bytes32 s;
316         uint8 v;
317 
318         // ecrecover takes the signature parameters, and the only way to get them
319         // currently is to use assembly.
320         // solhint-disable-next-line no-inline-assembly
321         assembly {
322             r := mload(add(signature, 0x20))
323             s := mload(add(signature, 0x40))
324             v := byte(0, mload(add(signature, 0x60)))
325         }
326 
327         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
328         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
329         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
330         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
331         //
332         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
333         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
334         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
335         // these malleable signatures as well.
336         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
337             return address(0);
338         }
339 
340         if (v != 27 && v != 28) {
341             return address(0);
342         }
343 
344         // If the signature is valid (and not malleable), return the signer address
345         return ecrecover(hash, v, r, s);
346     }
347 
348     /**
349      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
350      * replicates the behavior of the
351      * [`eth_sign`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign)
352      * JSON-RPC method.
353      *
354      * See `recover`.
355      */
356     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
357         // 32 is the length in bytes of hash,
358         // enforced by the type signature above
359         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
360     }
361 }
362 
363 
364 /**
365  * @dev Wrappers over Solidity's arithmetic operations with added overflow
366  * checks.
367  *
368  * Arithmetic operations in Solidity wrap on overflow. This can easily result
369  * in bugs, because programmers usually assume that an overflow raises an
370  * error, which is the standard behavior in high level programming languages.
371  * `SafeMath` restores this intuition by reverting the transaction when an
372  * operation overflows.
373  *
374  * Using this library instead of the unchecked operations eliminates an entire
375  * class of bugs, so it's recommended to use it always.
376  */
377 library SafeMath {
378     /**
379      * @dev Returns the addition of two unsigned integers, reverting on
380      * overflow.
381      *
382      * Counterpart to Solidity's `+` operator.
383      *
384      * Requirements:
385      * - Addition cannot overflow.
386      */
387     function add(uint256 a, uint256 b) internal pure returns (uint256) {
388         uint256 c = a + b;
389         require(c >= a, "SafeMath: addition overflow");
390 
391         return c;
392     }
393 
394     /**
395      * @dev Returns the subtraction of two unsigned integers, reverting on
396      * overflow (when the result is negative).
397      *
398      * Counterpart to Solidity's `-` operator.
399      *
400      * Requirements:
401      * - Subtraction cannot overflow.
402      */
403     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
404         require(b <= a, "SafeMath: subtraction overflow");
405         uint256 c = a - b;
406 
407         return c;
408     }
409 
410     /**
411      * @dev Returns the multiplication of two unsigned integers, reverting on
412      * overflow.
413      *
414      * Counterpart to Solidity's `*` operator.
415      *
416      * Requirements:
417      * - Multiplication cannot overflow.
418      */
419     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
420         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
421         // benefit is lost if 'b' is also tested.
422         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
423         if (a == 0) {
424             return 0;
425         }
426 
427         uint256 c = a * b;
428         require(c / a == b, "SafeMath: multiplication overflow");
429 
430         return c;
431     }
432 
433     /**
434      * @dev Returns the integer division of two unsigned integers. Reverts on
435      * division by zero. The result is rounded towards zero.
436      *
437      * Counterpart to Solidity's `/` operator. Note: this function uses a
438      * `revert` opcode (which leaves remaining gas untouched) while Solidity
439      * uses an invalid opcode to revert (consuming all remaining gas).
440      *
441      * Requirements:
442      * - The divisor cannot be zero.
443      */
444     function div(uint256 a, uint256 b) internal pure returns (uint256) {
445         // Solidity only automatically asserts when dividing by 0
446         require(b > 0, "SafeMath: division by zero");
447         uint256 c = a / b;
448         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
449 
450         return c;
451     }
452 
453     /**
454      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
455      * Reverts when dividing by zero.
456      *
457      * Counterpart to Solidity's `%` operator. This function uses a `revert`
458      * opcode (which leaves remaining gas untouched) while Solidity uses an
459      * invalid opcode to revert (consuming all remaining gas).
460      *
461      * Requirements:
462      * - The divisor cannot be zero.
463      */
464     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
465         require(b != 0, "SafeMath: modulo by zero");
466         return a % b;
467     }
468 }
469 
470 
471 /**
472  * @dev Interface of the ERC165 standard, as defined in the
473  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
474  *
475  * Implementers can declare support of contract interfaces, which can then be
476  * queried by others (`ERC165Checker`).
477  *
478  * For an implementation, see `ERC165`.
479  */
480 interface IERC165 {
481     /**
482      * @dev Returns true if this contract implements the interface defined by
483      * `interfaceId`. See the corresponding
484      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
485      * to learn more about how these ids are created.
486      *
487      * This function call must use less than 30 000 gas.
488      */
489     function supportsInterface(bytes4 interfaceId) external view returns (bool);
490 }
491 
492 
493 /**
494  * @dev Contract module which provides a basic access control mechanism, where
495  * there is an account (an owner) that can be granted exclusive access to
496  * specific functions.
497  *
498  * This module is used through inheritance. It will make available the modifier
499  * `onlyOwner`, which can be aplied to your functions to restrict their use to
500  * the owner.
501  */
502 contract Ownable {
503     address private _owner;
504 
505     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
506 
507     /**
508      * @dev Initializes the contract setting the deployer as the initial owner.
509      */
510     constructor () internal {
511         _owner = msg.sender;
512         emit OwnershipTransferred(address(0), _owner);
513     }
514 
515     /**
516      * @dev Returns the address of the current owner.
517      */
518     function owner() public view returns (address) {
519         return _owner;
520     }
521 
522     /**
523      * @dev Throws if called by any account other than the owner.
524      */
525     modifier onlyOwner() {
526         require(isOwner(), "Ownable: caller is not the owner");
527         _;
528     }
529 
530     /**
531      * @dev Returns true if the caller is the current owner.
532      */
533     function isOwner() public view returns (bool) {
534         return msg.sender == _owner;
535     }
536 
537     /**
538      * @dev Leaves the contract without owner. It will not be possible to call
539      * `onlyOwner` functions anymore. Can only be called by the current owner.
540      *
541      * > Note: Renouncing ownership will leave the contract without an owner,
542      * thereby removing any functionality that is only available to the owner.
543      */
544     function renounceOwnership() public onlyOwner {
545         emit OwnershipTransferred(_owner, address(0));
546         _owner = address(0);
547     }
548 
549     /**
550      * @dev Transfers ownership of the contract to a new account (`newOwner`).
551      * Can only be called by the current owner.
552      */
553     function transferOwnership(address newOwner) public onlyOwner {
554         _transferOwnership(newOwner);
555     }
556 
557     /**
558      * @dev Transfers ownership of the contract to a new account (`newOwner`).
559      */
560     function _transferOwnership(address newOwner) internal {
561         require(newOwner != address(0), "Ownable: new owner is the zero address");
562         emit OwnershipTransferred(_owner, newOwner);
563         _owner = newOwner;
564     }
565 }
566 
567 
568 /**
569  * @dev Required interface of an ERC721 compliant contract.
570  */
571 contract IERC721 is IERC165 {
572     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
573     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
574     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
575 
576     /**
577      * @dev Returns the number of NFTs in `owner`'s account.
578      */
579     function balanceOf(address owner) public view returns (uint256 balance);
580 
581     /**
582      * @dev Returns the owner of the NFT specified by `tokenId`.
583      */
584     function ownerOf(uint256 tokenId) public view returns (address owner);
585 
586     /**
587      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
588      * another (`to`).
589      *
590      * 
591      *
592      * Requirements:
593      * - `from`, `to` cannot be zero.
594      * - `tokenId` must be owned by `from`.
595      * - If the caller is not `from`, it must be have been allowed to move this
596      * NFT by either `approve` or `setApproveForAll`.
597      */
598     function safeTransferFrom(address from, address to, uint256 tokenId) public;
599     /**
600      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
601      * another (`to`).
602      *
603      * Requirements:
604      * - If the caller is not `from`, it must be approved to move this NFT by
605      * either `approve` or `setApproveForAll`.
606      */
607     function transferFrom(address from, address to, uint256 tokenId) public;
608     function approve(address to, uint256 tokenId) public;
609     function getApproved(uint256 tokenId) public view returns (address operator);
610 
611     function setApprovalForAll(address operator, bool _approved) public;
612     function isApprovedForAll(address owner, address operator) public view returns (bool);
613 
614 
615     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
616 }
617 
618 
619 contract LinkdropFactoryStorage is Ownable {
620 
621     // Current version of mastercopy contract
622     uint public masterCopyVersion;
623 
624     // Contract bytecode to be installed when deploying proxy
625     bytes internal _bytecode;
626 
627     // Bootstrap initcode to fetch the actual contract bytecode. Used to generate repeatable contract addresses
628     bytes internal _initcode;
629 
630     // Network id
631     uint public chainId;
632 
633     // Maps hash(sender address, campaign id) to its corresponding proxy address
634     mapping (bytes32 => address) public deployed;
635 
636     // Events
637     event Deployed(address payable indexed owner, uint campaignId, address payable proxy, bytes32 salt);
638     event Destroyed(address payable owner, address payable proxy);
639     event SetMasterCopy(address masterCopy, uint version);
640 
641 }
642 
643 contract FeeManager is Ownable {
644 
645     event FeeChanged(address proxy, uint fee);
646 
647     mapping (address => uint) fees;
648 
649     uint public standardFee = 0.002 ether;
650 
651     function setFee(address _proxy, uint _fee) external onlyOwner returns (bool) {
652         _setFee(_proxy, _fee);
653         return true;
654     }
655 
656     function _setFee(address _proxy, uint _fee) internal {
657         if (fees[_proxy] != 0) {
658             require(_fee < fees[_proxy], "CANNOT_INCREASE_FEE");
659         }
660         fees[_proxy] = _fee;
661         emit FeeChanged(_proxy, _fee);
662     }
663 
664     function setStandardFee(uint _fee) external onlyOwner {
665         standardFee = _fee;
666     }
667 
668 }
669 
670 contract RelayerManager is Ownable {
671 
672     mapping (address => bool) public isRelayer;
673 
674     event RelayerAdded(address indexed relayer);
675 
676     event RelayerRemoved(address indexed relayer);
677 
678     function addRelayer(address _relayer) external onlyOwner returns (bool) {
679         require(_relayer != address(0) && !isRelayer[_relayer], "INVALID_RELAYER_ADDRESS");
680         isRelayer[_relayer] = true;
681         emit RelayerAdded(_relayer);
682         return true;
683     }
684 
685     function removeRelayer(address _relayer) external onlyOwner returns (bool) {
686         require(isRelayer[_relayer], "INVALID_RELAYER_ADDRESS");
687         isRelayer[_relayer] = false;
688         emit RelayerRemoved(_relayer);
689         return true;
690     }
691 
692 }
693 
694 
695 
696 
697 
698 
699 contract LinkdropFactoryCommon is LinkdropFactoryStorage, FeeManager, RelayerManager {
700     using SafeMath for uint;
701 
702     /**
703     * @dev Indicates whether a proxy contract for linkdrop master is deployed or not
704     * @param _linkdropMaster Address of linkdrop master
705     * @param _campaignId Campaign id
706     * @return True if deployed
707     */
708     function isDeployed(address _linkdropMaster, uint _campaignId) public view returns (bool) {
709         return (deployed[salt(_linkdropMaster, _campaignId)] != address(0));
710     }
711 
712     /**
713     * @dev Indicates whether a link is claimed or not
714     * @param _linkdropMaster Address of lindkrop master
715     * @param _campaignId Campaign id
716     * @param _linkId Address corresponding to link key
717     * @return True if claimed
718     */
719     function isClaimedLink(address payable _linkdropMaster, uint _campaignId, address _linkId) public view returns (bool) {
720 
721         if (!isDeployed(_linkdropMaster, _campaignId)) {
722             return false;
723         }
724         else {
725             address payable proxy = address(uint160(deployed[salt(_linkdropMaster, _campaignId)]));
726             return ILinkdropCommon(proxy).isClaimedLink(_linkId);
727         }
728 
729     }
730 
731     /**
732     * @dev Function to deploy a proxy contract for msg.sender
733     * @param _campaignId Campaign id
734     * @return Proxy contract address
735     */
736     function deployProxy(uint _campaignId)
737     public
738     payable
739     returns (address payable proxy)
740     {
741         proxy = _deployProxy(msg.sender, _campaignId);
742     }
743 
744     /**
745     * @dev Function to deploy a proxy contract for msg.sender and add a new signing key
746     * @param _campaignId Campaign id
747     * @param _signer Address corresponding to signing key
748     * @return Proxy contract address
749     */
750     function deployProxyWithSigner(uint _campaignId, address _signer)
751     public
752     payable
753     returns (address payable proxy)
754     {
755         proxy = deployProxy(_campaignId);
756         ILinkdropCommon(proxy).addSigner(_signer);
757     }
758 
759     /**
760     * @dev Internal function to deploy a proxy contract for linkdrop master
761     * @param _linkdropMaster Address of linkdrop master
762     * @param _campaignId Campaign id
763     * @return Proxy contract address
764     */
765     function _deployProxy(address payable _linkdropMaster, uint _campaignId)
766     internal
767     returns (address payable proxy)
768     {
769 
770         require(!isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_ALREADY_DEPLOYED");
771         require(_linkdropMaster != address(0), "INVALID_LINKDROP_MASTER_ADDRESS");
772 
773         bytes32 salt = salt(_linkdropMaster, _campaignId);
774         bytes memory initcode = getInitcode();
775 
776         assembly {
777             proxy := create2(0, add(initcode, 0x20), mload(initcode), salt)
778             if iszero(extcodesize(proxy)) { revert(0, 0) }
779         }
780 
781         deployed[salt] = proxy;
782 
783         // Initialize owner address, linkdrop master address master copy version in proxy contract
784         require
785         (
786             ILinkdropCommon(proxy).initialize
787             (
788                 address(this), // Owner address
789                 _linkdropMaster, // Linkdrop master address
790                 masterCopyVersion,
791                 chainId
792             ),
793             "INITIALIZATION_FAILED"
794         );
795 
796         // Send funds attached to proxy contract
797         proxy.transfer(msg.value);
798 
799         // Set standard fee for the proxy
800         _setFee(proxy, standardFee);
801 
802         emit Deployed(_linkdropMaster, _campaignId, proxy, salt);
803         return proxy;
804     }
805 
806     /**
807     * @dev Function to destroy proxy contract, called by proxy owner
808     * @param _campaignId Campaign id
809     * @return True if destroyed successfully
810     */
811     function destroyProxy(uint _campaignId)
812     public
813     returns (bool)
814     {
815         require(isDeployed(msg.sender, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
816         address payable proxy = address(uint160(deployed[salt(msg.sender, _campaignId)]));
817         ILinkdropCommon(proxy).destroy();
818         delete deployed[salt(msg.sender, _campaignId)];
819         delete fees[proxy];
820         emit Destroyed(msg.sender, proxy);
821         return true;
822     }
823 
824     /**
825     * @dev Function to get bootstrap initcode for generating repeatable contract addresses
826     * @return Static bootstrap initcode
827     */
828     function getInitcode()
829     public view
830     returns (bytes memory)
831     {
832         return _initcode;
833     }
834 
835     /**
836     * @dev Function to fetch the actual contract bytecode to install. Called by proxy when executing initcode
837     * @return Contract bytecode to install
838     */
839     function getBytecode()
840     public view
841     returns (bytes memory)
842     {
843         return _bytecode;
844     }
845 
846     /**
847     * @dev Function to set new master copy and update contract bytecode to install. Can only be called by factory owner
848     * @param _masterCopy Address of linkdrop mastercopy contract to calculate bytecode from
849     * @return True if updated successfully
850     */
851     function setMasterCopy(address payable _masterCopy)
852     public onlyOwner
853     returns (bool)
854     {
855         require(_masterCopy != address(0), "INVALID_MASTER_COPY_ADDRESS");
856         masterCopyVersion = masterCopyVersion.add(1);
857 
858         require
859         (
860             ILinkdropCommon(_masterCopy).initialize
861             (
862                 address(0), // Owner address
863                 address(0), // Linkdrop master address
864                 masterCopyVersion,
865                 chainId
866             ),
867             "INITIALIZATION_FAILED"
868         );
869 
870         bytes memory bytecode = abi.encodePacked
871         (
872             hex"363d3d373d3d3d363d73",
873             _masterCopy,
874             hex"5af43d82803e903d91602b57fd5bf3"
875         );
876 
877         _bytecode = bytecode;
878 
879         emit SetMasterCopy(_masterCopy, masterCopyVersion);
880         return true;
881     }
882 
883     /**
884     * @dev Function to fetch the master copy version installed (or to be installed) to proxy
885     * @param _linkdropMaster Address of linkdrop master
886     * @param _campaignId Campaign id
887     * @return Master copy version
888     */
889     function getProxyMasterCopyVersion(address _linkdropMaster, uint _campaignId) external view returns (uint) {
890 
891         if (!isDeployed(_linkdropMaster, _campaignId)) {
892             return masterCopyVersion;
893         }
894         else {
895             address payable proxy = address(uint160(deployed[salt(_linkdropMaster, _campaignId)]));
896             return ILinkdropCommon(proxy).getMasterCopyVersion();
897         }
898     }
899 
900     /**
901      * @dev Function to hash `_linkdropMaster` and `_campaignId` params. Used as salt when deploying with create2
902      * @param _linkdropMaster Address of linkdrop master
903      * @param _campaignId Campaign id
904      * @return Hash of passed arguments
905      */
906     function salt(address _linkdropMaster, uint _campaignId) public pure returns (bytes32) {
907         return keccak256(abi.encodePacked(_linkdropMaster, _campaignId));
908     }
909 
910 }
911 
912 
913 
914 
915 contract LinkdropFactoryERC20 is ILinkdropFactoryERC20, LinkdropFactoryCommon {
916 
917     /**
918     * @dev Function to verify claim params, make sure the link is not claimed or canceled and proxy has sufficient balance
919     * @param _weiAmount Amount of wei to be claimed
920     * @param _tokenAddress Token address
921     * @param _tokenAmount Amount of tokens to be claimed (in atomic value)
922     * @param _expiration Unix timestamp of link expiration time
923     * @param _linkId Address corresponding to link key
924     * @param _linkdropMaster Address corresponding to linkdrop master key
925     * @param _campaignId Campaign id
926     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
927     * @param _receiver Address of linkdrop receiver
928     * @param _receiverSignature ECDSA signature of linkdrop receiver
929     * @return True if success
930     */
931     function checkClaimParams
932     (
933         uint _weiAmount,
934         address _tokenAddress,
935         uint _tokenAmount,
936         uint _expiration,
937         address _linkId,
938         address payable _linkdropMaster,
939         uint _campaignId,
940         bytes memory _linkdropSignerSignature,
941         address _receiver,
942         bytes memory _receiverSignature
943     )
944     public view
945     returns (bool)
946     {
947         // Make sure proxy contract is deployed
948         require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
949 
950         uint fee = fees[deployed[salt(_linkdropMaster, _campaignId)]];
951 
952         return ILinkdropERC20(deployed[salt(_linkdropMaster, _campaignId)]).checkClaimParams
953         (
954             _weiAmount,
955             _tokenAddress,
956             _tokenAmount,
957             _expiration,
958             _linkId,
959             _linkdropSignerSignature,
960             _receiver,
961             _receiverSignature,
962             fee
963         );
964     }
965 
966     /**
967     * @dev Function to claim ETH and/or ERC20 tokens
968     * @param _weiAmount Amount of wei to be claimed
969     * @param _tokenAddress Token address
970     * @param _tokenAmount Amount of tokens to be claimed (in atomic value)
971     * @param _expiration Unix timestamp of link expiration time
972     * @param _linkId Address corresponding to link key
973     * @param _linkdropMaster Address corresponding to linkdrop master key
974     * @param _campaignId Campaign id
975     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
976     * @param _receiver Address of linkdrop receiver
977     * @param _receiverSignature ECDSA signature of linkdrop receiver
978     * @return True if success
979     */
980     function claim
981     (
982         uint _weiAmount,
983         address _tokenAddress,
984         uint _tokenAmount,
985         uint _expiration,
986         address _linkId,
987         address payable _linkdropMaster,
988         uint _campaignId,
989         bytes calldata _linkdropSignerSignature,
990         address payable _receiver,
991         bytes calldata _receiverSignature
992     )
993     external
994     returns (bool)
995     {
996         // Make sure proxy contract is deployed
997         require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
998 
999         // Make sure only whitelisted relayer calls this function
1000         require(isRelayer[msg.sender], "ONLY_RELAYER");
1001 
1002         uint fee = fees[deployed[salt(_linkdropMaster, _campaignId)]];
1003 
1004         // Call claim function in the context of proxy contract
1005         ILinkdropERC20(deployed[salt(_linkdropMaster, _campaignId)]).claim
1006         (
1007             _weiAmount,
1008             _tokenAddress,
1009             _tokenAmount,
1010             _expiration,
1011             _linkId,
1012             _linkdropSignerSignature,
1013             _receiver,
1014             _receiverSignature,
1015             msg.sender, // Fee receiver
1016             fee
1017         );
1018 
1019         return true;
1020     }
1021 
1022 }
1023 
1024 
1025 
1026 
1027 contract LinkdropFactoryERC721 is ILinkdropFactoryERC721, LinkdropFactoryCommon {
1028 
1029     /**
1030     * @dev Function to verify claim params, make sure the link is not claimed or canceled and proxy is allowed to spend token
1031     * @param _weiAmount Amount of wei to be claimed
1032     * @param _nftAddress NFT address
1033     * @param _tokenId Token id to be claimed
1034     * @param _expiration Unix timestamp of link expiration time
1035     * @param _linkId Address corresponding to link key
1036     * @param _linkdropMaster Address corresponding to linkdrop master key
1037     * @param _campaignId Campaign id
1038     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
1039     * @param _receiver Address of linkdrop receiver
1040     * @param _receiverSignature ECDSA signature of linkdrop receiver
1041     * @return True if success
1042     */
1043     function checkClaimParamsERC721
1044     (
1045         uint _weiAmount,
1046         address _nftAddress,
1047         uint _tokenId,
1048         uint _expiration,
1049         address _linkId,
1050         address payable _linkdropMaster,
1051         uint _campaignId,
1052         bytes memory _linkdropSignerSignature,
1053         address _receiver,
1054         bytes memory _receiverSignature
1055     )
1056     public view
1057     returns (bool)
1058     {
1059         // Make sure proxy contract is deployed
1060         require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
1061 
1062         uint fee = fees[deployed[salt(_linkdropMaster, _campaignId)]];
1063 
1064         return ILinkdropERC721(deployed[salt(_linkdropMaster, _campaignId)]).checkClaimParamsERC721
1065         (
1066             _weiAmount,
1067             _nftAddress,
1068             _tokenId,
1069             _expiration,
1070             _linkId,
1071             _linkdropSignerSignature,
1072             _receiver,
1073             _receiverSignature,
1074             fee
1075         );
1076     }
1077 
1078     /**
1079     * @dev Function to claim ETH and/or ERC721 token
1080     * @param _weiAmount Amount of wei to be claimed
1081     * @param _nftAddress NFT address
1082     * @param _tokenId Token id to be claimed
1083     * @param _expiration Unix timestamp of link expiration time
1084     * @param _linkId Address corresponding to link key
1085     * @param _linkdropMaster Address corresponding to linkdrop master key
1086     * @param _campaignId Campaign id
1087     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
1088     * @param _receiver Address of linkdrop receiver
1089     * @param _receiverSignature ECDSA signature of linkdrop receiver
1090     * @return True if success
1091     */
1092     function claimERC721
1093     (
1094         uint _weiAmount,
1095         address _nftAddress,
1096         uint _tokenId,
1097         uint _expiration,
1098         address _linkId,
1099         address payable _linkdropMaster,
1100         uint _campaignId,
1101         bytes calldata _linkdropSignerSignature,
1102         address payable _receiver,
1103         bytes calldata _receiverSignature
1104     )
1105     external
1106     returns (bool)
1107     {
1108         // Make sure proxy contract is deployed
1109         require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
1110 
1111         // Make sure only whitelisted relayer calls this function
1112         require(isRelayer[msg.sender], "ONLY_RELAYER");
1113 
1114         uint fee = fees[deployed[salt(_linkdropMaster, _campaignId)]];
1115 
1116         // Call claim function in the context of proxy contract
1117         ILinkdropERC721(deployed[salt(_linkdropMaster, _campaignId)]).claimERC721
1118         (
1119             _weiAmount,
1120             _nftAddress,
1121             _tokenId,
1122             _expiration,
1123             _linkId,
1124             _linkdropSignerSignature,
1125             _receiver,
1126             _receiverSignature,
1127             msg.sender, // Fee receiver
1128             fee
1129         );
1130 
1131         return true;
1132     }
1133 
1134 }
1135 
1136 
1137 contract LinkdropFactory is LinkdropFactoryERC20, LinkdropFactoryERC721 {
1138 
1139     /**
1140     * @dev Constructor that sets bootstap initcode, factory owner, chainId and master copy
1141     * @param _masterCopy Linkdrop mastercopy contract address to calculate bytecode from
1142     * @param _chainId Chain id
1143     */
1144     constructor(address payable _masterCopy, uint _chainId) public {
1145         _initcode = (hex"6352c7420d6000526103ff60206004601c335afa6040516060f3");
1146         chainId = _chainId;
1147         setMasterCopy(_masterCopy);
1148     }
1149 
1150 }