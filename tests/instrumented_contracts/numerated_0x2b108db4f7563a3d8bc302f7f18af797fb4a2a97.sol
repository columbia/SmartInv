1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount)
26         external
27         returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender)
37         external
38         view
39         returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(
85         address indexed owner,
86         address indexed spender,
87         uint256 value
88     );
89 }
90 
91 // CAUTION
92 // This version of SafeMath should only be used with Solidity 0.8 or later,
93 // because it relies on the compiler's built in overflow checks.
94 
95 /**
96  * @dev Wrappers over Solidity's arithmetic operations.
97  *
98  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
99  * now has built in overflow checking.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, with an overflow flag.
104      *
105      * _Available since v3.4._
106      */
107     function tryAdd(uint256 a, uint256 b)
108         internal
109         pure
110         returns (bool, uint256)
111     {
112         unchecked {
113             uint256 c = a + b;
114             if (c < a) return (false, 0);
115             return (true, c);
116         }
117     }
118 
119     /**
120      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
121      *
122      * _Available since v3.4._
123      */
124     function trySub(uint256 a, uint256 b)
125         internal
126         pure
127         returns (bool, uint256)
128     {
129         unchecked {
130             if (b > a) return (false, 0);
131             return (true, a - b);
132         }
133     }
134 
135     /**
136      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
137      *
138      * _Available since v3.4._
139      */
140     function tryMul(uint256 a, uint256 b)
141         internal
142         pure
143         returns (bool, uint256)
144     {
145         unchecked {
146             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
147             // benefit is lost if 'b' is also tested.
148             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
149             if (a == 0) return (true, 0);
150             uint256 c = a * b;
151             if (c / a != b) return (false, 0);
152             return (true, c);
153         }
154     }
155 
156     /**
157      * @dev Returns the division of two unsigned integers, with a division by zero flag.
158      *
159      * _Available since v3.4._
160      */
161     function tryDiv(uint256 a, uint256 b)
162         internal
163         pure
164         returns (bool, uint256)
165     {
166         unchecked {
167             if (b == 0) return (false, 0);
168             return (true, a / b);
169         }
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
174      *
175      * _Available since v3.4._
176      */
177     function tryMod(uint256 a, uint256 b)
178         internal
179         pure
180         returns (bool, uint256)
181     {
182         unchecked {
183             if (b == 0) return (false, 0);
184             return (true, a % b);
185         }
186     }
187 
188     /**
189      * @dev Returns the addition of two unsigned integers, reverting on
190      * overflow.
191      *
192      * Counterpart to Solidity's `+` operator.
193      *
194      * Requirements:
195      *
196      * - Addition cannot overflow.
197      */
198     function add(uint256 a, uint256 b) internal pure returns (uint256) {
199         return a + b;
200     }
201 
202     /**
203      * @dev Returns the subtraction of two unsigned integers, reverting on
204      * overflow (when the result is negative).
205      *
206      * Counterpart to Solidity's `-` operator.
207      *
208      * Requirements:
209      *
210      * - Subtraction cannot overflow.
211      */
212     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
213         return a - b;
214     }
215 
216     /**
217      * @dev Returns the multiplication of two unsigned integers, reverting on
218      * overflow.
219      *
220      * Counterpart to Solidity's `*` operator.
221      *
222      * Requirements:
223      *
224      * - Multiplication cannot overflow.
225      */
226     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
227         return a * b;
228     }
229 
230     /**
231      * @dev Returns the integer division of two unsigned integers, reverting on
232      * division by zero. The result is rounded towards zero.
233      *
234      * Counterpart to Solidity's `/` operator.
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function div(uint256 a, uint256 b) internal pure returns (uint256) {
241         return a / b;
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * reverting when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257         return a % b;
258     }
259 
260     /**
261      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
262      * overflow (when the result is negative).
263      *
264      * CAUTION: This function is deprecated because it requires allocating memory for the error
265      * message unnecessarily. For custom revert reasons use {trySub}.
266      *
267      * Counterpart to Solidity's `-` operator.
268      *
269      * Requirements:
270      *
271      * - Subtraction cannot overflow.
272      */
273     function sub(
274         uint256 a,
275         uint256 b,
276         string memory errorMessage
277     ) internal pure returns (uint256) {
278         unchecked {
279             require(b <= a, errorMessage);
280             return a - b;
281         }
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
286      * division by zero. The result is rounded towards zero.
287      *
288      * Counterpart to Solidity's `/` operator. Note: this function uses a
289      * `revert` opcode (which leaves remaining gas untouched) while Solidity
290      * uses an invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function div(
297         uint256 a,
298         uint256 b,
299         string memory errorMessage
300     ) internal pure returns (uint256) {
301         unchecked {
302             require(b > 0, errorMessage);
303             return a / b;
304         }
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * reverting with custom message when dividing by zero.
310      *
311      * CAUTION: This function is deprecated because it requires allocating memory for the error
312      * message unnecessarily. For custom revert reasons use {tryMod}.
313      *
314      * Counterpart to Solidity's `%` operator. This function uses a `revert`
315      * opcode (which leaves remaining gas untouched) while Solidity uses an
316      * invalid opcode to revert (consuming all remaining gas).
317      *
318      * Requirements:
319      *
320      * - The divisor cannot be zero.
321      */
322     function mod(
323         uint256 a,
324         uint256 b,
325         string memory errorMessage
326     ) internal pure returns (uint256) {
327         unchecked {
328             require(b > 0, errorMessage);
329             return a % b;
330         }
331     }
332 }
333 
334 abstract contract Context {
335     function _msgSender() internal view virtual returns (address) {
336         return msg.sender;
337     }
338 
339     function _msgData() internal view virtual returns (bytes calldata) {
340         return msg.data;
341     }
342 }
343 
344 abstract contract Ownable is Context {
345     address private _owner;
346 
347     event OwnershipTransferred(
348         address indexed previousOwner,
349         address indexed newOwner
350     );
351 
352     /**
353      * @dev Initializes the contract setting the deployer as the initial owner.
354      */
355     constructor() {
356         _setOwner(_msgSender());
357     }
358 
359     /**
360      * @dev Returns the address of the current owner.
361      */
362     function owner() public view virtual returns (address) {
363         return _owner;
364     }
365 
366     /**
367      * @dev Throws if called by any account other than the owner.
368      */
369     modifier onlyOwner() {
370         require(owner() == _msgSender(), "Ownable: caller is not the owner");
371         _;
372     }
373 
374     /**
375      * @dev Transfers ownership of the contract to a new account (`newOwner`).
376      * Can only be called by the current owner.
377      */
378     function transferOwnership(address newOwner) public virtual onlyOwner {
379         require(
380             newOwner != address(0),
381             "Ownable: new owner is the zero address"
382         );
383         _setOwner(newOwner);
384     }
385 
386     function _setOwner(address newOwner) private {
387         address oldOwner = _owner;
388         _owner = newOwner;
389         emit OwnershipTransferred(oldOwner, newOwner);
390     }
391 }
392 
393 interface IGenArtInterface {
394     function getMaxMintForMembership(uint256 _membershipId)
395         external
396         view
397         returns (uint256);
398 
399     function getMaxMintForOwner(address owner) external view returns (uint256);
400 
401     function upgradeGenArtTokenContract(address _genArtTokenAddress) external;
402 
403     function setAllowGen(bool allow) external;
404 
405     function genAllowed() external view returns (bool);
406 
407     function isGoldToken(uint256 _membershipId) external view returns (bool);
408 
409     function transferFrom(
410         address _from,
411         address _to,
412         uint256 _amount
413     ) external;
414 
415     function balanceOf(address _owner) external view returns (uint256);
416 
417     function ownerOf(uint256 _membershipId) external view returns (address);
418 }
419 
420 interface IGenArt {
421     function getTokensByOwner(address owner)
422         external
423         view
424         returns (uint256[] memory);
425 
426     function ownerOf(uint256 tokenId) external view returns (address);
427 
428     function isGoldToken(uint256 _tokenId) external view returns (bool);
429 }
430 
431 contract GenArtTreasury is Ownable {
432     struct Partner {
433         uint256 vestingAmount;
434         uint256 claimedAmount;
435         uint256 vestingBegin;
436         uint256 vestingEnd;
437     }
438 
439     using SafeMath for uint256;
440 
441     address genartToken;
442     address genArtInterfaceAddress;
443     address genArtMembershipAddress;
444     uint256 vestingBegin;
445     uint256 vestingEnd;
446 
447     // 100mm total token supply
448     uint256 liqTokenAmount = 10_000_000 * 10**18; // 10mm
449     uint256 treasuryTokenAmount = 37_000_000 * 10**18; // 37mm
450     uint256 teamMemberTokenAmount = 3_750_000 * 10**18; // 4 team members: 15mm
451     uint256 standardMemberTokenAmount = 4_000 * 10**18; // 5k members: 20mm
452     uint256 goldMemberTokenAmount = 20_000 * 10**18; // 100 gold members: 2mm
453     uint256 marketingTokenAmount = 6_000_000 * 10**18; // 6mm
454     uint256 partnerTokenAmount = 10_000_000 * 10**18; // 10mm
455 
456     uint256 totalOwnerWithdrawAmount = 0; // total amount withdrawn by withdraw function
457     uint256 spendPartnerTokens = 0;
458 
459     mapping(address => uint256) nonces;
460     mapping(address => uint256) partnerClaims;
461     mapping(address => uint256) teamClaimedAmount;
462     mapping(uint256 => bool) membershipClaims;
463     mapping(address => bool) teamMembers;
464     mapping(address => Partner) partners;
465 
466     constructor(
467         address genArtInterfaceAddress_,
468         address genArtMembershipAddress_,
469         uint256 vestingBegin_,
470         uint256 vestingEnd_,
471         address teamMember1_,
472         address teamMember2_,
473         address teamMember3_,
474         address teamMember4_
475     ) {
476         require(
477             vestingBegin_ >= block.timestamp,
478             "GenArtTreasury: vesting begin too early"
479         );
480         require(
481             vestingEnd_ > vestingBegin_,
482             "GenArtTreasury: vesting end too early"
483         );
484         genArtMembershipAddress = genArtMembershipAddress_;
485         genArtInterfaceAddress = genArtInterfaceAddress_;
486         vestingBegin = vestingBegin_;
487         vestingEnd = vestingEnd_;
488 
489         teamMembers[teamMember1_] = true;
490         teamMembers[teamMember2_] = true;
491         teamMembers[teamMember3_] = true;
492         teamMembers[teamMember4_] = true;
493     }
494 
495     function claimTokensAllMemberships() public {
496         uint256[] memory memberships = IGenArt(genArtMembershipAddress)
497             .getTokensByOwner(msg.sender);
498         for (uint256 i = 0; i < memberships.length; i++) {
499             claimTokensMembership(memberships[i]);
500         }
501     }
502 
503     function claimTokensMembership(uint256 membershipId_) public {
504         if (!membershipClaims[membershipId_]) {
505             address owner = IGenArt(genArtMembershipAddress).ownerOf(
506                 membershipId_
507             );
508             bool isGold = IGenArtInterface(genArtInterfaceAddress).isGoldToken(
509                 membershipId_
510             );
511             require(
512                 owner == msg.sender,
513                 "GenArtTreasury: only owner can claim tokens"
514             );
515             IERC20(genartToken).transfer(
516                 owner,
517                 (isGold ? goldMemberTokenAmount : standardMemberTokenAmount)
518             );
519             membershipClaims[membershipId_] = true;
520         }
521     }
522 
523     function withdraw(uint256 _amount, address _to) public onlyOwner {
524         uint256 maxWithdrawAmount = liqTokenAmount +
525             treasuryTokenAmount +
526             marketingTokenAmount;
527         uint256 newWithdrawAmount = _amount.add(totalOwnerWithdrawAmount);
528 
529         require(
530             newWithdrawAmount <= maxWithdrawAmount,
531             "GenArtTreasury: amount would excceed limit"
532         );
533         IERC20(genartToken).transfer(_to, _amount);
534         totalOwnerWithdrawAmount = newWithdrawAmount;
535     }
536 
537     function calcVestedAmount(
538         uint256 startDate_,
539         uint256 endDate_,
540         uint256 amount_
541     ) public view returns (uint256) {
542         if (block.timestamp >= endDate_) {
543             return amount_;
544         }
545         uint256 fractions = amount_.div(endDate_.sub(startDate_));
546         return fractions.mul(block.timestamp.sub(startDate_));
547     }
548 
549     function claimTokensTeamMember(address to_) public {
550         address teamMember = msg.sender;
551 
552         require(
553             teamMembers[teamMember],
554             "GenArtTreasury: caller is not team member"
555         );
556         require(
557             teamClaimedAmount[teamMember] < teamMemberTokenAmount,
558             "GenArtTreasury: no tokens to claim"
559         );
560         uint256 vestedAmount = calcVestedAmount(
561             vestingBegin,
562             vestingEnd,
563             teamMemberTokenAmount
564         );
565 
566         uint256 payoutAmount = vestedAmount.sub(teamClaimedAmount[teamMember]);
567         IERC20(genartToken).transfer(to_, payoutAmount);
568         teamClaimedAmount[teamMember] = payoutAmount.add(
569             teamClaimedAmount[teamMember]
570         );
571     }
572 
573     function claimTokensPartner(address to_) public {
574         Partner memory partner = partners[msg.sender];
575         require(
576             block.number > nonces[msg.sender],
577             "GenArtTreasury: another transaction in progress"
578         );
579         nonces[msg.sender] = block.number;
580         require(
581             partner.vestingAmount > 0,
582             "GenArtTreasury: caller is not partner"
583         );
584         require(
585             partner.claimedAmount < partner.vestingAmount,
586             "GenArtTreasury: no tokens to claim"
587         );
588         uint256 vestedAmount = calcVestedAmount(
589             partner.vestingBegin,
590             partner.vestingEnd,
591             partner.vestingAmount
592         );
593         uint256 payoutAmount = vestedAmount.sub(partner.claimedAmount);
594         IERC20(genartToken).transfer(to_, payoutAmount);
595         partners[msg.sender].claimedAmount = payoutAmount.add(
596             partner.claimedAmount
597         );
598     }
599 
600     function addPartner(
601         address wallet_,
602         uint256 vestingBegin_,
603         uint256 vestingEnd_,
604         uint256 vestingAmount_
605     ) public onlyOwner {
606         require(
607             partners[wallet_].vestingAmount == 0,
608             "GenArtTreasury: partner already added"
609         );
610         require(spendPartnerTokens.add(vestingAmount_) <= partnerTokenAmount);
611         partners[wallet_] = Partner({
612             vestingBegin: vestingBegin_,
613             vestingEnd: vestingEnd_,
614             vestingAmount: vestingAmount_,
615             claimedAmount: 0
616         });
617 
618         spendPartnerTokens = spendPartnerTokens.add(vestingAmount_);
619     }
620 
621     function updateGenArtInterfaceAddress(address newAddress_)
622         public
623         onlyOwner
624     {
625         genArtInterfaceAddress = newAddress_;
626     }
627 
628     function updateGenArtTokenAddress(address newAddress_) public onlyOwner {
629         genartToken = newAddress_;
630     }
631 
632     function calcUnclaimedTeamTokenAmount(address account)
633         public
634         view
635         returns (uint256)
636     {
637         return teamMemberTokenAmount.sub(teamClaimedAmount[account]);
638     }
639 
640     function isTeamMember(address account) public view returns (bool) {
641         return teamMembers[account];
642     }
643 }