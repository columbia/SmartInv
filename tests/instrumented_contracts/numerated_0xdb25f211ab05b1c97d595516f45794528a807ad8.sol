1 /**
2  * EURS Token Smart Contract: EIP-20 compatible token smart contract that
3  * manages EURS tokens.
4  */
5 
6 /*
7  * Safe Math Smart Contract.
8  * Copyright (c) 2018 by STSS (Malta) Limited.
9  * Contact: <tech@stasis.net>
10  */
11 pragma solidity ^0.4.20;
12 
13 /**
14  * Provides methods to safely add, subtract and multiply uint256 numbers.
15  */
16 contract SafeMath {
17   uint256 constant private MAX_UINT256 =
18     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
19 
20   /**
21    * Add two uint256 values, throw in case of overflow.
22    *
23    * @param x first value to add
24    * @param y second value to add
25    * @return x + y
26    */
27   function safeAdd (uint256 x, uint256 y)
28   pure internal
29   returns (uint256 z) {
30     assert (x <= MAX_UINT256 - y);
31     return x + y;
32   }
33 
34   /**
35    * Subtract one uint256 value from another, throw in case of underflow.
36    *
37    * @param x value to subtract from
38    * @param y value to subtract
39    * @return x - y
40    */
41   function safeSub (uint256 x, uint256 y)
42   pure internal
43   returns (uint256 z) {
44     assert (x >= y);
45     return x - y;
46   }
47 
48   /**
49    * Multiply two uint256 values, throw in case of overflow.
50    *
51    * @param x first value to multiply
52    * @param y second value to multiply
53    * @return x * y
54    */
55   function safeMul (uint256 x, uint256 y)
56   pure internal
57   returns (uint256 z) {
58     if (y == 0) return 0; // Prevent division by zero at the next line
59     assert (x <= MAX_UINT256 / y);
60     return x * y;
61   }
62 }
63 /*
64  * EIP-20 Standard Token Smart Contract Interface.
65  * Copyright (c) 2018 by STSS (Malta) Limited.
66  * Contact: <tech@stasis.net>
67 
68  * ERC-20 standard token interface, as defined
69  * <a href="https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md">here</a>.
70  */
71 contract Token {
72   /**
73    * Get total number of tokens in circulation.
74    *
75    * @return total number of tokens in circulation
76    */
77   function totalSupply () public view returns (uint256 supply);
78 
79   /**
80    * Get number of tokens currently belonging to given owner.
81    *
82    * @param _owner address to get number of tokens currently belonging to the
83    *        owner of
84    * @return number of tokens currently belonging to the owner of given address
85    */
86   function balanceOf (address _owner) public view returns (uint256 balance);
87 
88   /**
89    * Transfer given number of tokens from message sender to given recipient.
90    *
91    * @param _to address to transfer tokens to the owner of
92    * @param _value number of tokens to transfer to the owner of given address
93    * @return true if tokens were transferred successfully, false otherwise
94    */
95   function transfer (address _to, uint256 _value)
96   public payable returns (bool success);
97 
98   /**
99    * Transfer given number of tokens from given owner to given recipient.
100    *
101    * @param _from address to transfer tokens from the owner of
102    * @param _to address to transfer tokens to the owner of
103    * @param _value number of tokens to transfer from given owner to given
104    *        recipient
105    * @return true if tokens were transferred successfully, false otherwise
106    */
107   function transferFrom (address _from, address _to, uint256 _value)
108   public payable returns (bool success);
109 
110   /**
111    * Allow given spender to transfer given number of tokens from message sender.
112    *
113    * @param _spender address to allow the owner of to transfer tokens from
114    *        message sender
115    * @param _value number of tokens to allow to transfer
116    * @return true if token transfer was successfully approved, false otherwise
117    */
118   function approve (address _spender, uint256 _value)
119   public payable returns (bool success);
120 
121   /**
122    * Tell how many tokens given spender is currently allowed to transfer from
123    * given owner.
124    *
125    * @param _owner address to get number of tokens allowed to be transferred
126    *        from the owner of
127    * @param _spender address to get number of tokens allowed to be transferred
128    *        by the owner of
129    * @return number of tokens given spender is currently allowed to transfer
130    *         from given owner
131    */
132   function allowance (address _owner, address _spender)
133   public view returns (uint256 remaining);
134 
135   /**
136    * Logged when tokens were transferred from one owner to another.
137    *
138    * @param _from address of the owner, tokens were transferred from
139    * @param _to address of the owner, tokens were transferred to
140    * @param _value number of tokens transferred
141    */
142   event Transfer (address indexed _from, address indexed _to, uint256 _value);
143 
144   /**
145    * Logged when owner approved his tokens to be transferred by some spender.
146    *
147    * @param _owner owner who approved his tokens to be transferred
148    * @param _spender spender who were allowed to transfer the tokens belonging
149    *        to the owner
150    * @param _value number of tokens belonging to the owner, approved to be
151    *        transferred by the spender
152    */
153   event Approval (
154     address indexed _owner, address indexed _spender, uint256 _value);
155 }
156 /*
157  * Abstract Token Smart Contract.
158  * Copyright (c) 2018 by STSS (Malta) Limited.
159  * Contact: <tech@stasis.net>
160 
161  * Abstract Token Smart Contract that could be used as a base contract for
162  * ERC-20 token contracts.
163  */
164 contract AbstractToken is Token, SafeMath {
165   /**
166    * Create new Abstract Token contract.
167    */
168   function AbstractToken () public {
169     // Do nothing
170   }
171 
172   /**
173    * Get number of tokens currently belonging to given owner.
174    *
175    * @param _owner address to get number of tokens currently belonging to the
176    *        owner of
177    * @return number of tokens currently belonging to the owner of given address
178    */
179   function balanceOf (address _owner) public view returns (uint256 balance) {
180     return accounts [_owner];
181   }
182 
183   /**
184    * Transfer given number of tokens from message sender to given recipient.
185    *
186    * @param _to address to transfer tokens to the owner of
187    * @param _value number of tokens to transfer to the owner of given address
188    * @return true if tokens were transferred successfully, false otherwise
189    */
190   function transfer (address _to, uint256 _value)
191   public payable returns (bool success) {
192     uint256 fromBalance = accounts [msg.sender];
193     if (fromBalance < _value) return false;
194     if (_value > 0 && msg.sender != _to) {
195       accounts [msg.sender] = safeSub (fromBalance, _value);
196       accounts [_to] = safeAdd (accounts [_to], _value);
197     }
198     Transfer (msg.sender, _to, _value);
199     return true;
200   }
201 
202   /**
203    * Transfer given number of tokens from given owner to given recipient.
204    *
205    * @param _from address to transfer tokens from the owner of
206    * @param _to address to transfer tokens to the owner of
207    * @param _value number of tokens to transfer from given owner to given
208    *        recipient
209    * @return true if tokens were transferred successfully, false otherwise
210    */
211   function transferFrom (address _from, address _to, uint256 _value)
212   public payable returns (bool success) {
213     uint256 spenderAllowance = allowances [_from][msg.sender];
214     if (spenderAllowance < _value) return false;
215     uint256 fromBalance = accounts [_from];
216     if (fromBalance < _value) return false;
217 
218     allowances [_from][msg.sender] =
219       safeSub (spenderAllowance, _value);
220 
221     if (_value > 0 && _from != _to) {
222       accounts [_from] = safeSub (fromBalance, _value);
223       accounts [_to] = safeAdd (accounts [_to], _value);
224     }
225     Transfer (_from, _to, _value);
226     return true;
227   }
228 
229   /**
230    * Allow given spender to transfer given number of tokens from message sender.
231    *
232    * @param _spender address to allow the owner of to transfer tokens from
233    *        message sender
234    * @param _value number of tokens to allow to transfer
235    * @return true if token transfer was successfully approved, false otherwise
236    */
237   function approve (address _spender, uint256 _value)
238   public payable returns (bool success) {
239     allowances [msg.sender][_spender] = _value;
240     Approval (msg.sender, _spender, _value);
241 
242     return true;
243   }
244 
245   /**
246    * Tell how many tokens given spender is currently allowed to transfer from
247    * given owner.
248    *
249    * @param _owner address to get number of tokens allowed to be transferred
250    *        from the owner of
251    * @param _spender address to get number of tokens allowed to be transferred
252    *        by the owner of
253    * @return number of tokens given spender is currently allowed to transfer
254    *         from given owner
255    */
256   function allowance (address _owner, address _spender)
257   public view returns (uint256 remaining) {
258     return allowances [_owner][_spender];
259   }
260 
261   /**
262    * Mapping from addresses of token holders to the numbers of tokens belonging
263    * to these token holders.
264    */
265   mapping (address => uint256) internal accounts;
266 
267   /**
268    * Mapping from addresses of token holders to the mapping of addresses of
269    * spenders to the allowances set by these token holders to these spenders.
270    */
271   mapping (address => mapping (address => uint256)) internal allowances;
272 }
273 
274 /*
275  * EURS Token Smart Contract.
276  * Copyright (c) 2018 by STSS (Malta) Limited.
277  * Contact: <tech@stasis.net>
278  */
279 
280 contract EURSToken is AbstractToken {
281   /**
282    * Fee denominator (0.001%).
283    */
284   uint256 constant internal FEE_DENOMINATOR = 100000;
285 
286   /**
287    * Maximum fee numerator (100%).
288    */
289   uint256 constant internal MAX_FEE_NUMERATOR = FEE_DENOMINATOR;
290 
291   /**
292    * Minimum fee numerator (0%).
293    */
294   uint256 constant internal MIN_FEE_NUMERATIOR = 0;
295 
296   /**
297    * Maximum allowed number of tokens in circulation.
298    */
299   uint256 constant internal MAX_TOKENS_COUNT =
300     0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff /
301     MAX_FEE_NUMERATOR;
302 
303   /**
304    * Default transfer fee.
305    */
306   uint256 constant internal DEFAULT_FEE = 5e2;
307 
308   /**
309    * Address flag that marks black listed addresses.
310    */
311   uint256 constant internal BLACK_LIST_FLAG = 0x01;
312 
313   /**
314    * Address flag that marks zero fee addresses.
315    */
316   uint256 constant internal ZERO_FEE_FLAG = 0x02;
317 
318   modifier delegatable {
319     if (delegate == address (0)) {
320       require (msg.value == 0); // Non payable if not delegated
321       _;
322     } else {
323       assembly {
324         // Save owner
325         let oldOwner := sload (owner_slot)
326 
327         // Save delegate
328         let oldDelegate := sload (delegate_slot)
329 
330         // Solidity stores address of the beginning of free memory at 0x40
331         let buffer := mload (0x40)
332 
333         // Copy message call data into buffer
334         calldatacopy (buffer, 0, calldatasize)
335 
336         // Lets call our delegate
337         let result := delegatecall (gas, oldDelegate, buffer, calldatasize, buffer, 0)
338 
339         // Check, whether owner was changed
340         switch eq (oldOwner, sload (owner_slot))
341         case 1 {} // Owner was not changed, fine
342         default {revert (0, 0) } // Owner was changed, revert!
343 
344         // Check, whether delegate was changed
345         switch eq (oldDelegate, sload (delegate_slot))
346         case 1 {} // Delegate was not changed, fine
347         default {revert (0, 0) } // Delegate was changed, revert!
348 
349         // Copy returned value into buffer
350         returndatacopy (buffer, 0, returndatasize)
351 
352         // Check call status
353         switch result
354         case 0 { revert (buffer, returndatasize) } // Call failed, revert!
355         default { return (buffer, returndatasize) } // Call succeeded, return
356       }
357     }
358   }
359 
360   /**
361    * Create EURS Token smart contract with message sender as an owner.
362    *
363    * @param _feeCollector address fees are sent to
364    */
365   function EURSToken (address _feeCollector) public {
366     fixedFee = DEFAULT_FEE;
367     minVariableFee = 0;
368     maxVariableFee = 0;
369     variableFeeNumerator = 0;
370 
371     owner = msg.sender;
372     feeCollector = _feeCollector;
373   }
374 
375   /**
376    * Delegate unrecognized functions.
377    */
378   function () public delegatable payable {
379     revert (); // Revert if not delegated
380   }
381 
382   /**
383    * Get name of the token.
384    *
385    * @return name of the token
386    */
387   function name () public delegatable view returns (string) {
388     return "STASIS EURS Token";
389   }
390 
391   /**
392    * Get symbol of the token.
393    *
394    * @return symbol of the token
395    */
396   function symbol () public delegatable view returns (string) {
397     return "EURS";
398   }
399 
400   /**
401    * Get number of decimals for the token.
402    *
403    * @return number of decimals for the token
404    */
405   function decimals () public delegatable view returns (uint8) {
406     return 2;
407   }
408 
409   /**
410    * Get total number of tokens in circulation.
411    *
412    * @return total number of tokens in circulation
413    */
414   function totalSupply () public delegatable view returns (uint256) {
415     return tokensCount;
416   }
417 
418   /**
419    * Get number of tokens currently belonging to given owner.
420    *
421    * @param _owner address to get number of tokens currently belonging to the
422    *        owner of
423    * @return number of tokens currently belonging to the owner of given address
424    */
425   function balanceOf (address _owner)
426     public delegatable view returns (uint256 balance) {
427     return AbstractToken.balanceOf (_owner);
428   }
429 
430   /**
431    * Transfer given number of tokens from message sender to given recipient.
432    *
433    * @param _to address to transfer tokens to the owner of
434    * @param _value number of tokens to transfer to the owner of given address
435    * @return true if tokens were transferred successfully, false otherwise
436    */
437   function transfer (address _to, uint256 _value)
438   public delegatable payable returns (bool) {
439     if (frozen) return false;
440     else if (
441       (addressFlags [msg.sender] | addressFlags [_to]) & BLACK_LIST_FLAG ==
442       BLACK_LIST_FLAG)
443       return false;
444     else {
445       uint256 fee =
446         (addressFlags [msg.sender] | addressFlags [_to]) & ZERO_FEE_FLAG == ZERO_FEE_FLAG ?
447           0 :
448           calculateFee (_value);
449 
450       if (_value <= accounts [msg.sender] &&
451           fee <= safeSub (accounts [msg.sender], _value)) {
452         require (AbstractToken.transfer (_to, _value));
453         require (AbstractToken.transfer (feeCollector, fee));
454         return true;
455       } else return false;
456     }
457   }
458 
459   /**
460    * Transfer given number of tokens from given owner to given recipient.
461    *
462    * @param _from address to transfer tokens from the owner of
463    * @param _to address to transfer tokens to the owner of
464    * @param _value number of tokens to transfer from given owner to given
465    *        recipient
466    * @return true if tokens were transferred successfully, false otherwise
467    */
468   function transferFrom (address _from, address _to, uint256 _value)
469   public delegatable payable returns (bool) {
470     if (frozen) return false;
471     else if (
472       (addressFlags [_from] | addressFlags [_to]) & BLACK_LIST_FLAG ==
473       BLACK_LIST_FLAG)
474       return false;
475     else {
476       uint256 fee =
477         (addressFlags [_from] | addressFlags [_to]) & ZERO_FEE_FLAG == ZERO_FEE_FLAG ?
478           0 :
479           calculateFee (_value);
480 
481       if (_value <= allowances [_from][msg.sender] &&
482           fee <= safeSub (allowances [_from][msg.sender], _value) &&
483           _value <= accounts [_from] &&
484           fee <= safeSub (accounts [_from], _value)) {
485         require (AbstractToken.transferFrom (_from, _to, _value));
486         require (AbstractToken.transferFrom (_from, feeCollector, fee));
487         return true;
488       } else return false;
489     }
490   }
491 
492   /**
493    * Allow given spender to transfer given number of tokens from message sender.
494    *
495    * @param _spender address to allow the owner of to transfer tokens from
496    *        message sender
497    * @param _value number of tokens to allow to transfer
498    * @return true if token transfer was successfully approved, false otherwise
499    */
500   function approve (address _spender, uint256 _value)
501   public delegatable payable returns (bool success) {
502     return AbstractToken.approve (_spender, _value);
503   }
504 
505   /**
506    * Tell how many tokens given spender is currently allowed to transfer from
507    * given owner.
508    *
509    * @param _owner address to get number of tokens allowed to be transferred
510    *        from the owner of
511    * @param _spender address to get number of tokens allowed to be transferred
512    *        by the owner of
513    * @return number of tokens given spender is currently allowed to transfer
514    *         from given owner
515    */
516   function allowance (address _owner, address _spender)
517   public delegatable view returns (uint256 remaining) {
518     return AbstractToken.allowance (_owner, _spender);
519   }
520 
521   /**
522    * Transfer given number of token from the signed defined by digital signature
523    * to given recipient.
524    *
525    * @param _to address to transfer token to the owner of
526    * @param _value number of tokens to transfer
527    * @param _fee number of tokens to give to message sender
528    * @param _nonce nonce of the transfer
529    * @param _v parameter V of digital signature
530    * @param _r parameter R of digital signature
531    * @param _s parameter S of digital signature
532    */
533   function delegatedTransfer (
534     address _to, uint256 _value, uint256 _fee,
535     uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s)
536   public delegatable payable returns (bool) {
537     if (frozen) return false;
538     else {
539       address _from = ecrecover (
540         keccak256 (
541           thisAddress (), messageSenderAddress (), _to, _value, _fee, _nonce),
542         _v, _r, _s);
543 
544       if (_nonce != nonces [_from]) return false;
545 
546       if (
547         (addressFlags [_from] | addressFlags [_to]) & BLACK_LIST_FLAG ==
548         BLACK_LIST_FLAG)
549         return false;
550 
551       uint256 fee =
552         (addressFlags [_from] | addressFlags [_to]) & ZERO_FEE_FLAG == ZERO_FEE_FLAG ?
553           0 :
554           calculateFee (_value);
555 
556       uint256 balance = accounts [_from];
557       if (_value > balance) return false;
558       balance = safeSub (balance, _value);
559       if (fee > balance) return false;
560       balance = safeSub (balance, fee);
561       if (_fee > balance) return false;
562       balance = safeSub (balance, _fee);
563 
564       nonces [_from] = _nonce + 1;
565 
566       accounts [_from] = balance;
567       accounts [_to] = safeAdd (accounts [_to], _value);
568       accounts [feeCollector] = safeAdd (accounts [feeCollector], fee);
569       accounts [msg.sender] = safeAdd (accounts [msg.sender], _fee);
570 
571       Transfer (_from, _to, _value);
572       Transfer (_from, feeCollector, fee);
573       Transfer (_from, msg.sender, _fee);
574 
575       return true;
576     }
577   }
578 
579   /**
580    * Create tokens.
581    *
582    * @param _value number of tokens to be created.
583    */
584   function createTokens (uint256 _value)
585   public delegatable payable returns (bool) {
586     require (msg.sender == owner);
587 
588     if (_value > 0) {
589       if (_value <= safeSub (MAX_TOKENS_COUNT, tokensCount)) {
590         accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
591         tokensCount = safeAdd (tokensCount, _value);
592 
593         Transfer (address (0), msg.sender, _value);
594 
595         return true;
596       } else return false;
597     } else return true;
598   }
599 
600   /**
601    * Burn tokens.
602    *
603    * @param _value number of tokens to burn
604    */
605   function burnTokens (uint256 _value)
606   public delegatable payable returns (bool) {
607     require (msg.sender == owner);
608 
609     if (_value > 0) {
610       if (_value <= accounts [msg.sender]) {
611         accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
612         tokensCount = safeSub (tokensCount, _value);
613 
614         Transfer (msg.sender, address (0), _value);
615 
616         return true;
617       } else return false;
618     } else return true;
619   }
620 
621   /**
622    * Freeze token transfers.
623    */
624   function freezeTransfers () public delegatable payable {
625     require (msg.sender == owner);
626 
627     if (!frozen) {
628       frozen = true;
629 
630       Freeze ();
631     }
632   }
633 
634   /**
635    * Unfreeze token transfers.
636    */
637   function unfreezeTransfers () public delegatable payable {
638     require (msg.sender == owner);
639 
640     if (frozen) {
641       frozen = false;
642 
643       Unfreeze ();
644     }
645   }
646 
647   /**
648    * Set smart contract owner.
649    *
650    * @param _newOwner address of the new owner
651    */
652   function setOwner (address _newOwner) public {
653     require (msg.sender == owner);
654 
655     owner = _newOwner;
656   }
657 
658   /**
659    * Set fee collector.
660    *
661    * @param _newFeeCollector address of the new fee collector
662    */
663   function setFeeCollector (address _newFeeCollector)
664   public delegatable payable {
665     require (msg.sender == owner);
666 
667     feeCollector = _newFeeCollector;
668   }
669 
670   /**
671    * Get current nonce for token holder with given address, i.e. nonce this
672    * token holder should use for next delegated transfer.
673    *
674    * @param _owner address of the token holder to get nonce for
675    * @return current nonce for token holder with give address
676    */
677   function nonce (address _owner) public view delegatable returns (uint256) {
678     return nonces [_owner];
679   }
680 
681   /**
682    * Set fee parameters.
683    *
684    * @param _fixedFee fixed fee in token units
685    * @param _minVariableFee minimum variable fee in token units
686    * @param _maxVariableFee maximum variable fee in token units
687    * @param _variableFeeNumerator variable fee numerator
688    */
689   function setFeeParameters (
690     uint256 _fixedFee,
691     uint256 _minVariableFee,
692     uint256 _maxVariableFee,
693     uint256 _variableFeeNumerator) public delegatable payable {
694     require (msg.sender == owner);
695 
696     require (_minVariableFee <= _maxVariableFee);
697     require (_variableFeeNumerator <= MAX_FEE_NUMERATOR);
698 
699     fixedFee = _fixedFee;
700     minVariableFee = _minVariableFee;
701     maxVariableFee = _maxVariableFee;
702     variableFeeNumerator = _variableFeeNumerator;
703 
704     FeeChange (
705       _fixedFee, _minVariableFee, _maxVariableFee, _variableFeeNumerator);
706   }
707 
708   /**
709    * Get fee parameters.
710    *
711    * @return fee parameters
712    */
713   function getFeeParameters () public delegatable view returns (
714     uint256 _fixedFee,
715     uint256 _minVariableFee,
716     uint256 _maxVariableFee,
717     uint256 _variableFeeNumnerator) {
718     _fixedFee = fixedFee;
719     _minVariableFee = minVariableFee;
720     _maxVariableFee = maxVariableFee;
721     _variableFeeNumnerator = variableFeeNumerator;
722   }
723 
724   /**
725    * Calculate fee for transfer of given number of tokens.
726    *
727    * @param _amount transfer amount to calculate fee for
728    * @return fee for transfer of given amount
729    */
730   function calculateFee (uint256 _amount)
731     public delegatable view returns (uint256 _fee) {
732     require (_amount <= MAX_TOKENS_COUNT);
733 
734     _fee = safeMul (_amount, variableFeeNumerator) / FEE_DENOMINATOR;
735     if (_fee < minVariableFee) _fee = minVariableFee;
736     if (_fee > maxVariableFee) _fee = maxVariableFee;
737     _fee = safeAdd (_fee, fixedFee);
738   }
739 
740   /**
741    * Set flags for given address.
742    *
743    * @param _address address to set flags for
744    * @param _flags flags to set
745    */
746   function setFlags (address _address, uint256 _flags)
747   public delegatable payable {
748     require (msg.sender == owner);
749 
750     addressFlags [_address] = _flags;
751   }
752 
753   /**
754    * Get flags for given address.
755    *
756    * @param _address address to get flags for
757    * @return flags for given address
758    */
759   function flags (address _address) public delegatable view returns (uint256) {
760     return addressFlags [_address];
761   }
762 
763   /**
764    * Set address of smart contract to delegate execution of delegatable methods
765    * to.
766    *
767    * @param _delegate address of smart contract to delegate execution of
768    * delegatable methods to, or zero to not delegate delegatable methods
769    * execution.
770    */
771   function setDelegate (address _delegate) public {
772     require (msg.sender == owner);
773 
774     if (delegate != _delegate) {
775       delegate = _delegate;
776       Delegation (delegate);
777     }
778   }
779 
780   /**
781    * Get address of this smart contract.
782    *
783    * @return address of this smart contract
784    */
785   function thisAddress () internal view returns (address) {
786     return this;
787   }
788 
789   /**
790    * Get address of message sender.
791    *
792    * @return address of this smart contract
793    */
794   function messageSenderAddress () internal view returns (address) {
795     return msg.sender;
796   }
797 
798   /**
799    * Owner of the smart contract.
800    */
801   address internal owner;
802 
803   /**
804    * Address where fees are sent to.
805    */
806   address internal feeCollector;
807 
808   /**
809    * Number of tokens in circulation.
810    */
811   uint256 internal tokensCount;
812 
813   /**
814    * Whether token transfers are currently frozen.
815    */
816   bool internal frozen;
817 
818   /**
819    * Mapping from sender's address to the next delegated transfer nonce.
820    */
821   mapping (address => uint256) internal nonces;
822 
823   /**
824    * Fixed fee amount in token units.
825    */
826   uint256 internal fixedFee;
827 
828   /**
829    * Minimum variable fee in token units.
830    */
831   uint256 internal minVariableFee;
832 
833   /**
834    * Maximum variable fee in token units.
835    */
836   uint256 internal maxVariableFee;
837 
838   /**
839    * Variable fee numerator.
840    */
841   uint256 internal variableFeeNumerator;
842 
843   /**
844    * Maps address to its flags.
845    */
846   mapping (address => uint256) internal addressFlags;
847 
848   /**
849    * Address of smart contract to delegate execution of delegatable methods to,
850    * or zero to not delegate delegatable methods execution.
851    */
852   address internal delegate;
853 
854   /**
855    * Logged when token transfers were frozen.
856    */
857   event Freeze ();
858 
859   /**
860    * Logged when token transfers were unfrozen.
861    */
862   event Unfreeze ();
863 
864   /**
865    * Logged when fee parameters were changed.
866    *
867    * @param fixedFee fixed fee in token units
868    * @param minVariableFee minimum variable fee in token units
869    * @param maxVariableFee maximum variable fee in token units
870    * @param variableFeeNumerator variable fee numerator
871    */
872   event FeeChange (
873     uint256 fixedFee,
874     uint256 minVariableFee,
875     uint256 maxVariableFee,
876     uint256 variableFeeNumerator);
877 
878   /**
879    * Logged when address of smart contract execution of delegatable methods is
880    * delegated to was changed.
881    *
882    * @param delegate new address of smart contract execution of delegatable
883    * methods is delegated to or zero if execution of delegatable methods is
884    * oot delegated.
885    */
886   event Delegation (address delegate);
887 }