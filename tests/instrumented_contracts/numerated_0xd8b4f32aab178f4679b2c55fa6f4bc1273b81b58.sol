1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 library Strings {
5 
6     /**
7      * Concat (High gas cost)
8      * 
9      * Appends two strings together and returns a new value
10      * 
11      * @param _base When being used for a data type this is the extended object
12      *              otherwise this is the string which will be the concatenated
13      *              prefix
14      * @param _value The value to be the concatenated suffix
15      * @return string The resulting string from combinging the base and value
16      */
17     function concat(string _base, string _value)
18         internal
19         pure
20         returns (string) {
21         bytes memory _baseBytes = bytes(_base);
22         bytes memory _valueBytes = bytes(_value);
23 
24         assert(_valueBytes.length > 0);
25 
26         string memory _tmpValue = new string(_baseBytes.length + 
27             _valueBytes.length);
28         bytes memory _newValue = bytes(_tmpValue);
29 
30         uint i;
31         uint j;
32 
33         for(i = 0; i < _baseBytes.length; i++) {
34             _newValue[j++] = _baseBytes[i];
35         }
36 
37         for(i = 0; i<_valueBytes.length; i++) {
38             _newValue[j++] = _valueBytes[i];
39         }
40 
41         return string(_newValue);
42     }
43 
44     /**
45      * Index Of
46      *
47      * Locates and returns the position of a character within a string
48      * 
49      * @param _base When being used for a data type this is the extended object
50      *              otherwise this is the string acting as the haystack to be
51      *              searched
52      * @param _value The needle to search for, at present this is currently
53      *               limited to one character
54      * @return int The position of the needle starting from 0 and returning -1
55      *             in the case of no matches found
56      */
57     function indexOf(string _base, string _value)
58         internal
59         pure
60         returns (int) {
61         return _indexOf(_base, _value, 0);
62     }
63 
64     /**
65      * Index Of
66      *
67      * Locates and returns the position of a character within a string starting
68      * from a defined offset
69      * 
70      * @param _base When being used for a data type this is the extended object
71      *              otherwise this is the string acting as the haystack to be
72      *              searched
73      * @param _value The needle to search for, at present this is currently
74      *               limited to one character
75      * @param _offset The starting point to start searching from which can start
76      *                from 0, but must not exceed the length of the string
77      * @return int The position of the needle starting from 0 and returning -1
78      *             in the case of no matches found
79      */
80     function _indexOf(string _base, string _value, uint _offset)
81         internal
82         pure
83         returns (int) {
84         bytes memory _baseBytes = bytes(_base);
85         bytes memory _valueBytes = bytes(_value);
86 
87         assert(_valueBytes.length == 1);
88 
89         for(uint i = _offset; i < _baseBytes.length; i++) {
90             if (_baseBytes[i] == _valueBytes[0]) {
91                 return int(i);
92             }
93         }
94 
95         return -1;
96     }
97 
98     /**
99      * Length
100      * 
101      * Returns the length of the specified string
102      * 
103      * @param _base When being used for a data type this is the extended object
104      *              otherwise this is the string to be measured
105      * @return uint The length of the passed string
106      */
107     function length(string _base)
108         internal
109         pure
110         returns (uint) {
111         bytes memory _baseBytes = bytes(_base);
112         return _baseBytes.length;
113     }
114 
115     /**
116      * Sub String
117      * 
118      * Extracts the beginning part of a string based on the desired length
119      * 
120      * @param _base When being used for a data type this is the extended object
121      *              otherwise this is the string that will be used for 
122      *              extracting the sub string from
123      * @param _length The length of the sub string to be extracted from the base
124      * @return string The extracted sub string
125      */
126     function substring(string _base, int _length)
127         internal
128         pure
129         returns (string) {
130         return _substring(_base, _length, 0);
131     }
132 
133     /**
134      * Sub String
135      * 
136      * Extracts the part of a string based on the desired length and offset. The
137      * offset and length must not exceed the lenth of the base string.
138      * 
139      * @param _base When being used for a data type this is the extended object
140      *              otherwise this is the string that will be used for 
141      *              extracting the sub string from
142      * @param _length The length of the sub string to be extracted from the base
143      * @param _offset The starting point to extract the sub string from
144      * @return string The extracted sub string
145      */
146     function _substring(string _base, int _length, int _offset)
147         internal
148         pure
149         returns (string) {
150         bytes memory _baseBytes = bytes(_base);
151 
152         assert(uint(_offset+_length) <= _baseBytes.length);
153 
154         string memory _tmp = new string(uint(_length));
155         bytes memory _tmpBytes = bytes(_tmp);
156 
157         uint j = 0;
158         for(uint i = uint(_offset); i < uint(_offset+_length); i++) {
159           _tmpBytes[j++] = _baseBytes[i];
160         }
161 
162         return string(_tmpBytes);
163     }
164 
165     /**
166      * String Split (Very high gas cost)
167      *
168      * Splits a string into an array of strings based off the delimiter value.
169      * Please note this can be quite a gas expensive function due to the use of
170      * storage so only use if really required.
171      *
172      * @param _base When being used for a data type this is the extended object
173      *               otherwise this is the string value to be split.
174      * @param _value The delimiter to split the string on which must be a single
175      *               character
176      * @return string[] An array of values split based off the delimiter, but
177      *                  do not container the delimiter.
178      */
179     function split(string _base, string _value)
180         internal
181         returns (string[] storage splitArr) {
182         bytes memory _baseBytes = bytes(_base);
183         uint _offset = 0;
184 
185         while(_offset < _baseBytes.length-1) {
186 
187             int _limit = _indexOf(_base, _value, _offset);
188             if (_limit == -1) {
189                 _limit = int(_baseBytes.length);
190             }
191 
192             string memory _tmp = new string(uint(_limit)-_offset);
193             bytes memory _tmpBytes = bytes(_tmp);
194 
195             uint j = 0;
196             for(uint i = _offset; i < uint(_limit); i++) {
197                 _tmpBytes[j++] = _baseBytes[i];
198             }
199             _offset = uint(_limit) + 1;
200             splitArr.push(string(_tmpBytes));
201         }
202         return splitArr;
203     }
204 
205     /**
206      * Compare To
207      * 
208      * Compares the characters of two strings, to ensure that they have an 
209      * identical footprint
210      * 
211      * @param _base When being used for a data type this is the extended object
212      *               otherwise this is the string base to compare against
213      * @param _value The string the base is being compared to
214      * @return bool Simply notates if the two string have an equivalent
215      */
216     function compareTo(string _base, string _value) 
217         internal
218         pure
219         returns (bool) {
220         bytes memory _baseBytes = bytes(_base);
221         bytes memory _valueBytes = bytes(_value);
222 
223         if (_baseBytes.length != _valueBytes.length) {
224             return false;
225         }
226 
227         for(uint i = 0; i < _baseBytes.length; i++) {
228             if (_baseBytes[i] != _valueBytes[i]) {
229                 return false;
230             }
231         }
232 
233         return true;
234     }
235 
236     /**
237      * Compare To Ignore Case (High gas cost)
238      * 
239      * Compares the characters of two strings, converting them to the same case
240      * where applicable to alphabetic characters to distinguish if the values
241      * match.
242      * 
243      * @param _base When being used for a data type this is the extended object
244      *               otherwise this is the string base to compare against
245      * @param _value The string the base is being compared to
246      * @return bool Simply notates if the two string have an equivalent value
247      *              discarding case
248      */
249     function compareToIgnoreCase(string _base, string _value)
250         internal
251         pure
252         returns (bool) {
253         bytes memory _baseBytes = bytes(_base);
254         bytes memory _valueBytes = bytes(_value);
255 
256         if (_baseBytes.length != _valueBytes.length) {
257             return false;
258         }
259 
260         for(uint i = 0; i < _baseBytes.length; i++) {
261             if (_baseBytes[i] != _valueBytes[i] && 
262                 _upper(_baseBytes[i]) != _upper(_valueBytes[i])) {
263                 return false;
264             }
265         }
266 
267         return true;
268     }
269 
270     /**
271      * Upper
272      * 
273      * Converts all the values of a string to their corresponding upper case
274      * value.
275      * 
276      * @param _base When being used for a data type this is the extended object
277      *              otherwise this is the string base to convert to upper case
278      * @return string 
279      */
280     function upper(string _base) 
281         internal
282         pure
283         returns (string) {
284         bytes memory _baseBytes = bytes(_base);
285         for (uint i = 0; i < _baseBytes.length; i++) {
286             _baseBytes[i] = _upper(_baseBytes[i]);
287         }
288         return string(_baseBytes);
289     }
290 
291     /**
292      * Lower
293      * 
294      * Converts all the values of a string to their corresponding lower case
295      * value.
296      * 
297      * @param _base When being used for a data type this is the extended object
298      *              otherwise this is the string base to convert to lower case
299      * @return string 
300      */
301     function lower(string _base) 
302         internal
303         pure
304         returns (string) {
305         bytes memory _baseBytes = bytes(_base);
306         for (uint i = 0; i < _baseBytes.length; i++) {
307             _baseBytes[i] = _lower(_baseBytes[i]);
308         }
309         return string(_baseBytes);
310     }
311 
312     /**
313      * Upper
314      * 
315      * Convert an alphabetic character to upper case and return the original
316      * value when not alphabetic
317      * 
318      * @param _b1 The byte to be converted to upper case
319      * @return bytes1 The converted value if the passed value was alphabetic
320      *                and in a lower case otherwise returns the original value
321      */
322     function _upper(bytes1 _b1)
323         private
324         pure
325         returns (bytes1) {
326 
327         if (_b1 >= 0x61 && _b1 <= 0x7A) {
328             return bytes1(uint8(_b1)-32);
329         }
330 
331         return _b1;
332     }
333 
334     /**
335      * Lower
336      * 
337      * Convert an alphabetic character to lower case and return the original
338      * value when not alphabetic
339      * 
340      * @param _b1 The byte to be converted to lower case
341      * @return bytes1 The converted value if the passed value was alphabetic
342      *                and in a upper case otherwise returns the original value
343      */
344     function _lower(bytes1 _b1)
345         private
346         pure
347         returns (bytes1) {
348 
349         if (_b1 >= 0x41 && _b1 <= 0x5A) {
350             return bytes1(uint8(_b1)+32);
351         }
352         
353         return _b1;
354     }
355 }
356 
357 contract Beneficiary {
358     /// @notice Receive ethers to the given wallet's given balance type
359     /// @param wallet The address of the concerned wallet
360     /// @param balanceType The target balance type of the wallet
361     function receiveEthersTo(address wallet, string balanceType)
362     public
363     payable;
364 
365     /// @notice Receive token to the given wallet's given balance type
366     /// @dev The wallet must approve of the token transfer prior to calling this function
367     /// @param wallet The address of the concerned wallet
368     /// @param balanceType The target balance type of the wallet
369     /// @param amount The amount to deposit
370     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
371     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
372     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
373     function receiveTokensTo(address wallet, string balanceType, int256 amount, address currencyCt,
374         uint256 currencyId, string standard)
375     public;
376 }
377 
378 contract AccrualBeneficiary is Beneficiary {
379     //
380     // Functions
381     // -----------------------------------------------------------------------------------------------------------------
382     event CloseAccrualPeriodEvent();
383 
384     //
385     // Functions
386     // -----------------------------------------------------------------------------------------------------------------
387     function closeAccrualPeriod(MonetaryTypesLib.Currency[])
388     public
389     {
390         emit CloseAccrualPeriodEvent();
391     }
392 }
393 
394 library ConstantsLib {
395     // Get the fraction that represents the entirety, equivalent of 100%
396     function PARTS_PER()
397     public
398     pure
399     returns (int256)
400     {
401         return 1e18;
402     }
403 }
404 
405 library CurrenciesLib {
406     using SafeMathUintLib for uint256;
407 
408     //
409     // Structures
410     // -----------------------------------------------------------------------------------------------------------------
411     struct Currencies {
412         MonetaryTypesLib.Currency[] currencies;
413         mapping(address => mapping(uint256 => uint256)) indexByCurrency;
414     }
415 
416     //
417     // Functions
418     // -----------------------------------------------------------------------------------------------------------------
419     function add(Currencies storage self, address currencyCt, uint256 currencyId)
420     internal
421     {
422         // Index is 1-based
423         if (0 == self.indexByCurrency[currencyCt][currencyId]) {
424             self.currencies.push(MonetaryTypesLib.Currency(currencyCt, currencyId));
425             self.indexByCurrency[currencyCt][currencyId] = self.currencies.length;
426         }
427     }
428 
429     function removeByCurrency(Currencies storage self, address currencyCt, uint256 currencyId)
430     internal
431     {
432         // Index is 1-based
433         uint256 index = self.indexByCurrency[currencyCt][currencyId];
434         if (0 < index)
435             removeByIndex(self, index - 1);
436     }
437 
438     function removeByIndex(Currencies storage self, uint256 index)
439     internal
440     {
441         require(index < self.currencies.length);
442 
443         address currencyCt = self.currencies[index].ct;
444         uint256 currencyId = self.currencies[index].id;
445 
446         if (index < self.currencies.length - 1) {
447             self.currencies[index] = self.currencies[self.currencies.length - 1];
448             self.indexByCurrency[self.currencies[index].ct][self.currencies[index].id] = index + 1;
449         }
450         self.currencies.length--;
451         self.indexByCurrency[currencyCt][currencyId] = 0;
452     }
453 
454     function count(Currencies storage self)
455     internal
456     view
457     returns (uint256)
458     {
459         return self.currencies.length;
460     }
461 
462     function has(Currencies storage self, address currencyCt, uint256 currencyId)
463     internal
464     view
465     returns (bool)
466     {
467         return 0 != self.indexByCurrency[currencyCt][currencyId];
468     }
469 
470     function getByIndex(Currencies storage self, uint256 index)
471     internal
472     view
473     returns (MonetaryTypesLib.Currency)
474     {
475         require(index < self.currencies.length);
476         return self.currencies[index];
477     }
478 
479     function getByIndices(Currencies storage self, uint256 low, uint256 up)
480     internal
481     view
482     returns (MonetaryTypesLib.Currency[])
483     {
484         require(0 < self.currencies.length);
485         require(low <= up);
486 
487         up = up.clampMax(self.currencies.length - 1);
488         MonetaryTypesLib.Currency[] memory _currencies = new MonetaryTypesLib.Currency[](up - low + 1);
489         for (uint256 i = low; i <= up; i++)
490             _currencies[i - low] = self.currencies[i];
491 
492         return _currencies;
493     }
494 }
495 
496 library DriipSettlementTypesLib {
497     //
498     // Structures
499     // -----------------------------------------------------------------------------------------------------------------
500     enum SettlementRole {Origin, Target}
501 
502     struct SettlementParty {
503         uint256 nonce;
504         address wallet;
505         bool done;
506     }
507 
508     struct Settlement {
509         string settledKind;
510         bytes32 settledHash;
511         SettlementParty origin;
512         SettlementParty target;
513     }
514 }
515 
516 library FungibleBalanceLib {
517     using SafeMathIntLib for int256;
518     using SafeMathUintLib for uint256;
519     using CurrenciesLib for CurrenciesLib.Currencies;
520 
521     //
522     // Structures
523     // -----------------------------------------------------------------------------------------------------------------
524     struct Record {
525         int256 amount;
526         uint256 blockNumber;
527     }
528 
529     struct Balance {
530         mapping(address => mapping(uint256 => int256)) amountByCurrency;
531         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
532 
533         CurrenciesLib.Currencies inUseCurrencies;
534         CurrenciesLib.Currencies everUsedCurrencies;
535     }
536 
537     //
538     // Functions
539     // -----------------------------------------------------------------------------------------------------------------
540     function get(Balance storage self, address currencyCt, uint256 currencyId)
541     internal
542     view
543     returns (int256)
544     {
545         return self.amountByCurrency[currencyCt][currencyId];
546     }
547 
548     function getByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
549     internal
550     view
551     returns (int256)
552     {
553         (int256 amount,) = recordByBlockNumber(self, currencyCt, currencyId, blockNumber);
554         return amount;
555     }
556 
557     function set(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
558     internal
559     {
560         self.amountByCurrency[currencyCt][currencyId] = amount;
561 
562         self.recordsByCurrency[currencyCt][currencyId].push(
563             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
564         );
565 
566         updateCurrencies(self, currencyCt, currencyId);
567     }
568 
569     function add(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
570     internal
571     {
572         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add(amount);
573 
574         self.recordsByCurrency[currencyCt][currencyId].push(
575             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
576         );
577 
578         updateCurrencies(self, currencyCt, currencyId);
579     }
580 
581     function sub(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
582     internal
583     {
584         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub(amount);
585 
586         self.recordsByCurrency[currencyCt][currencyId].push(
587             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
588         );
589 
590         updateCurrencies(self, currencyCt, currencyId);
591     }
592 
593     function transfer(Balance storage _from, Balance storage _to, int256 amount,
594         address currencyCt, uint256 currencyId)
595     internal
596     {
597         sub(_from, amount, currencyCt, currencyId);
598         add(_to, amount, currencyCt, currencyId);
599     }
600 
601     function add_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
602     internal
603     {
604         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add_nn(amount);
605 
606         self.recordsByCurrency[currencyCt][currencyId].push(
607             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
608         );
609 
610         updateCurrencies(self, currencyCt, currencyId);
611     }
612 
613     function sub_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
614     internal
615     {
616         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub_nn(amount);
617 
618         self.recordsByCurrency[currencyCt][currencyId].push(
619             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
620         );
621 
622         updateCurrencies(self, currencyCt, currencyId);
623     }
624 
625     function transfer_nn(Balance storage _from, Balance storage _to, int256 amount,
626         address currencyCt, uint256 currencyId)
627     internal
628     {
629         sub_nn(_from, amount, currencyCt, currencyId);
630         add_nn(_to, amount, currencyCt, currencyId);
631     }
632 
633     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
634     internal
635     view
636     returns (uint256)
637     {
638         return self.recordsByCurrency[currencyCt][currencyId].length;
639     }
640 
641     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
642     internal
643     view
644     returns (int256, uint256)
645     {
646         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
647         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (0, 0);
648     }
649 
650     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
651     internal
652     view
653     returns (int256, uint256)
654     {
655         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
656             return (0, 0);
657 
658         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
659         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
660         return (record.amount, record.blockNumber);
661     }
662 
663     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
664     internal
665     view
666     returns (int256, uint256)
667     {
668         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
669             return (0, 0);
670 
671         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
672         return (record.amount, record.blockNumber);
673     }
674 
675     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
676     internal
677     view
678     returns (bool)
679     {
680         return self.inUseCurrencies.has(currencyCt, currencyId);
681     }
682 
683     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
684     internal
685     view
686     returns (bool)
687     {
688         return self.everUsedCurrencies.has(currencyCt, currencyId);
689     }
690 
691     function updateCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
692     internal
693     {
694         if (0 == self.amountByCurrency[currencyCt][currencyId] && self.inUseCurrencies.has(currencyCt, currencyId))
695             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
696         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
697             self.inUseCurrencies.add(currencyCt, currencyId);
698             self.everUsedCurrencies.add(currencyCt, currencyId);
699         }
700     }
701 
702     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
703     internal
704     view
705     returns (uint256)
706     {
707         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
708             return 0;
709         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
710             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
711                 return i;
712         return 0;
713     }
714 }
715 
716 contract Modifiable {
717     //
718     // Modifiers
719     // -----------------------------------------------------------------------------------------------------------------
720     modifier notNullAddress(address _address) {
721         require(_address != address(0));
722         _;
723     }
724 
725     modifier notThisAddress(address _address) {
726         require(_address != address(this));
727         _;
728     }
729 
730     modifier notNullOrThisAddress(address _address) {
731         require(_address != address(0));
732         require(_address != address(this));
733         _;
734     }
735 
736     modifier notSameAddresses(address _address1, address _address2) {
737         if (_address1 != _address2)
738             _;
739     }
740 }
741 
742 library MonetaryTypesLib {
743     //
744     // Structures
745     // -----------------------------------------------------------------------------------------------------------------
746     struct Currency {
747         address ct;
748         uint256 id;
749     }
750 
751     struct Figure {
752         int256 amount;
753         Currency currency;
754     }
755 
756     struct NoncedAmount {
757         uint256 nonce;
758         int256 amount;
759     }
760 }
761 
762 library NahmiiTypesLib {
763     //
764     // Enums
765     // -----------------------------------------------------------------------------------------------------------------
766     enum ChallengePhase {Dispute, Closed}
767 
768     //
769     // Structures
770     // -----------------------------------------------------------------------------------------------------------------
771     struct OriginFigure {
772         uint256 originId;
773         MonetaryTypesLib.Figure figure;
774     }
775 
776     struct IntendedConjugateCurrency {
777         MonetaryTypesLib.Currency intended;
778         MonetaryTypesLib.Currency conjugate;
779     }
780 
781     struct SingleFigureTotalOriginFigures {
782         MonetaryTypesLib.Figure single;
783         OriginFigure[] total;
784     }
785 
786     struct TotalOriginFigures {
787         OriginFigure[] total;
788     }
789 
790     struct CurrentPreviousInt256 {
791         int256 current;
792         int256 previous;
793     }
794 
795     struct SingleTotalInt256 {
796         int256 single;
797         int256 total;
798     }
799 
800     struct IntendedConjugateCurrentPreviousInt256 {
801         CurrentPreviousInt256 intended;
802         CurrentPreviousInt256 conjugate;
803     }
804 
805     struct IntendedConjugateSingleTotalInt256 {
806         SingleTotalInt256 intended;
807         SingleTotalInt256 conjugate;
808     }
809 
810     struct WalletOperatorHashes {
811         bytes32 wallet;
812         bytes32 operator;
813     }
814 
815     struct Signature {
816         bytes32 r;
817         bytes32 s;
818         uint8 v;
819     }
820 
821     struct Seal {
822         bytes32 hash;
823         Signature signature;
824     }
825 
826     struct WalletOperatorSeal {
827         Seal wallet;
828         Seal operator;
829     }
830 }
831 
832 library SafeMathIntLib {
833     int256 constant INT256_MIN = int256((uint256(1) << 255));
834     int256 constant INT256_MAX = int256(~((uint256(1) << 255)));
835 
836     //
837     //Functions below accept positive and negative integers and result must not overflow.
838     //
839     function div(int256 a, int256 b)
840     internal
841     pure
842     returns (int256)
843     {
844         require(a != INT256_MIN || b != - 1);
845         return a / b;
846     }
847 
848     function mul(int256 a, int256 b)
849     internal
850     pure
851     returns (int256)
852     {
853         require(a != - 1 || b != INT256_MIN);
854         // overflow
855         require(b != - 1 || a != INT256_MIN);
856         // overflow
857         int256 c = a * b;
858         require((b == 0) || (c / b == a));
859         return c;
860     }
861 
862     function sub(int256 a, int256 b)
863     internal
864     pure
865     returns (int256)
866     {
867         require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
868         return a - b;
869     }
870 
871     function add(int256 a, int256 b)
872     internal
873     pure
874     returns (int256)
875     {
876         int256 c = a + b;
877         require((b >= 0 && c >= a) || (b < 0 && c < a));
878         return c;
879     }
880 
881     //
882     //Functions below only accept positive integers and result must be greater or equal to zero too.
883     //
884     function div_nn(int256 a, int256 b)
885     internal
886     pure
887     returns (int256)
888     {
889         require(a >= 0 && b > 0);
890         return a / b;
891     }
892 
893     function mul_nn(int256 a, int256 b)
894     internal
895     pure
896     returns (int256)
897     {
898         require(a >= 0 && b >= 0);
899         int256 c = a * b;
900         require(a == 0 || c / a == b);
901         require(c >= 0);
902         return c;
903     }
904 
905     function sub_nn(int256 a, int256 b)
906     internal
907     pure
908     returns (int256)
909     {
910         require(a >= 0 && b >= 0 && b <= a);
911         return a - b;
912     }
913 
914     function add_nn(int256 a, int256 b)
915     internal
916     pure
917     returns (int256)
918     {
919         require(a >= 0 && b >= 0);
920         int256 c = a + b;
921         require(c >= a);
922         return c;
923     }
924 
925     //
926     //Conversion and validation functions.
927     //
928     function abs(int256 a)
929     public
930     pure
931     returns (int256)
932     {
933         return a < 0 ? neg(a) : a;
934     }
935 
936     function neg(int256 a)
937     public
938     pure
939     returns (int256)
940     {
941         return mul(a, - 1);
942     }
943 
944     function toNonZeroInt256(uint256 a)
945     public
946     pure
947     returns (int256)
948     {
949         require(a > 0 && a < (uint256(1) << 255));
950         return int256(a);
951     }
952 
953     function toInt256(uint256 a)
954     public
955     pure
956     returns (int256)
957     {
958         require(a >= 0 && a < (uint256(1) << 255));
959         return int256(a);
960     }
961 
962     function toUInt256(int256 a)
963     public
964     pure
965     returns (uint256)
966     {
967         require(a >= 0);
968         return uint256(a);
969     }
970 
971     function isNonZeroPositiveInt256(int256 a)
972     public
973     pure
974     returns (bool)
975     {
976         return (a > 0);
977     }
978 
979     function isPositiveInt256(int256 a)
980     public
981     pure
982     returns (bool)
983     {
984         return (a >= 0);
985     }
986 
987     function isNonZeroNegativeInt256(int256 a)
988     public
989     pure
990     returns (bool)
991     {
992         return (a < 0);
993     }
994 
995     function isNegativeInt256(int256 a)
996     public
997     pure
998     returns (bool)
999     {
1000         return (a <= 0);
1001     }
1002 
1003     //
1004     //Clamping functions.
1005     //
1006     function clamp(int256 a, int256 min, int256 max)
1007     public
1008     pure
1009     returns (int256)
1010     {
1011         if (a < min)
1012             return min;
1013         return (a > max) ? max : a;
1014     }
1015 
1016     function clampMin(int256 a, int256 min)
1017     public
1018     pure
1019     returns (int256)
1020     {
1021         return (a < min) ? min : a;
1022     }
1023 
1024     function clampMax(int256 a, int256 max)
1025     public
1026     pure
1027     returns (int256)
1028     {
1029         return (a > max) ? max : a;
1030     }
1031 }
1032 
1033 library SafeMathUintLib {
1034     function mul(uint256 a, uint256 b)
1035     internal
1036     pure
1037     returns (uint256)
1038     {
1039         uint256 c = a * b;
1040         assert(a == 0 || c / a == b);
1041         return c;
1042     }
1043 
1044     function div(uint256 a, uint256 b)
1045     internal
1046     pure
1047     returns (uint256)
1048     {
1049         // assert(b > 0); // Solidity automatically throws when dividing by 0
1050         uint256 c = a / b;
1051         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1052         return c;
1053     }
1054 
1055     function sub(uint256 a, uint256 b)
1056     internal
1057     pure
1058     returns (uint256)
1059     {
1060         assert(b <= a);
1061         return a - b;
1062     }
1063 
1064     function add(uint256 a, uint256 b)
1065     internal
1066     pure
1067     returns (uint256)
1068     {
1069         uint256 c = a + b;
1070         assert(c >= a);
1071         return c;
1072     }
1073 
1074     //
1075     //Clamping functions.
1076     //
1077     function clamp(uint256 a, uint256 min, uint256 max)
1078     public
1079     pure
1080     returns (uint256)
1081     {
1082         return (a > max) ? max : ((a < min) ? min : a);
1083     }
1084 
1085     function clampMin(uint256 a, uint256 min)
1086     public
1087     pure
1088     returns (uint256)
1089     {
1090         return (a < min) ? min : a;
1091     }
1092 
1093     function clampMax(uint256 a, uint256 max)
1094     public
1095     pure
1096     returns (uint256)
1097     {
1098         return (a > max) ? max : a;
1099     }
1100 }
1101 
1102 contract SelfDestructible {
1103     //
1104     // Variables
1105     // -----------------------------------------------------------------------------------------------------------------
1106     bool public selfDestructionDisabled;
1107 
1108     //
1109     // Events
1110     // -----------------------------------------------------------------------------------------------------------------
1111     event SelfDestructionDisabledEvent(address wallet);
1112     event TriggerSelfDestructionEvent(address wallet);
1113 
1114     //
1115     // Functions
1116     // -----------------------------------------------------------------------------------------------------------------
1117     /// @notice Get the address of the destructor role
1118     function destructor()
1119     public
1120     view
1121     returns (address);
1122 
1123     /// @notice Disable self-destruction of this contract
1124     /// @dev This operation can not be undone
1125     function disableSelfDestruction()
1126     public
1127     {
1128         // Require that sender is the assigned destructor
1129         require(destructor() == msg.sender);
1130 
1131         // Disable self-destruction
1132         selfDestructionDisabled = true;
1133 
1134         // Emit event
1135         emit SelfDestructionDisabledEvent(msg.sender);
1136     }
1137 
1138     /// @notice Destroy this contract
1139     function triggerSelfDestruction()
1140     public
1141     {
1142         // Require that sender is the assigned destructor
1143         require(destructor() == msg.sender);
1144 
1145         // Require that self-destruction has not been disabled
1146         require(!selfDestructionDisabled);
1147 
1148         // Emit event
1149         emit TriggerSelfDestructionEvent(msg.sender);
1150 
1151         // Self-destruct and reward destructor
1152         selfdestruct(msg.sender);
1153     }
1154 }
1155 
1156 contract Ownable is Modifiable, SelfDestructible {
1157     //
1158     // Variables
1159     // -----------------------------------------------------------------------------------------------------------------
1160     address public deployer;
1161     address public operator;
1162 
1163     //
1164     // Events
1165     // -----------------------------------------------------------------------------------------------------------------
1166     event SetDeployerEvent(address oldDeployer, address newDeployer);
1167     event SetOperatorEvent(address oldOperator, address newOperator);
1168 
1169     //
1170     // Constructor
1171     // -----------------------------------------------------------------------------------------------------------------
1172     constructor(address _deployer) internal notNullOrThisAddress(_deployer) {
1173         deployer = _deployer;
1174         operator = _deployer;
1175     }
1176 
1177     //
1178     // Functions
1179     // -----------------------------------------------------------------------------------------------------------------
1180     /// @notice Return the address that is able to initiate self-destruction
1181     function destructor()
1182     public
1183     view
1184     returns (address)
1185     {
1186         return deployer;
1187     }
1188 
1189     /// @notice Set the deployer of this contract
1190     /// @param newDeployer The address of the new deployer
1191     function setDeployer(address newDeployer)
1192     public
1193     onlyDeployer
1194     notNullOrThisAddress(newDeployer)
1195     {
1196         if (newDeployer != deployer) {
1197             // Set new deployer
1198             address oldDeployer = deployer;
1199             deployer = newDeployer;
1200 
1201             // Emit event
1202             emit SetDeployerEvent(oldDeployer, newDeployer);
1203         }
1204     }
1205 
1206     /// @notice Set the operator of this contract
1207     /// @param newOperator The address of the new operator
1208     function setOperator(address newOperator)
1209     public
1210     onlyOperator
1211     notNullOrThisAddress(newOperator)
1212     {
1213         if (newOperator != operator) {
1214             // Set new operator
1215             address oldOperator = operator;
1216             operator = newOperator;
1217 
1218             // Emit event
1219             emit SetOperatorEvent(oldOperator, newOperator);
1220         }
1221     }
1222 
1223     /// @notice Gauge whether message sender is deployer or not
1224     /// @return true if msg.sender is deployer, else false
1225     function isDeployer()
1226     internal
1227     view
1228     returns (bool)
1229     {
1230         return msg.sender == deployer;
1231     }
1232 
1233     /// @notice Gauge whether message sender is operator or not
1234     /// @return true if msg.sender is operator, else false
1235     function isOperator()
1236     internal
1237     view
1238     returns (bool)
1239     {
1240         return msg.sender == operator;
1241     }
1242 
1243     /// @notice Gauge whether message sender is operator or deployer on the one hand, or none of these on these on
1244     /// on the other hand
1245     /// @return true if msg.sender is operator, else false
1246     function isDeployerOrOperator()
1247     internal
1248     view
1249     returns (bool)
1250     {
1251         return isDeployer() || isOperator();
1252     }
1253 
1254     // Modifiers
1255     // -----------------------------------------------------------------------------------------------------------------
1256     modifier onlyDeployer() {
1257         require(isDeployer());
1258         _;
1259     }
1260 
1261     modifier notDeployer() {
1262         require(!isDeployer());
1263         _;
1264     }
1265 
1266     modifier onlyOperator() {
1267         require(isOperator());
1268         _;
1269     }
1270 
1271     modifier notOperator() {
1272         require(!isOperator());
1273         _;
1274     }
1275 
1276     modifier onlyDeployerOrOperator() {
1277         require(isDeployerOrOperator());
1278         _;
1279     }
1280 
1281     modifier notDeployerOrOperator() {
1282         require(!isDeployerOrOperator());
1283         _;
1284     }
1285 }
1286 
1287 contract Benefactor is Ownable {
1288     //
1289     // Variables
1290     // -----------------------------------------------------------------------------------------------------------------
1291     address[] internal beneficiaries;
1292     mapping(address => uint256) internal beneficiaryIndexByAddress;
1293 
1294     //
1295     // Events
1296     // -----------------------------------------------------------------------------------------------------------------
1297     event RegisterBeneficiaryEvent(address beneficiary);
1298     event DeregisterBeneficiaryEvent(address beneficiary);
1299 
1300     //
1301     // Functions
1302     // -----------------------------------------------------------------------------------------------------------------
1303     /// @notice Register the given beneficiary
1304     /// @param beneficiary Address of beneficiary to be registered
1305     function registerBeneficiary(address beneficiary)
1306     public
1307     onlyDeployer
1308     notNullAddress(beneficiary)
1309     returns (bool)
1310     {
1311         if (beneficiaryIndexByAddress[beneficiary] > 0)
1312             return false;
1313 
1314         beneficiaries.push(beneficiary);
1315         beneficiaryIndexByAddress[beneficiary] = beneficiaries.length;
1316 
1317         // Emit event
1318         emit RegisterBeneficiaryEvent(beneficiary);
1319 
1320         return true;
1321     }
1322 
1323     /// @notice Deregister the given beneficiary
1324     /// @param beneficiary Address of beneficiary to be deregistered
1325     function deregisterBeneficiary(address beneficiary)
1326     public
1327     onlyDeployer
1328     notNullAddress(beneficiary)
1329     returns (bool)
1330     {
1331         if (beneficiaryIndexByAddress[beneficiary] == 0)
1332             return false;
1333 
1334         uint256 idx = beneficiaryIndexByAddress[beneficiary] - 1;
1335         if (idx < beneficiaries.length - 1) {
1336             // Remap the last item in the array to this index
1337             beneficiaries[idx] = beneficiaries[beneficiaries.length - 1];
1338             beneficiaryIndexByAddress[beneficiaries[idx]] = idx + 1;
1339         }
1340         beneficiaries.length--;
1341         beneficiaryIndexByAddress[beneficiary] = 0;
1342 
1343         // Emit event
1344         emit DeregisterBeneficiaryEvent(beneficiary);
1345 
1346         return true;
1347     }
1348 
1349     /// @notice Gauge whether the given address is the one of a registered beneficiary
1350     /// @param beneficiary Address of beneficiary
1351     /// @return true if beneficiary is registered, else false
1352     function isRegisteredBeneficiary(address beneficiary)
1353     public
1354     view
1355     returns (bool)
1356     {
1357         return beneficiaryIndexByAddress[beneficiary] > 0;
1358     }
1359 
1360     /// @notice Get the count of registered beneficiaries
1361     /// @return The count of registered beneficiaries
1362     function registeredBeneficiariesCount()
1363     public
1364     view
1365     returns (uint256)
1366     {
1367         return beneficiaries.length;
1368     }
1369 }
1370 
1371 contract AccrualBenefactor is Benefactor {
1372     using SafeMathIntLib for int256;
1373 
1374     //
1375     // Variables
1376     // -----------------------------------------------------------------------------------------------------------------
1377     mapping(address => int256) private _beneficiaryFractionMap;
1378     int256 public totalBeneficiaryFraction;
1379 
1380     //
1381     // Events
1382     // -----------------------------------------------------------------------------------------------------------------
1383     event RegisterAccrualBeneficiaryEvent(address beneficiary, int256 fraction);
1384     event DeregisterAccrualBeneficiaryEvent(address beneficiary);
1385 
1386     //
1387     // Functions
1388     // -----------------------------------------------------------------------------------------------------------------
1389     /// @notice Register the given beneficiary for the entirety fraction
1390     /// @param beneficiary Address of beneficiary to be registered
1391     function registerBeneficiary(address beneficiary)
1392     public
1393     onlyDeployer
1394     notNullAddress(beneficiary)
1395     returns (bool)
1396     {
1397         return registerFractionalBeneficiary(beneficiary, ConstantsLib.PARTS_PER());
1398     }
1399 
1400     /// @notice Register the given beneficiary for the given fraction
1401     /// @param beneficiary Address of beneficiary to be registered
1402     /// @param fraction Fraction of benefits to be given
1403     function registerFractionalBeneficiary(address beneficiary, int256 fraction)
1404     public
1405     onlyDeployer
1406     notNullAddress(beneficiary)
1407     returns (bool)
1408     {
1409         require(fraction > 0);
1410         require(totalBeneficiaryFraction.add(fraction) <= ConstantsLib.PARTS_PER());
1411 
1412         if (!super.registerBeneficiary(beneficiary))
1413             return false;
1414 
1415         _beneficiaryFractionMap[beneficiary] = fraction;
1416         totalBeneficiaryFraction = totalBeneficiaryFraction.add(fraction);
1417 
1418         // Emit event
1419         emit RegisterAccrualBeneficiaryEvent(beneficiary, fraction);
1420 
1421         return true;
1422     }
1423 
1424     /// @notice Deregister the given beneficiary
1425     /// @param beneficiary Address of beneficiary to be deregistered
1426     function deregisterBeneficiary(address beneficiary)
1427     public
1428     onlyDeployer
1429     notNullAddress(beneficiary)
1430     returns (bool)
1431     {
1432         if (!super.deregisterBeneficiary(beneficiary))
1433             return false;
1434 
1435         totalBeneficiaryFraction = totalBeneficiaryFraction.sub(_beneficiaryFractionMap[beneficiary]);
1436         _beneficiaryFractionMap[beneficiary] = 0;
1437 
1438         // Emit event
1439         emit DeregisterAccrualBeneficiaryEvent(beneficiary);
1440 
1441         return true;
1442     }
1443 
1444     /// @notice Get the fraction of benefits that is granted the given beneficiary
1445     /// @param beneficiary Address of beneficiary
1446     /// @return The beneficiary's fraction
1447     function beneficiaryFraction(address beneficiary)
1448     public
1449     view
1450     returns (int256)
1451     {
1452         return _beneficiaryFractionMap[beneficiary];
1453     }
1454 }
1455 
1456 contract CommunityVotable is Ownable {
1457     //
1458     // Variables
1459     // -----------------------------------------------------------------------------------------------------------------
1460     CommunityVote public communityVote;
1461     bool public communityVoteFrozen;
1462 
1463     //
1464     // Events
1465     // -----------------------------------------------------------------------------------------------------------------
1466     event SetCommunityVoteEvent(CommunityVote oldCommunityVote, CommunityVote newCommunityVote);
1467     event FreezeCommunityVoteEvent();
1468 
1469     //
1470     // Functions
1471     // -----------------------------------------------------------------------------------------------------------------
1472     /// @notice Set the community vote contract
1473     /// @param newCommunityVote The (address of) CommunityVote contract instance
1474     function setCommunityVote(CommunityVote newCommunityVote) 
1475     public 
1476     onlyDeployer
1477     notNullAddress(newCommunityVote)
1478     notSameAddresses(newCommunityVote, communityVote)
1479     {
1480         require(!communityVoteFrozen);
1481 
1482         // Set new community vote
1483         CommunityVote oldCommunityVote = communityVote;
1484         communityVote = newCommunityVote;
1485 
1486         // Emit event
1487         emit SetCommunityVoteEvent(oldCommunityVote, newCommunityVote);
1488     }
1489 
1490     /// @notice Freeze the community vote from further updates
1491     /// @dev This operation can not be undone
1492     function freezeCommunityVote()
1493     public
1494     onlyDeployer
1495     {
1496         communityVoteFrozen = true;
1497 
1498         // Emit event
1499         emit FreezeCommunityVoteEvent();
1500     }
1501 
1502     //
1503     // Modifiers
1504     // -----------------------------------------------------------------------------------------------------------------
1505     modifier communityVoteInitialized() {
1506         require(communityVote != address(0));
1507         _;
1508     }
1509 }
1510 
1511 contract CommunityVote is Ownable {
1512     //
1513     // Variables
1514     // -----------------------------------------------------------------------------------------------------------------
1515     mapping(address => bool) doubleSpenderByWallet;
1516     uint256 maxDriipNonce;
1517     uint256 maxNullNonce;
1518     bool dataAvailable;
1519 
1520     //
1521     // Constructor
1522     // -----------------------------------------------------------------------------------------------------------------
1523     constructor(address deployer) Ownable(deployer) public {
1524         dataAvailable = true;
1525     }
1526 
1527     //
1528     // Results functions
1529     // -----------------------------------------------------------------------------------------------------------------
1530     /// @notice Get the double spender status of given wallet
1531     /// @param wallet The wallet address for which to check double spender status
1532     /// @return true if wallet is double spender, false otherwise
1533     function isDoubleSpenderWallet(address wallet)
1534     public
1535     view
1536     returns (bool)
1537     {
1538         return doubleSpenderByWallet[wallet];
1539     }
1540 
1541     /// @notice Get the max driip nonce to be accepted in settlements
1542     /// @return the max driip nonce
1543     function getMaxDriipNonce()
1544     public
1545     view
1546     returns (uint256)
1547     {
1548         return maxDriipNonce;
1549     }
1550 
1551     /// @notice Get the max null settlement nonce to be accepted in settlements
1552     /// @return the max driip nonce
1553     function getMaxNullNonce()
1554     public
1555     view
1556     returns (uint256)
1557     {
1558         return maxNullNonce;
1559     }
1560 
1561     /// @notice Get the data availability status
1562     /// @return true if data is available
1563     function isDataAvailable()
1564     public
1565     view
1566     returns (bool)
1567     {
1568         return dataAvailable;
1569     }
1570 }
1571 
1572 contract Servable is Ownable {
1573     //
1574     // Types
1575     // -----------------------------------------------------------------------------------------------------------------
1576     struct ServiceInfo {
1577         bool registered;
1578         uint256 activationTimestamp;
1579         mapping(bytes32 => bool) actionsEnabledMap;
1580         bytes32[] actionsList;
1581     }
1582 
1583     //
1584     // Variables
1585     // -----------------------------------------------------------------------------------------------------------------
1586     mapping(address => ServiceInfo) internal registeredServicesMap;
1587     uint256 public serviceActivationTimeout;
1588 
1589     //
1590     // Events
1591     // -----------------------------------------------------------------------------------------------------------------
1592     event ServiceActivationTimeoutEvent(uint256 timeoutInSeconds);
1593     event RegisterServiceEvent(address service);
1594     event RegisterServiceDeferredEvent(address service, uint256 timeout);
1595     event DeregisterServiceEvent(address service);
1596     event EnableServiceActionEvent(address service, string action);
1597     event DisableServiceActionEvent(address service, string action);
1598 
1599     //
1600     // Functions
1601     // -----------------------------------------------------------------------------------------------------------------
1602     /// @notice Set the service activation timeout
1603     /// @param timeoutInSeconds The set timeout in unit of seconds
1604     function setServiceActivationTimeout(uint256 timeoutInSeconds)
1605     public
1606     onlyDeployer
1607     {
1608         serviceActivationTimeout = timeoutInSeconds;
1609 
1610         // Emit event
1611         emit ServiceActivationTimeoutEvent(timeoutInSeconds);
1612     }
1613 
1614     /// @notice Register a service contract whose activation is immediate
1615     /// @param service The address of the service contract to be registered
1616     function registerService(address service)
1617     public
1618     onlyDeployer
1619     notNullOrThisAddress(service)
1620     {
1621         _registerService(service, 0);
1622 
1623         // Emit event
1624         emit RegisterServiceEvent(service);
1625     }
1626 
1627     /// @notice Register a service contract whose activation is deferred by the service activation timeout
1628     /// @param service The address of the service contract to be registered
1629     function registerServiceDeferred(address service)
1630     public
1631     onlyDeployer
1632     notNullOrThisAddress(service)
1633     {
1634         _registerService(service, serviceActivationTimeout);
1635 
1636         // Emit event
1637         emit RegisterServiceDeferredEvent(service, serviceActivationTimeout);
1638     }
1639 
1640     /// @notice Deregister a service contract
1641     /// @param service The address of the service contract to be deregistered
1642     function deregisterService(address service)
1643     public
1644     onlyDeployer
1645     notNullOrThisAddress(service)
1646     {
1647         require(registeredServicesMap[service].registered);
1648 
1649         registeredServicesMap[service].registered = false;
1650 
1651         // Emit event
1652         emit DeregisterServiceEvent(service);
1653     }
1654 
1655     /// @notice Enable a named action in an already registered service contract
1656     /// @param service The address of the registered service contract
1657     /// @param action The name of the action to be enabled
1658     function enableServiceAction(address service, string action)
1659     public
1660     onlyDeployer
1661     notNullOrThisAddress(service)
1662     {
1663         require(registeredServicesMap[service].registered);
1664 
1665         bytes32 actionHash = hashString(action);
1666 
1667         require(!registeredServicesMap[service].actionsEnabledMap[actionHash]);
1668 
1669         registeredServicesMap[service].actionsEnabledMap[actionHash] = true;
1670         registeredServicesMap[service].actionsList.push(actionHash);
1671 
1672         // Emit event
1673         emit EnableServiceActionEvent(service, action);
1674     }
1675 
1676     /// @notice Enable a named action in a service contract
1677     /// @param service The address of the service contract
1678     /// @param action The name of the action to be disabled
1679     function disableServiceAction(address service, string action)
1680     public
1681     onlyDeployer
1682     notNullOrThisAddress(service)
1683     {
1684         bytes32 actionHash = hashString(action);
1685 
1686         require(registeredServicesMap[service].actionsEnabledMap[actionHash]);
1687 
1688         registeredServicesMap[service].actionsEnabledMap[actionHash] = false;
1689 
1690         // Emit event
1691         emit DisableServiceActionEvent(service, action);
1692     }
1693 
1694     /// @notice Gauge whether a service contract is registered
1695     /// @param service The address of the service contract
1696     /// @return true if service is registered, else false
1697     function isRegisteredService(address service)
1698     public
1699     view
1700     returns (bool)
1701     {
1702         return registeredServicesMap[service].registered;
1703     }
1704 
1705     /// @notice Gauge whether a service contract is registered and active
1706     /// @param service The address of the service contract
1707     /// @return true if service is registered and activate, else false
1708     function isRegisteredActiveService(address service)
1709     public
1710     view
1711     returns (bool)
1712     {
1713         return isRegisteredService(service) && block.timestamp >= registeredServicesMap[service].activationTimestamp;
1714     }
1715 
1716     /// @notice Gauge whether a service contract action is enabled which implies also registered and active
1717     /// @param service The address of the service contract
1718     /// @param action The name of action
1719     function isEnabledServiceAction(address service, string action)
1720     public
1721     view
1722     returns (bool)
1723     {
1724         bytes32 actionHash = hashString(action);
1725         return isRegisteredActiveService(service) && registeredServicesMap[service].actionsEnabledMap[actionHash];
1726     }
1727 
1728     //
1729     // Internal functions
1730     // -----------------------------------------------------------------------------------------------------------------
1731     function hashString(string _string)
1732     internal
1733     pure
1734     returns (bytes32)
1735     {
1736         return keccak256(abi.encodePacked(_string));
1737     }
1738 
1739     //
1740     // Private functions
1741     // -----------------------------------------------------------------------------------------------------------------
1742     function _registerService(address service, uint256 timeout)
1743     private
1744     {
1745         if (!registeredServicesMap[service].registered) {
1746             registeredServicesMap[service].registered = true;
1747             registeredServicesMap[service].activationTimestamp = block.timestamp + timeout;
1748         }
1749     }
1750 
1751     //
1752     // Modifiers
1753     // -----------------------------------------------------------------------------------------------------------------
1754     modifier onlyActiveService() {
1755         require(isRegisteredActiveService(msg.sender));
1756         _;
1757     }
1758 
1759     modifier onlyEnabledServiceAction(string action) {
1760         require(isEnabledServiceAction(msg.sender, action));
1761         _;
1762     }
1763 }
1764 
1765 contract DriipSettlementState is Ownable, Servable, CommunityVotable {
1766     using SafeMathIntLib for int256;
1767     using SafeMathUintLib for uint256;
1768 
1769     //
1770     // Constants
1771     // -----------------------------------------------------------------------------------------------------------------
1772     string constant public INIT_SETTLEMENT_ACTION = "init_settlement";
1773     string constant public SET_SETTLEMENT_ROLE_DONE_ACTION = "set_settlement_role_done";
1774     string constant public SET_MAX_NONCE_ACTION = "set_max_nonce";
1775     string constant public SET_MAX_DRIIP_NONCE_ACTION = "set_max_driip_nonce";
1776     string constant public SET_FEE_TOTAL_ACTION = "set_fee_total";
1777 
1778     //
1779     // Variables
1780     // -----------------------------------------------------------------------------------------------------------------
1781     uint256 public maxDriipNonce;
1782 
1783     DriipSettlementTypesLib.Settlement[] public settlements;
1784     mapping(address => uint256[]) public walletSettlementIndices;
1785     mapping(address => mapping(uint256 => uint256)) public walletNonceSettlementIndex;
1786     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyMaxNonce;
1787 
1788     mapping(address => mapping(address => mapping(address => mapping(address => mapping(uint256 => MonetaryTypesLib.NoncedAmount))))) public totalFeesMap;
1789 
1790     //
1791     // Events
1792     // -----------------------------------------------------------------------------------------------------------------
1793     event InitSettlementEvent(DriipSettlementTypesLib.Settlement settlement);
1794     event SetSettlementRoleDoneEvent(address wallet, uint256 nonce,
1795         DriipSettlementTypesLib.SettlementRole settlementRole, bool done);
1796     event SetMaxNonceByWalletAndCurrencyEvent(address wallet, MonetaryTypesLib.Currency currency,
1797         uint256 maxNonce);
1798     event SetMaxDriipNonceEvent(uint256 maxDriipNonce);
1799     event UpdateMaxDriipNonceFromCommunityVoteEvent(uint256 maxDriipNonce);
1800     event SetTotalFeeEvent(address wallet, Beneficiary beneficiary, address destination,
1801         MonetaryTypesLib.Currency currency, MonetaryTypesLib.NoncedAmount totalFee);
1802 
1803     //
1804     // Constructor
1805     // -----------------------------------------------------------------------------------------------------------------
1806     constructor(address deployer) Ownable(deployer) public {
1807     }
1808 
1809     //
1810     // Functions
1811     // -----------------------------------------------------------------------------------------------------------------
1812     /// @notice Get the count of settlements
1813     function settlementsCount()
1814     public
1815     view
1816     returns (uint256)
1817     {
1818         return settlements.length;
1819     }
1820 
1821     /// @notice Get the count of settlements for given wallet
1822     /// @param wallet The address for which to return settlement count
1823     /// @return count of settlements for the provided wallet
1824     function settlementsCountByWallet(address wallet)
1825     public
1826     view
1827     returns (uint256)
1828     {
1829         return walletSettlementIndices[wallet].length;
1830     }
1831 
1832     /// @notice Get settlement of given wallet and index
1833     /// @param wallet The address for which to return settlement
1834     /// @param index The wallet's settlement index
1835     /// @return settlement for the provided wallet and index
1836     function settlementByWalletAndIndex(address wallet, uint256 index)
1837     public
1838     view
1839     returns (DriipSettlementTypesLib.Settlement)
1840     {
1841         require(walletSettlementIndices[wallet].length > index);
1842         return settlements[walletSettlementIndices[wallet][index] - 1];
1843     }
1844 
1845     /// @notice Get settlement of given wallet and wallet nonce
1846     /// @param wallet The address for which to return settlement
1847     /// @param nonce The wallet's nonce
1848     /// @return settlement for the provided wallet and index
1849     function settlementByWalletAndNonce(address wallet, uint256 nonce)
1850     public
1851     view
1852     returns (DriipSettlementTypesLib.Settlement)
1853     {
1854         require(0 < walletNonceSettlementIndex[wallet][nonce]);
1855         return settlements[walletNonceSettlementIndex[wallet][nonce] - 1];
1856     }
1857 
1858     /// @notice Initialize settlement, i.e. create one if no such settlement exists
1859     /// for the double pair of wallets and nonces
1860     /// @param settledKind The kind of driip of the settlement
1861     /// @param settledHash The hash of driip of the settlement
1862     /// @param originWallet The address of the origin wallet
1863     /// @param originNonce The wallet nonce of the origin wallet
1864     /// @param targetWallet The address of the target wallet
1865     /// @param targetNonce The wallet nonce of the target wallet
1866     function initSettlement(string settledKind, bytes32 settledHash, address originWallet,
1867         uint256 originNonce, address targetWallet, uint256 targetNonce)
1868     public
1869     onlyEnabledServiceAction(INIT_SETTLEMENT_ACTION)
1870     {
1871         if (
1872             0 == walletNonceSettlementIndex[originWallet][originNonce] &&
1873             0 == walletNonceSettlementIndex[targetWallet][targetNonce]
1874         ) {
1875             // Create new settlement
1876             settlements.length++;
1877 
1878             // Get the 0-based index
1879             uint256 index = settlements.length - 1;
1880 
1881             // Update settlement
1882             settlements[index].settledKind = settledKind;
1883             settlements[index].settledHash = settledHash;
1884             settlements[index].origin.nonce = originNonce;
1885             settlements[index].origin.wallet = originWallet;
1886             settlements[index].target.nonce = targetNonce;
1887             settlements[index].target.wallet = targetWallet;
1888 
1889             // Emit event
1890             emit InitSettlementEvent(settlements[index]);
1891 
1892             // Store 1-based index value
1893             index++;
1894             walletSettlementIndices[originWallet].push(index);
1895             walletSettlementIndices[targetWallet].push(index);
1896             walletNonceSettlementIndex[originWallet][originNonce] = index;
1897             walletNonceSettlementIndex[targetWallet][targetNonce] = index;
1898         }
1899     }
1900 
1901     /// @notice Gauge whether the settlement is done wrt the given settlement role
1902     /// @param wallet The address of the concerned wallet
1903     /// @param nonce The nonce of the concerned wallet
1904     /// @param settlementRole The settlement role
1905     /// @return True if settlement is done for role, else false
1906     function isSettlementRoleDone(address wallet, uint256 nonce,
1907         DriipSettlementTypesLib.SettlementRole settlementRole)
1908     public
1909     view
1910     returns (bool)
1911     {
1912         // Get the 1-based index of the settlement
1913         uint256 index = walletNonceSettlementIndex[wallet][nonce];
1914 
1915         // Return false if settlement does not exist
1916         if (0 == index)
1917             return false;
1918 
1919         // Return done of settlement role
1920         if (DriipSettlementTypesLib.SettlementRole.Origin == settlementRole)
1921             return settlements[index - 1].origin.done;
1922         else // DriipSettlementTypesLib.SettlementRole.Target == settlementRole
1923             return settlements[index - 1].target.done;
1924     }
1925 
1926     /// @notice Set the done of the given settlement role in the given settlement
1927     /// @param wallet The address of the concerned wallet
1928     /// @param nonce The nonce of the concerned wallet
1929     /// @param settlementRole The settlement role
1930     /// @param done The done flag
1931     function setSettlementRoleDone(address wallet, uint256 nonce,
1932         DriipSettlementTypesLib.SettlementRole settlementRole, bool done)
1933     public
1934     onlyEnabledServiceAction(SET_SETTLEMENT_ROLE_DONE_ACTION)
1935     {
1936         // Get the 1-based index of the settlement
1937         uint256 index = walletNonceSettlementIndex[wallet][nonce];
1938 
1939         // Require the existence of settlement
1940         require(0 != index);
1941 
1942         // Update the settlement role done value
1943         if (DriipSettlementTypesLib.SettlementRole.Origin == settlementRole)
1944             settlements[index - 1].origin.done = done;
1945         else // DriipSettlementTypesLib.SettlementRole.Target == settlementRole
1946             settlements[index - 1].target.done = done;
1947 
1948         // Emit event
1949         emit SetSettlementRoleDoneEvent(wallet, nonce, settlementRole, done);
1950     }
1951 
1952     /// @notice Set the max (driip) nonce
1953     /// @param _maxDriipNonce The max nonce
1954     function setMaxDriipNonce(uint256 _maxDriipNonce)
1955     public
1956     onlyEnabledServiceAction(SET_MAX_DRIIP_NONCE_ACTION)
1957     {
1958         maxDriipNonce = _maxDriipNonce;
1959 
1960         // Emit event
1961         emit SetMaxDriipNonceEvent(maxDriipNonce);
1962     }
1963 
1964     /// @notice Update the max driip nonce property from CommunityVote contract
1965     function updateMaxDriipNonceFromCommunityVote()
1966     public
1967     {
1968         uint256 _maxDriipNonce = communityVote.getMaxDriipNonce();
1969         if (0 == _maxDriipNonce)
1970             return;
1971 
1972         maxDriipNonce = _maxDriipNonce;
1973 
1974         // Emit event
1975         emit UpdateMaxDriipNonceFromCommunityVoteEvent(maxDriipNonce);
1976     }
1977 
1978     /// @notice Get the max nonce of the given wallet and currency
1979     /// @param wallet The address of the concerned wallet
1980     /// @param currency The concerned currency
1981     /// @return The max nonce
1982     function maxNonceByWalletAndCurrency(address wallet, MonetaryTypesLib.Currency currency)
1983     public
1984     view
1985     returns (uint256)
1986     {
1987         return walletCurrencyMaxNonce[wallet][currency.ct][currency.id];
1988     }
1989 
1990     /// @notice Set the max nonce of the given wallet and currency
1991     /// @param wallet The address of the concerned wallet
1992     /// @param currency The concerned currency
1993     /// @param maxNonce The max nonce
1994     function setMaxNonceByWalletAndCurrency(address wallet, MonetaryTypesLib.Currency currency,
1995         uint256 maxNonce)
1996     public
1997     onlyEnabledServiceAction(SET_MAX_NONCE_ACTION)
1998     {
1999         // Update max nonce value
2000         walletCurrencyMaxNonce[wallet][currency.ct][currency.id] = maxNonce;
2001 
2002         // Emit event
2003         emit SetMaxNonceByWalletAndCurrencyEvent(wallet, currency, maxNonce);
2004     }
2005 
2006     /// @notice Get the total fee payed by the given wallet to the given beneficiary and destination
2007     /// in the given currency
2008     /// @param wallet The address of the concerned wallet
2009     /// @param beneficiary The concerned beneficiary
2010     /// @param destination The concerned destination
2011     /// @param currency The concerned currency
2012     /// @return The total fee
2013     function totalFee(address wallet, Beneficiary beneficiary, address destination,
2014         MonetaryTypesLib.Currency currency)
2015     public
2016     view
2017     returns (MonetaryTypesLib.NoncedAmount)
2018     {
2019         return totalFeesMap[wallet][address(beneficiary)][destination][currency.ct][currency.id];
2020     }
2021 
2022     /// @notice Set the total fee payed by the given wallet to the given beneficiary and destination
2023     /// in the given currency
2024     /// @param wallet The address of the concerned wallet
2025     /// @param beneficiary The concerned beneficiary
2026     /// @param destination The concerned destination
2027     /// @param _totalFee The total fee
2028     function setTotalFee(address wallet, Beneficiary beneficiary, address destination,
2029         MonetaryTypesLib.Currency currency, MonetaryTypesLib.NoncedAmount _totalFee)
2030     public
2031     onlyEnabledServiceAction(SET_FEE_TOTAL_ACTION)
2032     {
2033         // Update total fees value
2034         totalFeesMap[wallet][address(beneficiary)][destination][currency.ct][currency.id] = _totalFee;
2035 
2036         // Emit event
2037         emit SetTotalFeeEvent(wallet, beneficiary, destination, currency, _totalFee);
2038     }
2039 }
2040 
2041 contract TransferController {
2042     //
2043     // Events
2044     // -----------------------------------------------------------------------------------------------------------------
2045     event CurrencyTransferred(address from, address to, uint256 value,
2046         address currencyCt, uint256 currencyId);
2047 
2048     //
2049     // Functions
2050     // -----------------------------------------------------------------------------------------------------------------
2051     function isFungible()
2052     public
2053     view
2054     returns (bool);
2055 
2056     /// @notice MUST be called with DELEGATECALL
2057     function receive(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
2058     public;
2059 
2060     /// @notice MUST be called with DELEGATECALL
2061     function approve(address to, uint256 value, address currencyCt, uint256 currencyId)
2062     public;
2063 
2064     /// @notice MUST be called with DELEGATECALL
2065     function dispatch(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
2066     public;
2067 
2068     //----------------------------------------
2069 
2070     function getReceiveSignature()
2071     public
2072     pure
2073     returns (bytes4)
2074     {
2075         return bytes4(keccak256("receive(address,address,uint256,address,uint256)"));
2076     }
2077 
2078     function getApproveSignature()
2079     public
2080     pure
2081     returns (bytes4)
2082     {
2083         return bytes4(keccak256("approve(address,uint256,address,uint256)"));
2084     }
2085 
2086     function getDispatchSignature()
2087     public
2088     pure
2089     returns (bytes4)
2090     {
2091         return bytes4(keccak256("dispatch(address,address,uint256,address,uint256)"));
2092     }
2093 }
2094 
2095 contract TransferControllerManageable is Ownable {
2096     //
2097     // Variables
2098     // -----------------------------------------------------------------------------------------------------------------
2099     TransferControllerManager public transferControllerManager;
2100 
2101     //
2102     // Events
2103     // -----------------------------------------------------------------------------------------------------------------
2104     event SetTransferControllerManagerEvent(TransferControllerManager oldTransferControllerManager,
2105         TransferControllerManager newTransferControllerManager);
2106 
2107     //
2108     // Functions
2109     // -----------------------------------------------------------------------------------------------------------------
2110     /// @notice Set the currency manager contract
2111     /// @param newTransferControllerManager The (address of) TransferControllerManager contract instance
2112     function setTransferControllerManager(TransferControllerManager newTransferControllerManager)
2113     public
2114     onlyDeployer
2115     notNullAddress(newTransferControllerManager)
2116     notSameAddresses(newTransferControllerManager, transferControllerManager)
2117     {
2118         //set new currency manager
2119         TransferControllerManager oldTransferControllerManager = transferControllerManager;
2120         transferControllerManager = newTransferControllerManager;
2121 
2122         // Emit event
2123         emit SetTransferControllerManagerEvent(oldTransferControllerManager, newTransferControllerManager);
2124     }
2125 
2126     /// @notice Get the transfer controller of the given currency contract address and standard
2127     function transferController(address currencyCt, string standard)
2128     internal
2129     view
2130     returns (TransferController)
2131     {
2132         return transferControllerManager.transferController(currencyCt, standard);
2133     }
2134 
2135     //
2136     // Modifiers
2137     // -----------------------------------------------------------------------------------------------------------------
2138     modifier transferControllerManagerInitialized() {
2139         require(transferControllerManager != address(0));
2140         _;
2141     }
2142 }
2143 
2144 contract PartnerFund is Ownable, Beneficiary, TransferControllerManageable {
2145     using FungibleBalanceLib for FungibleBalanceLib.Balance;
2146     using TxHistoryLib for TxHistoryLib.TxHistory;
2147     using SafeMathIntLib for int256;
2148     using Strings for string;
2149 
2150     //
2151     // Structures
2152     // -----------------------------------------------------------------------------------------------------------------
2153     struct Partner {
2154         bytes32 nameHash;
2155 
2156         uint256 fee;
2157         address wallet;
2158         uint256 index;
2159 
2160         bool operatorCanUpdate;
2161         bool partnerCanUpdate;
2162 
2163         FungibleBalanceLib.Balance active;
2164         FungibleBalanceLib.Balance staged;
2165 
2166         TxHistoryLib.TxHistory txHistory;
2167         FullBalanceHistory[] fullBalanceHistory;
2168     }
2169 
2170     struct FullBalanceHistory {
2171         uint256 listIndex;
2172         int256 balance;
2173         uint256 blockNumber;
2174     }
2175 
2176     //
2177     // Variables
2178     // -----------------------------------------------------------------------------------------------------------------
2179     Partner[] private partners;
2180 
2181     mapping(bytes32 => uint256) private _indexByNameHash;
2182     mapping(address => uint256) private _indexByWallet;
2183 
2184     //
2185     // Events
2186     // -----------------------------------------------------------------------------------------------------------------
2187     event ReceiveEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
2188     event RegisterPartnerByNameEvent(string name, uint256 fee, address wallet);
2189     event RegisterPartnerByNameHashEvent(bytes32 nameHash, uint256 fee, address wallet);
2190     event SetFeeByIndexEvent(uint256 index, uint256 oldFee, uint256 newFee);
2191     event SetFeeByNameEvent(string name, uint256 oldFee, uint256 newFee);
2192     event SetFeeByNameHashEvent(bytes32 nameHash, uint256 oldFee, uint256 newFee);
2193     event SetFeeByWalletEvent(address wallet, uint256 oldFee, uint256 newFee);
2194     event SetPartnerWalletByIndexEvent(uint256 index, address oldWallet, address newWallet);
2195     event SetPartnerWalletByNameEvent(string name, address oldWallet, address newWallet);
2196     event SetPartnerWalletByNameHashEvent(bytes32 nameHash, address oldWallet, address newWallet);
2197     event SetPartnerWalletByWalletEvent(address oldWallet, address newWallet);
2198     event StageEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
2199     event WithdrawEvent(address to, int256 amount, address currencyCt, uint256 currencyId);
2200 
2201     //
2202     // Constructor
2203     // -----------------------------------------------------------------------------------------------------------------
2204     constructor(address deployer) Ownable(deployer) public {
2205     }
2206 
2207     //
2208     // Functions
2209     // -----------------------------------------------------------------------------------------------------------------
2210     /// @notice Fallback function that deposits ethers
2211     function() public payable {
2212         _receiveEthersTo(
2213             indexByWallet(msg.sender) - 1, SafeMathIntLib.toNonZeroInt256(msg.value)
2214         );
2215     }
2216 
2217     /// @notice Receive ethers to
2218     /// @param tag The tag of the concerned partner
2219     function receiveEthersTo(address tag, string)
2220     public
2221     payable
2222     {
2223         _receiveEthersTo(
2224             uint256(tag) - 1, SafeMathIntLib.toNonZeroInt256(msg.value)
2225         );
2226     }
2227 
2228     /// @notice Receive tokens
2229     /// @param amount The concerned amount
2230     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2231     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2232     /// @param standard The standard of token ("ERC20", "ERC721")
2233     function receiveTokens(string, int256 amount, address currencyCt,
2234         uint256 currencyId, string standard)
2235     public
2236     {
2237         _receiveTokensTo(
2238             indexByWallet(msg.sender) - 1, amount, currencyCt, currencyId, standard
2239         );
2240     }
2241 
2242     /// @notice Receive tokens to
2243     /// @param tag The tag of the concerned partner
2244     /// @param amount The concerned amount
2245     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2246     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2247     /// @param standard The standard of token ("ERC20", "ERC721")
2248     function receiveTokensTo(address tag, string, int256 amount, address currencyCt,
2249         uint256 currencyId, string standard)
2250     public
2251     {
2252         _receiveTokensTo(
2253             uint256(tag) - 1, amount, currencyCt, currencyId, standard
2254         );
2255     }
2256 
2257     /// @notice Hash name
2258     /// @param name The name to be hashed
2259     /// @return The hash value
2260     function hashName(string name)
2261     public
2262     pure
2263     returns (bytes32)
2264     {
2265         return keccak256(abi.encodePacked(name.upper()));
2266     }
2267 
2268     /// @notice Get deposit by partner and deposit indices
2269     /// @param partnerIndex The index of the concerned partner
2270     /// @param depositIndex The index of the concerned deposit
2271     /// return The deposit parameters
2272     function depositByIndices(uint256 partnerIndex, uint256 depositIndex)
2273     public
2274     view
2275     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
2276     {
2277         // Require partner index is one of registered partner
2278         require(0 < partnerIndex && partnerIndex <= partners.length);
2279 
2280         return _depositByIndices(partnerIndex - 1, depositIndex);
2281     }
2282 
2283     /// @notice Get deposit by partner name and deposit indices
2284     /// @param name The name of the concerned partner
2285     /// @param depositIndex The index of the concerned deposit
2286     /// return The deposit parameters
2287     function depositByName(string name, uint depositIndex)
2288     public
2289     view
2290     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
2291     {
2292         // Implicitly require that partner name is registered
2293         return _depositByIndices(indexByName(name) - 1, depositIndex);
2294     }
2295 
2296     /// @notice Get deposit by partner name hash and deposit indices
2297     /// @param nameHash The hashed name of the concerned partner
2298     /// @param depositIndex The index of the concerned deposit
2299     /// return The deposit parameters
2300     function depositByNameHash(bytes32 nameHash, uint depositIndex)
2301     public
2302     view
2303     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
2304     {
2305         // Implicitly require that partner name hash is registered
2306         return _depositByIndices(indexByNameHash(nameHash) - 1, depositIndex);
2307     }
2308 
2309     /// @notice Get deposit by partner wallet and deposit indices
2310     /// @param wallet The wallet of the concerned partner
2311     /// @param depositIndex The index of the concerned deposit
2312     /// return The deposit parameters
2313     function depositByWallet(address wallet, uint depositIndex)
2314     public
2315     view
2316     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
2317     {
2318         // Implicitly require that partner wallet is registered
2319         return _depositByIndices(indexByWallet(wallet) - 1, depositIndex);
2320     }
2321 
2322     /// @notice Get deposits count by partner index
2323     /// @param index The index of the concerned partner
2324     /// return The deposits count
2325     function depositsCountByIndex(uint256 index)
2326     public
2327     view
2328     returns (uint256)
2329     {
2330         // Require partner index is one of registered partner
2331         require(0 < index && index <= partners.length);
2332 
2333         return _depositsCountByIndex(index - 1);
2334     }
2335 
2336     /// @notice Get deposits count by partner name
2337     /// @param name The name of the concerned partner
2338     /// return The deposits count
2339     function depositsCountByName(string name)
2340     public
2341     view
2342     returns (uint256)
2343     {
2344         // Implicitly require that partner name is registered
2345         return _depositsCountByIndex(indexByName(name) - 1);
2346     }
2347 
2348     /// @notice Get deposits count by partner name hash
2349     /// @param nameHash The hashed name of the concerned partner
2350     /// return The deposits count
2351     function depositsCountByNameHash(bytes32 nameHash)
2352     public
2353     view
2354     returns (uint256)
2355     {
2356         // Implicitly require that partner name hash is registered
2357         return _depositsCountByIndex(indexByNameHash(nameHash) - 1);
2358     }
2359 
2360     /// @notice Get deposits count by partner wallet
2361     /// @param wallet The wallet of the concerned partner
2362     /// return The deposits count
2363     function depositsCountByWallet(address wallet)
2364     public
2365     view
2366     returns (uint256)
2367     {
2368         // Implicitly require that partner wallet is registered
2369         return _depositsCountByIndex(indexByWallet(wallet) - 1);
2370     }
2371 
2372     /// @notice Get active balance by partner index and currency
2373     /// @param index The index of the concerned partner
2374     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2375     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2376     /// return The active balance
2377     function activeBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
2378     public
2379     view
2380     returns (int256)
2381     {
2382         // Require partner index is one of registered partner
2383         require(0 < index && index <= partners.length);
2384 
2385         return _activeBalanceByIndex(index - 1, currencyCt, currencyId);
2386     }
2387 
2388     /// @notice Get active balance by partner name and currency
2389     /// @param name The name of the concerned partner
2390     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2391     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2392     /// return The active balance
2393     function activeBalanceByName(string name, address currencyCt, uint256 currencyId)
2394     public
2395     view
2396     returns (int256)
2397     {
2398         // Implicitly require that partner name is registered
2399         return _activeBalanceByIndex(indexByName(name) - 1, currencyCt, currencyId);
2400     }
2401 
2402     /// @notice Get active balance by partner name hash and currency
2403     /// @param nameHash The hashed name of the concerned partner
2404     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2405     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2406     /// return The active balance
2407     function activeBalanceByNameHash(bytes32 nameHash, address currencyCt, uint256 currencyId)
2408     public
2409     view
2410     returns (int256)
2411     {
2412         // Implicitly require that partner name hash is registered
2413         return _activeBalanceByIndex(indexByNameHash(nameHash) - 1, currencyCt, currencyId);
2414     }
2415 
2416     /// @notice Get active balance by partner wallet and currency
2417     /// @param wallet The wallet of the concerned partner
2418     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2419     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2420     /// return The active balance
2421     function activeBalanceByWallet(address wallet, address currencyCt, uint256 currencyId)
2422     public
2423     view
2424     returns (int256)
2425     {
2426         // Implicitly require that partner wallet is registered
2427         return _activeBalanceByIndex(indexByWallet(wallet) - 1, currencyCt, currencyId);
2428     }
2429 
2430     /// @notice Get staged balance by partner index and currency
2431     /// @param index The index of the concerned partner
2432     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2433     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2434     /// return The staged balance
2435     function stagedBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
2436     public
2437     view
2438     returns (int256)
2439     {
2440         // Require partner index is one of registered partner
2441         require(0 < index && index <= partners.length);
2442 
2443         return _stagedBalanceByIndex(index - 1, currencyCt, currencyId);
2444     }
2445 
2446     /// @notice Get staged balance by partner name and currency
2447     /// @param name The name of the concerned partner
2448     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2449     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2450     /// return The staged balance
2451     function stagedBalanceByName(string name, address currencyCt, uint256 currencyId)
2452     public
2453     view
2454     returns (int256)
2455     {
2456         // Implicitly require that partner name is registered
2457         return _stagedBalanceByIndex(indexByName(name) - 1, currencyCt, currencyId);
2458     }
2459 
2460     /// @notice Get staged balance by partner name hash and currency
2461     /// @param nameHash The hashed name of the concerned partner
2462     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2463     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2464     /// return The staged balance
2465     function stagedBalanceByNameHash(bytes32 nameHash, address currencyCt, uint256 currencyId)
2466     public
2467     view
2468     returns (int256)
2469     {
2470         // Implicitly require that partner name is registered
2471         return _stagedBalanceByIndex(indexByNameHash(nameHash) - 1, currencyCt, currencyId);
2472     }
2473 
2474     /// @notice Get staged balance by partner wallet and currency
2475     /// @param wallet The wallet of the concerned partner
2476     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2477     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2478     /// return The staged balance
2479     function stagedBalanceByWallet(address wallet, address currencyCt, uint256 currencyId)
2480     public
2481     view
2482     returns (int256)
2483     {
2484         // Implicitly require that partner wallet is registered
2485         return _stagedBalanceByIndex(indexByWallet(wallet) - 1, currencyCt, currencyId);
2486     }
2487 
2488     /// @notice Get the number of partners
2489     /// @return The number of partners
2490     function partnersCount()
2491     public
2492     view
2493     returns (uint256)
2494     {
2495         return partners.length;
2496     }
2497 
2498     /// @notice Register a partner by name
2499     /// @param name The name of the concerned partner
2500     /// @param fee The partner's fee fraction
2501     /// @param wallet The partner's wallet
2502     /// @param partnerCanUpdate Indicator of whether partner can update fee and wallet
2503     /// @param operatorCanUpdate Indicator of whether operator can update fee and wallet
2504     function registerByName(string name, uint256 fee, address wallet,
2505         bool partnerCanUpdate, bool operatorCanUpdate)
2506     public
2507     onlyOperator
2508     {
2509         // Require not empty name string
2510         require(bytes(name).length > 0);
2511 
2512         // Hash name
2513         bytes32 nameHash = hashName(name);
2514 
2515         // Register partner
2516         _registerPartnerByNameHash(nameHash, fee, wallet, partnerCanUpdate, operatorCanUpdate);
2517 
2518         // Emit event
2519         emit RegisterPartnerByNameEvent(name, fee, wallet);
2520     }
2521 
2522     /// @notice Register a partner by name hash
2523     /// @param nameHash The hashed name of the concerned partner
2524     /// @param fee The partner's fee fraction
2525     /// @param wallet The partner's wallet
2526     /// @param partnerCanUpdate Indicator of whether partner can update fee and wallet
2527     /// @param operatorCanUpdate Indicator of whether operator can update fee and wallet
2528     function registerByNameHash(bytes32 nameHash, uint256 fee, address wallet,
2529         bool partnerCanUpdate, bool operatorCanUpdate)
2530     public
2531     onlyOperator
2532     {
2533         // Register partner
2534         _registerPartnerByNameHash(nameHash, fee, wallet, partnerCanUpdate, operatorCanUpdate);
2535 
2536         // Emit event
2537         emit RegisterPartnerByNameHashEvent(nameHash, fee, wallet);
2538     }
2539 
2540     /// @notice Gets the 1-based index of partner by its name
2541     /// @dev Reverts if name does not correspond to registered partner
2542     /// @return Index of partner by given name
2543     function indexByNameHash(bytes32 nameHash)
2544     public
2545     view
2546     returns (uint256)
2547     {
2548         uint256 index = _indexByNameHash[nameHash];
2549         require(0 < index);
2550         return index;
2551     }
2552 
2553     /// @notice Gets the 1-based index of partner by its name
2554     /// @dev Reverts if name does not correspond to registered partner
2555     /// @return Index of partner by given name
2556     function indexByName(string name)
2557     public
2558     view
2559     returns (uint256)
2560     {
2561         return indexByNameHash(hashName(name));
2562     }
2563 
2564     /// @notice Gets the 1-based index of partner by its wallet
2565     /// @dev Reverts if wallet does not correspond to registered partner
2566     /// @return Index of partner by given wallet
2567     function indexByWallet(address wallet)
2568     public
2569     view
2570     returns (uint256)
2571     {
2572         uint256 index = _indexByWallet[wallet];
2573         require(0 < index);
2574         return index;
2575     }
2576 
2577     /// @notice Gauge whether a partner by the given name is registered
2578     /// @param name The name of the concerned partner
2579     /// @return true if partner is registered, else false
2580     function isRegisteredByName(string name)
2581     public
2582     view
2583     returns (bool)
2584     {
2585         return (0 < _indexByNameHash[hashName(name)]);
2586     }
2587 
2588     /// @notice Gauge whether a partner by the given name hash is registered
2589     /// @param nameHash The hashed name of the concerned partner
2590     /// @return true if partner is registered, else false
2591     function isRegisteredByNameHash(bytes32 nameHash)
2592     public
2593     view
2594     returns (bool)
2595     {
2596         return (0 < _indexByNameHash[nameHash]);
2597     }
2598 
2599     /// @notice Gauge whether a partner by the given wallet is registered
2600     /// @param wallet The wallet of the concerned partner
2601     /// @return true if partner is registered, else false
2602     function isRegisteredByWallet(address wallet)
2603     public
2604     view
2605     returns (bool)
2606     {
2607         return (0 < _indexByWallet[wallet]);
2608     }
2609 
2610     /// @notice Get the partner fee fraction by the given partner index
2611     /// @param index The index of the concerned partner
2612     /// @return The fee fraction
2613     function feeByIndex(uint256 index)
2614     public
2615     view
2616     returns (uint256)
2617     {
2618         // Require partner index is one of registered partner
2619         require(0 < index && index <= partners.length);
2620 
2621         return _partnerFeeByIndex(index - 1);
2622     }
2623 
2624     /// @notice Get the partner fee fraction by the given partner name
2625     /// @param name The name of the concerned partner
2626     /// @return The fee fraction
2627     function feeByName(string name)
2628     public
2629     view
2630     returns (uint256)
2631     {
2632         // Get fee, implicitly requiring that partner name is registered
2633         return _partnerFeeByIndex(indexByName(name) - 1);
2634     }
2635 
2636     /// @notice Get the partner fee fraction by the given partner name hash
2637     /// @param nameHash The hashed name of the concerned partner
2638     /// @return The fee fraction
2639     function feeByNameHash(bytes32 nameHash)
2640     public
2641     view
2642     returns (uint256)
2643     {
2644         // Get fee, implicitly requiring that partner name hash is registered
2645         return _partnerFeeByIndex(indexByNameHash(nameHash) - 1);
2646     }
2647 
2648     /// @notice Get the partner fee fraction by the given partner wallet
2649     /// @param wallet The wallet of the concerned partner
2650     /// @return The fee fraction
2651     function feeByWallet(address wallet)
2652     public
2653     view
2654     returns (uint256)
2655     {
2656         // Get fee, implicitly requiring that partner wallet is registered
2657         return _partnerFeeByIndex(indexByWallet(wallet) - 1);
2658     }
2659 
2660     /// @notice Set the partner fee fraction by the given partner index
2661     /// @param index The index of the concerned partner
2662     /// @param newFee The partner's fee fraction
2663     function setFeeByIndex(uint256 index, uint256 newFee)
2664     public
2665     {
2666         // Require partner index is one of registered partner
2667         require(0 < index && index <= partners.length);
2668 
2669         // Update fee
2670         uint256 oldFee = _setPartnerFeeByIndex(index - 1, newFee);
2671 
2672         // Emit event
2673         emit SetFeeByIndexEvent(index, oldFee, newFee);
2674     }
2675 
2676     /// @notice Set the partner fee fraction by the given partner name
2677     /// @param name The name of the concerned partner
2678     /// @param newFee The partner's fee fraction
2679     function setFeeByName(string name, uint256 newFee)
2680     public
2681     {
2682         // Update fee, implicitly requiring that partner name is registered
2683         uint256 oldFee = _setPartnerFeeByIndex(indexByName(name) - 1, newFee);
2684 
2685         // Emit event
2686         emit SetFeeByNameEvent(name, oldFee, newFee);
2687     }
2688 
2689     /// @notice Set the partner fee fraction by the given partner name hash
2690     /// @param nameHash The hashed name of the concerned partner
2691     /// @param newFee The partner's fee fraction
2692     function setFeeByNameHash(bytes32 nameHash, uint256 newFee)
2693     public
2694     {
2695         // Update fee, implicitly requiring that partner name hash is registered
2696         uint256 oldFee = _setPartnerFeeByIndex(indexByNameHash(nameHash) - 1, newFee);
2697 
2698         // Emit event
2699         emit SetFeeByNameHashEvent(nameHash, oldFee, newFee);
2700     }
2701 
2702     /// @notice Set the partner fee fraction by the given partner wallet
2703     /// @param wallet The wallet of the concerned partner
2704     /// @param newFee The partner's fee fraction
2705     function setFeeByWallet(address wallet, uint256 newFee)
2706     public
2707     {
2708         // Update fee, implicitly requiring that partner wallet is registered
2709         uint256 oldFee = _setPartnerFeeByIndex(indexByWallet(wallet) - 1, newFee);
2710 
2711         // Emit event
2712         emit SetFeeByWalletEvent(wallet, oldFee, newFee);
2713     }
2714 
2715     /// @notice Get the partner wallet by the given partner index
2716     /// @param index The index of the concerned partner
2717     /// @return The wallet
2718     function walletByIndex(uint256 index)
2719     public
2720     view
2721     returns (address)
2722     {
2723         // Require partner index is one of registered partner
2724         require(0 < index && index <= partners.length);
2725 
2726         return partners[index - 1].wallet;
2727     }
2728 
2729     /// @notice Get the partner wallet by the given partner name
2730     /// @param name The name of the concerned partner
2731     /// @return The wallet
2732     function walletByName(string name)
2733     public
2734     view
2735     returns (address)
2736     {
2737         // Get wallet, implicitly requiring that partner name is registered
2738         return partners[indexByName(name) - 1].wallet;
2739     }
2740 
2741     /// @notice Get the partner wallet by the given partner name hash
2742     /// @param nameHash The hashed name of the concerned partner
2743     /// @return The wallet
2744     function walletByNameHash(bytes32 nameHash)
2745     public
2746     view
2747     returns (address)
2748     {
2749         // Get wallet, implicitly requiring that partner name hash is registered
2750         return partners[indexByNameHash(nameHash) - 1].wallet;
2751     }
2752 
2753     /// @notice Set the partner wallet by the given partner index
2754     /// @param index The index of the concerned partner
2755     /// @return newWallet The partner's wallet
2756     function setWalletByIndex(uint256 index, address newWallet)
2757     public
2758     {
2759         // Require partner index is one of registered partner
2760         require(0 < index && index <= partners.length);
2761 
2762         // Update wallet
2763         address oldWallet = _setPartnerWalletByIndex(index - 1, newWallet);
2764 
2765         // Emit event
2766         emit SetPartnerWalletByIndexEvent(index, oldWallet, newWallet);
2767     }
2768 
2769     /// @notice Set the partner wallet by the given partner name
2770     /// @param name The name of the concerned partner
2771     /// @return newWallet The partner's wallet
2772     function setWalletByName(string name, address newWallet)
2773     public
2774     {
2775         // Update wallet
2776         address oldWallet = _setPartnerWalletByIndex(indexByName(name) - 1, newWallet);
2777 
2778         // Emit event
2779         emit SetPartnerWalletByNameEvent(name, oldWallet, newWallet);
2780     }
2781 
2782     /// @notice Set the partner wallet by the given partner name hash
2783     /// @param nameHash The hashed name of the concerned partner
2784     /// @return newWallet The partner's wallet
2785     function setWalletByNameHash(bytes32 nameHash, address newWallet)
2786     public
2787     {
2788         // Update wallet
2789         address oldWallet = _setPartnerWalletByIndex(indexByNameHash(nameHash) - 1, newWallet);
2790 
2791         // Emit event
2792         emit SetPartnerWalletByNameHashEvent(nameHash, oldWallet, newWallet);
2793     }
2794 
2795     /// @notice Set the new partner wallet by the given old partner wallet
2796     /// @param oldWallet The old wallet of the concerned partner
2797     /// @return newWallet The partner's new wallet
2798     function setWalletByWallet(address oldWallet, address newWallet)
2799     public
2800     {
2801         // Update wallet
2802         _setPartnerWalletByIndex(indexByWallet(oldWallet) - 1, newWallet);
2803 
2804         // Emit event
2805         emit SetPartnerWalletByWalletEvent(oldWallet, newWallet);
2806     }
2807 
2808     /// @notice Stage the amount for subsequent withdrawal
2809     /// @param amount The concerned amount to stage
2810     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2811     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2812     function stage(int256 amount, address currencyCt, uint256 currencyId)
2813     public
2814     {
2815         // Get index, implicitly requiring that msg.sender is wallet of registered partner
2816         uint256 index = indexByWallet(msg.sender);
2817 
2818         // Require positive amount
2819         require(amount.isPositiveInt256());
2820 
2821         // Clamp amount to move
2822         amount = amount.clampMax(partners[index - 1].active.get(currencyCt, currencyId));
2823 
2824         partners[index - 1].active.sub(amount, currencyCt, currencyId);
2825         partners[index - 1].staged.add(amount, currencyCt, currencyId);
2826 
2827         partners[index - 1].txHistory.addDeposit(amount, currencyCt, currencyId);
2828 
2829         // Add to full deposit history
2830         partners[index - 1].fullBalanceHistory.push(
2831             FullBalanceHistory(
2832                 partners[index - 1].txHistory.depositsCount() - 1,
2833                 partners[index - 1].active.get(currencyCt, currencyId),
2834                 block.number
2835             )
2836         );
2837 
2838         // Emit event
2839         emit StageEvent(msg.sender, amount, currencyCt, currencyId);
2840     }
2841 
2842     /// @notice Withdraw the given amount from staged balance
2843     /// @param amount The concerned amount to withdraw
2844     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2845     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2846     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
2847     function withdraw(int256 amount, address currencyCt, uint256 currencyId, string standard)
2848     public
2849     {
2850         // Get index, implicitly requiring that msg.sender is wallet of registered partner
2851         uint256 index = indexByWallet(msg.sender);
2852 
2853         // Require positive amount
2854         require(amount.isPositiveInt256());
2855 
2856         // Clamp amount to move
2857         amount = amount.clampMax(partners[index - 1].staged.get(currencyCt, currencyId));
2858 
2859         partners[index - 1].staged.sub(amount, currencyCt, currencyId);
2860 
2861         // Execute transfer
2862         if (address(0) == currencyCt && 0 == currencyId)
2863             msg.sender.transfer(uint256(amount));
2864 
2865         else {
2866             TransferController controller = transferController(currencyCt, standard);
2867             require(
2868                 address(controller).delegatecall(
2869                     controller.getDispatchSignature(), this, msg.sender, uint256(amount), currencyCt, currencyId
2870                 )
2871             );
2872         }
2873 
2874         // Emit event
2875         emit WithdrawEvent(msg.sender, amount, currencyCt, currencyId);
2876     }
2877 
2878     //
2879     // Private functions
2880     // -----------------------------------------------------------------------------------------------------------------
2881     /// @dev index is 0-based
2882     function _receiveEthersTo(uint256 index, int256 amount)
2883     private
2884     {
2885         // Require that index is within bounds
2886         require(index < partners.length);
2887 
2888         // Add to active
2889         partners[index].active.add(amount, address(0), 0);
2890         partners[index].txHistory.addDeposit(amount, address(0), 0);
2891 
2892         // Add to full deposit history
2893         partners[index].fullBalanceHistory.push(
2894             FullBalanceHistory(
2895                 partners[index].txHistory.depositsCount() - 1,
2896                 partners[index].active.get(address(0), 0),
2897                 block.number
2898             )
2899         );
2900 
2901         // Emit event
2902         emit ReceiveEvent(msg.sender, amount, address(0), 0);
2903     }
2904 
2905     /// @dev index is 0-based
2906     function _receiveTokensTo(uint256 index, int256 amount, address currencyCt,
2907         uint256 currencyId, string standard)
2908     private
2909     {
2910         // Require that index is within bounds
2911         require(index < partners.length);
2912 
2913         require(amount.isNonZeroPositiveInt256());
2914 
2915         // Execute transfer
2916         TransferController controller = transferController(currencyCt, standard);
2917         require(
2918             address(controller).delegatecall(
2919                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
2920             )
2921         );
2922 
2923         // Add to active
2924         partners[index].active.add(amount, currencyCt, currencyId);
2925         partners[index].txHistory.addDeposit(amount, currencyCt, currencyId);
2926 
2927         // Add to full deposit history
2928         partners[index].fullBalanceHistory.push(
2929             FullBalanceHistory(
2930                 partners[index].txHistory.depositsCount() - 1,
2931                 partners[index].active.get(currencyCt, currencyId),
2932                 block.number
2933             )
2934         );
2935 
2936         // Emit event
2937         emit ReceiveEvent(msg.sender, amount, currencyCt, currencyId);
2938     }
2939 
2940     /// @dev partnerIndex is 0-based
2941     function _depositByIndices(uint256 partnerIndex, uint256 depositIndex)
2942     private
2943     view
2944     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
2945     {
2946         require(depositIndex < partners[partnerIndex].fullBalanceHistory.length);
2947 
2948         FullBalanceHistory storage entry = partners[partnerIndex].fullBalanceHistory[depositIndex];
2949         (,, currencyCt, currencyId) = partners[partnerIndex].txHistory.deposit(entry.listIndex);
2950 
2951         balance = entry.balance;
2952         blockNumber = entry.blockNumber;
2953     }
2954 
2955     /// @dev index is 0-based
2956     function _depositsCountByIndex(uint256 index)
2957     private
2958     view
2959     returns (uint256)
2960     {
2961         return partners[index].fullBalanceHistory.length;
2962     }
2963 
2964     /// @dev index is 0-based
2965     function _activeBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
2966     private
2967     view
2968     returns (int256)
2969     {
2970         return partners[index].active.get(currencyCt, currencyId);
2971     }
2972 
2973     /// @dev index is 0-based
2974     function _stagedBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
2975     private
2976     view
2977     returns (int256)
2978     {
2979         return partners[index].staged.get(currencyCt, currencyId);
2980     }
2981 
2982     function _registerPartnerByNameHash(bytes32 nameHash, uint256 fee, address wallet,
2983         bool partnerCanUpdate, bool operatorCanUpdate)
2984     private
2985     {
2986         // Require that the name is not previously registered
2987         require(0 == _indexByNameHash[nameHash]);
2988 
2989         // Require possibility to update
2990         require(partnerCanUpdate || operatorCanUpdate);
2991 
2992         // Add new partner
2993         partners.length++;
2994 
2995         // Reference by 1-based index
2996         uint256 index = partners.length;
2997 
2998         // Update partner map
2999         partners[index - 1].nameHash = nameHash;
3000         partners[index - 1].fee = fee;
3001         partners[index - 1].wallet = wallet;
3002         partners[index - 1].partnerCanUpdate = partnerCanUpdate;
3003         partners[index - 1].operatorCanUpdate = operatorCanUpdate;
3004         partners[index - 1].index = index;
3005 
3006         // Update name hash to index map
3007         _indexByNameHash[nameHash] = index;
3008 
3009         // Update wallet to index map
3010         _indexByWallet[wallet] = index;
3011     }
3012 
3013     /// @dev index is 0-based
3014     function _setPartnerFeeByIndex(uint256 index, uint256 fee)
3015     private
3016     returns (uint256)
3017     {
3018         uint256 oldFee = partners[index].fee;
3019 
3020         // If operator tries to change verify that operator has access
3021         if (isOperator())
3022             require(partners[index].operatorCanUpdate);
3023 
3024         else {
3025             // Require that msg.sender is partner
3026             require(msg.sender == partners[index].wallet);
3027 
3028             // If partner tries to change verify that partner has access
3029             require(partners[index].partnerCanUpdate);
3030         }
3031 
3032         // Update stored fee
3033         partners[index].fee = fee;
3034 
3035         return oldFee;
3036     }
3037 
3038     // @dev index is 0-based
3039     function _setPartnerWalletByIndex(uint256 index, address newWallet)
3040     private
3041     returns (address)
3042     {
3043         address oldWallet = partners[index].wallet;
3044 
3045         // If address has not been set operator is the only allowed to change it
3046         if (oldWallet == address(0))
3047             require(isOperator());
3048 
3049         // Else if operator tries to change verify that operator has access
3050         else if (isOperator())
3051             require(partners[index].operatorCanUpdate);
3052 
3053         else {
3054             // Require that msg.sender is partner
3055             require(msg.sender == oldWallet);
3056 
3057             // If partner tries to change verify that partner has access
3058             require(partners[index].partnerCanUpdate);
3059 
3060             // Require that new wallet is not zero-address if it can not be changed by operator
3061             require(partners[index].operatorCanUpdate || newWallet != address(0));
3062         }
3063 
3064         // Update stored wallet
3065         partners[index].wallet = newWallet;
3066 
3067         // Update address to tag map
3068         if (oldWallet != address(0))
3069             _indexByWallet[oldWallet] = 0;
3070         if (newWallet != address(0))
3071             _indexByWallet[newWallet] = index;
3072 
3073         return oldWallet;
3074     }
3075 
3076     // @dev index is 0-based
3077     function _partnerFeeByIndex(uint256 index)
3078     private
3079     view
3080     returns (uint256)
3081     {
3082         return partners[index].fee;
3083     }
3084 }
3085 
3086 contract RevenueFund is Ownable, AccrualBeneficiary, AccrualBenefactor, TransferControllerManageable {
3087     using FungibleBalanceLib for FungibleBalanceLib.Balance;
3088     using TxHistoryLib for TxHistoryLib.TxHistory;
3089     using SafeMathIntLib for int256;
3090     using SafeMathUintLib for uint256;
3091     using CurrenciesLib for CurrenciesLib.Currencies;
3092 
3093     //
3094     // Variables
3095     // -----------------------------------------------------------------------------------------------------------------
3096     FungibleBalanceLib.Balance periodAccrual;
3097     CurrenciesLib.Currencies periodCurrencies;
3098 
3099     FungibleBalanceLib.Balance aggregateAccrual;
3100     CurrenciesLib.Currencies aggregateCurrencies;
3101 
3102     TxHistoryLib.TxHistory private txHistory;
3103 
3104     //
3105     // Events
3106     // -----------------------------------------------------------------------------------------------------------------
3107     event ReceiveEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
3108     event CloseAccrualPeriodEvent();
3109     event RegisterServiceEvent(address service);
3110     event DeregisterServiceEvent(address service);
3111 
3112     //
3113     // Constructor
3114     // -----------------------------------------------------------------------------------------------------------------
3115     constructor(address deployer) Ownable(deployer) public {
3116     }
3117 
3118     //
3119     // Functions
3120     // -----------------------------------------------------------------------------------------------------------------
3121     /// @notice Fallback function that deposits ethers
3122     function() public payable {
3123         receiveEthersTo(msg.sender, "");
3124     }
3125 
3126     /// @notice Receive ethers to
3127     /// @param wallet The concerned wallet address
3128     function receiveEthersTo(address wallet, string)
3129     public
3130     payable
3131     {
3132         int256 amount = SafeMathIntLib.toNonZeroInt256(msg.value);
3133 
3134         // Add to balances
3135         periodAccrual.add(amount, address(0), 0);
3136         aggregateAccrual.add(amount, address(0), 0);
3137 
3138         // Add currency to stores of currencies
3139         periodCurrencies.add(address(0), 0);
3140         aggregateCurrencies.add(address(0), 0);
3141 
3142         // Add to transaction history
3143         txHistory.addDeposit(amount, address(0), 0);
3144 
3145         // Emit event
3146         emit ReceiveEvent(wallet, amount, address(0), 0);
3147     }
3148 
3149     /// @notice Receive tokens
3150     /// @param amount The concerned amount
3151     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3152     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3153     /// @param standard The standard of token ("ERC20", "ERC721")
3154     function receiveTokens(string balanceType, int256 amount, address currencyCt,
3155         uint256 currencyId, string standard)
3156     public
3157     {
3158         receiveTokensTo(msg.sender, balanceType, amount, currencyCt, currencyId, standard);
3159     }
3160 
3161     /// @notice Receive tokens to
3162     /// @param wallet The address of the concerned wallet
3163     /// @param amount The concerned amount
3164     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3165     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3166     /// @param standard The standard of token ("ERC20", "ERC721")
3167     function receiveTokensTo(address wallet, string, int256 amount,
3168         address currencyCt, uint256 currencyId, string standard)
3169     public
3170     {
3171         require(amount.isNonZeroPositiveInt256());
3172 
3173         // Execute transfer
3174         TransferController controller = transferController(currencyCt, standard);
3175         require(
3176             address(controller).delegatecall(
3177                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
3178             )
3179         );
3180 
3181         // Add to balances
3182         periodAccrual.add(amount, currencyCt, currencyId);
3183         aggregateAccrual.add(amount, currencyCt, currencyId);
3184 
3185         // Add currency to stores of currencies
3186         periodCurrencies.add(currencyCt, currencyId);
3187         aggregateCurrencies.add(currencyCt, currencyId);
3188 
3189         // Add to transaction history
3190         txHistory.addDeposit(amount, currencyCt, currencyId);
3191 
3192         // Emit event
3193         emit ReceiveEvent(wallet, amount, currencyCt, currencyId);
3194     }
3195 
3196     /// @notice Get the period accrual balance of the given currency
3197     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3198     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3199     /// @return The current period's accrual balance
3200     function periodAccrualBalance(address currencyCt, uint256 currencyId)
3201     public
3202     view
3203     returns (int256)
3204     {
3205         return periodAccrual.get(currencyCt, currencyId);
3206     }
3207 
3208     /// @notice Get the aggregate accrual balance of the given currency, including contribution from the
3209     /// current accrual period
3210     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3211     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3212     /// @return The aggregate accrual balance
3213     function aggregateAccrualBalance(address currencyCt, uint256 currencyId)
3214     public
3215     view
3216     returns (int256)
3217     {
3218         return aggregateAccrual.get(currencyCt, currencyId);
3219     }
3220 
3221     /// @notice Get the count of currencies recorded in the accrual period
3222     /// @return The number of currencies in the current accrual period
3223     function periodCurrenciesCount()
3224     public
3225     view
3226     returns (uint256)
3227     {
3228         return periodCurrencies.count();
3229     }
3230 
3231     /// @notice Get the currencies with indices in the given range that have been recorded in the current accrual period
3232     /// @param low The lower currency index
3233     /// @param up The upper currency index
3234     /// @return The currencies of the given index range in the current accrual period
3235     function periodCurrenciesByIndices(uint256 low, uint256 up)
3236     public
3237     view
3238     returns (MonetaryTypesLib.Currency[])
3239     {
3240         return periodCurrencies.getByIndices(low, up);
3241     }
3242 
3243     /// @notice Get the count of currencies ever recorded
3244     /// @return The number of currencies ever recorded
3245     function aggregateCurrenciesCount()
3246     public
3247     view
3248     returns (uint256)
3249     {
3250         return aggregateCurrencies.count();
3251     }
3252 
3253     /// @notice Get the currencies with indices in the given range that have ever been recorded
3254     /// @param low The lower currency index
3255     /// @param up The upper currency index
3256     /// @return The currencies of the given index range ever recorded
3257     function aggregateCurrenciesByIndices(uint256 low, uint256 up)
3258     public
3259     view
3260     returns (MonetaryTypesLib.Currency[])
3261     {
3262         return aggregateCurrencies.getByIndices(low, up);
3263     }
3264 
3265     /// @notice Get the count of deposits
3266     /// @return The count of deposits
3267     function depositsCount()
3268     public
3269     view
3270     returns (uint256)
3271     {
3272         return txHistory.depositsCount();
3273     }
3274 
3275     /// @notice Get the deposit at the given index
3276     /// @return The deposit at the given index
3277     function deposit(uint index)
3278     public
3279     view
3280     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
3281     {
3282         return txHistory.deposit(index);
3283     }
3284 
3285     /// @notice Close the current accrual period of the given currencies
3286     /// @param currencies The concerned currencies
3287     function closeAccrualPeriod(MonetaryTypesLib.Currency[] currencies)
3288     public
3289     onlyOperator
3290     {
3291         require(ConstantsLib.PARTS_PER() == totalBeneficiaryFraction);
3292 
3293         // Execute transfer
3294         for (uint256 i = 0; i < currencies.length; i++) {
3295             MonetaryTypesLib.Currency memory currency = currencies[i];
3296 
3297             int256 remaining = periodAccrual.get(currency.ct, currency.id);
3298 
3299             if (0 >= remaining)
3300                 continue;
3301 
3302             for (uint256 j = 0; j < beneficiaries.length; j++) {
3303                 address beneficiaryAddress = beneficiaries[j];
3304 
3305                 if (beneficiaryFraction(beneficiaryAddress) > 0) {
3306                     int256 transferable = periodAccrual.get(currency.ct, currency.id)
3307                     .mul(beneficiaryFraction(beneficiaryAddress))
3308                     .div(ConstantsLib.PARTS_PER());
3309 
3310                     if (transferable > remaining)
3311                         transferable = remaining;
3312 
3313                     if (transferable > 0) {
3314                         // Transfer ETH to the beneficiary
3315                         if (currency.ct == address(0))
3316                             AccrualBeneficiary(beneficiaryAddress).receiveEthersTo.value(uint256(transferable))(address(0), "");
3317 
3318                         // Transfer token to the beneficiary
3319                         else {
3320                             TransferController controller = transferController(currency.ct, "");
3321                             require(
3322                                 address(controller).delegatecall(
3323                                     controller.getApproveSignature(), beneficiaryAddress, uint256(transferable), currency.ct, currency.id
3324                                 )
3325                             );
3326 
3327                             AccrualBeneficiary(beneficiaryAddress).receiveTokensTo(address(0), "", transferable, currency.ct, currency.id, "");
3328                         }
3329 
3330                         remaining = remaining.sub(transferable);
3331                     }
3332                 }
3333             }
3334 
3335             // Roll over remaining to next accrual period
3336             periodAccrual.set(remaining, currency.ct, currency.id);
3337         }
3338 
3339         // Close accrual period of accrual beneficiaries
3340         for (j = 0; j < beneficiaries.length; j++) {
3341             beneficiaryAddress = beneficiaries[j];
3342 
3343             // Require that beneficiary fraction is strictly positive
3344             if (0 >= beneficiaryFraction(beneficiaryAddress))
3345                 continue;
3346 
3347             // Close accrual period
3348             AccrualBeneficiary(beneficiaryAddress).closeAccrualPeriod(currencies);
3349         }
3350 
3351         // Emit event
3352         emit CloseAccrualPeriodEvent();
3353     }
3354 }
3355 
3356 contract TransferControllerManager is Ownable {
3357     //
3358     // Constants
3359     // -----------------------------------------------------------------------------------------------------------------
3360     struct CurrencyInfo {
3361         bytes32 standard;
3362         bool blacklisted;
3363     }
3364 
3365     //
3366     // Variables
3367     // -----------------------------------------------------------------------------------------------------------------
3368     mapping(bytes32 => address) public registeredTransferControllers;
3369     mapping(address => CurrencyInfo) public registeredCurrencies;
3370 
3371     //
3372     // Events
3373     // -----------------------------------------------------------------------------------------------------------------
3374     event RegisterTransferControllerEvent(string standard, address controller);
3375     event ReassociateTransferControllerEvent(string oldStandard, string newStandard, address controller);
3376 
3377     event RegisterCurrencyEvent(address currencyCt, string standard);
3378     event DeregisterCurrencyEvent(address currencyCt);
3379     event BlacklistCurrencyEvent(address currencyCt);
3380     event WhitelistCurrencyEvent(address currencyCt);
3381 
3382     //
3383     // Constructor
3384     // -----------------------------------------------------------------------------------------------------------------
3385     constructor(address deployer) Ownable(deployer) public {
3386     }
3387 
3388     //
3389     // Functions
3390     // -----------------------------------------------------------------------------------------------------------------
3391     function registerTransferController(string standard, address controller)
3392     external
3393     onlyDeployer
3394     notNullAddress(controller)
3395     {
3396         require(bytes(standard).length > 0);
3397         bytes32 standardHash = keccak256(abi.encodePacked(standard));
3398 
3399         require(registeredTransferControllers[standardHash] == address(0));
3400 
3401         registeredTransferControllers[standardHash] = controller;
3402 
3403         // Emit event
3404         emit RegisterTransferControllerEvent(standard, controller);
3405     }
3406 
3407     function reassociateTransferController(string oldStandard, string newStandard, address controller)
3408     external
3409     onlyDeployer
3410     notNullAddress(controller)
3411     {
3412         require(bytes(newStandard).length > 0);
3413         bytes32 oldStandardHash = keccak256(abi.encodePacked(oldStandard));
3414         bytes32 newStandardHash = keccak256(abi.encodePacked(newStandard));
3415 
3416         require(registeredTransferControllers[oldStandardHash] != address(0));
3417         require(registeredTransferControllers[newStandardHash] == address(0));
3418 
3419         registeredTransferControllers[newStandardHash] = registeredTransferControllers[oldStandardHash];
3420         registeredTransferControllers[oldStandardHash] = address(0);
3421 
3422         // Emit event
3423         emit ReassociateTransferControllerEvent(oldStandard, newStandard, controller);
3424     }
3425 
3426     function registerCurrency(address currencyCt, string standard)
3427     external
3428     onlyOperator
3429     notNullAddress(currencyCt)
3430     {
3431         require(bytes(standard).length > 0);
3432         bytes32 standardHash = keccak256(abi.encodePacked(standard));
3433 
3434         require(registeredCurrencies[currencyCt].standard == bytes32(0));
3435 
3436         registeredCurrencies[currencyCt].standard = standardHash;
3437 
3438         // Emit event
3439         emit RegisterCurrencyEvent(currencyCt, standard);
3440     }
3441 
3442     function deregisterCurrency(address currencyCt)
3443     external
3444     onlyOperator
3445     {
3446         require(registeredCurrencies[currencyCt].standard != 0);
3447 
3448         registeredCurrencies[currencyCt].standard = bytes32(0);
3449         registeredCurrencies[currencyCt].blacklisted = false;
3450 
3451         // Emit event
3452         emit DeregisterCurrencyEvent(currencyCt);
3453     }
3454 
3455     function blacklistCurrency(address currencyCt)
3456     external
3457     onlyOperator
3458     {
3459         require(registeredCurrencies[currencyCt].standard != bytes32(0));
3460 
3461         registeredCurrencies[currencyCt].blacklisted = true;
3462 
3463         // Emit event
3464         emit BlacklistCurrencyEvent(currencyCt);
3465     }
3466 
3467     function whitelistCurrency(address currencyCt)
3468     external
3469     onlyOperator
3470     {
3471         require(registeredCurrencies[currencyCt].standard != bytes32(0));
3472 
3473         registeredCurrencies[currencyCt].blacklisted = false;
3474 
3475         // Emit event
3476         emit WhitelistCurrencyEvent(currencyCt);
3477     }
3478 
3479     /**
3480     @notice The provided standard takes priority over assigned interface to currency
3481     */
3482     function transferController(address currencyCt, string standard)
3483     public
3484     view
3485     returns (TransferController)
3486     {
3487         if (bytes(standard).length > 0) {
3488             bytes32 standardHash = keccak256(abi.encodePacked(standard));
3489 
3490             require(registeredTransferControllers[standardHash] != address(0));
3491             return TransferController(registeredTransferControllers[standardHash]);
3492         }
3493 
3494         require(registeredCurrencies[currencyCt].standard != bytes32(0));
3495         require(!registeredCurrencies[currencyCt].blacklisted);
3496 
3497         address controllerAddress = registeredTransferControllers[registeredCurrencies[currencyCt].standard];
3498         require(controllerAddress != address(0));
3499 
3500         return TransferController(controllerAddress);
3501     }
3502 }
3503 
3504 library TxHistoryLib {
3505     //
3506     // Structures
3507     // -----------------------------------------------------------------------------------------------------------------
3508     struct AssetEntry {
3509         int256 amount;
3510         uint256 blockNumber;
3511         address currencyCt;      //0 for ethers
3512         uint256 currencyId;
3513     }
3514 
3515     struct TxHistory {
3516         AssetEntry[] deposits;
3517         mapping(address => mapping(uint256 => AssetEntry[])) currencyDeposits;
3518 
3519         AssetEntry[] withdrawals;
3520         mapping(address => mapping(uint256 => AssetEntry[])) currencyWithdrawals;
3521     }
3522 
3523     //
3524     // Functions
3525     // -----------------------------------------------------------------------------------------------------------------
3526     function addDeposit(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
3527     internal
3528     {
3529         AssetEntry memory deposit = AssetEntry(amount, block.number, currencyCt, currencyId);
3530         self.deposits.push(deposit);
3531         self.currencyDeposits[currencyCt][currencyId].push(deposit);
3532     }
3533 
3534     function addWithdrawal(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
3535     internal
3536     {
3537         AssetEntry memory withdrawal = AssetEntry(amount, block.number, currencyCt, currencyId);
3538         self.withdrawals.push(withdrawal);
3539         self.currencyWithdrawals[currencyCt][currencyId].push(withdrawal);
3540     }
3541 
3542     //----
3543 
3544     function deposit(TxHistory storage self, uint index)
3545     internal
3546     view
3547     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
3548     {
3549         require(index < self.deposits.length);
3550 
3551         amount = self.deposits[index].amount;
3552         blockNumber = self.deposits[index].blockNumber;
3553         currencyCt = self.deposits[index].currencyCt;
3554         currencyId = self.deposits[index].currencyId;
3555     }
3556 
3557     function depositsCount(TxHistory storage self)
3558     internal
3559     view
3560     returns (uint256)
3561     {
3562         return self.deposits.length;
3563     }
3564 
3565     function currencyDeposit(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
3566     internal
3567     view
3568     returns (int256 amount, uint256 blockNumber)
3569     {
3570         require(index < self.currencyDeposits[currencyCt][currencyId].length);
3571 
3572         amount = self.currencyDeposits[currencyCt][currencyId][index].amount;
3573         blockNumber = self.currencyDeposits[currencyCt][currencyId][index].blockNumber;
3574     }
3575 
3576     function currencyDepositsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
3577     internal
3578     view
3579     returns (uint256)
3580     {
3581         return self.currencyDeposits[currencyCt][currencyId].length;
3582     }
3583 
3584     //----
3585 
3586     function withdrawal(TxHistory storage self, uint index)
3587     internal
3588     view
3589     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
3590     {
3591         require(index < self.withdrawals.length);
3592 
3593         amount = self.withdrawals[index].amount;
3594         blockNumber = self.withdrawals[index].blockNumber;
3595         currencyCt = self.withdrawals[index].currencyCt;
3596         currencyId = self.withdrawals[index].currencyId;
3597     }
3598 
3599     function withdrawalsCount(TxHistory storage self)
3600     internal
3601     view
3602     returns (uint256)
3603     {
3604         return self.withdrawals.length;
3605     }
3606 
3607     function currencyWithdrawal(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
3608     internal
3609     view
3610     returns (int256 amount, uint256 blockNumber)
3611     {
3612         require(index < self.currencyWithdrawals[currencyCt][currencyId].length);
3613 
3614         amount = self.currencyWithdrawals[currencyCt][currencyId][index].amount;
3615         blockNumber = self.currencyWithdrawals[currencyCt][currencyId][index].blockNumber;
3616     }
3617 
3618     function currencyWithdrawalsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
3619     internal
3620     view
3621     returns (uint256)
3622     {
3623         return self.currencyWithdrawals[currencyCt][currencyId].length;
3624     }
3625 }