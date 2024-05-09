1 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
7  *
8  * These functions can be used to verify that a message was signed by the holder
9  * of the private keys of a given address.
10  */
11 library ECDSA {
12     /**
13      * @dev Returns the address that signed a hashed message (`hash`) with
14      * `signature`. This address can then be used for verification purposes.
15      *
16      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
17      * this function rejects them by requiring the `s` value to be in the lower
18      * half order, and the `v` value to be either 27 or 28.
19      *
20      * (.note) This call _does not revert_ if the signature is invalid, or
21      * if the signer is otherwise unable to be retrieved. In those scenarios,
22      * the zero address is returned.
23      *
24      * (.warning) `hash` _must_ be the result of a hash operation for the
25      * verification to be secure: it is possible to craft signatures that
26      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
27      * this is by receiving a hash of the original message (which may otherwise)
28      * be too long), and then calling `toEthSignedMessageHash` on it.
29      */
30     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
31         // Check the signature length
32         if (signature.length != 65) {
33             return (address(0));
34         }
35 
36         // Divide the signature in r, s and v variables
37         bytes32 r;
38         bytes32 s;
39         uint8 v;
40 
41         // ecrecover takes the signature parameters, and the only way to get them
42         // currently is to use assembly.
43         // solhint-disable-next-line no-inline-assembly
44         assembly {
45             r := mload(add(signature, 0x20))
46             s := mload(add(signature, 0x40))
47             v := byte(0, mload(add(signature, 0x60)))
48         }
49 
50         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
51         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
52         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
53         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
54         //
55         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
56         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
57         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
58         // these malleable signatures as well.
59         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
60             return address(0);
61         }
62 
63         if (v != 27 && v != 28) {
64             return address(0);
65         }
66 
67         // If the signature is valid (and not malleable), return the signer address
68         return ecrecover(hash, v, r, s);
69     }
70 
71     /**
72      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
73      * replicates the behavior of the
74      * [`eth_sign`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign)
75      * JSON-RPC method.
76      *
77      * See `recover`.
78      */
79     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
80         // 32 is the length in bytes of hash,
81         // enforced by the type signature above
82         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
83     }
84 }
85 
86 // File: @daostack/infra/contracts/votingMachines/IntVoteInterface.sol
87 
88 pragma solidity ^0.5.11;
89 
90 interface IntVoteInterface {
91     //When implementing this interface please do not only override function and modifier,
92     //but also to keep the modifiers on the overridden functions.
93     modifier onlyProposalOwner(bytes32 _proposalId) {revert(); _;}
94     modifier votable(bytes32 _proposalId) {revert(); _;}
95 
96     event NewProposal(
97         bytes32 indexed _proposalId,
98         address indexed _organization,
99         uint256 _numOfChoices,
100         address _proposer,
101         bytes32 _paramsHash
102     );
103 
104     event ExecuteProposal(bytes32 indexed _proposalId,
105         address indexed _organization,
106         uint256 _decision,
107         uint256 _totalReputation
108     );
109 
110     event VoteProposal(
111         bytes32 indexed _proposalId,
112         address indexed _organization,
113         address indexed _voter,
114         uint256 _vote,
115         uint256 _reputation
116     );
117 
118     event CancelProposal(bytes32 indexed _proposalId, address indexed _organization );
119     event CancelVoting(bytes32 indexed _proposalId, address indexed _organization, address indexed _voter);
120 
121     /**
122      * @dev register a new proposal with the given parameters. Every proposal has a unique ID which is being
123      * generated by calculating keccak256 of a incremented counter.
124      * @param _numOfChoices number of voting choices
125      * @param _proposalParameters defines the parameters of the voting machine used for this proposal
126      * @param _proposer address
127      * @param _organization address - if this address is zero the msg.sender will be used as the organization address.
128      * @return proposal's id.
129      */
130     function propose(
131         uint256 _numOfChoices,
132         bytes32 _proposalParameters,
133         address _proposer,
134         address _organization
135         ) external returns(bytes32);
136 
137     function vote(
138         bytes32 _proposalId,
139         uint256 _vote,
140         uint256 _rep,
141         address _voter
142     )
143     external
144     returns(bool);
145 
146     function cancelVote(bytes32 _proposalId) external;
147 
148     function getNumberOfChoices(bytes32 _proposalId) external view returns(uint256);
149 
150     function isVotable(bytes32 _proposalId) external view returns(bool);
151 
152     /**
153      * @dev voteStatus returns the reputation voted for a proposal for a specific voting choice.
154      * @param _proposalId the ID of the proposal
155      * @param _choice the index in the
156      * @return voted reputation for the given choice
157      */
158     function voteStatus(bytes32 _proposalId, uint256 _choice) external view returns(uint256);
159 
160     /**
161      * @dev isAbstainAllow returns if the voting machine allow abstain (0)
162      * @return bool true or false
163      */
164     function isAbstainAllow() external pure returns(bool);
165 
166     /**
167      * @dev getAllowedRangeOfChoices returns the allowed range of choices for a voting machine.
168      * @return min - minimum number of choices
169                max - maximum number of choices
170      */
171     function getAllowedRangeOfChoices() external pure returns(uint256 min, uint256 max);
172 }
173 
174 // File: @daostack/infra/contracts/libs/RealMath.sol
175 
176 pragma solidity ^0.5.11;
177 
178 /**
179  * RealMath: fixed-point math library, based on fractional and integer parts.
180  * Using uint256 as real216x40, which isn't in Solidity yet.
181  * Internally uses the wider uint256 for some math.
182  *
183  * Note that for addition, subtraction, and mod (%), you should just use the
184  * built-in Solidity operators. Functions for these operations are not provided.
185  *
186  */
187 
188 
189 library RealMath {
190 
191     /**
192      * How many total bits are there?
193      */
194     uint256 constant private REAL_BITS = 256;
195 
196     /**
197      * How many fractional bits are there?
198      */
199     uint256 constant private REAL_FBITS = 40;
200 
201     /**
202      * What's the first non-fractional bit
203      */
204     uint256 constant private REAL_ONE = uint256(1) << REAL_FBITS;
205 
206     /**
207      * Raise a real number to any positive integer power
208      */
209     function pow(uint256 realBase, uint256 exponent) internal pure returns (uint256) {
210 
211         uint256 tempRealBase = realBase;
212         uint256 tempExponent = exponent;
213 
214         // Start with the 0th power
215         uint256 realResult = REAL_ONE;
216         while (tempExponent != 0) {
217             // While there are still bits set
218             if ((tempExponent & 0x1) == 0x1) {
219                 // If the low bit is set, multiply in the (many-times-squared) base
220                 realResult = mul(realResult, tempRealBase);
221             }
222                 // Shift off the low bit
223             tempExponent = tempExponent >> 1;
224             if (tempExponent != 0) {
225                 // Do the squaring
226                 tempRealBase = mul(tempRealBase, tempRealBase);
227             }
228         }
229 
230         // Return the final result.
231         return realResult;
232     }
233 
234     /**
235      * Create a real from a rational fraction.
236      */
237     function fraction(uint216 numerator, uint216 denominator) internal pure returns (uint256) {
238         return div(uint256(numerator) * REAL_ONE, uint256(denominator) * REAL_ONE);
239     }
240 
241     /**
242      * Multiply one real by another. Truncates overflows.
243      */
244     function mul(uint256 realA, uint256 realB) private pure returns (uint256) {
245         // When multiplying fixed point in x.y and z.w formats we get (x+z).(y+w) format.
246         // So we just have to clip off the extra REAL_FBITS fractional bits.
247         uint256 res = realA * realB;
248         require(res/realA == realB, "RealMath mul overflow");
249         return (res >> REAL_FBITS);
250     }
251 
252     /**
253      * Divide one real by another real. Truncates overflows.
254      */
255     function div(uint256 realNumerator, uint256 realDenominator) private pure returns (uint256) {
256         // We use the reverse of the multiplication trick: convert numerator from
257         // x.y to (x+z).(y+w) fixed point, then divide by denom in z.w fixed point.
258         return uint256((uint256(realNumerator) * REAL_ONE) / uint256(realDenominator));
259     }
260 
261 }
262 
263 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
264 
265 pragma solidity ^0.5.0;
266 
267 /**
268  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
269  * the optional functions; to access them see `ERC20Detailed`.
270  */
271 interface IERC20 {
272     /**
273      * @dev Returns the amount of tokens in existence.
274      */
275     function totalSupply() external view returns (uint256);
276 
277     /**
278      * @dev Returns the amount of tokens owned by `account`.
279      */
280     function balanceOf(address account) external view returns (uint256);
281 
282     /**
283      * @dev Moves `amount` tokens from the caller's account to `recipient`.
284      *
285      * Returns a boolean value indicating whether the operation succeeded.
286      *
287      * Emits a `Transfer` event.
288      */
289     function transfer(address recipient, uint256 amount) external returns (bool);
290 
291     /**
292      * @dev Returns the remaining number of tokens that `spender` will be
293      * allowed to spend on behalf of `owner` through `transferFrom`. This is
294      * zero by default.
295      *
296      * This value changes when `approve` or `transferFrom` are called.
297      */
298     function allowance(address owner, address spender) external view returns (uint256);
299 
300     /**
301      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
302      *
303      * Returns a boolean value indicating whether the operation succeeded.
304      *
305      * > Beware that changing an allowance with this method brings the risk
306      * that someone may use both the old and the new allowance by unfortunate
307      * transaction ordering. One possible solution to mitigate this race
308      * condition is to first reduce the spender's allowance to 0 and set the
309      * desired value afterwards:
310      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
311      *
312      * Emits an `Approval` event.
313      */
314     function approve(address spender, uint256 amount) external returns (bool);
315 
316     /**
317      * @dev Moves `amount` tokens from `sender` to `recipient` using the
318      * allowance mechanism. `amount` is then deducted from the caller's
319      * allowance.
320      *
321      * Returns a boolean value indicating whether the operation succeeded.
322      *
323      * Emits a `Transfer` event.
324      */
325     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
326 
327     /**
328      * @dev Emitted when `value` tokens are moved from one account (`from`) to
329      * another (`to`).
330      *
331      * Note that `value` may be zero.
332      */
333     event Transfer(address indexed from, address indexed to, uint256 value);
334 
335     /**
336      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
337      * a call to `approve`. `value` is the new allowance.
338      */
339     event Approval(address indexed owner, address indexed spender, uint256 value);
340 }
341 
342 // File: @daostack/infra/contracts/votingMachines/VotingMachineCallbacksInterface.sol
343 
344 pragma solidity ^0.5.11;
345 
346 
347 interface VotingMachineCallbacksInterface {
348     function mintReputation(uint256 _amount, address _beneficiary, bytes32 _proposalId) external returns(bool);
349     function burnReputation(uint256 _amount, address _owner, bytes32 _proposalId) external returns(bool);
350 
351     function stakingTokenTransfer(IERC20 _stakingToken, address _beneficiary, uint256 _amount, bytes32 _proposalId)
352     external
353     returns(bool);
354 
355     function getTotalReputationSupply(bytes32 _proposalId) external view returns(uint256);
356     function reputationOf(address _owner, bytes32 _proposalId) external view returns(uint256);
357     function balanceOfStakingToken(IERC20 _stakingToken, bytes32 _proposalId) external view returns(uint256);
358 }
359 
360 // File: @daostack/infra/contracts/votingMachines/ProposalExecuteInterface.sol
361 
362 pragma solidity ^0.5.11;
363 
364 interface ProposalExecuteInterface {
365     function executeProposal(bytes32 _proposalId, int _decision) external returns(bool);
366 }
367 
368 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
369 
370 pragma solidity ^0.5.0;
371 
372 /**
373  * @dev Wrappers over Solidity's arithmetic operations with added overflow
374  * checks.
375  *
376  * Arithmetic operations in Solidity wrap on overflow. This can easily result
377  * in bugs, because programmers usually assume that an overflow raises an
378  * error, which is the standard behavior in high level programming languages.
379  * `SafeMath` restores this intuition by reverting the transaction when an
380  * operation overflows.
381  *
382  * Using this library instead of the unchecked operations eliminates an entire
383  * class of bugs, so it's recommended to use it always.
384  */
385 library SafeMath {
386     /**
387      * @dev Returns the addition of two unsigned integers, reverting on
388      * overflow.
389      *
390      * Counterpart to Solidity's `+` operator.
391      *
392      * Requirements:
393      * - Addition cannot overflow.
394      */
395     function add(uint256 a, uint256 b) internal pure returns (uint256) {
396         uint256 c = a + b;
397         require(c >= a, "SafeMath: addition overflow");
398 
399         return c;
400     }
401 
402     /**
403      * @dev Returns the subtraction of two unsigned integers, reverting on
404      * overflow (when the result is negative).
405      *
406      * Counterpart to Solidity's `-` operator.
407      *
408      * Requirements:
409      * - Subtraction cannot overflow.
410      */
411     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
412         require(b <= a, "SafeMath: subtraction overflow");
413         uint256 c = a - b;
414 
415         return c;
416     }
417 
418     /**
419      * @dev Returns the multiplication of two unsigned integers, reverting on
420      * overflow.
421      *
422      * Counterpart to Solidity's `*` operator.
423      *
424      * Requirements:
425      * - Multiplication cannot overflow.
426      */
427     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
428         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
429         // benefit is lost if 'b' is also tested.
430         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
431         if (a == 0) {
432             return 0;
433         }
434 
435         uint256 c = a * b;
436         require(c / a == b, "SafeMath: multiplication overflow");
437 
438         return c;
439     }
440 
441     /**
442      * @dev Returns the integer division of two unsigned integers. Reverts on
443      * division by zero. The result is rounded towards zero.
444      *
445      * Counterpart to Solidity's `/` operator. Note: this function uses a
446      * `revert` opcode (which leaves remaining gas untouched) while Solidity
447      * uses an invalid opcode to revert (consuming all remaining gas).
448      *
449      * Requirements:
450      * - The divisor cannot be zero.
451      */
452     function div(uint256 a, uint256 b) internal pure returns (uint256) {
453         // Solidity only automatically asserts when dividing by 0
454         require(b > 0, "SafeMath: division by zero");
455         uint256 c = a / b;
456         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
457 
458         return c;
459     }
460 
461     /**
462      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
463      * Reverts when dividing by zero.
464      *
465      * Counterpart to Solidity's `%` operator. This function uses a `revert`
466      * opcode (which leaves remaining gas untouched) while Solidity uses an
467      * invalid opcode to revert (consuming all remaining gas).
468      *
469      * Requirements:
470      * - The divisor cannot be zero.
471      */
472     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
473         require(b != 0, "SafeMath: modulo by zero");
474         return a % b;
475     }
476 }
477 
478 // File: openzeppelin-solidity/contracts/math/Math.sol
479 
480 pragma solidity ^0.5.0;
481 
482 /**
483  * @dev Standard math utilities missing in the Solidity language.
484  */
485 library Math {
486     /**
487      * @dev Returns the largest of two numbers.
488      */
489     function max(uint256 a, uint256 b) internal pure returns (uint256) {
490         return a >= b ? a : b;
491     }
492 
493     /**
494      * @dev Returns the smallest of two numbers.
495      */
496     function min(uint256 a, uint256 b) internal pure returns (uint256) {
497         return a < b ? a : b;
498     }
499 
500     /**
501      * @dev Returns the average of two numbers. The result is rounded towards
502      * zero.
503      */
504     function average(uint256 a, uint256 b) internal pure returns (uint256) {
505         // (a + b) / 2 can overflow, so we distribute
506         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
507     }
508 }
509 
510 // File: openzeppelin-solidity/contracts/utils/Address.sol
511 
512 pragma solidity ^0.5.0;
513 
514 /**
515  * @dev Collection of functions related to the address type,
516  */
517 library Address {
518     /**
519      * @dev Returns true if `account` is a contract.
520      *
521      * This test is non-exhaustive, and there may be false-negatives: during the
522      * execution of a contract's constructor, its address will be reported as
523      * not containing a contract.
524      *
525      * > It is unsafe to assume that an address for which this function returns
526      * false is an externally-owned account (EOA) and not a contract.
527      */
528     function isContract(address account) internal view returns (bool) {
529         // This method relies in extcodesize, which returns 0 for contracts in
530         // construction, since the code is only stored at the end of the
531         // constructor execution.
532 
533         uint256 size;
534         // solhint-disable-next-line no-inline-assembly
535         assembly { size := extcodesize(account) }
536         return size > 0;
537     }
538 }
539 
540 // File: @daostack/infra/contracts/votingMachines/GenesisProtocolLogic.sol
541 
542 pragma solidity ^0.5.11;
543 
544 
545 
546 
547 
548 
549 
550 
551 
552 
553 
554 /**
555  * @title GenesisProtocol implementation -an organization's voting machine scheme.
556  */
557 contract GenesisProtocolLogic is IntVoteInterface {
558     using SafeMath for uint256;
559     using Math for uint256;
560     using RealMath for uint216;
561     using RealMath for uint256;
562     using Address for address;
563 
564     enum ProposalState { None, ExpiredInQueue, Executed, Queued, PreBoosted, Boosted, QuietEndingPeriod}
565     enum ExecutionState { None, QueueBarCrossed, QueueTimeOut, PreBoostedBarCrossed, BoostedTimeOut, BoostedBarCrossed}
566 
567     //Organization's parameters
568     struct Parameters {
569         uint256 queuedVoteRequiredPercentage; // the absolute vote percentages bar.
570         uint256 queuedVotePeriodLimit; //the time limit for a proposal to be in an absolute voting mode.
571         uint256 boostedVotePeriodLimit; //the time limit for a proposal to be in boost mode.
572         uint256 preBoostedVotePeriodLimit; //the time limit for a proposal
573                                           //to be in an preparation state (stable) before boosted.
574         uint256 thresholdConst; //constant  for threshold calculation .
575                                 //threshold =thresholdConst ** (numberOfBoostedProposals)
576         uint256 limitExponentValue;// an upper limit for numberOfBoostedProposals
577                                    //in the threshold calculation to prevent overflow
578         uint256 quietEndingPeriod; //quite ending period
579         uint256 proposingRepReward;//proposer reputation reward.
580         uint256 votersReputationLossRatio;//Unsuccessful pre booster
581                                           //voters lose votersReputationLossRatio% of their reputation.
582         uint256 minimumDaoBounty;
583         uint256 daoBountyConst;//The DAO downstake for each proposal is calculate according to the formula
584                                //(daoBountyConst * averageBoostDownstakes)/100 .
585         uint256 activationTime;//the point in time after which proposals can be created.
586         //if this address is set so only this address is allowed to vote of behalf of someone else.
587         address voteOnBehalf;
588     }
589 
590     struct Voter {
591         uint256 vote; // YES(1) ,NO(2)
592         uint256 reputation; // amount of voter's reputation
593         bool preBoosted;
594     }
595 
596     struct Staker {
597         uint256 vote; // YES(1) ,NO(2)
598         uint256 amount; // amount of staker's stake
599         uint256 amount4Bounty;// amount of staker's stake used for bounty reward calculation.
600     }
601 
602     struct Proposal {
603         bytes32 organizationId; // the organization unique identifier the proposal is target to.
604         address callbacks;    // should fulfill voting callbacks interface.
605         ProposalState state;
606         uint256 winningVote; //the winning vote.
607         address proposer;
608         //the proposal boosted period limit . it is updated for the case of quiteWindow mode.
609         uint256 currentBoostedVotePeriodLimit;
610         bytes32 paramsHash;
611         uint256 daoBountyRemain; //use for checking sum zero bounty claims.it is set at the proposing time.
612         uint256 daoBounty;
613         uint256 totalStakes;// Total number of tokens staked which can be redeemable by stakers.
614         uint256 confidenceThreshold;
615         uint256 secondsFromTimeOutTillExecuteBoosted;
616         uint[3] times; //times[0] - submittedTime
617                        //times[1] - boostedPhaseTime
618                        //times[2] -preBoostedPhaseTime;
619         bool daoRedeemItsWinnings;
620         //      vote      reputation
621         mapping(uint256   =>  uint256    ) votes;
622         //      vote      reputation
623         mapping(uint256   =>  uint256    ) preBoostedVotes;
624         //      address     voter
625         mapping(address =>  Voter    ) voters;
626         //      vote        stakes
627         mapping(uint256   =>  uint256    ) stakes;
628         //      address  staker
629         mapping(address  => Staker   ) stakers;
630     }
631 
632     event Stake(bytes32 indexed _proposalId,
633         address indexed _organization,
634         address indexed _staker,
635         uint256 _vote,
636         uint256 _amount
637     );
638 
639     event Redeem(bytes32 indexed _proposalId,
640         address indexed _organization,
641         address indexed _beneficiary,
642         uint256 _amount
643     );
644 
645     event RedeemDaoBounty(bytes32 indexed _proposalId,
646         address indexed _organization,
647         address indexed _beneficiary,
648         uint256 _amount
649     );
650 
651     event RedeemReputation(bytes32 indexed _proposalId,
652         address indexed _organization,
653         address indexed _beneficiary,
654         uint256 _amount
655     );
656 
657     event StateChange(bytes32 indexed _proposalId, ProposalState _proposalState);
658     event GPExecuteProposal(bytes32 indexed _proposalId, ExecutionState _executionState);
659     event ExpirationCallBounty(bytes32 indexed _proposalId, address indexed _beneficiary, uint256 _amount);
660     event ConfidenceLevelChange(bytes32 indexed _proposalId, uint256 _confidenceThreshold);
661 
662     mapping(bytes32=>Parameters) public parameters;  // A mapping from hashes to parameters
663     mapping(bytes32=>Proposal) public proposals; // Mapping from the ID of the proposal to the proposal itself.
664     mapping(bytes32=>uint) public orgBoostedProposalsCnt;
665            //organizationId => organization
666     mapping(bytes32        => address     ) public organizations;
667           //organizationId => averageBoostDownstakes
668     mapping(bytes32           => uint256              ) public averagesDownstakesOfBoosted;
669     uint256 constant public NUM_OF_CHOICES = 2;
670     uint256 constant public NO = 2;
671     uint256 constant public YES = 1;
672     uint256 public proposalsCnt; // Total number of proposals
673     IERC20 public stakingToken;
674     address constant private GEN_TOKEN_ADDRESS = 0x543Ff227F64Aa17eA132Bf9886cAb5DB55DCAddf;
675     uint256 constant private MAX_BOOSTED_PROPOSALS = 4096;
676 
677     /**
678      * @dev Constructor
679      */
680     constructor(IERC20 _stakingToken) public {
681       //The GEN token (staking token) address is hard coded in the contract by GEN_TOKEN_ADDRESS .
682       //This will work for a network which already hosted the GEN token on this address (e.g mainnet).
683       //If such contract address does not exist in the network (e.g ganache)
684       //the contract will use the _stakingToken param as the
685       //staking token address.
686         if (address(GEN_TOKEN_ADDRESS).isContract()) {
687             stakingToken = IERC20(GEN_TOKEN_ADDRESS);
688         } else {
689             stakingToken = _stakingToken;
690         }
691     }
692 
693   /**
694    * @dev Check that the proposal is votable
695    * a proposal is votable if it is in one of the following states:
696    *  PreBoosted,Boosted,QuietEndingPeriod or Queued
697    */
698     modifier votable(bytes32 _proposalId) {
699         require(_isVotable(_proposalId));
700         _;
701     }
702 
703     /**
704      * @dev register a new proposal with the given parameters. Every proposal has a unique ID which is being
705      * generated by calculating keccak256 of a incremented counter.
706      * @param _paramsHash parameters hash
707      * @param _proposer address
708      * @param _organization address
709      */
710     function propose(uint256, bytes32 _paramsHash, address _proposer, address _organization)
711         external
712         returns(bytes32)
713     {
714       // solhint-disable-next-line not-rely-on-time
715         require(now > parameters[_paramsHash].activationTime, "not active yet");
716         //Check parameters existence.
717         require(parameters[_paramsHash].queuedVoteRequiredPercentage >= 50);
718         // Generate a unique ID:
719         bytes32 proposalId = keccak256(abi.encodePacked(this, proposalsCnt));
720         proposalsCnt = proposalsCnt.add(1);
721          // Open proposal:
722         Proposal memory proposal;
723         proposal.callbacks = msg.sender;
724         proposal.organizationId = keccak256(abi.encodePacked(msg.sender, _organization));
725 
726         proposal.state = ProposalState.Queued;
727         // solhint-disable-next-line not-rely-on-time
728         proposal.times[0] = now;//submitted time
729         proposal.currentBoostedVotePeriodLimit = parameters[_paramsHash].boostedVotePeriodLimit;
730         proposal.proposer = _proposer;
731         proposal.winningVote = NO;
732         proposal.paramsHash = _paramsHash;
733         if (organizations[proposal.organizationId] == address(0)) {
734             if (_organization == address(0)) {
735                 organizations[proposal.organizationId] = msg.sender;
736             } else {
737                 organizations[proposal.organizationId] = _organization;
738             }
739         }
740         //calc dao bounty
741         uint256 daoBounty =
742         parameters[_paramsHash].daoBountyConst.mul(averagesDownstakesOfBoosted[proposal.organizationId]).div(100);
743         proposal.daoBountyRemain = daoBounty.max(parameters[_paramsHash].minimumDaoBounty);
744         proposals[proposalId] = proposal;
745         proposals[proposalId].stakes[NO] = proposal.daoBountyRemain;//dao downstake on the proposal
746 
747         emit NewProposal(proposalId, organizations[proposal.organizationId], NUM_OF_CHOICES, _proposer, _paramsHash);
748         return proposalId;
749     }
750 
751     /**
752       * @dev executeBoosted try to execute a boosted or QuietEndingPeriod proposal if it is expired
753       * it rewards the msg.sender with P % of the proposal's upstakes upon a successful call to this function.
754       * P = t/150, where t is the number of seconds passed since the the proposal's timeout.
755       * P is capped by 10%.
756       * @param _proposalId the id of the proposal
757       * @return uint256 expirationCallBounty the bounty amount for the expiration call
758      */
759     function executeBoosted(bytes32 _proposalId) external returns(uint256 expirationCallBounty) {
760         Proposal storage proposal = proposals[_proposalId];
761         require(proposal.state == ProposalState.Boosted || proposal.state == ProposalState.QuietEndingPeriod,
762         "proposal state in not Boosted nor QuietEndingPeriod");
763         require(_execute(_proposalId), "proposal need to expire");
764 
765         proposal.secondsFromTimeOutTillExecuteBoosted =
766         // solhint-disable-next-line not-rely-on-time
767         now.sub(proposal.currentBoostedVotePeriodLimit.add(proposal.times[1]));
768 
769         expirationCallBounty = calcExecuteCallBounty(_proposalId);
770         proposal.totalStakes = proposal.totalStakes.sub(expirationCallBounty);
771         require(stakingToken.transfer(msg.sender, expirationCallBounty), "transfer to msg.sender failed");
772         emit ExpirationCallBounty(_proposalId, msg.sender, expirationCallBounty);
773     }
774 
775     /**
776      * @dev hash the parameters, save them if necessary, and return the hash value
777      * @param _params a parameters array
778      *    _params[0] - _queuedVoteRequiredPercentage,
779      *    _params[1] - _queuedVotePeriodLimit, //the time limit for a proposal to be in an absolute voting mode.
780      *    _params[2] - _boostedVotePeriodLimit, //the time limit for a proposal to be in an relative voting mode.
781      *    _params[3] - _preBoostedVotePeriodLimit, //the time limit for a proposal to be in an preparation
782      *                  state (stable) before boosted.
783      *    _params[4] -_thresholdConst
784      *    _params[5] -_quietEndingPeriod
785      *    _params[6] -_proposingRepReward
786      *    _params[7] -_votersReputationLossRatio
787      *    _params[8] -_minimumDaoBounty
788      *    _params[9] -_daoBountyConst
789      *    _params[10] -_activationTime
790      * @param _voteOnBehalf - authorized to vote on behalf of others.
791     */
792     function setParameters(
793         uint[11] calldata _params, //use array here due to stack too deep issue.
794         address _voteOnBehalf
795     )
796     external
797     returns(bytes32)
798     {
799         require(_params[0] <= 100 && _params[0] >= 50, "50 <= queuedVoteRequiredPercentage <= 100");
800         require(_params[4] <= 16000 && _params[4] > 1000, "1000 < thresholdConst <= 16000");
801         require(_params[7] <= 100, "votersReputationLossRatio <= 100");
802         require(_params[2] >= _params[5], "boostedVotePeriodLimit >= quietEndingPeriod");
803         require(_params[8] > 0, "minimumDaoBounty should be > 0");
804         require(_params[9] > 0, "daoBountyConst should be > 0");
805 
806         bytes32 paramsHash = getParametersHash(_params, _voteOnBehalf);
807         //set a limit for power for a given alpha to prevent overflow
808         uint256 limitExponent = 172;//for alpha less or equal 2
809         uint256 j = 2;
810         for (uint256 i = 2000; i < 16000; i = i*2) {
811             if ((_params[4] > i) && (_params[4] <= i*2)) {
812                 limitExponent = limitExponent/j;
813                 break;
814             }
815             j++;
816         }
817 
818         parameters[paramsHash] = Parameters({
819             queuedVoteRequiredPercentage: _params[0],
820             queuedVotePeriodLimit: _params[1],
821             boostedVotePeriodLimit: _params[2],
822             preBoostedVotePeriodLimit: _params[3],
823             thresholdConst:uint216(_params[4]).fraction(uint216(1000)),
824             limitExponentValue:limitExponent,
825             quietEndingPeriod: _params[5],
826             proposingRepReward: _params[6],
827             votersReputationLossRatio:_params[7],
828             minimumDaoBounty:_params[8],
829             daoBountyConst:_params[9],
830             activationTime:_params[10],
831             voteOnBehalf:_voteOnBehalf
832         });
833         return paramsHash;
834     }
835 
836     /**
837      * @dev redeem a reward for a successful stake, vote or proposing.
838      * The function use a beneficiary address as a parameter (and not msg.sender) to enable
839      * users to redeem on behalf of someone else.
840      * @param _proposalId the ID of the proposal
841      * @param _beneficiary - the beneficiary address
842      * @return rewards -
843      *           [0] stakerTokenReward
844      *           [1] voterReputationReward
845      *           [2] proposerReputationReward
846      */
847      // solhint-disable-next-line function-max-lines,code-complexity
848     function redeem(bytes32 _proposalId, address _beneficiary) public returns (uint[3] memory rewards) {
849         Proposal storage proposal = proposals[_proposalId];
850         require((proposal.state == ProposalState.Executed)||(proposal.state == ProposalState.ExpiredInQueue),
851         "Proposal should be Executed or ExpiredInQueue");
852         Parameters memory params = parameters[proposal.paramsHash];
853         //as staker
854         Staker storage staker = proposal.stakers[_beneficiary];
855         uint256 totalWinningStakes = proposal.stakes[proposal.winningVote];
856         uint256 totalStakesLeftAfterCallBounty =
857         proposal.stakes[NO].add(proposal.stakes[YES]).sub(calcExecuteCallBounty(_proposalId));
858         if (staker.amount > 0) {
859 
860             if (proposal.state == ProposalState.ExpiredInQueue) {
861                 //Stakes of a proposal that expires in Queue are sent back to stakers
862                 rewards[0] = staker.amount;
863             } else if (staker.vote == proposal.winningVote) {
864                 if (staker.vote == YES) {
865                     if (proposal.daoBounty < totalStakesLeftAfterCallBounty) {
866                         uint256 _totalStakes = totalStakesLeftAfterCallBounty.sub(proposal.daoBounty);
867                         rewards[0] = (staker.amount.mul(_totalStakes))/totalWinningStakes;
868                     }
869                 } else {
870                     rewards[0] = (staker.amount.mul(totalStakesLeftAfterCallBounty))/totalWinningStakes;
871                 }
872             }
873             staker.amount = 0;
874         }
875             //dao redeem its winnings
876         if (proposal.daoRedeemItsWinnings == false &&
877             _beneficiary == organizations[proposal.organizationId] &&
878             proposal.state != ProposalState.ExpiredInQueue &&
879             proposal.winningVote == NO) {
880             rewards[0] =
881             rewards[0]
882             .add((proposal.daoBounty.mul(totalStakesLeftAfterCallBounty))/totalWinningStakes)
883             .sub(proposal.daoBounty);
884             proposal.daoRedeemItsWinnings = true;
885         }
886 
887         //as voter
888         Voter storage voter = proposal.voters[_beneficiary];
889         if ((voter.reputation != 0) && (voter.preBoosted)) {
890             if (proposal.state == ProposalState.ExpiredInQueue) {
891               //give back reputation for the voter
892                 rewards[1] = ((voter.reputation.mul(params.votersReputationLossRatio))/100);
893             } else if (proposal.winningVote == voter.vote) {
894                 uint256 lostReputation;
895                 if (proposal.winningVote == YES) {
896                     lostReputation = proposal.preBoostedVotes[NO];
897                 } else {
898                     lostReputation = proposal.preBoostedVotes[YES];
899                 }
900                 lostReputation = (lostReputation.mul(params.votersReputationLossRatio))/100;
901                 rewards[1] = ((voter.reputation.mul(params.votersReputationLossRatio))/100)
902                 .add((voter.reputation.mul(lostReputation))/proposal.preBoostedVotes[proposal.winningVote]);
903             }
904             voter.reputation = 0;
905         }
906         //as proposer
907         if ((proposal.proposer == _beneficiary)&&(proposal.winningVote == YES)&&(proposal.proposer != address(0))) {
908             rewards[2] = params.proposingRepReward;
909             proposal.proposer = address(0);
910         }
911         if (rewards[0] != 0) {
912             proposal.totalStakes = proposal.totalStakes.sub(rewards[0]);
913             require(stakingToken.transfer(_beneficiary, rewards[0]), "transfer to beneficiary failed");
914             emit Redeem(_proposalId, organizations[proposal.organizationId], _beneficiary, rewards[0]);
915         }
916         if (rewards[1].add(rewards[2]) != 0) {
917             VotingMachineCallbacksInterface(proposal.callbacks)
918             .mintReputation(rewards[1].add(rewards[2]), _beneficiary, _proposalId);
919             emit RedeemReputation(
920             _proposalId,
921             organizations[proposal.organizationId],
922             _beneficiary,
923             rewards[1].add(rewards[2])
924             );
925         }
926     }
927 
928     /**
929      * @dev redeemDaoBounty a reward for a successful stake.
930      * The function use a beneficiary address as a parameter (and not msg.sender) to enable
931      * users to redeem on behalf of someone else.
932      * @param _proposalId the ID of the proposal
933      * @param _beneficiary - the beneficiary address
934      * @return redeemedAmount - redeem token amount
935      * @return potentialAmount - potential redeem token amount(if there is enough tokens bounty at the organization )
936      */
937     function redeemDaoBounty(bytes32 _proposalId, address _beneficiary)
938     public
939     returns(uint256 redeemedAmount, uint256 potentialAmount) {
940         Proposal storage proposal = proposals[_proposalId];
941         require(proposal.state == ProposalState.Executed);
942         uint256 totalWinningStakes = proposal.stakes[proposal.winningVote];
943         Staker storage staker = proposal.stakers[_beneficiary];
944         if (
945             (staker.amount4Bounty > 0)&&
946             (staker.vote == proposal.winningVote)&&
947             (proposal.winningVote == YES)&&
948             (totalWinningStakes != 0)) {
949             //as staker
950                 potentialAmount = (staker.amount4Bounty * proposal.daoBounty)/totalWinningStakes;
951             }
952         if ((potentialAmount != 0)&&
953             (VotingMachineCallbacksInterface(proposal.callbacks)
954             .balanceOfStakingToken(stakingToken, _proposalId) >= potentialAmount)) {
955             staker.amount4Bounty = 0;
956             proposal.daoBountyRemain = proposal.daoBountyRemain.sub(potentialAmount);
957             require(
958             VotingMachineCallbacksInterface(proposal.callbacks)
959             .stakingTokenTransfer(stakingToken, _beneficiary, potentialAmount, _proposalId));
960             redeemedAmount = potentialAmount;
961             emit RedeemDaoBounty(_proposalId, organizations[proposal.organizationId], _beneficiary, redeemedAmount);
962         }
963     }
964 
965     /**
966       * @dev calcExecuteCallBounty calculate the execute boosted call bounty
967       * @param _proposalId the ID of the proposal
968       * @return uint256 executeCallBounty
969     */
970     function calcExecuteCallBounty(bytes32 _proposalId) public view returns(uint256) {
971         uint maxRewardSeconds = 1500;
972         uint rewardSeconds =
973         uint256(maxRewardSeconds).min(proposals[_proposalId].secondsFromTimeOutTillExecuteBoosted);
974         return rewardSeconds.mul(proposals[_proposalId].stakes[YES]).div(maxRewardSeconds*10);
975     }
976 
977     /**
978      * @dev shouldBoost check if a proposal should be shifted to boosted phase.
979      * @param _proposalId the ID of the proposal
980      * @return bool true or false.
981      */
982     function shouldBoost(bytes32 _proposalId) public view returns(bool) {
983         Proposal memory proposal = proposals[_proposalId];
984         return (_score(_proposalId) > threshold(proposal.paramsHash, proposal.organizationId));
985     }
986 
987     /**
988      * @dev threshold return the organization's score threshold which required by
989      * a proposal to shift to boosted state.
990      * This threshold is dynamically set and it depend on the number of boosted proposal.
991      * @param _organizationId the organization identifier
992      * @param _paramsHash the organization parameters hash
993      * @return uint256 organization's score threshold as real number.
994      */
995     function threshold(bytes32 _paramsHash, bytes32 _organizationId) public view returns(uint256) {
996         uint256 power = orgBoostedProposalsCnt[_organizationId];
997         Parameters storage params = parameters[_paramsHash];
998 
999         if (power > params.limitExponentValue) {
1000             power = params.limitExponentValue;
1001         }
1002 
1003         return params.thresholdConst.pow(power);
1004     }
1005 
1006   /**
1007    * @dev hashParameters returns a hash of the given parameters
1008    */
1009     function getParametersHash(
1010         uint[11] memory _params,//use array here due to stack too deep issue.
1011         address _voteOnBehalf
1012     )
1013         public
1014         pure
1015         returns(bytes32)
1016         {
1017         //double call to keccak256 to avoid deep stack issue when call with too many params.
1018         return keccak256(
1019             abi.encodePacked(
1020             keccak256(
1021             abi.encodePacked(
1022                 _params[0],
1023                 _params[1],
1024                 _params[2],
1025                 _params[3],
1026                 _params[4],
1027                 _params[5],
1028                 _params[6],
1029                 _params[7],
1030                 _params[8],
1031                 _params[9],
1032                 _params[10])
1033             ),
1034             _voteOnBehalf
1035         ));
1036     }
1037 
1038     /**
1039       * @dev execute check if the proposal has been decided, and if so, execute the proposal
1040       * @param _proposalId the id of the proposal
1041       * @return bool true - the proposal has been executed
1042       *              false - otherwise.
1043      */
1044      // solhint-disable-next-line function-max-lines,code-complexity
1045     function _execute(bytes32 _proposalId) internal votable(_proposalId) returns(bool) {
1046         Proposal storage proposal = proposals[_proposalId];
1047         Parameters memory params = parameters[proposal.paramsHash];
1048         Proposal memory tmpProposal = proposal;
1049         uint256 totalReputation =
1050         VotingMachineCallbacksInterface(proposal.callbacks).getTotalReputationSupply(_proposalId);
1051         //first divide by 100 to prevent overflow
1052         uint256 executionBar = (totalReputation/100) * params.queuedVoteRequiredPercentage;
1053         ExecutionState executionState = ExecutionState.None;
1054         uint256 averageDownstakesOfBoosted;
1055         uint256 confidenceThreshold;
1056 
1057         if (proposal.votes[proposal.winningVote] > executionBar) {
1058          // someone crossed the absolute vote execution bar.
1059             if (proposal.state == ProposalState.Queued) {
1060                 executionState = ExecutionState.QueueBarCrossed;
1061             } else if (proposal.state == ProposalState.PreBoosted) {
1062                 executionState = ExecutionState.PreBoostedBarCrossed;
1063             } else {
1064                 executionState = ExecutionState.BoostedBarCrossed;
1065             }
1066             proposal.state = ProposalState.Executed;
1067         } else {
1068             if (proposal.state == ProposalState.Queued) {
1069                 // solhint-disable-next-line not-rely-on-time
1070                 if ((now - proposal.times[0]) >= params.queuedVotePeriodLimit) {
1071                     proposal.state = ProposalState.ExpiredInQueue;
1072                     proposal.winningVote = NO;
1073                     executionState = ExecutionState.QueueTimeOut;
1074                 } else {
1075                     confidenceThreshold = threshold(proposal.paramsHash, proposal.organizationId);
1076                     if (_score(_proposalId) > confidenceThreshold) {
1077                         //change proposal mode to PreBoosted mode.
1078                         proposal.state = ProposalState.PreBoosted;
1079                         // solhint-disable-next-line not-rely-on-time
1080                         proposal.times[2] = now;
1081                         proposal.confidenceThreshold = confidenceThreshold;
1082                     }
1083                 }
1084             }
1085 
1086             if (proposal.state == ProposalState.PreBoosted) {
1087                 confidenceThreshold = threshold(proposal.paramsHash, proposal.organizationId);
1088               // solhint-disable-next-line not-rely-on-time
1089                 if ((now - proposal.times[2]) >= params.preBoostedVotePeriodLimit) {
1090                     if (_score(_proposalId) > confidenceThreshold) {
1091                         if (orgBoostedProposalsCnt[proposal.organizationId] < MAX_BOOSTED_PROPOSALS) {
1092                          //change proposal mode to Boosted mode.
1093                             proposal.state = ProposalState.Boosted;
1094                          // solhint-disable-next-line not-rely-on-time
1095                             proposal.times[1] = now;
1096                             orgBoostedProposalsCnt[proposal.organizationId]++;
1097                          //add a value to average -> average = average + ((value - average) / nbValues)
1098                             averageDownstakesOfBoosted = averagesDownstakesOfBoosted[proposal.organizationId];
1099                           // solium-disable-next-line indentation
1100                             averagesDownstakesOfBoosted[proposal.organizationId] =
1101                                 uint256(int256(averageDownstakesOfBoosted) +
1102                                 ((int256(proposal.stakes[NO])-int256(averageDownstakesOfBoosted))/
1103                                 int256(orgBoostedProposalsCnt[proposal.organizationId])));
1104                         }
1105                     } else {
1106                         proposal.state = ProposalState.Queued;
1107                     }
1108                 } else { //check the Confidence level is stable
1109                     uint256 proposalScore = _score(_proposalId);
1110                     if (proposalScore <= proposal.confidenceThreshold.min(confidenceThreshold)) {
1111                         proposal.state = ProposalState.Queued;
1112                     } else if (proposal.confidenceThreshold > proposalScore) {
1113                         proposal.confidenceThreshold = confidenceThreshold;
1114                         emit ConfidenceLevelChange(_proposalId, confidenceThreshold);
1115                     }
1116                 }
1117             }
1118         }
1119 
1120         if ((proposal.state == ProposalState.Boosted) ||
1121             (proposal.state == ProposalState.QuietEndingPeriod)) {
1122             // solhint-disable-next-line not-rely-on-time
1123             if ((now - proposal.times[1]) >= proposal.currentBoostedVotePeriodLimit) {
1124                 proposal.state = ProposalState.Executed;
1125                 executionState = ExecutionState.BoostedTimeOut;
1126             }
1127         }
1128 
1129         if (executionState != ExecutionState.None) {
1130             if ((executionState == ExecutionState.BoostedTimeOut) ||
1131                 (executionState == ExecutionState.BoostedBarCrossed)) {
1132                 orgBoostedProposalsCnt[tmpProposal.organizationId] =
1133                 orgBoostedProposalsCnt[tmpProposal.organizationId].sub(1);
1134                 //remove a value from average = ((average * nbValues) - value) / (nbValues - 1);
1135                 uint256 boostedProposals = orgBoostedProposalsCnt[tmpProposal.organizationId];
1136                 if (boostedProposals == 0) {
1137                     averagesDownstakesOfBoosted[proposal.organizationId] = 0;
1138                 } else {
1139                     averageDownstakesOfBoosted = averagesDownstakesOfBoosted[proposal.organizationId];
1140                     averagesDownstakesOfBoosted[proposal.organizationId] =
1141                     (averageDownstakesOfBoosted.mul(boostedProposals+1).sub(proposal.stakes[NO]))/boostedProposals;
1142                 }
1143             }
1144             emit ExecuteProposal(
1145             _proposalId,
1146             organizations[proposal.organizationId],
1147             proposal.winningVote,
1148             totalReputation
1149             );
1150             emit GPExecuteProposal(_proposalId, executionState);
1151             ProposalExecuteInterface(proposal.callbacks).executeProposal(_proposalId, int(proposal.winningVote));
1152             proposal.daoBounty = proposal.daoBountyRemain;
1153         }
1154         if (tmpProposal.state != proposal.state) {
1155             emit StateChange(_proposalId, proposal.state);
1156         }
1157         return (executionState != ExecutionState.None);
1158     }
1159 
1160     /**
1161      * @dev staking function
1162      * @param _proposalId id of the proposal
1163      * @param _vote  NO(2) or YES(1).
1164      * @param _amount the betting amount
1165      * @return bool true - the proposal has been executed
1166      *              false - otherwise.
1167      */
1168     function _stake(bytes32 _proposalId, uint256 _vote, uint256 _amount, address _staker) internal returns(bool) {
1169         // 0 is not a valid vote.
1170         require(_vote <= NUM_OF_CHOICES && _vote > 0, "wrong vote value");
1171         require(_amount > 0, "staking amount should be >0");
1172 
1173         if (_execute(_proposalId)) {
1174             return true;
1175         }
1176         Proposal storage proposal = proposals[_proposalId];
1177 
1178         if ((proposal.state != ProposalState.PreBoosted) &&
1179             (proposal.state != ProposalState.Queued)) {
1180             return false;
1181         }
1182 
1183         // enable to increase stake only on the previous stake vote
1184         Staker storage staker = proposal.stakers[_staker];
1185         if ((staker.amount > 0) && (staker.vote != _vote)) {
1186             return false;
1187         }
1188 
1189         uint256 amount = _amount;
1190         require(stakingToken.transferFrom(_staker, address(this), amount), "fail transfer from staker");
1191         proposal.totalStakes = proposal.totalStakes.add(amount); //update totalRedeemableStakes
1192         staker.amount = staker.amount.add(amount);
1193         //This is to prevent average downstakes calculation overflow
1194         //Note that any how GEN cap is 100000000 ether.
1195         require(staker.amount <= 0x100000000000000000000000000000000, "staking amount is too high");
1196         require(proposal.totalStakes <= uint256(0x100000000000000000000000000000000).sub(proposal.daoBountyRemain),
1197                 "total stakes is too high");
1198 
1199         if (_vote == YES) {
1200             staker.amount4Bounty = staker.amount4Bounty.add(amount);
1201         }
1202         staker.vote = _vote;
1203 
1204         proposal.stakes[_vote] = amount.add(proposal.stakes[_vote]);
1205         emit Stake(_proposalId, organizations[proposal.organizationId], _staker, _vote, _amount);
1206         return _execute(_proposalId);
1207     }
1208 
1209     /**
1210      * @dev Vote for a proposal, if the voter already voted, cancel the last vote and set a new one instead
1211      * @param _proposalId id of the proposal
1212      * @param _voter used in case the vote is cast for someone else
1213      * @param _vote a value between 0 to and the proposal's number of choices.
1214      * @param _rep how many reputation the voter would like to stake for this vote.
1215      *         if  _rep==0 so the voter full reputation will be use.
1216      * @return true in case of proposal execution otherwise false
1217      * throws if proposal is not open or if it has been executed
1218      * NB: executes the proposal if a decision has been reached
1219      */
1220      // solhint-disable-next-line function-max-lines,code-complexity
1221     function internalVote(bytes32 _proposalId, address _voter, uint256 _vote, uint256 _rep) internal returns(bool) {
1222         require(_vote <= NUM_OF_CHOICES && _vote > 0, "0 < _vote <= 2");
1223         if (_execute(_proposalId)) {
1224             return true;
1225         }
1226 
1227         Parameters memory params = parameters[proposals[_proposalId].paramsHash];
1228         Proposal storage proposal = proposals[_proposalId];
1229 
1230         // Check voter has enough reputation:
1231         uint256 reputation = VotingMachineCallbacksInterface(proposal.callbacks).reputationOf(_voter, _proposalId);
1232         require(reputation > 0, "_voter must have reputation");
1233         require(reputation >= _rep, "reputation >= _rep");
1234         uint256 rep = _rep;
1235         if (rep == 0) {
1236             rep = reputation;
1237         }
1238         // If this voter has already voted, return false.
1239         if (proposal.voters[_voter].reputation != 0) {
1240             return false;
1241         }
1242         // The voting itself:
1243         proposal.votes[_vote] = rep.add(proposal.votes[_vote]);
1244         //check if the current winningVote changed or there is a tie.
1245         //for the case there is a tie the current winningVote set to NO.
1246         if ((proposal.votes[_vote] > proposal.votes[proposal.winningVote]) ||
1247             ((proposal.votes[NO] == proposal.votes[proposal.winningVote]) &&
1248             proposal.winningVote == YES)) {
1249             if (proposal.state == ProposalState.Boosted &&
1250             // solhint-disable-next-line not-rely-on-time
1251                 ((now - proposal.times[1]) >= (params.boostedVotePeriodLimit - params.quietEndingPeriod))||
1252                 proposal.state == ProposalState.QuietEndingPeriod) {
1253                 //quietEndingPeriod
1254                 if (proposal.state != ProposalState.QuietEndingPeriod) {
1255                     proposal.currentBoostedVotePeriodLimit = params.quietEndingPeriod;
1256                     proposal.state = ProposalState.QuietEndingPeriod;
1257                     emit StateChange(_proposalId, proposal.state);
1258                 }
1259                 // solhint-disable-next-line not-rely-on-time
1260                 proposal.times[1] = now;
1261             }
1262             proposal.winningVote = _vote;
1263         }
1264         proposal.voters[_voter] = Voter({
1265             reputation: rep,
1266             vote: _vote,
1267             preBoosted:((proposal.state == ProposalState.PreBoosted) || (proposal.state == ProposalState.Queued))
1268         });
1269         if ((proposal.state == ProposalState.PreBoosted) || (proposal.state == ProposalState.Queued)) {
1270             proposal.preBoostedVotes[_vote] = rep.add(proposal.preBoostedVotes[_vote]);
1271             uint256 reputationDeposit = (params.votersReputationLossRatio.mul(rep))/100;
1272             VotingMachineCallbacksInterface(proposal.callbacks).burnReputation(reputationDeposit, _voter, _proposalId);
1273         }
1274         emit VoteProposal(_proposalId, organizations[proposal.organizationId], _voter, _vote, rep);
1275         return _execute(_proposalId);
1276     }
1277 
1278     /**
1279      * @dev _score return the proposal score (Confidence level)
1280      * For dual choice proposal S = (S+)/(S-)
1281      * @param _proposalId the ID of the proposal
1282      * @return uint256 proposal score as real number.
1283      */
1284     function _score(bytes32 _proposalId) internal view returns(uint256) {
1285         Proposal storage proposal = proposals[_proposalId];
1286         //proposal.stakes[NO] cannot be zero as the dao downstake > 0 for each proposal.
1287         return uint216(proposal.stakes[YES]).fraction(uint216(proposal.stakes[NO]));
1288     }
1289 
1290     /**
1291       * @dev _isVotable check if the proposal is votable
1292       * @param _proposalId the ID of the proposal
1293       * @return bool true or false
1294     */
1295     function _isVotable(bytes32 _proposalId) internal view returns(bool) {
1296         ProposalState pState = proposals[_proposalId].state;
1297         return ((pState == ProposalState.PreBoosted)||
1298                 (pState == ProposalState.Boosted)||
1299                 (pState == ProposalState.QuietEndingPeriod)||
1300                 (pState == ProposalState.Queued)
1301         );
1302     }
1303 }
1304 
1305 // File: @daostack/infra/contracts/votingMachines/GenesisProtocol.sol
1306 
1307 pragma solidity ^0.5.11;
1308 
1309 
1310 
1311 
1312 /**
1313  * @title GenesisProtocol implementation -an organization's voting machine scheme.
1314  */
1315 contract GenesisProtocol is IntVoteInterface, GenesisProtocolLogic {
1316     using ECDSA for bytes32;
1317 
1318     // Digest describing the data the user signs according EIP 712.
1319     // Needs to match what is passed to Metamask.
1320     bytes32 public constant DELEGATION_HASH_EIP712 =
1321     keccak256(abi.encodePacked(
1322     "address GenesisProtocolAddress",
1323     "bytes32 ProposalId",
1324     "uint256 Vote",
1325     "uint256 AmountToStake",
1326     "uint256 Nonce"
1327     ));
1328 
1329     mapping(address=>uint256) public stakesNonce; //stakes Nonce
1330 
1331     /**
1332      * @dev Constructor
1333      */
1334     constructor(IERC20 _stakingToken)
1335     public
1336     // solhint-disable-next-line no-empty-blocks
1337     GenesisProtocolLogic(_stakingToken) {
1338     }
1339 
1340     /**
1341      * @dev staking function
1342      * @param _proposalId id of the proposal
1343      * @param _vote  NO(2) or YES(1).
1344      * @param _amount the betting amount
1345      * @return bool true - the proposal has been executed
1346      *              false - otherwise.
1347      */
1348     function stake(bytes32 _proposalId, uint256 _vote, uint256 _amount) external returns(bool) {
1349         return _stake(_proposalId, _vote, _amount, msg.sender);
1350     }
1351 
1352     /**
1353      * @dev stakeWithSignature function
1354      * @param _proposalId id of the proposal
1355      * @param _vote  NO(2) or YES(1).
1356      * @param _amount the betting amount
1357      * @param _nonce nonce value ,it is part of the signature to ensure that
1358               a signature can be received only once.
1359      * @param _signatureType signature type
1360               1 - for web3.eth.sign
1361               2 - for eth_signTypedData according to EIP #712.
1362      * @param _signature  - signed data by the staker
1363      * @return bool true - the proposal has been executed
1364      *              false - otherwise.
1365      */
1366     function stakeWithSignature(
1367         bytes32 _proposalId,
1368         uint256 _vote,
1369         uint256 _amount,
1370         uint256 _nonce,
1371         uint256 _signatureType,
1372         bytes calldata _signature
1373         )
1374         external
1375         returns(bool)
1376         {
1377         // Recreate the digest the user signed
1378         bytes32 delegationDigest;
1379         if (_signatureType == 2) {
1380             delegationDigest = keccak256(
1381                 abi.encodePacked(
1382                     DELEGATION_HASH_EIP712, keccak256(
1383                         abi.encodePacked(
1384                         address(this),
1385                         _proposalId,
1386                         _vote,
1387                         _amount,
1388                         _nonce)
1389                     )
1390                 )
1391             );
1392         } else {
1393             delegationDigest = keccak256(
1394                         abi.encodePacked(
1395                         address(this),
1396                         _proposalId,
1397                         _vote,
1398                         _amount,
1399                         _nonce)
1400                     ).toEthSignedMessageHash();
1401         }
1402         address staker = delegationDigest.recover(_signature);
1403         //a garbage staker address due to wrong signature will revert due to lack of approval and funds.
1404         require(staker != address(0), "staker address cannot be 0");
1405         require(stakesNonce[staker] == _nonce);
1406         stakesNonce[staker] = stakesNonce[staker].add(1);
1407         return _stake(_proposalId, _vote, _amount, staker);
1408     }
1409 
1410     /**
1411      * @dev voting function
1412      * @param _proposalId id of the proposal
1413      * @param _vote NO(2) or YES(1).
1414      * @param _amount the reputation amount to vote with . if _amount == 0 it will use all voter reputation.
1415      * @param _voter voter address
1416      * @return bool true - the proposal has been executed
1417      *              false - otherwise.
1418      */
1419     function vote(bytes32 _proposalId, uint256 _vote, uint256 _amount, address _voter)
1420     external
1421     votable(_proposalId)
1422     returns(bool) {
1423         Proposal storage proposal = proposals[_proposalId];
1424         Parameters memory params = parameters[proposal.paramsHash];
1425         address voter;
1426         if (params.voteOnBehalf != address(0)) {
1427             require(msg.sender == params.voteOnBehalf);
1428             voter = _voter;
1429         } else {
1430             voter = msg.sender;
1431         }
1432         return internalVote(_proposalId, voter, _vote, _amount);
1433     }
1434 
1435   /**
1436    * @dev Cancel the vote of the msg.sender.
1437    * cancel vote is not allow in genesisProtocol so this function doing nothing.
1438    * This function is here in order to comply to the IntVoteInterface .
1439    */
1440     function cancelVote(bytes32 _proposalId) external votable(_proposalId) {
1441        //this is not allowed
1442         return;
1443     }
1444 
1445     /**
1446       * @dev execute check if the proposal has been decided, and if so, execute the proposal
1447       * @param _proposalId the id of the proposal
1448       * @return bool true - the proposal has been executed
1449       *              false - otherwise.
1450      */
1451     function execute(bytes32 _proposalId) external votable(_proposalId) returns(bool) {
1452         return _execute(_proposalId);
1453     }
1454 
1455   /**
1456     * @dev getNumberOfChoices returns the number of choices possible in this proposal
1457     * @return uint256 that contains number of choices
1458     */
1459     function getNumberOfChoices(bytes32) external view returns(uint256) {
1460         return NUM_OF_CHOICES;
1461     }
1462 
1463     /**
1464       * @dev getProposalTimes returns proposals times variables.
1465       * @param _proposalId id of the proposal
1466       * @return proposals times array
1467       */
1468     function getProposalTimes(bytes32 _proposalId) external view returns(uint[3] memory times) {
1469         return proposals[_proposalId].times;
1470     }
1471 
1472     /**
1473      * @dev voteInfo returns the vote and the amount of reputation of the user committed to this proposal
1474      * @param _proposalId the ID of the proposal
1475      * @param _voter the address of the voter
1476      * @return uint256 vote - the voters vote
1477      *        uint256 reputation - amount of reputation committed by _voter to _proposalId
1478      */
1479     function voteInfo(bytes32 _proposalId, address _voter) external view returns(uint, uint) {
1480         Voter memory voter = proposals[_proposalId].voters[_voter];
1481         return (voter.vote, voter.reputation);
1482     }
1483 
1484     /**
1485     * @dev voteStatus returns the reputation voted for a proposal for a specific voting choice.
1486     * @param _proposalId the ID of the proposal
1487     * @param _choice the index in the
1488     * @return voted reputation for the given choice
1489     */
1490     function voteStatus(bytes32 _proposalId, uint256 _choice) external view returns(uint256) {
1491         return proposals[_proposalId].votes[_choice];
1492     }
1493 
1494     /**
1495     * @dev isVotable check if the proposal is votable
1496     * @param _proposalId the ID of the proposal
1497     * @return bool true or false
1498     */
1499     function isVotable(bytes32 _proposalId) external view returns(bool) {
1500         return _isVotable(_proposalId);
1501     }
1502 
1503     /**
1504     * @dev proposalStatus return the total votes and stakes for a given proposal
1505     * @param _proposalId the ID of the proposal
1506     * @return uint256 preBoostedVotes YES
1507     * @return uint256 preBoostedVotes NO
1508     * @return uint256 total stakes YES
1509     * @return uint256 total stakes NO
1510     */
1511     function proposalStatus(bytes32 _proposalId) external view returns(uint256, uint256, uint256, uint256) {
1512         return (
1513                 proposals[_proposalId].preBoostedVotes[YES],
1514                 proposals[_proposalId].preBoostedVotes[NO],
1515                 proposals[_proposalId].stakes[YES],
1516                 proposals[_proposalId].stakes[NO]
1517         );
1518     }
1519 
1520   /**
1521     * @dev getProposalOrganization return the organizationId for a given proposal
1522     * @param _proposalId the ID of the proposal
1523     * @return bytes32 organization identifier
1524     */
1525     function getProposalOrganization(bytes32 _proposalId) external view returns(bytes32) {
1526         return (proposals[_proposalId].organizationId);
1527     }
1528 
1529     /**
1530       * @dev getStaker return the vote and stake amount for a given proposal and staker
1531       * @param _proposalId the ID of the proposal
1532       * @param _staker staker address
1533       * @return uint256 vote
1534       * @return uint256 amount
1535     */
1536     function getStaker(bytes32 _proposalId, address _staker) external view returns(uint256, uint256) {
1537         return (proposals[_proposalId].stakers[_staker].vote, proposals[_proposalId].stakers[_staker].amount);
1538     }
1539 
1540     /**
1541       * @dev voteStake return the amount stakes for a given proposal and vote
1542       * @param _proposalId the ID of the proposal
1543       * @param _vote vote number
1544       * @return uint256 stake amount
1545     */
1546     function voteStake(bytes32 _proposalId, uint256 _vote) external view returns(uint256) {
1547         return proposals[_proposalId].stakes[_vote];
1548     }
1549 
1550   /**
1551     * @dev voteStake return the winningVote for a given proposal
1552     * @param _proposalId the ID of the proposal
1553     * @return uint256 winningVote
1554     */
1555     function winningVote(bytes32 _proposalId) external view returns(uint256) {
1556         return proposals[_proposalId].winningVote;
1557     }
1558 
1559     /**
1560       * @dev voteStake return the state for a given proposal
1561       * @param _proposalId the ID of the proposal
1562       * @return ProposalState proposal state
1563     */
1564     function state(bytes32 _proposalId) external view returns(ProposalState) {
1565         return proposals[_proposalId].state;
1566     }
1567 
1568    /**
1569     * @dev isAbstainAllow returns if the voting machine allow abstain (0)
1570     * @return bool true or false
1571     */
1572     function isAbstainAllow() external pure returns(bool) {
1573         return false;
1574     }
1575 
1576     /**
1577      * @dev getAllowedRangeOfChoices returns the allowed range of choices for a voting machine.
1578      * @return min - minimum number of choices
1579                max - maximum number of choices
1580      */
1581     function getAllowedRangeOfChoices() external pure returns(uint256 min, uint256 max) {
1582         return (YES, NO);
1583     }
1584 
1585     /**
1586      * @dev score return the proposal score
1587      * @param _proposalId the ID of the proposal
1588      * @return uint256 proposal score.
1589      */
1590     function score(bytes32 _proposalId) public view returns(uint256) {
1591         return  _score(_proposalId);
1592     }
1593 }