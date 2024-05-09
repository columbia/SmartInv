1 /*
2  * Safe Math Smart Contract.
3  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
4  */
5 pragma solidity ^0.4.16;
6 
7 /**
8  * Provides methods to safely add, subtract and multiply uint256 numbers.
9  */
10 contract SafeMath {
11   uint256 constant private MAX_UINT256 =
12     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
13 
14   /**
15    * Add two uint256 values, throw in case of overflow.
16    *
17    * @param x first value to add
18    * @param y second value to add
19    * @return x + y
20    */
21   function safeAdd (uint256 x, uint256 y)
22   constant internal
23   returns (uint256 z) {
24     assert (x <= MAX_UINT256 - y);
25     return x + y;
26   }
27 
28   /**
29    * Subtract one uint256 value from another, throw in case of underflow.
30    *
31    * @param x value to subtract from
32    * @param y value to subtract
33    * @return x - y
34    */
35   function safeSub (uint256 x, uint256 y)
36   constant internal
37   returns (uint256 z) {
38     assert (x >= y);
39     return x - y;
40   }
41 
42   /**
43    * Multiply two uint256 values, throw in case of overflow.
44    *
45    * @param x first value to multiply
46    * @param y second value to multiply
47    * @return x * y
48    */
49   function safeMul (uint256 x, uint256 y)
50   constant internal
51   returns (uint256 z) {
52     if (y == 0) return 0; // Prevent division by zero at the next line
53     assert (x <= MAX_UINT256 / y);
54     return x * y;
55   }
56 } 
57 
58 /*
59  * ERC-20 Standard Token Smart Contract Interface.
60  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
61  */
62 pragma solidity ^0.4.16;
63 
64 /**
65  * ERC-20 standard token interface, as defined
66  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
67  */
68 contract Token {
69   /**
70    * Get total number of tokens in circulation.
71    *
72    * @return total number of tokens in circulation
73    */
74   function totalSupply () constant returns (uint256 supply);
75 
76   /**
77    * Get number of tokens currently belonging to given owner.
78    *
79    * @param _owner address to get number of tokens currently belonging to the
80    *        owner of
81    * @return number of tokens currently belonging to the owner of given address
82    */
83   function balanceOf (address _owner) constant returns (uint256 balance);
84 
85   /**
86    * Transfer given number of tokens from message sender to given recipient.
87    *
88    * @param _to address to transfer tokens to the owner of
89    * @param _value number of tokens to transfer to the owner of given address
90    * @return true if tokens were transferred successfully, false otherwise
91    */
92   function transfer (address _to, uint256 _value) returns (bool success);
93 
94   /**
95    * Transfer given number of tokens from given owner to given recipient.
96    *
97    * @param _from address to transfer tokens from the owner of
98    * @param _to address to transfer tokens to the owner of
99    * @param _value number of tokens to transfer from given owner to given
100    *        recipient
101    * @return true if tokens were transferred successfully, false otherwise
102    */
103   function transferFrom (address _from, address _to, uint256 _value)
104   returns (bool success);
105 
106   /**
107    * Allow given spender to transfer given number of tokens from message sender.
108    *
109    * @param _spender address to allow the owner of to transfer tokens from
110    *        message sender
111    * @param _value number of tokens to allow to transfer
112    * @return true if token transfer was successfully approved, false otherwise
113    */
114   function approve (address _spender, uint256 _value) returns (bool success);
115 
116   /**
117    * Tell how many tokens given spender is currently allowed to transfer from
118    * given owner.
119    *
120    * @param _owner address to get number of tokens allowed to be transferred
121    *        from the owner of
122    * @param _spender address to get number of tokens allowed to be transferred
123    *        by the owner of
124    * @return number of tokens given spender is currently allowed to transfer
125    *         from given owner
126    */
127   function allowance (address _owner, address _spender) constant
128   returns (uint256 remaining);
129 
130   /**
131    * Logged when tokens were transferred from one owner to another.
132    *
133    * @param _from address of the owner, tokens were transferred from
134    * @param _to address of the owner, tokens were transferred to
135    * @param _value number of tokens transferred
136    */
137   event Transfer (address indexed _from, address indexed _to, uint256 _value);
138 
139   /**
140    * Logged when owner approved his tokens to be transferred by some spender.
141    *
142    * @param _owner owner who approved his tokens to be transferred
143    * @param _spender spender who were allowed to transfer the tokens belonging
144    *        to the owner
145    * @param _value number of tokens belonging to the owner, approved to be
146    *        transferred by the spender
147    */
148   event Approval (
149     address indexed _owner, address indexed _spender, uint256 _value);
150 } 
151 
152 /*
153  * Abstract base contract for Token Smart Contracts that may create snapshots of
154  * token holder balances.
155  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
156  */
157 pragma solidity ^0.4.16;
158 
159 
160 /**
161  * Abstract base contract Token Smart Contracts that support snapshots of token
162  * holder balances.
163  */
164 contract AbstractSnapshottableToken is SafeMath, Token {
165   /**
166    * Maximum number of tokens in circulation (2^256 - 1).
167    */
168   uint256 constant MAX_TOKENS = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
169 
170   /**
171    * Maximum value of uint256 type, i.e. 2^256-1.
172    */
173   uint256 constant MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
174 
175   /**
176    * Maximum value of address represented as uint256, i.e. 2^160-1.
177    */
178   uint256 constant MAX_ADDRESS = 0x00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
179 
180   /**
181    * 2^160.
182    */
183   uint256 constant TWO_160 = 0x00010000000000000000000000000000000000000000;
184 
185   /**
186    * Create new Abstract Snapshottable Token smart contract.
187    */
188   function AbstractSnapshottableToken () {
189     snapshots.length = 1; // Reserve zero ID.
190   }
191 
192   /**
193    * Get total number of tokens in circulation.
194    *
195    * @return total number of tokens in circulation
196    */
197   function totalSupply () constant returns (uint256 supply) {
198     return tokensCount;
199   }
200 
201   /**
202    * Get total number of tokens in circulation as is was at the moment when
203    * snapshot with given index was created.
204    *
205    * @param _index index of the snapshot to get total number of tokens in
206    *        circulation at the moment of
207    * @return total number of tokens in circulation at the moment snapshot with
208    *         given index was created
209    */
210   function totalSupplyAt (uint256 _index) constant returns (uint256 supply) {
211     require (_index > 0);
212     require (_index < snapshots.length);
213 
214     return snapshots [_index].tokensCount;
215   }
216 
217   /**
218    * Get number of tokens currently belonging to the owner of given address.
219    *
220    * @param _owner address to get number of tokens currently belonging to the
221    *        owner of
222    * @return number of tokens currently belonging to the owner of given address
223    */
224   function balanceOf (address _owner) constant returns (uint256 balance) {
225     return accounts [_owner].balance;
226   }
227 
228   /**
229    * Get number of tokens owner of the given address had at the moment when
230    * snapshot with given index was created.
231    *
232    * @param _owner address to get number of tokens for the owner of
233    * @param _index index of the snapshot to get number of tokens at the time of
234    * @return number of tokens owner of the given address had at the moment the
235    *         snapshot with given index was created
236    */
237   function balanceOfAt (address _owner, uint256 _index)
238     constant returns (uint256 balance) {
239     require (_index > 0);
240     require (_index < snapshots.length);
241 
242     if (_index > accounts [_owner].lastSnapshotIndex)
243       return accounts [_owner].balance;
244     else {
245       uint8 level = 0;
246       while (_index > 0) {
247         uint256 v = historicalBalances [_owner][level][_index];
248         if (v != 0) return v;
249 
250         _index >>= 1;
251         level += 1; // Overflow is possible here, but is harmless
252       }
253 
254       return 0;
255     }
256   }
257 
258   /**
259    * Get first address that probably had non-zero token balance at the moment
260    * snapshot with given index was created.
261    *
262    * @param _index index of the snapshot to get first address the probably had
263    *        non-zero token balance at the moment of
264    * @return flag that tells whether there is at least one address that probably
265    *         had non-zero token balance at the moment of snapshot with given
266    *         index (hasResult); and the fist address that probably had non-zero
267    *         token balance at the moment snapshot with given index was created
268    *         or zero if there are no such addresses (result)
269    */
270   function firstAddressAt (uint256 _index)
271     constant returns (bool hasResult, address result) {
272     require (_index > 0);
273     require (_index < snapshots.length);
274     uint256 rawFirstAddress = snapshots [_index].firstAddress;
275     hasResult = rawFirstAddress != MAX_UINT256;
276     result = hasResult ?
277       address (rawFirstAddress & MAX_ADDRESS) :
278         0;
279   }
280 
281   /**
282    * Get next address that probably had non-zero token balance at the moment
283    * certain snapshot was created.
284    *
285    * @param _address previous address that probably had non-zero token balance
286    *        at the moment of certain snapshot
287    * @return flag that tells whether there is next address that probably had
288    *         non-zero token balance at the moment of snapshot with given index
289    *         (hasResult); and the next address that probably had non-zero
290    *         token balance at the moment of snapshot with given index was
291    *         created or zero if there are no such addresses (result)
292    */
293   function nextAddress (address _address)
294     constant returns (bool hasResult, address result) {
295     uint256 rawNextAddress = nextAddresses [_address];
296     require (rawNextAddress != 0);
297     hasResult = rawNextAddress != MAX_UINT256;
298     result = hasResult ?
299       address (rawNextAddress & MAX_ADDRESS) :
300         0;
301   }
302 
303   /**
304    * Transfer given number of tokens from message sender to given recipient.
305    *
306    * @param _to address to transfer tokens to the owner of
307    * @param _value number of tokens to transfer to the owner of given address
308    * @return true if tokens were transferred successfully, false otherwise
309    */
310   function transfer (address _to, uint256 _value) returns (bool success) {
311     return doTransfer (msg.sender, _to, _value);
312   }
313 
314   /**
315    * Transfer given number of tokens from given owner to given recipient.
316    *
317    * @param _from address to transfer tokens from the owner of
318    * @param _to address to transfer tokens to the owner of
319    * @param _value number of tokens to transfer from given owner to given
320    *        recipient
321    * @return true if tokens were transferred successfully, false otherwise
322    */
323   function transferFrom (address _from, address _to, uint256 _value)
324   returns (bool success) {
325     if (_value > approved [_from][msg.sender]) return false;
326     else if (doTransfer (_from, _to, _value)) {
327       approved [_from][msg.sender] =
328         safeSub (approved[_from][msg.sender], _value);
329       return true;
330     } else return false;
331   }
332 
333   /**
334    * Allow given spender to transfer given number of tokens from message sender.
335    *
336    * @param _spender address to allow the owner of to transfer tokens from
337    *        message sender
338    * @param _value number of tokens to allow to transfer
339    * @return true if token transfer was successfully approved, false otherwise
340    */
341   function approve (address _spender, uint256 _value) returns (bool success) {
342     approved [msg.sender][_spender] = _value;
343     Approval (msg.sender, _spender, _value);
344     return true;
345   }
346 
347   /**
348    * Tell how many tokens given spender is currently allowed to transfer from
349    * given owner.
350    *
351    * @param _owner address to get number of tokens allowed to be transferred
352    *        from the owner of
353    * @param _spender address to get number of tokens allowed to be transferred
354    *        by the owner of
355    * @return number of tokens given spender is currently allowed to transfer
356    *         from given owner
357    */
358   function allowance (address _owner, address _spender) constant
359   returns (uint256 remaining) {
360     return approved [_owner][_spender];
361   }
362 
363   /**
364    * Create snapshot of token holder balances.
365    *
366    * @return index of new created snapshot
367    */
368   function snapshot () returns (uint256 index) {
369     index = snapshots.length++;
370     snapshots [index].tokensCount = tokensCount;
371     snapshots [index].firstAddress = firstAddress;
372     Snapshot (index);
373   }
374 
375   /**
376    * Transfer given number of tokens from the owner of given from address to the
377    * owner of given to address.
378    *
379    * @param _from address to transfer tokens from the owner of
380    * @param _to address to transfer tokens to the owner of
381    * @param _value number of tokens to transfer
382    * @return true if tokens were transferred successfully, false otherwise
383    */
384   function doTransfer (address _from, address _to, uint256 _value)
385     internal returns (bool success) {
386     if (_value > accounts [_from].balance) return false;
387     else if (_value > 0 && _from != _to) {
388       saveAddress (_to);
389       updateHistoricalBalances (_from);
390       updateHistoricalBalances (_to);
391       accounts [_from].balance = safeSub (accounts [_from].balance, _value);
392       accounts [_to].balance = safeAdd (accounts [_to].balance, _value);
393       Transfer (_from, _to, _value);
394       return true;
395     } else return true;
396   }
397 
398   /**
399    * Create given number of tokens and give them to message sender.
400    *
401    * @param _value number of tokens to create
402    * @return true on success, false on error
403    */
404   function doCreateTokens (uint256 _value) internal returns (bool success) {
405     if (_value > safeSub (MAX_TOKENS, tokensCount)) return false;
406     else if (_value > 0) {
407       saveAddress (msg.sender);
408       updateHistoricalBalances (msg.sender);
409       accounts [msg.sender].balance =
410         safeAdd (accounts [msg.sender].balance, _value);
411       tokensCount = safeAdd (tokensCount, _value);
412       return true;
413     } else return true;
414   }
415 
416   /**
417    * Update historical balances for given token owner.
418    *
419    * @param _owner token owner to update historical balances for
420    */
421   function updateHistoricalBalances (address _owner) internal {
422     uint256 balance = accounts [_owner].balance;
423     uint256 nextSnapshotIndex = snapshots.length;
424     uint256 lastNextSnapshotIndex =
425       safeAdd (accounts [_owner].lastSnapshotIndex, 1);
426     if (nextSnapshotIndex > lastNextSnapshotIndex) {
427       if (balance > 0) {
428         setHistoricalBalance (
429           _owner, lastNextSnapshotIndex, nextSnapshotIndex, balance);
430       }
431       accounts [_owner].lastSnapshotIndex =
432         safeSub (nextSnapshotIndex, 1);
433     }
434   }
435 
436   /**
437    * Set historical balance for the owner of given address as it was at the
438    * moments of snapshots with indexes in given range.
439    *
440    * @param _owner address to set the historical balance for the owner of
441    * @param _from beginning of the snapshot index range (inclusive)
442    * @param _to end of the snapshot index range (exclusive)
443    * @param _balance value to set balance to
444    */
445   function setHistoricalBalance (
446     address _owner, uint256 _from, uint256 _to, uint256 _balance)
447     internal {
448     assert (_from > 0);
449     assert (_to >= _from);
450     assert (_balance > 0);
451 
452     uint8 level = 0;
453     while (_from < _to) {
454       if (_from & 1 == 1) {
455         // Overflow is not possible here because _from < _to
456         historicalBalances [_owner][level][_from++] = _balance;
457       }
458 
459       if (_to & 1 == 1) {
460         // Underflow is not possible here, because _to & 1 == 1
461         historicalBalances [_owner][level][--_to] = _balance;
462       }
463 
464       _from >>= 1;
465       _to >>= 1;
466       level += 1; // Even for snapshot index range 1..2^256-1 overflow will
467                   // not happen here
468     }
469   }
470 
471   /**
472    * Add address to the list of addresses that ever had non-zero token balance.
473    *
474    * @param _address address to be added to the list of addresses that ever had
475    *        non-zero token balance
476    */
477   function saveAddress (address _address) internal {
478     if (nextAddresses [_address] == 0) {
479       nextAddresses [_address] = firstAddress;
480       firstAddress = TWO_160 | uint256(_address);
481     }
482   }
483 
484   /**
485    * Total number of tokens in circulation.
486    */
487   uint256 tokensCount;
488 
489   /**
490    * All snapshots ever created.
491    */
492   SnapshotInfo [] snapshots;
493 
494   /**
495    * Maps addresses of token owners to states of their accounts.
496    */
497   mapping (address => Account) accounts;
498 
499   /**
500    * First address that ever had non-zero token balance plus 2^160, or 2^256-1
501    * if there are no such addresses.
502    */
503   uint256 firstAddress = MAX_UINT256;
504 
505   /**
506    * Mapping from address that ever had non-zero token balance to the next
507    * address that ever had non-zero token balance plus 2^160 or 2^256-1 if there
508    * are no more such addresses.
509    */
510   mapping (address => uint256) nextAddresses;
511 
512   /**
513    * Historical balances of token owners.  If for some address, level and index,
514    * where level >= 0 and index > 0, historicalBalances[address][level][index]
515    * is non-zero, then owner of given address had this many tokens at the
516    * time moments of snapshots with indexes from (index * 2^level) to
517    * ((index + 1) * 2^level - 1) inclusive.
518    * For each snapshot, there should be at most one level with non-zero
519    * value at corresponding index.
520    */
521   mapping (address => mapping (uint8 => mapping (uint256 => uint256)))
522     historicalBalances;
523 
524   /**
525    * Maps addresses of token owners to mappings from addresses of spenders to
526    * how many tokens belonging to the owner, the spender is currently allowed to
527    * transfer.
528    */
529   mapping (address => mapping (address => uint256)) approved;
530 
531   /**
532    * Encapsulates information about snapshot.
533    */
534   struct SnapshotInfo {
535     /**
536      * Total number of tokens in circulation at the moment of snapshot.
537      */
538     uint256 tokensCount;
539 
540     /**
541      * Value of firstAddress field at the moment of snapshot.
542      */
543     uint256 firstAddress;
544   }
545 
546   /**
547    * Encapsulates information about token owner's balance.
548    */
549   struct Account {
550     /**
551      * Number of tokens currently belonging to the token owner.
552      */
553     uint256 balance;
554 
555     /**
556      * Index of the last snapshot before the moment historical balances were
557      * last updated for this token owner.
558      */
559     uint256 lastSnapshotIndex;
560   }
561 
562   /**
563    * Logged when new snapshot was created.
564    *
565    * @param _index index of the new snapshot
566    */
567   event Snapshot (uint256 indexed _index);
568 }
569 
570 
571 /*
572  * Standard Snapshottable Token Smart Contract.
573  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
574  */
575 
576 /**
577  * Standard Snapshottable Token Smart Contract.
578  */
579 contract StandardSnapshottableToken is AbstractSnapshottableToken {
580   /**
581    * Create new Standard Snapshottable Token Smart Contract and make
582    * message sender the owner of the smart contract.
583    */
584   function StandardSnapshottableToken ()
585     AbstractSnapshottableToken () {
586     owner = msg.sender;
587   }
588 
589   /**
590    * Transfer given number of tokens from message sender to given recipient.
591    *
592    * @param _to address to transfer tokens to the owner of
593    * @param _value number of tokens to transfer to the owner of given address
594    * @return true if tokens were transferred successfully, false otherwise
595    */
596   function transfer (address _to, uint256 _value) returns (bool success) {
597     if (frozen) return false;
598     else return AbstractSnapshottableToken.transfer (_to, _value);
599   }
600 
601   /**
602    * Transfer given number of tokens from given owner to given recipient.
603    *
604    * @param _from address to transfer tokens from the owner of
605    * @param _to address to transfer tokens to the owner of
606    * @param _value number of tokens to transfer from given owner to given
607    *        recipient
608    * @return true if tokens were transferred successfully, false otherwise
609    */
610   function transferFrom (address _from, address _to, uint256 _value)
611   returns (bool success) {
612     if (frozen) return false;
613     else
614       return AbstractSnapshottableToken.transferFrom (_from, _to, _value);
615   }
616 
617   /**
618    * Create given number of tokens and give them to message sender.  May only be
619    * called by the owner of the smart contract.
620    *
621    * @param _value number of tokens to create
622    * @return true on success, false on error
623    */
624   function createTokens (uint256 _value) returns (bool success) {
625     require (msg.sender == owner);
626 
627     return doCreateTokens (_value);
628   }
629 
630   /**
631    * Freeze token transfers.  May only be called by the owner of the smart
632    * contract.
633    */
634   function freezeTransfers () {
635     require (msg.sender == owner);
636 
637     if (!frozen)
638     {
639       frozen = true;
640       Freeze ();
641     }
642   }
643 
644   /**
645    * Unfreeze token transfers.  May only be called by the owner of the smart
646    * contract.
647    */
648   function unfreezeTransfers () {
649     require (msg.sender == owner);
650 
651     if (frozen) {
652       frozen = false;
653       Unfreeze ();
654     }
655   }
656 
657   /**
658    * Set new owner address.  May only be called by the owner of the smart
659    * contract.
660    *
661    * @param _newOwner new owner address
662    */
663   function setOwner (address _newOwner) {
664     require (msg.sender == owner);
665 
666     owner = _newOwner;
667   }
668 
669   /**
670    * Owner of this smart contract.
671    */
672   address owner;
673 
674   /**
675    * Whether token transfers are currently frozen.
676    */
677   bool frozen;
678 
679   /**
680    * Logged when token transfers were frozen.
681    */
682   event Freeze ();
683 
684   /**
685    * Logged when token transfers were unfrozen.
686    */
687   event Unfreeze ();
688 }
689 
690 
691 /*
692  * Science Blockchain Token Smart Contract.
693  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
694  */
695 
696 /**
697  * Science Blockchain Token Smart Contract.
698  */
699 contract ScienceBlockchainToken is StandardSnapshottableToken {
700   /**
701    * Create new Science Blockchain Token smart contract and make message sender
702    * to be the owner of smart contract and to be a snapshot creator.
703    */
704   function ScienceBlockchainToken ()
705     StandardSnapshottableToken () {
706     snapshotCreator = msg.sender;
707   }
708 
709   /**
710    * Create snapshot of token holder balances.
711    *
712    * @return index of new created snapshot
713    */
714   function snapshot () returns (uint256 index) {
715     require (msg.sender == snapshotCreator);
716     return AbstractSnapshottableToken.snapshot ();
717   }
718 
719   /**
720    * Get name of this token.
721    *
722    * @return name of this token
723    */
724   function name () constant returns (string result) {
725     return "SCIENCE BLOCKCHAIN";
726   }
727 
728   /**
729    * Get symbol of this token.
730    *
731    * @return symbol of this token
732    */
733   function symbol () constant returns (string result) {
734     return "SCI";
735   }
736 
737   /**
738    * Get number of decimals for this token.
739    *
740    * @return number of decimals for this token
741    */
742   function decimals () constant returns (uint8 result) {
743     return 0;
744   }
745 
746   /**
747    * Burn given number of tokens belonging to message sender.
748    *
749    * @param _value number of tokens to burn
750    * @return true if tokens were burned successfully, false otherwise
751    */
752   function burnTokens (uint256 _value) returns (bool success) {
753     uint256 balance = accounts [msg.sender].balance;
754     if (_value > balance) return false;
755     if (_value > 0) {
756       updateHistoricalBalances (msg.sender);
757       accounts [msg.sender].balance = safeSub (balance, _value);
758       tokensCount = safeSub (tokensCount, _value);
759       return true;
760     }
761     return true;
762   }
763 
764   /**
765    * Set new snapshot creator address.
766    *
767    * @param _snapshotCreator new snapshot creator address
768    */
769   function setSnapshotCreator (address _snapshotCreator) {
770     require (msg.sender == owner);
771     snapshotCreator = _snapshotCreator;
772   }
773 
774   /**
775    * Address of snapshot creator, i.e. the one allowed to create snapshots.
776    */
777   address snapshotCreator;
778 }