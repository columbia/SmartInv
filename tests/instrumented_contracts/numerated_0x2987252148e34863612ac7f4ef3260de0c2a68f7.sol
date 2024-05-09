1 /*
2 
3 ⚠⚠⚠ WARNING WARNING WARNING ⚠⚠⚠
4 
5 This is a TARGET contract - DO NOT CONNECT TO IT DIRECTLY IN YOUR CONTRACTS or DAPPS!
6 
7 This contract has an associated PROXY that MUST be used for all integrations - this TARGET will be REPLACED in an upcoming Synthetix release!
8 The proxy for this contract can be found here:
9 
10 https://contracts.synthetix.io/ProxyERC20
11 
12 *//*
13    ____            __   __        __   _
14   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
15  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
16 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
17      /___/
18 
19 * Synthetix: Synthetix.sol
20 *
21 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/Synthetix.sol
22 * Docs: https://docs.synthetix.io/contracts/Synthetix
23 *
24 * Contract Dependencies: 
25 *	- ExternStateToken
26 *	- MixinResolver
27 *	- Owned
28 *	- Proxyable
29 *	- SelfDestructible
30 *	- State
31 * Libraries: 
32 *	- Math
33 *	- SafeDecimalMath
34 *	- SafeMath
35 *
36 * MIT License
37 * ===========
38 *
39 * Copyright (c) 2020 Synthetix
40 *
41 * Permission is hereby granted, free of charge, to any person obtaining a copy
42 * of this software and associated documentation files (the "Software"), to deal
43 * in the Software without restriction, including without limitation the rights
44 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
45 * copies of the Software, and to permit persons to whom the Software is
46 * furnished to do so, subject to the following conditions:
47 *
48 * The above copyright notice and this permission notice shall be included in all
49 * copies or substantial portions of the Software.
50 *
51 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
52 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
53 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
54 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
55 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
56 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
57 */
58 
59 /* ===============================================
60 * Flattened with Solidifier by Coinage
61 * 
62 * https://solidifier.coina.ge
63 * ===============================================
64 */
65 
66 
67 pragma solidity ^0.4.24;
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that revert on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, reverts on overflow.
77   */
78   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (a == 0) {
83       return 0;
84     }
85 
86     uint256 c = a * b;
87     require(c / a == b);
88 
89     return c;
90   }
91 
92   /**
93   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
94   */
95   function div(uint256 a, uint256 b) internal pure returns (uint256) {
96     require(b > 0); // Solidity only automatically asserts when dividing by 0
97     uint256 c = a / b;
98     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99 
100     return c;
101   }
102 
103   /**
104   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
105   */
106   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107     require(b <= a);
108     uint256 c = a - b;
109 
110     return c;
111   }
112 
113   /**
114   * @dev Adds two numbers, reverts on overflow.
115   */
116   function add(uint256 a, uint256 b) internal pure returns (uint256) {
117     uint256 c = a + b;
118     require(c >= a);
119 
120     return c;
121   }
122 
123   /**
124   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
125   * reverts when dividing by zero.
126   */
127   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
128     require(b != 0);
129     return a % b;
130   }
131 }
132 
133 
134 // https://docs.synthetix.io/contracts/SafeDecimalMath
135 library SafeDecimalMath {
136     using SafeMath for uint;
137 
138     /* Number of decimal places in the representations. */
139     uint8 public constant decimals = 18;
140     uint8 public constant highPrecisionDecimals = 27;
141 
142     /* The number representing 1.0. */
143     uint public constant UNIT = 10**uint(decimals);
144 
145     /* The number representing 1.0 for higher fidelity numbers. */
146     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
147     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
148 
149     /**
150      * @return Provides an interface to UNIT.
151      */
152     function unit() external pure returns (uint) {
153         return UNIT;
154     }
155 
156     /**
157      * @return Provides an interface to PRECISE_UNIT.
158      */
159     function preciseUnit() external pure returns (uint) {
160         return PRECISE_UNIT;
161     }
162 
163     /**
164      * @return The result of multiplying x and y, interpreting the operands as fixed-point
165      * decimals.
166      *
167      * @dev A unit factor is divided out after the product of x and y is evaluated,
168      * so that product must be less than 2**256. As this is an integer division,
169      * the internal division always rounds down. This helps save on gas. Rounding
170      * is more expensive on gas.
171      */
172     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
173         /* Divide by UNIT to remove the extra factor introduced by the product. */
174         return x.mul(y) / UNIT;
175     }
176 
177     /**
178      * @return The result of safely multiplying x and y, interpreting the operands
179      * as fixed-point decimals of the specified precision unit.
180      *
181      * @dev The operands should be in the form of a the specified unit factor which will be
182      * divided out after the product of x and y is evaluated, so that product must be
183      * less than 2**256.
184      *
185      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
186      * Rounding is useful when you need to retain fidelity for small decimal numbers
187      * (eg. small fractions or percentages).
188      */
189     function _multiplyDecimalRound(uint x, uint y, uint precisionUnit) private pure returns (uint) {
190         /* Divide by UNIT to remove the extra factor introduced by the product. */
191         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
192 
193         if (quotientTimesTen % 10 >= 5) {
194             quotientTimesTen += 10;
195         }
196 
197         return quotientTimesTen / 10;
198     }
199 
200     /**
201      * @return The result of safely multiplying x and y, interpreting the operands
202      * as fixed-point decimals of a precise unit.
203      *
204      * @dev The operands should be in the precise unit factor which will be
205      * divided out after the product of x and y is evaluated, so that product must be
206      * less than 2**256.
207      *
208      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
209      * Rounding is useful when you need to retain fidelity for small decimal numbers
210      * (eg. small fractions or percentages).
211      */
212     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
213         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
214     }
215 
216     /**
217      * @return The result of safely multiplying x and y, interpreting the operands
218      * as fixed-point decimals of a standard unit.
219      *
220      * @dev The operands should be in the standard unit factor which will be
221      * divided out after the product of x and y is evaluated, so that product must be
222      * less than 2**256.
223      *
224      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
225      * Rounding is useful when you need to retain fidelity for small decimal numbers
226      * (eg. small fractions or percentages).
227      */
228     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
229         return _multiplyDecimalRound(x, y, UNIT);
230     }
231 
232     /**
233      * @return The result of safely dividing x and y. The return value is a high
234      * precision decimal.
235      *
236      * @dev y is divided after the product of x and the standard precision unit
237      * is evaluated, so the product of x and UNIT must be less than 2**256. As
238      * this is an integer division, the result is always rounded down.
239      * This helps save on gas. Rounding is more expensive on gas.
240      */
241     function divideDecimal(uint x, uint y) internal pure returns (uint) {
242         /* Reintroduce the UNIT factor that will be divided out by y. */
243         return x.mul(UNIT).div(y);
244     }
245 
246     /**
247      * @return The result of safely dividing x and y. The return value is as a rounded
248      * decimal in the precision unit specified in the parameter.
249      *
250      * @dev y is divided after the product of x and the specified precision unit
251      * is evaluated, so the product of x and the specified precision unit must
252      * be less than 2**256. The result is rounded to the nearest increment.
253      */
254     function _divideDecimalRound(uint x, uint y, uint precisionUnit) private pure returns (uint) {
255         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
256 
257         if (resultTimesTen % 10 >= 5) {
258             resultTimesTen += 10;
259         }
260 
261         return resultTimesTen / 10;
262     }
263 
264     /**
265      * @return The result of safely dividing x and y. The return value is as a rounded
266      * standard precision decimal.
267      *
268      * @dev y is divided after the product of x and the standard precision unit
269      * is evaluated, so the product of x and the standard precision unit must
270      * be less than 2**256. The result is rounded to the nearest increment.
271      */
272     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
273         return _divideDecimalRound(x, y, UNIT);
274     }
275 
276     /**
277      * @return The result of safely dividing x and y. The return value is as a rounded
278      * high precision decimal.
279      *
280      * @dev y is divided after the product of x and the high precision unit
281      * is evaluated, so the product of x and the high precision unit must
282      * be less than 2**256. The result is rounded to the nearest increment.
283      */
284     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
285         return _divideDecimalRound(x, y, PRECISE_UNIT);
286     }
287 
288     /**
289      * @dev Convert a standard decimal representation to a high precision one.
290      */
291     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
292         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
293     }
294 
295     /**
296      * @dev Convert a high precision decimal to a standard decimal representation.
297      */
298     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
299         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
300 
301         if (quotientTimesTen % 10 >= 5) {
302             quotientTimesTen += 10;
303         }
304 
305         return quotientTimesTen / 10;
306     }
307 }
308 
309 
310 // https://docs.synthetix.io/contracts/Owned
311 contract Owned {
312     address public owner;
313     address public nominatedOwner;
314 
315     /**
316      * @dev Owned Constructor
317      */
318     constructor(address _owner) public {
319         require(_owner != address(0), "Owner address cannot be 0");
320         owner = _owner;
321         emit OwnerChanged(address(0), _owner);
322     }
323 
324     /**
325      * @notice Nominate a new owner of this contract.
326      * @dev Only the current owner may nominate a new owner.
327      */
328     function nominateNewOwner(address _owner) external onlyOwner {
329         nominatedOwner = _owner;
330         emit OwnerNominated(_owner);
331     }
332 
333     /**
334      * @notice Accept the nomination to be owner.
335      */
336     function acceptOwnership() external {
337         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
338         emit OwnerChanged(owner, nominatedOwner);
339         owner = nominatedOwner;
340         nominatedOwner = address(0);
341     }
342 
343     modifier onlyOwner {
344         require(msg.sender == owner, "Only the contract owner may perform this action");
345         _;
346     }
347 
348     event OwnerNominated(address newOwner);
349     event OwnerChanged(address oldOwner, address newOwner);
350 }
351 
352 
353 // https://docs.synthetix.io/contracts/SelfDestructible
354 contract SelfDestructible is Owned {
355     uint public initiationTime;
356     bool public selfDestructInitiated;
357     address public selfDestructBeneficiary;
358     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
359 
360     /**
361      * @dev Constructor
362      * @param _owner The account which controls this contract.
363      */
364     constructor(address _owner) public Owned(_owner) {
365         require(_owner != address(0), "Owner must not be zero");
366         selfDestructBeneficiary = _owner;
367         emit SelfDestructBeneficiaryUpdated(_owner);
368     }
369 
370     /**
371      * @notice Set the beneficiary address of this contract.
372      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
373      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
374      */
375     function setSelfDestructBeneficiary(address _beneficiary) external onlyOwner {
376         require(_beneficiary != address(0), "Beneficiary must not be zero");
377         selfDestructBeneficiary = _beneficiary;
378         emit SelfDestructBeneficiaryUpdated(_beneficiary);
379     }
380 
381     /**
382      * @notice Begin the self-destruction counter of this contract.
383      * Once the delay has elapsed, the contract may be self-destructed.
384      * @dev Only the contract owner may call this.
385      */
386     function initiateSelfDestruct() external onlyOwner {
387         initiationTime = now;
388         selfDestructInitiated = true;
389         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
390     }
391 
392     /**
393      * @notice Terminate and reset the self-destruction timer.
394      * @dev Only the contract owner may call this.
395      */
396     function terminateSelfDestruct() external onlyOwner {
397         initiationTime = 0;
398         selfDestructInitiated = false;
399         emit SelfDestructTerminated();
400     }
401 
402     /**
403      * @notice If the self-destruction delay has elapsed, destroy this contract and
404      * remit any ether it owns to the beneficiary address.
405      * @dev Only the contract owner may call this.
406      */
407     function selfDestruct() external onlyOwner {
408         require(selfDestructInitiated, "Self Destruct not yet initiated");
409         require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay not met");
410         address beneficiary = selfDestructBeneficiary;
411         emit SelfDestructed(beneficiary);
412         selfdestruct(beneficiary);
413     }
414 
415     event SelfDestructTerminated();
416     event SelfDestructed(address beneficiary);
417     event SelfDestructInitiated(uint selfDestructDelay);
418     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
419 }
420 
421 
422 // https://docs.synthetix.io/contracts/State
423 contract State is Owned {
424     // the address of the contract that can modify variables
425     // this can only be changed by the owner of this contract
426     address public associatedContract;
427 
428     constructor(address _owner, address _associatedContract) public Owned(_owner) {
429         associatedContract = _associatedContract;
430         emit AssociatedContractUpdated(_associatedContract);
431     }
432 
433     /* ========== SETTERS ========== */
434 
435     // Change the associated contract to a new address
436     function setAssociatedContract(address _associatedContract) external onlyOwner {
437         associatedContract = _associatedContract;
438         emit AssociatedContractUpdated(_associatedContract);
439     }
440 
441     /* ========== MODIFIERS ========== */
442 
443     modifier onlyAssociatedContract {
444         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
445         _;
446     }
447 
448     /* ========== EVENTS ========== */
449 
450     event AssociatedContractUpdated(address associatedContract);
451 }
452 
453 
454 // https://docs.synthetix.io/contracts/TokenState
455 contract TokenState is State {
456     /* ERC20 fields. */
457     mapping(address => uint) public balanceOf;
458     mapping(address => mapping(address => uint)) public allowance;
459 
460     /**
461      * @dev Constructor
462      * @param _owner The address which controls this contract.
463      * @param _associatedContract The ERC20 contract whose state this composes.
464      */
465     constructor(address _owner, address _associatedContract) public State(_owner, _associatedContract) {}
466 
467     /* ========== SETTERS ========== */
468 
469     /**
470      * @notice Set ERC20 allowance.
471      * @dev Only the associated contract may call this.
472      * @param tokenOwner The authorising party.
473      * @param spender The authorised party.
474      * @param value The total value the authorised party may spend on the
475      * authorising party's behalf.
476      */
477     function setAllowance(address tokenOwner, address spender, uint value) external onlyAssociatedContract {
478         allowance[tokenOwner][spender] = value;
479     }
480 
481     /**
482      * @notice Set the balance in a given account
483      * @dev Only the associated contract may call this.
484      * @param account The account whose value to set.
485      * @param value The new balance of the given account.
486      */
487     function setBalanceOf(address account, uint value) external onlyAssociatedContract {
488         balanceOf[account] = value;
489     }
490 }
491 
492 
493 // https://docs.synthetix.io/contracts/Proxy
494 contract Proxy is Owned {
495     Proxyable public target;
496     bool public useDELEGATECALL;
497 
498     constructor(address _owner) public Owned(_owner) {}
499 
500     function setTarget(Proxyable _target) external onlyOwner {
501         target = _target;
502         emit TargetUpdated(_target);
503     }
504 
505     function setUseDELEGATECALL(bool value) external onlyOwner {
506         useDELEGATECALL = value;
507     }
508 
509     function _emit(bytes callData, uint numTopics, bytes32 topic1, bytes32 topic2, bytes32 topic3, bytes32 topic4)
510         external
511         onlyTarget
512     {
513         uint size = callData.length;
514         bytes memory _callData = callData;
515 
516         assembly {
517             /* The first 32 bytes of callData contain its length (as specified by the abi).
518              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
519              * in length. It is also leftpadded to be a multiple of 32 bytes.
520              * This means moving call_data across 32 bytes guarantees we correctly access
521              * the data itself. */
522             switch numTopics
523                 case 0 {
524                     log0(add(_callData, 32), size)
525                 }
526                 case 1 {
527                     log1(add(_callData, 32), size, topic1)
528                 }
529                 case 2 {
530                     log2(add(_callData, 32), size, topic1, topic2)
531                 }
532                 case 3 {
533                     log3(add(_callData, 32), size, topic1, topic2, topic3)
534                 }
535                 case 4 {
536                     log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
537                 }
538         }
539     }
540 
541     function() external payable {
542         if (useDELEGATECALL) {
543             assembly {
544                 /* Copy call data into free memory region. */
545                 let free_ptr := mload(0x40)
546                 calldatacopy(free_ptr, 0, calldatasize)
547 
548                 /* Forward all gas and call data to the target contract. */
549                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
550                 returndatacopy(free_ptr, 0, returndatasize)
551 
552                 /* Revert if the call failed, otherwise return the result. */
553                 if iszero(result) {
554                     revert(free_ptr, returndatasize)
555                 }
556                 return(free_ptr, returndatasize)
557             }
558         } else {
559             /* Here we are as above, but must send the messageSender explicitly
560              * since we are using CALL rather than DELEGATECALL. */
561             target.setMessageSender(msg.sender);
562             assembly {
563                 let free_ptr := mload(0x40)
564                 calldatacopy(free_ptr, 0, calldatasize)
565 
566                 /* We must explicitly forward ether to the underlying contract as well. */
567                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
568                 returndatacopy(free_ptr, 0, returndatasize)
569 
570                 if iszero(result) {
571                     revert(free_ptr, returndatasize)
572                 }
573                 return(free_ptr, returndatasize)
574             }
575         }
576     }
577 
578     modifier onlyTarget {
579         require(Proxyable(msg.sender) == target, "Must be proxy target");
580         _;
581     }
582 
583     event TargetUpdated(Proxyable newTarget);
584 }
585 
586 
587 // https://docs.synthetix.io/contracts/Proxyable
588 contract Proxyable is Owned {
589     // This contract should be treated like an abstract contract
590 
591     /* The proxy this contract exists behind. */
592     Proxy public proxy;
593     Proxy public integrationProxy;
594 
595     /* The caller of the proxy, passed through to this contract.
596      * Note that every function using this member must apply the onlyProxy or
597      * optionalProxy modifiers, otherwise their invocations can use stale values. */
598     address public messageSender;
599 
600     constructor(address _proxy, address _owner) public Owned(_owner) {
601         proxy = Proxy(_proxy);
602         emit ProxyUpdated(_proxy);
603     }
604 
605     function setProxy(address _proxy) external onlyOwner {
606         proxy = Proxy(_proxy);
607         emit ProxyUpdated(_proxy);
608     }
609 
610     function setIntegrationProxy(address _integrationProxy) external onlyOwner {
611         integrationProxy = Proxy(_integrationProxy);
612     }
613 
614     function setMessageSender(address sender) external onlyProxy {
615         messageSender = sender;
616     }
617 
618     modifier onlyProxy {
619         require(Proxy(msg.sender) == proxy || Proxy(msg.sender) == integrationProxy, "Only the proxy can call");
620         _;
621     }
622 
623     modifier optionalProxy {
624         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
625             messageSender = msg.sender;
626         }
627         _;
628     }
629 
630     modifier optionalProxy_onlyOwner {
631         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
632             messageSender = msg.sender;
633         }
634         require(messageSender == owner, "Owner only function");
635         _;
636     }
637 
638     event ProxyUpdated(address proxyAddress);
639 }
640 
641 
642 // https://docs.synthetix.io/contracts/ExternStateToken
643 contract ExternStateToken is SelfDestructible, Proxyable {
644     using SafeMath for uint;
645     using SafeDecimalMath for uint;
646 
647     /* ========== STATE VARIABLES ========== */
648 
649     /* Stores balances and allowances. */
650     TokenState public tokenState;
651 
652     /* Other ERC20 fields. */
653     string public name;
654     string public symbol;
655     uint public totalSupply;
656     uint8 public decimals;
657 
658     /**
659      * @dev Constructor.
660      * @param _proxy The proxy associated with this contract.
661      * @param _name Token's ERC20 name.
662      * @param _symbol Token's ERC20 symbol.
663      * @param _totalSupply The total supply of the token.
664      * @param _tokenState The TokenState contract address.
665      * @param _owner The owner of this contract.
666      */
667     constructor(
668         address _proxy,
669         TokenState _tokenState,
670         string _name,
671         string _symbol,
672         uint _totalSupply,
673         uint8 _decimals,
674         address _owner
675     ) public SelfDestructible(_owner) Proxyable(_proxy, _owner) {
676         tokenState = _tokenState;
677 
678         name = _name;
679         symbol = _symbol;
680         totalSupply = _totalSupply;
681         decimals = _decimals;
682     }
683 
684     /* ========== VIEWS ========== */
685 
686     /**
687      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
688      * @param owner The party authorising spending of their funds.
689      * @param spender The party spending tokenOwner's funds.
690      */
691     function allowance(address owner, address spender) public view returns (uint) {
692         return tokenState.allowance(owner, spender);
693     }
694 
695     /**
696      * @notice Returns the ERC20 token balance of a given account.
697      */
698     function balanceOf(address account) public view returns (uint) {
699         return tokenState.balanceOf(account);
700     }
701 
702     /* ========== MUTATIVE FUNCTIONS ========== */
703 
704     /**
705      * @notice Set the address of the TokenState contract.
706      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
707      * as balances would be unreachable.
708      */
709     function setTokenState(TokenState _tokenState) external optionalProxy_onlyOwner {
710         tokenState = _tokenState;
711         emitTokenStateUpdated(_tokenState);
712     }
713 
714     function _internalTransfer(address from, address to, uint value) internal returns (bool) {
715         /* Disallow transfers to irretrievable-addresses. */
716         require(to != address(0) && to != address(this) && to != address(proxy), "Cannot transfer to this address");
717 
718         // Insufficient balance will be handled by the safe subtraction.
719         tokenState.setBalanceOf(from, tokenState.balanceOf(from).sub(value));
720         tokenState.setBalanceOf(to, tokenState.balanceOf(to).add(value));
721 
722         // Emit a standard ERC20 transfer event
723         emitTransfer(from, to, value);
724 
725         return true;
726     }
727 
728     /**
729      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
730      * the onlyProxy or optionalProxy modifiers.
731      */
732     function _transfer_byProxy(address from, address to, uint value) internal returns (bool) {
733         return _internalTransfer(from, to, value);
734     }
735 
736     /**
737      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
738      * possessing the optionalProxy or optionalProxy modifiers.
739      */
740     function _transferFrom_byProxy(address sender, address from, address to, uint value) internal returns (bool) {
741         /* Insufficient allowance will be handled by the safe subtraction. */
742         tokenState.setAllowance(from, sender, tokenState.allowance(from, sender).sub(value));
743         return _internalTransfer(from, to, value);
744     }
745 
746     /**
747      * @notice Approves spender to transfer on the message sender's behalf.
748      */
749     function approve(address spender, uint value) public optionalProxy returns (bool) {
750         address sender = messageSender;
751 
752         tokenState.setAllowance(sender, spender, value);
753         emitApproval(sender, spender, value);
754         return true;
755     }
756 
757     /* ========== EVENTS ========== */
758 
759     event Transfer(address indexed from, address indexed to, uint value);
760     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
761 
762     function emitTransfer(address from, address to, uint value) internal {
763         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
764     }
765 
766     event Approval(address indexed owner, address indexed spender, uint value);
767     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
768 
769     function emitApproval(address owner, address spender, uint value) internal {
770         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
771     }
772 
773     event TokenStateUpdated(address newTokenState);
774     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
775 
776     function emitTokenStateUpdated(address newTokenState) internal {
777         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
778     }
779 }
780 
781 
782 // https://docs.synthetix.io/contracts/AddressResolver
783 contract AddressResolver is Owned {
784     mapping(bytes32 => address) public repository;
785 
786     constructor(address _owner) public Owned(_owner) {}
787 
788     /* ========== MUTATIVE FUNCTIONS ========== */
789 
790     function importAddresses(bytes32[] names, address[] destinations) public onlyOwner {
791         require(names.length == destinations.length, "Input lengths must match");
792 
793         for (uint i = 0; i < names.length; i++) {
794             repository[names[i]] = destinations[i];
795         }
796     }
797 
798     /* ========== VIEWS ========== */
799 
800     function getAddress(bytes32 name) public view returns (address) {
801         return repository[name];
802     }
803 
804     function requireAndGetAddress(bytes32 name, string reason) public view returns (address) {
805         address _foundAddress = repository[name];
806         require(_foundAddress != address(0), reason);
807         return _foundAddress;
808     }
809 }
810 
811 
812 // https://docs.synthetix.io/contracts/MixinResolver
813 contract MixinResolver is Owned {
814     AddressResolver public resolver;
815 
816     mapping(bytes32 => address) private addressCache;
817 
818     bytes32[] public resolverAddressesRequired;
819 
820     uint public constant MAX_ADDRESSES_FROM_RESOLVER = 24;
821 
822     constructor(address _owner, address _resolver, bytes32[MAX_ADDRESSES_FROM_RESOLVER] _addressesToCache)
823         public
824         Owned(_owner)
825     {
826         for (uint i = 0; i < _addressesToCache.length; i++) {
827             if (_addressesToCache[i] != bytes32(0)) {
828                 resolverAddressesRequired.push(_addressesToCache[i]);
829             } else {
830                 // End early once an empty item is found - assumes there are no empty slots in
831                 // _addressesToCache
832                 break;
833             }
834         }
835         resolver = AddressResolver(_resolver);
836         // Do not sync the cache as addresses may not be in the resolver yet
837     }
838 
839     /* ========== SETTERS ========== */
840     function setResolverAndSyncCache(AddressResolver _resolver) external onlyOwner {
841         resolver = _resolver;
842 
843         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
844             bytes32 name = resolverAddressesRequired[i];
845             // Note: can only be invoked once the resolver has all the targets needed added
846             addressCache[name] = resolver.requireAndGetAddress(name, "Resolver missing target");
847         }
848     }
849 
850     /* ========== VIEWS ========== */
851 
852     function requireAndGetAddress(bytes32 name, string reason) internal view returns (address) {
853         address _foundAddress = addressCache[name];
854         require(_foundAddress != address(0), reason);
855         return _foundAddress;
856     }
857 
858     // Note: this could be made external in a utility contract if addressCache was made public
859     // (used for deployment)
860     function isResolverCached(AddressResolver _resolver) external view returns (bool) {
861         if (resolver != _resolver) {
862             return false;
863         }
864 
865         // otherwise, check everything
866         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
867             bytes32 name = resolverAddressesRequired[i];
868             // false if our cache is invalid or if the resolver doesn't have the required address
869             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
870                 return false;
871             }
872         }
873 
874         return true;
875     }
876 
877     // Note: can be made external into a utility contract (used for deployment)
878     function getResolverAddressesRequired() external view returns (bytes32[MAX_ADDRESSES_FROM_RESOLVER] addressesRequired) {
879         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
880             addressesRequired[i] = resolverAddressesRequired[i];
881         }
882     }
883 
884     /* ========== INTERNAL FUNCTIONS ========== */
885     function appendToAddressCache(bytes32 name) internal {
886         resolverAddressesRequired.push(name);
887         require(resolverAddressesRequired.length < MAX_ADDRESSES_FROM_RESOLVER, "Max resolver cache size met");
888         // Because this is designed to be called internally in constructors, we don't
889         // check the address exists already in the resolver
890         addressCache[name] = resolver.getAddress(name);
891     }
892 }
893 
894 
895 // https://docs.synthetix.io/contracts/Math
896 library Math {
897     using SafeMath for uint;
898     using SafeDecimalMath for uint;
899 
900     /**
901      * @dev Uses "exponentiation by squaring" algorithm where cost is 0(logN)
902      * vs 0(N) for naive repeated multiplication.
903      * Calculates x^n with x as fixed-point and n as regular unsigned int.
904      * Calculates to 18 digits of precision with SafeDecimalMath.unit()
905      */
906     function powDecimal(uint x, uint n) internal pure returns (uint) {
907         // https://mpark.github.io/programming/2014/08/18/exponentiation-by-squaring/
908 
909         uint result = SafeDecimalMath.unit();
910         while (n > 0) {
911             if (n % 2 != 0) {
912                 result = result.multiplyDecimal(x);
913             }
914             x = x.multiplyDecimal(x);
915             n /= 2;
916         }
917         return result;
918     }
919 }
920 
921 
922 /**
923  * @title SynthetixState interface contract
924  * @notice Abstract contract to hold public getters
925  */
926 contract ISynthetixState {
927     // A struct for handing values associated with an individual user's debt position
928     struct IssuanceData {
929         // Percentage of the total debt owned at the time
930         // of issuance. This number is modified by the global debt
931         // delta array. You can figure out a user's exit price and
932         // collateralisation ratio using a combination of their initial
933         // debt and the slice of global debt delta which applies to them.
934         uint initialDebtOwnership;
935         // This lets us know when (in relative terms) the user entered
936         // the debt pool so we can calculate their exit price and
937         // collateralistion ratio
938         uint debtEntryIndex;
939     }
940 
941     uint[] public debtLedger;
942     uint public issuanceRatio;
943     mapping(address => IssuanceData) public issuanceData;
944 
945     function debtLedgerLength() external view returns (uint);
946 
947     function hasIssued(address account) external view returns (bool);
948 
949     function incrementTotalIssuerCount() external;
950 
951     function decrementTotalIssuerCount() external;
952 
953     function setCurrentIssuanceData(address account, uint initialDebtOwnership) external;
954 
955     function lastDebtLedgerEntry() external view returns (uint);
956 
957     function appendDebtLedgerValue(uint value) external;
958 
959     function clearIssuanceData(address account) external;
960 }
961 
962 
963 interface ISynth {
964     function burn(address account, uint amount) external;
965 
966     function issue(address account, uint amount) external;
967 
968     function transfer(address to, uint value) external returns (bool);
969 
970     function transferFrom(address from, address to, uint value) external returns (bool);
971 
972     function transferFromAndSettle(address from, address to, uint value) external returns (bool);
973 
974     function balanceOf(address owner) external view returns (uint);
975 }
976 
977 
978 /**
979  * @title SynthetixEscrow interface
980  */
981 interface ISynthetixEscrow {
982     function balanceOf(address account) public view returns (uint);
983 
984     function appendVestingEntry(address account, uint quantity) public;
985 }
986 
987 
988 /**
989  * @title FeePool Interface
990  * @notice Abstract contract to hold public getters
991  */
992 contract IFeePool {
993     address public FEE_ADDRESS;
994     uint public exchangeFeeRate;
995 
996     function amountReceivedFromExchange(uint value) external view returns (uint);
997 
998     function amountReceivedFromTransfer(uint value) external view returns (uint);
999 
1000     function recordFeePaid(uint sUSDAmount) external;
1001 
1002     function appendAccountIssuanceRecord(address account, uint lockedAmount, uint debtEntryIndex) external;
1003 
1004     function setRewardsToDistribute(uint amount) external;
1005 }
1006 
1007 
1008 /**
1009  * @title ExchangeRates interface
1010  */
1011 interface IExchangeRates {
1012     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
1013         external
1014         view
1015         returns (uint);
1016 
1017     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1018 
1019     function ratesForCurrencies(bytes32[] currencyKeys) external view returns (uint[] memory);
1020 
1021     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1022 
1023     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
1024 
1025     function anyRateIsStale(bytes32[] currencyKeys) external view returns (bool);
1026 
1027     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
1028 
1029     function effectiveValueAtRound(
1030         bytes32 sourceCurrencyKey,
1031         uint sourceAmount,
1032         bytes32 destinationCurrencyKey,
1033         uint roundIdForSrc,
1034         uint roundIdForDest
1035     ) external view returns (uint);
1036 
1037     function getLastRoundIdBeforeElapsedSecs(
1038         bytes32 currencyKey,
1039         uint startingRoundId,
1040         uint startingTimestamp,
1041         uint timediff
1042     ) external view returns (uint);
1043 
1044     function ratesAndStaleForCurrencies(bytes32[] currencyKeys) external view returns (uint[], bool);
1045 
1046     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
1047 }
1048 
1049 
1050 interface ISystemStatus {
1051     function requireSystemActive() external view;
1052 
1053     function requireIssuanceActive() external view;
1054 
1055     function requireExchangeActive() external view;
1056 
1057     function requireSynthActive(bytes32 currencyKey) external view;
1058 
1059     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1060 }
1061 
1062 
1063 interface IExchanger {
1064     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
1065 
1066     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view returns (uint);
1067 
1068     function settlementOwing(address account, bytes32 currencyKey)
1069         external
1070         view
1071         returns (uint reclaimAmount, uint rebateAmount, uint numEntries);
1072 
1073     function settle(address from, bytes32 currencyKey) external returns (uint reclaimed, uint refunded, uint numEntries);
1074 
1075     function exchange(
1076         address from,
1077         bytes32 sourceCurrencyKey,
1078         uint sourceAmount,
1079         bytes32 destinationCurrencyKey,
1080         address destinationAddress
1081     ) external returns (uint amountReceived);
1082 
1083     function exchangeOnBehalf(
1084         address exchangeForAddress,
1085         address from,
1086         bytes32 sourceCurrencyKey,
1087         uint sourceAmount,
1088         bytes32 destinationCurrencyKey
1089     ) external returns (uint amountReceived);
1090 
1091     function calculateAmountAfterSettlement(address from, bytes32 currencyKey, uint amount, uint refunded)
1092         external
1093         view
1094         returns (uint amountAfterSettlement);
1095 }
1096 
1097 
1098 interface IIssuer {
1099     function issueSynths(address from, uint amount) external;
1100 
1101     function issueSynthsOnBehalf(address issueFor, address from, uint amount) external;
1102 
1103     function issueMaxSynths(address from) external;
1104 
1105     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
1106 
1107     function burnSynths(address from, uint amount) external;
1108 
1109     function burnSynthsOnBehalf(address burnForAddress, address from, uint amount) external;
1110 
1111     function burnSynthsToTarget(address from) external;
1112 
1113     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
1114 
1115     function canBurnSynths(address account) external view returns (bool);
1116 
1117     function lastIssueEvent(address account) external view returns (uint);
1118 }
1119 
1120 
1121 // https://docs.synthetix.io/contracts/Synth
1122 contract Synth is ExternStateToken, MixinResolver {
1123     /* ========== STATE VARIABLES ========== */
1124 
1125     // Currency key which identifies this Synth to the Synthetix system
1126     bytes32 public currencyKey;
1127 
1128     uint8 public constant DECIMALS = 18;
1129 
1130     // Where fees are pooled in sUSD
1131     address public constant FEE_ADDRESS = 0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF;
1132 
1133     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1134 
1135     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1136     bytes32 private constant CONTRACT_SYNTHETIX = "Synthetix";
1137     bytes32 private constant CONTRACT_EXCHANGER = "Exchanger";
1138     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1139     bytes32 private constant CONTRACT_FEEPOOL = "FeePool";
1140 
1141     bytes32[24] internal addressesToCache = [
1142         CONTRACT_SYSTEMSTATUS,
1143         CONTRACT_SYNTHETIX,
1144         CONTRACT_EXCHANGER,
1145         CONTRACT_ISSUER,
1146         CONTRACT_FEEPOOL
1147     ];
1148 
1149     /* ========== CONSTRUCTOR ========== */
1150 
1151     constructor(
1152         address _proxy,
1153         TokenState _tokenState,
1154         string _tokenName,
1155         string _tokenSymbol,
1156         address _owner,
1157         bytes32 _currencyKey,
1158         uint _totalSupply,
1159         address _resolver
1160     )
1161         public
1162         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, _totalSupply, DECIMALS, _owner)
1163         MixinResolver(_owner, _resolver, addressesToCache)
1164     {
1165         require(_proxy != address(0), "_proxy cannot be 0");
1166         require(_owner != 0, "_owner cannot be 0");
1167 
1168         currencyKey = _currencyKey;
1169     }
1170 
1171     /* ========== MUTATIVE FUNCTIONS ========== */
1172 
1173     function transfer(address to, uint value) public optionalProxy returns (bool) {
1174         _ensureCanTransfer(messageSender, value);
1175 
1176         // transfers to FEE_ADDRESS will be exchanged into sUSD and recorded as fee
1177         if (to == FEE_ADDRESS) {
1178             return _transferToFeeAddress(to, value);
1179         }
1180 
1181         // transfers to 0x address will be burned
1182         if (to == address(0)) {
1183             return _internalBurn(messageSender, value);
1184         }
1185 
1186         return super._internalTransfer(messageSender, to, value);
1187     }
1188 
1189     function transferAndSettle(address to, uint value) public optionalProxy returns (bool) {
1190         systemStatus().requireSynthActive(currencyKey);
1191 
1192         (, , uint numEntriesSettled) = exchanger().settle(messageSender, currencyKey);
1193 
1194         // Save gas instead of calling transferableSynths
1195         uint balanceAfter = value;
1196 
1197         if (numEntriesSettled > 0) {
1198             balanceAfter = tokenState.balanceOf(messageSender);
1199         }
1200 
1201         // Reduce the value to transfer if balance is insufficient after reclaimed
1202         value = value > balanceAfter ? balanceAfter : value;
1203 
1204         return super._internalTransfer(messageSender, to, value);
1205     }
1206 
1207     function transferFrom(address from, address to, uint value) public optionalProxy returns (bool) {
1208         _ensureCanTransfer(from, value);
1209 
1210         return _internalTransferFrom(from, to, value);
1211     }
1212 
1213     function transferFromAndSettle(address from, address to, uint value) public optionalProxy returns (bool) {
1214         systemStatus().requireSynthActive(currencyKey);
1215 
1216         (, , uint numEntriesSettled) = exchanger().settle(from, currencyKey);
1217 
1218         // Save gas instead of calling transferableSynths
1219         uint balanceAfter = value;
1220 
1221         if (numEntriesSettled > 0) {
1222             balanceAfter = tokenState.balanceOf(from);
1223         }
1224 
1225         // Reduce the value to transfer if balance is insufficient after reclaimed
1226         value = value >= balanceAfter ? balanceAfter : value;
1227 
1228         return _internalTransferFrom(from, to, value);
1229     }
1230 
1231     /**
1232      * @notice _transferToFeeAddress function
1233      * non-sUSD synths are exchanged into sUSD via synthInitiatedExchange
1234      * notify feePool to record amount as fee paid to feePool */
1235     function _transferToFeeAddress(address to, uint value) internal returns (bool) {
1236         uint amountInUSD;
1237 
1238         // sUSD can be transferred to FEE_ADDRESS directly
1239         if (currencyKey == "sUSD") {
1240             amountInUSD = value;
1241             super._internalTransfer(messageSender, to, value);
1242         } else {
1243             // else exchange synth into sUSD and send to FEE_ADDRESS
1244             amountInUSD = exchanger().exchange(messageSender, currencyKey, value, "sUSD", FEE_ADDRESS);
1245         }
1246 
1247         // Notify feePool to record sUSD to distribute as fees
1248         feePool().recordFeePaid(amountInUSD);
1249 
1250         return true;
1251     }
1252 
1253     // Allow synthetix to issue a certain number of synths from an account.
1254     // forward call to _internalIssue
1255     function issue(address account, uint amount) external onlyInternalContracts {
1256         _internalIssue(account, amount);
1257     }
1258 
1259     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
1260     // forward call to _internalBurn
1261     function burn(address account, uint amount) external onlyInternalContracts {
1262         _internalBurn(account, amount);
1263     }
1264 
1265     function _internalIssue(address account, uint amount) internal {
1266         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
1267         totalSupply = totalSupply.add(amount);
1268         emitTransfer(address(0), account, amount);
1269         emitIssued(account, amount);
1270     }
1271 
1272     function _internalBurn(address account, uint amount) internal returns (bool) {
1273         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
1274         totalSupply = totalSupply.sub(amount);
1275         emitTransfer(account, address(0), amount);
1276         emitBurned(account, amount);
1277 
1278         return true;
1279     }
1280 
1281     // Allow owner to set the total supply on import.
1282     function setTotalSupply(uint amount) external optionalProxy_onlyOwner {
1283         totalSupply = amount;
1284     }
1285 
1286     /* ========== VIEWS ========== */
1287     function systemStatus() internal view returns (ISystemStatus) {
1288         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS, "Missing SystemStatus address"));
1289     }
1290 
1291     function synthetix() internal view returns (ISynthetix) {
1292         return ISynthetix(requireAndGetAddress(CONTRACT_SYNTHETIX, "Missing Synthetix address"));
1293     }
1294 
1295     function feePool() internal view returns (IFeePool) {
1296         return IFeePool(requireAndGetAddress(CONTRACT_FEEPOOL, "Missing FeePool address"));
1297     }
1298 
1299     function exchanger() internal view returns (IExchanger) {
1300         return IExchanger(requireAndGetAddress(CONTRACT_EXCHANGER, "Missing Exchanger address"));
1301     }
1302 
1303     function issuer() internal view returns (IIssuer) {
1304         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER, "Missing Issuer address"));
1305     }
1306 
1307     function _ensureCanTransfer(address from, uint value) internal view {
1308         require(exchanger().maxSecsLeftInWaitingPeriod(from, currencyKey) == 0, "Cannot transfer during waiting period");
1309         require(transferableSynths(from) >= value, "Insufficient balance after any settlement owing");
1310         systemStatus().requireSynthActive(currencyKey);
1311     }
1312 
1313     function transferableSynths(address account) public view returns (uint) {
1314         (uint reclaimAmount, , ) = exchanger().settlementOwing(account, currencyKey);
1315 
1316         // Note: ignoring rebate amount here because a settle() is required in order to
1317         // allow the transfer to actually work
1318 
1319         uint balance = tokenState.balanceOf(account);
1320 
1321         if (reclaimAmount > balance) {
1322             return 0;
1323         } else {
1324             return balance.sub(reclaimAmount);
1325         }
1326     }
1327 
1328     /* ========== INTERNAL FUNCTIONS ========== */
1329 
1330     function _internalTransferFrom(address from, address to, uint value) internal returns (bool) {
1331         // Skip allowance update in case of infinite allowance
1332         if (tokenState.allowance(from, messageSender) != uint(-1)) {
1333             // Reduce the allowance by the amount we're transferring.
1334             // The safeSub call will handle an insufficient allowance.
1335             tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
1336         }
1337 
1338         return super._internalTransfer(from, to, value);
1339     }
1340 
1341     /* ========== MODIFIERS ========== */
1342 
1343     modifier onlyInternalContracts() {
1344         bool isSynthetix = msg.sender == address(synthetix());
1345         bool isFeePool = msg.sender == address(feePool());
1346         bool isExchanger = msg.sender == address(exchanger());
1347         bool isIssuer = msg.sender == address(issuer());
1348 
1349         require(
1350             isSynthetix || isFeePool || isExchanger || isIssuer,
1351             "Only Synthetix, FeePool, Exchanger or Issuer contracts allowed"
1352         );
1353         _;
1354     }
1355 
1356     /* ========== EVENTS ========== */
1357     event Issued(address indexed account, uint value);
1358     bytes32 private constant ISSUED_SIG = keccak256("Issued(address,uint256)");
1359 
1360     function emitIssued(address account, uint value) internal {
1361         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
1362     }
1363 
1364     event Burned(address indexed account, uint value);
1365     bytes32 private constant BURNED_SIG = keccak256("Burned(address,uint256)");
1366 
1367     function emitBurned(address account, uint value) internal {
1368         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
1369     }
1370 }
1371 
1372 
1373 /**
1374  * @title Synthetix interface contract
1375  * @notice Abstract contract to hold public getters
1376  * @dev pseudo interface, actually declared as contract to hold the public getters
1377  */
1378 
1379 
1380 contract ISynthetix {
1381     // ========== PUBLIC STATE VARIABLES ==========
1382 
1383     uint public totalSupply;
1384 
1385     mapping(bytes32 => Synth) public synths;
1386 
1387     mapping(address => bytes32) public synthsByAddress;
1388 
1389     // ========== PUBLIC FUNCTIONS ==========
1390 
1391     function balanceOf(address account) public view returns (uint);
1392 
1393     function transfer(address to, uint value) public returns (bool);
1394 
1395     function transferFrom(address from, address to, uint value) public returns (bool);
1396 
1397     function exchange(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
1398         external
1399         returns (uint amountReceived);
1400 
1401     function issueSynths(uint amount) external;
1402 
1403     function issueMaxSynths() external;
1404 
1405     function burnSynths(uint amount) external;
1406 
1407     function burnSynthsToTarget() external;
1408 
1409     function settle(bytes32 currencyKey) external returns (uint reclaimed, uint refunded, uint numEntries);
1410 
1411     function collateralisationRatio(address issuer) public view returns (uint);
1412 
1413     function totalIssuedSynths(bytes32 currencyKey) public view returns (uint);
1414 
1415     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) public view returns (uint);
1416 
1417     function debtBalanceOf(address issuer, bytes32 currencyKey) public view returns (uint);
1418 
1419     function debtBalanceOfAndTotalDebt(address issuer, bytes32 currencyKey)
1420         public
1421         view
1422         returns (uint debtBalance, uint totalSystemValue);
1423 
1424     function remainingIssuableSynths(address issuer)
1425         public
1426         view
1427         returns (uint maxIssuable, uint alreadyIssued, uint totalSystemDebt);
1428 
1429     function maxIssuableSynths(address issuer) public view returns (uint maxIssuable);
1430 
1431     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
1432 
1433     function emitSynthExchange(
1434         address account,
1435         bytes32 fromCurrencyKey,
1436         uint fromAmount,
1437         bytes32 toCurrencyKey,
1438         uint toAmount,
1439         address toAddress
1440     ) external;
1441 
1442     function emitExchangeReclaim(address account, bytes32 currencyKey, uint amount) external;
1443 
1444     function emitExchangeRebate(address account, bytes32 currencyKey, uint amount) external;
1445 }
1446 
1447 
1448 // https://docs.synthetix.io/contracts/SupplySchedule
1449 contract SupplySchedule is Owned {
1450     using SafeMath for uint;
1451     using SafeDecimalMath for uint;
1452     using Math for uint;
1453 
1454     // Time of the last inflation supply mint event
1455     uint public lastMintEvent;
1456 
1457     // Counter for number of weeks since the start of supply inflation
1458     uint public weekCounter;
1459 
1460     // The number of SNX rewarded to the caller of Synthetix.mint()
1461     uint public minterReward = 200 * SafeDecimalMath.unit();
1462 
1463     // The initial weekly inflationary supply is 75m / 52 until the start of the decay rate.
1464     // 75e6 * SafeDecimalMath.unit() / 52
1465     uint public constant INITIAL_WEEKLY_SUPPLY = 1442307692307692307692307;
1466 
1467     // Address of the SynthetixProxy for the onlySynthetix modifier
1468     address public synthetixProxy;
1469 
1470     // Max SNX rewards for minter
1471     uint public constant MAX_MINTER_REWARD = 200 * SafeDecimalMath.unit();
1472 
1473     // How long each inflation period is before mint can be called
1474     uint public constant MINT_PERIOD_DURATION = 1 weeks;
1475 
1476     uint public constant INFLATION_START_DATE = 1551830400; // 2019-03-06T00:00:00+00:00
1477     uint public constant MINT_BUFFER = 1 days;
1478     uint8 public constant SUPPLY_DECAY_START = 40; // Week 40
1479     uint8 public constant SUPPLY_DECAY_END = 234; //  Supply Decay ends on Week 234 (inclusive of Week 234 for a total of 195 weeks of inflation decay)
1480 
1481     // Weekly percentage decay of inflationary supply from the first 40 weeks of the 75% inflation rate
1482     uint public constant DECAY_RATE = 12500000000000000; // 1.25% weekly
1483 
1484     // Percentage growth of terminal supply per annum
1485     uint public constant TERMINAL_SUPPLY_RATE_ANNUAL = 25000000000000000; // 2.5% pa
1486 
1487     constructor(address _owner, uint _lastMintEvent, uint _currentWeek) public Owned(_owner) {
1488         lastMintEvent = _lastMintEvent;
1489         weekCounter = _currentWeek;
1490     }
1491 
1492     // ========== VIEWS ==========
1493 
1494     /**
1495      * @return The amount of SNX mintable for the inflationary supply
1496      */
1497     function mintableSupply() external view returns (uint) {
1498         uint totalAmount;
1499 
1500         if (!isMintable()) {
1501             return totalAmount;
1502         }
1503 
1504         uint remainingWeeksToMint = weeksSinceLastIssuance();
1505 
1506         uint currentWeek = weekCounter;
1507 
1508         // Calculate total mintable supply from exponential decay function
1509         // The decay function stops after week 234
1510         while (remainingWeeksToMint > 0) {
1511             currentWeek++;
1512 
1513             if (currentWeek < SUPPLY_DECAY_START) {
1514                 // If current week is before supply decay we add initial supply to mintableSupply
1515                 totalAmount = totalAmount.add(INITIAL_WEEKLY_SUPPLY);
1516                 remainingWeeksToMint--;
1517             } else if (currentWeek <= SUPPLY_DECAY_END) {
1518                 // if current week before supply decay ends we add the new supply for the week
1519                 // diff between current week and (supply decay start week - 1)
1520                 uint decayCount = currentWeek.sub(SUPPLY_DECAY_START - 1);
1521 
1522                 totalAmount = totalAmount.add(tokenDecaySupplyForWeek(decayCount));
1523                 remainingWeeksToMint--;
1524             } else {
1525                 // Terminal supply is calculated on the total supply of Synthetix including any new supply
1526                 // We can compound the remaining week's supply at the fixed terminal rate
1527                 uint totalSupply = ISynthetix(synthetixProxy).totalSupply();
1528                 uint currentTotalSupply = totalSupply.add(totalAmount);
1529 
1530                 totalAmount = totalAmount.add(terminalInflationSupply(currentTotalSupply, remainingWeeksToMint));
1531                 remainingWeeksToMint = 0;
1532             }
1533         }
1534 
1535         return totalAmount;
1536     }
1537 
1538     /**
1539      * @return A unit amount of decaying inflationary supply from the INITIAL_WEEKLY_SUPPLY
1540      * @dev New token supply reduces by the decay rate each week calculated as supply = INITIAL_WEEKLY_SUPPLY * ()
1541      */
1542     function tokenDecaySupplyForWeek(uint counter) public pure returns (uint) {
1543         // Apply exponential decay function to number of weeks since
1544         // start of inflation smoothing to calculate diminishing supply for the week.
1545         uint effectiveDecay = (SafeDecimalMath.unit().sub(DECAY_RATE)).powDecimal(counter);
1546         uint supplyForWeek = INITIAL_WEEKLY_SUPPLY.multiplyDecimal(effectiveDecay);
1547 
1548         return supplyForWeek;
1549     }
1550 
1551     /**
1552      * @return A unit amount of terminal inflation supply
1553      * @dev Weekly compound rate based on number of weeks
1554      */
1555     function terminalInflationSupply(uint totalSupply, uint numOfWeeks) public pure returns (uint) {
1556         // rate = (1 + weekly rate) ^ num of weeks
1557         uint effectiveCompoundRate = SafeDecimalMath.unit().add(TERMINAL_SUPPLY_RATE_ANNUAL.div(52)).powDecimal(numOfWeeks);
1558 
1559         // return Supply * (effectiveRate - 1) for extra supply to issue based on number of weeks
1560         return totalSupply.multiplyDecimal(effectiveCompoundRate.sub(SafeDecimalMath.unit()));
1561     }
1562 
1563     /**
1564      * @dev Take timeDiff in seconds (Dividend) and MINT_PERIOD_DURATION as (Divisor)
1565      * @return Calculate the numberOfWeeks since last mint rounded down to 1 week
1566      */
1567     function weeksSinceLastIssuance() public view returns (uint) {
1568         // Get weeks since lastMintEvent
1569         // If lastMintEvent not set or 0, then start from inflation start date.
1570         uint timeDiff = lastMintEvent > 0 ? now.sub(lastMintEvent) : now.sub(INFLATION_START_DATE);
1571         return timeDiff.div(MINT_PERIOD_DURATION);
1572     }
1573 
1574     /**
1575      * @return boolean whether the MINT_PERIOD_DURATION (7 days)
1576      * has passed since the lastMintEvent.
1577      * */
1578     function isMintable() public view returns (bool) {
1579         if (now - lastMintEvent > MINT_PERIOD_DURATION) {
1580             return true;
1581         }
1582         return false;
1583     }
1584 
1585     // ========== MUTATIVE FUNCTIONS ==========
1586 
1587     /**
1588      * @notice Record the mint event from Synthetix by incrementing the inflation
1589      * week counter for the number of weeks minted (probabaly always 1)
1590      * and store the time of the event.
1591      * @param supplyMinted the amount of SNX the total supply was inflated by.
1592      * */
1593     function recordMintEvent(uint supplyMinted) external onlySynthetix returns (bool) {
1594         uint numberOfWeeksIssued = weeksSinceLastIssuance();
1595 
1596         // add number of weeks minted to weekCounter
1597         weekCounter = weekCounter.add(numberOfWeeksIssued);
1598 
1599         // Update mint event to latest week issued (start date + number of weeks issued * seconds in week)
1600         // 1 day time buffer is added so inflation is minted after feePeriod closes
1601         lastMintEvent = INFLATION_START_DATE.add(weekCounter.mul(MINT_PERIOD_DURATION)).add(MINT_BUFFER);
1602 
1603         emit SupplyMinted(supplyMinted, numberOfWeeksIssued, lastMintEvent, now);
1604         return true;
1605     }
1606 
1607     /**
1608      * @notice Sets the reward amount of SNX for the caller of the public
1609      * function Synthetix.mint().
1610      * This incentivises anyone to mint the inflationary supply and the mintr
1611      * Reward will be deducted from the inflationary supply and sent to the caller.
1612      * @param amount the amount of SNX to reward the minter.
1613      * */
1614     function setMinterReward(uint amount) external onlyOwner {
1615         require(amount <= MAX_MINTER_REWARD, "Reward cannot exceed max minter reward");
1616         minterReward = amount;
1617         emit MinterRewardUpdated(minterReward);
1618     }
1619 
1620     // ========== SETTERS ========== */
1621 
1622     /**
1623      * @notice Set the SynthetixProxy should it ever change.
1624      * SupplySchedule requires Synthetix address as it has the authority
1625      * to record mint event.
1626      * */
1627     function setSynthetixProxy(ISynthetix _synthetixProxy) external onlyOwner {
1628         require(_synthetixProxy != address(0), "Address cannot be 0");
1629         synthetixProxy = _synthetixProxy;
1630         emit SynthetixProxyUpdated(synthetixProxy);
1631     }
1632 
1633     // ========== MODIFIERS ==========
1634 
1635     /**
1636      * @notice Only the Synthetix contract is authorised to call this function
1637      * */
1638     modifier onlySynthetix() {
1639         require(
1640             msg.sender == address(Proxy(synthetixProxy).target()),
1641             "Only the synthetix contract can perform this action"
1642         );
1643         _;
1644     }
1645 
1646     /* ========== EVENTS ========== */
1647     /**
1648      * @notice Emitted when the inflationary supply is minted
1649      * */
1650     event SupplyMinted(uint supplyMinted, uint numberOfWeeksIssued, uint lastMintEvent, uint timestamp);
1651 
1652     /**
1653      * @notice Emitted when the SNX minter reward amount is updated
1654      * */
1655     event MinterRewardUpdated(uint newRewardAmount);
1656 
1657     /**
1658      * @notice Emitted when setSynthetixProxy is called changing the Synthetix Proxy address
1659      * */
1660     event SynthetixProxyUpdated(address newAddress);
1661 }
1662 
1663 
1664 /**
1665  * @title RewardsDistribution interface
1666  */
1667 interface IRewardsDistribution {
1668     function distributeRewards(uint amount) external;
1669 }
1670 
1671 
1672 contract IEtherCollateral {
1673     uint256 public totalIssuedSynths;
1674 }
1675 
1676 
1677 // https://docs.synthetix.io/contracts/Synthetix
1678 contract Synthetix is ExternStateToken, MixinResolver {
1679     // ========== STATE VARIABLES ==========
1680 
1681     // Available Synths which can be used with the system
1682     Synth[] public availableSynths;
1683     mapping(bytes32 => Synth) public synths;
1684     mapping(address => bytes32) public synthsByAddress;
1685 
1686     string constant TOKEN_NAME = "Synthetix Network Token";
1687     string constant TOKEN_SYMBOL = "SNX";
1688     uint8 constant DECIMALS = 18;
1689     bytes32 constant sUSD = "sUSD";
1690 
1691     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1692 
1693     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1694     bytes32 private constant CONTRACT_EXCHANGER = "Exchanger";
1695     bytes32 private constant CONTRACT_ETHERCOLLATERAL = "EtherCollateral";
1696     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1697     bytes32 private constant CONTRACT_SYNTHETIXSTATE = "SynthetixState";
1698     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
1699     bytes32 private constant CONTRACT_FEEPOOL = "FeePool";
1700     bytes32 private constant CONTRACT_SUPPLYSCHEDULE = "SupplySchedule";
1701     bytes32 private constant CONTRACT_REWARDESCROW = "RewardEscrow";
1702     bytes32 private constant CONTRACT_SYNTHETIXESCROW = "SynthetixEscrow";
1703     bytes32 private constant CONTRACT_REWARDSDISTRIBUTION = "RewardsDistribution";
1704 
1705     bytes32[24] private addressesToCache = [
1706         CONTRACT_SYSTEMSTATUS,
1707         CONTRACT_EXCHANGER,
1708         CONTRACT_ETHERCOLLATERAL,
1709         CONTRACT_ISSUER,
1710         CONTRACT_SYNTHETIXSTATE,
1711         CONTRACT_EXRATES,
1712         CONTRACT_FEEPOOL,
1713         CONTRACT_SUPPLYSCHEDULE,
1714         CONTRACT_REWARDESCROW,
1715         CONTRACT_SYNTHETIXESCROW,
1716         CONTRACT_REWARDSDISTRIBUTION
1717     ];
1718 
1719     // ========== CONSTRUCTOR ==========
1720 
1721     /**
1722      * @dev Constructor
1723      * @param _proxy The main token address of the Proxy contract. This will be ProxyERC20.sol
1724      * @param _tokenState Address of the external immutable contract containing token balances.
1725      * @param _owner The owner of this contract.
1726      * @param _totalSupply On upgrading set to reestablish the current total supply (This should be in SynthetixState if ever updated)
1727      * @param _resolver The address of the Synthetix Address Resolver
1728      */
1729     constructor(address _proxy, TokenState _tokenState, address _owner, uint _totalSupply, address _resolver)
1730         public
1731         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, _totalSupply, DECIMALS, _owner)
1732         MixinResolver(_owner, _resolver, addressesToCache)
1733     {}
1734 
1735     /* ========== VIEWS ========== */
1736 
1737     function systemStatus() internal view returns (ISystemStatus) {
1738         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS, "Missing SystemStatus address"));
1739     }
1740 
1741     function exchanger() internal view returns (IExchanger) {
1742         return IExchanger(requireAndGetAddress(CONTRACT_EXCHANGER, "Missing Exchanger address"));
1743     }
1744 
1745     function etherCollateral() internal view returns (IEtherCollateral) {
1746         return IEtherCollateral(requireAndGetAddress(CONTRACT_ETHERCOLLATERAL, "Missing EtherCollateral address"));
1747     }
1748 
1749     function issuer() internal view returns (IIssuer) {
1750         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER, "Missing Issuer address"));
1751     }
1752 
1753     function synthetixState() internal view returns (ISynthetixState) {
1754         return ISynthetixState(requireAndGetAddress(CONTRACT_SYNTHETIXSTATE, "Missing SynthetixState address"));
1755     }
1756 
1757     function exchangeRates() internal view returns (IExchangeRates) {
1758         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES, "Missing ExchangeRates address"));
1759     }
1760 
1761     function feePool() internal view returns (IFeePool) {
1762         return IFeePool(requireAndGetAddress(CONTRACT_FEEPOOL, "Missing FeePool address"));
1763     }
1764 
1765     function supplySchedule() internal view returns (SupplySchedule) {
1766         return SupplySchedule(requireAndGetAddress(CONTRACT_SUPPLYSCHEDULE, "Missing SupplySchedule address"));
1767     }
1768 
1769     function rewardEscrow() internal view returns (ISynthetixEscrow) {
1770         return ISynthetixEscrow(requireAndGetAddress(CONTRACT_REWARDESCROW, "Missing RewardEscrow address"));
1771     }
1772 
1773     function synthetixEscrow() internal view returns (ISynthetixEscrow) {
1774         return ISynthetixEscrow(requireAndGetAddress(CONTRACT_SYNTHETIXESCROW, "Missing SynthetixEscrow address"));
1775     }
1776 
1777     function rewardsDistribution() internal view returns (IRewardsDistribution) {
1778         return
1779             IRewardsDistribution(requireAndGetAddress(CONTRACT_REWARDSDISTRIBUTION, "Missing RewardsDistribution address"));
1780     }
1781 
1782     /**
1783      * @notice Total amount of synths issued by the system, priced in currencyKey
1784      * @param currencyKey The currency to value the synths in
1785      */
1786     function _totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) internal view returns (uint) {
1787         IExchangeRates exRates = exchangeRates();
1788         uint total = 0;
1789         uint currencyRate = exRates.rateForCurrency(currencyKey);
1790 
1791         (uint[] memory rates, bool anyRateStale) = exRates.ratesAndStaleForCurrencies(availableCurrencyKeys());
1792         require(!anyRateStale, "Rates are stale");
1793 
1794         for (uint i = 0; i < availableSynths.length; i++) {
1795             // What's the total issued value of that synth in the destination currency?
1796             // Note: We're not using exchangeRates().effectiveValue() because we don't want to go get the
1797             //       rate for the destination currency and check if it's stale repeatedly on every
1798             //       iteration of the loop
1799             uint totalSynths = availableSynths[i].totalSupply();
1800 
1801             // minus total issued synths from Ether Collateral from sETH.totalSupply()
1802             if (excludeEtherCollateral && availableSynths[i] == synths["sETH"]) {
1803                 totalSynths = totalSynths.sub(etherCollateral().totalIssuedSynths());
1804             }
1805 
1806             uint synthValue = totalSynths.multiplyDecimalRound(rates[i]);
1807             total = total.add(synthValue);
1808         }
1809 
1810         return total.divideDecimalRound(currencyRate);
1811     }
1812 
1813     /**
1814      * @notice Total amount of synths issued by the system priced in currencyKey
1815      * @param currencyKey The currency to value the synths in
1816      */
1817     function totalIssuedSynths(bytes32 currencyKey) public view returns (uint) {
1818         return _totalIssuedSynths(currencyKey, false);
1819     }
1820 
1821     /**
1822      * @notice Total amount of synths issued by the system priced in currencyKey, excluding ether collateral
1823      * @param currencyKey The currency to value the synths in
1824      */
1825     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) public view returns (uint) {
1826         return _totalIssuedSynths(currencyKey, true);
1827     }
1828 
1829     /**
1830      * @notice Returns the currencyKeys of availableSynths for rate checking
1831      */
1832     function availableCurrencyKeys() public view returns (bytes32[]) {
1833         bytes32[] memory currencyKeys = new bytes32[](availableSynths.length);
1834 
1835         for (uint i = 0; i < availableSynths.length; i++) {
1836             currencyKeys[i] = synthsByAddress[availableSynths[i]];
1837         }
1838 
1839         return currencyKeys;
1840     }
1841 
1842     /**
1843      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
1844      */
1845     function availableSynthCount() public view returns (uint) {
1846         return availableSynths.length;
1847     }
1848 
1849     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool) {
1850         return exchanger().maxSecsLeftInWaitingPeriod(messageSender, currencyKey) > 0;
1851     }
1852 
1853     // ========== MUTATIVE FUNCTIONS ==========
1854 
1855     /**
1856      * @notice Add an associated Synth contract to the Synthetix system
1857      * @dev Only the contract owner may call this.
1858      */
1859     function addSynth(Synth synth) external optionalProxy_onlyOwner {
1860         bytes32 currencyKey = synth.currencyKey();
1861 
1862         require(synths[currencyKey] == Synth(0), "Synth already exists");
1863         require(synthsByAddress[synth] == bytes32(0), "Synth address already exists");
1864 
1865         availableSynths.push(synth);
1866         synths[currencyKey] = synth;
1867         synthsByAddress[synth] = currencyKey;
1868     }
1869 
1870     /**
1871      * @notice Remove an associated Synth contract from the Synthetix system
1872      * @dev Only the contract owner may call this.
1873      */
1874     function removeSynth(bytes32 currencyKey) external optionalProxy_onlyOwner {
1875         require(synths[currencyKey] != address(0), "Synth does not exist");
1876         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
1877         require(currencyKey != sUSD, "Cannot remove synth");
1878 
1879         // Save the address we're removing for emitting the event at the end.
1880         address synthToRemove = synths[currencyKey];
1881 
1882         // Remove the synth from the availableSynths array.
1883         for (uint i = 0; i < availableSynths.length; i++) {
1884             if (availableSynths[i] == synthToRemove) {
1885                 delete availableSynths[i];
1886 
1887                 // Copy the last synth into the place of the one we just deleted
1888                 // If there's only one synth, this is synths[0] = synths[0].
1889                 // If we're deleting the last one, it's also a NOOP in the same way.
1890                 availableSynths[i] = availableSynths[availableSynths.length - 1];
1891 
1892                 // Decrease the size of the array by one.
1893                 availableSynths.length--;
1894 
1895                 break;
1896             }
1897         }
1898 
1899         // And remove it from the synths mapping
1900         delete synthsByAddress[synths[currencyKey]];
1901         delete synths[currencyKey];
1902 
1903         // Note: No event here as Synthetix contract exceeds max contract size
1904         // with these events, and it's unlikely people will need to
1905         // track these events specifically.
1906 
1907     }
1908 
1909     /**
1910      * @notice ERC20 transfer function.
1911      */
1912     function transfer(address to, uint value) public optionalProxy returns (bool) {
1913         systemStatus().requireSystemActive();
1914 
1915         // Ensure they're not trying to exceed their staked SNX amount
1916         require(value <= transferableSynthetix(messageSender), "Cannot transfer staked or escrowed SNX");
1917 
1918         // Perform the transfer: if there is a problem an exception will be thrown in this call.
1919         _transfer_byProxy(messageSender, to, value);
1920 
1921         return true;
1922     }
1923 
1924     /**
1925      * @notice ERC20 transferFrom function.
1926      */
1927     function transferFrom(address from, address to, uint value) public optionalProxy returns (bool) {
1928         systemStatus().requireSystemActive();
1929 
1930         // Ensure they're not trying to exceed their locked amount
1931         require(value <= transferableSynthetix(from), "Cannot transfer staked or escrowed SNX");
1932 
1933         // Perform the transfer: if there is a problem,
1934         // an exception will be thrown in this call.
1935         return _transferFrom_byProxy(messageSender, from, to, value);
1936     }
1937 
1938     function issueSynths(uint amount) external optionalProxy {
1939         systemStatus().requireIssuanceActive();
1940 
1941         return issuer().issueSynths(messageSender, amount);
1942     }
1943 
1944     function issueSynthsOnBehalf(address issueForAddress, uint amount) external optionalProxy {
1945         systemStatus().requireIssuanceActive();
1946 
1947         return issuer().issueSynthsOnBehalf(issueForAddress, messageSender, amount);
1948     }
1949 
1950     function issueMaxSynths() external optionalProxy {
1951         systemStatus().requireIssuanceActive();
1952 
1953         return issuer().issueMaxSynths(messageSender);
1954     }
1955 
1956     function issueMaxSynthsOnBehalf(address issueForAddress) external optionalProxy {
1957         systemStatus().requireIssuanceActive();
1958 
1959         return issuer().issueMaxSynthsOnBehalf(issueForAddress, messageSender);
1960     }
1961 
1962     function burnSynths(uint amount) external optionalProxy {
1963         systemStatus().requireIssuanceActive();
1964 
1965         return issuer().burnSynths(messageSender, amount);
1966     }
1967 
1968     function burnSynthsOnBehalf(address burnForAddress, uint amount) external optionalProxy {
1969         systemStatus().requireIssuanceActive();
1970 
1971         return issuer().burnSynthsOnBehalf(burnForAddress, messageSender, amount);
1972     }
1973 
1974     function burnSynthsToTarget() external optionalProxy {
1975         systemStatus().requireIssuanceActive();
1976 
1977         return issuer().burnSynthsToTarget(messageSender);
1978     }
1979 
1980     function burnSynthsToTargetOnBehalf(address burnForAddress) external optionalProxy {
1981         systemStatus().requireIssuanceActive();
1982 
1983         return issuer().burnSynthsToTargetOnBehalf(burnForAddress, messageSender);
1984     }
1985 
1986     function exchange(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
1987         external
1988         optionalProxy
1989         returns (uint amountReceived)
1990     {
1991         systemStatus().requireExchangeActive();
1992 
1993         systemStatus().requireSynthsActive(sourceCurrencyKey, destinationCurrencyKey);
1994 
1995         return exchanger().exchange(messageSender, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, messageSender);
1996     }
1997 
1998     function exchangeOnBehalf(
1999         address exchangeForAddress,
2000         bytes32 sourceCurrencyKey,
2001         uint sourceAmount,
2002         bytes32 destinationCurrencyKey
2003     ) external optionalProxy returns (uint amountReceived) {
2004         systemStatus().requireExchangeActive();
2005 
2006         systemStatus().requireSynthsActive(sourceCurrencyKey, destinationCurrencyKey);
2007 
2008         return
2009             exchanger().exchangeOnBehalf(
2010                 exchangeForAddress,
2011                 messageSender,
2012                 sourceCurrencyKey,
2013                 sourceAmount,
2014                 destinationCurrencyKey
2015             );
2016     }
2017 
2018     function settle(bytes32 currencyKey)
2019         external
2020         optionalProxy
2021         returns (uint reclaimed, uint refunded, uint numEntriesSettled)
2022     {
2023         return exchanger().settle(messageSender, currencyKey);
2024     }
2025 
2026     // ========== Issuance/Burning ==========
2027 
2028     /**
2029      * @notice The maximum synths an issuer can issue against their total synthetix quantity.
2030      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
2031      */
2032     function maxIssuableSynths(address _issuer)
2033         public
2034         view
2035         returns (
2036             // We don't need to check stale rates here as effectiveValue will do it for us.
2037             uint
2038         )
2039     {
2040         // What is the value of their SNX balance in the destination currency?
2041         uint destinationValue = exchangeRates().effectiveValue("SNX", collateral(_issuer), sUSD);
2042 
2043         // They're allowed to issue up to issuanceRatio of that value
2044         return destinationValue.multiplyDecimal(synthetixState().issuanceRatio());
2045     }
2046 
2047     /**
2048      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
2049      * as the value of the underlying Synthetix asset changes,
2050      * e.g. based on an issuance ratio of 20%. if a user issues their maximum available
2051      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
2052      * of Synthetix changes, the ratio returned by this function will adjust accordingly. Users are
2053      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
2054      * altering the amount of fees they're able to claim from the system.
2055      */
2056     function collateralisationRatio(address _issuer) public view returns (uint) {
2057         uint totalOwnedSynthetix = collateral(_issuer);
2058         if (totalOwnedSynthetix == 0) return 0;
2059 
2060         uint debtBalance = debtBalanceOf(_issuer, "SNX");
2061         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
2062     }
2063 
2064     /**
2065      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
2066      * will tell you how many synths a user has to give back to the system in order to unlock their original
2067      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
2068      * the debt in sUSD, or any other synth you wish.
2069      */
2070     function debtBalanceOf(address _issuer, bytes32 currencyKey)
2071         public
2072         view
2073         returns (
2074             // Don't need to check for stale rates here because totalIssuedSynths will do it for us
2075             uint
2076         )
2077     {
2078         ISynthetixState state = synthetixState();
2079 
2080         // What was their initial debt ownership?
2081         (uint initialDebtOwnership, ) = state.issuanceData(_issuer);
2082 
2083         // If it's zero, they haven't issued, and they have no debt.
2084         if (initialDebtOwnership == 0) return 0;
2085 
2086         (uint debtBalance, ) = debtBalanceOfAndTotalDebt(_issuer, currencyKey);
2087         return debtBalance;
2088     }
2089 
2090     function debtBalanceOfAndTotalDebt(address _issuer, bytes32 currencyKey)
2091         public
2092         view
2093         returns (uint debtBalance, uint totalSystemValue)
2094     {
2095         ISynthetixState state = synthetixState();
2096 
2097         // What was their initial debt ownership?
2098         uint initialDebtOwnership;
2099         uint debtEntryIndex;
2100         (initialDebtOwnership, debtEntryIndex) = state.issuanceData(_issuer);
2101 
2102         // What's the total value of the system excluding ETH backed synths in their requested currency?
2103         totalSystemValue = totalIssuedSynthsExcludeEtherCollateral(currencyKey);
2104 
2105         // If it's zero, they haven't issued, and they have no debt.
2106         if (initialDebtOwnership == 0) return (0, totalSystemValue);
2107 
2108         // Figure out the global debt percentage delta from when they entered the system.
2109         // This is a high precision integer of 27 (1e27) decimals.
2110         uint currentDebtOwnership = state
2111             .lastDebtLedgerEntry()
2112             .divideDecimalRoundPrecise(state.debtLedger(debtEntryIndex))
2113             .multiplyDecimalRoundPrecise(initialDebtOwnership);
2114 
2115         // Their debt balance is their portion of the total system value.
2116         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal().multiplyDecimalRoundPrecise(
2117             currentDebtOwnership
2118         );
2119 
2120         // Convert back into 18 decimals (1e18)
2121         debtBalance = highPrecisionBalance.preciseDecimalToDecimal();
2122     }
2123 
2124     /**
2125      * @notice The remaining synths an issuer can issue against their total synthetix balance.
2126      * @param _issuer The account that intends to issue
2127      */
2128     function remainingIssuableSynths(address _issuer)
2129         public
2130         view
2131         returns (
2132             // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
2133             uint maxIssuable,
2134             uint alreadyIssued,
2135             uint totalSystemDebt
2136         )
2137     {
2138         (alreadyIssued, totalSystemDebt) = debtBalanceOfAndTotalDebt(_issuer, sUSD);
2139         maxIssuable = maxIssuableSynths(_issuer);
2140 
2141         if (alreadyIssued >= maxIssuable) {
2142             maxIssuable = 0;
2143         } else {
2144             maxIssuable = maxIssuable.sub(alreadyIssued);
2145         }
2146     }
2147 
2148     /**
2149      * @notice The total SNX owned by this account, both escrowed and unescrowed,
2150      * against which synths can be issued.
2151      * This includes those already being used as collateral (locked), and those
2152      * available for further issuance (unlocked).
2153      */
2154     function collateral(address account) public view returns (uint) {
2155         uint balance = tokenState.balanceOf(account);
2156 
2157         if (synthetixEscrow() != address(0)) {
2158             balance = balance.add(synthetixEscrow().balanceOf(account));
2159         }
2160 
2161         if (rewardEscrow() != address(0)) {
2162             balance = balance.add(rewardEscrow().balanceOf(account));
2163         }
2164 
2165         return balance;
2166     }
2167 
2168     /**
2169      * @notice The number of SNX that are free to be transferred for an account.
2170      * @dev Escrowed SNX are not transferable, so they are not included
2171      * in this calculation.
2172      * @notice SNX rate not stale is checked within debtBalanceOf
2173      */
2174     function transferableSynthetix(address account)
2175         public
2176         view
2177         rateNotStale("SNX") // SNX is not a synth so is not checked in totalIssuedSynths
2178         returns (uint)
2179     {
2180         // How many SNX do they have, excluding escrow?
2181         // Note: We're excluding escrow here because we're interested in their transferable amount
2182         // and escrowed SNX are not transferable.
2183         uint balance = tokenState.balanceOf(account);
2184 
2185         // How many of those will be locked by the amount they've issued?
2186         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
2187         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
2188         // The locked synthetix value can exceed their balance.
2189         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState().issuanceRatio());
2190 
2191         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
2192         if (lockedSynthetixValue >= balance) {
2193             return 0;
2194         } else {
2195             return balance.sub(lockedSynthetixValue);
2196         }
2197     }
2198 
2199     /**
2200      * @notice Mints the inflationary SNX supply. The inflation shedule is
2201      * defined in the SupplySchedule contract.
2202      * The mint() function is publicly callable by anyone. The caller will
2203      receive a minter reward as specified in supplySchedule.minterReward().
2204      */
2205     function mint() external returns (bool) {
2206         require(rewardsDistribution() != address(0), "RewardsDistribution not set");
2207 
2208         systemStatus().requireIssuanceActive();
2209 
2210         SupplySchedule _supplySchedule = supplySchedule();
2211         IRewardsDistribution _rewardsDistribution = rewardsDistribution();
2212 
2213         uint supplyToMint = _supplySchedule.mintableSupply();
2214         require(supplyToMint > 0, "No supply is mintable");
2215 
2216         // record minting event before mutation to token supply
2217         _supplySchedule.recordMintEvent(supplyToMint);
2218 
2219         // Set minted SNX balance to RewardEscrow's balance
2220         // Minus the minterReward and set balance of minter to add reward
2221         uint minterReward = _supplySchedule.minterReward();
2222         // Get the remainder
2223         uint amountToDistribute = supplyToMint.sub(minterReward);
2224 
2225         // Set the token balance to the RewardsDistribution contract
2226         tokenState.setBalanceOf(_rewardsDistribution, tokenState.balanceOf(_rewardsDistribution).add(amountToDistribute));
2227         emitTransfer(this, _rewardsDistribution, amountToDistribute);
2228 
2229         // Kick off the distribution of rewards
2230         _rewardsDistribution.distributeRewards(amountToDistribute);
2231 
2232         // Assign the minters reward.
2233         tokenState.setBalanceOf(msg.sender, tokenState.balanceOf(msg.sender).add(minterReward));
2234         emitTransfer(this, msg.sender, minterReward);
2235 
2236         totalSupply = totalSupply.add(supplyToMint);
2237 
2238         return true;
2239     }
2240 
2241     // ========== MODIFIERS ==========
2242 
2243     modifier rateNotStale(bytes32 currencyKey) {
2244         require(!exchangeRates().rateIsStale(currencyKey), "Rate stale or not a synth");
2245         _;
2246     }
2247 
2248     modifier onlyExchanger() {
2249         require(msg.sender == address(exchanger()), "Only the exchanger contract can invoke this function");
2250         _;
2251     }
2252 
2253     // ========== EVENTS ==========
2254     /* solium-disable */
2255     event SynthExchange(
2256         address indexed account,
2257         bytes32 fromCurrencyKey,
2258         uint256 fromAmount,
2259         bytes32 toCurrencyKey,
2260         uint256 toAmount,
2261         address toAddress
2262     );
2263     bytes32 constant SYNTHEXCHANGE_SIG = keccak256("SynthExchange(address,bytes32,uint256,bytes32,uint256,address)");
2264 
2265     function emitSynthExchange(
2266         address account,
2267         bytes32 fromCurrencyKey,
2268         uint256 fromAmount,
2269         bytes32 toCurrencyKey,
2270         uint256 toAmount,
2271         address toAddress
2272     ) external onlyExchanger {
2273         proxy._emit(
2274             abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress),
2275             2,
2276             SYNTHEXCHANGE_SIG,
2277             bytes32(account),
2278             0,
2279             0
2280         );
2281     }
2282 
2283     event ExchangeReclaim(address indexed account, bytes32 currencyKey, uint amount);
2284     bytes32 constant EXCHANGERECLAIM_SIG = keccak256("ExchangeReclaim(address,bytes32,uint256)");
2285 
2286     function emitExchangeReclaim(address account, bytes32 currencyKey, uint256 amount) external onlyExchanger {
2287         proxy._emit(abi.encode(currencyKey, amount), 2, EXCHANGERECLAIM_SIG, bytes32(account), 0, 0);
2288     }
2289 
2290     event ExchangeRebate(address indexed account, bytes32 currencyKey, uint amount);
2291     bytes32 constant EXCHANGEREBATE_SIG = keccak256("ExchangeRebate(address,bytes32,uint256)");
2292 
2293     function emitExchangeRebate(address account, bytes32 currencyKey, uint256 amount) external onlyExchanger {
2294         proxy._emit(abi.encode(currencyKey, amount), 2, EXCHANGEREBATE_SIG, bytes32(account), 0, 0);
2295     }
2296     /* solium-enable */
2297 }
2298 
2299 
2300     