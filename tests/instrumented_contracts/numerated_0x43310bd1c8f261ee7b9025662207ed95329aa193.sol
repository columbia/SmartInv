1 pragma solidity 0.5.3;
2 /*
3     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
4     INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
5     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
6     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
7     DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
8     ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
9 
10     © 2020 The LAO I, LLC
11 */
12 library SafeMath {
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17 
18         uint256 c = a * b;
19         require(c / a == b);
20 
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25 
26         require(b > 0);
27         uint256 c = a / b;
28 
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b <= a);
34         uint256 c = a - b;
35 
36         return c;
37     }
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a);
42 
43         return c;
44     }
45 }
46 
47 interface IERC20 {
48     function transfer(address to, uint256 value) external returns (bool);
49 
50     function approve(address spender, uint256 value) external returns (bool);
51 
52     function transferFrom(address from, address to, uint256 value) external returns (bool);
53 
54     function totalSupply() external view returns (uint256);
55 
56     function balanceOf(address who) external view returns (uint256);
57 
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 /**
66  * @dev Contract module that helps prevent reentrant calls to a function.
67  *
68  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
69  * available, which can be applied to functions to make sure there are no nested
70  * (reentrant) calls to them.
71  *
72  * Note that because there is a single `nonReentrant` guard, functions marked as
73  * `nonReentrant` may not call one another. This can be worked around by making
74  * those functions `private`, and then adding `external` `nonReentrant` entry
75  * points to them.
76  *
77  * TIP: If you would like to learn more about reentrancy and alternative ways
78  * to protect against it, check out our blog post
79  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
80  *
81  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
82  * metering changes introduced in the Istanbul hardfork.
83  */
84  /*
85  * @dev Provides information about the current execution context, including the
86  * sender of the transaction and its data. While these are generally available
87  * via msg.sender and msg.data, they should not be accessed in such a direct
88  * manner, since when dealing with GSN meta-transactions the account sending and
89  * paying for execution may not be the actual sender (as far as an application
90  * is concerned).
91  *
92  * This contract is only required for intermediate, library-like contracts.
93  */
94 contract Context {
95     // Empty internal constructor, to prevent people from mistakenly deploying
96     // an instance of this contract, which should be used via inheritance.
97     constructor () internal { }
98     // solhint-disable-previous-line no-empty-blocks
99 
100     function _msgSender() internal view returns (address payable) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view returns (bytes memory) {
105         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
106         return msg.data;
107     }
108 }
109 
110 contract Ownable is Context {
111     address private _owner;
112 
113     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
114 
115     /**
116      * @dev Initializes the contract setting the deployer as the initial owner.
117      */
118     constructor () internal {
119         address msgSender = _msgSender();
120         _owner = msgSender;
121         emit OwnershipTransferred(address(0), msgSender);
122     }
123 
124     /**
125      * @dev Returns the address of the current owner.
126      */
127     function owner() public view returns (address) {
128         return _owner;
129     }
130 
131     /**
132      * @dev Throws if called by any account other than the owner.
133      */
134     modifier onlyOwner() {
135         require(isOwner(), "Ownable: caller is not the owner");
136         _;
137     }
138 
139     /**
140      * @dev Returns true if the caller is the current owner.
141      */
142     function isOwner() public view returns (bool) {
143         return _msgSender() == _owner;
144     }
145 
146     /**
147      * @dev Leaves the contract without owner. It will not be possible to call
148      * `onlyOwner` functions anymore. Can only be called by the current owner.
149      *
150      * NOTE: Renouncing ownership will leave the contract without an owner,
151      * thereby removing any functionality that is only available to the owner.
152      */
153     function renounceOwnership() public onlyOwner {
154         emit OwnershipTransferred(_owner, address(0));
155         _owner = address(0);
156     }
157 
158     /**
159      * @dev Transfers ownership of the contract to a new account (`newOwner`).
160      * Can only be called by the current owner.
161      */
162     function transferOwnership(address newOwner) public onlyOwner {
163         _transferOwnership(newOwner);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      */
169     function _transferOwnership(address newOwner) internal {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         emit OwnershipTransferred(_owner, newOwner);
172         _owner = newOwner;
173     }
174 }
175 
176 contract ReentrancyGuard {
177     bool private _notEntered;
178 
179     constructor () internal {
180         // Storing an initial non-zero value makes deployment a bit more
181         // expensive, but in exchange the refund on every call to nonReentrant
182         // will be lower in amount. Since refunds are capped to a percetange of
183         // the total transaction's gas, it is best to keep them low in cases
184         // like this one, to increase the likelihood of the full refund coming
185         // into effect.
186         _notEntered = true;
187     }
188 
189     /**
190      * @dev Prevents a contract from calling itself, directly or indirectly.
191      * Calling a `nonReentrant` function from another `nonReentrant`
192      * function is not supported. It is possible to prevent this from happening
193      * by making the `nonReentrant` function external, and make it call a
194      * `private` function that does the actual work.
195      */
196     modifier nonReentrant() {
197         // On the first call to nonReentrant, _notEntered will be true
198         require(_notEntered, "ReentrancyGuard: reentrant call");
199 
200         // Any calls to nonReentrant after this point will fail
201         _notEntered = false;
202 
203         _;
204 
205         // By storing the original value once again, a refund is triggered (see
206         // https://eips.ethereum.org/EIPS/eip-2200)
207         _notEntered = true;
208     }
209 }
210 
211 contract LAO is Ownable, ReentrancyGuard {
212     using SafeMath for uint256;
213 
214     /***************
215     GLOBAL CONSTANTS
216     ***************/
217     uint256 public periodDuration; // default = 17280 = 4.8 hours in seconds (5 periods per day)
218     uint256 public votingPeriodLength; // default = 35 periods (7 days)
219     uint256 public gracePeriodLength; // default = 35 periods (7 days)
220     uint256 public proposalDeposit; // default = 10 ETH (~$1,000 worth of ETH at contract deployment)
221     uint256 public dilutionBound; // default = 3 - maximum multiplier a YES voter will be obligated to pay in case of mass ragequit
222     uint256 public processingReward; // default = 0.1 - amount of ETH to give to whoever processes a proposal
223     uint256 public summoningTime; // needed to determine the current period
224 
225     address public depositToken; // deposit token contract reference; default = wETH
226     /******
227      AdminFee - LAO exclusive, add on to original Moloch
228      *********/
229     uint256 constant paymentPeriod = 90 days; // 90 days - 1 day is for test only!
230     uint256 public lastPaymentTime; // this will set as 'now' in constructor = summoningTime
231     address public laoFundAddress; // this field MUST be set in constructor or set to default to summoner here
232     uint256 public adminFeeDenominator = 200; // initial denominator
233    
234     // HARD-CODED LIMITS
235     // These numbers are quite arbitrary; they are small enough to avoid overflows when doing calculations
236     // with periods or shares, yet big enough to not limit reasonable use cases.
237     uint256 constant MAX_VOTING_PERIOD_LENGTH = 10**18; // maximum length of voting period
238     uint256 constant MAX_GRACE_PERIOD_LENGTH = 10**18; // maximum length of grace period
239     uint256 constant MAX_DILUTION_BOUND = 10**18; // maximum dilution bound
240     uint256 constant MAX_NUMBER_OF_SHARES_AND_LOOT = 10**18; // maximum number of shares that can be minted
241     uint256 constant MAX_TOKEN_WHITELIST_COUNT = 200; // maximum number of whitelisted tokens, default is 400
242     uint256 constant MAX_TOKEN_GUILDBANK_COUNT = 100; // maximum number of tokens with non-zero balance in guildbank, default is 200
243 
244     // ***************
245     // EVENTS
246     // ***************
247     event SummonComplete(address indexed summoner, address[] tokens, uint256 summoningTime, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 proposalDeposit, uint256 dilutionBound, uint256 processingReward);
248     event SubmitProposal(address indexed applicant, uint256 sharesRequested, uint256 lootRequested, uint256 tributeOffered, address tributeToken, uint256 paymentRequested, address paymentToken, string details, bool[6] flags, uint256 proposalId, address indexed delegateKey, address indexed memberAddress);
249     event SponsorProposal(address indexed delegateKey, address indexed memberAddress, uint256 proposalId, uint256 proposalIndex, uint256 startingPeriod);
250     event SubmitVote(uint256 proposalId, uint256 indexed proposalIndex, address indexed delegateKey, address indexed memberAddress, uint8 uintVote);
251     event ProcessProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
252     event ProcessWhitelistProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
253     event ProcessGuildKickProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
254     event Ragequit(address indexed memberAddress, uint256 sharesToBurn, uint256 lootToBurn);
255     event TokensCollected(address indexed token, uint256 amountToCollect);
256     event CancelProposal(uint256 indexed proposalId, address applicantAddress);
257     event UpdateDelegateKey(address indexed memberAddress, address newDelegateKey);
258     event Withdraw(address indexed memberAddress, address token, uint256 amount);
259 
260     // *******************
261     // INTERNAL ACCOUNTING
262     // *******************
263     uint256 public proposalCount = 0; // total proposals submitted
264     uint256 public totalShares = 0; // total shares across all members
265     uint256 public totalLoot = 0; // total loot across all members
266 
267     uint256 public totalGuildBankTokens = 0; // total tokens with non-zero balance in guild bank
268 
269     address public constant GUILD = address(0xdead);
270     address public constant ESCROW = address(0xbeef);
271     address public constant TOTAL = address(0xbabe);
272     mapping (address => mapping(address => uint256)) public userTokenBalances; // userTokenBalances[userAddress][tokenAddress]
273 
274     enum Vote {
275         Null, // default value, counted as abstention
276         Yes,
277         No
278     }
279 
280     struct Member {
281         address delegateKey; // the key responsible for submitting proposals and voting - defaults to member address unless updated
282         uint256 shares; // the # of voting shares assigned to this member
283         uint256 loot; // the loot amount available to this member (combined with shares on ragequit)
284         bool exists; // always true once a member has been created
285         uint256 highestIndexYesVote; // highest proposal index # on which the member voted YES
286         uint256 jailed; // set to proposalIndex of a passing guild kick proposal for this member, prevents voting on and sponsoring proposals
287     }
288 
289     struct Proposal {
290         address applicant; // the applicant who wishes to become a member - this key will be used for withdrawals (doubles as guild kick target for gkick proposals)
291         address proposer; // the account that submitted the proposal (can be non-member)
292         address sponsor; // the member that sponsored the proposal (moving it into the queue)
293         uint256 sharesRequested; // the # of shares the applicant is requesting
294         uint256 lootRequested; // the amount of loot the applicant is requesting
295         uint256 tributeOffered; // amount of tokens offered as tribute
296         address tributeToken; // tribute token contract reference
297         uint256 paymentRequested; // amount of tokens requested as payment
298         address paymentToken; // payment token contract reference
299         uint256 startingPeriod; // the period in which voting can start for this proposal
300         uint256 yesVotes; // the total number of YES votes for this proposal
301         uint256 noVotes; // the total number of NO votes for this proposal
302         bool[6] flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
303         string details; // proposal details - could be IPFS hash, plaintext, or JSON
304         uint256 maxTotalSharesAndLootAtYesVote; // the maximum # of total shares encountered at a yes vote on this proposal
305         mapping(address => Vote) votesByMember; // the votes on this proposal by each member
306     }
307 
308     mapping(address => bool) public tokenWhitelist;
309     address[] public approvedTokens;
310 
311     mapping(address => bool) public proposedToWhitelist;
312     mapping(address => bool) public proposedToKick;
313 
314     mapping(address => Member) public members;
315     mapping(address => address) public memberAddressByDelegateKey;
316 
317     mapping(uint256 => Proposal) public proposals;
318 
319     uint256[] public proposalQueue;
320 
321     modifier onlyMember {
322         require(members[msg.sender].shares > 0 || members[msg.sender].loot > 0, "not a member");
323         _;
324     }
325 
326     modifier onlyShareholder {
327         require(members[msg.sender].shares > 0, "not a shareholder");
328         _;
329     }
330 
331     modifier onlyDelegate {
332         require(members[memberAddressByDelegateKey[msg.sender]].shares > 0, "not a delegate");
333         _;
334     }
335 
336     constructor(
337         address _summoner,
338         address[] memory _approvedTokens,
339         uint256 _periodDuration,
340         uint256 _votingPeriodLength,
341         uint256 _gracePeriodLength,
342         uint256 _proposalDeposit,
343         uint256 _dilutionBound,
344         uint256 _processingReward,
345         address _laoFundAddress
346     ) public {
347         require(_summoner != address(0), "summoner cannot be 0");
348         require(_periodDuration > 0, "_periodDuration cannot be 0");
349         require(_votingPeriodLength > 0, "_votingPeriodLength cannot be 0");
350         require(_votingPeriodLength <= MAX_VOTING_PERIOD_LENGTH, "_votingPeriodLength exceeds limit");
351         require(_gracePeriodLength <= MAX_GRACE_PERIOD_LENGTH, "_gracePeriodLength exceeds limit");
352         require(_dilutionBound > 0, "_dilutionBound cannot be 0");
353         require(_dilutionBound <= MAX_DILUTION_BOUND, "_dilutionBound exceeds limit");
354         require(_approvedTokens.length > 0, "need at least one approved token");
355         require(_approvedTokens.length <= MAX_TOKEN_WHITELIST_COUNT, "too many tokens");
356         require(_proposalDeposit >= _processingReward, "_proposalDeposit cannot be smaller than _processingReward");
357         require(_laoFundAddress != address(0), "laoFundAddress cannot be 0");
358         depositToken = _approvedTokens[0];
359         // NOTE: move event up here, avoid stack too deep if too many approved tokens
360         emit SummonComplete(_summoner, _approvedTokens, now, _periodDuration, _votingPeriodLength, _gracePeriodLength, _proposalDeposit, _dilutionBound, _processingReward);
361 
362         for (uint256 i = 0; i < _approvedTokens.length; i++) {
363             require(_approvedTokens[i] != address(0), "_approvedToken cannot be 0");
364             require(!tokenWhitelist[_approvedTokens[i]], "duplicate approved token");
365             tokenWhitelist[_approvedTokens[i]] = true;
366             approvedTokens.push(_approvedTokens[i]);
367         }
368 
369         periodDuration = _periodDuration;
370         votingPeriodLength = _votingPeriodLength;
371         gracePeriodLength = _gracePeriodLength;
372         proposalDeposit = _proposalDeposit;
373         dilutionBound = _dilutionBound;
374         processingReward = _processingReward;
375 
376         summoningTime = now;
377         laoFundAddress = _laoFundAddress; // LAO add on for adminFee
378         lastPaymentTime = now;  // LAO add on for adminFee
379         members[_summoner] = Member(_summoner, 1, 0, true, 0, 0);
380         memberAddressByDelegateKey[_summoner] = _summoner;
381         totalShares = 1;
382     }
383     
384     /******************
385     ADMIN FEE FUNCTIONS 
386     -- LAO add on functions to MOLOCH
387     setAdminFee can only be changed by Owner
388     withdrawAdminFee can be called by any ETH address
389     ******************/
390     // @dev Owner can change amount of adminFee and direction of funds 
391     // @param adminFeeDenominator must be >= 200. Greater than 200, will equal 0.5% or less of assets  
392     // @param laoFundAddress - where the Owner wants the funds to go 
393     function setAdminFee(uint256 _adminFeeDenominator, address _laoFundAddress) public nonReentrant onlyOwner{
394         require(_adminFeeDenominator >= 200);
395         adminFeeDenominator = _adminFeeDenominator; 
396         laoFundAddress = _laoFundAddress;
397     } 
398     
399     function withdrawAdminFee() public nonReentrant {
400         require(now >= lastPaymentTime.add(paymentPeriod), "90 days have not passed since last withdrawal");
401         lastPaymentTime = lastPaymentTime.add(paymentPeriod); // set it to the next payment period 
402         // local variables to save gas by reading from storage only 1x
403         uint256 denominator = adminFeeDenominator; 
404         address recipient = laoFundAddress;
405         
406         for (uint256 i = 0; i < approvedTokens.length; i++) {
407             address token = approvedTokens[i];
408             uint256 amount = userTokenBalances[GUILD][token] / denominator;
409             if (amount > 0) { // otherwise skip for efficiency, only tokens with a balance
410                userTokenBalances[GUILD][token] -= amount;
411                userTokenBalances[recipient][token] += amount;
412             }
413         } 
414     } 
415     
416     /*****************
417     PROPOSAL FUNCTIONS
418     *****************/
419     function submitProposal(
420         address applicant,
421         uint256 sharesRequested,
422         uint256 lootRequested,
423         uint256 tributeOffered,
424         address tributeToken,
425         uint256 paymentRequested,
426         address paymentToken,
427         string memory details
428     ) public nonReentrant returns (uint256 proposalId) {
429         require(sharesRequested.add(lootRequested) <= MAX_NUMBER_OF_SHARES_AND_LOOT, "too many shares requested");
430         require(tokenWhitelist[tributeToken], "tributeToken is not whitelisted");
431         require(tokenWhitelist[paymentToken], "payment is not whitelisted");
432         require(applicant != address(0), "applicant cannot be 0");
433         require(applicant != GUILD && applicant != ESCROW && applicant != TOTAL, "applicant address cannot be reserved");
434         require(members[applicant].jailed == 0, "proposal applicant must not be jailed");
435 
436         if (tributeOffered > 0 && userTokenBalances[GUILD][tributeToken] == 0) {
437             require(totalGuildBankTokens < MAX_TOKEN_GUILDBANK_COUNT, 'cannot submit more tribute proposals for new tokens - guildbank is full');
438         }
439 
440         // collect tribute from proposer and store it in the LAO until the proposal is processed
441         require(IERC20(tributeToken).transferFrom(msg.sender, address(this), tributeOffered), "tribute token transfer failed");
442         unsafeAddToBalance(ESCROW, tributeToken, tributeOffered);
443 
444         bool[6] memory flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
445 
446         _submitProposal(applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags);
447         return proposalCount - 1; // return proposalId - contracts calling submit might want it
448     }
449 
450     function submitWhitelistProposal(address tokenToWhitelist, string memory details) public nonReentrant returns (uint256 proposalId) {
451         require(tokenToWhitelist != address(0), "must provide token address");
452         require(!tokenWhitelist[tokenToWhitelist], "cannot already have whitelisted the token");
453         require(approvedTokens.length < MAX_TOKEN_WHITELIST_COUNT, "cannot submit more whitelist proposals");
454 
455         bool[6] memory flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
456         flags[4] = true; // whitelist
457 
458         _submitProposal(address(0), 0, 0, 0, tokenToWhitelist, 0, address(0), details, flags);
459         return proposalCount - 1;
460     }
461 
462     function submitGuildKickProposal(address memberToKick, string memory details) public nonReentrant returns (uint256 proposalId) {
463         Member memory member = members[memberToKick];
464 
465         require(member.shares > 0 || member.loot > 0, "member must have at least one share or one loot");
466         require(members[memberToKick].jailed == 0, "member must not already be jailed");
467 
468         bool[6] memory flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
469         flags[5] = true; // guild kick
470 
471         _submitProposal(memberToKick, 0, 0, 0, address(0), 0, address(0), details, flags);
472         return proposalCount - 1;
473     }
474 
475     function _submitProposal(
476         address applicant,
477         uint256 sharesRequested,
478         uint256 lootRequested,
479         uint256 tributeOffered,
480         address tributeToken,
481         uint256 paymentRequested,
482         address paymentToken,
483         string memory details,
484         bool[6] memory flags
485     ) internal {
486         Proposal memory proposal = Proposal({
487             applicant : applicant,
488             proposer : msg.sender,
489             sponsor : address(0),
490             sharesRequested : sharesRequested,
491             lootRequested : lootRequested,
492             tributeOffered : tributeOffered,
493             tributeToken : tributeToken,
494             paymentRequested : paymentRequested,
495             paymentToken : paymentToken,
496             startingPeriod : 0,
497             yesVotes : 0,
498             noVotes : 0,
499             flags : flags,
500             details : details,
501             maxTotalSharesAndLootAtYesVote : 0
502         });
503 
504         proposals[proposalCount] = proposal;
505         address memberAddress = memberAddressByDelegateKey[msg.sender];
506         // NOTE: argument order matters, avoid stack too deep
507         emit SubmitProposal(applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags, proposalCount, msg.sender, memberAddress);
508         proposalCount += 1;
509     }
510 
511     function sponsorProposal(uint256 proposalId) public nonReentrant onlyDelegate {
512         // collect proposal deposit from sponsor and store it in the LAO until the proposal is processed
513         require(IERC20(depositToken).transferFrom(msg.sender, address(this), proposalDeposit), "proposal deposit token transfer failed");
514         unsafeAddToBalance(ESCROW, depositToken, proposalDeposit);
515 
516         Proposal storage proposal = proposals[proposalId];
517 
518         require(proposal.proposer != address(0), 'proposal must have been proposed');
519         require(!proposal.flags[0], "proposal has already been sponsored");
520         require(!proposal.flags[3], "proposal has been cancelled");
521         require(members[proposal.applicant].jailed == 0, "proposal applicant must not be jailed");
522 
523         if (proposal.tributeOffered > 0 && userTokenBalances[GUILD][proposal.tributeToken] == 0) {
524             require(totalGuildBankTokens < MAX_TOKEN_GUILDBANK_COUNT, 'cannot sponsor more tribute proposals for new tokens - guildbank is full');
525         }
526 
527         // whitelist proposal
528         if (proposal.flags[4]) {
529             require(!tokenWhitelist[address(proposal.tributeToken)], "cannot already have whitelisted the token");
530             require(!proposedToWhitelist[address(proposal.tributeToken)], 'already proposed to whitelist');
531             require(approvedTokens.length < MAX_TOKEN_WHITELIST_COUNT, "cannot sponsor more whitelist proposals");
532             proposedToWhitelist[address(proposal.tributeToken)] = true;
533 
534         // guild kick proposal
535         } else if (proposal.flags[5]) {
536             require(!proposedToKick[proposal.applicant], 'already proposed to kick');
537             proposedToKick[proposal.applicant] = true;
538         }
539 
540         // compute startingPeriod for proposal
541         uint256 startingPeriod = max(
542             getCurrentPeriod(),
543             proposalQueue.length == 0 ? 0 : proposals[proposalQueue[proposalQueue.length.sub(1)]].startingPeriod
544         ).add(1);
545 
546         proposal.startingPeriod = startingPeriod;
547 
548         address memberAddress = memberAddressByDelegateKey[msg.sender];
549         proposal.sponsor = memberAddress;
550 
551         proposal.flags[0] = true; // sponsored
552 
553         // append proposal to the queue
554         proposalQueue.push(proposalId);
555         
556         emit SponsorProposal(msg.sender, memberAddress, proposalId, proposalQueue.length.sub(1), startingPeriod);
557     }
558 
559     // NOTE: In MolochV2/LAO proposalIndex !== proposalId
560     function submitVote(uint256 proposalIndex, uint8 uintVote) public nonReentrant onlyDelegate {
561         address memberAddress = memberAddressByDelegateKey[msg.sender];
562         Member storage member = members[memberAddress];
563 
564         require(proposalIndex < proposalQueue.length, "proposal does not exist");
565         Proposal storage proposal = proposals[proposalQueue[proposalIndex]];
566 
567         require(uintVote < 3, "must be less than 3");
568         Vote vote = Vote(uintVote);
569 
570         require(getCurrentPeriod() >= proposal.startingPeriod, "voting period has not started");
571         require(!hasVotingPeriodExpired(proposal.startingPeriod), "proposal voting period has expired");
572         require(proposal.votesByMember[memberAddress] == Vote.Null, "member has already voted");
573         require(vote == Vote.Yes || vote == Vote.No, "vote must be either Yes or No");
574 
575         proposal.votesByMember[memberAddress] = vote;
576 
577         if (vote == Vote.Yes) {
578             proposal.yesVotes = proposal.yesVotes.add(member.shares);
579 
580             // set highest index (latest) yes vote - must be processed for member to ragequit
581             if (proposalIndex > member.highestIndexYesVote) {
582                 member.highestIndexYesVote = proposalIndex;
583             }
584 
585             // set maximum of total shares encountered at a yes vote - used to bound dilution for yes voters
586             if (totalShares.add(totalLoot) > proposal.maxTotalSharesAndLootAtYesVote) {
587                 proposal.maxTotalSharesAndLootAtYesVote = totalShares.add(totalLoot);
588             }
589 
590         } else if (vote == Vote.No) {
591             proposal.noVotes = proposal.noVotes.add(member.shares);
592         }
593      
594         // NOTE: subgraph indexes by proposalId not proposalIndex since proposalIndex isn't set untill it's been sponsored but proposal is created on submission
595         emit SubmitVote(proposalQueue[proposalIndex], proposalIndex, msg.sender, memberAddress, uintVote);
596     }
597 
598     function processProposal(uint256 proposalIndex) public nonReentrant {
599         _validateProposalForProcessing(proposalIndex);
600 
601         uint256 proposalId = proposalQueue[proposalIndex];
602         Proposal storage proposal = proposals[proposalId];
603 
604         require(!proposal.flags[4] && !proposal.flags[5], "must be a standard proposal");
605 
606         proposal.flags[1] = true; // processed
607 
608         bool didPass = _didPass(proposalIndex);
609 
610         // Make the proposal fail if the new total number of shares and loot exceeds the limit
611         if (totalShares.add(totalLoot).add(proposal.sharesRequested).add(proposal.lootRequested) > MAX_NUMBER_OF_SHARES_AND_LOOT) {
612             didPass = false;
613         }
614 
615         // Make the proposal fail if it is requesting more tokens as payment than the available guild bank balance
616         if (proposal.paymentRequested > userTokenBalances[GUILD][proposal.paymentToken]) {
617             didPass = false;
618         }
619 
620         // Make the proposal fail if it would result in too many tokens with non-zero balance in guild bank
621         if (proposal.tributeOffered > 0 && userTokenBalances[GUILD][proposal.tributeToken] == 0 && totalGuildBankTokens >= MAX_TOKEN_GUILDBANK_COUNT) {
622            didPass = false;
623         }
624 
625         // PROPOSAL PASSED
626         if (didPass) {
627             proposal.flags[2] = true; // didPass
628 
629             // if the applicant is already a member, add to their existing shares & loot
630             if (members[proposal.applicant].exists) {
631                 members[proposal.applicant].shares = members[proposal.applicant].shares.add(proposal.sharesRequested);
632                 members[proposal.applicant].loot = members[proposal.applicant].loot.add(proposal.lootRequested);
633 
634             // the applicant is a new member, create a new record for them
635             } else {
636                 // if the applicant address is already taken by a member's delegateKey, reset it to their member address
637                 if (members[memberAddressByDelegateKey[proposal.applicant]].exists) {
638                     address memberToOverride = memberAddressByDelegateKey[proposal.applicant];
639                     memberAddressByDelegateKey[memberToOverride] = memberToOverride;
640                     members[memberToOverride].delegateKey = memberToOverride;
641                 }
642 
643                 // use applicant address as delegateKey by default
644                 members[proposal.applicant] = Member(proposal.applicant, proposal.sharesRequested, proposal.lootRequested, true, 0, 0);
645                 memberAddressByDelegateKey[proposal.applicant] = proposal.applicant;
646             }
647 
648             // mint new shares & loot
649             totalShares = totalShares.add(proposal.sharesRequested);
650             totalLoot = totalLoot.add(proposal.lootRequested);
651 
652             // if the proposal tribute is the first tokens of its kind to make it into the guild bank, increment total guild bank tokens
653             if (userTokenBalances[GUILD][proposal.tributeToken] == 0 && proposal.tributeOffered > 0) {
654                 totalGuildBankTokens += 1;
655             }
656 
657             unsafeInternalTransfer(ESCROW, GUILD, proposal.tributeToken, proposal.tributeOffered);
658             unsafeInternalTransfer(GUILD, proposal.applicant, proposal.paymentToken, proposal.paymentRequested);
659 
660             // if the proposal spends 100% of guild bank balance for a token, decrement total guild bank tokens
661             if (userTokenBalances[GUILD][proposal.paymentToken] == 0 && proposal.paymentRequested > 0) {
662                 totalGuildBankTokens -= 1;
663             }
664 
665         // PROPOSAL FAILED
666         } else {
667             // return all tokens to the proposer (not the applicant, because funds come from proposer)
668             unsafeInternalTransfer(ESCROW, proposal.proposer, proposal.tributeToken, proposal.tributeOffered);
669         }
670 
671         _returnDeposit(proposal.sponsor);
672 
673         emit ProcessProposal(proposalIndex, proposalId, didPass);
674     }
675 
676     function processWhitelistProposal(uint256 proposalIndex) public nonReentrant {
677         _validateProposalForProcessing(proposalIndex);
678 
679         uint256 proposalId = proposalQueue[proposalIndex];
680         Proposal storage proposal = proposals[proposalId];
681 
682         require(proposal.flags[4], "must be a whitelist proposal");
683 
684         proposal.flags[1] = true; // processed
685 
686         bool didPass = _didPass(proposalIndex);
687 
688         if (approvedTokens.length >= MAX_TOKEN_WHITELIST_COUNT) {
689             didPass = false;
690         }
691 
692         if (didPass) {
693             proposal.flags[2] = true; // didPass
694 
695             tokenWhitelist[address(proposal.tributeToken)] = true;
696             approvedTokens.push(proposal.tributeToken);
697         }
698 
699         proposedToWhitelist[address(proposal.tributeToken)] = false;
700 
701         _returnDeposit(proposal.sponsor);
702 
703         emit ProcessWhitelistProposal(proposalIndex, proposalId, didPass);
704     }
705 
706     function processGuildKickProposal(uint256 proposalIndex) public nonReentrant {
707         _validateProposalForProcessing(proposalIndex);
708 
709         uint256 proposalId = proposalQueue[proposalIndex];
710         Proposal storage proposal = proposals[proposalId];
711 
712         require(proposal.flags[5], "must be a guild kick proposal");
713 
714         proposal.flags[1] = true; // processed
715 
716         bool didPass = _didPass(proposalIndex);
717 
718         if (didPass) {
719             proposal.flags[2] = true; // didPass
720             Member storage member = members[proposal.applicant];
721             member.jailed = proposalIndex;
722 
723             // transfer shares to loot
724             member.loot = member.loot.add(member.shares);
725             totalShares = totalShares.sub(member.shares);
726             totalLoot = totalLoot.add(member.shares);
727             member.shares = 0; // revoke all shares
728         }
729 
730         proposedToKick[proposal.applicant] = false;
731 
732         _returnDeposit(proposal.sponsor);
733 
734         emit ProcessGuildKickProposal(proposalIndex, proposalId, didPass);
735     }
736 
737     function _didPass(uint256 proposalIndex) internal view returns  (bool didPass) {
738         Proposal memory proposal = proposals[proposalQueue[proposalIndex]];
739 
740         didPass = proposal.yesVotes > proposal.noVotes;
741 
742         // Make the proposal fail if the dilutionBound is exceeded
743         if ((totalShares.add(totalLoot)).mul(dilutionBound) < proposal.maxTotalSharesAndLootAtYesVote) {
744             didPass = false;
745         }
746 
747         // Make the proposal fail if the applicant is jailed
748         // - for standard proposals, we don't want the applicant to get any shares/loot/payment
749         // - for guild kick proposals, we should never be able to propose to kick a jailed member (or have two kick proposals active), so it doesn't matter
750         if (members[proposal.applicant].jailed != 0) {
751             didPass = false;
752         }
753 
754         return didPass;
755     }
756 
757     function _validateProposalForProcessing(uint256 proposalIndex) internal view {
758         require(proposalIndex < proposalQueue.length, "proposal does not exist");
759         Proposal memory proposal = proposals[proposalQueue[proposalIndex]];
760 
761         require(getCurrentPeriod() >= proposal.startingPeriod.add(votingPeriodLength).add(gracePeriodLength), "proposal is not ready to be processed");
762         require(proposal.flags[1] == false, "proposal has already been processed");
763         require(proposalIndex == 0 || proposals[proposalQueue[proposalIndex.sub(1)]].flags[1], "previous proposal must be processed");
764     }
765 
766     function _returnDeposit(address sponsor) internal {
767         unsafeInternalTransfer(ESCROW, msg.sender, depositToken, processingReward);
768         unsafeInternalTransfer(ESCROW, sponsor, depositToken, proposalDeposit.sub(processingReward));
769     }
770 
771     function ragequit(uint256 sharesToBurn, uint256 lootToBurn) public nonReentrant onlyMember {
772         _ragequit(msg.sender, sharesToBurn, lootToBurn);
773     }
774 
775     function _ragequit(address memberAddress, uint256 sharesToBurn, uint256 lootToBurn) internal {
776         uint256 initialTotalSharesAndLoot = totalShares.add(totalLoot);
777 
778         Member storage member = members[memberAddress];
779 
780         require(member.shares >= sharesToBurn, "insufficient shares");
781         require(member.loot >= lootToBurn, "insufficient loot");
782 
783         require(canRagequit(member.highestIndexYesVote), "cannot ragequit until highest index proposal member voted YES on is processed");
784 
785         uint256 sharesAndLootToBurn = sharesToBurn.add(lootToBurn);
786 
787         // burn shares and loot
788         member.shares = member.shares.sub(sharesToBurn);
789         member.loot = member.loot.sub(lootToBurn);
790         totalShares = totalShares.sub(sharesToBurn);
791         totalLoot = totalLoot.sub(lootToBurn);
792 
793         for (uint256 i = 0; i < approvedTokens.length; i++) {
794             uint256 amountToRagequit = fairShare(userTokenBalances[GUILD][approvedTokens[i]], sharesAndLootToBurn, initialTotalSharesAndLoot);
795             if (amountToRagequit > 0) { // gas optimization to allow a higher maximum token limit
796                 // deliberately not using safemath here to keep overflows from preventing the function execution (which would break ragekicks)
797                 // if a token overflows, it is because the supply was artificially inflated to oblivion, so we probably don't care about it anyways
798                 userTokenBalances[GUILD][approvedTokens[i]] -= amountToRagequit;
799                 userTokenBalances[memberAddress][approvedTokens[i]] += amountToRagequit;
800             }
801         }
802 
803         emit Ragequit(msg.sender, sharesToBurn, lootToBurn);
804     }
805 
806     function ragekick(address memberToKick) public nonReentrant {
807         Member storage member = members[memberToKick];
808 
809         require(member.jailed != 0, "member must be in jail");
810         require(member.loot > 0, "member must have some loot"); // note - should be impossible for jailed member to have shares
811         require(canRagequit(member.highestIndexYesVote), "cannot ragequit until highest index proposal member voted YES on is processed");
812 
813         _ragequit(memberToKick, 0, member.loot);
814     }
815 
816     function withdrawBalance(address token, uint256 amount) public nonReentrant {
817         _withdrawBalance(token, amount);
818     }
819 
820     function withdrawBalances(address[] memory tokens, uint256[] memory amounts, bool max) public nonReentrant {
821         require(tokens.length == amounts.length, "tokens and amounts arrays must be matching lengths");
822 
823         for (uint256 i=0; i < tokens.length; i++) {
824             uint256 withdrawAmount = amounts[i];
825             if (max) { // withdraw the maximum balance
826                 withdrawAmount = userTokenBalances[msg.sender][tokens[i]];
827             }
828 
829             _withdrawBalance(tokens[i], withdrawAmount);
830         }
831     }
832     
833     function _withdrawBalance(address token, uint256 amount) internal {
834         require(userTokenBalances[msg.sender][token] >= amount, "insufficient balance");
835         unsafeSubtractFromBalance(msg.sender, token, amount);
836         require(IERC20(token).transfer(msg.sender, amount), "transfer failed");
837         emit Withdraw(msg.sender, token, amount);
838     }
839 
840     function collectTokens(address token) public onlyDelegate nonReentrant {
841         uint256 amountToCollect = IERC20(token).balanceOf(address(this)).sub(userTokenBalances[TOTAL][token]);
842         // only collect if 1) there are tokens to collect 2) token is whitelisted 3) token has non-zero balance
843         require(amountToCollect > 0, 'no tokens to collect');
844         require(tokenWhitelist[token], 'token to collect must be whitelisted');
845         require(userTokenBalances[GUILD][token] > 0, 'token to collect must have non-zero guild bank balance');
846         
847         unsafeAddToBalance(GUILD, token, amountToCollect);
848         emit TokensCollected(token, amountToCollect);
849     }
850 
851     // NOTE: requires that delegate key which sent the original proposal cancels, msg.sender == proposal.proposer
852     function cancelProposal(uint256 proposalId) public nonReentrant {
853         Proposal storage proposal = proposals[proposalId];
854         require(!proposal.flags[0], "proposal has already been sponsored");
855         require(!proposal.flags[3], "proposal has already been cancelled");
856         require(msg.sender == proposal.proposer, "solely the proposer can cancel");
857 
858         proposal.flags[3] = true; // cancelled
859         
860         unsafeInternalTransfer(ESCROW, proposal.proposer, proposal.tributeToken, proposal.tributeOffered);
861         emit CancelProposal(proposalId, msg.sender);
862     }
863 
864     function updateDelegateKey(address newDelegateKey) public nonReentrant onlyShareholder {
865         require(newDelegateKey != address(0), "newDelegateKey cannot be 0");
866 
867         // skip checks if member is setting the delegate key to their member address
868         if (newDelegateKey != msg.sender) {
869             require(!members[newDelegateKey].exists, "cannot overwrite existing members");
870             require(!members[memberAddressByDelegateKey[newDelegateKey]].exists, "cannot overwrite existing delegate keys");
871         }
872 
873         Member storage member = members[msg.sender];
874         memberAddressByDelegateKey[member.delegateKey] = address(0);
875         memberAddressByDelegateKey[newDelegateKey] = msg.sender;
876         member.delegateKey = newDelegateKey;
877 
878         emit UpdateDelegateKey(msg.sender, newDelegateKey);
879     }
880 
881     // can only ragequit if the latest proposal you voted YES on has been processed
882     function canRagequit(uint256 highestIndexYesVote) public view returns (bool) {
883         require(highestIndexYesVote < proposalQueue.length, "proposal does not exist");
884         return proposals[proposalQueue[highestIndexYesVote]].flags[1];
885     }
886 
887     function hasVotingPeriodExpired(uint256 startingPeriod) public view returns (bool) {
888         return getCurrentPeriod() >= startingPeriod.add(votingPeriodLength);
889     }
890 
891     /***************
892     GETTER FUNCTIONS
893     ***************/
894     function max(uint256 x, uint256 y) internal pure returns (uint256) {
895         return x >= y ? x : y;
896     }
897 
898     function getCurrentPeriod() public view returns (uint256) {
899         return now.sub(summoningTime).div(periodDuration);
900     }
901 
902     function getProposalQueueLength() public view returns (uint256) {
903         return proposalQueue.length;
904     }
905 
906     function getProposalFlags(uint256 proposalId) public view returns (bool[6] memory) {
907         return proposals[proposalId].flags;
908     }
909 
910     function getUserTokenBalance(address user, address token) public view returns (uint256) {
911         return userTokenBalances[user][token];
912     }
913 
914     function getMemberProposalVote(address memberAddress, uint256 proposalIndex) public view returns (Vote) {
915         require(members[memberAddress].exists, "member does not exist");
916         require(proposalIndex < proposalQueue.length, "proposal does not exist");
917         return proposals[proposalQueue[proposalIndex]].votesByMember[memberAddress];
918     }
919 
920     function getTokenCount() public view returns (uint256) {
921         return approvedTokens.length;
922     }
923 
924     /***************
925     HELPER FUNCTIONS
926     ***************/
927     function unsafeAddToBalance(address user, address token, uint256 amount) internal {
928         userTokenBalances[user][token] += amount;
929         userTokenBalances[TOTAL][token] += amount;
930     }
931 
932     function unsafeSubtractFromBalance(address user, address token, uint256 amount) internal {
933         userTokenBalances[user][token] -= amount;
934         userTokenBalances[TOTAL][token] -= amount;
935     }
936 
937     function unsafeInternalTransfer(address from, address to, address token, uint256 amount) internal {
938         unsafeSubtractFromBalance(from, token, amount);
939         unsafeAddToBalance(to, token, amount);
940     }
941 
942     function fairShare(uint256 balance, uint256 shares, uint256 totalShares) internal pure returns (uint256) {
943         require(totalShares != 0);
944 
945         if (balance == 0) { return 0; }
946 
947         uint256 prod = balance * shares;
948 
949         if (prod / balance == shares) { // no overflow in multiplication above?
950             return prod / totalShares;
951         }
952 
953         return (balance / totalShares) * shares;
954     }
955 }