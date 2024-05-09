1 pragma solidity 0.4.18;
2 
3 /**
4  * @title Math
5  * @dev Assorted math operations
6  */
7 
8 library Math {
9   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
10     return a >= b ? a : b;
11   }
12 
13   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
14     return a < b ? a : b;
15   }
16 
17   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
18     return a >= b ? a : b;
19   }
20 
21   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
22     return a < b ? a : b;
23   }
24 }
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     if (a == 0) {
34       return 0;
35     }
36     uint256 c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 
61 /**
62  * @title Ownable
63  * @dev The Ownable contract has an owner address, and provides basic authorization control
64  * functions, this simplifies the implementation of "user permissions".
65  */
66 contract Ownable {
67   address public owner;
68 
69 
70   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   function Ownable() public {
78     owner = msg.sender;
79   }
80 
81 
82   /**
83    * @dev Throws if called by any account other than the owner.
84    */
85   modifier onlyOwner() {
86     require(msg.sender == owner);
87     _;
88   }
89 
90 
91   /**
92    * @dev Allows the current owner to transfer control of the contract to a newOwner.
93    * @param newOwner The address to transfer ownership to.
94    */
95   function transferOwnership(address newOwner) public onlyOwner {
96     require(newOwner != address(0));
97     OwnershipTransferred(owner, newOwner);
98     owner = newOwner;
99   }
100 
101 }
102 
103 
104 /**
105  * @title Contracts that should be able to recover tokens
106  * @author SylTi
107  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
108  * This will prevent any accidental loss of tokens.
109  */
110 contract CanReclaimToken is Ownable {
111   using SafeERC20 for ERC20Basic;
112 
113   /**
114    * @dev Reclaim all ERC20Basic compatible tokens
115    * @param token ERC20Basic The address of the token contract
116    */
117   function reclaimToken(ERC20Basic token) external onlyOwner {
118     uint256 balance = token.balanceOf(this);
119     token.safeTransfer(owner, balance);
120   }
121 
122 }
123 
124 
125 
126 
127 /**
128  * @title Claimable
129  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
130  * This allows the new owner to accept the transfer.
131  */
132 contract Claimable is Ownable {
133   address public pendingOwner;
134 
135   /**
136    * @dev Modifier throws if called by any account other than the pendingOwner.
137    */
138   modifier onlyPendingOwner() {
139     require(msg.sender == pendingOwner);
140     _;
141   }
142 
143   /**
144    * @dev Allows the current owner to set the pendingOwner address.
145    * @param newOwner The address to transfer ownership to.
146    */
147   function transferOwnership(address newOwner) onlyOwner public {
148     pendingOwner = newOwner;
149   }
150 
151   /**
152    * @dev Allows the pendingOwner address to finalize the transfer.
153    */
154   function claimOwnership() onlyPendingOwner public {
155     OwnershipTransferred(owner, pendingOwner);
156     owner = pendingOwner;
157     pendingOwner = address(0);
158   }
159 }
160 
161 
162 /**
163  * @title Contracts that should not own Contracts
164  * @author Remco Bloemen <remco@2π.com>
165  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
166  * of this contract to reclaim ownership of the contracts.
167  */
168 contract HasNoContracts is Ownable {
169 
170   /**
171    * @dev Reclaim ownership of Ownable contracts
172    * @param contractAddr The address of the Ownable to be reclaimed.
173    */
174   function reclaimContract(address contractAddr) external onlyOwner {
175     Ownable contractInst = Ownable(contractAddr);
176     contractInst.transferOwnership(owner);
177   }
178 }
179 
180 
181 /**
182  * @title Contracts that should not own Tokens
183  * @author Remco Bloemen <remco@2π.com>
184  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
185  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
186  * owner to reclaim the tokens.
187  */
188 contract HasNoTokens is CanReclaimToken {
189 
190  /**
191   * @dev Reject all ERC23 compatible tokens
192   * @param from_ address The address that is transferring the tokens
193   * @param value_ uint256 the amount of the specified token
194   * @param data_ Bytes The data passed from the caller.
195   */
196   function tokenFallback(address from_, uint256 value_, bytes data_) external {
197     from_;
198     value_;
199     data_;
200     revert();
201   }
202 
203 }
204 
205 
206 /**
207  * @title ERC20Basic
208  * @dev Simpler version of ERC20 interface
209  * @dev see https://github.com/ethereum/EIPs/issues/179
210  */
211 contract ERC20Basic {
212   uint256 public totalSupply;
213   function balanceOf(address who) public view returns (uint256);
214   function transfer(address to, uint256 value) public returns (bool);
215   event Transfer(address indexed from, address indexed to, uint256 value);
216 }
217 
218 
219 
220 
221 /**
222  * @title ERC20 interface
223  * @dev see https://github.com/ethereum/EIPs/issues/20
224  */
225 contract ERC20 is ERC20Basic {
226   function allowance(address owner, address spender) public view returns (uint256);
227   function transferFrom(address from, address to, uint256 value) public returns (bool);
228   function approve(address spender, uint256 value) public returns (bool);
229   event Approval(address indexed owner, address indexed spender, uint256 value);
230 }
231 
232 
233 
234 
235 /**
236  * @title Basic token
237  * @dev Basic version of StandardToken, with no allowances.
238  */
239 contract BasicToken is ERC20Basic {
240   using SafeMath for uint256;
241 
242   mapping(address => uint256) balances;
243 
244   /**
245   * @dev transfer token for a specified address
246   * @param _to The address to transfer to.
247   * @param _value The amount to be transferred.
248   */
249   function transfer(address _to, uint256 _value) public returns (bool) {
250     require(_to != address(0));
251     require(_value <= balances[msg.sender]);
252 
253     // SafeMath.sub will throw if there is not enough balance.
254     balances[msg.sender] = balances[msg.sender].sub(_value);
255     balances[_to] = balances[_to].add(_value);
256     Transfer(msg.sender, _to, _value);
257     return true;
258   }
259 
260   /**
261   * @dev Gets the balance of the specified address.
262   * @param _owner The address to query the the balance of.
263   * @return An uint256 representing the amount owned by the passed address.
264   */
265   function balanceOf(address _owner) public view returns (uint256 balance) {
266     return balances[_owner];
267   }
268 
269 }
270 
271 
272 
273 
274 /**
275  * @title Standard ERC20 token
276  *
277  * @dev Implementation of the basic standard token.
278  * @dev https://github.com/ethereum/EIPs/issues/20
279  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
280  */
281 contract StandardToken is ERC20, BasicToken {
282 
283   mapping (address => mapping (address => uint256)) internal allowed;
284 
285 
286   /**
287    * @dev Transfer tokens from one address to another
288    * @param _from address The address which you want to send tokens from
289    * @param _to address The address which you want to transfer to
290    * @param _value uint256 the amount of tokens to be transferred
291    */
292   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
293     require(_to != address(0));
294     require(_value <= balances[_from]);
295     require(_value <= allowed[_from][msg.sender]);
296 
297     balances[_from] = balances[_from].sub(_value);
298     balances[_to] = balances[_to].add(_value);
299     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
300     Transfer(_from, _to, _value);
301     return true;
302   }
303 
304   /**
305    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
306    *
307    * Beware that changing an allowance with this method brings the risk that someone may use both the old
308    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
309    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
310    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
311    * @param _spender The address which will spend the funds.
312    * @param _value The amount of tokens to be spent.
313    */
314   function approve(address _spender, uint256 _value) public returns (bool) {
315     allowed[msg.sender][_spender] = _value;
316     Approval(msg.sender, _spender, _value);
317     return true;
318   }
319 
320   /**
321    * @dev Function to check the amount of tokens that an owner allowed to a spender.
322    * @param _owner address The address which owns the funds.
323    * @param _spender address The address which will spend the funds.
324    * @return A uint256 specifying the amount of tokens still available for the spender.
325    */
326   function allowance(address _owner, address _spender) public view returns (uint256) {
327     return allowed[_owner][_spender];
328   }
329 
330   /**
331    * @dev Increase the amount of tokens that an owner allowed to a spender.
332    *
333    * approve should be called when allowed[_spender] == 0. To increment
334    * allowed value is better to use this function to avoid 2 calls (and wait until
335    * the first transaction is mined)
336    * From MonolithDAO Token.sol
337    * @param _spender The address which will spend the funds.
338    * @param _addedValue The amount of tokens to increase the allowance by.
339    */
340   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
341     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
342     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
343     return true;
344   }
345 
346   /**
347    * @dev Decrease the amount of tokens that an owner allowed to a spender.
348    *
349    * approve should be called when allowed[_spender] == 0. To decrement
350    * allowed value is better to use this function to avoid 2 calls (and wait until
351    * the first transaction is mined)
352    * From MonolithDAO Token.sol
353    * @param _spender The address which will spend the funds.
354    * @param _subtractedValue The amount of tokens to decrease the allowance by.
355    */
356   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
357     uint oldValue = allowed[msg.sender][_spender];
358     if (_subtractedValue > oldValue) {
359       allowed[msg.sender][_spender] = 0;
360     } else {
361       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
362     }
363     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
364     return true;
365   }
366 
367 }
368 
369 
370 
371 
372 
373 /**
374  * @title Mintable token
375  * @dev Simple ERC20 Token example, with mintable token creation
376  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
377  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
378  */
379 
380 contract MintableToken is StandardToken, Ownable {
381   event Mint(address indexed to, uint256 amount);
382   event MintFinished();
383 
384   bool public mintingFinished = false;
385 
386 
387   modifier canMint() {
388     require(!mintingFinished);
389     _;
390   }
391 
392   /**
393    * @dev Function to mint tokens
394    * @param _to The address that will receive the minted tokens.
395    * @param _amount The amount of tokens to mint.
396    * @return A boolean that indicates if the operation was successful.
397    */
398   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
399     totalSupply = totalSupply.add(_amount);
400     balances[_to] = balances[_to].add(_amount);
401     Mint(_to, _amount);
402     Transfer(address(0), _to, _amount);
403     return true;
404   }
405 
406   /**
407    * @dev Function to stop minting new tokens.
408    * @return True if the operation was successful.
409    */
410   function finishMinting() onlyOwner canMint public returns (bool) {
411     mintingFinished = true;
412     MintFinished();
413     return true;
414   }
415 }
416 
417 
418 /**
419  * @title SafeERC20
420  * @dev Wrappers around ERC20 operations that throw on failure.
421  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
422  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
423  */
424 library SafeERC20 {
425   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
426     assert(token.transfer(to, value));
427   }
428 
429   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
430     assert(token.transferFrom(from, to, value));
431   }
432 
433   function safeApprove(ERC20 token, address spender, uint256 value) internal {
434     assert(token.approve(spender, value));
435   }
436 }
437 
438 
439 
440 contract VITToken is Claimable, HasNoTokens, MintableToken {
441     // solhint-disable const-name-snakecase
442     string public constant name = "Vice";
443     string public constant symbol = "VIT";
444     uint8 public constant decimals = 18;
445     // solhint-enable const-name-snakecase
446 
447     modifier cannotMint() {
448         require(mintingFinished);
449         _;
450     }
451 
452     function VITToken() public {
453 
454     }
455 
456     /// @dev Same ERC20 behavior, but reverts if still minting.
457     /// @param _to address The address to transfer to.
458     /// @param _value uint256 The amount to be transferred.
459     function transfer(address _to, uint256 _value) public cannotMint returns (bool) {
460         return super.transfer(_to, _value);
461     }
462 
463     /// @dev Same ERC20 behavior, but reverts if still minting.
464     /// @param _from address The address which you want to send tokens from.
465     /// @param _to address The address which you want to transfer to.
466     /// @param _value uint256 the amount of tokens to be transferred.
467     function transferFrom(address _from, address _to, uint256 _value) public cannotMint returns (bool) {
468         return super.transferFrom(_from, _to, _value);
469     }
470 }
471 
472 
473 
474 
475 /// @title VITToken sale contract.
476 contract VITTokenSale is Claimable {
477     using Math for uint256;
478     using SafeMath for uint256;
479 
480     // VIT token contract.
481     VITToken public vitToken;
482 
483     // Received funds are forwarded to this address.
484     address public fundingRecipient;
485 
486     // VIT token unit.
487     uint256 public constant TOKEN_UNIT = 10 ** 18;
488 
489     // Maximum tokens offered in the sale: 2B.
490     uint256 public constant MAX_TOKENS_SOLD = 2 * 10 ** 9 * TOKEN_UNIT;
491 
492     // VIT to 1 wei ratio.
493     uint256 public vitPerWei;
494 
495     // Sale start and end timestamps.
496     uint256 public constant RESTRICTED_PERIOD_DURATION = 1 days;
497     uint256 public startTime;
498     uint256 public endTime;
499 
500     // Refund data and state.
501     uint256 public refundEndTime;
502     mapping (address => uint256) public refundableEther;
503     mapping (address => uint256) public claimableTokens;
504     uint256 public totalClaimableTokens = 0;
505     bool public finalizedRefund = false;
506 
507     // Amount of tokens sold until now in the sale.
508     uint256 public tokensSold = 0;
509 
510     // Accumulated amount each participant has contributed so far.
511     mapping (address => uint256) public participationHistory;
512 
513     // Maximum amount that each participant is allowed to contribute (in WEI), during the restricted period.
514     mapping (address => uint256) public participationCaps;
515 
516     // Initial allocations.
517     address[20] public strategicPartnersPools;
518     uint256 public constant STRATEGIC_PARTNERS_POOL_ALLOCATION = 100 * 10 ** 6 * TOKEN_UNIT; // 100M
519 
520     event TokensIssued(address indexed to, uint256 tokens);
521     event EtherRefunded(address indexed from, uint256 weiAmount);
522     event TokensClaimed(address indexed from, uint256 tokens);
523     event Finalized();
524     event FinalizedRefunds();
525 
526     /// @dev Reverts if called when not during sale.
527     modifier onlyDuringSale() {
528         require(!saleEnded() && now >= startTime);
529 
530         _;
531     }
532 
533     /// @dev Reverts if called before the sale ends.
534     modifier onlyAfterSale() {
535         require(saleEnded());
536 
537         _;
538     }
539 
540     /// @dev Reverts if called not doing the refund period.
541     modifier onlyDuringRefund() {
542         require(saleDuringRefundPeriod());
543 
544         _;
545     }
546 
547     modifier onlyAfterRefund() {
548         require(saleAfterRefundPeriod());
549 
550         _;
551     }
552 
553     /// @dev Constructor that initializes the sale conditions.
554     /// @param _fundingRecipient address The address of the funding recipient.
555     /// @param _startTime uint256 The start time of the token sale.
556     /// @param _endTime uint256 The end time of the token sale.
557     /// @param _refundEndTime uint256 The end time of the refunding period.
558     /// @param _vitPerWei uint256 The exchange rate of VIT for one ETH.
559     /// @param _strategicPartnersPools address[20] The addresses of the 20 strategic partners pools.
560     function VITTokenSale(address _fundingRecipient, uint256 _startTime, uint256 _endTime, uint256 _refundEndTime,
561         uint256 _vitPerWei, address[20] _strategicPartnersPools) public {
562         require(_fundingRecipient != address(0));
563         require(_startTime > now && _startTime < _endTime && _endTime < _refundEndTime);
564         require(_startTime.add(RESTRICTED_PERIOD_DURATION) < _endTime);
565         require(_vitPerWei > 0);
566 
567         for (uint i = 0; i < _strategicPartnersPools.length; ++i) {
568             require(_strategicPartnersPools[i] != address(0));
569         }
570 
571         fundingRecipient = _fundingRecipient;
572         startTime = _startTime;
573         endTime = _endTime;
574         refundEndTime = _refundEndTime;
575         vitPerWei = _vitPerWei;
576         strategicPartnersPools = _strategicPartnersPools;
577 
578         // Deploy new VITToken contract.
579         vitToken = new VITToken();
580 
581         // Grant initial token allocations.
582         grantInitialAllocations();
583     }
584 
585     /// @dev Fallback function that will delegate the request to create().
586     function () external payable onlyDuringSale {
587         address recipient = msg.sender;
588 
589         uint256 cappedWeiReceived = msg.value;
590         uint256 weiAlreadyParticipated = participationHistory[recipient];
591 
592         // If we're during the restricted period, then only the white-listed participants are allowed to participate,
593         if (saleDuringRestrictedPeriod()) {
594             uint256 participationCap = participationCaps[recipient];
595             cappedWeiReceived = Math.min256(cappedWeiReceived, participationCap.sub(weiAlreadyParticipated));
596         }
597 
598         require(cappedWeiReceived > 0);
599 
600         // Calculate how much tokens can be sold to this participant.
601         uint256 tokensLeftInSale = MAX_TOKENS_SOLD.sub(tokensSold);
602         uint256 weiLeftInSale = tokensLeftInSale.div(vitPerWei);
603         uint256 weiToParticipate = Math.min256(cappedWeiReceived, weiLeftInSale);
604         participationHistory[recipient] = weiAlreadyParticipated.add(weiToParticipate);
605 
606         // Issue tokens and transfer to recipient.
607         uint256 tokensToIssue = weiToParticipate.mul(vitPerWei);
608         if (tokensLeftInSale.sub(tokensToIssue) < vitPerWei) {
609             // If purchase would cause less than vitPerWei tokens left then nobody could ever buy them, so we'll gift
610             // them to the last buyer.
611             tokensToIssue = tokensLeftInSale;
612         }
613 
614         // Record the both the participate ETH and tokens for future refunds.
615         refundableEther[recipient] = refundableEther[recipient].add(weiToParticipate);
616         claimableTokens[recipient] = claimableTokens[recipient].add(tokensToIssue);
617 
618         // Update token counters.
619         totalClaimableTokens = totalClaimableTokens.add(tokensToIssue);
620         tokensSold = tokensSold.add(tokensToIssue);
621 
622         // Issue the tokens to the token sale smart contract itself, which will hold them for future refunds.
623         issueTokens(address(this), tokensToIssue);
624 
625         // Partial refund if full participation not possible, e.g. due to cap being reached.
626         uint256 refund = msg.value.sub(weiToParticipate);
627         if (refund > 0) {
628             msg.sender.transfer(refund);
629         }
630     }
631 
632     /// @dev Set restricted period participation caps for a list of addresses.
633     /// @param _participants address[] The list of participant addresses.
634     /// @param _cap uint256 The cap amount (in ETH).
635     function setRestrictedParticipationCap(address[] _participants, uint256 _cap) external onlyOwner {
636         for (uint i = 0; i < _participants.length; ++i) {
637             participationCaps[_participants[i]] = _cap;
638         }
639     }
640 
641     /// @dev Finalizes the token sale event, by stopping token minting.
642     function finalize() external onlyAfterSale {
643         // Issue any unsold tokens back to the company.
644         if (tokensSold < MAX_TOKENS_SOLD) {
645             issueTokens(fundingRecipient, MAX_TOKENS_SOLD.sub(tokensSold));
646         }
647 
648         // Finish minting. Please note, that if minting was already finished - this call will revert().
649         vitToken.finishMinting();
650 
651         Finalized();
652     }
653 
654     function finalizeRefunds() external onlyAfterRefund {
655         require(!finalizedRefund);
656 
657         finalizedRefund = true;
658 
659         // Transfer all the Ether to the beneficiary of the funding.
660         fundingRecipient.transfer(this.balance);
661 
662         FinalizedRefunds();
663     }
664 
665     /// @dev Reclaim all ERC20 compatible tokens, but not more than the VIT tokens which were reserved for refunds.
666     /// @param token ERC20Basic The address of the token contract.
667     function reclaimToken(ERC20Basic token) external onlyOwner {
668         uint256 balance = token.balanceOf(this);
669         if (token == vitToken) {
670             balance = balance.sub(totalClaimableTokens);
671         }
672 
673         assert(token.transfer(owner, balance));
674     }
675 
676     /// @dev Allows participants to claim their tokens, which also transfers the Ether to the funding recipient.
677     /// @param _tokensToClaim uint256 The amount of tokens to claim.
678     function claimTokens(uint256 _tokensToClaim) public onlyAfterSale {
679         require(_tokensToClaim != 0);
680 
681         address participant = msg.sender;
682         require(claimableTokens[participant] > 0);
683 
684         uint256 claimableTokensAmount = claimableTokens[participant];
685         require(_tokensToClaim <= claimableTokensAmount);
686 
687         uint256 refundableEtherAmount = refundableEther[participant];
688         uint256 etherToClaim = _tokensToClaim.mul(refundableEtherAmount).div(claimableTokensAmount);
689         assert(etherToClaim > 0);
690 
691         refundableEther[participant] = refundableEtherAmount.sub(etherToClaim);
692         claimableTokens[participant] = claimableTokensAmount.sub(_tokensToClaim);
693         totalClaimableTokens = totalClaimableTokens.sub(_tokensToClaim);
694 
695         // Transfer the tokens from the token sale smart contract to the participant.
696         assert(vitToken.transfer(participant, _tokensToClaim));
697 
698         // Transfer the Ether to the beneficiary of the funding (as long as the refund hasn't finalized yet).
699         if (!finalizedRefund) {
700             fundingRecipient.transfer(etherToClaim);
701         }
702 
703         TokensClaimed(participant, _tokensToClaim);
704     }
705 
706     /// @dev Allows participants to claim all their tokens.
707     function claimAllTokens() public onlyAfterSale {
708         uint256 claimableTokensAmount = claimableTokens[msg.sender];
709         claimTokens(claimableTokensAmount);
710     }
711 
712     /// @dev Allows participants to claim refund for their purchased tokens.
713     /// @param _etherToClaim uint256 The amount of Ether to claim.
714     function refundEther(uint256 _etherToClaim) public onlyDuringRefund {
715         require(_etherToClaim != 0);
716 
717         address participant = msg.sender;
718 
719         uint256 refundableEtherAmount = refundableEther[participant];
720         require(_etherToClaim <= refundableEtherAmount);
721 
722         uint256 claimableTokensAmount = claimableTokens[participant];
723         uint256 tokensToClaim = _etherToClaim.mul(claimableTokensAmount).div(refundableEtherAmount);
724         assert(tokensToClaim > 0);
725 
726         refundableEther[participant] = refundableEtherAmount.sub(_etherToClaim);
727         claimableTokens[participant] = claimableTokensAmount.sub(tokensToClaim);
728         totalClaimableTokens = totalClaimableTokens.sub(tokensToClaim);
729 
730         // Transfer the tokens to the beneficiary of the funding.
731         assert(vitToken.transfer(fundingRecipient, tokensToClaim));
732 
733         // Transfer the Ether to the participant.
734         participant.transfer(_etherToClaim);
735 
736         EtherRefunded(participant, _etherToClaim);
737     }
738 
739     /// @dev Allows participants to claim refund for all their purchased tokens.
740     function refundAllEther() public onlyDuringRefund {
741         uint256 refundableEtherAmount = refundableEther[msg.sender];
742         refundEther(refundableEtherAmount);
743     }
744 
745     /// @dev Initialize token grants.
746     function grantInitialAllocations() private onlyOwner {
747         for (uint i = 0; i < strategicPartnersPools.length; ++i) {
748             issueTokens(strategicPartnersPools[i], STRATEGIC_PARTNERS_POOL_ALLOCATION);
749         }
750     }
751 
752     /// @dev Issues tokens for the recipient.
753     /// @param _recipient address The address of the recipient.
754     /// @param _tokens uint256 The amount of tokens to issue.
755     function issueTokens(address _recipient, uint256 _tokens) private {
756         // Request VIT token contract to mint the requested tokens for the buyer.
757         assert(vitToken.mint(_recipient, _tokens));
758 
759         TokensIssued(_recipient, _tokens);
760     }
761 
762     /// @dev Returns whether the sale has ended.
763     /// @return bool Whether the sale has ended or not.
764     function saleEnded() private view returns (bool) {
765         return tokensSold >= MAX_TOKENS_SOLD || now >= endTime;
766     }
767 
768     /// @dev Returns whether the sale is during its restricted period, where only white-listed participants are allowed
769     /// to participate.
770     /// @return bool Whether the sale is during its restricted period, where only white-listed participants are allowed
771     /// to participate.
772     function saleDuringRestrictedPeriod() private view returns (bool) {
773         return now <= startTime.add(RESTRICTED_PERIOD_DURATION);
774     }
775 
776     /// @dev Returns whether the sale is during its refund period.
777     /// @return bool whether the sale is during its refund period.
778     function saleDuringRefundPeriod() private view returns (bool) {
779         return saleEnded() && now <= refundEndTime;
780     }
781 
782     /// @dev Returns whether the sale is during its refund period.
783     /// @return bool whether the sale is during its refund period.
784     function saleAfterRefundPeriod() private view returns (bool) {
785         return saleEnded() && now > refundEndTime;
786     }
787 }