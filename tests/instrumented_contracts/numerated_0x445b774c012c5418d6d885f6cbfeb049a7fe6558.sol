1 // File: contracts/lib/Context.sol
2 
3 // From package @openzeppelin/contracts@2.4.0
4 pragma solidity 0.5.8;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 contract Context {
17     // Empty internal constructor, to prevent people from mistakenly deploying
18     // an instance of this contract, which should be used via inheritance.
19     constructor () internal { }
20     // solhint-disable-previous-line no-empty-blocks
21 
22     function _msgSender() internal view returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: contracts/lib/Ownable.sol
33 
34 // From package @openzeppelin/contracts@2.4.0
35 pragma solidity 0.5.8;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         _owner = _msgSender();
56         emit OwnershipTransferred(address(0), _owner);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(isOwner(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Returns true if the caller is the current owner.
76      */
77     function isOwner() public view returns (bool) {
78         return _msgSender() == _owner;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public onlyOwner {
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      */
104     function _transferOwnership(address newOwner) internal {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         emit OwnershipTransferred(_owner, newOwner);
107         _owner = newOwner;
108     }
109 }
110 
111 // File: contracts/lib/SafeMath.sol
112 
113 // From package @openzeppelin/contracts@2.4.0
114 pragma solidity 0.5.8;
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `+` operator.
135      *
136      * Requirements:
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      * - Subtraction cannot overflow.
167      *
168      * _Available since v2.4.0._
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return div(a, b, "SafeMath: division by zero");
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      * - The divisor cannot be zero.
225      *
226      * _Available since v2.4.0._
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         // Solidity only automatically asserts when dividing by 0
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      * - The divisor cannot be zero.
262      *
263      * _Available since v2.4.0._
264      */
265     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 }
270 
271 // File: contracts/lib/lib.sol
272 
273 // This program is free software: you can redistribute it and/or modify
274 // it under the terms of the GNU General Public License as published by
275 // the Free Software Foundation, either version 3 of the License, or
276 // (at your option) any later version.
277 
278 // This program is distributed in the hope that it will be useful,
279 // but WITHOUT ANY WARRANTY; without even the implied warranty of
280 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
281 // GNU General Public License for more details.
282 
283 // You should have received a copy of the GNU General Public License
284 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
285 
286 /*
287     Everest is using the dai contracts to mock the real dai that will be used.
288     This contract lives here: https://github.com/makerdao/dss/blob/master/src/lib.sol
289     Also we changed the pragma from 0.5.12 to ^0.5.8
290 */
291 
292 pragma solidity 0.5.8;
293 
294 contract LibNote {
295     event LogNote(
296         bytes4   indexed  sig,
297         address  indexed  usr,
298         bytes32  indexed  arg1,
299         bytes32  indexed  arg2,
300         bytes             data
301     ) anonymous;
302 
303     modifier note {
304         _;
305         /* solium-disable-next-line security/no-inline-assembly*/
306         assembly {
307             // log an 'anonymous' event with a constant 6 words of calldata
308             // and four indexed topics: selector, caller, arg1 and arg2
309             let mark := msize                         // end of memory ensures zero
310             mstore(0x40, add(mark, 288))              // update free memory pointer
311             mstore(mark, 0x20)                        // bytes type data offset
312             mstore(add(mark, 0x20), 224)              // bytes size (padded)
313             calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
314             log4(mark, 288,                           // calldata
315                  shl(224, shr(224, calldataload(0))), // msg.sig
316                  caller,                              // msg.sender
317                  calldataload(4),                     // arg1
318                  calldataload(36)                     // arg2
319                 )
320         }
321     }
322 }
323 
324 // File: contracts/lib/dai.sol
325 
326 // Copyright (C) 2017, 2018, 2019 dbrock, rain, mrchico
327 
328 // This program is free software: you can redistribute it and/or modify
329 // it under the terms of the GNU Affero General Public License as published by
330 // the Free Software Foundation, either version 3 of the License, or
331 // (at your option) any later version.
332 //
333 // This program is distributed in the hope that it will be useful,
334 // but WITHOUT ANY WARRANTY; without even the implied warranty of
335 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
336 // GNU Affero General Public License for more details.
337 //
338 // You should have received a copy of the GNU Affero General Public License
339 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
340 
341 /*
342     Everest is using the dai contracts to mock the real dai that will be used.
343     This contract lives here: https://github.com/makerdao/dss/blob/master/src/dai.sol
344     Also we changed the pragma from 0.5.12 to ^0.5.8
345 */
346 
347 pragma solidity 0.5.8;
348 
349 
350 contract Dai is LibNote {
351     // --- Auth ---
352     mapping (address => uint) public wards;
353     function rely(address guy) external note auth { wards[guy] = 1; }
354     function deny(address guy) external note auth { wards[guy] = 0; }
355     modifier auth {
356         require(wards[msg.sender] == 1, "Dai/not-authorized");
357         _;
358     }
359 
360     // --- ERC20 Data ---
361     string  public constant name     = "Dai Stablecoin";
362     string  public constant symbol   = "DAI";
363     string  public constant version  = "1";
364     uint8   public constant decimals = 18;
365     uint256 public totalSupply;
366 
367     mapping (address => uint)                      public balanceOf;
368     mapping (address => mapping (address => uint)) public allowance;
369     mapping (address => uint)                      public nonces;
370 
371     event Approval(address indexed src, address indexed guy, uint wad);
372     event Transfer(address indexed src, address indexed dst, uint wad);
373 
374     // --- Math ---
375     function add(uint x, uint y) internal pure returns (uint z) {
376         require((z = x + y) >= x);
377     }
378     function sub(uint x, uint y) internal pure returns (uint z) {
379         require((z = x - y) <= x);
380     }
381 
382     // --- EIP712 niceties ---
383     bytes32 public DOMAIN_SEPARATOR;
384     // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)");
385     bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
386 
387     constructor(uint256 chainId_) public {
388         wards[msg.sender] = 1;
389         DOMAIN_SEPARATOR = keccak256(abi.encode(
390             keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
391             keccak256(bytes(name)),
392             keccak256(bytes(version)),
393             chainId_,
394             address(this)
395         ));
396     }
397 
398     // --- Token ---
399     function transfer(address dst, uint wad) external returns (bool) {
400         return transferFrom(msg.sender, dst, wad);
401     }
402     function transferFrom(address src, address dst, uint wad)
403         public returns (bool)
404     {
405         require(balanceOf[src] >= wad, "Dai/insufficient-balance");
406         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
407             require(allowance[src][msg.sender] >= wad, "Dai/insufficient-allowance");
408             allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
409         }
410         balanceOf[src] = sub(balanceOf[src], wad);
411         balanceOf[dst] = add(balanceOf[dst], wad);
412         emit Transfer(src, dst, wad);
413         return true;
414     }
415     function mint(address usr, uint wad) external auth {
416         balanceOf[usr] = add(balanceOf[usr], wad);
417         totalSupply    = add(totalSupply, wad);
418         emit Transfer(address(0), usr, wad);
419     }
420     function burn(address usr, uint wad) external {
421         require(balanceOf[usr] >= wad, "Dai/insufficient-balance");
422         if (usr != msg.sender && allowance[usr][msg.sender] != uint(-1)) {
423             require(allowance[usr][msg.sender] >= wad, "Dai/insufficient-allowance");
424             allowance[usr][msg.sender] = sub(allowance[usr][msg.sender], wad);
425         }
426         balanceOf[usr] = sub(balanceOf[usr], wad);
427         totalSupply    = sub(totalSupply, wad);
428         emit Transfer(usr, address(0), wad);
429     }
430     function approve(address usr, uint wad) external returns (bool) {
431         allowance[msg.sender][usr] = wad;
432         emit Approval(msg.sender, usr, wad);
433         return true;
434     }
435 
436     // --- Alias ---
437     function push(address usr, uint wad) external {
438         transferFrom(msg.sender, usr, wad);
439     }
440     function pull(address usr, uint wad) external {
441         transferFrom(usr, msg.sender, wad);
442     }
443     function move(address src, address dst, uint wad) external {
444         transferFrom(src, dst, wad);
445     }
446 
447     // --- Approve by signature ---
448     function permit(address holder, address spender, uint256 nonce, uint256 expiry,
449                     bool allowed, uint8 v, bytes32 r, bytes32 s) external
450     {
451         bytes32 digest =
452             keccak256(abi.encodePacked(
453                 "\x19\x01",
454                 DOMAIN_SEPARATOR,
455                 keccak256(abi.encode(PERMIT_TYPEHASH,
456                                      holder,
457                                      spender,
458                                      nonce,
459                                      expiry,
460                                      allowed))
461         ));
462 
463         require(holder != address(0), "Dai/invalid-address-0");
464         require(holder == ecrecover(digest, v, r, s), "Dai/invalid-permit");
465         require(expiry == 0 || now <= expiry, "Dai/permit-expired");
466         require(nonce == nonces[holder]++, "Dai/invalid-nonce");
467         uint wad = allowed ? uint(-1) : 0;
468         allowance[holder][spender] = wad;
469         emit Approval(holder, spender, wad);
470     }
471 }
472 
473 // File: contracts/lib/AddressUtils.sol
474 
475 // Taken from
476 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
477 
478 pragma solidity 0.5.8;
479 
480 /**
481  * @dev Collection of functions related to the address type
482  */
483 library AddressUtils {
484     /**
485      * @dev Returns true if `account` is a contract.
486      *
487      * [IMPORTANT]
488      * ====
489      * It is unsafe to assume that an address for which this function returns
490      * false is an externally-owned account (EOA) and not a contract.
491      *
492      * Among others, `isContract` will return false for the following
493      * types of addresses:
494      *
495      *  - an externally-owned account
496      *  - a contract in construction
497      *  - an address where a contract will be created
498      *  - an address where a contract lived, but was destroyed
499      * ====
500      */
501     function isContract(address account) internal view returns (bool) {
502         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
503         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
504         // for accounts without code, i.e. `keccak256('')`
505         bytes32 codehash;
506         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
507         // solhint-disable-next-line no-inline-assembly
508         assembly { codehash := extcodehash(account) }
509         return (codehash != accountHash && codehash != 0x0);
510     }
511 }
512 
513 // File: contracts/ReserveBank.sol
514 
515 pragma solidity 0.5.8;
516 
517 
518 
519 
520 
521 /* Note, in Everest V1, the Reserve Bank is not upgradeable.
522  * What will be done is when Everest V2 is deployed, all the tokens
523  * stored in the Reserve Bank will be transferred to the new Reserve Bank.
524  * The new Reverse Bank is likely to be upgradeable, and have more functionality.
525  * However, the ownership of ReserveBank can still be transferred by the Everest owner
526  *
527  * Also, when the switch over happens from V1 to V2, it is okay the empty the reserve bank right
528  * away. This is because all existing challenges will fail on V1, since Everest V1 will no
529  * longer be the owner of the Registry, and any challenge will not be able to withdraw
530  * from the Reserve Bank.
531  */
532 
533 contract ReserveBank is Ownable {
534     using SafeMath for uint256;
535     using AddressUtils for address;
536 
537     Dai public token;
538 
539     constructor(address _daiAddress) public {
540         require(_daiAddress.isContract(), "The address should be a contract");
541         token = Dai(_daiAddress);
542     }
543 
544     /**
545     @dev                Allow the owner of the contract (Everest) to withdraw the funds.
546     @param _receiver    The address receiving the tokens
547     @param _amount      The amount being withdrawn
548     @return             True if successful
549     */
550     function withdraw(address _receiver, uint256 _amount)
551         external
552         onlyOwner
553         returns (bool)
554     {
555         require(_receiver != address(0), "Receiver must not be 0 address");
556         return token.transfer(_receiver, _amount);
557     }
558 }
559 
560 // File: contracts/Registry.sol
561 
562 pragma solidity 0.5.8;
563 
564 
565 contract Registry is Ownable {
566     // ------
567     // STATE
568     // ------
569 
570     struct Member {
571         uint256 challengeID;
572         uint256 memberStartTime; // Used for voting: voteWeight = sqrt(now - memberStartTime)
573     }
574 
575     // Note, this address is used to map to the owner and delegates in the ERC-1056 registry
576     mapping(address => Member) public members;
577 
578     // -----------------
579     // GETTER FUNCTIONS
580     // -----------------
581 
582     /**
583     @dev                Get the challenge ID of a Member. If no challenge exists it returns 0
584     @param _member      The member being checked
585     @return             The challengeID
586     */
587     function getChallengeID(address _member) external view returns (uint256) {
588         require(_member != address(0), "Can't check 0 address");
589         Member memory member = members[_member];
590         return member.challengeID;
591     }
592 
593     /**
594     @dev                Get the start time of a Member. If no time exists it returns 0
595     @param _member      The member being checked
596     @return             The start time
597     */
598     function getMemberStartTime(address _member) external view returns (uint256) {
599         require(_member != address(0), "Can't check 0 address");
600         Member memory member = members[_member];
601         return member.memberStartTime;
602     }
603 
604     // -----------------
605     // SETTER FUNCTIONS
606     // -----------------
607 
608     /**
609     @dev                Set a member in the Registry. Only Everest can call this function.
610     @param _member      The member being added
611     @return             The start time of the member
612     */
613     function setMember(address _member) external onlyOwner returns (uint256) {
614         require(_member != address(0), "Can't check 0 address");
615         Member memory member = Member({
616             challengeID: 0,
617             /* solium-disable-next-line security/no-block-members*/
618             memberStartTime: now
619         });
620         members[_member] = member;
621 
622         /* solium-disable-next-line security/no-block-members*/
623         return now;
624     }
625 
626     /**
627     @dev                        Edit the challengeID. Can be used to set a challenge or remove a
628                                 challenge for a member. Only Everest can call.
629     @param _member              The member being checked
630     @param _newChallengeID      The new challenge ID. Pass in 0 to remove a challenge.
631     */
632     function editChallengeID(address _member, uint256 _newChallengeID) external onlyOwner {
633         require(_member != address(0), "Can't check 0 address");
634         Member storage member = members[_member];
635         member.challengeID = _newChallengeID;
636     }
637 
638     /**
639     @dev                Remove a member. Only Everest can call
640     @param _member      The member being removed
641     */
642     function deleteMember(address _member) external onlyOwner {
643         require(_member != address(0), "Can't check 0 address");
644         delete members[_member];
645     }
646 }
647 
648 // File: contracts/lib/EthereumDIDRegistry.sol
649 
650 /*
651 Original Author: https://github.com/uport-project/ethr-did-registry
652 
653 Pragma has been changed for this document from what is deployed on mainnet.
654 This shouldn"t pose a problem, but it means a lot of syntax has been changed.
655 
656 This contract is only used for testing. On mainnet, we will use the existing
657 DID registry: https://etherscan.io/address/0xdca7ef03e98e0dc2b855be647c39abe984fcf21b#code
658 
659 This contract is also deployed on all testnets, which can be found here:
660 https://github.com/uport-project/ethr-did-registry
661 
662 This contract is included in this repository for testing purposes on ganache. For deploying
663 to testnets or mainnet, it will never be included in the deploy script, since we will use the
664 deployed versions in the above link.
665 */
666 pragma solidity 0.5.8;
667 
668 contract EthereumDIDRegistry {
669     mapping(address => address) public owners;
670     mapping(address => mapping(bytes32 => mapping(address => uint256))) public delegates;
671     mapping(address => uint256) public changed;
672     mapping(address => uint256) public nonce;
673 
674     modifier onlyOwner(address identity, address actor) {
675         require(actor == identityOwner(identity), "Caller must be the identity owner");
676         _;
677     }
678 
679     event DIDOwnerChanged(address indexed identity, address owner, uint256 previousChange);
680 
681     event DIDDelegateChanged(
682         address indexed identity,
683         bytes32 delegateType,
684         address delegate,
685         uint256 validTo,
686         uint256 previousChange
687     );
688 
689     event DIDAttributeChanged(
690         address indexed identity,
691         bytes32 name,
692         bytes value,
693         uint256 validTo,
694         uint256 previousChange
695     );
696 
697     function identityOwner(address identity) public view returns (address) {
698         address owner = owners[identity];
699         if (owner != address(0)) {
700             return owner;
701         }
702         return identity;
703     }
704 
705     function checkSignature(address identity, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 hash)
706         internal
707         returns (address)
708     {
709         address signer = ecrecover(hash, sigV, sigR, sigS);
710         require(signer == identityOwner(identity), "Signer must be the identity owner");
711         nonce[signer]++;
712         return signer;
713     }
714 
715     function validDelegate(address identity, bytes32 delegateType, address delegate)
716         public
717         view
718         returns (bool)
719     {
720         uint256 validity = delegates[identity][keccak256(abi.encode(delegateType))][delegate];
721         /* solium-disable-next-line security/no-block-members*/
722         return (validity > now);
723     }
724 
725     function changeOwner(address identity, address actor, address newOwner)
726         internal
727         onlyOwner(identity, actor)
728     {
729         owners[identity] = newOwner;
730         emit DIDOwnerChanged(identity, newOwner, changed[identity]);
731         changed[identity] = block.number;
732     }
733 
734     function changeOwner(address identity, address newOwner) public {
735         changeOwner(identity, msg.sender, newOwner);
736     }
737 
738     function changeOwnerSigned(
739         address identity,
740         uint8 sigV,
741         bytes32 sigR,
742         bytes32 sigS,
743         address newOwner
744     ) public {
745         bytes32 hash = keccak256(
746             abi.encodePacked(
747                 bytes1(0x19),
748                 bytes1(0),
749                 this,
750                 nonce[identityOwner(identity)],
751                 identity,
752                 "changeOwner",
753                 newOwner
754             )
755         );
756         changeOwner(identity, checkSignature(identity, sigV, sigR, sigS, hash), newOwner);
757     }
758 
759     function addDelegate(
760         address identity,
761         address actor,
762         bytes32 delegateType,
763         address delegate,
764         uint256 validity
765     ) internal onlyOwner(identity, actor) {
766         /* solium-disable-next-line security/no-block-members*/
767         delegates[identity][keccak256(abi.encode(delegateType))][delegate] = now + validity;
768         emit DIDDelegateChanged(
769             identity,
770             delegateType,
771             delegate,
772             /* solium-disable-next-line security/no-block-members*/
773             now + validity,
774             changed[identity]
775         );
776         changed[identity] = block.number;
777     }
778 
779     function addDelegate(address identity, bytes32 delegateType, address delegate, uint256 validity)
780         public
781     {
782         addDelegate(identity, msg.sender, delegateType, delegate, validity);
783     }
784 
785     function addDelegateSigned(
786         address identity,
787         uint8 sigV,
788         bytes32 sigR,
789         bytes32 sigS,
790         bytes32 delegateType,
791         address delegate,
792         uint256 validity
793     ) public {
794         bytes32 hash = keccak256(
795             abi.encodePacked(
796                 bytes1(0x19),
797                 bytes1(0),
798                 this,
799                 nonce[identityOwner(identity)],
800                 identity,
801                 "addDelegate",
802                 delegateType,
803                 delegate,
804                 validity
805             )
806         );
807         addDelegate(
808             identity,
809             checkSignature(identity, sigV, sigR, sigS, hash),
810             delegateType,
811             delegate,
812             validity
813         );
814     }
815 
816     function revokeDelegate(address identity, address actor, bytes32 delegateType, address delegate)
817         internal
818         onlyOwner(identity, actor)
819     {
820         /* solium-disable-next-line security/no-block-members*/
821         delegates[identity][keccak256(abi.encode(delegateType))][delegate] = now;
822         /* solium-disable-next-line security/no-block-members*/
823         emit DIDDelegateChanged(identity, delegateType, delegate, now, changed[identity]);
824         changed[identity] = block.number;
825     }
826 
827     function revokeDelegate(address identity, bytes32 delegateType, address delegate) public {
828         revokeDelegate(identity, msg.sender, delegateType, delegate);
829     }
830 
831     function revokeDelegateSigned(
832         address identity,
833         uint8 sigV,
834         bytes32 sigR,
835         bytes32 sigS,
836         bytes32 delegateType,
837         address delegate
838     ) public {
839         bytes32 hash = keccak256(
840             abi.encodePacked(
841                 bytes1(0x19),
842                 bytes1(0),
843                 this,
844                 nonce[identityOwner(identity)],
845                 identity,
846                 "revokeDelegate",
847                 delegateType,
848                 delegate
849             )
850         );
851         revokeDelegate(
852             identity,
853             checkSignature(identity, sigV, sigR, sigS, hash),
854             delegateType,
855             delegate
856         );
857     }
858 
859     function setAttribute(
860         address identity,
861         address actor,
862         bytes32 name,
863         bytes memory value,
864         uint256 validity
865     ) internal onlyOwner(identity, actor) {
866         /* solium-disable-next-line security/no-block-members*/
867         emit DIDAttributeChanged(identity, name, value, now + validity, changed[identity]);
868         changed[identity] = block.number;
869     }
870 
871     function setAttribute(address identity, bytes32 name, bytes memory value, uint256 validity)
872         public
873     {
874         setAttribute(identity, msg.sender, name, value, validity);
875     }
876 
877     function setAttributeSigned(
878         address identity,
879         uint8 sigV,
880         bytes32 sigR,
881         bytes32 sigS,
882         bytes32 name,
883         bytes memory value,
884         uint256 validity
885     ) public {
886         bytes32 hash = keccak256(
887             abi.encodePacked(
888                 bytes1(0x19),
889                 bytes1(0),
890                 this,
891                 nonce[identityOwner(identity)],
892                 identity,
893                 "setAttribute",
894                 name,
895                 value,
896                 validity
897             )
898         );
899         setAttribute(
900             identity,
901             checkSignature(identity, sigV, sigR, sigS, hash),
902             name,
903             value,
904             validity
905         );
906     }
907 
908     function revokeAttribute(address identity, address actor, bytes32 name, bytes memory value)
909         internal
910         onlyOwner(identity, actor)
911     {
912         emit DIDAttributeChanged(identity, name, value, 0, changed[identity]);
913         changed[identity] = block.number;
914     }
915 
916     function revokeAttribute(address identity, bytes32 name, bytes memory value) public {
917         revokeAttribute(identity, msg.sender, name, value);
918     }
919 
920     function revokeAttributeSigned(
921         address identity,
922         uint8 sigV,
923         bytes32 sigR,
924         bytes32 sigS,
925         bytes32 name,
926         bytes memory value
927     ) public {
928         bytes32 hash = keccak256(
929             abi.encodePacked(
930                 bytes1(0x19),
931                 bytes1(0),
932                 this,
933                 nonce[identityOwner(identity)],
934                 identity,
935                 "revokeAttribute",
936                 name,
937                 value
938             )
939         );
940         revokeAttribute(identity, checkSignature(identity, sigV, sigR, sigS, hash), name, value);
941     }
942 
943 }
944 
945 // File: contracts/abdk-libraries-solidity/ABDKMath64x64.sol
946 
947 /*
948  * TheGraph is using this software as described in the README.md in this folder
949  * https://github.com/abdk-consulting/abdk-libraries-solidity/tree/939f0a264f2d07a9e2c7a3a020f0db2c0885dc01
950  *
951  * This library has been significantly reduced to only include the functions needed for Everest
952  * Please visit the library at the link above for more details
953  */
954 
955 /*
956  * ABDK Math 64.64 Smart Contract Library.  Copyright © 2019 by ABDK Consulting.
957  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
958  */
959 pragma solidity 0.5.8;
960 
961 /**
962  * Smart contract library of mathematical functions operating with signed
963  * 64.64-bit fixed point numbers.  Signed 64.64-bit fixed point number is
964  * basically a simple fraction whose numerator is signed 128-bit integer and
965  * denominator is 2^64.  As long as denominator is always the same, there is no
966  * need to store it, thus in Solidity signed 64.64-bit fixed point numbers are
967  * represented by int128 type holding only the numerator.
968  */
969 library ABDKMath64x64 {
970   /**
971    * Convert unsigned 256-bit integer number into signed 64.64-bit fixed point
972    * number.  Revert on overflow.
973    *
974    * @param x unsigned 256-bit integer number
975    * @return signed 64.64-bit fixed point number
976    */
977   function fromUInt (uint256 x) internal pure returns (int128) {
978     require (x <= 0x7FFFFFFFFFFFFFFF);
979     return int128 (x << 64);
980   }
981 
982   /**
983    * Convert signed 64.64 fixed point number into unsigned 64-bit integer
984    * number rounding down.  Revert on underflow.
985    *
986    * @param x signed 64.64-bit fixed point number
987    * @return unsigned 64-bit integer number
988    */
989   function toUInt (int128 x) internal pure returns (uint64) {
990     require (x >= 0);
991     return uint64 (x >> 64);
992   }
993 
994   /**
995    * Calculate sqrt (x) rounding down.  Revert if x < 0.
996    *
997    * @param x signed 64.64-bit fixed point number
998    * @return signed 64.64-bit fixed point number
999    */
1000   function sqrt (int128 x) internal pure returns (int128) {
1001     require (x >= 0);
1002     return int128 (sqrtu (uint256 (x) << 64, 0x10000000000000000));
1003   }
1004 
1005   /**
1006    * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer
1007    * number.
1008    *
1009    * @param x unsigned 256-bit integer number
1010    * @return unsigned 128-bit integer number
1011    */
1012   function sqrtu (uint256 x, uint256 r) private pure returns (uint128) {
1013     if (x == 0) return 0;
1014     else {
1015       require (r > 0);
1016       while (true) {
1017         uint256 rr = x / r;
1018         if (r == rr || r + 1 == rr) return uint128 (r);
1019         else if (r == rr + 1) return uint128 (rr);
1020         r = r + rr + 1 >> 1;
1021       }
1022     }
1023   }
1024 }
1025 
1026 // File: contracts/Everest.sol
1027 
1028 /*
1029  Everest is a DAO that is designed to curate a Registry of members.
1030 
1031  This storage of the list is in Registry. The EthereumDIDRegistry is used to store data such
1032  as attributes and delegates and transfer of ownership. The only storage in the Everest contract
1033  is Challenges and Votes, which can be safely removed upon completion. This allows for Everest
1034  to be an upgradeable contract, while Registry is the persistent storage.
1035 
1036  The DAO is inspired by the Moloch DAO smart contracts https://github.com/MolochVentures/moloch
1037 */
1038 pragma solidity 0.5.8;
1039 
1040 
1041 
1042 
1043 
1044 
1045 
1046 
1047 contract Everest is Ownable {
1048     using SafeMath for uint256;
1049     using ABDKMath64x64 for uint256;
1050     using ABDKMath64x64 for int128;
1051     using AddressUtils for address;
1052 
1053     // -----------------
1054     // STATE
1055     // -----------------
1056 
1057     // Voting period length for a challenge (in unix seconds)
1058     uint256 public votingPeriodDuration;
1059     // Deposit that must be made in order to submit a challenge
1060     uint256 public challengeDeposit;
1061     // Application fee to become a member
1062     uint256 public applicationFee;
1063     // IPFS hash for off chain storage of the Everest Charter
1064     bytes32 public charter;
1065     // IPFS hash for off chain storage of the Everest Categories
1066     bytes32 public categories;
1067     // Challenge freeze that can prevent new challenges from being made
1068     bool public challengesFrozen;
1069 
1070     // Approved token contract reference (i.e. DAI)
1071     Dai public approvedToken;
1072     // Reserve bank contract reference
1073     ReserveBank public reserveBank;
1074     // ERC-1056 contract reference
1075     EthereumDIDRegistry public erc1056Registry;
1076     // Registry contract reference
1077     Registry public registry;
1078 
1079     // We pass in the bytes representation of the string 'everest'
1080     // bytes("everest") = 0x65766572657374. Then add 50 zeros to the end. The bytes32 value
1081     // is passed to the ERC-1056 registry, and hashed within the delegate functions
1082     bytes32 constant delegateType = 0x6576657265737400000000000000000000000000000000000000000000000000;
1083 
1084     mapping (uint256 => Challenge) public challenges;
1085     // Challenge counter for challenge IDs. With upgrading the contract, the latest challengeID
1086     // must be the last challengeID + 1 of the old version of Everest
1087     uint256 public challengeCounter;
1088 
1089     // -------
1090     // EVENTS
1091     // -------
1092 
1093     // Event data on delegates, owner, and offChainData are emitted from the ERC-1056 registry
1094     event NewMember(address indexed member, uint256 startTime, uint256 fee);
1095     event MemberExited(address indexed member);
1096     event CharterUpdated(bytes32 indexed data);
1097     event CategoriesUpdated(bytes32 indexed data);
1098     event Withdrawal(address indexed receiver, uint256 amount);
1099     event VotingDurationUpdated(uint256 indexed duration);
1100     event ChallengeDepositUpdated(uint256 indexed deposit);
1101     event ApplicationFeeUpdated(uint256 indexed fee);
1102     event ChallengesFrozen(bool isFrozen);
1103 
1104 
1105     event EverestDeployed(
1106         address owner,
1107         address approvedToken,
1108         uint256 votingPeriodDuration,
1109         uint256 challengeDeposit,
1110         uint256 applicationFee,
1111         bytes32 charter,
1112         bytes32 categories,
1113         address didRegistry,
1114         address reserveBank,
1115         address registry,
1116         uint256 startingChallengeID
1117     );
1118 
1119     event MemberChallenged(
1120         address indexed member,
1121         uint256 indexed challengeID,
1122         address indexed challenger,
1123         uint256 challengeEndTime,
1124         bytes32 details
1125     );
1126 
1127     event SubmitVote(
1128         uint256 indexed challengeID,
1129         address indexed submitter,      // i.e. msg.sender
1130         address indexed votingMember,
1131         VoteChoice voteChoice,
1132         uint256 voteWeight
1133     );
1134 
1135     event ChallengeFailed(
1136         address indexed member,
1137         uint256 indexed challengeID,
1138         uint256 yesVotes,
1139         uint256 noVotes,
1140         uint256 voterCount,
1141         uint256 resolverReward
1142     );
1143 
1144     event ChallengeSucceeded(
1145         address indexed member,
1146         uint256 indexed challengeID,
1147         uint256 yesVotes,
1148         uint256 noVotes,
1149         uint256 voterCount,
1150         uint256 challengerReward,
1151         uint256 resolverReward
1152     );
1153 
1154     // ------
1155     // STATE
1156     // ------
1157 
1158     enum VoteChoice {
1159         Null, // Same as not voting at all (i.e. 0 value)
1160         Yes,
1161         No
1162     }
1163 
1164     struct Challenge {
1165         address challenger;         // The member who submitted the challenge
1166         address challengee;         // The member being challenged
1167         uint256 yesVotes;           // The total weight of YES votes for this challenge
1168         uint256 noVotes;            // The total weight of NO votes for this challenge
1169         uint256 voterCount;         // Total count of voters participating in the challenge
1170         uint256 endTime;            // Ending time of the challenge
1171         bytes32 details;            // Challenge details - an IPFS hash, without Qm, to make bytes32
1172         mapping (address => VoteChoice) voteChoiceByMember;     // The choice by each member
1173         mapping (address => uint256) voteWeightByMember;        // The vote weight of each member
1174     }
1175 
1176     // ----------
1177     // MODIFIERS
1178     // ----------
1179 
1180     /**
1181     @dev                Modifer that allows a function to be called by the owner or delegate of a
1182                         member.
1183     @param _member      Member interacting with everest
1184     */
1185     modifier onlyMemberOwnerOrDelegate(address _member) {
1186         require(
1187             isMember(_member),
1188             "onlyMemberOwnerOrDelegate - Address is not a Member"
1189         );
1190         address memberOwner = erc1056Registry.identityOwner(_member);
1191         bool validDelegate = erc1056Registry.validDelegate(_member, delegateType, msg.sender);
1192         require(
1193             validDelegate || memberOwner == msg.sender,
1194             "onlyMemberOwnerOrDelegate - Caller must be delegate or owner"
1195         );
1196         _;
1197     }
1198 
1199     /**
1200     @dev                Modifer that allows a function to be called by owner of a member.
1201                         Only the member can call (no delegate permissions)
1202     @param _member      Member interacting with everest
1203     */
1204     modifier onlyMemberOwner(address _member) {
1205         require(
1206             isMember(_member),
1207             "onlyMemberOwner - Address is not a member"
1208         );
1209         address memberOwner = erc1056Registry.identityOwner(_member);
1210         require(
1211             memberOwner == msg.sender,
1212             "onlyMemberOwner - Caller must be the owner"
1213         );
1214         _;
1215     }
1216 
1217     // ----------
1218     // FUNCTIONS
1219     // ----------
1220 
1221     constructor(
1222         address _approvedToken,
1223         uint256 _votingPeriodDuration,
1224         uint256 _challengeDeposit,
1225         uint256 _applicationFee,
1226         bytes32 _charter,
1227         bytes32 _categories,
1228         address _DIDregistry,
1229         address _reserveBank,
1230         address _registry,
1231         uint256 _startingChallengeID
1232     ) public {
1233         require(_approvedToken.isContract(), "The _approvedToken address should be a contract");
1234         require(_DIDregistry.isContract(), "The _DIDregistry address should be a contract");
1235         require(_reserveBank.isContract(), "The _reserveBank address should be a contract");
1236         require(_registry.isContract(), "The _registry address should be a contract");
1237         require(_votingPeriodDuration > 0, "constructor - _votingPeriodDuration cannot be 0");
1238         require(_challengeDeposit > 0, "constructor - _challengeDeposit cannot be 0");
1239         require(_applicationFee > 0, "constructor - _applicationFee cannot be 0");
1240         require(_startingChallengeID != 0, "constructor - _startingChallengeID cannot be 0");
1241 
1242         approvedToken = Dai(_approvedToken);
1243         votingPeriodDuration = _votingPeriodDuration;
1244         challengeDeposit = _challengeDeposit;
1245         applicationFee = _applicationFee;
1246         charter = _charter;
1247         categories = _categories;
1248         erc1056Registry = EthereumDIDRegistry(_DIDregistry);
1249         reserveBank = ReserveBank(_reserveBank);
1250         registry = Registry(_registry);
1251         challengeCounter = _startingChallengeID;
1252 
1253         emit EverestDeployed(
1254             msg.sender,             // i.e owner
1255             _approvedToken,
1256             _votingPeriodDuration,
1257             _challengeDeposit,
1258             _applicationFee,
1259             _charter,
1260             _categories,
1261             _DIDregistry,
1262             _reserveBank,
1263             _registry,
1264             _startingChallengeID
1265         );
1266     }
1267 
1268     // ---------------------
1269     // ADD MEMBER FUNCTIONS
1270     // ---------------------
1271 
1272     /**
1273     @dev                            Allows a user to add a member to the Registry and
1274                                     add off chain data to the DID registry. The sig for
1275                                     changeOwner() and setAttribute() are from _newMember
1276                                     and for DAIS permit() it is the _owner.
1277 
1278                                     [0] = setAttributeSigned() signature
1279                                     [1] = changeOwnerSigned() signature
1280                                     [2] = permit() signature
1281 
1282     @param _newMember               The address of the new member
1283     @param _sigV                    V of sigs
1284     @param _sigR                    R of sigs
1285     @param _sigS                    S of sigs
1286     @param _memberOwner             Owner of the member (on the DID registry)
1287     @param _offChainDataName        Attribute name. Should be a string less than 32 bytes, converted
1288                                     to bytes32. example: 'ProjectData' = 0x50726f6a65637444617461,
1289                                     with zeros appended to make it 32 bytes
1290     @param _offChainDataValue       Attribute data stored offchain (IPFS)
1291     @param _offChainDataValidity    Length of time attribute data is valid (unix)
1292     */
1293     function applySignedWithAttributeAndPermit(
1294         address _newMember,
1295         uint8[3] calldata _sigV,
1296         bytes32[3] calldata _sigR,
1297         bytes32[3] calldata _sigS,
1298         address _memberOwner,
1299         bytes32 _offChainDataName,
1300         bytes calldata _offChainDataValue,
1301         uint256 _offChainDataValidity
1302     ) external {
1303         require(_newMember != address(0), "Member can't be 0 address");
1304         require(_memberOwner != address(0), "Owner can't be 0 address");
1305         applySignedWithAttributeAndPermitInternal(
1306             _newMember,
1307             _sigV,
1308             _sigR,
1309             _sigS,
1310             _memberOwner,
1311             _offChainDataName,
1312             _offChainDataValue,
1313             _offChainDataValidity
1314         );
1315     }
1316 
1317     /// @dev    Note that this internal function is created in order to avoid the
1318     ///         Solidity stack too deep error.
1319     function applySignedWithAttributeAndPermitInternal(
1320         address _newMember,
1321         uint8[3] memory _sigV,
1322         bytes32[3] memory _sigR,
1323         bytes32[3] memory _sigS,
1324         address _memberOwner,
1325         bytes32 _offChainDataName,
1326         bytes memory _offChainDataValue,
1327         uint256 _offChainDataValidity
1328     ) internal {
1329         // Approve Everest to transfer DAI on the owner's behalf
1330         // Expiry = 0 is infinite. true is unlimited allowance
1331         uint256 nonce = approvedToken.nonces(_memberOwner);
1332         approvedToken.permit(_memberOwner, address(this), nonce, 0, true, _sigV[2], _sigR[2], _sigS[2]);
1333 
1334         applySignedWithAttribute(
1335             _newMember,
1336             [_sigV[0], _sigV[1]],
1337             [_sigR[0], _sigR[1]],
1338             [_sigS[0], _sigS[1]],
1339             _memberOwner,
1340             _offChainDataName,
1341             _offChainDataValue,
1342             _offChainDataValidity
1343         );
1344     }
1345 
1346     /**
1347     @dev                            Functions the same as applySignedWithAttributeAndPermit(),
1348                                     except without permit(). This function should be called by
1349                                     any _owner that has already called permit() for Everest.
1350 
1351                                     [0] = setAttributeSigned() signature
1352                                     [1] = changeOwnerSigned() signature
1353 
1354     @param _newMember               The address of the new member
1355     @param _sigV                    V of sigs
1356     @param _sigR                    R of sigs
1357     @param _sigS                    S of sigs
1358     @param _memberOwner             Owner of the member application
1359     @param _offChainDataName        Attribute name. Should be a string less than 32 bytes, converted
1360                                     to bytes32. example: 'ProjectData' = 0x50726f6a65637444617461,
1361                                     with zeros appended to make it 32 bytes
1362     @param _offChainDataValue       Attribute data stored offchain (IPFS)
1363     @param _offChainDataValidity    Length of time attribute data is valid
1364     */
1365     function applySignedWithAttribute(
1366         address _newMember,
1367         uint8[2] memory _sigV,
1368         bytes32[2] memory _sigR,
1369         bytes32[2] memory _sigS,
1370         address _memberOwner,
1371         bytes32 _offChainDataName,
1372         bytes memory _offChainDataValue,
1373         uint256 _offChainDataValidity
1374     ) public {
1375         require(_newMember != address(0), "Member can't be 0 address");
1376         require(_memberOwner != address(0), "Owner can't be 0 address");
1377         require(
1378             registry.getMemberStartTime(_newMember) == 0,
1379             "applySignedInternal - This member already exists"
1380         );
1381         uint256 startTime = registry.setMember(_newMember);
1382 
1383         // This event should be emitted before changeOwnerSigned() is called. This way all events
1384         // in the Ethereum DID registry can start to be considered within the bounds of the event
1385         // event NewMember() and the end of membership with event MemberExit() or event
1386         // ChallengeSucceeded()
1387         emit NewMember(
1388             _newMember,
1389             startTime,
1390             applicationFee
1391         );
1392 
1393         erc1056Registry.setAttributeSigned(
1394             _newMember,
1395             _sigV[0],
1396             _sigR[0],
1397             _sigS[0],
1398             _offChainDataName,
1399             _offChainDataValue,
1400             _offChainDataValidity
1401         );
1402 
1403         erc1056Registry.changeOwnerSigned(_newMember, _sigV[1], _sigR[1], _sigS[1], _memberOwner);
1404 
1405         // Transfers tokens from owner to the reserve bank
1406         require(
1407             approvedToken.transferFrom(_memberOwner, address(reserveBank), applicationFee),
1408             "applySignedInternal - Token transfer failed"
1409         );
1410     }
1411 
1412     /**
1413     @dev                Allow a member to voluntarily leave. Note that this does not
1414                         reset ownership or delegates in the ERC-1056 registry. This must be done by
1415                         calling the respective functions in the registry that handle those.
1416     @param _member      Member exiting the list
1417     */
1418     function memberExit(
1419         address _member
1420     ) external onlyMemberOwner(_member) {
1421         require(_member != address(0), "Member can't be 0 address");
1422         require(
1423             !memberChallengeExists(_member),
1424             "memberExit - Can't exit during ongoing challenge"
1425         );
1426         registry.deleteMember(_member);
1427         emit MemberExited(_member);
1428     }
1429 
1430     // --------------------
1431     // CHALLENGE FUNCTIONS
1432     // --------------------
1433 
1434     /**
1435     @dev                        Starts a challenge on a member. Challenger deposits a fee.
1436     @param _challenger          The address of the member who is challenging another member
1437     @param _challengee          The address of the member being challenged
1438     @param _details             Extra details relevant to the challenge. (IPFS hash without Qm)
1439     @return                     Challenge ID for the created challenge
1440     */
1441     function challenge(
1442         address _challenger,
1443         address _challengee,
1444         bytes32 _details
1445     ) external onlyMemberOwner(_challenger) returns (uint256 challengeID) {
1446         require(_challenger != address(0), "Challenger can't be 0 address");
1447         require(isMember(_challengee), "challenge - Challengee must exist");
1448         require(
1449             _challenger != _challengee,
1450             "challenge - Can't challenge self"
1451         );
1452         require(challengesFrozen != true, "challenge - Cannot create challenge, frozen");
1453         uint256 currentChallengeID = registry.getChallengeID(_challengee);
1454         require(currentChallengeID == 0, "challenge - Existing challenge must be resolved first");
1455 
1456         uint256 newChallengeID = challengeCounter;
1457         Challenge memory newChallenge = Challenge({
1458             challenger: _challenger,
1459             challengee: _challengee,
1460             // It is okay to start counts at 0 here. submitVote() is called at the end of the func
1461             yesVotes: 0,
1462             noVotes: 0,
1463             voterCount: 0,
1464             /* solium-disable-next-line security/no-block-members*/
1465             endTime: now.add(votingPeriodDuration),
1466             details: _details
1467         });
1468         challengeCounter = challengeCounter.add(1);
1469 
1470         challenges[newChallengeID] = newChallenge;
1471 
1472         // Updates member to store most recent challenge
1473         registry.editChallengeID(_challengee, newChallengeID);
1474 
1475         // Transfer tokens from challenger to reserve bank
1476         require(
1477             approvedToken.transferFrom(msg.sender, address(reserveBank), challengeDeposit),
1478             "challenge - Token transfer failed"
1479         );
1480 
1481         emit MemberChallenged(
1482             _challengee,
1483             newChallengeID,
1484             _challenger,
1485             /* solium-disable-next-line security/no-block-members*/
1486             now.add(votingPeriodDuration),
1487             newChallenge.details
1488         );
1489 
1490         // Add challengers' vote into the challenge
1491         submitVote(newChallengeID, VoteChoice.Yes, _challenger);
1492         return newChallengeID;
1493     }
1494 
1495     /**
1496     @dev                    Submit a vote. Owner or delegate can submit
1497     @param _challengeID     The challenge ID
1498     @param _voteChoice      The vote choice (yes or no)
1499     @param _votingMember    The member who is voting
1500     */
1501     function submitVote(
1502         uint256 _challengeID,
1503         VoteChoice _voteChoice,
1504         address _votingMember
1505     ) public onlyMemberOwnerOrDelegate(_votingMember) {
1506         require(_votingMember != address(0), "Member can't be 0 address");
1507         require(
1508             _voteChoice == VoteChoice.Yes || _voteChoice == VoteChoice.No,
1509             "submitVote - Vote must be either Yes or No"
1510         );
1511 
1512         Challenge storage storedChallenge = challenges[_challengeID];
1513         require(
1514             storedChallenge.endTime > 0,
1515             "submitVote - Challenge does not exist"
1516         );
1517         require(
1518             !hasVotingPeriodExpired(storedChallenge.endTime),
1519             "submitVote - Challenge voting period has expired"
1520         );
1521         require(
1522             storedChallenge.voteChoiceByMember[_votingMember] == VoteChoice.Null,
1523             "submitVote - Member has already voted on this challenge"
1524         );
1525 
1526         require(
1527             storedChallenge.challengee != _votingMember,
1528             "submitVote - Member can't vote on their own challenge"
1529         );
1530 
1531         uint256 startTime = registry.getMemberStartTime(_votingMember);
1532         // The lower the member start time (i.e. the older the member) the more vote weight
1533         uint256 voteWeightSquared = storedChallenge.endTime.sub(startTime);
1534 
1535         // Here we use ABDKMath64x64 to do the square root of the vote weight
1536         // We have to covert it to a 64.64 fixed point number, do sqrt(), then convert it
1537         // back to uint256. uint256 wraps the result of toUInt(), since it returns uint64
1538         int128 sixtyFourBitFPInt = voteWeightSquared.fromUInt();
1539         int128 voteWeightInt128 = sixtyFourBitFPInt.sqrt();
1540         uint256 voteWeight = uint256(voteWeightInt128.toUInt());
1541 
1542         // Store vote with _votingMember, not msg.sender, since a delegate can vote
1543         storedChallenge.voteChoiceByMember[_votingMember] = _voteChoice;
1544         storedChallenge.voteWeightByMember[_votingMember] = voteWeight;
1545         storedChallenge.voterCount = storedChallenge.voterCount.add(1);
1546 
1547         // Count vote
1548         if (_voteChoice == VoteChoice.Yes) {
1549             storedChallenge.yesVotes = storedChallenge.yesVotes.add(voteWeight);
1550         } else if (_voteChoice == VoteChoice.No) {
1551             storedChallenge.noVotes = storedChallenge.noVotes.add(voteWeight);
1552         }
1553 
1554         emit SubmitVote(_challengeID, msg.sender, _votingMember, _voteChoice, voteWeight);
1555     }
1556 
1557     /**
1558     @dev                    Submit many votes from owner or delegate with multiple members they own
1559                             or are delegates of
1560     @param _challengeID     The challenge ID
1561     @param _voteChoices     The vote choices (yes or no)
1562     @param _voters          The members who are voting
1563     */
1564     function submitVotes(
1565         uint256 _challengeID,
1566         VoteChoice[] calldata _voteChoices,
1567         address[] calldata _voters
1568     ) external {
1569         require(
1570             _voteChoices.length == _voters.length,
1571             "submitVotes - Arrays must be equal"
1572         );
1573         require(_voteChoices.length < 90, "submitVotes - Array should be < 90 to avoid going over the block gas limit");
1574         for (uint256 i; i < _voteChoices.length; i++){
1575             submitVote(_challengeID, _voteChoices[i], _voters[i]);
1576         }
1577     }
1578 
1579     /**
1580     @dev                    Resolve a challenge A successful challenge means the member is removed.
1581                             Anyone can call this function. They will be rewarded with 1/10 of the
1582                             challenge deposit.
1583     @param _challengeID     The challenge ID
1584     */
1585     function resolveChallenge(uint256 _challengeID) external {
1586         challengeCanBeResolved(_challengeID);
1587         Challenge storage storedChallenge = challenges[_challengeID];
1588 
1589         bool didPass = storedChallenge.yesVotes > storedChallenge.noVotes;
1590         bool moreThanOneVote = storedChallenge.voterCount > 1;
1591         // Challenge reward is 1/10th the challenge deposit. This allows incentivization to
1592         // always resolve the challenge for the user that calls this function
1593         uint256 challengeRewardDivisor = 10;
1594         uint256 resolverReward = challengeDeposit.div(challengeRewardDivisor);
1595 
1596         if (didPass && moreThanOneVote) {
1597             address challengerOwner = erc1056Registry.identityOwner(storedChallenge.challenger);
1598 
1599             // The amount includes the applicationFee, which is the reward for challenging a project
1600             // and getting it successfully removed. Minus the resolver reward
1601             uint256 challengerReward = challengeDeposit.add(applicationFee).sub(resolverReward);
1602             require(
1603                 reserveBank.withdraw(challengerOwner, challengerReward),
1604                 "resolveChallenge - Rewarding challenger failed"
1605             );
1606             // Transfer resolver reward
1607             require(
1608                 reserveBank.withdraw(msg.sender, resolverReward),
1609                 "resolveChallenge - Rewarding resolver failed"
1610             );
1611 
1612             registry.deleteMember(storedChallenge.challengee);
1613             emit ChallengeSucceeded(
1614                 storedChallenge.challengee,
1615                 _challengeID,
1616                 storedChallenge.yesVotes,
1617                 storedChallenge.noVotes,
1618                 storedChallenge.voterCount,
1619                 challengerReward,
1620                 resolverReward
1621             );
1622 
1623         } else {
1624             // Transfer resolver reward
1625             require(
1626                 reserveBank.withdraw(msg.sender, resolverReward),
1627                 "resolveChallenge - Rewarding resolver failed"
1628             );
1629 
1630             // Remove challenge ID from the Member in the registry
1631             registry.editChallengeID(storedChallenge.challengee, 0);
1632             emit ChallengeFailed(
1633                 storedChallenge.challengee,
1634                 _challengeID,
1635                 storedChallenge.yesVotes,
1636                 storedChallenge.noVotes,
1637                 storedChallenge.voterCount,
1638                 resolverReward
1639             );
1640         }
1641 
1642         // Delete challenge from Everest in either case
1643         delete challenges[_challengeID];
1644     }
1645 
1646     // ------------------------
1647     // EVEREST OWNER FUNCTIONS
1648     // ------------------------
1649 
1650     /**
1651     @dev                Allows the owner of everest to withdraw funds from the reserve bank.
1652     @param _receiver    The address receiving funds
1653     @param _amount      The amount of funds being withdrawn
1654     @return             True if withdrawal is successful
1655     */
1656     function withdraw(address _receiver, uint256 _amount) external onlyOwner returns (bool) {
1657         require(_receiver != address(0), "Receiver must not be 0 address");
1658         require(_amount > 0, "Amount must be greater than 0");
1659         emit Withdrawal(_receiver, _amount);
1660         return reserveBank.withdraw(_receiver, _amount);
1661     }
1662 
1663     /**
1664     @dev                Allows the owner of Everest to transfer the ownership of ReserveBank
1665     @param _newOwner    The new owner
1666     */
1667     function transferOwnershipReserveBank(address _newOwner) external onlyOwner {
1668         reserveBank.transferOwnership(_newOwner);
1669     }
1670 
1671     /**
1672     @dev                Allows the owner of Everest to transfer the ownership of Registry
1673     @param _newOwner    The new owner
1674     */
1675     function transferOwnershipRegistry(address _newOwner) external onlyOwner {
1676         registry.transferOwnership(_newOwner);
1677     }
1678 
1679     /**
1680     @dev                Updates the charter for Everest
1681     @param _newCharter  The data that point to the new charter
1682     */
1683     function updateCharter(bytes32 _newCharter) external onlyOwner {
1684         charter = _newCharter;
1685         emit CharterUpdated(charter);
1686     }
1687 
1688     /**
1689     @dev                Updates the categories for Everest
1690     @param _newCategories  The data that point to the new categories
1691     */
1692     function updateCategories(bytes32 _newCategories) external onlyOwner {
1693         categories = _newCategories;
1694         emit CategoriesUpdated(categories);
1695     }
1696 
1697     /**
1698     @dev                        Updates the voting duration for Everest
1699     @param _newVotingDuration   New voting duration in unix seconds
1700     */
1701     function updateVotingPeriodDuration(uint256 _newVotingDuration) external onlyOwner {
1702         votingPeriodDuration = _newVotingDuration;
1703         emit VotingDurationUpdated(votingPeriodDuration);
1704     }
1705 
1706     /**
1707     @dev                Updates the challenge deposit required
1708     @param _newDeposit  The new value for the challenge deposit, with decimals (10^18)
1709     */
1710     function updateChallengeDeposit(uint256 _newDeposit) external onlyOwner {
1711         challengeDeposit = _newDeposit;
1712         emit ChallengeDepositUpdated(challengeDeposit);
1713     }
1714 
1715     /**
1716     @dev            Updates the application fee for Everest
1717     @param _newFee  The new application fee, with decimals (10^18)
1718     */
1719     function updateApplicationFee(uint256 _newFee) external onlyOwner {
1720         applicationFee = _newFee;
1721         emit ApplicationFeeUpdated(applicationFee);
1722     }
1723 
1724     /**
1725     @dev                Freezes the ability to create challenges
1726     @param _isFrozen    Pass in true if challenges are to be frozen
1727     */
1728     function updateChallengeFreeze(bool _isFrozen) external onlyOwner {
1729         challengesFrozen = _isFrozen;
1730         emit ChallengesFrozen(challengesFrozen);
1731     }
1732 
1733     // -----------------
1734     // GETTER FUNCTIONS
1735     // -----------------
1736 
1737 
1738     /**
1739     @dev                Returns true if a challenge vote period has finished
1740     @param _endTime     The starting period of the challenge
1741     @return             True if voting period has expired
1742     */
1743     function hasVotingPeriodExpired(uint256 _endTime) private view returns (bool) {
1744         /* solium-disable-next-line security/no-block-members*/
1745         return now >= _endTime;
1746     }
1747 
1748     /**
1749     @dev            Returns true if the address is a member
1750     @param _member  The member name of the member whose status is to be examined
1751     @return         True is address is a member
1752     */
1753     function isMember(address _member) public view returns (bool){
1754         require(_member != address(0), "Member can't be 0 address");
1755         uint256 startTime = registry.getMemberStartTime(_member);
1756         if (startTime > 0){
1757             return true;
1758         }
1759         return false;
1760     }
1761 
1762     /**
1763     @dev            Returns true if the member has an unresolved challenge. False if the challenge
1764                     does not exist.
1765     @param _member  The member that is being checked for a challenge.
1766     @return         True if a challenge exists on the member
1767     */
1768     function memberChallengeExists(address _member) public view returns (bool) {
1769         require(_member != address(0), "Member can't be 0 address");
1770         uint256 challengeID = registry.getChallengeID(_member);
1771         return (challengeID > 0);
1772     }
1773 
1774     /**
1775     @dev                Determines whether voting has concluded in a challenge for a given
1776                         member. Throws if challenge can't be resolved
1777     @param _challengeID The challenge ID
1778     */
1779     function challengeCanBeResolved(uint256 _challengeID) private view {
1780         Challenge storage storedChallenge = challenges[_challengeID];
1781         require(
1782             challenges[_challengeID].endTime > 0,
1783             "challengeCanBeResolved - Challenge does not exist or was completed"
1784         );
1785         require(
1786             hasVotingPeriodExpired(storedChallenge.endTime),
1787             "challengeCanBeResolved - Current challenge is not ready to be resolved"
1788         );
1789     }
1790 }