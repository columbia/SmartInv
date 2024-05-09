1 // File: browser/ReentrancyGuard.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module that helps prevent reentrant calls to a function.
7  *
8  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
9  * available, which can be applied to functions to make sure there are no nested
10  * (reentrant) calls to them.
11  *
12  * Note that because there is a single `nonReentrant` guard, functions marked as
13  * `nonReentrant` may not call one another. This can be worked around by making
14  * those functions `private`, and then adding `external` `nonReentrant` entry
15  * points to them.
16  *
17  * TIP: If you would like to learn more about reentrancy and alternative ways
18  * to protect against it, check out our blog post
19  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
20  *
21  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
22  * metering changes introduced in the Istanbul hardfork.
23  */
24 contract ReentrancyGuard {
25     bool private _notEntered;
26 
27     constructor () internal {
28         // Storing an initial non-zero value makes deployment a bit more
29         // expensive, but in exchange the refund on every call to nonReentrant
30         // will be lower in amount. Since refunds are capped to a percetange of
31         // the total transaction's gas, it is best to keep them low in cases
32         // like this one, to increase the likelihood of the full refund coming
33         // into effect.
34         _notEntered = true;
35     }
36 
37     /**
38      * @dev Prevents a contract from calling itself, directly or indirectly.
39      * Calling a `nonReentrant` function from another `nonReentrant`
40      * function is not supported. It is possible to prevent this from happening
41      * by making the `nonReentrant` function external, and make it call a
42      * `private` function that does the actual work.
43      */
44     modifier nonReentrant() {
45         // On the first call to nonReentrant, _notEntered will be true
46         require(_notEntered, "ReentrancyGuard: reentrant call");
47 
48         // Any calls to nonReentrant after this point will fail
49         _notEntered = false;
50 
51         _;
52 
53         // By storing the original value once again, a refund is triggered (see
54         // https://eips.ethereum.org/EIPS/eip-2200)
55         _notEntered = true;
56     }
57 }
58 // File: browser/IERC20.sol
59 
60 pragma solidity ^0.5.0;
61 
62 /**
63  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
64  * the optional functions; to access them see {ERC20Detailed}.
65  */
66 interface IERC20 {
67     /**
68      * @dev Returns the amount of tokens in existence.
69      */
70     function totalSupply() external view returns (uint256);
71 
72     /**
73      * @dev Returns the amount of tokens owned by `account`.
74      */
75     function balanceOf(address account) external view returns (uint256);
76 
77     /**
78      * @dev Moves `amount` tokens from the caller's account to `recipient`.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transfer(address recipient, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Returns the remaining number of tokens that `spender` will be
88      * allowed to spend on behalf of `owner` through {transferFrom}. This is
89      * zero by default.
90      *
91      * This value changes when {approve} or {transferFrom} are called.
92      */
93     function allowance(address owner, address spender) external view returns (uint256);
94 
95     /**
96      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * IMPORTANT: Beware that changing an allowance with this method brings the risk
101      * that someone may use both the old and the new allowance by unfortunate
102      * transaction ordering. One possible solution to mitigate this race
103      * condition is to first reduce the spender's allowance to 0 and set the
104      * desired value afterwards:
105      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106      *
107      * Emits an {Approval} event.
108      */
109     function approve(address spender, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Moves `amount` tokens from `sender` to `recipient` using the
113      * allowance mechanism. `amount` is then deducted from the caller's
114      * allowance.
115      *
116      * Returns a boolean value indicating whether the operation succeeded.
117      *
118      * Emits a {Transfer} event.
119      */
120     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
121 
122     /**
123      * @dev Emitted when `value` tokens are moved from one account (`from`) to
124      * another (`to`).
125      *
126      * Note that `value` may be zero.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 value);
129 
130     /**
131      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
132      * a call to {approve}. `value` is the new allowance.
133      */
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 // File: browser/SafeMath.sol
137 
138 pragma solidity ^0.5.0;
139 
140 /**
141  * @dev Wrappers over Solidity's arithmetic operations with added overflow
142  * checks.
143  *
144  * Arithmetic operations in Solidity wrap on overflow. This can easily result
145  * in bugs, because programmers usually assume that an overflow raises an
146  * error, which is the standard behavior in high level programming languages.
147  * `SafeMath` restores this intuition by reverting the transaction when an
148  * operation overflows.
149  *
150  * Using this library instead of the unchecked operations eliminates an entire
151  * class of bugs, so it's recommended to use it always.
152  */
153 library SafeMath {
154     /**
155      * @dev Returns the addition of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `+` operator.
159      *
160      * Requirements:
161      * - Addition cannot overflow.
162      */
163     function add(uint256 a, uint256 b) internal pure returns (uint256) {
164         uint256 c = a + b;
165         require(c >= a, "SafeMath: addition overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
180         return sub(a, b, "SafeMath: subtraction overflow");
181     }
182 
183     /**
184      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
185      * overflow (when the result is negative).
186      *
187      * Counterpart to Solidity's `-` operator.
188      *
189      * Requirements:
190      * - Subtraction cannot overflow.
191      *
192      * _Available since v2.4.0._
193      */
194     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b <= a, errorMessage);
196         uint256 c = a - b;
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the multiplication of two unsigned integers, reverting on
203      * overflow.
204      *
205      * Counterpart to Solidity's `*` operator.
206      *
207      * Requirements:
208      * - Multiplication cannot overflow.
209      */
210     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
211         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
212         // benefit is lost if 'b' is also tested.
213         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
214         if (a == 0) {
215             return 0;
216         }
217 
218         uint256 c = a * b;
219         require(c / a == b, "SafeMath: multiplication overflow");
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers. Reverts on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      * - The divisor cannot be zero.
234      */
235     function div(uint256 a, uint256 b) internal pure returns (uint256) {
236         return div(a, b, "SafeMath: division by zero");
237     }
238 
239     /**
240      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
241      * division by zero. The result is rounded towards zero.
242      *
243      * Counterpart to Solidity's `/` operator. Note: this function uses a
244      * `revert` opcode (which leaves remaining gas untouched) while Solidity
245      * uses an invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      * - The divisor cannot be zero.
249      *
250      * _Available since v2.4.0._
251      */
252     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         // Solidity only automatically asserts when dividing by 0
254         require(b > 0, errorMessage);
255         uint256 c = a / b;
256         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
257 
258         return c;
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263      * Reverts when dividing by zero.
264      *
265      * Counterpart to Solidity's `%` operator. This function uses a `revert`
266      * opcode (which leaves remaining gas untouched) while Solidity uses an
267      * invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      * - The divisor cannot be zero.
271      */
272     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
273         return mod(a, b, "SafeMath: modulo by zero");
274     }
275 
276     /**
277      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
278      * Reverts with custom message when dividing by zero.
279      *
280      * Counterpart to Solidity's `%` operator. This function uses a `revert`
281      * opcode (which leaves remaining gas untouched) while Solidity uses an
282      * invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      * - The divisor cannot be zero.
286      *
287      * _Available since v2.4.0._
288      */
289     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
290         require(b != 0, errorMessage);
291         return a % b;
292     }
293 }
294 // File: browser/MolochV2a.sol
295 
296 pragma solidity 0.5.3;
297 
298 
299 
300 
301 contract Moloch is ReentrancyGuard {
302     using SafeMath for uint256;
303 
304     /***************
305     GLOBAL CONSTANTS
306     ***************/
307     uint256 public periodDuration; // default = 17280 = 4.8 hours in seconds (5 periods per day)
308     uint256 public votingPeriodLength; // default = 35 periods (7 days)
309     uint256 public gracePeriodLength; // default = 35 periods (7 days)
310     uint256 public proposalDeposit; // default = 10 ETH (~$1,000 worth of ETH at contract deployment)
311     uint256 public dilutionBound; // default = 3 - maximum multiplier a YES voter will be obligated to pay in case of mass ragequit
312     uint256 public processingReward; // default = 0.1 - amount of ETH to give to whoever processes a proposal
313     uint256 public summoningTime; // needed to determine the current period
314 
315     address public depositToken; // deposit token contract reference; default = wETH
316 
317     // HARD-CODED LIMITS
318     // These numbers are quite arbitrary; they are small enough to avoid overflows when doing calculations
319     // with periods or shares, yet big enough to not limit reasonable use cases.
320     uint256 constant MAX_VOTING_PERIOD_LENGTH = 10**18; // maximum length of voting period
321     uint256 constant MAX_GRACE_PERIOD_LENGTH = 10**18; // maximum length of grace period
322     uint256 constant MAX_DILUTION_BOUND = 10**18; // maximum dilution bound
323     uint256 constant MAX_NUMBER_OF_SHARES_AND_LOOT = 10**18; // maximum number of shares that can be minted
324     uint256 constant MAX_TOKEN_WHITELIST_COUNT = 400; // maximum number of whitelisted tokens
325     uint256 constant MAX_TOKEN_GUILDBANK_COUNT = 200; // maximum number of tokens with non-zero balance in guildbank
326 
327     // ***************
328     // EVENTS
329     // ***************
330     event SummonComplete(address indexed summoner, address[] tokens, uint256 summoningTime, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 proposalDeposit, uint256 dilutionBound, uint256 processingReward);
331     event SubmitProposal(address indexed applicant, uint256 sharesRequested, uint256 lootRequested, uint256 tributeOffered, address tributeToken, uint256 paymentRequested, address paymentToken, string details, bool[6] flags, uint256 proposalId, address indexed delegateKey, address indexed memberAddress);
332     event SponsorProposal(address indexed delegateKey, address indexed memberAddress, uint256 proposalId, uint256 proposalIndex, uint256 startingPeriod);
333     event SubmitVote(uint256 proposalId, uint256 indexed proposalIndex, address indexed delegateKey, address indexed memberAddress, uint8 uintVote);
334     event ProcessProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
335     event ProcessWhitelistProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
336     event ProcessGuildKickProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
337     event Ragequit(address indexed memberAddress, uint256 sharesToBurn, uint256 lootToBurn);
338     event TokensCollected(address indexed token, uint256 amountToCollect);
339     event CancelProposal(uint256 indexed proposalId, address applicantAddress);
340     event UpdateDelegateKey(address indexed memberAddress, address newDelegateKey);
341     event Withdraw(address indexed memberAddress, address token, uint256 amount);
342 
343     // *******************
344     // INTERNAL ACCOUNTING
345     // *******************
346     uint256 public proposalCount = 0; // total proposals submitted
347     uint256 public totalShares = 0; // total shares across all members
348     uint256 public totalLoot = 0; // total loot across all members
349 
350     uint256 public totalGuildBankTokens = 0; // total tokens with non-zero balance in guild bank
351 
352     address public constant GUILD = address(0xdead);
353     address public constant ESCROW = address(0xbeef);
354     address public constant TOTAL = address(0xbabe);
355     mapping (address => mapping(address => uint256)) public userTokenBalances; // userTokenBalances[userAddress][tokenAddress]
356 
357     enum Vote {
358         Null, // default value, counted as abstention
359         Yes,
360         No
361     }
362 
363     struct Member {
364         address delegateKey; // the key responsible for submitting proposals and voting - defaults to member address unless updated
365         uint256 shares; // the # of voting shares assigned to this member
366         uint256 loot; // the loot amount available to this member (combined with shares on ragequit)
367         bool exists; // always true once a member has been created
368         uint256 highestIndexYesVote; // highest proposal index # on which the member voted YES
369         uint256 jailed; // set to proposalIndex of a passing guild kick proposal for this member, prevents voting on and sponsoring proposals
370     }
371 
372     struct Proposal {
373         address applicant; // the applicant who wishes to become a member - this key will be used for withdrawals (doubles as guild kick target for gkick proposals)
374         address proposer; // the account that submitted the proposal (can be non-member)
375         address sponsor; // the member that sponsored the proposal (moving it into the queue)
376         uint256 sharesRequested; // the # of shares the applicant is requesting
377         uint256 lootRequested; // the amount of loot the applicant is requesting
378         uint256 tributeOffered; // amount of tokens offered as tribute
379         address tributeToken; // tribute token contract reference
380         uint256 paymentRequested; // amount of tokens requested as payment
381         address paymentToken; // payment token contract reference
382         uint256 startingPeriod; // the period in which voting can start for this proposal
383         uint256 yesVotes; // the total number of YES votes for this proposal
384         uint256 noVotes; // the total number of NO votes for this proposal
385         bool[6] flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
386         string details; // proposal details - could be IPFS hash, plaintext, or JSON
387         uint256 maxTotalSharesAndLootAtYesVote; // the maximum # of total shares encountered at a yes vote on this proposal
388         mapping(address => Vote) votesByMember; // the votes on this proposal by each member
389     }
390 
391     mapping(address => bool) public tokenWhitelist;
392     address[] public approvedTokens;
393 
394     mapping(address => bool) public proposedToWhitelist;
395     mapping(address => bool) public proposedToKick;
396 
397     mapping(address => Member) public members;
398     mapping(address => address) public memberAddressByDelegateKey;
399 
400     mapping(uint256 => Proposal) public proposals;
401 
402     uint256[] public proposalQueue;
403 
404     modifier onlyMember {
405         require(members[msg.sender].shares > 0 || members[msg.sender].loot > 0, "not a member");
406         _;
407     }
408 
409     modifier onlyShareholder {
410         require(members[msg.sender].shares > 0, "not a shareholder");
411         _;
412     }
413 
414     modifier onlyDelegate {
415         require(members[memberAddressByDelegateKey[msg.sender]].shares > 0, "not a delegate");
416         _;
417     }
418 
419     constructor(
420         address _summoner,
421         address[] memory _approvedTokens,
422         uint256 _periodDuration,
423         uint256 _votingPeriodLength,
424         uint256 _gracePeriodLength,
425         uint256 _proposalDeposit,
426         uint256 _dilutionBound,
427         uint256 _processingReward
428     ) public {
429         require(_summoner != address(0), "summoner cannot be 0");
430         require(_periodDuration > 0, "_periodDuration cannot be 0");
431         require(_votingPeriodLength > 0, "_votingPeriodLength cannot be 0");
432         require(_votingPeriodLength <= MAX_VOTING_PERIOD_LENGTH, "_votingPeriodLength exceeds limit");
433         require(_gracePeriodLength <= MAX_GRACE_PERIOD_LENGTH, "_gracePeriodLength exceeds limit");
434         require(_dilutionBound > 0, "_dilutionBound cannot be 0");
435         require(_dilutionBound <= MAX_DILUTION_BOUND, "_dilutionBound exceeds limit");
436         require(_approvedTokens.length > 0, "need at least one approved token");
437         require(_approvedTokens.length <= MAX_TOKEN_WHITELIST_COUNT, "too many tokens");
438         require(_proposalDeposit >= _processingReward, "_proposalDeposit cannot be smaller than _processingReward");
439         
440         depositToken = _approvedTokens[0];
441         // NOTE: move event up here, avoid stack too deep if too many approved tokens
442         emit SummonComplete(_summoner, _approvedTokens, now, _periodDuration, _votingPeriodLength, _gracePeriodLength, _proposalDeposit, _dilutionBound, _processingReward);
443 
444 
445         for (uint256 i = 0; i < _approvedTokens.length; i++) {
446             require(_approvedTokens[i] != address(0), "_approvedToken cannot be 0");
447             require(!tokenWhitelist[_approvedTokens[i]], "duplicate approved token");
448             tokenWhitelist[_approvedTokens[i]] = true;
449             approvedTokens.push(_approvedTokens[i]);
450         }
451 
452         periodDuration = _periodDuration;
453         votingPeriodLength = _votingPeriodLength;
454         gracePeriodLength = _gracePeriodLength;
455         proposalDeposit = _proposalDeposit;
456         dilutionBound = _dilutionBound;
457         processingReward = _processingReward;
458 
459         summoningTime = now;
460 
461         members[_summoner] = Member(_summoner, 1, 0, true, 0, 0);
462         memberAddressByDelegateKey[_summoner] = _summoner;
463         totalShares = 1;
464        
465     }
466 
467     /*****************
468     PROPOSAL FUNCTIONS
469     *****************/
470     function submitProposal(
471         address applicant,
472         uint256 sharesRequested,
473         uint256 lootRequested,
474         uint256 tributeOffered,
475         address tributeToken,
476         uint256 paymentRequested,
477         address paymentToken,
478         string memory details
479     ) public nonReentrant returns (uint256 proposalId) {
480         require(sharesRequested.add(lootRequested) <= MAX_NUMBER_OF_SHARES_AND_LOOT, "too many shares requested");
481         require(tokenWhitelist[tributeToken], "tributeToken is not whitelisted");
482         require(tokenWhitelist[paymentToken], "payment is not whitelisted");
483         require(applicant != address(0), "applicant cannot be 0");
484         require(applicant != GUILD && applicant != ESCROW && applicant != TOTAL, "applicant address cannot be reserved");
485         require(members[applicant].jailed == 0, "proposal applicant must not be jailed");
486 
487         if (tributeOffered > 0 && userTokenBalances[GUILD][tributeToken] == 0) {
488             require(totalGuildBankTokens < MAX_TOKEN_GUILDBANK_COUNT, 'cannot submit more tribute proposals for new tokens - guildbank is full');
489         }
490 
491         // collect tribute from proposer and store it in the Moloch until the proposal is processed
492         require(IERC20(tributeToken).transferFrom(msg.sender, address(this), tributeOffered), "tribute token transfer failed");
493         unsafeAddToBalance(ESCROW, tributeToken, tributeOffered);
494 
495         bool[6] memory flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
496 
497         _submitProposal(applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags);
498         return proposalCount - 1; // return proposalId - contracts calling submit might want it
499     }
500 
501     function submitWhitelistProposal(address tokenToWhitelist, string memory details) public nonReentrant returns (uint256 proposalId) {
502         require(tokenToWhitelist != address(0), "must provide token address");
503         require(!tokenWhitelist[tokenToWhitelist], "cannot already have whitelisted the token");
504         require(approvedTokens.length < MAX_TOKEN_WHITELIST_COUNT, "cannot submit more whitelist proposals");
505 
506         bool[6] memory flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
507         flags[4] = true; // whitelist
508 
509         _submitProposal(address(0), 0, 0, 0, tokenToWhitelist, 0, address(0), details, flags);
510         return proposalCount - 1;
511     }
512 
513     function submitGuildKickProposal(address memberToKick, string memory details) public nonReentrant returns (uint256 proposalId) {
514         Member memory member = members[memberToKick];
515 
516         require(member.shares > 0 || member.loot > 0, "member must have at least one share or one loot");
517         require(members[memberToKick].jailed == 0, "member must not already be jailed");
518 
519         bool[6] memory flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
520         flags[5] = true; // guild kick
521 
522         _submitProposal(memberToKick, 0, 0, 0, address(0), 0, address(0), details, flags);
523         return proposalCount - 1;
524     }
525 
526     function _submitProposal(
527         address applicant,
528         uint256 sharesRequested,
529         uint256 lootRequested,
530         uint256 tributeOffered,
531         address tributeToken,
532         uint256 paymentRequested,
533         address paymentToken,
534         string memory details,
535         bool[6] memory flags
536     ) internal {
537         Proposal memory proposal = Proposal({
538             applicant : applicant,
539             proposer : msg.sender,
540             sponsor : address(0),
541             sharesRequested : sharesRequested,
542             lootRequested : lootRequested,
543             tributeOffered : tributeOffered,
544             tributeToken : tributeToken,
545             paymentRequested : paymentRequested,
546             paymentToken : paymentToken,
547             startingPeriod : 0,
548             yesVotes : 0,
549             noVotes : 0,
550             flags : flags,
551             details : details,
552             maxTotalSharesAndLootAtYesVote : 0
553         });
554 
555         proposals[proposalCount] = proposal;
556         address memberAddress = memberAddressByDelegateKey[msg.sender];
557         // NOTE: argument order matters, avoid stack too deep
558         emit SubmitProposal(applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags, proposalCount, msg.sender, memberAddress);
559         proposalCount += 1;
560     }
561 
562     function sponsorProposal(uint256 proposalId) public nonReentrant onlyDelegate {
563         // collect proposal deposit from sponsor and store it in the Moloch until the proposal is processed
564         require(IERC20(depositToken).transferFrom(msg.sender, address(this), proposalDeposit), "proposal deposit token transfer failed");
565         unsafeAddToBalance(ESCROW, depositToken, proposalDeposit);
566 
567         Proposal storage proposal = proposals[proposalId];
568 
569         require(proposal.proposer != address(0), 'proposal must have been proposed');
570         require(!proposal.flags[0], "proposal has already been sponsored");
571         require(!proposal.flags[3], "proposal has been cancelled");
572         require(members[proposal.applicant].jailed == 0, "proposal applicant must not be jailed");
573 
574         if (proposal.tributeOffered > 0 && userTokenBalances[GUILD][proposal.tributeToken] == 0) {
575             require(totalGuildBankTokens < MAX_TOKEN_GUILDBANK_COUNT, 'cannot sponsor more tribute proposals for new tokens - guildbank is full');
576         }
577 
578         // whitelist proposal
579         if (proposal.flags[4]) {
580             require(!tokenWhitelist[address(proposal.tributeToken)], "cannot already have whitelisted the token");
581             require(!proposedToWhitelist[address(proposal.tributeToken)], 'already proposed to whitelist');
582             require(approvedTokens.length < MAX_TOKEN_WHITELIST_COUNT, "cannot sponsor more whitelist proposals");
583             proposedToWhitelist[address(proposal.tributeToken)] = true;
584 
585         // guild kick proposal
586         } else if (proposal.flags[5]) {
587             require(!proposedToKick[proposal.applicant], 'already proposed to kick');
588             proposedToKick[proposal.applicant] = true;
589         }
590 
591         // compute startingPeriod for proposal
592         uint256 startingPeriod = max(
593             getCurrentPeriod(),
594             proposalQueue.length == 0 ? 0 : proposals[proposalQueue[proposalQueue.length.sub(1)]].startingPeriod
595         ).add(1);
596 
597         proposal.startingPeriod = startingPeriod;
598 
599         address memberAddress = memberAddressByDelegateKey[msg.sender];
600         proposal.sponsor = memberAddress;
601 
602         proposal.flags[0] = true; // sponsored
603 
604         // append proposal to the queue
605         proposalQueue.push(proposalId);
606         
607         emit SponsorProposal(msg.sender, memberAddress, proposalId, proposalQueue.length.sub(1), startingPeriod);
608     }
609 
610     // NOTE: In MolochV2 proposalIndex !== proposalId
611     function submitVote(uint256 proposalIndex, uint8 uintVote) public nonReentrant onlyDelegate {
612         address memberAddress = memberAddressByDelegateKey[msg.sender];
613         Member storage member = members[memberAddress];
614 
615         require(proposalIndex < proposalQueue.length, "proposal does not exist");
616         Proposal storage proposal = proposals[proposalQueue[proposalIndex]];
617 
618         require(uintVote < 3, "must be less than 3");
619         Vote vote = Vote(uintVote);
620 
621         require(getCurrentPeriod() >= proposal.startingPeriod, "voting period has not started");
622         require(!hasVotingPeriodExpired(proposal.startingPeriod), "proposal voting period has expired");
623         require(proposal.votesByMember[memberAddress] == Vote.Null, "member has already voted");
624         require(vote == Vote.Yes || vote == Vote.No, "vote must be either Yes or No");
625 
626         proposal.votesByMember[memberAddress] = vote;
627 
628         if (vote == Vote.Yes) {
629             proposal.yesVotes = proposal.yesVotes.add(member.shares);
630 
631             // set highest index (latest) yes vote - must be processed for member to ragequit
632             if (proposalIndex > member.highestIndexYesVote) {
633                 member.highestIndexYesVote = proposalIndex;
634             }
635 
636             // set maximum of total shares encountered at a yes vote - used to bound dilution for yes voters
637             if (totalShares.add(totalLoot) > proposal.maxTotalSharesAndLootAtYesVote) {
638                 proposal.maxTotalSharesAndLootAtYesVote = totalShares.add(totalLoot);
639             }
640 
641         } else if (vote == Vote.No) {
642             proposal.noVotes = proposal.noVotes.add(member.shares);
643         }
644      
645         // NOTE: subgraph indexes by proposalId not proposalIndex since proposalIndex isn't set untill it's been sponsored but proposal is created on submission
646         emit SubmitVote(proposalQueue[proposalIndex], proposalIndex, msg.sender, memberAddress, uintVote);
647     }
648 
649     function processProposal(uint256 proposalIndex) public nonReentrant {
650         _validateProposalForProcessing(proposalIndex);
651 
652         uint256 proposalId = proposalQueue[proposalIndex];
653         Proposal storage proposal = proposals[proposalId];
654 
655         require(!proposal.flags[4] && !proposal.flags[5], "must be a standard proposal");
656 
657         proposal.flags[1] = true; // processed
658 
659         bool didPass = _didPass(proposalIndex);
660 
661         // Make the proposal fail if the new total number of shares and loot exceeds the limit
662         if (totalShares.add(totalLoot).add(proposal.sharesRequested).add(proposal.lootRequested) > MAX_NUMBER_OF_SHARES_AND_LOOT) {
663             didPass = false;
664         }
665 
666         // Make the proposal fail if it is requesting more tokens as payment than the available guild bank balance
667         if (proposal.paymentRequested > userTokenBalances[GUILD][proposal.paymentToken]) {
668             didPass = false;
669         }
670 
671         // Make the proposal fail if it would result in too many tokens with non-zero balance in guild bank
672         if (proposal.tributeOffered > 0 && userTokenBalances[GUILD][proposal.tributeToken] == 0 && totalGuildBankTokens >= MAX_TOKEN_GUILDBANK_COUNT) {
673            didPass = false;
674         }
675 
676         // PROPOSAL PASSED
677         if (didPass) {
678             proposal.flags[2] = true; // didPass
679 
680             // if the applicant is already a member, add to their existing shares & loot
681             if (members[proposal.applicant].exists) {
682                 members[proposal.applicant].shares = members[proposal.applicant].shares.add(proposal.sharesRequested);
683                 members[proposal.applicant].loot = members[proposal.applicant].loot.add(proposal.lootRequested);
684 
685             // the applicant is a new member, create a new record for them
686             } else {
687                 // if the applicant address is already taken by a member's delegateKey, reset it to their member address
688                 if (members[memberAddressByDelegateKey[proposal.applicant]].exists) {
689                     address memberToOverride = memberAddressByDelegateKey[proposal.applicant];
690                     memberAddressByDelegateKey[memberToOverride] = memberToOverride;
691                     members[memberToOverride].delegateKey = memberToOverride;
692                 }
693 
694                 // use applicant address as delegateKey by default
695                 members[proposal.applicant] = Member(proposal.applicant, proposal.sharesRequested, proposal.lootRequested, true, 0, 0);
696                 memberAddressByDelegateKey[proposal.applicant] = proposal.applicant;
697             }
698 
699             // mint new shares & loot
700             totalShares = totalShares.add(proposal.sharesRequested);
701             totalLoot = totalLoot.add(proposal.lootRequested);
702 
703             // if the proposal tribute is the first tokens of its kind to make it into the guild bank, increment total guild bank tokens
704             if (userTokenBalances[GUILD][proposal.tributeToken] == 0 && proposal.tributeOffered > 0) {
705                 totalGuildBankTokens += 1;
706             }
707 
708             unsafeInternalTransfer(ESCROW, GUILD, proposal.tributeToken, proposal.tributeOffered);
709             unsafeInternalTransfer(GUILD, proposal.applicant, proposal.paymentToken, proposal.paymentRequested);
710 
711             // if the proposal spends 100% of guild bank balance for a token, decrement total guild bank tokens
712             if (userTokenBalances[GUILD][proposal.paymentToken] == 0 && proposal.paymentRequested > 0) {
713                 totalGuildBankTokens -= 1;
714             }
715 
716         // PROPOSAL FAILED
717         } else {
718             // return all tokens to the proposer (not the applicant, because funds come from proposer)
719             unsafeInternalTransfer(ESCROW, proposal.proposer, proposal.tributeToken, proposal.tributeOffered);
720         }
721 
722         _returnDeposit(proposal.sponsor);
723 
724         emit ProcessProposal(proposalIndex, proposalId, didPass);
725     }
726 
727     function processWhitelistProposal(uint256 proposalIndex) public nonReentrant {
728         _validateProposalForProcessing(proposalIndex);
729 
730         uint256 proposalId = proposalQueue[proposalIndex];
731         Proposal storage proposal = proposals[proposalId];
732 
733         require(proposal.flags[4], "must be a whitelist proposal");
734 
735         proposal.flags[1] = true; // processed
736 
737         bool didPass = _didPass(proposalIndex);
738 
739         if (approvedTokens.length >= MAX_TOKEN_WHITELIST_COUNT) {
740             didPass = false;
741         }
742 
743         if (didPass) {
744             proposal.flags[2] = true; // didPass
745 
746             tokenWhitelist[address(proposal.tributeToken)] = true;
747             approvedTokens.push(proposal.tributeToken);
748         }
749 
750         proposedToWhitelist[address(proposal.tributeToken)] = false;
751 
752         _returnDeposit(proposal.sponsor);
753 
754         emit ProcessWhitelistProposal(proposalIndex, proposalId, didPass);
755     }
756 
757     function processGuildKickProposal(uint256 proposalIndex) public nonReentrant {
758         _validateProposalForProcessing(proposalIndex);
759 
760         uint256 proposalId = proposalQueue[proposalIndex];
761         Proposal storage proposal = proposals[proposalId];
762 
763         require(proposal.flags[5], "must be a guild kick proposal");
764 
765         proposal.flags[1] = true; // processed
766 
767         bool didPass = _didPass(proposalIndex);
768 
769         if (didPass) {
770             proposal.flags[2] = true; // didPass
771             Member storage member = members[proposal.applicant];
772             member.jailed = proposalIndex;
773 
774             // transfer shares to loot
775             member.loot = member.loot.add(member.shares);
776             totalShares = totalShares.sub(member.shares);
777             totalLoot = totalLoot.add(member.shares);
778             member.shares = 0; // revoke all shares
779         }
780 
781         proposedToKick[proposal.applicant] = false;
782 
783         _returnDeposit(proposal.sponsor);
784 
785         emit ProcessGuildKickProposal(proposalIndex, proposalId, didPass);
786     }
787 
788     function _didPass(uint256 proposalIndex) internal returns (bool didPass) {
789         Proposal memory proposal = proposals[proposalQueue[proposalIndex]];
790 
791         didPass = proposal.yesVotes > proposal.noVotes;
792 
793         // Make the proposal fail if the dilutionBound is exceeded
794         if ((totalShares.add(totalLoot)).mul(dilutionBound) < proposal.maxTotalSharesAndLootAtYesVote) {
795             didPass = false;
796         }
797 
798         // Make the proposal fail if the applicant is jailed
799         // - for standard proposals, we don't want the applicant to get any shares/loot/payment
800         // - for guild kick proposals, we should never be able to propose to kick a jailed member (or have two kick proposals active), so it doesn't matter
801         if (members[proposal.applicant].jailed != 0) {
802             didPass = false;
803         }
804 
805         return didPass;
806     }
807 
808     function _validateProposalForProcessing(uint256 proposalIndex) internal view {
809         require(proposalIndex < proposalQueue.length, "proposal does not exist");
810         Proposal memory proposal = proposals[proposalQueue[proposalIndex]];
811 
812         require(getCurrentPeriod() >= proposal.startingPeriod.add(votingPeriodLength).add(gracePeriodLength), "proposal is not ready to be processed");
813         require(proposal.flags[1] == false, "proposal has already been processed");
814         require(proposalIndex == 0 || proposals[proposalQueue[proposalIndex.sub(1)]].flags[1], "previous proposal must be processed");
815     }
816 
817     function _returnDeposit(address sponsor) internal {
818         unsafeInternalTransfer(ESCROW, msg.sender, depositToken, processingReward);
819         unsafeInternalTransfer(ESCROW, sponsor, depositToken, proposalDeposit.sub(processingReward));
820     }
821 
822     function ragequit(uint256 sharesToBurn, uint256 lootToBurn) public nonReentrant onlyMember {
823         _ragequit(msg.sender, sharesToBurn, lootToBurn);
824     }
825 
826     function _ragequit(address memberAddress, uint256 sharesToBurn, uint256 lootToBurn) internal {
827         uint256 initialTotalSharesAndLoot = totalShares.add(totalLoot);
828 
829         Member storage member = members[memberAddress];
830 
831         require(member.shares >= sharesToBurn, "insufficient shares");
832         require(member.loot >= lootToBurn, "insufficient loot");
833 
834         require(canRagequit(member.highestIndexYesVote), "cannot ragequit until highest index proposal member voted YES on is processed");
835 
836         uint256 sharesAndLootToBurn = sharesToBurn.add(lootToBurn);
837 
838         // burn shares and loot
839         member.shares = member.shares.sub(sharesToBurn);
840         member.loot = member.loot.sub(lootToBurn);
841         totalShares = totalShares.sub(sharesToBurn);
842         totalLoot = totalLoot.sub(lootToBurn);
843 
844         for (uint256 i = 0; i < approvedTokens.length; i++) {
845             uint256 amountToRagequit = fairShare(userTokenBalances[GUILD][approvedTokens[i]], sharesAndLootToBurn, initialTotalSharesAndLoot);
846             if (amountToRagequit > 0) { // gas optimization to allow a higher maximum token limit
847                 // deliberately not using safemath here to keep overflows from preventing the function execution (which would break ragekicks)
848                 // if a token overflows, it is because the supply was artificially inflated to oblivion, so we probably don't care about it anyways
849                 userTokenBalances[GUILD][approvedTokens[i]] -= amountToRagequit;
850                 userTokenBalances[memberAddress][approvedTokens[i]] += amountToRagequit;
851             }
852         }
853 
854         emit Ragequit(msg.sender, sharesToBurn, lootToBurn);
855     }
856 
857     function ragekick(address memberToKick) public nonReentrant {
858         Member storage member = members[memberToKick];
859 
860         require(member.jailed != 0, "member must be in jail");
861         require(member.loot > 0, "member must have some loot"); // note - should be impossible for jailed member to have shares
862         require(canRagequit(member.highestIndexYesVote), "cannot ragequit until highest index proposal member voted YES on is processed");
863 
864         _ragequit(memberToKick, 0, member.loot);
865     }
866 
867     function withdrawBalance(address token, uint256 amount) public nonReentrant {
868         _withdrawBalance(token, amount);
869     }
870 
871     function withdrawBalances(address[] memory tokens, uint256[] memory amounts, bool max) public nonReentrant {
872         require(tokens.length == amounts.length, "tokens and amounts arrays must be matching lengths");
873 
874         for (uint256 i=0; i < tokens.length; i++) {
875             uint256 withdrawAmount = amounts[i];
876             if (max) { // withdraw the maximum balance
877                 withdrawAmount = userTokenBalances[msg.sender][tokens[i]];
878             }
879 
880             _withdrawBalance(tokens[i], withdrawAmount);
881         }
882     }
883     
884     function _withdrawBalance(address token, uint256 amount) internal {
885         require(userTokenBalances[msg.sender][token] >= amount, "insufficient balance");
886         unsafeSubtractFromBalance(msg.sender, token, amount);
887         require(IERC20(token).transfer(msg.sender, amount), "transfer failed");
888         emit Withdraw(msg.sender, token, amount);
889     }
890 
891     function collectTokens(address token) public onlyDelegate nonReentrant {
892         uint256 amountToCollect = IERC20(token).balanceOf(address(this)).sub(userTokenBalances[TOTAL][token]);
893         // only collect if 1) there are tokens to collect 2) token is whitelisted 3) token has non-zero balance
894         require(amountToCollect > 0, 'no tokens to collect');
895         require(tokenWhitelist[token], 'token to collect must be whitelisted');
896         require(userTokenBalances[GUILD][token] > 0, 'token to collect must have non-zero guild bank balance');
897         
898         unsafeAddToBalance(GUILD, token, amountToCollect);
899         emit TokensCollected(token, amountToCollect);
900     }
901 
902     // NOTE: requires that delegate key which sent the original proposal cancels, msg.sender == proposal.proposer
903     function cancelProposal(uint256 proposalId) public nonReentrant {
904         Proposal storage proposal = proposals[proposalId];
905         require(!proposal.flags[0], "proposal has already been sponsored");
906         require(!proposal.flags[3], "proposal has already been cancelled");
907         require(msg.sender == proposal.proposer, "solely the proposer can cancel");
908 
909         proposal.flags[3] = true; // cancelled
910         
911         unsafeInternalTransfer(ESCROW, proposal.proposer, proposal.tributeToken, proposal.tributeOffered);
912         emit CancelProposal(proposalId, msg.sender);
913     }
914 
915     function updateDelegateKey(address newDelegateKey) public nonReentrant onlyShareholder {
916         require(newDelegateKey != address(0), "newDelegateKey cannot be 0");
917 
918         // skip checks if member is setting the delegate key to their member address
919         if (newDelegateKey != msg.sender) {
920             require(!members[newDelegateKey].exists, "cannot overwrite existing members");
921             require(!members[memberAddressByDelegateKey[newDelegateKey]].exists, "cannot overwrite existing delegate keys");
922         }
923 
924         Member storage member = members[msg.sender];
925         memberAddressByDelegateKey[member.delegateKey] = address(0);
926         memberAddressByDelegateKey[newDelegateKey] = msg.sender;
927         member.delegateKey = newDelegateKey;
928 
929         emit UpdateDelegateKey(msg.sender, newDelegateKey);
930     }
931 
932     // can only ragequit if the latest proposal you voted YES on has been processed
933     function canRagequit(uint256 highestIndexYesVote) public view returns (bool) {
934         require(highestIndexYesVote < proposalQueue.length, "proposal does not exist");
935         return proposals[proposalQueue[highestIndexYesVote]].flags[1];
936     }
937 
938     function hasVotingPeriodExpired(uint256 startingPeriod) public view returns (bool) {
939         return getCurrentPeriod() >= startingPeriod.add(votingPeriodLength);
940     }
941 
942     /***************
943     GETTER FUNCTIONS
944     ***************/
945 
946     function max(uint256 x, uint256 y) internal pure returns (uint256) {
947         return x >= y ? x : y;
948     }
949 
950     function getCurrentPeriod() public view returns (uint256) {
951         return now.sub(summoningTime).div(periodDuration);
952     }
953 
954     function getProposalQueueLength() public view returns (uint256) {
955         return proposalQueue.length;
956     }
957 
958     function getProposalFlags(uint256 proposalId) public view returns (bool[6] memory) {
959         return proposals[proposalId].flags;
960     }
961 
962     function getUserTokenBalance(address user, address token) public view returns (uint256) {
963         return userTokenBalances[user][token];
964     }
965 
966     function getMemberProposalVote(address memberAddress, uint256 proposalIndex) public view returns (Vote) {
967         require(members[memberAddress].exists, "member does not exist");
968         require(proposalIndex < proposalQueue.length, "proposal does not exist");
969         return proposals[proposalQueue[proposalIndex]].votesByMember[memberAddress];
970     }
971 
972     function getTokenCount() public view returns (uint256) {
973         return approvedTokens.length;
974     }
975 
976     /***************
977     HELPER FUNCTIONS
978     ***************/
979     function unsafeAddToBalance(address user, address token, uint256 amount) internal {
980         userTokenBalances[user][token] += amount;
981         userTokenBalances[TOTAL][token] += amount;
982     }
983 
984     function unsafeSubtractFromBalance(address user, address token, uint256 amount) internal {
985         userTokenBalances[user][token] -= amount;
986         userTokenBalances[TOTAL][token] -= amount;
987     }
988 
989     function unsafeInternalTransfer(address from, address to, address token, uint256 amount) internal {
990         unsafeSubtractFromBalance(from, token, amount);
991         unsafeAddToBalance(to, token, amount);
992     }
993 
994     function fairShare(uint256 balance, uint256 shares, uint256 totalShares) internal pure returns (uint256) {
995         require(totalShares != 0);
996 
997         if (balance == 0) { return 0; }
998 
999         uint256 prod = balance * shares;
1000 
1001         if (prod / balance == shares) { // no overflow in multiplication above?
1002             return prod / totalShares;
1003         }
1004 
1005         return (balance / totalShares) * shares;
1006     }
1007 }