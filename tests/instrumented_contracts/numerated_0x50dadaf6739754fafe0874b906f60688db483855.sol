1 // SPDX-License-Identifier: GPL-3.0
2 // pragma solidity >=0.6.0 <0.8.0;
3 
4 interface ILinkdropERC20 {
5 
6     function verifyLinkdropSignerSignature
7     (
8         uint _weiAmount,
9         address _tokenAddress,
10         uint _tokenAmount,
11         uint _expiration,
12         address _linkId,
13         bytes calldata _signature
14     )
15     external view returns (bool);
16 
17     function checkClaimParams
18     (
19         uint _weiAmount,
20         address _tokenAddress,
21         uint _tokenAmount,
22         uint _expiration,
23         address _linkId,
24         bytes calldata _linkdropSignerSignature,
25         address _receiver,
26         bytes calldata _receiverSignature
27     )
28     external view returns (bool);
29 
30     function claim
31     (
32         uint _weiAmount,
33         address _tokenAddress,
34         uint _tokenAmount,
35         uint _expiration,
36         address _linkId,
37         bytes calldata _linkdropSignerSignature,
38         address payable _receiver,
39         bytes calldata _receiverSignature
40     )
41       external payable returns (bool);
42 }
43 
44 
45 // Dependency file: contracts/interfaces/ILinkdropFactoryERC20.sol
46 
47 // pragma solidity >=0.6.0 <0.8.0;
48 
49 interface ILinkdropFactoryERC20 {
50 
51     function checkClaimParams
52     (
53         uint _weiAmount,
54         address _tokenAddress,
55         uint _tokenAmount,
56         uint _expiration,
57         address _linkId,
58         address payable _linkdropMaster,
59         uint _campaignId,
60         bytes calldata _linkdropSignerSignature,
61         address _receiver,
62         bytes calldata _receiverSignature
63     )
64     external view
65     returns (bool);
66 
67     function claim
68     (
69         uint _weiAmount,
70         address _tokenAddress,
71         uint _tokenAmount,
72         uint _expiration,
73         address _linkId,
74         address payable _linkdropMaster,
75         uint _campaignId,
76         bytes calldata _linkdropSignerSignature,
77         address payable _receiver,
78         bytes calldata _receiverSignature
79     )
80     external
81     returns (bool);
82 }
83 
84 
85 // Dependency file: openzeppelin-solidity/contracts/utils/Context.sol
86 
87 
88 // pragma solidity >=0.6.0 <0.8.0;
89 
90 /*
91  * @dev Provides information about the current execution context, including the
92  * sender of the transaction and its data. While these are generally available
93  * via msg.sender and msg.data, they should not be accessed in such a direct
94  * manner, since when dealing with GSN meta-transactions the account sending and
95  * paying for execution may not be the actual sender (as far as an application
96  * is concerned).
97  *
98  * This contract is only required for intermediate, library-like contracts.
99  */
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address payable) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes memory) {
106         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
107         return msg.data;
108     }
109 }
110 
111 
112 // Dependency file: openzeppelin-solidity/contracts/access/Ownable.sol
113 
114 
115 // pragma solidity >=0.6.0 <0.8.0;
116 
117 // import "openzeppelin-solidity/contracts/utils/Context.sol";
118 /**
119  * @dev Contract module which provides a basic access control mechanism, where
120  * there is an account (an owner) that can be granted exclusive access to
121  * specific functions.
122  *
123  * By default, the owner account will be the one that deploys the contract. This
124  * can later be changed with {transferOwnership}.
125  *
126  * This module is used through inheritance. It will make available the modifier
127  * `onlyOwner`, which can be applied to your functions to restrict their use to
128  * the owner.
129  */
130 abstract contract Ownable is Context {
131     address private _owner;
132 
133     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
134 
135     /**
136      * @dev Initializes the contract setting the deployer as the initial owner.
137      */
138     constructor () internal {
139         address msgSender = _msgSender();
140         _owner = msgSender;
141         emit OwnershipTransferred(address(0), msgSender);
142     }
143 
144     /**
145      * @dev Returns the address of the current owner.
146      */
147     function owner() public view virtual returns (address) {
148         return _owner;
149     }
150 
151     /**
152      * @dev Throws if called by any account other than the owner.
153      */
154     modifier onlyOwner() {
155         require(owner() == _msgSender(), "Ownable: caller is not the owner");
156         _;
157     }
158 
159     /**
160      * @dev Leaves the contract without owner. It will not be possible to call
161      * `onlyOwner` functions anymore. Can only be called by the current owner.
162      *
163      * NOTE: Renouncing ownership will leave the contract without an owner,
164      * thereby removing any functionality that is only available to the owner.
165      */
166     function renounceOwnership() public virtual onlyOwner {
167         emit OwnershipTransferred(_owner, address(0));
168         _owner = address(0);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         emit OwnershipTransferred(_owner, newOwner);
178         _owner = newOwner;
179     }
180 }
181 
182 
183 // Dependency file: contracts/interfaces/IFeeManager.sol
184 
185 // pragma solidity >=0.6.0 <0.8.0;
186 
187 interface IFeeManager {
188   function isWhitelisted(address _addr) external view returns (bool);
189   function whitelist(address _addr) external returns (bool);
190   function cancelWhitelist(address _addr) external returns (bool);
191   function changeFeeReceiver(address payable _addr) external returns (bool);
192   function updateFee(uint _fee) external returns (bool);
193   function updateClaimerFee(uint _claimerFee) external returns (bool);  
194   function withdraw() external returns (bool);
195   function calculateFee(
196                         address _linkdropMaster,
197                         address _tokenAddress,
198                         address _receiver) external view returns (uint);
199   function feeReceiver() external view returns (address payable); 
200 }
201 
202 
203 // Dependency file: contracts/storage/LinkdropFactoryStorage.sol
204 
205 // pragma solidity >=0.6.0 <0.8.0;
206 // import "openzeppelin-solidity/contracts/access/Ownable.sol";
207 // import "contracts/interfaces/IFeeManager.sol";
208 
209 contract LinkdropFactoryStorage is Ownable {
210 
211     // Current version of mastercopy contract
212     uint public masterCopyVersion;
213 
214     // Contract bytecode to be installed when deploying proxy
215     bytes internal _bytecode;
216 
217     // Bootstrap initcode to fetch the actual contract bytecode. Used to generate repeatable contract addresses
218     bytes internal _initcode;
219 
220     // Network id
221     uint public chainId;
222 
223     // Maps hash(sender address, campaign id) to its corresponding proxy address
224     mapping (bytes32 => address) public deployed;
225         
226     // Events
227     event Deployed(address payable indexed owner, uint campaignId, address payable proxy, bytes32 salt);
228     event Destroyed(address payable owner, address payable proxy);
229     event SetMasterCopy(address masterCopy, uint version);
230 
231 }
232 
233 
234 // Dependency file: contracts/interfaces/ILinkdropCommon.sol
235 
236 // pragma solidity >=0.6.0 <0.8.0;
237 
238 interface ILinkdropCommon {
239 
240     function initialize
241     (
242         address _owner,
243         address payable _linkdropMaster,
244         uint _version,
245         uint _chainId,
246         uint _claimPattern
247     )
248     external returns (bool);
249 
250     function isClaimedLink(address _linkId) external view returns (bool);
251     function isCanceledLink(address _linkId) external view returns (bool);
252     function paused() external view returns (bool);
253     function cancel(address _linkId) external  returns (bool);
254     function withdraw() external returns (bool);
255     function pause() external returns (bool);
256     function unpause() external returns (bool);
257     function addSigner(address _linkdropSigner) external payable returns (bool);
258     function removeSigner(address _linkdropSigner) external returns (bool);
259     function destroy() external;
260     function getLinkdropMaster() external view returns (address);
261     function getMasterCopyVersion() external view returns (uint);
262     function verifyReceiverSignature( address _linkId,
263                                       address _receiver,
264                                       bytes calldata _signature
265                                       )  external view returns (bool);
266     receive() external payable;
267 
268 }
269 
270 
271 // Dependency file: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
272 
273 
274 // pragma solidity >=0.6.0 <0.8.0;
275 
276 /**
277  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
278  *
279  * These functions can be used to verify that a message was signed by the holder
280  * of the private keys of a given address.
281  */
282 library ECDSA {
283     /**
284      * @dev Returns the address that signed a hashed message (`hash`) with
285      * `signature`. This address can then be used for verification purposes.
286      *
287      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
288      * this function rejects them by requiring the `s` value to be in the lower
289      * half order, and the `v` value to be either 27 or 28.
290      *
291      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
292      * verification to be secure: it is possible to craft signatures that
293      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
294      * this is by receiving a hash of the original message (which may otherwise
295      * be too long), and then calling {toEthSignedMessageHash} on it.
296      */
297     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
298         // Check the signature length
299         if (signature.length != 65) {
300             revert("ECDSA: invalid signature length");
301         }
302 
303         // Divide the signature in r, s and v variables
304         bytes32 r;
305         bytes32 s;
306         uint8 v;
307 
308         // ecrecover takes the signature parameters, and the only way to get them
309         // currently is to use assembly.
310         // solhint-disable-next-line no-inline-assembly
311         assembly {
312             r := mload(add(signature, 0x20))
313             s := mload(add(signature, 0x40))
314             v := byte(0, mload(add(signature, 0x60)))
315         }
316 
317         return recover(hash, v, r, s);
318     }
319 
320     /**
321      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
322      * `r` and `s` signature fields separately.
323      */
324     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
325         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
326         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
327         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
328         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
329         //
330         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
331         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
332         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
333         // these malleable signatures as well.
334         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
335         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
336 
337         // If the signature is valid (and not malleable), return the signer address
338         address signer = ecrecover(hash, v, r, s);
339         require(signer != address(0), "ECDSA: invalid signature");
340 
341         return signer;
342     }
343 
344     /**
345      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
346      * replicates the behavior of the
347      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
348      * JSON-RPC method.
349      *
350      * See {recover}.
351      */
352     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
353         // 32 is the length in bytes of hash,
354         // enforced by the type signature above
355         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
356     }
357 }
358 
359 
360 // Dependency file: openzeppelin-solidity/contracts/math/SafeMath.sol
361 
362 
363 // pragma solidity >=0.6.0 <0.8.0;
364 
365 /**
366  * @dev Wrappers over Solidity's arithmetic operations with added overflow
367  * checks.
368  *
369  * Arithmetic operations in Solidity wrap on overflow. This can easily result
370  * in bugs, because programmers usually assume that an overflow raises an
371  * error, which is the standard behavior in high level programming languages.
372  * `SafeMath` restores this intuition by reverting the transaction when an
373  * operation overflows.
374  *
375  * Using this library instead of the unchecked operations eliminates an entire
376  * class of bugs, so it's recommended to use it always.
377  */
378 library SafeMath {
379     /**
380      * @dev Returns the addition of two unsigned integers, with an overflow flag.
381      *
382      * _Available since v3.4._
383      */
384     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
385         uint256 c = a + b;
386         if (c < a) return (false, 0);
387         return (true, c);
388     }
389 
390     /**
391      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
392      *
393      * _Available since v3.4._
394      */
395     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
396         if (b > a) return (false, 0);
397         return (true, a - b);
398     }
399 
400     /**
401      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
402      *
403      * _Available since v3.4._
404      */
405     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
406         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
407         // benefit is lost if 'b' is also tested.
408         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
409         if (a == 0) return (true, 0);
410         uint256 c = a * b;
411         if (c / a != b) return (false, 0);
412         return (true, c);
413     }
414 
415     /**
416      * @dev Returns the division of two unsigned integers, with a division by zero flag.
417      *
418      * _Available since v3.4._
419      */
420     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
421         if (b == 0) return (false, 0);
422         return (true, a / b);
423     }
424 
425     /**
426      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
427      *
428      * _Available since v3.4._
429      */
430     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
431         if (b == 0) return (false, 0);
432         return (true, a % b);
433     }
434 
435     /**
436      * @dev Returns the addition of two unsigned integers, reverting on
437      * overflow.
438      *
439      * Counterpart to Solidity's `+` operator.
440      *
441      * Requirements:
442      *
443      * - Addition cannot overflow.
444      */
445     function add(uint256 a, uint256 b) internal pure returns (uint256) {
446         uint256 c = a + b;
447         require(c >= a, "SafeMath: addition overflow");
448         return c;
449     }
450 
451     /**
452      * @dev Returns the subtraction of two unsigned integers, reverting on
453      * overflow (when the result is negative).
454      *
455      * Counterpart to Solidity's `-` operator.
456      *
457      * Requirements:
458      *
459      * - Subtraction cannot overflow.
460      */
461     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
462         require(b <= a, "SafeMath: subtraction overflow");
463         return a - b;
464     }
465 
466     /**
467      * @dev Returns the multiplication of two unsigned integers, reverting on
468      * overflow.
469      *
470      * Counterpart to Solidity's `*` operator.
471      *
472      * Requirements:
473      *
474      * - Multiplication cannot overflow.
475      */
476     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
477         if (a == 0) return 0;
478         uint256 c = a * b;
479         require(c / a == b, "SafeMath: multiplication overflow");
480         return c;
481     }
482 
483     /**
484      * @dev Returns the integer division of two unsigned integers, reverting on
485      * division by zero. The result is rounded towards zero.
486      *
487      * Counterpart to Solidity's `/` operator. Note: this function uses a
488      * `revert` opcode (which leaves remaining gas untouched) while Solidity
489      * uses an invalid opcode to revert (consuming all remaining gas).
490      *
491      * Requirements:
492      *
493      * - The divisor cannot be zero.
494      */
495     function div(uint256 a, uint256 b) internal pure returns (uint256) {
496         require(b > 0, "SafeMath: division by zero");
497         return a / b;
498     }
499 
500     /**
501      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
502      * reverting when dividing by zero.
503      *
504      * Counterpart to Solidity's `%` operator. This function uses a `revert`
505      * opcode (which leaves remaining gas untouched) while Solidity uses an
506      * invalid opcode to revert (consuming all remaining gas).
507      *
508      * Requirements:
509      *
510      * - The divisor cannot be zero.
511      */
512     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
513         require(b > 0, "SafeMath: modulo by zero");
514         return a % b;
515     }
516 
517     /**
518      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
519      * overflow (when the result is negative).
520      *
521      * CAUTION: This function is deprecated because it requires allocating memory for the error
522      * message unnecessarily. For custom revert reasons use {trySub}.
523      *
524      * Counterpart to Solidity's `-` operator.
525      *
526      * Requirements:
527      *
528      * - Subtraction cannot overflow.
529      */
530     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
531         require(b <= a, errorMessage);
532         return a - b;
533     }
534 
535     /**
536      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
537      * division by zero. The result is rounded towards zero.
538      *
539      * CAUTION: This function is deprecated because it requires allocating memory for the error
540      * message unnecessarily. For custom revert reasons use {tryDiv}.
541      *
542      * Counterpart to Solidity's `/` operator. Note: this function uses a
543      * `revert` opcode (which leaves remaining gas untouched) while Solidity
544      * uses an invalid opcode to revert (consuming all remaining gas).
545      *
546      * Requirements:
547      *
548      * - The divisor cannot be zero.
549      */
550     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
551         require(b > 0, errorMessage);
552         return a / b;
553     }
554 
555     /**
556      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
557      * reverting with custom message when dividing by zero.
558      *
559      * CAUTION: This function is deprecated because it requires allocating memory for the error
560      * message unnecessarily. For custom revert reasons use {tryMod}.
561      *
562      * Counterpart to Solidity's `%` operator. This function uses a `revert`
563      * opcode (which leaves remaining gas untouched) while Solidity uses an
564      * invalid opcode to revert (consuming all remaining gas).
565      *
566      * Requirements:
567      *
568      * - The divisor cannot be zero.
569      */
570     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
571         require(b > 0, errorMessage);
572         return a % b;
573     }
574 }
575 
576 
577 // Dependency file: contracts/factory/LinkdropFactoryCommon.sol
578 
579 // pragma solidity >=0.6.0 <0.8.0;
580 
581 // import "contracts/storage/LinkdropFactoryStorage.sol";
582 // import "contracts/interfaces/ILinkdropCommon.sol";
583 // import "openzeppelin-solidity/contracts/cryptography/ECDSA.sol";
584 // import "openzeppelin-solidity/contracts/math/SafeMath.sol";
585 
586 contract LinkdropFactoryCommon is LinkdropFactoryStorage {
587     using SafeMath for uint;
588 
589     /**
590     * @dev Indicates whether a proxy contract for linkdrop master is deployed or not
591     * @param _linkdropMaster Address of linkdrop master
592     * @param _campaignId Campaign id
593     * @return True if deployed
594     */
595     function isDeployed(address _linkdropMaster, uint _campaignId) public view returns (bool) {
596         return (deployed[salt(_linkdropMaster, _campaignId)] != address(0));
597     }
598 
599     /**
600     * @dev Indicates whether a link is claimed or not
601     * @param _linkdropMaster Address of lindkrop master
602     * @param _campaignId Campaign id
603     * @param _linkId Address corresponding to link key
604     * @return True if claimed
605     */
606     function isClaimedLink(address payable _linkdropMaster, uint _campaignId, address _linkId) public view returns (bool) {
607 
608         if (!isDeployed(_linkdropMaster, _campaignId)) {
609             return false;
610         }
611         else {
612             address payable proxy = address(uint160(deployed[salt(_linkdropMaster, _campaignId)]));
613             return ILinkdropCommon(proxy).isClaimedLink(_linkId);
614         }
615     }
616 
617 
618     /**
619     * @dev Function to deploy a proxy contract for msg.sender
620     * @param _campaignId Campaign id
621     * @param _claimPattern which pattern the campaign will use (mint on claim, transfer pre-minted tokens, etc)
622     * @return proxy Proxy contract address
623     */
624     function deployProxy(uint _campaignId, uint _claimPattern)
625     public
626     payable
627     returns (address payable proxy)
628     {
629       proxy = _deployProxy(msg.sender, _campaignId, _claimPattern);
630     }
631 
632     /**
633     * @dev Function to deploy a proxy contract for msg.sender and add a new signing key
634     * @param _campaignId Campaign id
635     * @param _signer Address corresponding to signing key
636     * @param _claimPattern which pattern the campaign will use (mint on claim, transfer pre-minted tokens, etc)
637     * @return proxy Proxy contract address
638     */
639     function deployProxyWithSigner(uint _campaignId, address _signer, uint _claimPattern)
640     public
641     payable
642     returns (address payable proxy)
643     {
644         proxy = _deployProxy(msg.sender, _campaignId, _claimPattern);
645         ILinkdropCommon(proxy).addSigner(_signer);
646     }
647 
648     /**
649     * @dev Internal function to deploy a proxy contract for linkdrop master
650     * @param _linkdropMaster Address of linkdrop master
651     * @param _campaignId Campaign id
652     * @param _claimPattern which pattern the campaign will use (mint on claim, transfer pre-minted tokens, etc)
653     * @return proxy Proxy contract address
654     */
655     function _deployProxy(address payable _linkdropMaster, uint _campaignId, uint _claimPattern)
656     internal
657     returns (address payable proxy)
658     {
659 
660         require(!isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_ALREADY_DEPLOYED");
661         require(_linkdropMaster != address(0), "INVALID_LINKDROP_MASTER_ADDRESS");
662 
663         bytes32 salt = salt(_linkdropMaster, _campaignId);
664         bytes memory initcode = getInitcode();
665 
666         assembly {
667             proxy := create2(0, add(initcode, 0x20), mload(initcode), salt)
668             if iszero(extcodesize(proxy)) { revert(0, 0) }
669         }
670 
671         deployed[salt] = proxy;
672 
673         // Initialize factory address, linkdrop master address master copy version in proxy contract
674         require
675         (
676             ILinkdropCommon(proxy).initialize
677             (
678                 address(this), // factory address
679                 _linkdropMaster, // Linkdrop master address
680                 masterCopyVersion,
681                 chainId,
682                 _claimPattern
683             ),
684             "INITIALIZATION_FAILED"
685         );
686 
687         // Send funds attached to proxy contract
688         proxy.transfer(msg.value);
689 
690         emit Deployed(_linkdropMaster, _campaignId, proxy, salt);
691         return proxy;
692     }
693 
694     /**
695     * @dev Function to destroy proxy contract, called by proxy owner
696     * @param _campaignId Campaign id
697     * @return True if destroyed successfully
698     */
699     function destroyProxy(uint _campaignId)
700     public
701     returns (bool)
702     {
703         require(isDeployed(msg.sender, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
704         address payable proxy = address(uint160(deployed[salt(msg.sender, _campaignId)]));
705         require(msg.sender == ILinkdropCommon(proxy).getLinkdropMaster(), "NOT_AUTHORIZED");
706         ILinkdropCommon(proxy).destroy();
707         delete deployed[salt(msg.sender, _campaignId)];
708         emit Destroyed(msg.sender, proxy);
709         return true;
710     }
711 
712     /**
713     * @dev Function to get bootstrap initcode for generating repeatable contract addresses
714     * @return Static bootstrap initcode
715     */
716     function getInitcode()
717     public view
718     returns (bytes memory)
719     {
720         return _initcode;
721     }
722 
723     /**
724     * @dev Function to fetch the actual contract bytecode to install. Called by proxy when executing initcode
725     * @return Contract bytecode to install
726     */
727     function getBytecode()
728     public view
729     returns (bytes memory)
730     {
731         return _bytecode;
732     }
733 
734     /**
735     * @dev Function to set new master copy and update contract bytecode to install. Can only be called by factory owner
736     * @param _masterCopy Address of linkdrop mastercopy contract to calculate bytecode from
737     * @return True if updated successfully
738     */
739     function setMasterCopy(address payable _masterCopy)
740     public onlyOwner
741     returns (bool)
742     {
743         require(_masterCopy != address(0), "INVALID_MASTER_COPY_ADDRESS");
744         masterCopyVersion = masterCopyVersion.add(1);
745 
746         require
747         (
748             ILinkdropCommon(_masterCopy).initialize
749             (
750                 address(0), // Owner address
751                 address(0), // Linkdrop master address
752                 masterCopyVersion,
753                 chainId,
754                 uint(0) // transfer pattern (mint tokens on claim or transfer pre-minted tokens) 
755             ),
756             "INITIALIZATION_FAILED"
757         );
758 
759         bytes memory bytecode = abi.encodePacked
760         (
761             hex"363d3d373d3d3d363d73",
762             _masterCopy,
763             hex"5af43d82803e903d91602b57fd5bf3"
764         );
765 
766         _bytecode = bytecode;
767 
768         emit SetMasterCopy(_masterCopy, masterCopyVersion);
769         return true;
770     }
771 
772     /**
773     * @dev Function to fetch the master copy version installed (or to be installed) to proxy
774     * @param _linkdropMaster Address of linkdrop master
775     * @param _campaignId Campaign id
776     * @return Master copy version
777     */
778     function getProxyMasterCopyVersion(address _linkdropMaster, uint _campaignId) external view returns (uint) {
779 
780         if (!isDeployed(_linkdropMaster, _campaignId)) {
781             return masterCopyVersion;
782         }
783         else {
784             address payable proxy = address(uint160(deployed[salt(_linkdropMaster, _campaignId)]));
785             return ILinkdropCommon(proxy).getMasterCopyVersion();
786         }
787     }
788 
789     /**
790      * @dev Function to hash `_linkdropMaster` and `_campaignId` params. Used as salt when deploying with create2
791      * @param _linkdropMaster Address of linkdrop master
792      * @param _campaignId Campaign id
793      * @return Hash of passed arguments
794      */
795     function salt(address _linkdropMaster, uint _campaignId) public pure returns (bytes32) {
796         return keccak256(abi.encodePacked(_linkdropMaster, _campaignId));
797     }
798   }
799 
800 
801 // Dependency file: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
802 
803 
804 // pragma solidity >=0.6.0 <0.8.0;
805 
806 /**
807  * @dev Interface of the ERC20 standard as defined in the EIP.
808  */
809 interface IERC20 {
810     /**
811      * @dev Returns the amount of tokens in existence.
812      */
813     function totalSupply() external view returns (uint256);
814 
815     /**
816      * @dev Returns the amount of tokens owned by `account`.
817      */
818     function balanceOf(address account) external view returns (uint256);
819 
820     /**
821      * @dev Moves `amount` tokens from the caller's account to `recipient`.
822      *
823      * Returns a boolean value indicating whether the operation succeeded.
824      *
825      * Emits a {Transfer} event.
826      */
827     function transfer(address recipient, uint256 amount) external returns (bool);
828 
829     /**
830      * @dev Returns the remaining number of tokens that `spender` will be
831      * allowed to spend on behalf of `owner` through {transferFrom}. This is
832      * zero by default.
833      *
834      * This value changes when {approve} or {transferFrom} are called.
835      */
836     function allowance(address owner, address spender) external view returns (uint256);
837 
838     /**
839      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
840      *
841      * Returns a boolean value indicating whether the operation succeeded.
842      *
843      * IMPORTANT: Beware that changing an allowance with this method brings the risk
844      * that someone may use both the old and the new allowance by unfortunate
845      * transaction ordering. One possible solution to mitigate this race
846      * condition is to first reduce the spender's allowance to 0 and set the
847      * desired value afterwards:
848      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
849      *
850      * Emits an {Approval} event.
851      */
852     function approve(address spender, uint256 amount) external returns (bool);
853 
854     /**
855      * @dev Moves `amount` tokens from `sender` to `recipient` using the
856      * allowance mechanism. `amount` is then deducted from the caller's
857      * allowance.
858      *
859      * Returns a boolean value indicating whether the operation succeeded.
860      *
861      * Emits a {Transfer} event.
862      */
863     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
864 
865     /**
866      * @dev Emitted when `value` tokens are moved from one account (`from`) to
867      * another (`to`).
868      *
869      * Note that `value` may be zero.
870      */
871     event Transfer(address indexed from, address indexed to, uint256 value);
872 
873     /**
874      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
875      * a call to {approve}. `value` is the new allowance.
876      */
877     event Approval(address indexed owner, address indexed spender, uint256 value);
878 }
879 
880 
881 // Dependency file: contracts/factory/LinkdropFactoryERC20.sol
882 
883 // pragma solidity >=0.6.0 <0.8.0;
884 
885 // import "contracts/interfaces/ILinkdropERC20.sol";
886 // import "contracts/interfaces/ILinkdropFactoryERC20.sol";
887 // import "contracts/factory/LinkdropFactoryCommon.sol";
888 // import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
889 
890 contract LinkdropFactoryERC20 is ILinkdropFactoryERC20, LinkdropFactoryCommon {
891 
892     /**
893     * @dev Function to verify claim params, make sure the link is not claimed or canceled and proxy has sufficient balance
894     * @param _weiAmount Amount of wei to be claimed
895     * @param _tokenAddress Token address
896     * @param _tokenAmount Amount of tokens to be claimed (in atomic value)
897     * @param _expiration Unix timestamp of link expiration time
898     * @param _linkId Address corresponding to link key
899     * @param _linkdropMaster Address corresponding to linkdrop master key
900     * @param _campaignId Campaign id
901     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
902     * @param _receiver Address of linkdrop receiver
903     * @param _receiverSignature ECDSA signature of linkdrop receiver
904     * @return True if success
905     */
906     function checkClaimParams
907     (
908         uint _weiAmount,
909         address _tokenAddress,
910         uint _tokenAmount,
911         uint _expiration,
912         address _linkId,
913         address payable _linkdropMaster,
914         uint _campaignId,
915         bytes memory _linkdropSignerSignature,
916         address _receiver,
917         bytes memory _receiverSignature
918     )
919     public
920     override      
921     view
922     returns (bool)
923     {
924         // Make sure proxy contract is deployed
925         require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
926 
927         return ILinkdropERC20(deployed[salt(_linkdropMaster, _campaignId)]).checkClaimParams
928         (
929             _weiAmount,
930             _tokenAddress,
931             _tokenAmount,
932             _expiration,
933             _linkId,
934             _linkdropSignerSignature,
935             _receiver,
936             _receiverSignature
937         );
938     }
939 
940     /**
941     * @dev Function to claim ETH and/or ERC20 tokens
942     * @param _weiAmount Amount of wei to be claimed
943     * @param _tokenAddress Token address
944     * @param _tokenAmount Amount of tokens to be claimed (in atomic value)
945     * @param _expiration Unix timestamp of link expiration time
946     * @param _linkId Address corresponding to link key
947     * @param _linkdropMaster Address corresponding to linkdrop master key
948     * @param _campaignId Campaign id
949     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
950     * @param _receiver Address of linkdrop receiver
951     * @param _receiverSignature ECDSA signature of linkdrop receiver
952     * @return True if success
953     */
954     function claim
955     (
956         uint _weiAmount,
957         address _tokenAddress,
958         uint _tokenAmount,
959         uint _expiration,
960         address _linkId,
961         address payable _linkdropMaster,
962         uint _campaignId,
963         bytes calldata _linkdropSignerSignature,
964         address payable _receiver,
965         bytes calldata _receiverSignature
966     )
967     external
968     override
969     returns (bool)
970     {
971         // Make sure proxy contract is deployed
972         require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
973 
974         // Call claim function in the context of proxy contract
975         ILinkdropERC20(deployed[salt(_linkdropMaster, _campaignId)]).claim
976           (
977            _weiAmount,
978            _tokenAddress,
979            _tokenAmount,
980            _expiration,
981             _linkId,
982            _linkdropSignerSignature,
983            _receiver,
984            _receiverSignature
985            );
986           
987           return true;
988     }   
989 }
990 
991 
992 // Dependency file: contracts/interfaces/ILinkdropERC721.sol
993 
994 // pragma solidity >=0.6.0 <0.8.0;
995 
996 interface ILinkdropERC721 {
997 
998     function verifyLinkdropSignerSignatureERC721
999     (
1000         uint _weiAmount,
1001         address _nftAddress,
1002         uint _tokenId,
1003         uint _expiration,
1004         address _linkId,
1005         bytes calldata _signature
1006     )
1007     external view returns (bool);
1008 
1009     function verifyReceiverSignatureERC721
1010     (
1011         address _linkId,
1012 	    address _receiver,
1013 		bytes calldata _signature
1014     )
1015     external view returns (bool);
1016 
1017     function checkClaimParamsERC721
1018     (
1019         uint _weiAmount,
1020         address _nftAddress,
1021         uint _tokenId,
1022         uint _expiration,
1023         address _linkId,
1024         bytes calldata _linkdropSignerSignature,
1025         address _receiver,
1026         bytes calldata _receiverSignature
1027     )
1028     external view returns (bool);
1029 
1030     function claimERC721
1031     (
1032         uint _weiAmount,
1033         address _nftAddress,
1034         uint _tokenId,
1035         uint _expiration,
1036         address _linkId,
1037         bytes calldata _linkdropSignerSignature,
1038         address payable _receiver,
1039         bytes calldata _receiverSignature
1040     )
1041       external
1042       payable
1043       returns (bool);
1044 
1045 }
1046 
1047 
1048 // Dependency file: contracts/interfaces/ILinkdropFactoryERC721.sol
1049 
1050 // pragma solidity >=0.6.0 <0.8.0;
1051 
1052 interface ILinkdropFactoryERC721 {
1053 
1054     function checkClaimParamsERC721
1055     (
1056         uint _weiAmount,
1057         address _nftAddress,
1058         uint _tokenId,
1059         uint _expiration,
1060         address _linkId,
1061         address payable _linkdropMaster,
1062         uint _campaignId,
1063         bytes calldata _linkdropSignerSignature,
1064         address _receiver,
1065         bytes calldata _receiverSignature
1066     )
1067     external view
1068     returns (bool);
1069 
1070     function claimERC721
1071     (
1072         uint _weiAmount,
1073         address _nftAddress,
1074         uint _tokenId,
1075         uint _expiration,
1076         address _linkId,
1077         address payable _linkdropMaster,
1078         uint _campaignId,
1079         bytes calldata _linkdropSignerSignature,
1080         address payable _receiver,
1081         bytes calldata _receiverSignature
1082     )
1083     external
1084     returns (bool);
1085 }
1086 
1087 
1088 // Dependency file: openzeppelin-solidity/contracts/introspection/IERC165.sol
1089 
1090 
1091 // pragma solidity >=0.6.0 <0.8.0;
1092 
1093 /**
1094  * @dev Interface of the ERC165 standard, as defined in the
1095  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1096  *
1097  * Implementers can declare support of contract interfaces, which can then be
1098  * queried by others ({ERC165Checker}).
1099  *
1100  * For an implementation, see {ERC165}.
1101  */
1102 interface IERC165 {
1103     /**
1104      * @dev Returns true if this contract implements the interface defined by
1105      * `interfaceId`. See the corresponding
1106      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1107      * to learn more about how these ids are created.
1108      *
1109      * This function call must use less than 30 000 gas.
1110      */
1111     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1112 }
1113 
1114 
1115 // Dependency file: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
1116 
1117 
1118 // pragma solidity >=0.6.2 <0.8.0;
1119 
1120 // import "openzeppelin-solidity/contracts/introspection/IERC165.sol";
1121 
1122 /**
1123  * @dev Required interface of an ERC721 compliant contract.
1124  */
1125 interface IERC721 is IERC165 {
1126     /**
1127      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1128      */
1129     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1130 
1131     /**
1132      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1133      */
1134     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1135 
1136     /**
1137      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1138      */
1139     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1140 
1141     /**
1142      * @dev Returns the number of tokens in ``owner``'s account.
1143      */
1144     function balanceOf(address owner) external view returns (uint256 balance);
1145 
1146     /**
1147      * @dev Returns the owner of the `tokenId` token.
1148      *
1149      * Requirements:
1150      *
1151      * - `tokenId` must exist.
1152      */
1153     function ownerOf(uint256 tokenId) external view returns (address owner);
1154 
1155     /**
1156      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1157      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1158      *
1159      * Requirements:
1160      *
1161      * - `from` cannot be the zero address.
1162      * - `to` cannot be the zero address.
1163      * - `tokenId` token must exist and be owned by `from`.
1164      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1165      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1170 
1171     /**
1172      * @dev Transfers `tokenId` token from `from` to `to`.
1173      *
1174      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1175      *
1176      * Requirements:
1177      *
1178      * - `from` cannot be the zero address.
1179      * - `to` cannot be the zero address.
1180      * - `tokenId` token must be owned by `from`.
1181      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1182      *
1183      * Emits a {Transfer} event.
1184      */
1185     function transferFrom(address from, address to, uint256 tokenId) external;
1186 
1187     /**
1188      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1189      * The approval is cleared when the token is transferred.
1190      *
1191      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1192      *
1193      * Requirements:
1194      *
1195      * - The caller must own the token or be an approved operator.
1196      * - `tokenId` must exist.
1197      *
1198      * Emits an {Approval} event.
1199      */
1200     function approve(address to, uint256 tokenId) external;
1201 
1202     /**
1203      * @dev Returns the account approved for `tokenId` token.
1204      *
1205      * Requirements:
1206      *
1207      * - `tokenId` must exist.
1208      */
1209     function getApproved(uint256 tokenId) external view returns (address operator);
1210 
1211     /**
1212      * @dev Approve or remove `operator` as an operator for the caller.
1213      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1214      *
1215      * Requirements:
1216      *
1217      * - The `operator` cannot be the caller.
1218      *
1219      * Emits an {ApprovalForAll} event.
1220      */
1221     function setApprovalForAll(address operator, bool _approved) external;
1222 
1223     /**
1224      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1225      *
1226      * See {setApprovalForAll}
1227      */
1228     function isApprovedForAll(address owner, address operator) external view returns (bool);
1229 
1230     /**
1231       * @dev Safely transfers `tokenId` token from `from` to `to`.
1232       *
1233       * Requirements:
1234       *
1235       * - `from` cannot be the zero address.
1236       * - `to` cannot be the zero address.
1237       * - `tokenId` token must exist and be owned by `from`.
1238       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1239       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1240       *
1241       * Emits a {Transfer} event.
1242       */
1243     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1244 }
1245 
1246 
1247 // Dependency file: contracts/factory/LinkdropFactoryERC721.sol
1248 
1249 // pragma solidity >=0.6.0 <0.8.0;
1250 
1251 // import "contracts/interfaces/ILinkdropERC721.sol";
1252 // import "contracts/interfaces/ILinkdropFactoryERC721.sol";
1253 // import "contracts/factory/LinkdropFactoryCommon.sol";
1254 // import "openzeppelin-solidity/contracts/token/ERC721/IERC721.sol";
1255 
1256 contract LinkdropFactoryERC721 is ILinkdropFactoryERC721, LinkdropFactoryCommon {
1257 
1258     /**
1259     * @dev Function to verify claim params, make sure the link is not claimed or canceled and proxy is allowed to spend token
1260     * @param _weiAmount Amount of wei to be claimed
1261     * @param _nftAddress NFT address
1262     * @param _tokenId Token id to be claimed
1263     * @param _expiration Unix timestamp of link expiration time
1264     * @param _linkId Address corresponding to link key
1265     * @param _linkdropMaster Address corresponding to linkdrop master key
1266     * @param _campaignId Campaign id
1267     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
1268     * @param _receiver Address of linkdrop receiver
1269     * @param _receiverSignature ECDSA signature of linkdrop receiver
1270     * @return True if success
1271     */
1272     function checkClaimParamsERC721
1273     (
1274         uint _weiAmount,
1275         address _nftAddress,
1276         uint _tokenId,
1277         uint _expiration,
1278         address _linkId,
1279         address payable _linkdropMaster,
1280         uint _campaignId,
1281         bytes memory _linkdropSignerSignature,
1282         address _receiver,
1283         bytes memory _receiverSignature
1284     )
1285     public
1286     override
1287     view
1288     returns (bool)
1289     {
1290         // Make sure proxy contract is deployed
1291         require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
1292 
1293         return ILinkdropERC721(deployed[salt(_linkdropMaster, _campaignId)]).checkClaimParamsERC721
1294         (
1295             _weiAmount,
1296             _nftAddress,
1297             _tokenId,
1298             _expiration,
1299             _linkId,
1300             _linkdropSignerSignature,
1301             _receiver,
1302             _receiverSignature
1303         );
1304     }
1305 
1306     /**
1307     * @dev Function to claim ETH and/or ERC721 token
1308     * @param _weiAmount Amount of wei to be claimed
1309     * @param _nftAddress NFT address
1310     * @param _tokenId Token id to be claimed
1311     * @param _expiration Unix timestamp of link expiration time
1312     * @param _linkId Address corresponding to link key
1313     * @param _linkdropMaster Address corresponding to linkdrop master key
1314     * @param _campaignId Campaign id
1315     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
1316     * @param _receiver Address of linkdrop receiver
1317     * @param _receiverSignature ECDSA signature of linkdrop receiver
1318     * @return True if success
1319     */
1320     function claimERC721
1321     (
1322         uint _weiAmount,
1323         address _nftAddress,
1324         uint _tokenId,
1325         uint _expiration,
1326         address _linkId,
1327         address payable _linkdropMaster,
1328         uint _campaignId,
1329         bytes calldata _linkdropSignerSignature,
1330         address payable _receiver,
1331         bytes calldata _receiverSignature
1332     )
1333     external
1334     override
1335     returns (bool)
1336     {
1337         // Make sure proxy contract is deployed
1338         require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
1339         // Call claim function in the context of proxy contract
1340         ILinkdropERC721(deployed[salt(_linkdropMaster, _campaignId)]).claimERC721
1341           (
1342             _weiAmount,
1343             _nftAddress,
1344             _tokenId,
1345             _expiration,
1346             _linkId,
1347             _linkdropSignerSignature,
1348             _receiver,
1349             _receiverSignature
1350         );
1351 
1352         return true;
1353     }
1354 }
1355 
1356 
1357 // Dependency file: contracts/interfaces/ILinkdropERC1155.sol
1358 
1359 // pragma solidity >=0.6.0 <0.8.0;
1360 
1361 interface ILinkdropERC1155 {
1362 
1363     function verifyLinkdropSignerSignatureERC1155
1364     (
1365         uint _weiAmount,
1366         address _nftAddress,
1367         uint _tokenId,
1368         uint _tokenAmount,
1369         uint _expiration,
1370         address _linkId,
1371         bytes calldata _signature
1372     )
1373     external view returns (bool);
1374 
1375     function checkClaimParamsERC1155
1376     (
1377         uint _weiAmount,
1378         address _nftAddress,
1379         uint _tokenId,
1380         uint _tokenAmount,        
1381         uint _expiration,
1382         address _linkId,
1383         bytes calldata _linkdropSignerSignature,
1384         address _receiver,
1385         bytes calldata _receiverSignature
1386      )
1387     external view returns (bool);
1388 
1389     function claimERC1155
1390     (
1391         uint _weiAmount,
1392         address _nftAddress,
1393         uint _tokenId,
1394         uint _tokenAmount,
1395         uint _expiration,
1396         address _linkId,
1397         bytes calldata _linkdropSignerSignature,
1398         address payable _receiver,
1399         bytes calldata _receiverSignature
1400     )
1401     external payable returns (bool);
1402 }
1403 
1404 
1405 // Dependency file: contracts/interfaces/ILinkdropFactoryERC1155.sol
1406 
1407 // pragma solidity >=0.6.0 <0.8.0;
1408 
1409 interface ILinkdropFactoryERC1155 {
1410 
1411     function checkClaimParamsERC1155
1412     (
1413         uint _weiAmount,
1414         address _nftAddress,
1415         uint _tokenId,
1416         uint _tokenAmount,
1417         uint _expiration,
1418         address _linkId,
1419         address payable _linkdropMaster,
1420         uint _campaignId,
1421         bytes calldata _linkdropSignerSignature,
1422         address _receiver,
1423         bytes calldata _receiverSignature
1424     )
1425     external view
1426     returns (bool);
1427 
1428     function claimERC1155
1429     (
1430         uint _weiAmount,
1431         address _nftAddress,
1432         uint _tokenId,
1433         uint _tokenAmount,
1434         uint _expiration,
1435         address _linkId,
1436         address payable _linkdropMaster,
1437         uint _campaignId,
1438         bytes calldata _linkdropSignerSignature,
1439         address payable _receiver,
1440         bytes calldata _receiverSignature
1441     )
1442     external
1443     returns (bool);
1444 }
1445 
1446 
1447 // Dependency file: openzeppelin-solidity/contracts/token/ERC1155/IERC1155.sol
1448 
1449 
1450 // pragma solidity >=0.6.2 <0.8.0;
1451 
1452 // import "openzeppelin-solidity/contracts/introspection/IERC165.sol";
1453 
1454 /**
1455  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1456  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1457  *
1458  * _Available since v3.1._
1459  */
1460 interface IERC1155 is IERC165 {
1461     /**
1462      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1463      */
1464     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1465 
1466     /**
1467      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1468      * transfers.
1469      */
1470     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
1471 
1472     /**
1473      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1474      * `approved`.
1475      */
1476     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1477 
1478     /**
1479      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1480      *
1481      * If an {URI} event was emitted for `id`, the standard
1482      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1483      * returned by {IERC1155MetadataURI-uri}.
1484      */
1485     event URI(string value, uint256 indexed id);
1486 
1487     /**
1488      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1489      *
1490      * Requirements:
1491      *
1492      * - `account` cannot be the zero address.
1493      */
1494     function balanceOf(address account, uint256 id) external view returns (uint256);
1495 
1496     /**
1497      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1498      *
1499      * Requirements:
1500      *
1501      * - `accounts` and `ids` must have the same length.
1502      */
1503     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
1504 
1505     /**
1506      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1507      *
1508      * Emits an {ApprovalForAll} event.
1509      *
1510      * Requirements:
1511      *
1512      * - `operator` cannot be the caller.
1513      */
1514     function setApprovalForAll(address operator, bool approved) external;
1515 
1516     /**
1517      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1518      *
1519      * See {setApprovalForAll}.
1520      */
1521     function isApprovedForAll(address account, address operator) external view returns (bool);
1522 
1523     /**
1524      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1525      *
1526      * Emits a {TransferSingle} event.
1527      *
1528      * Requirements:
1529      *
1530      * - `to` cannot be the zero address.
1531      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1532      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1533      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1534      * acceptance magic value.
1535      */
1536     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
1537 
1538     /**
1539      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1540      *
1541      * Emits a {TransferBatch} event.
1542      *
1543      * Requirements:
1544      *
1545      * - `ids` and `amounts` must have the same length.
1546      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1547      * acceptance magic value.
1548      */
1549     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
1550 }
1551 
1552 
1553 // Dependency file: contracts/factory/LinkdropFactoryERC1155.sol
1554 
1555 // pragma solidity >=0.6.0 <0.8.0;
1556 
1557 // import "contracts/interfaces/ILinkdropERC1155.sol";
1558 // import "contracts/interfaces/ILinkdropFactoryERC1155.sol";
1559 // import "contracts/factory/LinkdropFactoryCommon.sol";
1560 // import "openzeppelin-solidity/contracts/token/ERC1155/IERC1155.sol";
1561 
1562 contract LinkdropFactoryERC1155 is ILinkdropFactoryERC1155, LinkdropFactoryCommon {
1563 
1564     /**
1565     * @dev Function to verify claim params, make sure the link is not claimed or canceled and proxy is allowed to spend token
1566     * @param _weiAmount Amount of wei to be claimed
1567     * @param _nftAddress NFT address
1568     * @param _tokenId Token id to be claimed
1569     * @param _tokenAmount Token id to be claimed
1570     * @param _expiration Unix timestamp of link expiration time
1571     * @param _linkId Address corresponding to link key
1572     * @param _linkdropMaster Address corresponding to linkdrop master key
1573     * @param _campaignId Campaign id
1574     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
1575     * @param _receiver Address of linkdrop receiver
1576     * @param _receiverSignature ECDSA signature of linkdrop receiver
1577     * @return True if success
1578     */
1579     function checkClaimParamsERC1155
1580     (
1581         uint _weiAmount,
1582         address _nftAddress,
1583         uint _tokenId,
1584         uint _tokenAmount,
1585         uint _expiration,
1586         address _linkId,
1587         address payable _linkdropMaster,
1588         uint _campaignId,
1589         bytes memory _linkdropSignerSignature,
1590         address _receiver,
1591         bytes memory _receiverSignature
1592     )
1593     public
1594     override
1595     view
1596     returns (bool)
1597     {
1598         // Make sure proxy contract is deployed
1599         require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
1600 
1601         return ILinkdropERC1155(deployed[salt(_linkdropMaster, _campaignId)]).checkClaimParamsERC1155
1602         (
1603             _weiAmount,
1604             _nftAddress,
1605             _tokenId,
1606             _tokenAmount,
1607             _expiration,
1608             _linkId,
1609             _linkdropSignerSignature,
1610             _receiver,
1611             _receiverSignature
1612         );
1613     }
1614 
1615     /**
1616     * @dev Function to claim ETH and/or ERC1155 token
1617     * @param _weiAmount Amount of wei to be claimed
1618     * @param _nftAddress NFT address
1619     * @param _tokenId Token id to be claimed
1620     * @param _tokenAmount Token id to be claimed
1621     * @param _expiration Unix timestamp of link expiration time
1622     * @param _linkId Address corresponding to link key
1623     * @param _linkdropMaster Address corresponding to linkdrop master key
1624     * @param _campaignId Campaign id
1625     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
1626     * @param _receiver Address of linkdrop receiver
1627     * @param _receiverSignature ECDSA signature of linkdrop receiver
1628     * @return True if success
1629     */
1630     function claimERC1155
1631     (
1632         uint _weiAmount,
1633         address _nftAddress,
1634         uint _tokenId,
1635         uint _tokenAmount,
1636         uint _expiration,
1637         address _linkId,
1638         address payable _linkdropMaster,
1639         uint _campaignId,
1640         bytes calldata _linkdropSignerSignature,
1641         address payable _receiver,
1642         bytes calldata _receiverSignature
1643     )
1644     external
1645     override
1646     returns (bool)
1647     {
1648       
1649       // Make sure proxy contract is deployed
1650       require(isDeployed(_linkdropMaster, _campaignId), "LINKDROP_PROXY_CONTRACT_NOT_DEPLOYED");
1651       
1652       // Call claim function in the context of proxy contract
1653       ILinkdropERC1155(deployed[salt(_linkdropMaster, _campaignId)]).claimERC1155
1654         (
1655          _weiAmount,
1656          _nftAddress,
1657          _tokenId,
1658          _tokenAmount,
1659          _expiration,
1660          _linkId,
1661          _linkdropSignerSignature,
1662          _receiver,
1663          _receiverSignature
1664        );
1665 
1666       return true;
1667     }
1668 
1669 }
1670 
1671 
1672 // Dependency file: contracts/fee-manager/FeeManager.sol
1673 
1674 // pragma solidity >=0.6.0 <0.8.0;
1675 
1676 // import "openzeppelin-solidity/contracts/access/Ownable.sol";
1677 // import "openzeppelin-solidity/contracts/math/SafeMath.sol";
1678 // import "contracts/interfaces/IFeeManager.sol";
1679 
1680 
1681 contract FeeManager is IFeeManager, Ownable  {
1682   using SafeMath for uint;  
1683   mapping (address => bool) internal _whitelisted;
1684   uint public fee; // fee paid by campaign creator if fee is sponsored
1685   uint public claimerFee;  // fee to paid by receiver if claim is not sponsored 
1686   address payable public override feeReceiver;
1687   
1688   constructor() public {
1689     fee = 0 ether;
1690     claimerFee = 0 ether;
1691     feeReceiver = payable(address(this));
1692   }
1693   
1694   function cancelWhitelist(address _addr) public override onlyOwner returns (bool) {
1695     _whitelisted[_addr] = false;
1696     return true;
1697   }
1698 
1699   function whitelist(address _addr) public override onlyOwner returns (bool) {
1700     _whitelisted[_addr] = true;
1701     return true;
1702   }
1703   
1704   function isWhitelisted(address _addr) public view override returns (bool) {
1705     return _whitelisted[_addr];
1706   }
1707   
1708   function changeFeeReceiver(address payable _addr) public override onlyOwner returns (bool) {
1709     feeReceiver = _addr;
1710     return true;
1711   }
1712   
1713   function updateFee(uint _fee) public override onlyOwner returns (bool) {
1714     fee = _fee;
1715     return true;
1716   }
1717 
1718   function updateClaimerFee(uint _claimerFee) public override onlyOwner returns (bool) {
1719     claimerFee = _claimerFee;
1720     return true;
1721   }  
1722 
1723   function withdraw() external override onlyOwner returns (bool) {
1724     msg.sender.transfer(address(this).balance);
1725     return true;
1726   }
1727 
1728   function calculateFee(
1729                         address _linkdropMaster,
1730                         address /* tokenAddress */,
1731                         address _receiver) public view override returns (uint) {
1732     if (isWhitelisted(_linkdropMaster)) {
1733       return 0;
1734     }
1735 
1736     if (_receiver == address(tx.origin)) {
1737       return claimerFee;
1738     }
1739         
1740     return fee;
1741   }
1742  
1743   /**
1744    * @dev Fallback function to accept ETH
1745    */
1746   receive() external payable {}  
1747 }
1748 
1749 
1750 // Root file: contracts/factory/LinkdropFactory.sol
1751 
1752 pragma solidity >=0.6.0 <0.8.0;
1753 
1754 // import "contracts/factory/LinkdropFactoryERC20.sol";
1755 // import "contracts/factory/LinkdropFactoryERC721.sol";
1756 // import "contracts/factory/LinkdropFactoryERC1155.sol";
1757 // import "contracts/fee-manager/FeeManager.sol";
1758 
1759 contract LinkdropFactory is LinkdropFactoryERC20, LinkdropFactoryERC721, LinkdropFactoryERC1155 {
1760 
1761   // Address of contract deploying proxies
1762   FeeManager public feeManager;
1763   
1764   /**
1765    * @dev Constructor that sets bootstap initcode, factory owner, chainId and master copy
1766    * @param _masterCopy Linkdrop mastercopy contract address to calculate bytecode from
1767    * @param _chainId Chain id
1768    */
1769   constructor(address payable _masterCopy, uint _chainId) public {
1770     _initcode = (hex"6352c7420d6000526103ff60206004601c335afa6040516060f3");
1771     chainId = _chainId;
1772     setMasterCopy(_masterCopy);        
1773     feeManager = new FeeManager();
1774     feeManager.transferOwnership(address(msg.sender));
1775   }
1776     
1777   function isWhitelisted(address _addr) public view returns (bool) {
1778     return feeManager.isWhitelisted(_addr);
1779   }    
1780 }