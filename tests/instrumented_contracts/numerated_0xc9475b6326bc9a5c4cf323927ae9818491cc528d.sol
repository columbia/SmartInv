1 /**
2  * ZCNY Token Smart Contract: EIP-20 compatible token smart contract that
3  * manages ZCNY tokens.
4  */
5 
6 /*
7  * Safe Math Smart Contract.
8  */
9 pragma solidity ^0.4.20;
10 
11 /**
12  * Provides methods to safely add, subtract and multiply uint256 numbers.
13  */
14 contract SafeMath {
15   uint256 constant private MAX_UINT256 =
16     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
17 
18   /**
19    * Add two uint256 values, throw in case of overflow.
20    *
21    * @param x first value to add
22    * @param y second value to add
23    * @return x + y
24    */
25   function safeAdd (uint256 x, uint256 y)
26   pure internal
27   returns (uint256 z) {
28     assert (x <= MAX_UINT256 - y);
29     return x + y;
30   }
31 
32   /**
33    * Subtract one uint256 value from another, throw in case of underflow.
34    *
35    * @param x value to subtract from
36    * @param y value to subtract
37    * @return x - y
38    */
39   function safeSub (uint256 x, uint256 y)
40   pure internal
41   returns (uint256 z) {
42     assert (x >= y);
43     return x - y;
44   }
45 
46   /**
47    * Multiply two uint256 values, throw in case of overflow.
48    *
49    * @param x first value to multiply
50    * @param y second value to multiply
51    * @return x * y
52    */
53   function safeMul (uint256 x, uint256 y)
54   pure internal
55   returns (uint256 z) {
56     if (y == 0) return 0; // Prevent division by zero at the next line
57     assert (x <= MAX_UINT256 / y);
58     return x * y;
59   }
60 }
61 
62 contract Token {
63   /**
64    * Get total number of tokens in circulation.
65    *
66    * @return total number of tokens in circulation
67    */
68   function totalSupply () public view returns (uint256 supply);
69 
70   /**
71    * Get number of tokens currently belonging to given owner.
72    *
73    * @param _owner address to get number of tokens currently belonging to the
74    *        owner of
75    * @return number of tokens currently belonging to the owner of given address
76    */
77   function balanceOf (address _owner) public view returns (uint256 balance);
78 
79   /**
80    * Transfer given number of tokens from message sender to given recipient.
81    *
82    * @param _to address to transfer tokens to the owner of
83    * @param _value number of tokens to transfer to the owner of given address
84    * @return true if tokens were transferred successfully, false otherwise
85    */
86   function transfer (address _to, uint256 _value)
87   public payable returns (bool success);
88 
89   /**
90    * Transfer given number of tokens from given owner to given recipient.
91    *
92    * @param _from address to transfer tokens from the owner of
93    * @param _to address to transfer tokens to the owner of
94    * @param _value number of tokens to transfer from given owner to given
95    *        recipient
96    * @return true if tokens were transferred successfully, false otherwise
97    */
98   function transferFrom (address _from, address _to, uint256 _value)
99   public payable returns (bool success);
100 
101   /**
102    * Allow given spender to transfer given number of tokens from message sender.
103    *
104    * @param _spender address to allow the owner of to transfer tokens from
105    *        message sender
106    * @param _value number of tokens to allow to transfer
107    * @return true if token transfer was successfully approved, false otherwise
108    */
109   function approve (address _spender, uint256 _value)
110   public payable returns (bool success);
111 
112   /**
113    * Tell how many tokens given spender is currently allowed to transfer from
114    * given owner.
115    *
116    * @param _owner address to get number of tokens allowed to be transferred
117    *        from the owner of
118    * @param _spender address to get number of tokens allowed to be transferred
119    *        by the owner of
120    * @return number of tokens given spender is currently allowed to transfer
121    *         from given owner
122    */
123   function allowance (address _owner, address _spender)
124   public view returns (uint256 remaining);
125 
126   /**
127    * Logged when tokens were transferred from one owner to another.
128    *
129    * @param _from address of the owner, tokens were transferred from
130    * @param _to address of the owner, tokens were transferred to
131    * @param _value number of tokens transferred
132    */
133   event Transfer (address indexed _from, address indexed _to, uint256 _value);
134 
135   /**
136    * Logged when owner approved his tokens to be transferred by some spender.
137    *
138    * @param _owner owner who approved his tokens to be transferred
139    * @param _spender spender who were allowed to transfer the tokens belonging
140    *        to the owner
141    * @param _value number of tokens belonging to the owner, approved to be
142    *        transferred by the spender
143    */
144   event Approval (
145     address indexed _owner, address indexed _spender, uint256 _value);
146 }
147 
148 contract AbstractToken is Token, SafeMath {
149   /**
150    * Create new Abstract Token contract.
151    */
152   function AbstractToken () public {
153     // Do nothing
154   }
155 
156   /**
157    * Get number of tokens currently belonging to given owner.
158    *
159    * @param _owner address to get number of tokens currently belonging to the
160    *        owner of
161    * @return number of tokens currently belonging to the owner of given address
162    */
163   function balanceOf (address _owner) public view returns (uint256 balance) {
164     return accounts [_owner];
165   }
166 
167   /**
168    * Transfer given number of tokens from message sender to given recipient.
169    *
170    * @param _to address to transfer tokens to the owner of
171    * @param _value number of tokens to transfer to the owner of given address
172    * @return true if tokens were transferred successfully, false otherwise
173    */
174   function transfer (address _to, uint256 _value)
175   public payable returns (bool success) {
176     uint256 fromBalance = accounts [msg.sender];
177     if (fromBalance < _value) return false;
178     if (_value > 0 && msg.sender != _to) {
179       accounts [msg.sender] = safeSub (fromBalance, _value);
180       accounts [_to] = safeAdd (accounts [_to], _value);
181     }
182     Transfer (msg.sender, _to, _value);
183     return true;
184   }
185 
186   /**
187    * Transfer given number of tokens from given owner to given recipient.
188    *
189    * @param _from address to transfer tokens from the owner of
190    * @param _to address to transfer tokens to the owner of
191    * @param _value number of tokens to transfer from given owner to given
192    *        recipient
193    * @return true if tokens were transferred successfully, false otherwise
194    */
195   function transferFrom (address _from, address _to, uint256 _value)
196   public payable returns (bool success) {
197     uint256 spenderAllowance = allowances [_from][msg.sender];
198     if (spenderAllowance < _value) return false;
199     uint256 fromBalance = accounts [_from];
200     if (fromBalance < _value) return false;
201 
202     allowances [_from][msg.sender] =
203       safeSub (spenderAllowance, _value);
204 
205     if (_value > 0 && _from != _to) {
206       accounts [_from] = safeSub (fromBalance, _value);
207       accounts [_to] = safeAdd (accounts [_to], _value);
208     }
209     Transfer (_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * Allow given spender to transfer given number of tokens from message sender.
215    *
216    * @param _spender address to allow the owner of to transfer tokens from
217    *        message sender
218    * @param _value number of tokens to allow to transfer
219    * @return true if token transfer was successfully approved, false otherwise
220    */
221   function approve (address _spender, uint256 _value)
222   public payable returns (bool success) {
223     allowances [msg.sender][_spender] = _value;
224     Approval (msg.sender, _spender, _value);
225 
226     return true;
227   }
228 
229   /**
230    * Tell how many tokens given spender is currently allowed to transfer from
231    * given owner.
232    *
233    * @param _owner address to get number of tokens allowed to be transferred
234    *        from the owner of
235    * @param _spender address to get number of tokens allowed to be transferred
236    *        by the owner of
237    * @return number of tokens given spender is currently allowed to transfer
238    *         from given owner
239    */
240   function allowance (address _owner, address _spender)
241   public view returns (uint256 remaining) {
242     return allowances [_owner][_spender];
243   }
244 
245   /**
246    * Mapping from addresses of token holders to the numbers of tokens belonging
247    * to these token holders.
248    */
249   mapping (address => uint256) internal accounts;
250 
251   /**
252    * Mapping from addresses of token holders to the mapping of addresses of
253    * spenders to the allowances set by these token holders to these spenders.
254    */
255   mapping (address => mapping (address => uint256)) internal allowances;
256 }
257 
258 contract ZCNYToken is AbstractToken {
259   /**
260    * Fee denominator (0.001%).
261    */
262   uint256 constant internal FEE_DENOMINATOR = 100000;
263 
264   /**
265    * Maximum fee numerator (100%).
266    */
267   uint256 constant internal MAX_FEE_NUMERATOR = FEE_DENOMINATOR;
268 
269   /**
270    * Minimum fee numerator (0%).
271    */
272   uint256 constant internal MIN_FEE_NUMERATIOR = 0;
273 
274   /**
275    * Maximum allowed number of tokens in circulation.
276    */
277   uint256 constant internal MAX_TOKENS_COUNT =
278     0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff /
279     MAX_FEE_NUMERATOR;
280 
281   /**
282    * Default transfer fee.
283    */
284   uint256 constant internal DEFAULT_FEE = 5e2;
285 
286   /**
287    * Address flag that marks black listed addresses.
288    */
289   uint256 constant internal BLACK_LIST_FLAG = 0x01;
290 
291   /**
292    * Address flag that marks zero fee addresses.
293    */
294   uint256 constant internal ZERO_FEE_FLAG = 0x02;
295 
296   modifier delegatable {
297     if (delegate == address (0)) {
298       require (msg.value == 0); // Non payable if not delegated
299       _;
300     } else {
301       assembly {
302         // Save owner
303         let oldOwner := sload (owner_slot)
304 
305         // Save delegate
306         let oldDelegate := sload (delegate_slot)
307 
308         // Solidity stores address of the beginning of free memory at 0x40
309         let buffer := mload (0x40)
310 
311         // Copy message call data into buffer
312         calldatacopy (buffer, 0, calldatasize)
313 
314         // Lets call our delegate
315         let result := delegatecall (gas, oldDelegate, buffer, calldatasize, buffer, 0)
316 
317         // Check, whether owner was changed
318         switch eq (oldOwner, sload (owner_slot))
319         case 1 {} // Owner was not changed, fine
320         default {revert (0, 0) } // Owner was changed, revert!
321 
322         // Check, whether delegate was changed
323         switch eq (oldDelegate, sload (delegate_slot))
324         case 1 {} // Delegate was not changed, fine
325         default {revert (0, 0) } // Delegate was changed, revert!
326 
327         // Copy returned value into buffer
328         returndatacopy (buffer, 0, returndatasize)
329 
330         // Check call status
331         switch result
332         case 0 { revert (buffer, returndatasize) } // Call failed, revert!
333         default { return (buffer, returndatasize) } // Call succeeded, return
334       }
335     }
336   }
337 
338   /**
339    * Create ZCNY Token smart contract with message sender as an owner.
340    *
341    * @param _feeCollector address fees are sent to
342    */
343   function ZCNYToken (address _feeCollector) public {
344     fixedFee = DEFAULT_FEE;
345     minVariableFee = 0;
346     maxVariableFee = 0;
347     variableFeeNumerator = 0;
348 
349     owner = msg.sender;
350     feeCollector = _feeCollector;
351   }
352 
353   /**
354    * Delegate unrecognized functions.
355    */
356   function () public delegatable payable {
357     revert (); // Revert if not delegated
358   }
359 
360   /**
361    * Get name of the token.
362    *
363    * @return name of the token
364    */
365   function name () public delegatable view returns (string) {
366     return "ZCNY Token";
367   }
368 
369   /**
370    * Get symbol of the token.
371    *
372    * @return symbol of the token
373    */
374   function symbol () public delegatable view returns (string) {
375     return "ZCNY";
376   }
377 
378   /**
379    * Get number of decimals for the token.
380    *
381    * @return number of decimals for the token
382    */
383   function decimals () public delegatable view returns (uint8) {
384     return 2;
385   }
386 
387   /**
388    * Get total number of tokens in circulation.
389    *
390    * @return total number of tokens in circulation
391    */
392   function totalSupply () public delegatable view returns (uint256) {
393     return tokensCount;
394   }
395 
396   /**
397    * Get number of tokens currently belonging to given owner.
398    *
399    * @param _owner address to get number of tokens currently belonging to the
400    *        owner of
401    * @return number of tokens currently belonging to the owner of given address
402    */
403   function balanceOf (address _owner)
404     public delegatable view returns (uint256 balance) {
405     return AbstractToken.balanceOf (_owner);
406   }
407 
408   /**
409    * Transfer given number of tokens from message sender to given recipient.
410    *
411    * @param _to address to transfer tokens to the owner of
412    * @param _value number of tokens to transfer to the owner of given address
413    * @return true if tokens were transferred successfully, false otherwise
414    */
415   function transfer (address _to, uint256 _value)
416   public delegatable payable returns (bool) {
417     if (frozen) return false;
418     else if (
419       (addressFlags [msg.sender] | addressFlags [_to]) & BLACK_LIST_FLAG ==
420       BLACK_LIST_FLAG)
421       return false;
422     else {
423       uint256 fee =
424         (addressFlags [msg.sender] | addressFlags [_to]) & ZERO_FEE_FLAG == ZERO_FEE_FLAG ?
425           0 :
426           calculateFee (_value);
427 
428       if (_value <= accounts [msg.sender] &&
429           fee <= safeSub (accounts [msg.sender], _value)) {
430         require (AbstractToken.transfer (_to, _value));
431         require (AbstractToken.transfer (feeCollector, fee));
432         return true;
433       } else return false;
434     }
435   }
436 
437   /**
438    * Transfer given number of tokens from given owner to given recipient.
439    *
440    * @param _from address to transfer tokens from the owner of
441    * @param _to address to transfer tokens to the owner of
442    * @param _value number of tokens to transfer from given owner to given
443    *        recipient
444    * @return true if tokens were transferred successfully, false otherwise
445    */
446   function transferFrom (address _from, address _to, uint256 _value)
447   public delegatable payable returns (bool) {
448     if (frozen) return false;
449     else if (
450       (addressFlags [_from] | addressFlags [_to]) & BLACK_LIST_FLAG ==
451       BLACK_LIST_FLAG)
452       return false;
453     else {
454       uint256 fee =
455         (addressFlags [_from] | addressFlags [_to]) & ZERO_FEE_FLAG == ZERO_FEE_FLAG ?
456           0 :
457           calculateFee (_value);
458 
459       if (_value <= allowances [_from][msg.sender] &&
460           fee <= safeSub (allowances [_from][msg.sender], _value) &&
461           _value <= accounts [_from] &&
462           fee <= safeSub (accounts [_from], _value)) {
463         require (AbstractToken.transferFrom (_from, _to, _value));
464         require (AbstractToken.transferFrom (_from, feeCollector, fee));
465         return true;
466       } else return false;
467     }
468   }
469 
470   /**
471    * Allow given spender to transfer given number of tokens from message sender.
472    *
473    * @param _spender address to allow the owner of to transfer tokens from
474    *        message sender
475    * @param _value number of tokens to allow to transfer
476    * @return true if token transfer was successfully approved, false otherwise
477    */
478   function approve (address _spender, uint256 _value)
479   public delegatable payable returns (bool success) {
480     return AbstractToken.approve (_spender, _value);
481   }
482 
483   /**
484    * Tell how many tokens given spender is currently allowed to transfer from
485    * given owner.
486    *
487    * @param _owner address to get number of tokens allowed to be transferred
488    *        from the owner of
489    * @param _spender address to get number of tokens allowed to be transferred
490    *        by the owner of
491    * @return number of tokens given spender is currently allowed to transfer
492    *         from given owner
493    */
494   function allowance (address _owner, address _spender)
495   public delegatable view returns (uint256 remaining) {
496     return AbstractToken.allowance (_owner, _spender);
497   }
498 
499   /**
500    * Transfer given number of token from the signed defined by digital signature
501    * to given recipient.
502    *
503    * @param _to address to transfer token to the owner of
504    * @param _value number of tokens to transfer
505    * @param _fee number of tokens to give to message sender
506    * @param _nonce nonce of the transfer
507    * @param _v parameter V of digital signature
508    * @param _r parameter R of digital signature
509    * @param _s parameter S of digital signature
510    */
511   function delegatedTransfer (
512     address _to, uint256 _value, uint256 _fee,
513     uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s)
514   public delegatable payable returns (bool) {
515     if (frozen) return false;
516     else {
517       address _from = ecrecover (
518         keccak256 (
519           thisAddress (), messageSenderAddress (), _to, _value, _fee, _nonce),
520         _v, _r, _s);
521 
522       if (_nonce != nonces [_from]) return false;
523 
524       if (
525         (addressFlags [_from] | addressFlags [_to]) & BLACK_LIST_FLAG ==
526         BLACK_LIST_FLAG)
527         return false;
528 
529       uint256 fee =
530         (addressFlags [_from] | addressFlags [_to]) & ZERO_FEE_FLAG == ZERO_FEE_FLAG ?
531           0 :
532           calculateFee (_value);
533 
534       uint256 balance = accounts [_from];
535       if (_value > balance) return false;
536       balance = safeSub (balance, _value);
537       if (fee > balance) return false;
538       balance = safeSub (balance, fee);
539       if (_fee > balance) return false;
540       balance = safeSub (balance, _fee);
541 
542       nonces [_from] = _nonce + 1;
543 
544       accounts [_from] = balance;
545       accounts [_to] = safeAdd (accounts [_to], _value);
546       accounts [feeCollector] = safeAdd (accounts [feeCollector], fee);
547       accounts [msg.sender] = safeAdd (accounts [msg.sender], _fee);
548 
549       Transfer (_from, _to, _value);
550       Transfer (_from, feeCollector, fee);
551       Transfer (_from, msg.sender, _fee);
552 
553       return true;
554     }
555   }
556 
557   /**
558    * Create tokens.
559    *
560    * @param _value number of tokens to be created.
561    */
562   function createTokens (uint256 _value)
563   public delegatable payable returns (bool) {
564     require (msg.sender == owner);
565 
566     if (_value > 0) {
567       if (_value <= safeSub (MAX_TOKENS_COUNT, tokensCount)) {
568         accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
569         tokensCount = safeAdd (tokensCount, _value);
570 
571         Transfer (address (0), msg.sender, _value);
572 
573         return true;
574       } else return false;
575     } else return true;
576   }
577 
578   /**
579    * Burn tokens.
580    *
581    * @param _value number of tokens to burn
582    */
583   function burnTokens (uint256 _value)
584   public delegatable payable returns (bool) {
585     require (msg.sender == owner);
586 
587     if (_value > 0) {
588       if (_value <= accounts [msg.sender]) {
589         accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
590         tokensCount = safeSub (tokensCount, _value);
591 
592         Transfer (msg.sender, address (0), _value);
593 
594         return true;
595       } else return false;
596     } else return true;
597   }
598 
599   /**
600    * Freeze token transfers.
601    */
602   function freezeTransfers () public delegatable payable {
603     require (msg.sender == owner);
604 
605     if (!frozen) {
606       frozen = true;
607 
608       Freeze ();
609     }
610   }
611 
612   /**
613    * Unfreeze token transfers.
614    */
615   function unfreezeTransfers () public delegatable payable {
616     require (msg.sender == owner);
617 
618     if (frozen) {
619       frozen = false;
620 
621       Unfreeze ();
622     }
623   }
624 
625   /**
626    * Set smart contract owner.
627    *
628    * @param _newOwner address of the new owner
629    */
630   function setOwner (address _newOwner) public {
631     require (msg.sender == owner);
632 
633     owner = _newOwner;
634   }
635 
636   /**
637    * Set fee collector.
638    *
639    * @param _newFeeCollector address of the new fee collector
640    */
641   function setFeeCollector (address _newFeeCollector)
642   public delegatable payable {
643     require (msg.sender == owner);
644 
645     feeCollector = _newFeeCollector;
646   }
647 
648   /**
649    * Get current nonce for token holder with given address, i.e. nonce this
650    * token holder should use for next delegated transfer.
651    *
652    * @param _owner address of the token holder to get nonce for
653    * @return current nonce for token holder with give address
654    */
655   function nonce (address _owner) public view delegatable returns (uint256) {
656     return nonces [_owner];
657   }
658 
659   /**
660    * Set fee parameters.
661    *
662    * @param _fixedFee fixed fee in token units
663    * @param _minVariableFee minimum variable fee in token units
664    * @param _maxVariableFee maximum variable fee in token units
665    * @param _variableFeeNumerator variable fee numerator
666    */
667   function setFeeParameters (
668     uint256 _fixedFee,
669     uint256 _minVariableFee,
670     uint256 _maxVariableFee,
671     uint256 _variableFeeNumerator) public delegatable payable {
672     require (msg.sender == owner);
673 
674     require (_minVariableFee <= _maxVariableFee);
675     require (_variableFeeNumerator <= MAX_FEE_NUMERATOR);
676 
677     fixedFee = _fixedFee;
678     minVariableFee = _minVariableFee;
679     maxVariableFee = _maxVariableFee;
680     variableFeeNumerator = _variableFeeNumerator;
681 
682     FeeChange (
683       _fixedFee, _minVariableFee, _maxVariableFee, _variableFeeNumerator);
684   }
685 
686   /**
687    * Get fee parameters.
688    *
689    * @return fee parameters
690    */
691   function getFeeParameters () public delegatable view returns (
692     uint256 _fixedFee,
693     uint256 _minVariableFee,
694     uint256 _maxVariableFee,
695     uint256 _variableFeeNumnerator) {
696     _fixedFee = fixedFee;
697     _minVariableFee = minVariableFee;
698     _maxVariableFee = maxVariableFee;
699     _variableFeeNumnerator = variableFeeNumerator;
700   }
701 
702   /**
703    * Calculate fee for transfer of given number of tokens.
704    *
705    * @param _amount transfer amount to calculate fee for
706    * @return fee for transfer of given amount
707    */
708   function calculateFee (uint256 _amount)
709     public delegatable view returns (uint256 _fee) {
710     require (_amount <= MAX_TOKENS_COUNT);
711 
712     _fee = safeMul (_amount, variableFeeNumerator) / FEE_DENOMINATOR;
713     if (_fee < minVariableFee) _fee = minVariableFee;
714     if (_fee > maxVariableFee) _fee = maxVariableFee;
715     _fee = safeAdd (_fee, fixedFee);
716   }
717 
718   /**
719    * Set flags for given address.
720    *
721    * @param _address address to set flags for
722    * @param _flags flags to set
723    */
724   function setFlags (address _address, uint256 _flags)
725   public delegatable payable {
726     require (msg.sender == owner);
727 
728     addressFlags [_address] = _flags;
729   }
730 
731   /**
732    * Get flags for given address.
733    *
734    * @param _address address to get flags for
735    * @return flags for given address
736    */
737   function flags (address _address) public delegatable view returns (uint256) {
738     return addressFlags [_address];
739   }
740 
741   /**
742    * Set address of smart contract to delegate execution of delegatable methods
743    * to.
744    *
745    * @param _delegate address of smart contract to delegate execution of
746    * delegatable methods to, or zero to not delegate delegatable methods
747    * execution.
748    */
749   function setDelegate (address _delegate) public {
750     require (msg.sender == owner);
751 
752     if (delegate != _delegate) {
753       delegate = _delegate;
754       Delegation (delegate);
755     }
756   }
757 
758   /**
759    * Get address of this smart contract.
760    *
761    * @return address of this smart contract
762    */
763   function thisAddress () internal view returns (address) {
764     return this;
765   }
766 
767   /**
768    * Get address of message sender.
769    *
770    * @return address of this smart contract
771    */
772   function messageSenderAddress () internal view returns (address) {
773     return msg.sender;
774   }
775 
776   /**
777    * Owner of the smart contract.
778    */
779   address internal owner;
780 
781   /**
782    * Address where fees are sent to.
783    */
784   address internal feeCollector;
785 
786   /**
787    * Number of tokens in circulation.
788    */
789   uint256 internal tokensCount;
790 
791   /**
792    * Whether token transfers are currently frozen.
793    */
794   bool internal frozen;
795 
796   /**
797    * Mapping from sender's address to the next delegated transfer nonce.
798    */
799   mapping (address => uint256) internal nonces;
800 
801   /**
802    * Fixed fee amount in token units.
803    */
804   uint256 internal fixedFee;
805 
806   /**
807    * Minimum variable fee in token units.
808    */
809   uint256 internal minVariableFee;
810 
811   /**
812    * Maximum variable fee in token units.
813    */
814   uint256 internal maxVariableFee;
815 
816   /**
817    * Variable fee numerator.
818    */
819   uint256 internal variableFeeNumerator;
820 
821   /**
822    * Maps address to its flags.
823    */
824   mapping (address => uint256) internal addressFlags;
825 
826   /**
827    * Address of smart contract to delegate execution of delegatable methods to,
828    * or zero to not delegate delegatable methods execution.
829    */
830   address internal delegate;
831 
832   /**
833    * Logged when token transfers were frozen.
834    */
835   event Freeze ();
836 
837   /**
838    * Logged when token transfers were unfrozen.
839    */
840   event Unfreeze ();
841 
842   /**
843    * Logged when fee parameters were changed.
844    *
845    * @param fixedFee fixed fee in token units
846    * @param minVariableFee minimum variable fee in token units
847    * @param maxVariableFee maximum variable fee in token units
848    * @param variableFeeNumerator variable fee numerator
849    */
850   event FeeChange (
851     uint256 fixedFee,
852     uint256 minVariableFee,
853     uint256 maxVariableFee,
854     uint256 variableFeeNumerator);
855 
856   /**
857    * Logged when address of smart contract execution of delegatable methods is
858    * delegated to was changed.
859    *
860    * @param delegate new address of smart contract execution of delegatable
861    * methods is delegated to or zero if execution of delegatable methods is
862    * oot delegated.
863    */
864   event Delegation (address delegate);
865 }