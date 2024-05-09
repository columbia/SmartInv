1 pragma solidity 0.5.3;
2 
3 /*
4 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
5 	INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
6 	 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
7 	 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
8 	 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
9 	 ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
10 
11  © 2020 The LAO I, LLC
12     
13  Contract Address = 0x8F56682a50BECB1df2Fb8136954f2062871bc7fc
14 
15  Date Deployed = 04/27/2020 (1588000270) 
16 
17 
18       
19 
20 
21 */
22 library SafeMath {
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b);
30 
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35 
36         require(b > 0);
37         uint256 c = a / b;
38 
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a);
52 
53         return c;
54     }
55 }
56 interface IERC20 {
57     function transfer(address to, uint256 value) external returns (bool);
58 
59     function approve(address spender, uint256 value) external returns (bool);
60 
61     function transferFrom(address from, address to, uint256 value) external returns (bool);
62 
63     function totalSupply() external view returns (uint256);
64 
65     function balanceOf(address who) external view returns (uint256);
66 
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 /**
74  * @dev Contract module that helps prevent reentrant calls to a function.
75  *
76  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
77  * available, which can be applied to functions to make sure there are no nested
78  * (reentrant) calls to them.
79  *
80  * Note that because there is a single `nonReentrant` guard, functions marked as
81  * `nonReentrant` may not call one another. This can be worked around by making
82  * those functions `private`, and then adding `external` `nonReentrant` entry
83  * points to them.
84  *
85  * TIP: If you would like to learn more about reentrancy and alternative ways
86  * to protect against it, check out our blog post
87  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
88  *
89  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
90  * metering changes introduced in the Istanbul hardfork.
91  */
92  /*
93  * @dev Provides information about the current execution context, including the
94  * sender of the transaction and its data. While these are generally available
95  * via msg.sender and msg.data, they should not be accessed in such a direct
96  * manner, since when dealing with GSN meta-transactions the account sending and
97  * paying for execution may not be the actual sender (as far as an application
98  * is concerned).
99  *
100  * This contract is only required for intermediate, library-like contracts.
101  */
102 contract Context {
103     // Empty internal constructor, to prevent people from mistakenly deploying
104     // an instance of this contract, which should be used via inheritance.
105     constructor () internal { }
106     // solhint-disable-previous-line no-empty-blocks
107 
108     function _msgSender() internal view returns (address payable) {
109         return msg.sender;
110     }
111 
112     function _msgData() internal view returns (bytes memory) {
113         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
114         return msg.data;
115     }
116 }
117 
118 contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor () internal {
127         address msgSender = _msgSender();
128         _owner = msgSender;
129         emit OwnershipTransferred(address(0), msgSender);
130     }
131 
132     /**
133      * @dev Returns the address of the current owner.
134      */
135     function owner() public view returns (address) {
136         return _owner;
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         require(isOwner(), "Ownable: caller is not the owner");
144         _;
145     }
146 
147     /**
148      * @dev Returns true if the caller is the current owner.
149      */
150     function isOwner() public view returns (bool) {
151         return _msgSender() == _owner;
152     }
153 
154     /**
155      * @dev Leaves the contract without owner. It will not be possible to call
156      * `onlyOwner` functions anymore. Can only be called by the current owner.
157      *
158      * NOTE: Renouncing ownership will leave the contract without an owner,
159      * thereby removing any functionality that is only available to the owner.
160      */
161     function renounceOwnership() public onlyOwner {
162         emit OwnershipTransferred(_owner, address(0));
163         _owner = address(0);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Can only be called by the current owner.
169      */
170     function transferOwnership(address newOwner) public onlyOwner {
171         _transferOwnership(newOwner);
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      */
177     function _transferOwnership(address newOwner) internal {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         emit OwnershipTransferred(_owner, newOwner);
180         _owner = newOwner;
181     }
182 }
183 
184 contract ReentrancyGuard {
185     bool private _notEntered;
186 
187     constructor () internal {
188         // Storing an initial non-zero value makes deployment a bit more
189         // expensive, but in exchange the refund on every call to nonReentrant
190         // will be lower in amount. Since refunds are capped to a percetange of
191         // the total transaction's gas, it is best to keep them low in cases
192         // like this one, to increase the likelihood of the full refund coming
193         // into effect.
194         _notEntered = true;
195     }
196 
197     /**
198      * @dev Prevents a contract from calling itself, directly or indirectly.
199      * Calling a `nonReentrant` function from another `nonReentrant`
200      * function is not supported. It is possible to prevent this from happening
201      * by making the `nonReentrant` function external, and make it call a
202      * `private` function that does the actual work.
203      */
204     modifier nonReentrant() {
205         // On the first call to nonReentrant, _notEntered will be true
206         require(_notEntered, "ReentrancyGuard: reentrant call");
207 
208         // Any calls to nonReentrant after this point will fail
209         _notEntered = false;
210 
211         _;
212 
213         // By storing the original value once again, a refund is triggered (see
214         // https://eips.ethereum.org/EIPS/eip-2200)
215         _notEntered = true;
216     }
217 }
218 
219 contract Moloch is ReentrancyGuard, Ownable {
220     using SafeMath for uint256;
221 
222     /***************
223     GLOBAL CONSTANTS
224     ***************/
225     uint256 public periodDuration; // default = 17280 = 4.8 hours in seconds (5 periods per day)
226     uint256 public votingPeriodLength; // default = 35 periods (7 days)
227     uint256 public gracePeriodLength; // default = 35 periods (7 days)
228     uint256 public proposalDeposit; // default = 10 ETH (~$1,000 worth of ETH at contract deployment)
229     uint256 public dilutionBound; // default = 3 - maximum multiplier a YES voter will be obligated to pay in case of mass ragequit
230     uint256 public processingReward; // default = 0.1 - amount of ETH to give to whoever processes a proposal
231     uint256 public summoningTime; // needed to determine the current period
232 
233     address public depositToken; // deposit token contract reference; default = wETH
234     /******
235      AdminFee - LAO exclusive, add on to original Moloch
236      *********/
237     uint256 constant paymentPeriod = 90 days; //90 days; - 1 day is for test only!
238     uint256 public lastPaymentTime; //this will set as 'now' in construtor = summoningTime;
239     address public laoFundAddress; //This field MUST be set in constructor or set to default to summoner here.
240     uint256 public adminFeeDenominator = 200; //initial denominator
241    
242     // HARD-CODED LIMITS
243     // These numbers are quite arbitrary; they are small enough to avoid overflows when doing calculations
244     // with periods or shares, yet big enough to not limit reasonable use cases.
245     uint256 constant MAX_VOTING_PERIOD_LENGTH = 10**18; // maximum length of voting period
246     uint256 constant MAX_GRACE_PERIOD_LENGTH = 10**18; // maximum length of grace period
247     uint256 constant MAX_DILUTION_BOUND = 10**18; // maximum dilution bound
248     uint256 constant MAX_NUMBER_OF_SHARES_AND_LOOT = 10**18; // maximum number of shares that can be minted
249     uint256 constant MAX_TOKEN_WHITELIST_COUNT = 200; // maximum number of whitelisted tokens, default is 400
250     uint256 constant MAX_TOKEN_GUILDBANK_COUNT = 100; // maximum number of tokens with non-zero balance in guildbank, default is 200
251 
252     // ***************
253     // EVENTS
254     // ***************
255     event SummonComplete(address indexed summoner, address[] tokens, uint256 summoningTime, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 proposalDeposit, uint256 dilutionBound, uint256 processingReward);
256     event SubmitProposal(address indexed applicant, uint256 sharesRequested, uint256 lootRequested, uint256 tributeOffered, address tributeToken, uint256 paymentRequested, address paymentToken, string details, bool[6] flags, uint256 proposalId, address indexed delegateKey, address indexed memberAddress);
257     event SponsorProposal(address indexed delegateKey, address indexed memberAddress, uint256 proposalId, uint256 proposalIndex, uint256 startingPeriod);
258     event SubmitVote(uint256 proposalId, uint256 indexed proposalIndex, address indexed delegateKey, address indexed memberAddress, uint8 uintVote);
259     event ProcessProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
260     event ProcessWhitelistProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
261     event ProcessGuildKickProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
262     event Ragequit(address indexed memberAddress, uint256 sharesToBurn, uint256 lootToBurn);
263     event TokensCollected(address indexed token, uint256 amountToCollect);
264     event CancelProposal(uint256 indexed proposalId, address applicantAddress);
265     event UpdateDelegateKey(address indexed memberAddress, address newDelegateKey);
266     event Withdraw(address indexed memberAddress, address token, uint256 amount);
267 
268     // *******************
269     // INTERNAL ACCOUNTING
270     // *******************
271     uint256 public proposalCount = 0; // total proposals submitted
272     uint256 public totalShares = 0; // total shares across all members
273     uint256 public totalLoot = 0; // total loot across all members
274 
275     uint256 public totalGuildBankTokens = 0; // total tokens with non-zero balance in guild bank
276 
277     address public constant GUILD = address(0xdead);
278     address public constant ESCROW = address(0xbeef);
279     address public constant TOTAL = address(0xbabe);
280     mapping (address => mapping(address => uint256)) public userTokenBalances; // userTokenBalances[userAddress][tokenAddress]
281 
282     enum Vote {
283         Null, // default value, counted as abstention
284         Yes,
285         No
286     }
287 
288     struct Member {
289         address delegateKey; // the key responsible for submitting proposals and voting - defaults to member address unless updated
290         uint256 shares; // the # of voting shares assigned to this member
291         uint256 loot; // the loot amount available to this member (combined with shares on ragequit)
292         bool exists; // always true once a member has been created
293         uint256 highestIndexYesVote; // highest proposal index # on which the member voted YES
294         uint256 jailed; // set to proposalIndex of a passing guild kick proposal for this member, prevents voting on and sponsoring proposals
295     }
296 
297     struct Proposal {
298         address applicant; // the applicant who wishes to become a member - this key will be used for withdrawals (doubles as guild kick target for gkick proposals)
299         address proposer; // the account that submitted the proposal (can be non-member)
300         address sponsor; // the member that sponsored the proposal (moving it into the queue)
301         uint256 sharesRequested; // the # of shares the applicant is requesting
302         uint256 lootRequested; // the amount of loot the applicant is requesting
303         uint256 tributeOffered; // amount of tokens offered as tribute
304         address tributeToken; // tribute token contract reference
305         uint256 paymentRequested; // amount of tokens requested as payment
306         address paymentToken; // payment token contract reference
307         uint256 startingPeriod; // the period in which voting can start for this proposal
308         uint256 yesVotes; // the total number of YES votes for this proposal
309         uint256 noVotes; // the total number of NO votes for this proposal
310         bool[6] flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
311         string details; // proposal details - could be IPFS hash, plaintext, or JSON
312         uint256 maxTotalSharesAndLootAtYesVote; // the maximum # of total shares encountered at a yes vote on this proposal
313         mapping(address => Vote) votesByMember; // the votes on this proposal by each member
314     }
315 
316     mapping(address => bool) public tokenWhitelist;
317     address[] public approvedTokens;
318 
319     mapping(address => bool) public proposedToWhitelist;
320     mapping(address => bool) public proposedToKick;
321 
322     mapping(address => Member) public members;
323     mapping(address => address) public memberAddressByDelegateKey;
324 
325     mapping(uint256 => Proposal) public proposals;
326 
327     uint256[] public proposalQueue;
328 
329     modifier onlyMember {
330         require(members[msg.sender].shares > 0 || members[msg.sender].loot > 0, "not a member");
331         _;
332     }
333 
334     modifier onlyShareholder {
335         require(members[msg.sender].shares > 0, "not a shareholder");
336         _;
337     }
338 
339     modifier onlyDelegate {
340         require(members[memberAddressByDelegateKey[msg.sender]].shares > 0, "not a delegate");
341         _;
342     }
343 
344     constructor(
345         address _summoner,
346         address[] memory _approvedTokens,
347         uint256 _periodDuration,
348         uint256 _votingPeriodLength,
349         uint256 _gracePeriodLength,
350         uint256 _proposalDeposit,
351         uint256 _dilutionBound,
352         uint256 _processingReward,
353         address _laoFundAddress
354     ) public {
355         require(_summoner != address(0), "summoner cannot be 0");
356         require(_periodDuration > 0, "_periodDuration cannot be 0");
357         require(_votingPeriodLength > 0, "_votingPeriodLength cannot be 0");
358         require(_votingPeriodLength <= MAX_VOTING_PERIOD_LENGTH, "_votingPeriodLength exceeds limit");
359         require(_gracePeriodLength <= MAX_GRACE_PERIOD_LENGTH, "_gracePeriodLength exceeds limit");
360         require(_dilutionBound > 0, "_dilutionBound cannot be 0");
361         require(_dilutionBound <= MAX_DILUTION_BOUND, "_dilutionBound exceeds limit");
362         require(_approvedTokens.length > 0, "need at least one approved token");
363         require(_approvedTokens.length <= MAX_TOKEN_WHITELIST_COUNT, "too many tokens");
364         require(_proposalDeposit >= _processingReward, "_proposalDeposit cannot be smaller than _processingReward");
365         require(_laoFundAddress != address(0), "laoFundAddress cannot be 0");
366         depositToken = _approvedTokens[0];
367         // NOTE: move event up here, avoid stack too deep if too many approved tokens
368         emit SummonComplete(_summoner, _approvedTokens, now, _periodDuration, _votingPeriodLength, _gracePeriodLength, _proposalDeposit, _dilutionBound, _processingReward);
369 
370 
371         for (uint256 i = 0; i < _approvedTokens.length; i++) {
372             require(_approvedTokens[i] != address(0), "_approvedToken cannot be 0");
373             require(!tokenWhitelist[_approvedTokens[i]], "duplicate approved token");
374             tokenWhitelist[_approvedTokens[i]] = true;
375             approvedTokens.push(_approvedTokens[i]);
376         }
377 
378         periodDuration = _periodDuration;
379         votingPeriodLength = _votingPeriodLength;
380         gracePeriodLength = _gracePeriodLength;
381         proposalDeposit = _proposalDeposit;
382         dilutionBound = _dilutionBound;
383         processingReward = _processingReward;
384 
385         summoningTime = now;
386         laoFundAddress = _laoFundAddress; //LAO add on for adminFee
387         lastPaymentTime = now;  //LAO add on adminFee
388         members[_summoner] = Member(_summoner, 1, 0, true, 0, 0);
389         memberAddressByDelegateKey[_summoner] = _summoner;
390         totalShares = 1;
391        
392     }
393     
394     /*******
395 
396     ADMIN FEE FUNCTION 
397     -- LAO add on functions to MOLCOH
398     setAdminFee can only be changed by Owner
399     withdrawAdminFee can by be called by any ETH address
400 
401     ******/
402     
403     // @dev Owner can change amount of adminFee and direction of funds 
404     // @param adminFeeDenoimnator must be >= 200. Greater than 200, will equal 0.5% or less of assets.  
405     //@param laoFundAddress - where the Owner wants the funds to go. 
406 
407     function setAdminFee (uint256 _adminFeeDenominator, address _laoFundAddress) public nonReentrant onlyOwner{
408         require(_adminFeeDenominator >= 200); 
409         adminFeeDenominator = _adminFeeDenominator; 
410         laoFundAddress = _laoFundAddress;
411     } //end of setAdminFee
412     
413     //can be called by an ETH Address
414     function withdrawAdminFee () public nonReentrant {
415        
416         require (now >= lastPaymentTime.add(paymentPeriod), "90 days have not passed since last withdrawal");
417         lastPaymentTime = now;
418         //local variables to save gas by reading from storage only 1x
419         uint256 denominator = adminFeeDenominator; 
420         address recipient = laoFundAddress;
421         
422         for (uint256 i = 0; i < approvedTokens.length; i++) {
423             address token = approvedTokens[i];
424             uint256 amount = userTokenBalances[GUILD][token] / denominator;
425             if (amount > 0) { // otherwise skip for efficiency, only tokens with a balance
426                userTokenBalances[GUILD][token] -= amount;
427                userTokenBalances[recipient][token] += amount;
428             }
429         } 
430         // Remove Event emit WithdrawAdminFee(laoFundAddress,token, amount);
431     } //end of withdrawAdminFee
432     
433     /*****************
434     PROPOSAL FUNCTIONS
435     *****************/
436     function submitProposal(
437         address applicant,
438         uint256 sharesRequested,
439         uint256 lootRequested,
440         uint256 tributeOffered,
441         address tributeToken,
442         uint256 paymentRequested,
443         address paymentToken,
444         string memory details
445     ) public nonReentrant returns (uint256 proposalId) {
446         require(sharesRequested.add(lootRequested) <= MAX_NUMBER_OF_SHARES_AND_LOOT, "too many shares requested");
447         require(tokenWhitelist[tributeToken], "tributeToken is not whitelisted");
448         require(tokenWhitelist[paymentToken], "payment is not whitelisted");
449         require(applicant != address(0), "applicant cannot be 0");
450         require(applicant != GUILD && applicant != ESCROW && applicant != TOTAL, "applicant address cannot be reserved");
451         require(members[applicant].jailed == 0, "proposal applicant must not be jailed");
452 
453         if (tributeOffered > 0 && userTokenBalances[GUILD][tributeToken] == 0) {
454             require(totalGuildBankTokens < MAX_TOKEN_GUILDBANK_COUNT, 'cannot submit more tribute proposals for new tokens - guildbank is full');
455         }
456 
457         // collect tribute from proposer and store it in the Moloch until the proposal is processed
458         require(IERC20(tributeToken).transferFrom(msg.sender, address(this), tributeOffered), "tribute token transfer failed");
459         unsafeAddToBalance(ESCROW, tributeToken, tributeOffered);
460 
461         bool[6] memory flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
462 
463         _submitProposal(applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags);
464         return proposalCount - 1; // return proposalId - contracts calling submit might want it
465     }
466 
467     function submitWhitelistProposal(address tokenToWhitelist, string memory details) public nonReentrant returns (uint256 proposalId) {
468         require(tokenToWhitelist != address(0), "must provide token address");
469         require(!tokenWhitelist[tokenToWhitelist], "cannot already have whitelisted the token");
470         require(approvedTokens.length < MAX_TOKEN_WHITELIST_COUNT, "cannot submit more whitelist proposals");
471 
472         bool[6] memory flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
473         flags[4] = true; // whitelist
474 
475         _submitProposal(address(0), 0, 0, 0, tokenToWhitelist, 0, address(0), details, flags);
476         return proposalCount - 1;
477     }
478 
479     function submitGuildKickProposal(address memberToKick, string memory details) public nonReentrant returns (uint256 proposalId) {
480         Member memory member = members[memberToKick];
481 
482         require(member.shares > 0 || member.loot > 0, "member must have at least one share or one loot");
483         require(members[memberToKick].jailed == 0, "member must not already be jailed");
484 
485         bool[6] memory flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
486         flags[5] = true; // guild kick
487 
488         _submitProposal(memberToKick, 0, 0, 0, address(0), 0, address(0), details, flags);
489         return proposalCount - 1;
490     }
491 
492     function _submitProposal(
493         address applicant,
494         uint256 sharesRequested,
495         uint256 lootRequested,
496         uint256 tributeOffered,
497         address tributeToken,
498         uint256 paymentRequested,
499         address paymentToken,
500         string memory details,
501         bool[6] memory flags
502     ) internal {
503         Proposal memory proposal = Proposal({
504             applicant : applicant,
505             proposer : msg.sender,
506             sponsor : address(0),
507             sharesRequested : sharesRequested,
508             lootRequested : lootRequested,
509             tributeOffered : tributeOffered,
510             tributeToken : tributeToken,
511             paymentRequested : paymentRequested,
512             paymentToken : paymentToken,
513             startingPeriod : 0,
514             yesVotes : 0,
515             noVotes : 0,
516             flags : flags,
517             details : details,
518             maxTotalSharesAndLootAtYesVote : 0
519         });
520 
521         proposals[proposalCount] = proposal;
522         address memberAddress = memberAddressByDelegateKey[msg.sender];
523         // NOTE: argument order matters, avoid stack too deep
524         emit SubmitProposal(applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags, proposalCount, msg.sender, memberAddress);
525         proposalCount += 1;
526     }
527 
528     function sponsorProposal(uint256 proposalId) public nonReentrant onlyDelegate {
529         // collect proposal deposit from sponsor and store it in the Moloch until the proposal is processed
530         require(IERC20(depositToken).transferFrom(msg.sender, address(this), proposalDeposit), "proposal deposit token transfer failed");
531         unsafeAddToBalance(ESCROW, depositToken, proposalDeposit);
532 
533         Proposal storage proposal = proposals[proposalId];
534 
535         require(proposal.proposer != address(0), 'proposal must have been proposed');
536         require(!proposal.flags[0], "proposal has already been sponsored");
537         require(!proposal.flags[3], "proposal has been cancelled");
538         require(members[proposal.applicant].jailed == 0, "proposal applicant must not be jailed");
539 
540         if (proposal.tributeOffered > 0 && userTokenBalances[GUILD][proposal.tributeToken] == 0) {
541             require(totalGuildBankTokens < MAX_TOKEN_GUILDBANK_COUNT, 'cannot sponsor more tribute proposals for new tokens - guildbank is full');
542         }
543 
544         // whitelist proposal
545         if (proposal.flags[4]) {
546             require(!tokenWhitelist[address(proposal.tributeToken)], "cannot already have whitelisted the token");
547             require(!proposedToWhitelist[address(proposal.tributeToken)], 'already proposed to whitelist');
548             require(approvedTokens.length < MAX_TOKEN_WHITELIST_COUNT, "cannot sponsor more whitelist proposals");
549             proposedToWhitelist[address(proposal.tributeToken)] = true;
550 
551         // guild kick proposal
552         } else if (proposal.flags[5]) {
553             require(!proposedToKick[proposal.applicant], 'already proposed to kick');
554             proposedToKick[proposal.applicant] = true;
555         }
556 
557         // compute startingPeriod for proposal
558         uint256 startingPeriod = max(
559             getCurrentPeriod(),
560             proposalQueue.length == 0 ? 0 : proposals[proposalQueue[proposalQueue.length.sub(1)]].startingPeriod
561         ).add(1);
562 
563         proposal.startingPeriod = startingPeriod;
564 
565         address memberAddress = memberAddressByDelegateKey[msg.sender];
566         proposal.sponsor = memberAddress;
567 
568         proposal.flags[0] = true; // sponsored
569 
570         // append proposal to the queue
571         proposalQueue.push(proposalId);
572         
573         emit SponsorProposal(msg.sender, memberAddress, proposalId, proposalQueue.length.sub(1), startingPeriod);
574     }
575 
576     // NOTE: In MolochV2 proposalIndex !== proposalId
577     function submitVote(uint256 proposalIndex, uint8 uintVote) public nonReentrant onlyDelegate {
578         address memberAddress = memberAddressByDelegateKey[msg.sender];
579         Member storage member = members[memberAddress];
580 
581         require(proposalIndex < proposalQueue.length, "proposal does not exist");
582         Proposal storage proposal = proposals[proposalQueue[proposalIndex]];
583 
584         require(uintVote < 3, "must be less than 3");
585         Vote vote = Vote(uintVote);
586 
587         require(getCurrentPeriod() >= proposal.startingPeriod, "voting period has not started");
588         require(!hasVotingPeriodExpired(proposal.startingPeriod), "proposal voting period has expired");
589         require(proposal.votesByMember[memberAddress] == Vote.Null, "member has already voted");
590         require(vote == Vote.Yes || vote == Vote.No, "vote must be either Yes or No");
591 
592         proposal.votesByMember[memberAddress] = vote;
593 
594         if (vote == Vote.Yes) {
595             proposal.yesVotes = proposal.yesVotes.add(member.shares);
596 
597             // set highest index (latest) yes vote - must be processed for member to ragequit
598             if (proposalIndex > member.highestIndexYesVote) {
599                 member.highestIndexYesVote = proposalIndex;
600             }
601 
602             // set maximum of total shares encountered at a yes vote - used to bound dilution for yes voters
603             if (totalShares.add(totalLoot) > proposal.maxTotalSharesAndLootAtYesVote) {
604                 proposal.maxTotalSharesAndLootAtYesVote = totalShares.add(totalLoot);
605             }
606 
607         } else if (vote == Vote.No) {
608             proposal.noVotes = proposal.noVotes.add(member.shares);
609         }
610      
611         // NOTE: subgraph indexes by proposalId not proposalIndex since proposalIndex isn't set untill it's been sponsored but proposal is created on submission
612         emit SubmitVote(proposalQueue[proposalIndex], proposalIndex, msg.sender, memberAddress, uintVote);
613     }
614 
615     function processProposal(uint256 proposalIndex) public nonReentrant {
616         _validateProposalForProcessing(proposalIndex);
617 
618         uint256 proposalId = proposalQueue[proposalIndex];
619         Proposal storage proposal = proposals[proposalId];
620 
621         require(!proposal.flags[4] && !proposal.flags[5], "must be a standard proposal");
622 
623         proposal.flags[1] = true; // processed
624 
625         bool didPass = _didPass(proposalIndex);
626 
627         // Make the proposal fail if the new total number of shares and loot exceeds the limit
628         if (totalShares.add(totalLoot).add(proposal.sharesRequested).add(proposal.lootRequested) > MAX_NUMBER_OF_SHARES_AND_LOOT) {
629             didPass = false;
630         }
631 
632         // Make the proposal fail if it is requesting more tokens as payment than the available guild bank balance
633         if (proposal.paymentRequested > userTokenBalances[GUILD][proposal.paymentToken]) {
634             didPass = false;
635         }
636 
637         // Make the proposal fail if it would result in too many tokens with non-zero balance in guild bank
638         if (proposal.tributeOffered > 0 && userTokenBalances[GUILD][proposal.tributeToken] == 0 && totalGuildBankTokens >= MAX_TOKEN_GUILDBANK_COUNT) {
639            didPass = false;
640         }
641 
642         // PROPOSAL PASSED
643         if (didPass) {
644             proposal.flags[2] = true; // didPass
645 
646             // if the applicant is already a member, add to their existing shares & loot
647             if (members[proposal.applicant].exists) {
648                 members[proposal.applicant].shares = members[proposal.applicant].shares.add(proposal.sharesRequested);
649                 members[proposal.applicant].loot = members[proposal.applicant].loot.add(proposal.lootRequested);
650 
651             // the applicant is a new member, create a new record for them
652             } else {
653                 // if the applicant address is already taken by a member's delegateKey, reset it to their member address
654                 if (members[memberAddressByDelegateKey[proposal.applicant]].exists) {
655                     address memberToOverride = memberAddressByDelegateKey[proposal.applicant];
656                     memberAddressByDelegateKey[memberToOverride] = memberToOverride;
657                     members[memberToOverride].delegateKey = memberToOverride;
658                 }
659 
660                 // use applicant address as delegateKey by default
661                 members[proposal.applicant] = Member(proposal.applicant, proposal.sharesRequested, proposal.lootRequested, true, 0, 0);
662                 memberAddressByDelegateKey[proposal.applicant] = proposal.applicant;
663             }
664 
665             // mint new shares & loot
666             totalShares = totalShares.add(proposal.sharesRequested);
667             totalLoot = totalLoot.add(proposal.lootRequested);
668 
669             // if the proposal tribute is the first tokens of its kind to make it into the guild bank, increment total guild bank tokens
670             if (userTokenBalances[GUILD][proposal.tributeToken] == 0 && proposal.tributeOffered > 0) {
671                 totalGuildBankTokens += 1;
672             }
673 
674             unsafeInternalTransfer(ESCROW, GUILD, proposal.tributeToken, proposal.tributeOffered);
675             unsafeInternalTransfer(GUILD, proposal.applicant, proposal.paymentToken, proposal.paymentRequested);
676 
677             // if the proposal spends 100% of guild bank balance for a token, decrement total guild bank tokens
678             if (userTokenBalances[GUILD][proposal.paymentToken] == 0 && proposal.paymentRequested > 0) {
679                 totalGuildBankTokens -= 1;
680             }
681 
682         // PROPOSAL FAILED
683         } else {
684             // return all tokens to the proposer (not the applicant, because funds come from proposer)
685             unsafeInternalTransfer(ESCROW, proposal.proposer, proposal.tributeToken, proposal.tributeOffered);
686         }
687 
688         _returnDeposit(proposal.sponsor);
689 
690         emit ProcessProposal(proposalIndex, proposalId, didPass);
691     }
692 
693     function processWhitelistProposal(uint256 proposalIndex) public nonReentrant {
694         _validateProposalForProcessing(proposalIndex);
695 
696         uint256 proposalId = proposalQueue[proposalIndex];
697         Proposal storage proposal = proposals[proposalId];
698 
699         require(proposal.flags[4], "must be a whitelist proposal");
700 
701         proposal.flags[1] = true; // processed
702 
703         bool didPass = _didPass(proposalIndex);
704 
705         if (approvedTokens.length >= MAX_TOKEN_WHITELIST_COUNT) {
706             didPass = false;
707         }
708 
709         if (didPass) {
710             proposal.flags[2] = true; // didPass
711 
712             tokenWhitelist[address(proposal.tributeToken)] = true;
713             approvedTokens.push(proposal.tributeToken);
714         }
715 
716         proposedToWhitelist[address(proposal.tributeToken)] = false;
717 
718         _returnDeposit(proposal.sponsor);
719 
720         emit ProcessWhitelistProposal(proposalIndex, proposalId, didPass);
721     }
722 
723     function processGuildKickProposal(uint256 proposalIndex) public nonReentrant {
724         _validateProposalForProcessing(proposalIndex);
725 
726         uint256 proposalId = proposalQueue[proposalIndex];
727         Proposal storage proposal = proposals[proposalId];
728 
729         require(proposal.flags[5], "must be a guild kick proposal");
730 
731         proposal.flags[1] = true; // processed
732 
733         bool didPass = _didPass(proposalIndex);
734 
735         if (didPass) {
736             proposal.flags[2] = true; // didPass
737             Member storage member = members[proposal.applicant];
738             member.jailed = proposalIndex;
739 
740             // transfer shares to loot
741             member.loot = member.loot.add(member.shares);
742             totalShares = totalShares.sub(member.shares);
743             totalLoot = totalLoot.add(member.shares);
744             member.shares = 0; // revoke all shares
745         }
746 
747         proposedToKick[proposal.applicant] = false;
748 
749         _returnDeposit(proposal.sponsor);
750 
751         emit ProcessGuildKickProposal(proposalIndex, proposalId, didPass);
752     }
753 
754     function _didPass(uint256 proposalIndex) internal view returns  (bool didPass) {
755         Proposal memory proposal = proposals[proposalQueue[proposalIndex]];
756 
757         didPass = proposal.yesVotes > proposal.noVotes;
758 
759         // Make the proposal fail if the dilutionBound is exceeded
760         if ((totalShares.add(totalLoot)).mul(dilutionBound) < proposal.maxTotalSharesAndLootAtYesVote) {
761             didPass = false;
762         }
763 
764         // Make the proposal fail if the applicant is jailed
765         // - for standard proposals, we don't want the applicant to get any shares/loot/payment
766         // - for guild kick proposals, we should never be able to propose to kick a jailed member (or have two kick proposals active), so it doesn't matter
767         if (members[proposal.applicant].jailed != 0) {
768             didPass = false;
769         }
770 
771         return didPass;
772     }
773 
774     function _validateProposalForProcessing(uint256 proposalIndex) internal view {
775         require(proposalIndex < proposalQueue.length, "proposal does not exist");
776         Proposal memory proposal = proposals[proposalQueue[proposalIndex]];
777 
778         require(getCurrentPeriod() >= proposal.startingPeriod.add(votingPeriodLength).add(gracePeriodLength), "proposal is not ready to be processed");
779         require(proposal.flags[1] == false, "proposal has already been processed");
780         require(proposalIndex == 0 || proposals[proposalQueue[proposalIndex.sub(1)]].flags[1], "previous proposal must be processed");
781     }
782 
783     function _returnDeposit(address sponsor) internal {
784         unsafeInternalTransfer(ESCROW, msg.sender, depositToken, processingReward);
785         unsafeInternalTransfer(ESCROW, sponsor, depositToken, proposalDeposit.sub(processingReward));
786     }
787 
788     function ragequit(uint256 sharesToBurn, uint256 lootToBurn) public nonReentrant onlyMember {
789         _ragequit(msg.sender, sharesToBurn, lootToBurn);
790     }
791 
792     function _ragequit(address memberAddress, uint256 sharesToBurn, uint256 lootToBurn) internal {
793         uint256 initialTotalSharesAndLoot = totalShares.add(totalLoot);
794 
795         Member storage member = members[memberAddress];
796 
797         require(member.shares >= sharesToBurn, "insufficient shares");
798         require(member.loot >= lootToBurn, "insufficient loot");
799 
800         require(canRagequit(member.highestIndexYesVote), "cannot ragequit until highest index proposal member voted YES on is processed");
801 
802         uint256 sharesAndLootToBurn = sharesToBurn.add(lootToBurn);
803 
804         // burn shares and loot
805         member.shares = member.shares.sub(sharesToBurn);
806         member.loot = member.loot.sub(lootToBurn);
807         totalShares = totalShares.sub(sharesToBurn);
808         totalLoot = totalLoot.sub(lootToBurn);
809 
810         for (uint256 i = 0; i < approvedTokens.length; i++) {
811             uint256 amountToRagequit = fairShare(userTokenBalances[GUILD][approvedTokens[i]], sharesAndLootToBurn, initialTotalSharesAndLoot);
812             if (amountToRagequit > 0) { // gas optimization to allow a higher maximum token limit
813                 // deliberately not using safemath here to keep overflows from preventing the function execution (which would break ragekicks)
814                 // if a token overflows, it is because the supply was artificially inflated to oblivion, so we probably don't care about it anyways
815                 userTokenBalances[GUILD][approvedTokens[i]] -= amountToRagequit;
816                 userTokenBalances[memberAddress][approvedTokens[i]] += amountToRagequit;
817             }
818         }
819 
820         emit Ragequit(msg.sender, sharesToBurn, lootToBurn);
821     }
822 
823     function ragekick(address memberToKick) public nonReentrant {
824         Member storage member = members[memberToKick];
825 
826         require(member.jailed != 0, "member must be in jail");
827         require(member.loot > 0, "member must have some loot"); // note - should be impossible for jailed member to have shares
828         require(canRagequit(member.highestIndexYesVote), "cannot ragequit until highest index proposal member voted YES on is processed");
829 
830         _ragequit(memberToKick, 0, member.loot);
831     }
832 
833     function withdrawBalance(address token, uint256 amount) public nonReentrant {
834         _withdrawBalance(token, amount);
835     }
836 
837     function withdrawBalances(address[] memory tokens, uint256[] memory amounts, bool max) public nonReentrant {
838         require(tokens.length == amounts.length, "tokens and amounts arrays must be matching lengths");
839 
840         for (uint256 i=0; i < tokens.length; i++) {
841             uint256 withdrawAmount = amounts[i];
842             if (max) { // withdraw the maximum balance
843                 withdrawAmount = userTokenBalances[msg.sender][tokens[i]];
844             }
845 
846             _withdrawBalance(tokens[i], withdrawAmount);
847         }
848     }
849     
850     function _withdrawBalance(address token, uint256 amount) internal {
851         require(userTokenBalances[msg.sender][token] >= amount, "insufficient balance");
852         unsafeSubtractFromBalance(msg.sender, token, amount);
853         require(IERC20(token).transfer(msg.sender, amount), "transfer failed");
854         emit Withdraw(msg.sender, token, amount);
855     }
856 
857     function collectTokens(address token) public onlyDelegate nonReentrant {
858         uint256 amountToCollect = IERC20(token).balanceOf(address(this)).sub(userTokenBalances[TOTAL][token]);
859         // only collect if 1) there are tokens to collect 2) token is whitelisted 3) token has non-zero balance
860         require(amountToCollect > 0, 'no tokens to collect');
861         require(tokenWhitelist[token], 'token to collect must be whitelisted');
862         require(userTokenBalances[GUILD][token] > 0, 'token to collect must have non-zero guild bank balance');
863         
864         unsafeAddToBalance(GUILD, token, amountToCollect);
865         emit TokensCollected(token, amountToCollect);
866     }
867 
868     // NOTE: requires that delegate key which sent the original proposal cancels, msg.sender == proposal.proposer
869     function cancelProposal(uint256 proposalId) public nonReentrant {
870         Proposal storage proposal = proposals[proposalId];
871         require(!proposal.flags[0], "proposal has already been sponsored");
872         require(!proposal.flags[3], "proposal has already been cancelled");
873         require(msg.sender == proposal.proposer, "solely the proposer can cancel");
874 
875         proposal.flags[3] = true; // cancelled
876         
877         unsafeInternalTransfer(ESCROW, proposal.proposer, proposal.tributeToken, proposal.tributeOffered);
878         emit CancelProposal(proposalId, msg.sender);
879     }
880 
881     function updateDelegateKey(address newDelegateKey) public nonReentrant onlyShareholder {
882         require(newDelegateKey != address(0), "newDelegateKey cannot be 0");
883 
884         // skip checks if member is setting the delegate key to their member address
885         if (newDelegateKey != msg.sender) {
886             require(!members[newDelegateKey].exists, "cannot overwrite existing members");
887             require(!members[memberAddressByDelegateKey[newDelegateKey]].exists, "cannot overwrite existing delegate keys");
888         }
889 
890         Member storage member = members[msg.sender];
891         memberAddressByDelegateKey[member.delegateKey] = address(0);
892         memberAddressByDelegateKey[newDelegateKey] = msg.sender;
893         member.delegateKey = newDelegateKey;
894 
895         emit UpdateDelegateKey(msg.sender, newDelegateKey);
896     }
897 
898     // can only ragequit if the latest proposal you voted YES on has been processed
899     function canRagequit(uint256 highestIndexYesVote) public view returns (bool) {
900         require(highestIndexYesVote < proposalQueue.length, "proposal does not exist");
901         return proposals[proposalQueue[highestIndexYesVote]].flags[1];
902     }
903 
904     function hasVotingPeriodExpired(uint256 startingPeriod) public view returns (bool) {
905         return getCurrentPeriod() >= startingPeriod.add(votingPeriodLength);
906     }
907 
908     /***************
909     GETTER FUNCTIONS
910     ***************/
911 
912     function max(uint256 x, uint256 y) internal pure returns (uint256) {
913         return x >= y ? x : y;
914     }
915 
916     function getCurrentPeriod() public view returns (uint256) {
917         return now.sub(summoningTime).div(periodDuration);
918     }
919 
920     function getProposalQueueLength() public view returns (uint256) {
921         return proposalQueue.length;
922     }
923 
924     function getProposalFlags(uint256 proposalId) public view returns (bool[6] memory) {
925         return proposals[proposalId].flags;
926     }
927 
928     function getUserTokenBalance(address user, address token) public view returns (uint256) {
929         return userTokenBalances[user][token];
930     }
931 
932     function getMemberProposalVote(address memberAddress, uint256 proposalIndex) public view returns (Vote) {
933         require(members[memberAddress].exists, "member does not exist");
934         require(proposalIndex < proposalQueue.length, "proposal does not exist");
935         return proposals[proposalQueue[proposalIndex]].votesByMember[memberAddress];
936     }
937 
938     function getTokenCount() public view returns (uint256) {
939         return approvedTokens.length;
940     }
941 
942     /***************
943     HELPER FUNCTIONS
944     ***************/
945     function unsafeAddToBalance(address user, address token, uint256 amount) internal {
946         userTokenBalances[user][token] += amount;
947         userTokenBalances[TOTAL][token] += amount;
948     }
949 
950     function unsafeSubtractFromBalance(address user, address token, uint256 amount) internal {
951         userTokenBalances[user][token] -= amount;
952         userTokenBalances[TOTAL][token] -= amount;
953     }
954 
955     function unsafeInternalTransfer(address from, address to, address token, uint256 amount) internal {
956         unsafeSubtractFromBalance(from, token, amount);
957         unsafeAddToBalance(to, token, amount);
958     }
959 
960     function fairShare(uint256 balance, uint256 shares, uint256 totalShares) internal pure returns (uint256) {
961         require(totalShares != 0);
962 
963         if (balance == 0) { return 0; }
964 
965         uint256 prod = balance * shares;
966 
967         if (prod / balance == shares) { // no overflow in multiplication above?
968             return prod / totalShares;
969         }
970 
971         return (balance / totalShares) * shares;
972     }
973 }