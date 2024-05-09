1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8   struct Role {
9     mapping (address => bool) bearer;
10   }
11 
12   /**
13    * @dev give an account access to this role
14    */
15   function add(Role storage role, address account) internal {
16     require(account != address(0));
17     require(!has(role, account));
18 
19     role.bearer[account] = true;
20   }
21 
22   /**
23    * @dev remove an account's access to this role
24    */
25   function remove(Role storage role, address account) internal {
26     require(account != address(0));
27     require(has(role, account));
28 
29     role.bearer[account] = false;
30   }
31 
32   /**
33    * @dev check if an account has this role
34    * @return bool
35    */
36   function has(Role storage role, address account)
37     internal
38     view
39     returns (bool)
40   {
41     require(account != address(0));
42     return role.bearer[account];
43   }
44 }
45 
46 
47 
48 
49 contract PauserRole {
50   using Roles for Roles.Role;
51 
52   event PauserAdded(address indexed account);
53   event PauserRemoved(address indexed account);
54 
55   Roles.Role private pausers;
56 
57   constructor() internal {
58     _addPauser(msg.sender);
59   }
60 
61   modifier onlyPauser() {
62     require(isPauser(msg.sender));
63     _;
64   }
65 
66   function isPauser(address account) public view returns (bool) {
67     return pausers.has(account);
68   }
69 
70   function addPauser(address account) public onlyPauser {
71     _addPauser(account);
72   }
73 
74   function renouncePauser() public {
75     _removePauser(msg.sender);
76   }
77 
78   function _addPauser(address account) internal {
79     pausers.add(account);
80     emit PauserAdded(account);
81   }
82 
83   function _removePauser(address account) internal {
84     pausers.remove(account);
85     emit PauserRemoved(account);
86   }
87 }
88 
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 interface IERC20 {
95   function totalSupply() external view returns (uint256);
96 
97   function balanceOf(address who) external view returns (uint256);
98 
99   function allowance(address owner, address spender)
100     external view returns (uint256);
101 
102   function transfer(address to, uint256 value) external returns (bool);
103 
104   function approve(address spender, uint256 value)
105     external returns (bool);
106 
107   function transferFrom(address from, address to, uint256 value)
108     external returns (bool);
109 
110   event Transfer(
111     address indexed from,
112     address indexed to,
113     uint256 value
114   );
115 
116   event Approval(
117     address indexed owner,
118     address indexed spender,
119     uint256 value
120   );
121 }
122 
123 
124 
125 
126 
127 
128 /**
129  * @title Pausable
130  * @dev Base contract which allows children to implement an emergency stop mechanism.
131  */
132 contract Pausable is PauserRole {
133   event Paused(address account);
134   event Unpaused(address account);
135 
136   bool private _paused;
137 
138   constructor() internal {
139     _paused = false;
140   }
141 
142   /**
143    * @return true if the contract is paused, false otherwise.
144    */
145   function paused() public view returns(bool) {
146     return _paused;
147   }
148 
149   /**
150    * @dev Modifier to make a function callable only when the contract is not paused.
151    */
152   modifier whenNotPaused() {
153     require(!_paused);
154     _;
155   }
156 
157   /**
158    * @dev Modifier to make a function callable only when the contract is paused.
159    */
160   modifier whenPaused() {
161     require(_paused);
162     _;
163   }
164 
165   /**
166    * @dev called by the owner to pause, triggers stopped state
167    */
168   function pause() public onlyPauser whenNotPaused {
169     _paused = true;
170     emit Paused(msg.sender);
171   }
172 
173   /**
174    * @dev called by the owner to unpause, returns to normal state
175    */
176   function unpause() public onlyPauser whenPaused {
177     _paused = false;
178     emit Unpaused(msg.sender);
179   }
180 }
181 
182 
183 
184 /**
185  * @title Ownable
186  * @dev The Ownable contract has an owner address, and provides basic authorization control
187  * functions, this simplifies the implementation of "user permissions".
188  */
189 contract Ownable {
190   address private _owner;
191 
192   event OwnershipTransferred(
193     address indexed previousOwner,
194     address indexed newOwner
195   );
196 
197   /**
198    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
199    * account.
200    */
201   constructor() internal {
202     _owner = msg.sender;
203     emit OwnershipTransferred(address(0), _owner);
204   }
205 
206   /**
207    * @return the address of the owner.
208    */
209   function owner() public view returns(address) {
210     return _owner;
211   }
212 
213   /**
214    * @dev Throws if called by any account other than the owner.
215    */
216   modifier onlyOwner() {
217     require(isOwner());
218     _;
219   }
220 
221   /**
222    * @return true if `msg.sender` is the owner of the contract.
223    */
224   function isOwner() public view returns(bool) {
225     return msg.sender == _owner;
226   }
227 
228   /**
229    * @dev Allows the current owner to relinquish control of the contract.
230    * @notice Renouncing to ownership will leave the contract without an owner.
231    * It will not be possible to call the functions with the `onlyOwner`
232    * modifier anymore.
233    */
234   function renounceOwnership() public onlyOwner {
235     emit OwnershipTransferred(_owner, address(0));
236     _owner = address(0);
237   }
238 
239   /**
240    * @dev Allows the current owner to transfer control of the contract to a newOwner.
241    * @param newOwner The address to transfer ownership to.
242    */
243   function transferOwnership(address newOwner) public onlyOwner {
244     _transferOwnership(newOwner);
245   }
246 
247   /**
248    * @dev Transfers control of the contract to a newOwner.
249    * @param newOwner The address to transfer ownership to.
250    */
251   function _transferOwnership(address newOwner) internal {
252     require(newOwner != address(0));
253     emit OwnershipTransferred(_owner, newOwner);
254     _owner = newOwner;
255   }
256 }
257 
258 
259 
260 /**
261  * @title SafeMath
262  * @dev Math operations with safety checks that revert on error
263  */
264 library SafeMath {
265 
266   /**
267   * @dev Multiplies two numbers, reverts on overflow.
268   */
269   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
270     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
271     // benefit is lost if 'b' is also tested.
272     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
273     if (a == 0) {
274       return 0;
275     }
276 
277     uint256 c = a * b;
278     require(c / a == b);
279 
280     return c;
281   }
282 
283   /**
284   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
285   */
286   function div(uint256 a, uint256 b) internal pure returns (uint256) {
287     require(b > 0); // Solidity only automatically asserts when dividing by 0
288     uint256 c = a / b;
289     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
290 
291     return c;
292   }
293 
294   /**
295   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
296   */
297   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
298     require(b <= a);
299     uint256 c = a - b;
300 
301     return c;
302   }
303 
304   /**
305   * @dev Adds two numbers, reverts on overflow.
306   */
307   function add(uint256 a, uint256 b) internal pure returns (uint256) {
308     uint256 c = a + b;
309     require(c >= a);
310 
311     return c;
312   }
313 
314   /**
315   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
316   * reverts when dividing by zero.
317   */
318   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
319     require(b != 0);
320     return a % b;
321   }
322 }
323 
324 
325 
326 
327 /**
328  * @title Elliptic curve signature operations
329  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
330  * TODO Remove this library once solidity supports passing a signature to ecrecover.
331  * See https://github.com/ethereum/solidity/issues/864
332  */
333 
334 library ECDSA {
335 
336   /**
337    * @dev Recover signer address from a message by using their signature
338    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
339    * @param signature bytes signature, the signature is generated using web3.eth.sign()
340    */
341   function recover(bytes32 hash, bytes signature)
342     internal
343     pure
344     returns (address)
345   {
346     bytes32 r;
347     bytes32 s;
348     uint8 v;
349 
350     // Check the signature length
351     if (signature.length != 65) {
352       return (address(0));
353     }
354 
355     // Divide the signature in r, s and v variables
356     // ecrecover takes the signature parameters, and the only way to get them
357     // currently is to use assembly.
358     // solium-disable-next-line security/no-inline-assembly
359     assembly {
360       r := mload(add(signature, 0x20))
361       s := mload(add(signature, 0x40))
362       v := byte(0, mload(add(signature, 0x60)))
363     }
364 
365     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
366     if (v < 27) {
367       v += 27;
368     }
369 
370     // If the version is correct return the signer address
371     if (v != 27 && v != 28) {
372       return (address(0));
373     } else {
374       // solium-disable-next-line arg-overflow
375       return ecrecover(hash, v, r, s);
376     }
377   }
378 
379   /**
380    * toEthSignedMessageHash
381    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
382    * and hash the result
383    */
384   function toEthSignedMessageHash(bytes32 hash)
385     internal
386     pure
387     returns (bytes32)
388   {
389     // 32 is the length in bytes of hash,
390     // enforced by the type signature above
391     return keccak256(
392       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
393     );
394   }
395 }
396 
397 
398 contract BMng is Pausable, Ownable {
399   using SafeMath for uint256;
400 
401   enum TokenStatus {
402     Unknown,
403     Active,
404     Suspended
405   }
406 
407   struct Token {
408     TokenStatus status;
409     uint256 rewardRateNumerator;
410     uint256 rewardRateDenominator;
411     uint256 burned;
412     uint256 burnedAccumulator;
413     uint256 suspiciousVolume; // provided during registration
414   }
415 
416   event Auth(
417     address indexed burner,
418     address indexed partner
419   );
420 
421   event Burn(
422     address indexed token,
423     address indexed burner,
424     address partner,
425     uint256 value,
426     uint256 bValue,
427     uint256 bValuePartner
428   );
429 
430   event DiscountUpdate(
431     uint256 discountNumerator,
432     uint256 discountDenominator,
433     uint256 balanceThreshold
434   );
435 
436   address constant burnAddress = 0x000000000000000000000000000000000000dEaD;
437 
438   // Lifetime parameters (set on initialization)
439   string public name;
440   IERC20 bToken; // BurnToken address
441   uint256 discountNumeratorMul;
442   uint256 discountDenominatorMul;
443   uint256 bonusNumerator;
444   uint256 bonusDenominator;
445   uint256 public initialBlockNumber;
446 
447   // Evolving parameters
448   uint256 discountNumerator;
449   uint256 discountDenominator;
450   uint256 balanceThreshold;
451 
452   // Managable parameters 
453   address registrator;
454   address defaultPartner;
455   uint256 partnerRewardRateNumerator;
456   uint256 partnerRewardRateDenominator;
457   bool permissionRequired;
458 
459   mapping (address => Token) public tokens;
460   mapping (address => address) referalPartners; // Users associated with referrals
461   mapping (address => mapping (address => uint256)) burnedByTokenUser; // Counters
462   mapping (bytes6 => address) refLookup; // Reference codes
463   mapping (address => bool) public shouldGetBonus; // Bonuses
464   mapping (address => uint256) public nonces; // Nonces for permissions
465 
466   constructor(
467     address bTokenAddress, 
468     address _registrator, 
469     address _defaultPartner,
470     uint256 initialBalance
471   ) 
472   public 
473   {
474     name = "Burn Token Management Contract v0.3";
475     registrator = _registrator;
476     defaultPartner = _defaultPartner;
477     bToken = IERC20(bTokenAddress);
478     initialBlockNumber = block.number;
479 
480     // Initially no permission needed for each burn
481     permissionRequired = false;
482 
483     // Formal referals for registrator and defaultPartner
484     referalPartners[registrator] = burnAddress;
485     referalPartners[defaultPartner] = burnAddress;
486 
487     // Reward rate 15% for each referral burning
488     partnerRewardRateNumerator = 15;
489     partnerRewardRateDenominator = 100;
490 
491     // 20% bonus for using referal link
492     bonusNumerator = 20;
493     bonusDenominator = 100;
494 
495     // discount 5% each time when when 95% of the balance spent
496     discountNumeratorMul = 95;
497     discountDenominatorMul = 100;
498 
499     discountNumerator = 1;
500     discountDenominator = 1;
501     balanceThreshold = initialBalance.mul(discountNumeratorMul).div(discountDenominatorMul);
502   }
503 
504   // --------------------------------------------------------------------------
505   // Administration fuctionality
506   
507   function claimBurnTokensBack(address to) public onlyOwner {
508     // This is necessary to finalize the contract lifecicle 
509     uint256 remainingBalance = bToken.balanceOf(address(this));
510     bToken.transfer(to, remainingBalance);
511   }
512 
513   function registerToken(
514     address tokenAddress, 
515     uint256 suspiciousVolume,
516     uint256 rewardRateNumerator,
517     uint256 rewardRateDenominator,
518     bool activate
519   ) 
520     public 
521     onlyOwner 
522   {
523     // require(tokens[tokenAddress].status == TokenStatus.Unknown, "Cannot register more than one time");
524     Token memory token;
525     if (activate) {
526       token.status = TokenStatus.Active;
527     } else {
528       token.status = TokenStatus.Suspended;
529     }    
530     token.rewardRateNumerator = rewardRateNumerator;
531     token.rewardRateDenominator = rewardRateDenominator;
532     token.suspiciousVolume = suspiciousVolume;
533     tokens[tokenAddress] = token;
534   }
535 
536   function changeRegistrator(address newRegistrator) public onlyOwner {
537     registrator = newRegistrator;
538   }
539 
540   function changeDefaultPartnerAddress(address newDefaultPartner) public onlyOwner {
541     defaultPartner = newDefaultPartner;
542   }
543 
544   
545   function setRewardRateForToken(
546     address tokenAddress,
547     uint256 rewardRateNumerator,
548     uint256 rewardRateDenominator
549   )
550     public 
551     onlyOwner 
552   {
553     require(tokens[tokenAddress].status != TokenStatus.Unknown, "Token should be registered first");
554     tokens[tokenAddress].rewardRateNumerator = rewardRateNumerator;
555     tokens[tokenAddress].rewardRateDenominator = rewardRateDenominator;
556   }
557   
558 
559   function setPartnerRewardRate(
560     uint256 newPartnerRewardRateNumerator,
561     uint256 newPartnerRewardRateDenominator
562   )
563     public 
564     onlyOwner 
565   {
566     partnerRewardRateNumerator = newPartnerRewardRateNumerator;
567     partnerRewardRateDenominator = newPartnerRewardRateDenominator;
568   }
569 
570   function setPermissionRequired(bool state) public onlyOwner {
571     permissionRequired = state;
572   }
573 
574   function suspend(address tokenAddress) public onlyOwner {
575     require(tokens[tokenAddress].status != TokenStatus.Unknown, "Token should be registered first");
576     tokens[tokenAddress].status = TokenStatus.Suspended;
577   }
578 
579   function unSuspend(address tokenAddress) public onlyOwner {
580     require(tokens[tokenAddress].status != TokenStatus.Unknown, "Token should be registered first");
581     tokens[tokenAddress].status = TokenStatus.Active;
582     tokens[tokenAddress].burnedAccumulator = 0;
583   }
584 
585   function activate(address tokenAddress) public onlyOwner {
586     require(tokens[tokenAddress].status != TokenStatus.Unknown, "Token should be registered first");
587     tokens[tokenAddress].status = TokenStatus.Active;
588   }
589 
590   // END of Administration fuctionality
591   // --------------------------------------------------------------------------
592 
593   modifier whenNoPermissionRequired() {
594     require(!isPermissionRequired(), "Need a permission");
595     _;
596   }
597 
598   function isPermissionRequired() public view returns (bool) {
599     // if burn can only occure by signed permission
600     return permissionRequired;
601   }
602 
603   function isAuthorized(address user) public view whenNotPaused returns (bool) {
604     address partner = referalPartners[user];
605     return partner != address(0);
606   }
607 
608   function amountBurnedTotal(address tokenAddress) public view returns (uint256) {
609     return tokens[tokenAddress].burned;
610   }
611 
612   function amountBurnedByUser(address tokenAddress, address user) public view returns (uint256) {
613     return burnedByTokenUser[tokenAddress][user];
614   }
615 
616   // Ref code
617   function getRefByAddress(address user) public pure returns (bytes6) {
618     /* 
619       We use Base58 encoding and want refcode length to be 8 symbols 
620       bits = log2(58) * 8 = 46.86384796102058 = 40 + 6.86384796102058
621       2^(40 + 6.86384796102058) = 0x100^5 * 116.4726943 ~ 0x100^5 * 116
622       CEIL(47 / 8) = 6
623       Output: bytes6 (48 bits)
624       In such case for 10^6 records we have 0.39% hash collision probability 
625       (see: https://preshing.com/20110504/hash-collision-probabilities/)
626     */ 
627     bytes32 dataHash = keccak256(abi.encodePacked(user, "BUTK"));
628     bytes32 tmp = bytes32(uint256(dataHash) % uint256(116 * 0x10000000000));
629     return bytes6(tmp << 26 * 8);
630   }
631 
632   function getAddressByRef(bytes6 ref) public view returns (address) {
633     return refLookup[ref];
634   }
635 
636   function saveRef(address user) private returns (bool) {
637     require(user != address(0), "Should not be zero address");
638     bytes6 ref = getRefByAddress(user);
639     refLookup[ref] = user;
640     return true;
641   }
642 
643   function checkSignature(bytes memory sig, address user) public view returns (bool) {
644     bytes32 dataHash = keccak256(abi.encodePacked(user));
645     return (ECDSA.recover(dataHash, sig) == registrator);
646   }
647 
648   function checkPermissionSignature(
649     bytes memory sig, 
650     address user, 
651     address tokenAddress,
652     uint256 value,
653     uint256 nonce
654   ) 
655     public view returns (bool) 
656   {
657     bytes32 dataHash = keccak256(abi.encodePacked(user, tokenAddress, value, nonce));
658     return (ECDSA.recover(dataHash, sig) == registrator);
659   }
660 
661   function authorizeAddress(bytes memory authSignature, bytes6 ref) public whenNotPaused returns (bool) {
662     // require(false, "Test fail");
663     require(checkSignature(authSignature, msg.sender) == true, "Authorization should be signed by registrator");
664     require(isAuthorized(msg.sender) == false, "No need to authorize more then once");
665     address refAddress = getAddressByRef(ref);
666     address partner = (refAddress == address(0)) ? defaultPartner : refAddress;
667 
668     // Create ref code (register as a partner)
669     saveRef(msg.sender);
670 
671     referalPartners[msg.sender] = partner;
672 
673     // Only if ref code is used authorized to get extra bonus
674     if (partner != defaultPartner) {
675       shouldGetBonus[msg.sender] = true;
676     }
677 
678     emit Auth(msg.sender, partner);
679 
680     return true;
681   }
682 
683   function suspendIfNecessary(address tokenAddress) private returns (bool) {
684     // When 10% of totalSupply is burned suspend the token just in case 
685     // there is a chance that its contract is broken
686     if (tokens[tokenAddress].burnedAccumulator > tokens[tokenAddress].suspiciousVolume) {
687       tokens[tokenAddress].status = TokenStatus.Suspended;
688       return true;
689     }
690     return false;
691   }
692 
693   // Discount
694   function discountCorrectionIfNecessary(uint256 balance) private returns (bool) {
695     if (balance < balanceThreshold) {
696       // Update discountNumerator, discountDenominator and balanceThreshold
697       // we multiply discount coefficient by discountNumeratorMul / discountDenominatorMul
698       discountNumerator = discountNumerator.mul(discountNumeratorMul);
699       discountDenominator = discountDenominator.mul(discountDenominatorMul);
700       balanceThreshold = balanceThreshold.mul(discountNumeratorMul).div(discountDenominatorMul);
701       emit DiscountUpdate(discountNumerator, discountDenominator, balanceThreshold);
702       return true;
703     }
704     return false;
705   }
706 
707   // Helpers
708   function getAllTokenData(
709     address tokenAddress,
710     address user
711   )
712     public view returns (uint256, uint256, uint256, uint256, bool) 
713   {
714     IERC20 tokenContract = IERC20(tokenAddress);
715     uint256 balance = tokenContract.balanceOf(user);
716     uint256 allowance = tokenContract.allowance(user, address(this));
717     uint256 burnedByUser = amountBurnedByUser(tokenAddress, user);
718     uint256 burnedTotal = amountBurnedTotal(tokenAddress);
719     bool isActive = (tokens[tokenAddress].status == TokenStatus.Active);
720     return (balance, allowance, burnedByUser, burnedTotal, isActive);
721   }
722 
723   function getBTokenValue(
724     address tokenAddress, 
725     uint256 value
726   )
727     public view returns (uint256) 
728   {
729     Token memory tokenRec = tokens[tokenAddress];
730     require(tokenRec.status == TokenStatus.Active, "Token should be in active state");
731     uint256 denominator = tokenRec.rewardRateDenominator;
732     require(denominator > 0, "Reward denominator should not be zero");
733     uint256 numerator = tokenRec.rewardRateNumerator;
734     uint256 bTokenValue = value.mul(numerator).div(denominator);
735     // Discount
736     uint256 discountedBTokenValue = bTokenValue.mul(discountNumerator).div(discountDenominator);
737     return discountedBTokenValue;
738   } 
739 
740   function getPartnerReward(uint256 bTokenValue) public view returns (uint256) {
741     return bTokenValue.mul(partnerRewardRateNumerator).div(partnerRewardRateDenominator);
742   }
743 
744   function burn(
745     address tokenAddress, 
746     uint256 value
747   )
748     public 
749     whenNotPaused
750     whenNoPermissionRequired
751   {
752     _burn(tokenAddress, value);
753   }
754 
755   function burnPermissioned(
756     address tokenAddress, 
757     uint256 value,
758     uint256 nonce,
759     bytes memory permissionSignature
760   )
761     public 
762     whenNotPaused
763   {
764     require(nonces[msg.sender] < nonce, "New nonce should be greater than previous");
765     bool signatureOk = checkPermissionSignature(permissionSignature, msg.sender, tokenAddress, value, nonce);
766     require(signatureOk, "Permission should have a correct signature");
767     nonces[msg.sender] = nonce;
768     _burn(tokenAddress, value);
769   }
770 
771   function _burn(address tokenAddress, uint256 value) private {
772     address partner = referalPartners[msg.sender];
773     require(partner != address(0), "Burner should be registered");
774     
775     IERC20 tokenContract = IERC20(tokenAddress);
776     
777     require(tokenContract.allowance(msg.sender, address(this)) >= value, "Should be allowed");
778  
779     uint256 bTokenValueTotal; // total user reward including bonus if allowed
780     uint256 bTokenValue = getBTokenValue(tokenAddress, value);
781     uint256 currentBalance = bToken.balanceOf(address(this));
782     require(bTokenValue < currentBalance.div(100), "Cannot reward more than 1% of the balance");
783 
784     uint256 bTokenPartnerReward = getPartnerReward(bTokenValue);
785     
786     // Update counters
787     tokens[tokenAddress].burned = tokens[tokenAddress].burned.add(value);
788     tokens[tokenAddress].burnedAccumulator = tokens[tokenAddress].burnedAccumulator.add(value);
789     burnedByTokenUser[tokenAddress][msg.sender] = burnedByTokenUser[tokenAddress][msg.sender].add(value);
790     
791     tokenContract.transferFrom(msg.sender, burnAddress, value); // burn shit-token
792     discountCorrectionIfNecessary(currentBalance.sub(bTokenValue).sub(bTokenPartnerReward));
793     
794     suspendIfNecessary(tokenAddress);
795 
796     bToken.transfer(partner, bTokenPartnerReward);
797 
798     if (shouldGetBonus[msg.sender]) {
799       // give 20% bonus once
800       shouldGetBonus[msg.sender] = false;
801       bTokenValueTotal = bTokenValue.add(bTokenValue.mul(bonusNumerator).div(bonusDenominator));
802     } else {
803       bTokenValueTotal = bTokenValue;
804     }
805 
806     bToken.transfer(msg.sender, bTokenValueTotal);
807     emit Burn(tokenAddress, msg.sender, partner, value, bTokenValueTotal, bTokenPartnerReward);
808   }
809 }