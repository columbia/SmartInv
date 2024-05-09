1 pragma solidity ^0.5.16;
2 
3 
4 // Copied from compound/EIP20Interface
5 /**
6  * @title ERC 20 Token Standard Interface
7  *  https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface EIP20Interface {
10     function name() external view returns (string memory);
11     function symbol() external view returns (string memory);
12     function decimals() external view returns (uint8);
13 
14     /**
15       * @notice Get the total number of tokens in circulation
16       * @return The supply of tokens
17       */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @notice Gets the balance of the specified address
22      * @param owner The address from which the balance will be retrieved
23      * @return The balance
24      */
25     function balanceOf(address owner) external view returns (uint256 balance);
26 
27     /**
28       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
29       * @param dst The address of the destination account
30       * @param amount The number of tokens to transfer
31       * @return Whether or not the transfer succeeded
32       */
33     function transfer(address dst, uint256 amount) external returns (bool success);
34 
35     /**
36       * @notice Transfer `amount` tokens from `src` to `dst`
37       * @param src The address of the source account
38       * @param dst The address of the destination account
39       * @param amount The number of tokens to transfer
40       * @return Whether or not the transfer succeeded
41       */
42     function transferFrom(address src, address dst, uint256 amount) external returns (bool success);
43 
44     /**
45       * @notice Approve `spender` to transfer up to `amount` from `src`
46       * @dev This will overwrite the approval amount for `spender`
47       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
48       * @param spender The address of the account which may transfer tokens
49       * @param amount The number of tokens that are approved (-1 means infinite)
50       * @return Whether or not the approval succeeded
51       */
52     function approve(address spender, uint256 amount) external returns (bool success);
53 
54     /**
55       * @notice Get the current allowance from `owner` for `spender`
56       * @param owner The address of the account which owns the tokens to be spent
57       * @param spender The address of the account which may transfer tokens
58       * @return The number of tokens allowed to be spent (-1 means infinite)
59       */
60     function allowance(address owner, address spender) external view returns (uint256 remaining);
61 
62     event Transfer(address indexed from, address indexed to, uint256 amount);
63     event Approval(address indexed owner, address indexed spender, uint256 amount);
64 }
65 
66 // Copied from compound/EIP20NonStandardInterface
67 /**
68  * @title EIP20NonStandardInterface
69  * @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
70  *  See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
71  */
72 interface EIP20NonStandardInterface {
73 
74     /**
75      * @notice Get the total number of tokens in circulation
76      * @return The supply of tokens
77      */
78     function totalSupply() external view returns (uint256);
79 
80     /**
81      * @notice Gets the balance of the specified address
82      * @param owner The address from which the balance will be retrieved
83      * @return The balance
84      */
85     function balanceOf(address owner) external view returns (uint256 balance);
86 
87     ///
88     /// !!!!!!!!!!!!!!
89     /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
90     /// !!!!!!!!!!!!!!
91     ///
92 
93     /**
94       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
95       * @param dst The address of the destination account
96       * @param amount The number of tokens to transfer
97       */
98     function transfer(address dst, uint256 amount) external;
99 
100     ///
101     /// !!!!!!!!!!!!!!
102     /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
103     /// !!!!!!!!!!!!!!
104     ///
105 
106     /**
107       * @notice Transfer `amount` tokens from `src` to `dst`
108       * @param src The address of the source account
109       * @param dst The address of the destination account
110       * @param amount The number of tokens to transfer
111       */
112     function transferFrom(address src, address dst, uint256 amount) external;
113 
114     /**
115       * @notice Approve `spender` to transfer up to `amount` from `src`
116       * @dev This will overwrite the approval amount for `spender`
117       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
118       * @param spender The address of the account which may transfer tokens
119       * @param amount The number of tokens that are approved
120       * @return Whether or not the approval succeeded
121       */
122     function approve(address spender, uint256 amount) external returns (bool success);
123 
124     /**
125       * @notice Get the current allowance from `owner` for `spender`
126       * @param owner The address of the account which owns the tokens to be spent
127       * @param spender The address of the account which may transfer tokens
128       * @return The number of tokens allowed to be spent
129       */
130     function allowance(address owner, address spender) external view returns (uint256 remaining);
131 
132     event Transfer(address indexed from, address indexed to, uint256 amount);
133     event Approval(address indexed owner, address indexed spender, uint256 amount);
134 }
135 
136 // Copied from Compound/ExponentialNoError
137 /**
138  * @title Exponential module for storing fixed-precision decimals
139  * @author DeFil
140  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
141  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
142  *         `Exp({mantissa: 5100000000000000000})`.
143  */
144 contract ExponentialNoError {
145     uint constant expScale = 1e18;
146     uint constant doubleScale = 1e36;
147     uint constant halfExpScale = expScale/2;
148     uint constant mantissaOne = expScale;
149 
150     struct Exp {
151         uint mantissa;
152     }
153 
154     struct Double {
155         uint mantissa;
156     }
157 
158     /**
159      * @dev Truncates the given exp to a whole number value.
160      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
161      */
162     function truncate(Exp memory exp) pure internal returns (uint) {
163         // Note: We are not using careful math here as we're performing a division that cannot fail
164         return exp.mantissa / expScale;
165     }
166 
167     /**
168      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
169      */
170     function mul_ScalarTruncate(Exp memory a, uint scalar) pure internal returns (uint) {
171         Exp memory product = mul_(a, scalar);
172         return truncate(product);
173     }
174 
175     /**
176      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
177      */
178     function mul_ScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (uint) {
179         Exp memory product = mul_(a, scalar);
180         return add_(truncate(product), addend);
181     }
182 
183     /**
184      * @dev Checks if first Exp is less than second Exp.
185      */
186     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
187         return left.mantissa < right.mantissa;
188     }
189 
190     /**
191      * @dev Checks if left Exp <= right Exp.
192      */
193     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
194         return left.mantissa <= right.mantissa;
195     }
196 
197     /**
198      * @dev Checks if left Exp > right Exp.
199      */
200     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
201         return left.mantissa > right.mantissa;
202     }
203 
204     /**
205      * @dev returns true if Exp is exactly zero
206      */
207     function isZeroExp(Exp memory value) pure internal returns (bool) {
208         return value.mantissa == 0;
209     }
210 
211     function safe224(uint n, string memory errorMessage) pure internal returns (uint224) {
212         require(n < 2**224, errorMessage);
213         return uint224(n);
214     }
215 
216     function safe32(uint n, string memory errorMessage) pure internal returns (uint32) {
217         require(n < 2**32, errorMessage);
218         return uint32(n);
219     }
220 
221     function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
222         return Exp({mantissa: add_(a.mantissa, b.mantissa)});
223     }
224 
225     function add_(Double memory a, Double memory b) pure internal returns (Double memory) {
226         return Double({mantissa: add_(a.mantissa, b.mantissa)});
227     }
228 
229     function add_(uint a, uint b) pure internal returns (uint) {
230         return add_(a, b, "addition overflow");
231     }
232 
233     function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
234         uint c = a + b;
235         require(c >= a, errorMessage);
236         return c;
237     }
238 
239     function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
240         return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
241     }
242 
243     function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {
244         return Double({mantissa: sub_(a.mantissa, b.mantissa)});
245     }
246 
247     function sub_(uint a, uint b) pure internal returns (uint) {
248         return sub_(a, b, "subtraction underflow");
249     }
250 
251     function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
252         require(b <= a, errorMessage);
253         return a - b;
254     }
255 
256     function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
257         return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
258     }
259 
260     function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {
261         return Exp({mantissa: mul_(a.mantissa, b)});
262     }
263 
264     function mul_(uint a, Exp memory b) pure internal returns (uint) {
265         return mul_(a, b.mantissa) / expScale;
266     }
267 
268     function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {
269         return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
270     }
271 
272     function mul_(Double memory a, uint b) pure internal returns (Double memory) {
273         return Double({mantissa: mul_(a.mantissa, b)});
274     }
275 
276     function mul_(uint a, Double memory b) pure internal returns (uint) {
277         return mul_(a, b.mantissa) / doubleScale;
278     }
279 
280     function mul_(uint a, uint b) pure internal returns (uint) {
281         return mul_(a, b, "multiplication overflow");
282     }
283 
284     function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
285         if (a == 0 || b == 0) {
286             return 0;
287         }
288         uint c = a * b;
289         require(c / a == b, errorMessage);
290         return c;
291     }
292 
293     function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
294         return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
295     }
296 
297     function div_(Exp memory a, uint b) pure internal returns (Exp memory) {
298         return Exp({mantissa: div_(a.mantissa, b)});
299     }
300 
301     function div_(uint a, Exp memory b) pure internal returns (uint) {
302         return div_(mul_(a, expScale), b.mantissa);
303     }
304 
305     function div_(Double memory a, Double memory b) pure internal returns (Double memory) {
306         return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
307     }
308 
309     function div_(Double memory a, uint b) pure internal returns (Double memory) {
310         return Double({mantissa: div_(a.mantissa, b)});
311     }
312 
313     function div_(uint a, Double memory b) pure internal returns (uint) {
314         return div_(mul_(a, doubleScale), b.mantissa);
315     }
316 
317     function div_(uint a, uint b) pure internal returns (uint) {
318         return div_(a, b, "divide by zero");
319     }
320 
321     function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
322         require(b > 0, errorMessage);
323         return a / b;
324     }
325 
326     function fraction(uint a, uint b) pure internal returns (Double memory) {
327         return Double({mantissa: div_(mul_(a, doubleScale), b)});
328     }
329 }
330 
331 interface Distributor {
332     // The asset to be distributed
333     function asset() external view returns (address);
334 
335     // Return the accrued amount of account based on stored data
336     function accruedStored(address account) external view returns (uint);
337 
338     // Accrue and distribute for caller, but not actually transfer assets to the caller
339     // returns the new accrued amount
340     function accrue() external returns (uint);
341 
342     // Claim asset, transfer the given amount assets to receiver
343     function claim(address receiver, uint amount) external returns (uint);
344 }
345 
346 contract Redistributor is Distributor, ExponentialNoError {
347     /**
348      * @notice The superior Distributor contract
349      */
350     Distributor public superior;
351 
352     // The accrued amount of this address in superior Distributor
353     uint public superiorAccruedAmount;
354 
355     // The initial accrual index
356     uint internal constant initialAccruedIndex = 1e36;
357 
358     // The last accrued block number
359     uint public accrualBlockNumber;
360 
361     // The last accrued index
362     uint public globalAccruedIndex;
363 
364     // Total count of shares.
365     uint internal totalShares;
366 
367     struct AccountState {
368         /// @notice The share of account
369         uint share;
370         // The last accrued index of account
371         uint accruedIndex;
372         /// @notice The accrued but not yet transferred to account
373         uint accruedAmount;
374     }
375 
376     // The AccountState for each account
377     mapping(address => AccountState) internal accountStates;
378 
379     /*** Events ***/
380     // Emitted when dfl is accrued
381     event Accrued(uint amount, uint globalAccruedIndex);
382 
383     // Emitted when distribute to a account
384     event Distributed(address account, uint amount, uint accruedIndex);
385 
386     // Emitted when account claims asset
387     event Claimed(address account, address receiver, uint amount);
388 
389     // Emitted when account transfer asset
390     event Transferred(address from, address to, uint amount);
391 
392     constructor(Distributor superior_) public {
393         // set superior
394         superior = superior_;
395         // init accrued index
396         globalAccruedIndex = initialAccruedIndex;
397     }
398 
399     function asset() external view returns (address) {
400         return superior.asset();
401     }
402 
403     // Return the accrued amount of account based on stored data
404     function accruedStored(address account) external view returns(uint) {
405         uint storedGlobalAccruedIndex;
406         if (totalShares == 0) {
407             storedGlobalAccruedIndex = globalAccruedIndex;
408         } else {
409             uint superiorAccruedStored = superior.accruedStored(address(this));
410             uint delta = sub_(superiorAccruedStored, superiorAccruedAmount);
411 
412             Double memory ratio = fraction(delta, totalShares);
413             Double memory doubleGlobalAccruedIndex = add_(Double({mantissa: globalAccruedIndex}), ratio);
414             storedGlobalAccruedIndex = doubleGlobalAccruedIndex.mantissa;
415         }
416 
417         (, uint instantAccountAccruedAmount) = accruedStoredInternal(account, storedGlobalAccruedIndex);
418         return instantAccountAccruedAmount;
419     }
420 
421     // Return the accrued amount of account based on stored data
422     function accruedStoredInternal(address account, uint withGlobalAccruedIndex) internal view returns(uint, uint) {
423         AccountState memory state = accountStates[account];
424 
425         Double memory doubleGlobalAccruedIndex = Double({mantissa: withGlobalAccruedIndex});
426         Double memory doubleAccountAccruedIndex = Double({mantissa: state.accruedIndex});
427         if (doubleAccountAccruedIndex.mantissa == 0 && doubleGlobalAccruedIndex.mantissa > 0) {
428             doubleAccountAccruedIndex.mantissa = initialAccruedIndex;
429         }
430 
431         Double memory deltaIndex = sub_(doubleGlobalAccruedIndex, doubleAccountAccruedIndex);
432         uint delta = mul_(state.share, deltaIndex);
433 
434         return (delta, add_(state.accruedAmount, delta));
435     }
436 
437     function accrueInternal() internal {
438         uint blockNumber = getBlockNumber();
439         if (accrualBlockNumber == blockNumber) {
440             return;
441         }
442 
443         uint newSuperiorAccruedAmount = superior.accrue();
444         if (totalShares == 0) {
445             accrualBlockNumber = blockNumber;
446             return;
447         }
448 
449         uint delta = sub_(newSuperiorAccruedAmount, superiorAccruedAmount);
450 
451         Double memory ratio = fraction(delta, totalShares);
452         Double memory doubleAccruedIndex = add_(Double({mantissa: globalAccruedIndex}), ratio);
453 
454         // update globalAccruedIndex
455         globalAccruedIndex = doubleAccruedIndex.mantissa;
456         superiorAccruedAmount = newSuperiorAccruedAmount;
457         accrualBlockNumber = blockNumber;
458 
459         emit Accrued(delta, doubleAccruedIndex.mantissa);
460     }
461 
462     /**
463      * @notice accrue and returns accrued stored of msg.sender
464      */
465     function accrue() external returns (uint) {
466         accrueInternal();
467 
468         (, uint instantAccountAccruedAmount) = accruedStoredInternal(msg.sender, globalAccruedIndex);
469         return instantAccountAccruedAmount;
470     }
471 
472     function distributeInternal(address account) internal {
473         (uint delta, uint instantAccruedAmount) = accruedStoredInternal(account, globalAccruedIndex);
474 
475         AccountState storage state = accountStates[account];
476         state.accruedIndex = globalAccruedIndex;
477         state.accruedAmount = instantAccruedAmount;
478 
479         // emit Distributed event
480         emit Distributed(account, delta, globalAccruedIndex);
481     }
482 
483     function claim(address receiver, uint amount) external returns (uint) {
484         address account = msg.sender;
485 
486         // keep fresh
487         accrueInternal();
488         distributeInternal(account);
489 
490         AccountState storage state = accountStates[account];
491         require(amount <= state.accruedAmount, "claim: insufficient value");
492 
493         // claim from superior
494         require(superior.claim(receiver, amount) == amount, "claim: amount mismatch");
495 
496         // update storage
497         state.accruedAmount = sub_(state.accruedAmount, amount);
498         superiorAccruedAmount = sub_(superiorAccruedAmount, amount);
499 
500         emit Claimed(account, receiver, amount);
501 
502         return amount;
503     }
504 
505     function claimAll() external {
506         address account = msg.sender;
507 
508         // accrue and distribute
509         accrueInternal();
510         distributeInternal(account);
511 
512         AccountState storage state = accountStates[account];
513         uint amount = state.accruedAmount;
514 
515         // claim from superior
516         require(superior.claim(account, amount) == amount, "claim: amount mismatch");
517 
518         // update storage
519         state.accruedAmount = 0;
520         superiorAccruedAmount = sub_(superiorAccruedAmount, amount);
521 
522         emit Claimed(account, account, amount);
523     }
524 
525     function transfer(address to, uint amount) external {
526         address from = msg.sender;
527 
528         // keep fresh
529         accrueInternal();
530         distributeInternal(from);
531 
532         AccountState storage fromState = accountStates[from];
533         uint actualAmount = amount;
534         if (actualAmount == 0) {
535             actualAmount = fromState.accruedAmount;
536         }
537         require(fromState.accruedAmount >= actualAmount, "transfer: insufficient value");
538 
539         AccountState storage toState = accountStates[to];
540 
541         // update storage
542         fromState.accruedAmount = sub_(fromState.accruedAmount, actualAmount);
543         toState.accruedAmount = add_(toState.accruedAmount, actualAmount);
544 
545         emit Transferred(from, to, actualAmount);
546     }
547 
548     function getBlockNumber() public view returns (uint) {
549         return block.number;
550     }
551 }
552 
553 contract Staking is Redistributor {
554     // The token to deposit
555     address public property;
556 
557     /*** Events ***/
558     // Event emitted when new property tokens is deposited
559     event Deposit(address account, uint amount);
560 
561     // Event emitted when new property tokens is withdrawed
562     event Withdraw(address account, uint amount);
563 
564     constructor(address property_, Distributor superior_) Redistributor(superior_) public {
565         property = property_;
566     }
567 
568     function totalDeposits() external view returns (uint) {
569         return totalShares;
570     }
571 
572     function accountState(address account) external view returns (uint, uint, uint) {
573         AccountState memory state = accountStates[account];
574         return (state.share, state.accruedIndex, state.accruedAmount);
575     }
576 
577     // Deposit property tokens
578     function deposit(uint amount) external returns (uint) {
579         address account = msg.sender;
580 
581         // accrue & distribute
582         accrueInternal();
583         distributeInternal(account);
584 
585         // transfer property token in
586         uint actualAmount = doTransferIn(account, amount);
587 
588         // update storage
589         AccountState storage state = accountStates[account];
590         totalShares = add_(totalShares, actualAmount);
591         state.share = add_(state.share, actualAmount);
592 
593         emit Deposit(account, actualAmount);
594 
595         return actualAmount;
596     }
597 
598     // Withdraw property tokens
599     function withdraw(uint amount) external returns (uint) {
600         address account = msg.sender;
601         AccountState storage state = accountStates[account];
602         require(state.share >= amount, "withdraw: insufficient value");
603 
604         // accrue & distribute
605         accrueInternal();
606         distributeInternal(account);
607 
608         // decrease total deposits
609         totalShares = sub_(totalShares, amount);
610         state.share = sub_(state.share, amount);
611 
612         // transfer property tokens back to account
613         doTransferOut(account, amount);
614 
615         emit Withdraw(account, amount);
616 
617         return amount;
618     }
619 
620     /*** Safe Token ***/
621 
622     /**
623      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and reverts in that case.
624      *      This will revert due to insufficient balance or insufficient allowance.
625      *      This function returns the actual amount received,
626      *      which may be less than `amount` if there is a fee attached to the transfer.
627      *
628      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
629      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
630      */
631     function doTransferIn(address from, uint amount) internal returns (uint) {
632         EIP20NonStandardInterface token = EIP20NonStandardInterface(property);
633         uint balanceBefore = EIP20Interface(property).balanceOf(address(this));
634         token.transferFrom(from, address(this), amount);
635 
636         bool success;
637         assembly {
638             switch returndatasize()
639                 case 0 {                       // This is a non-standard ERC-20
640                     success := not(0)          // set success to true
641                 }
642                 case 32 {                      // This is a compliant ERC-20
643                     returndatacopy(0, 0, 32)
644                     success := mload(0)        // Set `success = returndata` of external call
645                 }
646                 default {                      // This is an excessively non-compliant ERC-20, revert.
647                     revert(0, 0)
648                 }
649         }
650         require(success, "TOKEN_TRANSFER_IN_FAILED");
651 
652         // Calculate the amount that was *actually* transferred
653         uint balanceAfter = EIP20Interface(property).balanceOf(address(this));
654         require(balanceAfter >= balanceBefore, "TOKEN_TRANSFER_IN_OVERFLOW");
655         return balanceAfter - balanceBefore;   // underflow already checked above, just subtract
656     }
657 
658     /**
659      * @dev Similar to EIP20 transfer, except it handles a False success from `transfer` and returns an explanatory
660      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
661      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
662      *      it is >= amount, this should not revert in normal conditions.
663      *
664      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
665      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
666      */
667     function doTransferOut(address to, uint amount) internal {
668         EIP20NonStandardInterface token = EIP20NonStandardInterface(property);
669         token.transfer(to, amount);
670 
671         bool success;
672         assembly {
673             switch returndatasize()
674                 case 0 {                      // This is a non-standard ERC-20
675                     success := not(0)          // set success to true
676                 }
677                 case 32 {                     // This is a complaint ERC-20
678                     returndatacopy(0, 0, 32)
679                     success := mload(0)        // Set `success = returndata` of external call
680                 }
681                 default {                     // This is an excessively non-compliant ERC-20, revert.
682                     revert(0, 0)
683                 }
684         }
685         require(success, "TOKEN_TRANSFER_OUT_FAILED");
686     }
687 }