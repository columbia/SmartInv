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
20      * NOTE: This call _does not revert_ if the signature is invalid, or
21      * if the signer is otherwise unable to be retrieved. In those scenarios,
22      * the zero address is returned.
23      *
24      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
25      * verification to be secure: it is possible to craft signatures that
26      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
27      * this is by receiving a hash of the original message (which may otherwise
28      * be too long), and then calling {toEthSignedMessageHash} on it.
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
74      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
75      * JSON-RPC method.
76      *
77      * See {recover}.
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
269  * the optional functions; to access them see {ERC20Detailed}.
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
287      * Emits a {Transfer} event.
288      */
289     function transfer(address recipient, uint256 amount) external returns (bool);
290 
291     /**
292      * @dev Returns the remaining number of tokens that `spender` will be
293      * allowed to spend on behalf of `owner` through {transferFrom}. This is
294      * zero by default.
295      *
296      * This value changes when {approve} or {transferFrom} are called.
297      */
298     function allowance(address owner, address spender) external view returns (uint256);
299 
300     /**
301      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
302      *
303      * Returns a boolean value indicating whether the operation succeeded.
304      *
305      * IMPORTANT: Beware that changing an allowance with this method brings the risk
306      * that someone may use both the old and the new allowance by unfortunate
307      * transaction ordering. One possible solution to mitigate this race
308      * condition is to first reduce the spender's allowance to 0 and set the
309      * desired value afterwards:
310      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
311      *
312      * Emits an {Approval} event.
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
323      * Emits a {Transfer} event.
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
337      * a call to {approve}. `value` is the new allowance.
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
412         return sub(a, b, "SafeMath: subtraction overflow");
413     }
414 
415     /**
416      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
417      * overflow (when the result is negative).
418      *
419      * Counterpart to Solidity's `-` operator.
420      *
421      * Requirements:
422      * - Subtraction cannot overflow.
423      *
424      * _Available since v2.4.0._
425      */
426     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
427         require(b <= a, errorMessage);
428         uint256 c = a - b;
429 
430         return c;
431     }
432 
433     /**
434      * @dev Returns the multiplication of two unsigned integers, reverting on
435      * overflow.
436      *
437      * Counterpart to Solidity's `*` operator.
438      *
439      * Requirements:
440      * - Multiplication cannot overflow.
441      */
442     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
443         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
444         // benefit is lost if 'b' is also tested.
445         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
446         if (a == 0) {
447             return 0;
448         }
449 
450         uint256 c = a * b;
451         require(c / a == b, "SafeMath: multiplication overflow");
452 
453         return c;
454     }
455 
456     /**
457      * @dev Returns the integer division of two unsigned integers. Reverts on
458      * division by zero. The result is rounded towards zero.
459      *
460      * Counterpart to Solidity's `/` operator. Note: this function uses a
461      * `revert` opcode (which leaves remaining gas untouched) while Solidity
462      * uses an invalid opcode to revert (consuming all remaining gas).
463      *
464      * Requirements:
465      * - The divisor cannot be zero.
466      */
467     function div(uint256 a, uint256 b) internal pure returns (uint256) {
468         return div(a, b, "SafeMath: division by zero");
469     }
470 
471     /**
472      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
473      * division by zero. The result is rounded towards zero.
474      *
475      * Counterpart to Solidity's `/` operator. Note: this function uses a
476      * `revert` opcode (which leaves remaining gas untouched) while Solidity
477      * uses an invalid opcode to revert (consuming all remaining gas).
478      *
479      * Requirements:
480      * - The divisor cannot be zero.
481      *
482      * _Available since v2.4.0._
483      */
484     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
485         // Solidity only automatically asserts when dividing by 0
486         require(b > 0, errorMessage);
487         uint256 c = a / b;
488         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
489 
490         return c;
491     }
492 
493     /**
494      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
495      * Reverts when dividing by zero.
496      *
497      * Counterpart to Solidity's `%` operator. This function uses a `revert`
498      * opcode (which leaves remaining gas untouched) while Solidity uses an
499      * invalid opcode to revert (consuming all remaining gas).
500      *
501      * Requirements:
502      * - The divisor cannot be zero.
503      */
504     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
505         return mod(a, b, "SafeMath: modulo by zero");
506     }
507 
508     /**
509      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
510      * Reverts with custom message when dividing by zero.
511      *
512      * Counterpart to Solidity's `%` operator. This function uses a `revert`
513      * opcode (which leaves remaining gas untouched) while Solidity uses an
514      * invalid opcode to revert (consuming all remaining gas).
515      *
516      * Requirements:
517      * - The divisor cannot be zero.
518      *
519      * _Available since v2.4.0._
520      */
521     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
522         require(b != 0, errorMessage);
523         return a % b;
524     }
525 }
526 
527 // File: openzeppelin-solidity/contracts/math/Math.sol
528 
529 pragma solidity ^0.5.0;
530 
531 /**
532  * @dev Standard math utilities missing in the Solidity language.
533  */
534 library Math {
535     /**
536      * @dev Returns the largest of two numbers.
537      */
538     function max(uint256 a, uint256 b) internal pure returns (uint256) {
539         return a >= b ? a : b;
540     }
541 
542     /**
543      * @dev Returns the smallest of two numbers.
544      */
545     function min(uint256 a, uint256 b) internal pure returns (uint256) {
546         return a < b ? a : b;
547     }
548 
549     /**
550      * @dev Returns the average of two numbers. The result is rounded towards
551      * zero.
552      */
553     function average(uint256 a, uint256 b) internal pure returns (uint256) {
554         // (a + b) / 2 can overflow, so we distribute
555         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
556     }
557 }
558 
559 // File: openzeppelin-solidity/contracts/utils/Address.sol
560 
561 pragma solidity ^0.5.5;
562 
563 /**
564  * @dev Collection of functions related to the address type
565  */
566 library Address {
567     /**
568      * @dev Returns true if `account` is a contract.
569      *
570      * This test is non-exhaustive, and there may be false-negatives: during the
571      * execution of a contract's constructor, its address will be reported as
572      * not containing a contract.
573      *
574      * IMPORTANT: It is unsafe to assume that an address for which this
575      * function returns false is an externally-owned account (EOA) and not a
576      * contract.
577      */
578     function isContract(address account) internal view returns (bool) {
579         // This method relies in extcodesize, which returns 0 for contracts in
580         // construction, since the code is only stored at the end of the
581         // constructor execution.
582 
583         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
584         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
585         // for accounts without code, i.e. `keccak256('')`
586         bytes32 codehash;
587         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
588         // solhint-disable-next-line no-inline-assembly
589         assembly { codehash := extcodehash(account) }
590         return (codehash != 0x0 && codehash != accountHash);
591     }
592 
593     /**
594      * @dev Converts an `address` into `address payable`. Note that this is
595      * simply a type cast: the actual underlying value is not changed.
596      *
597      * _Available since v2.4.0._
598      */
599     function toPayable(address account) internal pure returns (address payable) {
600         return address(uint160(account));
601     }
602 
603     /**
604      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
605      * `recipient`, forwarding all available gas and reverting on errors.
606      *
607      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
608      * of certain opcodes, possibly making contracts go over the 2300 gas limit
609      * imposed by `transfer`, making them unable to receive funds via
610      * `transfer`. {sendValue} removes this limitation.
611      *
612      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
613      *
614      * IMPORTANT: because control is transferred to `recipient`, care must be
615      * taken to not create reentrancy vulnerabilities. Consider using
616      * {ReentrancyGuard} or the
617      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
618      *
619      * _Available since v2.4.0._
620      */
621     function sendValue(address payable recipient, uint256 amount) internal {
622         require(address(this).balance >= amount, "Address: insufficient balance");
623 
624         // solhint-disable-next-line avoid-call-value
625         (bool success, ) = recipient.call.value(amount)("");
626         require(success, "Address: unable to send value, recipient may have reverted");
627     }
628 }
629 
630 // File: @daostack/infra/contracts/votingMachines/GenesisProtocolLogic.sol
631 
632 pragma solidity ^0.5.11;
633 
634 
635 
636 
637 
638 
639 
640 
641 
642 
643 
644 /**
645  * @title GenesisProtocol implementation -an organization's voting machine scheme.
646  */
647 contract GenesisProtocolLogic is IntVoteInterface {
648     using SafeMath for uint256;
649     using Math for uint256;
650     using RealMath for uint216;
651     using RealMath for uint256;
652     using Address for address;
653 
654     enum ProposalState { None, ExpiredInQueue, Executed, Queued, PreBoosted, Boosted, QuietEndingPeriod}
655     enum ExecutionState { None, QueueBarCrossed, QueueTimeOut, PreBoostedBarCrossed, BoostedTimeOut, BoostedBarCrossed}
656 
657     //Organization's parameters
658     struct Parameters {
659         uint256 queuedVoteRequiredPercentage; // the absolute vote percentages bar.
660         uint256 queuedVotePeriodLimit; //the time limit for a proposal to be in an absolute voting mode.
661         uint256 boostedVotePeriodLimit; //the time limit for a proposal to be in boost mode.
662         uint256 preBoostedVotePeriodLimit; //the time limit for a proposal
663                                           //to be in an preparation state (stable) before boosted.
664         uint256 thresholdConst; //constant  for threshold calculation .
665                                 //threshold =thresholdConst ** (numberOfBoostedProposals)
666         uint256 limitExponentValue;// an upper limit for numberOfBoostedProposals
667                                    //in the threshold calculation to prevent overflow
668         uint256 quietEndingPeriod; //quite ending period
669         uint256 proposingRepReward;//proposer reputation reward.
670         uint256 votersReputationLossRatio;//Unsuccessful pre booster
671                                           //voters lose votersReputationLossRatio% of their reputation.
672         uint256 minimumDaoBounty;
673         uint256 daoBountyConst;//The DAO downstake for each proposal is calculate according to the formula
674                                //(daoBountyConst * averageBoostDownstakes)/100 .
675         uint256 activationTime;//the point in time after which proposals can be created.
676         //if this address is set so only this address is allowed to vote of behalf of someone else.
677         address voteOnBehalf;
678     }
679 
680     struct Voter {
681         uint256 vote; // YES(1) ,NO(2)
682         uint256 reputation; // amount of voter's reputation
683         bool preBoosted;
684     }
685 
686     struct Staker {
687         uint256 vote; // YES(1) ,NO(2)
688         uint256 amount; // amount of staker's stake
689         uint256 amount4Bounty;// amount of staker's stake used for bounty reward calculation.
690     }
691 
692     struct Proposal {
693         bytes32 organizationId; // the organization unique identifier the proposal is target to.
694         address callbacks;    // should fulfill voting callbacks interface.
695         ProposalState state;
696         uint256 winningVote; //the winning vote.
697         address proposer;
698         //the proposal boosted period limit . it is updated for the case of quiteWindow mode.
699         uint256 currentBoostedVotePeriodLimit;
700         bytes32 paramsHash;
701         uint256 daoBountyRemain; //use for checking sum zero bounty claims.it is set at the proposing time.
702         uint256 daoBounty;
703         uint256 totalStakes;// Total number of tokens staked which can be redeemable by stakers.
704         uint256 confidenceThreshold;
705         uint256 secondsFromTimeOutTillExecuteBoosted;
706         uint[3] times; //times[0] - submittedTime
707                        //times[1] - boostedPhaseTime
708                        //times[2] -preBoostedPhaseTime;
709         bool daoRedeemItsWinnings;
710         //      vote      reputation
711         mapping(uint256   =>  uint256    ) votes;
712         //      vote      reputation
713         mapping(uint256   =>  uint256    ) preBoostedVotes;
714         //      address     voter
715         mapping(address =>  Voter    ) voters;
716         //      vote        stakes
717         mapping(uint256   =>  uint256    ) stakes;
718         //      address  staker
719         mapping(address  => Staker   ) stakers;
720     }
721 
722     event Stake(bytes32 indexed _proposalId,
723         address indexed _organization,
724         address indexed _staker,
725         uint256 _vote,
726         uint256 _amount
727     );
728 
729     event Redeem(bytes32 indexed _proposalId,
730         address indexed _organization,
731         address indexed _beneficiary,
732         uint256 _amount
733     );
734 
735     event RedeemDaoBounty(bytes32 indexed _proposalId,
736         address indexed _organization,
737         address indexed _beneficiary,
738         uint256 _amount
739     );
740 
741     event RedeemReputation(bytes32 indexed _proposalId,
742         address indexed _organization,
743         address indexed _beneficiary,
744         uint256 _amount
745     );
746 
747     event StateChange(bytes32 indexed _proposalId, ProposalState _proposalState);
748     event GPExecuteProposal(bytes32 indexed _proposalId, ExecutionState _executionState);
749     event ExpirationCallBounty(bytes32 indexed _proposalId, address indexed _beneficiary, uint256 _amount);
750     event ConfidenceLevelChange(bytes32 indexed _proposalId, uint256 _confidenceThreshold);
751 
752     mapping(bytes32=>Parameters) public parameters;  // A mapping from hashes to parameters
753     mapping(bytes32=>Proposal) public proposals; // Mapping from the ID of the proposal to the proposal itself.
754     mapping(bytes32=>uint) public orgBoostedProposalsCnt;
755            //organizationId => organization
756     mapping(bytes32        => address     ) public organizations;
757           //organizationId => averageBoostDownstakes
758     mapping(bytes32           => uint256              ) public averagesDownstakesOfBoosted;
759     uint256 constant public NUM_OF_CHOICES = 2;
760     uint256 constant public NO = 2;
761     uint256 constant public YES = 1;
762     uint256 public proposalsCnt; // Total number of proposals
763     IERC20 public stakingToken;
764     address constant private GEN_TOKEN_ADDRESS = 0x543Ff227F64Aa17eA132Bf9886cAb5DB55DCAddf;
765     uint256 constant private MAX_BOOSTED_PROPOSALS = 4096;
766 
767     /**
768      * @dev Constructor
769      */
770     constructor(IERC20 _stakingToken) public {
771       //The GEN token (staking token) address is hard coded in the contract by GEN_TOKEN_ADDRESS .
772       //This will work for a network which already hosted the GEN token on this address (e.g mainnet).
773       //If such contract address does not exist in the network (e.g ganache)
774       //the contract will use the _stakingToken param as the
775       //staking token address.
776         if (address(GEN_TOKEN_ADDRESS).isContract()) {
777             stakingToken = IERC20(GEN_TOKEN_ADDRESS);
778         } else {
779             stakingToken = _stakingToken;
780         }
781     }
782 
783   /**
784    * @dev Check that the proposal is votable
785    * a proposal is votable if it is in one of the following states:
786    *  PreBoosted,Boosted,QuietEndingPeriod or Queued
787    */
788     modifier votable(bytes32 _proposalId) {
789         require(_isVotable(_proposalId));
790         _;
791     }
792 
793     /**
794      * @dev register a new proposal with the given parameters. Every proposal has a unique ID which is being
795      * generated by calculating keccak256 of a incremented counter.
796      * @param _paramsHash parameters hash
797      * @param _proposer address
798      * @param _organization address
799      */
800     function propose(uint256, bytes32 _paramsHash, address _proposer, address _organization)
801         external
802         returns(bytes32)
803     {
804       // solhint-disable-next-line not-rely-on-time
805         require(now > parameters[_paramsHash].activationTime, "not active yet");
806         //Check parameters existence.
807         require(parameters[_paramsHash].queuedVoteRequiredPercentage >= 50);
808         // Generate a unique ID:
809         bytes32 proposalId = keccak256(abi.encodePacked(this, proposalsCnt));
810         proposalsCnt = proposalsCnt.add(1);
811          // Open proposal:
812         Proposal memory proposal;
813         proposal.callbacks = msg.sender;
814         proposal.organizationId = keccak256(abi.encodePacked(msg.sender, _organization));
815 
816         proposal.state = ProposalState.Queued;
817         // solhint-disable-next-line not-rely-on-time
818         proposal.times[0] = now;//submitted time
819         proposal.currentBoostedVotePeriodLimit = parameters[_paramsHash].boostedVotePeriodLimit;
820         proposal.proposer = _proposer;
821         proposal.winningVote = NO;
822         proposal.paramsHash = _paramsHash;
823         if (organizations[proposal.organizationId] == address(0)) {
824             if (_organization == address(0)) {
825                 organizations[proposal.organizationId] = msg.sender;
826             } else {
827                 organizations[proposal.organizationId] = _organization;
828             }
829         }
830         //calc dao bounty
831         uint256 daoBounty =
832         parameters[_paramsHash].daoBountyConst.mul(averagesDownstakesOfBoosted[proposal.organizationId]).div(100);
833         proposal.daoBountyRemain = daoBounty.max(parameters[_paramsHash].minimumDaoBounty);
834         proposals[proposalId] = proposal;
835         proposals[proposalId].stakes[NO] = proposal.daoBountyRemain;//dao downstake on the proposal
836 
837         emit NewProposal(proposalId, organizations[proposal.organizationId], NUM_OF_CHOICES, _proposer, _paramsHash);
838         return proposalId;
839     }
840 
841     /**
842       * @dev executeBoosted try to execute a boosted or QuietEndingPeriod proposal if it is expired
843       * it rewards the msg.sender with P % of the proposal's upstakes upon a successful call to this function.
844       * P = t/150, where t is the number of seconds passed since the the proposal's timeout.
845       * P is capped by 10%.
846       * @param _proposalId the id of the proposal
847       * @return uint256 expirationCallBounty the bounty amount for the expiration call
848      */
849     function executeBoosted(bytes32 _proposalId) external returns(uint256 expirationCallBounty) {
850         Proposal storage proposal = proposals[_proposalId];
851         require(proposal.state == ProposalState.Boosted || proposal.state == ProposalState.QuietEndingPeriod,
852         "proposal state in not Boosted nor QuietEndingPeriod");
853         require(_execute(_proposalId), "proposal need to expire");
854 
855         proposal.secondsFromTimeOutTillExecuteBoosted =
856         // solhint-disable-next-line not-rely-on-time
857         now.sub(proposal.currentBoostedVotePeriodLimit.add(proposal.times[1]));
858 
859         expirationCallBounty = calcExecuteCallBounty(_proposalId);
860         proposal.totalStakes = proposal.totalStakes.sub(expirationCallBounty);
861         require(stakingToken.transfer(msg.sender, expirationCallBounty), "transfer to msg.sender failed");
862         emit ExpirationCallBounty(_proposalId, msg.sender, expirationCallBounty);
863     }
864 
865     /**
866      * @dev hash the parameters, save them if necessary, and return the hash value
867      * @param _params a parameters array
868      *    _params[0] - _queuedVoteRequiredPercentage,
869      *    _params[1] - _queuedVotePeriodLimit, //the time limit for a proposal to be in an absolute voting mode.
870      *    _params[2] - _boostedVotePeriodLimit, //the time limit for a proposal to be in an relative voting mode.
871      *    _params[3] - _preBoostedVotePeriodLimit, //the time limit for a proposal to be in an preparation
872      *                  state (stable) before boosted.
873      *    _params[4] -_thresholdConst
874      *    _params[5] -_quietEndingPeriod
875      *    _params[6] -_proposingRepReward
876      *    _params[7] -_votersReputationLossRatio
877      *    _params[8] -_minimumDaoBounty
878      *    _params[9] -_daoBountyConst
879      *    _params[10] -_activationTime
880      * @param _voteOnBehalf - authorized to vote on behalf of others.
881     */
882     function setParameters(
883         uint[11] calldata _params, //use array here due to stack too deep issue.
884         address _voteOnBehalf
885     )
886     external
887     returns(bytes32)
888     {
889         require(_params[0] <= 100 && _params[0] >= 50, "50 <= queuedVoteRequiredPercentage <= 100");
890         require(_params[4] <= 16000 && _params[4] > 1000, "1000 < thresholdConst <= 16000");
891         require(_params[7] <= 100, "votersReputationLossRatio <= 100");
892         require(_params[2] >= _params[5], "boostedVotePeriodLimit >= quietEndingPeriod");
893         require(_params[8] > 0, "minimumDaoBounty should be > 0");
894         require(_params[9] > 0, "daoBountyConst should be > 0");
895 
896         bytes32 paramsHash = getParametersHash(_params, _voteOnBehalf);
897         //set a limit for power for a given alpha to prevent overflow
898         uint256 limitExponent = 172;//for alpha less or equal 2
899         uint256 j = 2;
900         for (uint256 i = 2000; i < 16000; i = i*2) {
901             if ((_params[4] > i) && (_params[4] <= i*2)) {
902                 limitExponent = limitExponent/j;
903                 break;
904             }
905             j++;
906         }
907 
908         parameters[paramsHash] = Parameters({
909             queuedVoteRequiredPercentage: _params[0],
910             queuedVotePeriodLimit: _params[1],
911             boostedVotePeriodLimit: _params[2],
912             preBoostedVotePeriodLimit: _params[3],
913             thresholdConst:uint216(_params[4]).fraction(uint216(1000)),
914             limitExponentValue:limitExponent,
915             quietEndingPeriod: _params[5],
916             proposingRepReward: _params[6],
917             votersReputationLossRatio:_params[7],
918             minimumDaoBounty:_params[8],
919             daoBountyConst:_params[9],
920             activationTime:_params[10],
921             voteOnBehalf:_voteOnBehalf
922         });
923         return paramsHash;
924     }
925 
926     /**
927      * @dev redeem a reward for a successful stake, vote or proposing.
928      * The function use a beneficiary address as a parameter (and not msg.sender) to enable
929      * users to redeem on behalf of someone else.
930      * @param _proposalId the ID of the proposal
931      * @param _beneficiary - the beneficiary address
932      * @return rewards -
933      *           [0] stakerTokenReward
934      *           [1] voterReputationReward
935      *           [2] proposerReputationReward
936      */
937      // solhint-disable-next-line function-max-lines,code-complexity
938     function redeem(bytes32 _proposalId, address _beneficiary) public returns (uint[3] memory rewards) {
939         Proposal storage proposal = proposals[_proposalId];
940         require((proposal.state == ProposalState.Executed)||(proposal.state == ProposalState.ExpiredInQueue),
941         "Proposal should be Executed or ExpiredInQueue");
942         Parameters memory params = parameters[proposal.paramsHash];
943         //as staker
944         Staker storage staker = proposal.stakers[_beneficiary];
945         uint256 totalWinningStakes = proposal.stakes[proposal.winningVote];
946         uint256 totalStakesLeftAfterCallBounty =
947         proposal.stakes[NO].add(proposal.stakes[YES]).sub(calcExecuteCallBounty(_proposalId));
948         if (staker.amount > 0) {
949 
950             if (proposal.state == ProposalState.ExpiredInQueue) {
951                 //Stakes of a proposal that expires in Queue are sent back to stakers
952                 rewards[0] = staker.amount;
953             } else if (staker.vote == proposal.winningVote) {
954                 if (staker.vote == YES) {
955                     if (proposal.daoBounty < totalStakesLeftAfterCallBounty) {
956                         uint256 _totalStakes = totalStakesLeftAfterCallBounty.sub(proposal.daoBounty);
957                         rewards[0] = (staker.amount.mul(_totalStakes))/totalWinningStakes;
958                     }
959                 } else {
960                     rewards[0] = (staker.amount.mul(totalStakesLeftAfterCallBounty))/totalWinningStakes;
961                 }
962             }
963             staker.amount = 0;
964         }
965             //dao redeem its winnings
966         if (proposal.daoRedeemItsWinnings == false &&
967             _beneficiary == organizations[proposal.organizationId] &&
968             proposal.state != ProposalState.ExpiredInQueue &&
969             proposal.winningVote == NO) {
970             rewards[0] =
971             rewards[0]
972             .add((proposal.daoBounty.mul(totalStakesLeftAfterCallBounty))/totalWinningStakes)
973             .sub(proposal.daoBounty);
974             proposal.daoRedeemItsWinnings = true;
975         }
976 
977         //as voter
978         Voter storage voter = proposal.voters[_beneficiary];
979         if ((voter.reputation != 0) && (voter.preBoosted)) {
980             if (proposal.state == ProposalState.ExpiredInQueue) {
981               //give back reputation for the voter
982                 rewards[1] = ((voter.reputation.mul(params.votersReputationLossRatio))/100);
983             } else if (proposal.winningVote == voter.vote) {
984                 uint256 lostReputation;
985                 if (proposal.winningVote == YES) {
986                     lostReputation = proposal.preBoostedVotes[NO];
987                 } else {
988                     lostReputation = proposal.preBoostedVotes[YES];
989                 }
990                 lostReputation = (lostReputation.mul(params.votersReputationLossRatio))/100;
991                 rewards[1] = ((voter.reputation.mul(params.votersReputationLossRatio))/100)
992                 .add((voter.reputation.mul(lostReputation))/proposal.preBoostedVotes[proposal.winningVote]);
993             }
994             voter.reputation = 0;
995         }
996         //as proposer
997         if ((proposal.proposer == _beneficiary)&&(proposal.winningVote == YES)&&(proposal.proposer != address(0))) {
998             rewards[2] = params.proposingRepReward;
999             proposal.proposer = address(0);
1000         }
1001         if (rewards[0] != 0) {
1002             proposal.totalStakes = proposal.totalStakes.sub(rewards[0]);
1003             require(stakingToken.transfer(_beneficiary, rewards[0]), "transfer to beneficiary failed");
1004             emit Redeem(_proposalId, organizations[proposal.organizationId], _beneficiary, rewards[0]);
1005         }
1006         if (rewards[1].add(rewards[2]) != 0) {
1007             VotingMachineCallbacksInterface(proposal.callbacks)
1008             .mintReputation(rewards[1].add(rewards[2]), _beneficiary, _proposalId);
1009             emit RedeemReputation(
1010             _proposalId,
1011             organizations[proposal.organizationId],
1012             _beneficiary,
1013             rewards[1].add(rewards[2])
1014             );
1015         }
1016     }
1017 
1018     /**
1019      * @dev redeemDaoBounty a reward for a successful stake.
1020      * The function use a beneficiary address as a parameter (and not msg.sender) to enable
1021      * users to redeem on behalf of someone else.
1022      * @param _proposalId the ID of the proposal
1023      * @param _beneficiary - the beneficiary address
1024      * @return redeemedAmount - redeem token amount
1025      * @return potentialAmount - potential redeem token amount(if there is enough tokens bounty at the organization )
1026      */
1027     function redeemDaoBounty(bytes32 _proposalId, address _beneficiary)
1028     public
1029     returns(uint256 redeemedAmount, uint256 potentialAmount) {
1030         Proposal storage proposal = proposals[_proposalId];
1031         require(proposal.state == ProposalState.Executed);
1032         uint256 totalWinningStakes = proposal.stakes[proposal.winningVote];
1033         Staker storage staker = proposal.stakers[_beneficiary];
1034         if (
1035             (staker.amount4Bounty > 0)&&
1036             (staker.vote == proposal.winningVote)&&
1037             (proposal.winningVote == YES)&&
1038             (totalWinningStakes != 0)) {
1039             //as staker
1040                 potentialAmount = (staker.amount4Bounty * proposal.daoBounty)/totalWinningStakes;
1041             }
1042         if ((potentialAmount != 0)&&
1043             (VotingMachineCallbacksInterface(proposal.callbacks)
1044             .balanceOfStakingToken(stakingToken, _proposalId) >= potentialAmount)) {
1045             staker.amount4Bounty = 0;
1046             proposal.daoBountyRemain = proposal.daoBountyRemain.sub(potentialAmount);
1047             require(
1048             VotingMachineCallbacksInterface(proposal.callbacks)
1049             .stakingTokenTransfer(stakingToken, _beneficiary, potentialAmount, _proposalId));
1050             redeemedAmount = potentialAmount;
1051             emit RedeemDaoBounty(_proposalId, organizations[proposal.organizationId], _beneficiary, redeemedAmount);
1052         }
1053     }
1054 
1055     /**
1056       * @dev calcExecuteCallBounty calculate the execute boosted call bounty
1057       * @param _proposalId the ID of the proposal
1058       * @return uint256 executeCallBounty
1059     */
1060     function calcExecuteCallBounty(bytes32 _proposalId) public view returns(uint256) {
1061         uint maxRewardSeconds = 1500;
1062         uint rewardSeconds =
1063         uint256(maxRewardSeconds).min(proposals[_proposalId].secondsFromTimeOutTillExecuteBoosted);
1064         return rewardSeconds.mul(proposals[_proposalId].stakes[YES]).div(maxRewardSeconds*10);
1065     }
1066 
1067     /**
1068      * @dev shouldBoost check if a proposal should be shifted to boosted phase.
1069      * @param _proposalId the ID of the proposal
1070      * @return bool true or false.
1071      */
1072     function shouldBoost(bytes32 _proposalId) public view returns(bool) {
1073         Proposal memory proposal = proposals[_proposalId];
1074         return (_score(_proposalId) > threshold(proposal.paramsHash, proposal.organizationId));
1075     }
1076 
1077     /**
1078      * @dev threshold return the organization's score threshold which required by
1079      * a proposal to shift to boosted state.
1080      * This threshold is dynamically set and it depend on the number of boosted proposal.
1081      * @param _organizationId the organization identifier
1082      * @param _paramsHash the organization parameters hash
1083      * @return uint256 organization's score threshold as real number.
1084      */
1085     function threshold(bytes32 _paramsHash, bytes32 _organizationId) public view returns(uint256) {
1086         uint256 power = orgBoostedProposalsCnt[_organizationId];
1087         Parameters storage params = parameters[_paramsHash];
1088 
1089         if (power > params.limitExponentValue) {
1090             power = params.limitExponentValue;
1091         }
1092 
1093         return params.thresholdConst.pow(power);
1094     }
1095 
1096   /**
1097    * @dev hashParameters returns a hash of the given parameters
1098    */
1099     function getParametersHash(
1100         uint[11] memory _params,//use array here due to stack too deep issue.
1101         address _voteOnBehalf
1102     )
1103         public
1104         pure
1105         returns(bytes32)
1106         {
1107         //double call to keccak256 to avoid deep stack issue when call with too many params.
1108         return keccak256(
1109             abi.encodePacked(
1110             keccak256(
1111             abi.encodePacked(
1112                 _params[0],
1113                 _params[1],
1114                 _params[2],
1115                 _params[3],
1116                 _params[4],
1117                 _params[5],
1118                 _params[6],
1119                 _params[7],
1120                 _params[8],
1121                 _params[9],
1122                 _params[10])
1123             ),
1124             _voteOnBehalf
1125         ));
1126     }
1127 
1128     /**
1129       * @dev execute check if the proposal has been decided, and if so, execute the proposal
1130       * @param _proposalId the id of the proposal
1131       * @return bool true - the proposal has been executed
1132       *              false - otherwise.
1133      */
1134      // solhint-disable-next-line function-max-lines,code-complexity
1135     function _execute(bytes32 _proposalId) internal votable(_proposalId) returns(bool) {
1136         Proposal storage proposal = proposals[_proposalId];
1137         Parameters memory params = parameters[proposal.paramsHash];
1138         Proposal memory tmpProposal = proposal;
1139         uint256 totalReputation =
1140         VotingMachineCallbacksInterface(proposal.callbacks).getTotalReputationSupply(_proposalId);
1141         //first divide by 100 to prevent overflow
1142         uint256 executionBar = (totalReputation/100) * params.queuedVoteRequiredPercentage;
1143         ExecutionState executionState = ExecutionState.None;
1144         uint256 averageDownstakesOfBoosted;
1145         uint256 confidenceThreshold;
1146 
1147         if (proposal.votes[proposal.winningVote] > executionBar) {
1148          // someone crossed the absolute vote execution bar.
1149             if (proposal.state == ProposalState.Queued) {
1150                 executionState = ExecutionState.QueueBarCrossed;
1151             } else if (proposal.state == ProposalState.PreBoosted) {
1152                 executionState = ExecutionState.PreBoostedBarCrossed;
1153             } else {
1154                 executionState = ExecutionState.BoostedBarCrossed;
1155             }
1156             proposal.state = ProposalState.Executed;
1157         } else {
1158             if (proposal.state == ProposalState.Queued) {
1159                 // solhint-disable-next-line not-rely-on-time
1160                 if ((now - proposal.times[0]) >= params.queuedVotePeriodLimit) {
1161                     proposal.state = ProposalState.ExpiredInQueue;
1162                     proposal.winningVote = NO;
1163                     executionState = ExecutionState.QueueTimeOut;
1164                 } else {
1165                     confidenceThreshold = threshold(proposal.paramsHash, proposal.organizationId);
1166                     if (_score(_proposalId) > confidenceThreshold) {
1167                         //change proposal mode to PreBoosted mode.
1168                         proposal.state = ProposalState.PreBoosted;
1169                         // solhint-disable-next-line not-rely-on-time
1170                         proposal.times[2] = now;
1171                         proposal.confidenceThreshold = confidenceThreshold;
1172                     }
1173                 }
1174             }
1175 
1176             if (proposal.state == ProposalState.PreBoosted) {
1177                 confidenceThreshold = threshold(proposal.paramsHash, proposal.organizationId);
1178               // solhint-disable-next-line not-rely-on-time
1179                 if ((now - proposal.times[2]) >= params.preBoostedVotePeriodLimit) {
1180                     if (_score(_proposalId) > confidenceThreshold) {
1181                         if (orgBoostedProposalsCnt[proposal.organizationId] < MAX_BOOSTED_PROPOSALS) {
1182                          //change proposal mode to Boosted mode.
1183                             proposal.state = ProposalState.Boosted;
1184                          // solhint-disable-next-line not-rely-on-time
1185                             proposal.times[1] = now;
1186                             orgBoostedProposalsCnt[proposal.organizationId]++;
1187                          //add a value to average -> average = average + ((value - average) / nbValues)
1188                             averageDownstakesOfBoosted = averagesDownstakesOfBoosted[proposal.organizationId];
1189                           // solium-disable-next-line indentation
1190                             averagesDownstakesOfBoosted[proposal.organizationId] =
1191                                 uint256(int256(averageDownstakesOfBoosted) +
1192                                 ((int256(proposal.stakes[NO])-int256(averageDownstakesOfBoosted))/
1193                                 int256(orgBoostedProposalsCnt[proposal.organizationId])));
1194                         }
1195                     } else {
1196                         proposal.state = ProposalState.Queued;
1197                     }
1198                 } else { //check the Confidence level is stable
1199                     uint256 proposalScore = _score(_proposalId);
1200                     if (proposalScore <= proposal.confidenceThreshold.min(confidenceThreshold)) {
1201                         proposal.state = ProposalState.Queued;
1202                     } else if (proposal.confidenceThreshold > proposalScore) {
1203                         proposal.confidenceThreshold = confidenceThreshold;
1204                         emit ConfidenceLevelChange(_proposalId, confidenceThreshold);
1205                     }
1206                 }
1207             }
1208         }
1209 
1210         if ((proposal.state == ProposalState.Boosted) ||
1211             (proposal.state == ProposalState.QuietEndingPeriod)) {
1212             // solhint-disable-next-line not-rely-on-time
1213             if ((now - proposal.times[1]) >= proposal.currentBoostedVotePeriodLimit) {
1214                 proposal.state = ProposalState.Executed;
1215                 executionState = ExecutionState.BoostedTimeOut;
1216             }
1217         }
1218 
1219         if (executionState != ExecutionState.None) {
1220             if ((executionState == ExecutionState.BoostedTimeOut) ||
1221                 (executionState == ExecutionState.BoostedBarCrossed)) {
1222                 orgBoostedProposalsCnt[tmpProposal.organizationId] =
1223                 orgBoostedProposalsCnt[tmpProposal.organizationId].sub(1);
1224                 //remove a value from average = ((average * nbValues) - value) / (nbValues - 1);
1225                 uint256 boostedProposals = orgBoostedProposalsCnt[tmpProposal.organizationId];
1226                 if (boostedProposals == 0) {
1227                     averagesDownstakesOfBoosted[proposal.organizationId] = 0;
1228                 } else {
1229                     averageDownstakesOfBoosted = averagesDownstakesOfBoosted[proposal.organizationId];
1230                     averagesDownstakesOfBoosted[proposal.organizationId] =
1231                     (averageDownstakesOfBoosted.mul(boostedProposals+1).sub(proposal.stakes[NO]))/boostedProposals;
1232                 }
1233             }
1234             emit ExecuteProposal(
1235             _proposalId,
1236             organizations[proposal.organizationId],
1237             proposal.winningVote,
1238             totalReputation
1239             );
1240             emit GPExecuteProposal(_proposalId, executionState);
1241             ProposalExecuteInterface(proposal.callbacks).executeProposal(_proposalId, int(proposal.winningVote));
1242             proposal.daoBounty = proposal.daoBountyRemain;
1243         }
1244         if (tmpProposal.state != proposal.state) {
1245             emit StateChange(_proposalId, proposal.state);
1246         }
1247         return (executionState != ExecutionState.None);
1248     }
1249 
1250     /**
1251      * @dev staking function
1252      * @param _proposalId id of the proposal
1253      * @param _vote  NO(2) or YES(1).
1254      * @param _amount the betting amount
1255      * @return bool true - the proposal has been executed
1256      *              false - otherwise.
1257      */
1258     function _stake(bytes32 _proposalId, uint256 _vote, uint256 _amount, address _staker) internal returns(bool) {
1259         // 0 is not a valid vote.
1260         require(_vote <= NUM_OF_CHOICES && _vote > 0, "wrong vote value");
1261         require(_amount > 0, "staking amount should be >0");
1262 
1263         if (_execute(_proposalId)) {
1264             return true;
1265         }
1266         Proposal storage proposal = proposals[_proposalId];
1267 
1268         if ((proposal.state != ProposalState.PreBoosted) &&
1269             (proposal.state != ProposalState.Queued)) {
1270             return false;
1271         }
1272 
1273         // enable to increase stake only on the previous stake vote
1274         Staker storage staker = proposal.stakers[_staker];
1275         if ((staker.amount > 0) && (staker.vote != _vote)) {
1276             return false;
1277         }
1278 
1279         uint256 amount = _amount;
1280         require(stakingToken.transferFrom(_staker, address(this), amount), "fail transfer from staker");
1281         proposal.totalStakes = proposal.totalStakes.add(amount); //update totalRedeemableStakes
1282         staker.amount = staker.amount.add(amount);
1283         //This is to prevent average downstakes calculation overflow
1284         //Note that any how GEN cap is 100000000 ether.
1285         require(staker.amount <= 0x100000000000000000000000000000000, "staking amount is too high");
1286         require(proposal.totalStakes <= uint256(0x100000000000000000000000000000000).sub(proposal.daoBountyRemain),
1287                 "total stakes is too high");
1288 
1289         if (_vote == YES) {
1290             staker.amount4Bounty = staker.amount4Bounty.add(amount);
1291         }
1292         staker.vote = _vote;
1293 
1294         proposal.stakes[_vote] = amount.add(proposal.stakes[_vote]);
1295         emit Stake(_proposalId, organizations[proposal.organizationId], _staker, _vote, _amount);
1296         return _execute(_proposalId);
1297     }
1298 
1299     /**
1300      * @dev Vote for a proposal, if the voter already voted, cancel the last vote and set a new one instead
1301      * @param _proposalId id of the proposal
1302      * @param _voter used in case the vote is cast for someone else
1303      * @param _vote a value between 0 to and the proposal's number of choices.
1304      * @param _rep how many reputation the voter would like to stake for this vote.
1305      *         if  _rep==0 so the voter full reputation will be use.
1306      * @return true in case of proposal execution otherwise false
1307      * throws if proposal is not open or if it has been executed
1308      * NB: executes the proposal if a decision has been reached
1309      */
1310      // solhint-disable-next-line function-max-lines,code-complexity
1311     function internalVote(bytes32 _proposalId, address _voter, uint256 _vote, uint256 _rep) internal returns(bool) {
1312         require(_vote <= NUM_OF_CHOICES && _vote > 0, "0 < _vote <= 2");
1313         if (_execute(_proposalId)) {
1314             return true;
1315         }
1316 
1317         Parameters memory params = parameters[proposals[_proposalId].paramsHash];
1318         Proposal storage proposal = proposals[_proposalId];
1319 
1320         // Check voter has enough reputation:
1321         uint256 reputation = VotingMachineCallbacksInterface(proposal.callbacks).reputationOf(_voter, _proposalId);
1322         require(reputation > 0, "_voter must have reputation");
1323         require(reputation >= _rep, "reputation >= _rep");
1324         uint256 rep = _rep;
1325         if (rep == 0) {
1326             rep = reputation;
1327         }
1328         // If this voter has already voted, return false.
1329         if (proposal.voters[_voter].reputation != 0) {
1330             return false;
1331         }
1332         // The voting itself:
1333         proposal.votes[_vote] = rep.add(proposal.votes[_vote]);
1334         //check if the current winningVote changed or there is a tie.
1335         //for the case there is a tie the current winningVote set to NO.
1336         if ((proposal.votes[_vote] > proposal.votes[proposal.winningVote]) ||
1337             ((proposal.votes[NO] == proposal.votes[proposal.winningVote]) &&
1338             proposal.winningVote == YES)) {
1339             if (proposal.state == ProposalState.Boosted &&
1340             // solhint-disable-next-line not-rely-on-time
1341                 ((now - proposal.times[1]) >= (params.boostedVotePeriodLimit - params.quietEndingPeriod))||
1342                 proposal.state == ProposalState.QuietEndingPeriod) {
1343                 //quietEndingPeriod
1344                 if (proposal.state != ProposalState.QuietEndingPeriod) {
1345                     proposal.currentBoostedVotePeriodLimit = params.quietEndingPeriod;
1346                     proposal.state = ProposalState.QuietEndingPeriod;
1347                     emit StateChange(_proposalId, proposal.state);
1348                 }
1349                 // solhint-disable-next-line not-rely-on-time
1350                 proposal.times[1] = now;
1351             }
1352             proposal.winningVote = _vote;
1353         }
1354         proposal.voters[_voter] = Voter({
1355             reputation: rep,
1356             vote: _vote,
1357             preBoosted:((proposal.state == ProposalState.PreBoosted) || (proposal.state == ProposalState.Queued))
1358         });
1359         if ((proposal.state == ProposalState.PreBoosted) || (proposal.state == ProposalState.Queued)) {
1360             proposal.preBoostedVotes[_vote] = rep.add(proposal.preBoostedVotes[_vote]);
1361             uint256 reputationDeposit = (params.votersReputationLossRatio.mul(rep))/100;
1362             VotingMachineCallbacksInterface(proposal.callbacks).burnReputation(reputationDeposit, _voter, _proposalId);
1363         }
1364         emit VoteProposal(_proposalId, organizations[proposal.organizationId], _voter, _vote, rep);
1365         return _execute(_proposalId);
1366     }
1367 
1368     /**
1369      * @dev _score return the proposal score (Confidence level)
1370      * For dual choice proposal S = (S+)/(S-)
1371      * @param _proposalId the ID of the proposal
1372      * @return uint256 proposal score as real number.
1373      */
1374     function _score(bytes32 _proposalId) internal view returns(uint256) {
1375         Proposal storage proposal = proposals[_proposalId];
1376         //proposal.stakes[NO] cannot be zero as the dao downstake > 0 for each proposal.
1377         return uint216(proposal.stakes[YES]).fraction(uint216(proposal.stakes[NO]));
1378     }
1379 
1380     /**
1381       * @dev _isVotable check if the proposal is votable
1382       * @param _proposalId the ID of the proposal
1383       * @return bool true or false
1384     */
1385     function _isVotable(bytes32 _proposalId) internal view returns(bool) {
1386         ProposalState pState = proposals[_proposalId].state;
1387         return ((pState == ProposalState.PreBoosted)||
1388                 (pState == ProposalState.Boosted)||
1389                 (pState == ProposalState.QuietEndingPeriod)||
1390                 (pState == ProposalState.Queued)
1391         );
1392     }
1393 }
1394 
1395 // File: @daostack/infra/contracts/votingMachines/GenesisProtocol.sol
1396 
1397 pragma solidity ^0.5.11;
1398 
1399 
1400 
1401 
1402 /**
1403  * @title GenesisProtocol implementation -an organization's voting machine scheme.
1404  */
1405 contract GenesisProtocol is IntVoteInterface, GenesisProtocolLogic {
1406     using ECDSA for bytes32;
1407 
1408     // Digest describing the data the user signs according EIP 712.
1409     // Needs to match what is passed to Metamask.
1410     bytes32 public constant DELEGATION_HASH_EIP712 =
1411     keccak256(abi.encodePacked(
1412     "address GenesisProtocolAddress",
1413     "bytes32 ProposalId",
1414     "uint256 Vote",
1415     "uint256 AmountToStake",
1416     "uint256 Nonce"
1417     ));
1418 
1419     mapping(address=>uint256) public stakesNonce; //stakes Nonce
1420 
1421     /**
1422      * @dev Constructor
1423      */
1424     constructor(IERC20 _stakingToken)
1425     public
1426     // solhint-disable-next-line no-empty-blocks
1427     GenesisProtocolLogic(_stakingToken) {
1428     }
1429 
1430     /**
1431      * @dev staking function
1432      * @param _proposalId id of the proposal
1433      * @param _vote  NO(2) or YES(1).
1434      * @param _amount the betting amount
1435      * @return bool true - the proposal has been executed
1436      *              false - otherwise.
1437      */
1438     function stake(bytes32 _proposalId, uint256 _vote, uint256 _amount) external returns(bool) {
1439         return _stake(_proposalId, _vote, _amount, msg.sender);
1440     }
1441 
1442     /**
1443      * @dev stakeWithSignature function
1444      * @param _proposalId id of the proposal
1445      * @param _vote  NO(2) or YES(1).
1446      * @param _amount the betting amount
1447      * @param _nonce nonce value ,it is part of the signature to ensure that
1448               a signature can be received only once.
1449      * @param _signatureType signature type
1450               1 - for web3.eth.sign
1451               2 - for eth_signTypedData according to EIP #712.
1452      * @param _signature  - signed data by the staker
1453      * @return bool true - the proposal has been executed
1454      *              false - otherwise.
1455      */
1456     function stakeWithSignature(
1457         bytes32 _proposalId,
1458         uint256 _vote,
1459         uint256 _amount,
1460         uint256 _nonce,
1461         uint256 _signatureType,
1462         bytes calldata _signature
1463         )
1464         external
1465         returns(bool)
1466         {
1467         // Recreate the digest the user signed
1468         bytes32 delegationDigest;
1469         if (_signatureType == 2) {
1470             delegationDigest = keccak256(
1471                 abi.encodePacked(
1472                     DELEGATION_HASH_EIP712, keccak256(
1473                         abi.encodePacked(
1474                         address(this),
1475                         _proposalId,
1476                         _vote,
1477                         _amount,
1478                         _nonce)
1479                     )
1480                 )
1481             );
1482         } else {
1483             delegationDigest = keccak256(
1484                         abi.encodePacked(
1485                         address(this),
1486                         _proposalId,
1487                         _vote,
1488                         _amount,
1489                         _nonce)
1490                     ).toEthSignedMessageHash();
1491         }
1492         address staker = delegationDigest.recover(_signature);
1493         //a garbage staker address due to wrong signature will revert due to lack of approval and funds.
1494         require(staker != address(0), "staker address cannot be 0");
1495         require(stakesNonce[staker] == _nonce);
1496         stakesNonce[staker] = stakesNonce[staker].add(1);
1497         return _stake(_proposalId, _vote, _amount, staker);
1498     }
1499 
1500     /**
1501      * @dev voting function
1502      * @param _proposalId id of the proposal
1503      * @param _vote NO(2) or YES(1).
1504      * @param _amount the reputation amount to vote with . if _amount == 0 it will use all voter reputation.
1505      * @param _voter voter address
1506      * @return bool true - the proposal has been executed
1507      *              false - otherwise.
1508      */
1509     function vote(bytes32 _proposalId, uint256 _vote, uint256 _amount, address _voter)
1510     external
1511     votable(_proposalId)
1512     returns(bool) {
1513         Proposal storage proposal = proposals[_proposalId];
1514         Parameters memory params = parameters[proposal.paramsHash];
1515         address voter;
1516         if (params.voteOnBehalf != address(0)) {
1517             require(msg.sender == params.voteOnBehalf);
1518             voter = _voter;
1519         } else {
1520             voter = msg.sender;
1521         }
1522         return internalVote(_proposalId, voter, _vote, _amount);
1523     }
1524 
1525   /**
1526    * @dev Cancel the vote of the msg.sender.
1527    * cancel vote is not allow in genesisProtocol so this function doing nothing.
1528    * This function is here in order to comply to the IntVoteInterface .
1529    */
1530     function cancelVote(bytes32 _proposalId) external votable(_proposalId) {
1531        //this is not allowed
1532         return;
1533     }
1534 
1535     /**
1536       * @dev execute check if the proposal has been decided, and if so, execute the proposal
1537       * @param _proposalId the id of the proposal
1538       * @return bool true - the proposal has been executed
1539       *              false - otherwise.
1540      */
1541     function execute(bytes32 _proposalId) external votable(_proposalId) returns(bool) {
1542         return _execute(_proposalId);
1543     }
1544 
1545   /**
1546     * @dev getNumberOfChoices returns the number of choices possible in this proposal
1547     * @return uint256 that contains number of choices
1548     */
1549     function getNumberOfChoices(bytes32) external view returns(uint256) {
1550         return NUM_OF_CHOICES;
1551     }
1552 
1553     /**
1554       * @dev getProposalTimes returns proposals times variables.
1555       * @param _proposalId id of the proposal
1556       * @return proposals times array
1557       */
1558     function getProposalTimes(bytes32 _proposalId) external view returns(uint[3] memory times) {
1559         return proposals[_proposalId].times;
1560     }
1561 
1562     /**
1563      * @dev voteInfo returns the vote and the amount of reputation of the user committed to this proposal
1564      * @param _proposalId the ID of the proposal
1565      * @param _voter the address of the voter
1566      * @return uint256 vote - the voters vote
1567      *        uint256 reputation - amount of reputation committed by _voter to _proposalId
1568      */
1569     function voteInfo(bytes32 _proposalId, address _voter) external view returns(uint, uint) {
1570         Voter memory voter = proposals[_proposalId].voters[_voter];
1571         return (voter.vote, voter.reputation);
1572     }
1573 
1574     /**
1575     * @dev voteStatus returns the reputation voted for a proposal for a specific voting choice.
1576     * @param _proposalId the ID of the proposal
1577     * @param _choice the index in the
1578     * @return voted reputation for the given choice
1579     */
1580     function voteStatus(bytes32 _proposalId, uint256 _choice) external view returns(uint256) {
1581         return proposals[_proposalId].votes[_choice];
1582     }
1583 
1584     /**
1585     * @dev isVotable check if the proposal is votable
1586     * @param _proposalId the ID of the proposal
1587     * @return bool true or false
1588     */
1589     function isVotable(bytes32 _proposalId) external view returns(bool) {
1590         return _isVotable(_proposalId);
1591     }
1592 
1593     /**
1594     * @dev proposalStatus return the total votes and stakes for a given proposal
1595     * @param _proposalId the ID of the proposal
1596     * @return uint256 preBoostedVotes YES
1597     * @return uint256 preBoostedVotes NO
1598     * @return uint256 total stakes YES
1599     * @return uint256 total stakes NO
1600     */
1601     function proposalStatus(bytes32 _proposalId) external view returns(uint256, uint256, uint256, uint256) {
1602         return (
1603                 proposals[_proposalId].preBoostedVotes[YES],
1604                 proposals[_proposalId].preBoostedVotes[NO],
1605                 proposals[_proposalId].stakes[YES],
1606                 proposals[_proposalId].stakes[NO]
1607         );
1608     }
1609 
1610   /**
1611     * @dev getProposalOrganization return the organizationId for a given proposal
1612     * @param _proposalId the ID of the proposal
1613     * @return bytes32 organization identifier
1614     */
1615     function getProposalOrganization(bytes32 _proposalId) external view returns(bytes32) {
1616         return (proposals[_proposalId].organizationId);
1617     }
1618 
1619     /**
1620       * @dev getStaker return the vote and stake amount for a given proposal and staker
1621       * @param _proposalId the ID of the proposal
1622       * @param _staker staker address
1623       * @return uint256 vote
1624       * @return uint256 amount
1625     */
1626     function getStaker(bytes32 _proposalId, address _staker) external view returns(uint256, uint256) {
1627         return (proposals[_proposalId].stakers[_staker].vote, proposals[_proposalId].stakers[_staker].amount);
1628     }
1629 
1630     /**
1631       * @dev voteStake return the amount stakes for a given proposal and vote
1632       * @param _proposalId the ID of the proposal
1633       * @param _vote vote number
1634       * @return uint256 stake amount
1635     */
1636     function voteStake(bytes32 _proposalId, uint256 _vote) external view returns(uint256) {
1637         return proposals[_proposalId].stakes[_vote];
1638     }
1639 
1640   /**
1641     * @dev voteStake return the winningVote for a given proposal
1642     * @param _proposalId the ID of the proposal
1643     * @return uint256 winningVote
1644     */
1645     function winningVote(bytes32 _proposalId) external view returns(uint256) {
1646         return proposals[_proposalId].winningVote;
1647     }
1648 
1649     /**
1650       * @dev voteStake return the state for a given proposal
1651       * @param _proposalId the ID of the proposal
1652       * @return ProposalState proposal state
1653     */
1654     function state(bytes32 _proposalId) external view returns(ProposalState) {
1655         return proposals[_proposalId].state;
1656     }
1657 
1658    /**
1659     * @dev isAbstainAllow returns if the voting machine allow abstain (0)
1660     * @return bool true or false
1661     */
1662     function isAbstainAllow() external pure returns(bool) {
1663         return false;
1664     }
1665 
1666     /**
1667      * @dev getAllowedRangeOfChoices returns the allowed range of choices for a voting machine.
1668      * @return min - minimum number of choices
1669                max - maximum number of choices
1670      */
1671     function getAllowedRangeOfChoices() external pure returns(uint256 min, uint256 max) {
1672         return (YES, NO);
1673     }
1674 
1675     /**
1676      * @dev score return the proposal score
1677      * @param _proposalId the ID of the proposal
1678      * @return uint256 proposal score.
1679      */
1680     function score(bytes32 _proposalId) public view returns(uint256) {
1681         return  _score(_proposalId);
1682     }
1683 }