1 // King of the Ether Throne Contracts.
2 // Copyright (c) 2016 Kieran Elby. Released under the MIT License.
3 // Version 0.9.9.2, July 2016.
4 //
5 // See also http://www.kingoftheether.com and
6 // https://github.com/kieranelby/KingOfTheEtherThrone .
7 // 
8 // This file contains a number of contracts, of which only
9 // these three are normally created:
10 //
11 // - Kingdom        = maintains the throne for a kingdom
12 // - World          = runs the world, which is a collection of kingdoms
13 // - KingdomFactory = used internally by the World contract
14 //
15 // The "Mixin" contracts (ThroneRulesMixin, ReentryProtectorMixin,
16 // CarefulSenderMixin, FundsHolderMixin, MoneyRounderMixin,
17 // NameableMixin) contain functions / data / structures used
18 // by the three main contracts.
19 // The ExposedInternalsForTesting contract is used by automated tests.
20 
21 
22 /// @title Mixin to help avoid recursive-call attacks.
23 contract ReentryProtectorMixin {
24 
25     // true if we are inside an external function
26     bool reentryProtector;
27 
28     // Mark contract as having entered an external function.
29     // Throws an exception if called twice with no externalLeave().
30     // For this to work, Contracts MUST:
31     //  - call externalEnter() at the start of each external function
32     //  - call externalLeave() at the end of each external function
33     //  - never use return statements in between enter and leave
34     //  - never call an external function from another function
35     // WARN: serious risk of contract getting stuck if used wrongly.
36     function externalEnter() internal {
37         if (reentryProtector) {
38             throw;
39         }
40         reentryProtector = true;
41     }
42 
43     // Mark contract as having left an external function.
44     // Do this after each call to externalEnter().
45     function externalLeave() internal {
46         reentryProtector = false;
47     }
48 
49 }
50 
51 
52 /// @title Mixin to help send ether to untrusted addresses.
53 contract CarefulSenderMixin {
54 
55     // Seems a reasonable amount for a well-written fallback function.
56     uint constant suggestedExtraGasToIncludeWithSends = 23000;
57 
58     // Send `_valueWei` of our ether to `_toAddress`, including
59     // `_extraGasIncluded` gas above the usual 2300 gas stipend
60     // with the send call.
61     //
62     // This needs care because there is no way to tell if _toAddress
63     // is externally owned or is another contract - and sending ether
64     // to a contract address will invoke its fallback function; this
65     // has three implications:
66     //
67     // 1) Danger of recursive attack.
68     //  The destination contract's fallback function (or another
69     //  contract it calls) may call back into this contract (including
70     //  our fallback function and external functions inherited, or into
71     //  other contracts in our stack), leading to unexpected behaviour.
72     //  Mitigations:
73     //   - protect all external functions against re-entry into
74     //     any of them (see ReentryProtectorMixin);
75     //   - program very defensively (e.g. debit balance before send).
76     //
77     // 2) Destination fallback function can fail.
78     //  If the destination contract's fallback function fails, ether
79     //  will not be sent and may be locked into the sending contract.
80     //  Unlike most errors, it will NOT cause this contract to throw.
81     //  Mitigations:
82     //   - check the return value from this function (see below).
83     //
84     // 3) Gas usage.
85     //  The destination fallback function will consume the gas supplied
86     //  in this transaction (which is fixed and set by the transaction
87     //  starter, though some clients do a good job of estimating it.
88     //  This is a problem for lottery-type contracts where one very
89     //  expensive-to-call receiving contract could 'poison' the lottery
90     //  contract by preventing it being invoked by another person who
91     //  cannot supply enough gas.
92     //  Mitigations:
93     //    - choose sensible value for _extraGasIncluded (by default
94     //      only 2300 gas is supplied to the destination function);
95     //    - if call fails consider whether to throw or to ring-fence
96     //      funds for later withdrawal.
97     //
98     // Returns:
99     //
100     //  True if-and-only-if the send call was made and did not throw
101     //  an error. In this case, we will no longer own the _valueWei
102     //  ether. Note that we cannot get the return value of the fallback
103     //  function called (if any).
104     //
105     //  False if the send was made but the destination fallback function
106     //  threw an error (or ran out of gas). If this hapens, we still own
107     //  _valueWei ether and the destination's actions were undone.
108     //
109     //  This function should not normally throw an error unless:
110     //    - not enough gas to make the send/call
111     //    - max call stack depth reached
112     //    - insufficient ether
113     //
114     function carefulSendWithFixedGas(
115         address _toAddress,
116         uint _valueWei,
117         uint _extraGasIncluded
118     ) internal returns (bool success) {
119         return _toAddress.call.value(_valueWei).gas(_extraGasIncluded)();
120     }
121 
122 }
123 
124 
125 /// @title Mixin to help track who owns our ether and allow withdrawals.
126 contract FundsHolderMixin is ReentryProtectorMixin, CarefulSenderMixin {
127 
128     // Record here how much wei is owned by an address.
129     // Obviously, the entries here MUST be backed by actual ether
130     // owned by the contract - we cannot enforce that in this mixin.
131     mapping (address => uint) funds;
132 
133     event FundsWithdrawnEvent(
134         address fromAddress,
135         address toAddress,
136         uint valueWei
137     );
138 
139     /// @notice Amount of ether held for `_address`.
140     function fundsOf(address _address) constant returns (uint valueWei) {
141         return funds[_address];
142     }
143 
144     /// @notice Send the caller (`msg.sender`) all ether they own.
145     function withdrawFunds() {
146         externalEnter();
147         withdrawFundsRP();
148         externalLeave();
149     }
150 
151     /// @notice Send `_valueWei` of the ether owned by the caller
152     /// (`msg.sender`) to `_toAddress`, including `_extraGas` gas
153     /// beyond the normal stipend.
154     function withdrawFundsAdvanced(
155         address _toAddress,
156         uint _valueWei,
157         uint _extraGas
158     ) {
159         externalEnter();
160         withdrawFundsAdvancedRP(_toAddress, _valueWei, _extraGas);
161         externalLeave();
162     }
163 
164     /// @dev internal version of withdrawFunds()
165     function withdrawFundsRP() internal {
166         address fromAddress = msg.sender;
167         address toAddress = fromAddress;
168         uint allAvailableWei = funds[fromAddress];
169         withdrawFundsAdvancedRP(
170             toAddress,
171             allAvailableWei,
172             suggestedExtraGasToIncludeWithSends
173         );
174     }
175 
176     /// @dev internal version of withdrawFundsAdvanced(), also used
177     /// by withdrawFundsRP().
178     function withdrawFundsAdvancedRP(
179         address _toAddress,
180         uint _valueWei,
181         uint _extraGasIncluded
182     ) internal {
183         if (msg.value != 0) {
184             throw;
185         }
186         address fromAddress = msg.sender;
187         if (_valueWei > funds[fromAddress]) {
188             throw;
189         }
190         funds[fromAddress] -= _valueWei;
191         bool sentOk = carefulSendWithFixedGas(
192             _toAddress,
193             _valueWei,
194             _extraGasIncluded
195         );
196         if (!sentOk) {
197             throw;
198         }
199         FundsWithdrawnEvent(fromAddress, _toAddress, _valueWei);
200     }
201 
202 }
203 
204 
205 /// @title Mixin to help make nicer looking ether amounts.
206 contract MoneyRounderMixin {
207 
208     /// @notice Make `_rawValueWei` into a nicer, rounder number.
209     /// @return A value that:
210     ///   - is no larger than `_rawValueWei`
211     ///   - is no smaller than `_rawValueWei` * 0.999
212     ///   - has no more than three significant figures UNLESS the
213     ///     number is very small or very large in monetary terms
214     ///     (which we define as < 1 finney or > 10000 ether), in
215     ///     which case no precision will be lost.
216     function roundMoneyDownNicely(uint _rawValueWei) constant internal
217     returns (uint nicerValueWei) {
218         if (_rawValueWei < 1 finney) {
219             return _rawValueWei;
220         } else if (_rawValueWei < 10 finney) {
221             return 10 szabo * (_rawValueWei / 10 szabo);
222         } else if (_rawValueWei < 100 finney) {
223             return 100 szabo * (_rawValueWei / 100 szabo);
224         } else if (_rawValueWei < 1 ether) {
225             return 1 finney * (_rawValueWei / 1 finney);
226         } else if (_rawValueWei < 10 ether) {
227             return 10 finney * (_rawValueWei / 10 finney);
228         } else if (_rawValueWei < 100 ether) {
229             return 100 finney * (_rawValueWei / 100 finney);
230         } else if (_rawValueWei < 1000 ether) {
231             return 1 ether * (_rawValueWei / 1 ether);
232         } else if (_rawValueWei < 10000 ether) {
233             return 10 ether * (_rawValueWei / 10 ether);
234         } else {
235             return _rawValueWei;
236         }
237     }
238     
239     /// @notice Convert `_valueWei` into a whole number of finney.
240     /// @return The smallest whole number of finney which is equal
241     /// to or greater than `_valueWei` when converted to wei.
242     /// WARN: May be incorrect if `_valueWei` is above 2**254.
243     function roundMoneyUpToWholeFinney(uint _valueWei) constant internal
244     returns (uint valueFinney) {
245         return (1 finney + _valueWei - 1 wei) / 1 finney;
246     }
247 
248 }
249 
250 
251 /// @title Mixin to help allow users to name things.
252 contract NameableMixin {
253 
254     // String manipulation is expensive in the EVM; keep things short.
255 
256     uint constant minimumNameLength = 1;
257     uint constant maximumNameLength = 25;
258     string constant nameDataPrefix = "NAME:";
259 
260     /// @notice Check if `_name` is a reasonable choice of name.
261     /// @return True if-and-only-if `_name_` meets the criteria
262     /// below, or false otherwise:
263     ///   - no fewer than 1 character
264     ///   - no more than 25 characters
265     ///   - no characters other than:
266     ///     - "roman" alphabet letters (A-Z and a-z)
267     ///     - western digits (0-9)
268     ///     - "safe" punctuation: ! ( ) - . _ SPACE
269     ///   - at least one non-punctuation character
270     /// Note that we deliberately exclude characters which may cause
271     /// security problems for websites and databases if escaping is
272     /// not performed correctly, such as < > " and '.
273     /// Apologies for the lack of non-English language support.
274     function validateNameInternal(string _name) constant internal
275     returns (bool allowed) {
276         bytes memory nameBytes = bytes(_name);
277         uint lengthBytes = nameBytes.length;
278         if (lengthBytes < minimumNameLength ||
279             lengthBytes > maximumNameLength) {
280             return false;
281         }
282         bool foundNonPunctuation = false;
283         for (uint i = 0; i < lengthBytes; i++) {
284             byte b = nameBytes[i];
285             if (
286                 (b >= 48 && b <= 57) || // 0 - 9
287                 (b >= 65 && b <= 90) || // A - Z
288                 (b >= 97 && b <= 122)   // a - z
289             ) {
290                 foundNonPunctuation = true;
291                 continue;
292             }
293             if (
294                 b == 32 || // space
295                 b == 33 || // !
296                 b == 40 || // (
297                 b == 41 || // )
298                 b == 45 || // -
299                 b == 46 || // .
300                 b == 95    // _
301             ) {
302                 continue;
303             }
304             return false;
305         }
306         return foundNonPunctuation;
307     }
308 
309     // Extract a name from bytes `_data` (presumably from `msg.data`),
310     // or throw an exception if the data is not in the expected format.
311     // 
312     // We want to make it easy for people to name things, even if
313     // they're not comfortable calling functions on contracts.
314     //
315     // So we allow names to be sent to the fallback function encoded
316     // as message data.
317     //
318     // Unfortunately, the way the Ethereum Function ABI works means we
319     // must be careful to avoid clashes between message data that
320     // represents our names and message data that represents a call
321     // to an external function - otherwise:
322     //   a) some names won't be usable;
323     //   b) small possibility of a phishing attack where users are
324     //     tricked into using certain names which cause an external
325     //     function call - e.g. if the data sent to the contract is
326     //     keccak256("withdrawFunds()") then a withdrawal will occur.
327     //
328     // So we require a prefix "NAME:" at the start of the name (encoded
329     // in ASCII) when sent via the fallback function - this prefix
330     // doesn't clash with any external function signature hashes.
331     //
332     // e.g. web3.fromAscii('NAME:' + 'Joe Bloggs')
333     //
334     // WARN: this does not check the name for "reasonableness";
335     // use validateNameInternal() for that.
336     //
337     function extractNameFromData(bytes _data) constant internal
338     returns (string extractedName) {
339         // check prefix present
340         uint expectedPrefixLength = (bytes(nameDataPrefix)).length;
341         if (_data.length < expectedPrefixLength) {
342             throw;
343         }
344         uint i;
345         for (i = 0; i < expectedPrefixLength; i++) {
346             if ((bytes(nameDataPrefix))[i] != _data[i]) {
347                 throw;
348             }
349         }
350         // copy data after prefix
351         uint payloadLength = _data.length - expectedPrefixLength;
352         if (payloadLength < minimumNameLength ||
353             payloadLength > maximumNameLength) {
354             throw;
355         }
356         string memory name = new string(payloadLength);
357         for (i = 0; i < payloadLength; i++) {
358             (bytes(name))[i] = _data[expectedPrefixLength + i];
359         }
360         return name;
361     }
362 
363     // Turn a short name into a "fuzzy hash" with the property
364     // that extremely similar names will have the same fuzzy hash.
365     //
366     // This is useful to:
367     //  - stop people choosing names which differ only in case or
368     //    punctuation and would lead to confusion.
369     //  - faciliate searching by name without needing exact match
370     //
371     // For example, these names all have the same fuzzy hash:
372     //
373     //  "Banana"
374     //  "BANANA"
375     //  "Ba-na-na"
376     //  "  banana  "
377     //  "Banana                        .. so long the end is ignored"
378     //
379     // On the other hand, "Banana1" and "A Banana" are different to
380     // the above.
381     //
382     // WARN: this is likely to work poorly on names that do not meet
383     // the validateNameInternal() test.
384     //
385     function computeNameFuzzyHash(string _name) constant internal
386     returns (uint fuzzyHash) {
387         bytes memory nameBytes = bytes(_name);
388         uint h = 0;
389         uint len = nameBytes.length;
390         if (len > maximumNameLength) {
391             len = maximumNameLength;
392         }
393         for (uint i = 0; i < len; i++) {
394             uint mul = 128;
395             byte b = nameBytes[i];
396             uint ub = uint(b);
397             if (b >= 48 && b <= 57) {
398                 // 0-9
399                 h = h * mul + ub;
400             } else if (b >= 65 && b <= 90) {
401                 // A-Z
402                 h = h * mul + ub;
403             } else if (b >= 97 && b <= 122) {
404                 // fold a-z to A-Z
405                 uint upper = ub - 32;
406                 h = h * mul + upper;
407             } else {
408                 // ignore others
409             }
410         }
411         return h;
412     }
413 
414 }
415 
416 
417 /// @title Mixin to help define the rules of a throne.
418 contract ThroneRulesMixin {
419 
420     // See World.createKingdom(..) for documentation.
421     struct ThroneRules {
422         uint startingClaimPriceWei;
423         uint maximumClaimPriceWei;
424         uint claimPriceAdjustPercent;
425         uint curseIncubationDurationSeconds;
426         uint commissionPerThousand;
427     }
428 
429 }
430 
431 
432 /// @title Maintains the throne of a kingdom.
433 contract Kingdom is
434   ReentryProtectorMixin,
435   CarefulSenderMixin,
436   FundsHolderMixin,
437   MoneyRounderMixin,
438   NameableMixin,
439   ThroneRulesMixin {
440 
441     // e.g. "King of the Ether"
442     string public kingdomName;
443 
444     // The World contract used to create this kingdom, or 0x0 if none.
445     address public world;
446 
447     // The rules that govern this kingdom - see ThroneRulesMixin.
448     ThroneRules public rules;
449 
450     // Someone who has ruled (or is ruling) our kingdom.
451     struct Monarch {
452         // where to send their compensation
453         address compensationAddress;
454         // their name
455         string name;
456         // when they became our ruler
457         uint coronationTimestamp;
458         // the claim price paid (excluding any over-payment)
459         uint claimPriceWei;
460         // the compensation sent to or held for them so far
461         uint compensationWei;
462     }
463 
464     // The first ruler is number 1; the zero-th entry is a dummy entry.
465     Monarch[] public monarchsByNumber;
466 
467     // The topWizard earns half the commission.
468     // They are normally the owner of the World contract.
469     address public topWizard;
470 
471     // The subWizard earns half the commission.
472     // They are normally the creator of this Kingdom.
473     // The topWizard and subWizard can be the same address.
474     address public subWizard;
475 
476     // NB: we also have a `funds` mapping from FundsHolderMixin,
477     // and a rentryProtector from ReentryProtectorMixin.
478 
479     event ThroneClaimedEvent(uint monarchNumber);
480     event CompensationSentEvent(address toAddress, uint valueWei);
481     event CompensationFailEvent(address toAddress, uint valueWei);
482     event CommissionEarnedEvent(address byAddress, uint valueWei);
483     event WizardReplacedEvent(address oldWizard, address newWizard);
484     // NB: we also have a `FundsWithdrawnEvent` from FundsHolderMixin
485 
486     // WARN - does NOT validate arguments; you MUST either call
487     // KingdomFactory.validateProposedThroneRules() or create
488     // the Kingdom via KingdomFactory/World's createKingdom().
489     // See World.createKingdom(..) for parameter documentation.
490     function Kingdom(
491         string _kingdomName,
492         address _world,
493         address _topWizard,
494         address _subWizard,
495         uint _startingClaimPriceWei,
496         uint _maximumClaimPriceWei,
497         uint _claimPriceAdjustPercent,
498         uint _curseIncubationDurationSeconds,
499         uint _commissionPerThousand
500     ) {
501         kingdomName = _kingdomName;
502         world = _world;
503         topWizard = _topWizard;
504         subWizard = _subWizard;
505         rules = ThroneRules(
506             _startingClaimPriceWei,
507             _maximumClaimPriceWei,
508             _claimPriceAdjustPercent,
509             _curseIncubationDurationSeconds,
510             _commissionPerThousand
511         );
512         // We number the monarchs starting from 1; it's sometimes useful
513         // to use zero = invalid, so put in a dummy entry for number 0.
514         monarchsByNumber.push(
515             Monarch(
516                 0,
517                 "",
518                 0,
519                 0,
520                 0
521             )
522         );
523     }
524 
525     function numberOfMonarchs() constant returns (uint totalCount) {
526         // zero-th entry is invalid
527         return monarchsByNumber.length - 1;
528     }
529 
530     // False if either there are no monarchs, or if the latest monarch
531     // has reigned too long and been struck down by the curse.
532     function isLivingMonarch() constant returns (bool alive) {
533         if (numberOfMonarchs() == 0) {
534             return false;
535         }
536         uint reignStartedTimestamp = latestMonarchInternal().coronationTimestamp;
537         if (now < reignStartedTimestamp) {
538             // Should not be possible, think miners reject blocks with
539             // timestamps that go backwards? But some drift possible and
540             // it needs handling for unsigned overflow audit checks ...
541             return true;
542         }
543         uint elapsedReignDurationSeconds = now - reignStartedTimestamp;
544         if (elapsedReignDurationSeconds > rules.curseIncubationDurationSeconds) {
545             return false;
546         } else {
547             return true;
548         }
549     }
550 
551     /// @notice How much you must pay to claim the throne now, in wei.
552     function currentClaimPriceWei() constant returns (uint priceInWei) {
553         if (!isLivingMonarch()) {
554             return rules.startingClaimPriceWei;
555         } else {
556             uint lastClaimPriceWei = latestMonarchInternal().claimPriceWei;
557             // no danger of overflow because claim price never gets that high
558             uint newClaimPrice =
559               (lastClaimPriceWei * (100 + rules.claimPriceAdjustPercent)) / 100;
560             newClaimPrice = roundMoneyDownNicely(newClaimPrice);
561             if (newClaimPrice < rules.startingClaimPriceWei) {
562                 newClaimPrice = rules.startingClaimPriceWei;
563             }
564             if (newClaimPrice > rules.maximumClaimPriceWei) {
565                 newClaimPrice = rules.maximumClaimPriceWei;
566             }
567             return newClaimPrice;
568         }
569     }
570 
571     /// @notice How much you must pay to claim the throne now, in finney.
572     function currentClaimPriceInFinney() constant
573     returns (uint priceInFinney) {
574         uint valueWei = currentClaimPriceWei();
575         return roundMoneyUpToWholeFinney(valueWei);
576     }
577 
578     /// @notice Check if a name can be used as a monarch name.
579     /// @return True if the name satisfies the criteria of:
580     ///   - no fewer than 1 character
581     ///   - no more than 25 characters
582     ///   - no characters other than:
583     ///     - "roman" alphabet letters (A-Z and a-z)
584     ///     - western digits (0-9)
585     ///     - "safe" punctuation: ! ( ) - . _ SPACE
586     function validateProposedMonarchName(string _monarchName) constant
587     returns (bool allowed) {
588         return validateNameInternal(_monarchName);
589     }
590 
591     // Get details of the latest monarch (even if they are dead).
592     //
593     // We don't expose externally because returning structs is not well
594     // supported in the ABI (strange that monarchsByNumber array works
595     // fine though). Note that the reference returned is writable - it
596     // can be used to update details of the latest monarch.
597     // WARN: you should check numberOfMonarchs() > 0 first.
598     function latestMonarchInternal() constant internal
599     returns (Monarch storage monarch) {
600         return monarchsByNumber[monarchsByNumber.length - 1];
601     }
602 
603     /// @notice Claim throne by sending funds to the contract.
604     /// Any future compensation earned will be sent to the sender's
605     /// address (`msg.sender`).
606     /// Sending from a contract is not recommended unless you know
607     /// what you're doing (and you've tested it).
608     /// If no message data is supplied, the throne will be claimed in
609     /// the name of "Anonymous". To supply a name, send data encoded
610     /// using web3.fromAscii('NAME:' + 'your_chosen_valid_name').
611     /// Sender must include payment equal to currentClaimPriceWei().
612     /// Will consume up to ~300,000 gas.
613     /// Will throw an error if:
614     ///   - name is invalid (see `validateProposedMonarchName(string)`)
615     ///   - payment is too low or too high
616     /// Produces events:
617     ///   - `ThroneClaimedEvent`
618     ///   - `CompensationSentEvent` / `CompensationFailEvent`
619     ///   - `CommissionEarnedEvent`
620     function () {
621         externalEnter();
622         fallbackRP();
623         externalLeave();
624     }
625 
626     /// @notice Claim throne in the given `_monarchName`.
627     /// Any future compensation earned will be sent to the caller's
628     /// address (`msg.sender`).
629     /// Caller must include payment equal to currentClaimPriceWei().
630     /// Calling from a contract is not recommended unless you know
631     /// what you're doing (and you've tested it).
632     /// Will consume up to ~300,000 gas.
633     /// Will throw an error if:
634     ///   - name is invalid (see `validateProposedMonarchName(string)`)
635     ///   - payment is too low or too high
636     /// Produces events:
637     ///   - `ThroneClaimedEvent
638     ///   - `CompensationSentEvent` / `CompensationFailEvent`
639     ///   - `CommissionEarnedEvent`
640     function claimThrone(string _monarchName) {
641         externalEnter();
642         claimThroneRP(_monarchName);
643         externalLeave();
644     }
645 
646     /// @notice Used by either the topWizard or subWizard to transfer
647     /// all rights to future commissions to the `_replacement` wizard.
648     /// WARN: The original wizard retains ownership of any past
649     /// commission held for them in the `funds` mapping, which they
650     /// can still withdraw.
651     /// Produces event WizardReplacedEvent.
652     function replaceWizard(address _replacement) {
653         externalEnter();
654         replaceWizardRP(_replacement);
655         externalLeave();
656     }
657 
658     function fallbackRP() internal {
659         if (msg.data.length == 0) {
660             claimThroneRP("Anonymous");
661         } else {
662             string memory _monarchName = extractNameFromData(msg.data);
663             claimThroneRP(_monarchName);
664         }
665     }
666     
667     function claimThroneRP(
668         string _monarchName
669     ) internal {
670 
671         address _compensationAddress = msg.sender;
672 
673         if (!validateNameInternal(_monarchName)) {
674             throw;
675         }
676 
677         if (_compensationAddress == 0 ||
678             _compensationAddress == address(this)) {
679             throw;
680         }
681 
682         uint paidWei = msg.value;
683         uint priceWei = currentClaimPriceWei();
684         if (paidWei < priceWei) {
685             throw;
686         }
687         // Make it easy for people to pay using a whole number of finney,
688         // which could be a teeny bit higher than the raw wei value.
689         uint excessWei = paidWei - priceWei;
690         if (excessWei > 1 finney) {
691             throw;
692         }
693         
694         uint compensationWei;
695         uint commissionWei;
696         if (!isLivingMonarch()) {
697             // dead men get no compensation
698             commissionWei = paidWei;
699             compensationWei = 0;
700         } else {
701             commissionWei = (paidWei * rules.commissionPerThousand) / 1000;
702             compensationWei = paidWei - commissionWei;
703         }
704 
705         if (commissionWei != 0) {
706             recordCommissionEarned(commissionWei);
707         }
708 
709         if (compensationWei != 0) {
710             compensateLatestMonarch(compensationWei);
711         }
712 
713         // In case of any teeny excess, we use the official price here
714         // since that should determine the new claim price, not paidWei.
715         monarchsByNumber.push(Monarch(
716             _compensationAddress,
717             _monarchName,
718             now,
719             priceWei,
720             0
721         ));
722 
723         ThroneClaimedEvent(monarchsByNumber.length - 1);
724     }
725 
726     function replaceWizardRP(address replacement) internal {
727         if (msg.value != 0) {
728             throw;
729         }
730         bool replacedOk = false;
731         address oldWizard;
732         if (msg.sender == topWizard) {
733             oldWizard = topWizard;
734             topWizard = replacement;
735             WizardReplacedEvent(oldWizard, replacement);
736             replacedOk = true;
737         }
738         // Careful - topWizard and subWizard can be the same address,
739         // in which case we must replace both.
740         if (msg.sender == subWizard) {
741             oldWizard = subWizard;
742             subWizard = replacement;
743             WizardReplacedEvent(oldWizard, replacement);
744             replacedOk = true;
745         }
746         if (!replacedOk) {
747             throw;
748         }
749     }
750 
751     // Allow commission funds to build up in contract for the wizards
752     // to withdraw (carefully ring-fenced).
753     function recordCommissionEarned(uint _commissionWei) internal {
754         // give the subWizard any "odd" single wei
755         uint topWizardWei = _commissionWei / 2;
756         uint subWizardWei = _commissionWei - topWizardWei;
757         funds[topWizard] += topWizardWei;
758         CommissionEarnedEvent(topWizard, topWizardWei);
759         funds[subWizard] += subWizardWei;
760         CommissionEarnedEvent(subWizard, subWizardWei);
761     }
762 
763     // Send compensation to latest monarch (or hold funds for them
764     // if cannot through no fault of current caller).
765     function compensateLatestMonarch(uint _compensationWei) internal {
766         address compensationAddress =
767           latestMonarchInternal().compensationAddress;
768         // record that we compensated them
769         latestMonarchInternal().compensationWei = _compensationWei;
770         // WARN: if the latest monarch is a contract whose fallback
771         // function needs more 25300 gas than then they will NOT
772         // receive compensation automatically.
773         bool sentOk = carefulSendWithFixedGas(
774             compensationAddress,
775             _compensationWei,
776             suggestedExtraGasToIncludeWithSends
777         );
778         if (sentOk) {
779             CompensationSentEvent(compensationAddress, _compensationWei);
780         } else {
781             // This should only happen if the latest monarch is a contract
782             // whose fallback-function failed or ran out of gas (despite
783             // us including a fair amount of gas).
784             // We do not throw since we do not want the throne to get
785             // 'stuck' (it's not the new usurpers fault) - instead save
786             // the funds we could not send so can be claimed later.
787             // Their monarch contract would need to have been designed
788             // to call our withdrawFundsAdvanced(..) function mind you.
789             funds[compensationAddress] += _compensationWei;
790             CompensationFailEvent(compensationAddress, _compensationWei);
791         }
792     }
793 
794 }
795 
796 
797 /// @title Used by the World contract to create Kingdom instances.
798 /// @dev Mostly exists so topWizard can potentially replace this
799 /// contract to modify the Kingdom contract and/or rule validation
800 /// logic to be used for *future* Kingdoms created by the World.
801 /// We do not implement rentry protection because we don't send/call.
802 /// We do not charge a fee here - but if you bypass the World then
803 /// you won't be listed on the official World page of course.
804 contract KingdomFactory {
805 
806     function KingdomFactory() {
807     }
808 
809     function () {
810         // this contract should never have a balance
811         throw;
812     }
813 
814     // See World.createKingdom(..) for parameter documentation.
815     function validateProposedThroneRules(
816         uint _startingClaimPriceWei,
817         uint _maximumClaimPriceWei,
818         uint _claimPriceAdjustPercent,
819         uint _curseIncubationDurationSeconds,
820         uint _commissionPerThousand
821     ) constant returns (bool allowed) {
822         // I suppose there is a danger that massive deflation/inflation could
823         // change the real-world sanity of these checks, but in that case we
824         // can deploy a new factory and update the world.
825         if (_startingClaimPriceWei < 1 finney ||
826             _startingClaimPriceWei > 100 ether) {
827             return false;
828         }
829         if (_maximumClaimPriceWei < 1 ether ||
830             _maximumClaimPriceWei > 100000 ether) {
831             return false;
832         }
833         if (_startingClaimPriceWei * 20 > _maximumClaimPriceWei) {
834             return false;
835         }
836         if (_claimPriceAdjustPercent < 1 ||
837             _claimPriceAdjustPercent > 900) {
838             return false;
839         }
840         if (_curseIncubationDurationSeconds < 2 hours ||
841             _curseIncubationDurationSeconds > 10000 days) {
842             return false;
843         }
844         if (_commissionPerThousand < 10 ||
845             _commissionPerThousand > 100) {
846             return false;
847         }
848         return true;
849     }
850 
851     /// @notice Create a new Kingdom. Normally called by World contract.
852     /// WARN: Does NOT validate the _kingdomName or _world arguments.
853     /// Will consume up to 1,800,000 gas (!)
854     /// Will throw an error if:
855     ///   - rules invalid (see validateProposedThroneRules)
856     ///   - wizard addresses "obviously" wrong
857     ///   - out of gas quite likely (perhaps in future should consider
858     ///     using solidity libraries to reduce Kingdom size?)
859     // See World.createKingdom(..) for parameter documentation.
860     function createKingdom(
861         string _kingdomName,
862         address _world,
863         address _topWizard,
864         address _subWizard,
865         uint _startingClaimPriceWei,
866         uint _maximumClaimPriceWei,
867         uint _claimPriceAdjustPercent,
868         uint _curseIncubationDurationSeconds,
869         uint _commissionPerThousand
870     ) returns (Kingdom newKingdom) {
871         if (msg.value > 0) {
872             // this contract should never have a balance
873             throw;
874         }
875         // NB: topWizard and subWizard CAN be the same as each other.
876         if (_topWizard == 0 || _subWizard == 0) {
877             throw;
878         }
879         if (_topWizard == _world || _subWizard == _world) {
880             throw;
881         }
882         if (!validateProposedThroneRules(
883             _startingClaimPriceWei,
884             _maximumClaimPriceWei,
885             _claimPriceAdjustPercent,
886             _curseIncubationDurationSeconds,
887             _commissionPerThousand
888         )) {
889             throw;
890         }
891         return new Kingdom(
892             _kingdomName,
893             _world,
894             _topWizard,
895             _subWizard,
896             _startingClaimPriceWei,
897             _maximumClaimPriceWei,
898             _claimPriceAdjustPercent,
899             _curseIncubationDurationSeconds,
900             _commissionPerThousand
901         );
902     }
903 
904 }
905 
906 
907 /// @title Runs the world, which is a collection of Kingdoms.
908 contract World is
909   ReentryProtectorMixin,
910   NameableMixin,
911   MoneyRounderMixin,
912   FundsHolderMixin,
913   ThroneRulesMixin {
914 
915     // The topWizard runs the world. They charge for the creation of
916     // kingdoms and become the topWizard in each kingdom created.
917     address public topWizard;
918 
919     // How much one must pay to create a new kingdom (in wei).
920     // Can be changed by the topWizard.
921     uint public kingdomCreationFeeWei;
922 
923     struct KingdomListing {
924         uint kingdomNumber;
925         string kingdomName;
926         address kingdomContract;
927         address kingdomCreator;
928         uint creationTimestamp;
929         address kingdomFactoryUsed;
930     }
931     
932     // The first kingdom is number 1; the zero-th entry is a dummy.
933     KingdomListing[] public kingdomsByNumber;
934 
935     // For safety, we cap just how high the price can get.
936     // Can be changed by the topWizard, though it will only affect
937     // kingdoms created after that.
938     uint public maximumClaimPriceWei;
939 
940     // Helper contract for creating Kingdom instances. Can be
941     // upgraded by the topWizard (won't affect existing ones).
942     KingdomFactory public kingdomFactory;
943 
944     // Avoids duplicate kingdom names and allows searching by name.
945     mapping (uint => uint) kingdomNumbersByfuzzyHash;
946 
947     // NB: we also have a `funds` mapping from FundsHolderMixin,
948     // and a rentryProtector from ReentryProtectorMixin.
949 
950     event KingdomCreatedEvent(uint kingdomNumber);
951     event CreationFeeChangedEvent(uint newFeeWei);
952     event FactoryChangedEvent(address newFactory);
953     event WizardReplacedEvent(address oldWizard, address newWizard);
954     // NB: we also have a `FundsWithdrawnEvent` from FundsHolderMixin
955 
956     // Create the world with no kingdoms yet.
957     // Costs about 1.9M gas to deploy.
958     function World(
959         address _topWizard,
960         uint _kingdomCreationFeeWei,
961         KingdomFactory _kingdomFactory,
962         uint _maximumClaimPriceWei
963     ) {
964         if (_topWizard == 0) {
965             throw;
966         }
967         if (_maximumClaimPriceWei < 1 ether) {
968             throw;
969         }
970         topWizard = _topWizard;
971         kingdomCreationFeeWei = _kingdomCreationFeeWei;
972         kingdomFactory = _kingdomFactory;
973         maximumClaimPriceWei = _maximumClaimPriceWei;
974         // We number the kingdoms starting from 1 since it's sometimes
975         // useful to use zero = invalid. Create dummy zero-th entry.
976         kingdomsByNumber.push(KingdomListing(0, "", 0, 0, 0, 0));
977     }
978 
979     function numberOfKingdoms() constant returns (uint totalCount) {
980         return kingdomsByNumber.length - 1;
981     }
982 
983     /// @return index into kingdomsByNumber if found, or zero if not. 
984     function findKingdomCalled(string _kingdomName) constant
985     returns (uint kingdomNumber) {
986         uint fuzzyHash = computeNameFuzzyHash(_kingdomName);
987         return kingdomNumbersByfuzzyHash[fuzzyHash];
988     }
989 
990     /// @notice Check if a name can be used as a kingdom name.
991     /// @return True if the name satisfies the criteria of:
992     ///   - no fewer than 1 character
993     ///   - no more than 25 characters
994     ///   - no characters other than:
995     ///     - "roman" alphabet letters (A-Z and a-z)
996     ///     - western digits (0-9)
997     ///     - "safe" punctuation: ! ( ) - . _ SPACE
998     ///
999     /// WARN: does not check if the name is already in use;
1000     /// use `findKingdomCalled(string)` for that afterwards.
1001     function validateProposedKingdomName(string _kingdomName) constant
1002     returns (bool allowed) {
1003         return validateNameInternal(_kingdomName);
1004     }
1005 
1006     // Check if rules would be allowed for a new custom Kingdom.
1007     // Typically used before calling `createKingdom(...)`.
1008     function validateProposedThroneRules(
1009         uint _startingClaimPriceWei,
1010         uint _claimPriceAdjustPercent,
1011         uint _curseIncubationDurationSeconds,
1012         uint _commissionPerThousand
1013     ) constant returns (bool allowed) {
1014         return kingdomFactory.validateProposedThroneRules(
1015             _startingClaimPriceWei,
1016             maximumClaimPriceWei,
1017             _claimPriceAdjustPercent,
1018             _curseIncubationDurationSeconds,
1019             _commissionPerThousand
1020         );
1021     }
1022 
1023     // How much one must pay to create a new kingdom (in finney).
1024     // Can be changed by the topWizard.
1025     function kingdomCreationFeeInFinney() constant
1026     returns (uint feeInFinney) {
1027         return roundMoneyUpToWholeFinney(kingdomCreationFeeWei);
1028     }
1029 
1030     // Reject funds sent to the contract - wizards who cannot interact
1031     // with it via the API won't be able to withdraw their commission.
1032     function () {
1033         throw;
1034     }
1035 
1036     /// @notice Create a new kingdom using custom rules.
1037     /// @param _kingdomName \
1038     ///   e.g. "King of the Ether Throne"
1039     /// @param _startingClaimPriceWei \
1040     ///   How much it will cost the first monarch to claim the throne
1041     ///   (and also the price after the death of a monarch).
1042     /// @param _claimPriceAdjustPercent \
1043     ///   Percentage increase after each claim - e.g. if claim price
1044     ///   was 200 ETH, and `_claimPriceAdjustPercent` is 50, the next
1045     ///   claim price will be 200 ETH + (50% of 200 ETH) => 300 ETH.
1046     /// @param _curseIncubationDurationSeconds \
1047     ///   The maximum length of a time a monarch can rule before the
1048     ///   curse strikes and they are removed without compensation.
1049     /// @param _commissionPerThousand \
1050     ///   How much of each payment is given to the wizards to share,
1051     ///   expressed in parts per thousand - e.g. 25 means 25/1000,
1052     ///   or 2.5%.
1053     /// 
1054     /// Caller must include payment equal to kingdomCreationFeeWei.
1055     /// The caller will become the 'sub-wizard' and will earn half
1056     /// any commission charged by the Kingdom.  Note however they
1057     /// will need to call withdrawFunds() on the Kingdom contract
1058     /// to get their commission - it's not send automatically.
1059     ///
1060     /// Will consume up to 1,900,000 gas (!)
1061     /// Will throw an error if:
1062     ///   - name is invalid (see `validateProposedKingdomName(string)`)
1063     ///   - name is already in use (see `findKingdomCalled(string)`)
1064     ///   - rules are invalid (see `validateProposedKingdomRules(...)`)
1065     ///   - payment is too low or too high
1066     ///   - insufficient gas (quite likely!)
1067     /// Produces event KingdomCreatedEvent.
1068     function createKingdom(
1069         string _kingdomName,
1070         uint _startingClaimPriceWei,
1071         uint _claimPriceAdjustPercent,
1072         uint _curseIncubationDurationSeconds,
1073         uint _commissionPerThousand
1074     ) {
1075         externalEnter();
1076         createKingdomRP(
1077             _kingdomName,
1078             _startingClaimPriceWei,
1079             _claimPriceAdjustPercent,
1080             _curseIncubationDurationSeconds,
1081             _commissionPerThousand
1082         );
1083         externalLeave();
1084     }
1085 
1086     /// @notice Used by topWizard to transfer all rights to future
1087     /// fees and future kingdom wizardships to `_replacement` wizard.
1088     /// WARN: The original wizard retains ownership of any past fees
1089     /// held for them in the `funds` mapping, which they can still
1090     /// withdraw. They also remain topWizard in any existing Kingdoms.
1091     /// Produces event WizardReplacedEvent.
1092     function replaceWizard(address _replacement) {
1093         externalEnter();
1094         replaceWizardRP(_replacement);
1095         externalLeave();
1096     }
1097 
1098     /// @notice Used by topWizard to vary the fee for creating kingdoms.
1099     function setKingdomCreationFeeWei(uint _kingdomCreationFeeWei) {
1100         externalEnter();
1101         setKingdomCreationFeeWeiRP(_kingdomCreationFeeWei);
1102         externalLeave();
1103     }
1104 
1105     /// @notice Used by topWizard to vary the cap on claim price.
1106     function setMaximumClaimPriceWei(uint _maximumClaimPriceWei) {
1107         externalEnter();
1108         setMaximumClaimPriceWeiRP(_maximumClaimPriceWei);
1109         externalLeave();
1110     }
1111 
1112     /// @notice Used by topWizard to vary the factory contract which
1113     /// will be used to create future Kingdoms.
1114     function setKingdomFactory(KingdomFactory _kingdomFactory) {
1115         externalEnter();
1116         setKingdomFactoryRP(_kingdomFactory);
1117         externalLeave();
1118     }
1119 
1120     function createKingdomRP(
1121         string _kingdomName,
1122         uint _startingClaimPriceWei,
1123         uint _claimPriceAdjustPercent,
1124         uint _curseIncubationDurationSeconds,
1125         uint _commissionPerThousand
1126     ) internal {
1127 
1128         address subWizard = msg.sender;
1129 
1130         if (!validateNameInternal(_kingdomName)) {
1131             throw;
1132         }
1133 
1134         uint newKingdomNumber = kingdomsByNumber.length;
1135         checkUniqueAndRegisterNewKingdomName(
1136             _kingdomName,
1137             newKingdomNumber
1138         );
1139 
1140         uint paidWei = msg.value;
1141         if (paidWei < kingdomCreationFeeWei) {
1142             throw;
1143         }
1144         // Make it easy for people to pay using a whole number of finney,
1145         // which could be a teeny bit higher than the raw wei value.
1146         uint excessWei = paidWei - kingdomCreationFeeWei;
1147         if (excessWei > 1 finney) {
1148             throw;
1149         }
1150         funds[topWizard] += paidWei;
1151         
1152         // This will perform rule validation.
1153         Kingdom kingdomContract = kingdomFactory.createKingdom(
1154             _kingdomName,
1155             address(this),
1156             topWizard,
1157             subWizard,
1158             _startingClaimPriceWei,
1159             maximumClaimPriceWei,
1160             _claimPriceAdjustPercent,
1161             _curseIncubationDurationSeconds,
1162             _commissionPerThousand
1163         );
1164 
1165         kingdomsByNumber.push(KingdomListing(
1166             newKingdomNumber,
1167             _kingdomName,
1168             kingdomContract,
1169             msg.sender,
1170             now,
1171             kingdomFactory
1172         ));
1173     }
1174 
1175     function replaceWizardRP(address replacement) internal { 
1176         if (msg.sender != topWizard) {
1177             throw;
1178         }
1179         if (msg.value != 0) {
1180             throw;
1181         }
1182         address oldWizard = topWizard;
1183         topWizard = replacement;
1184         WizardReplacedEvent(oldWizard, replacement);
1185     }
1186 
1187     function setKingdomCreationFeeWeiRP(uint _kingdomCreationFeeWei) internal {
1188         if (msg.sender != topWizard) {
1189             throw;
1190         }
1191         if (msg.value != 0) {
1192             throw;
1193         }
1194         kingdomCreationFeeWei = _kingdomCreationFeeWei;
1195         CreationFeeChangedEvent(kingdomCreationFeeWei);
1196     }
1197 
1198     function setMaximumClaimPriceWeiRP(uint _maximumClaimPriceWei) internal {
1199         if (msg.sender != topWizard) {
1200             throw;
1201         }
1202         if (_maximumClaimPriceWei < 1 ether) {
1203             throw;
1204         }
1205         maximumClaimPriceWei = _maximumClaimPriceWei;
1206     }
1207 
1208     function setKingdomFactoryRP(KingdomFactory _kingdomFactory) internal {
1209         if (msg.sender != topWizard) {
1210             throw;
1211         }
1212         if (msg.value != 0) {
1213             throw;
1214         }
1215         kingdomFactory = _kingdomFactory;
1216         FactoryChangedEvent(kingdomFactory);
1217     }
1218 
1219     // If there is no existing kingdom called `_kingdomName`, create
1220     // a record mapping that name to kingdom no. `_newKingdomNumber`.
1221     // Throws an error if an existing kingdom with the same (or
1222     // fuzzily similar - see computeNameFuzzyHash) name exists.
1223     function checkUniqueAndRegisterNewKingdomName(
1224         string _kingdomName,
1225         uint _newKingdomNumber
1226     ) internal {
1227         uint fuzzyHash = computeNameFuzzyHash(_kingdomName);
1228         if (kingdomNumbersByfuzzyHash[fuzzyHash] != 0) {
1229             throw;
1230         }
1231         kingdomNumbersByfuzzyHash[fuzzyHash] = _newKingdomNumber;
1232     }
1233 
1234 }
1235 
1236 
1237 /// @title Used on the testnet to allow automated testing of internals.
1238 contract ExposedInternalsForTesting is
1239   MoneyRounderMixin, NameableMixin {
1240 
1241     function roundMoneyDownNicelyET(uint _rawValueWei) constant
1242     returns (uint nicerValueWei) {
1243         return roundMoneyDownNicely(_rawValueWei);
1244     }
1245 
1246     function roundMoneyUpToWholeFinneyET(uint _valueWei) constant
1247     returns (uint valueFinney) {
1248         return roundMoneyUpToWholeFinney(_valueWei);
1249     }
1250 
1251     function validateNameInternalET(string _name) constant
1252     returns (bool allowed) {
1253         return validateNameInternal(_name);
1254     }
1255 
1256     function extractNameFromDataET(bytes _data) constant
1257     returns (string extractedName) {
1258         return extractNameFromData(_data);
1259     }
1260     
1261     function computeNameFuzzyHashET(string _name) constant
1262     returns (uint fuzzyHash) {
1263         return computeNameFuzzyHash(_name);
1264     }
1265 
1266 }