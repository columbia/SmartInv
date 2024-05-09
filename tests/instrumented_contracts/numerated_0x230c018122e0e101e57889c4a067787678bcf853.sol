1 pragma solidity 0.4.24;
2 
3 // File: contracts\safe_math_lib.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, reverts on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b > 0); // Solidity only automatically asserts when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts\database.sol
70 
71 contract database {
72 
73     /* libraries */
74     using SafeMath for uint256;
75 
76     /* struct declarations */
77     struct participant {
78         address eth_address; // your eth address
79         uint256 topl_address; // your topl address
80         uint256 arbits; // the amount of a arbits you have
81         uint256 num_of_pro_rata_tokens_alloted;
82         bool arbits_kyc_whitelist; // if you pass arbits level kyc you get this
83         uint8 num_of_uses;
84     }
85 
86     /* variable declarations */
87     // permission variables
88     mapping(address => bool) public sale_owners;
89     mapping(address => bool) public owners;
90     mapping(address => bool) public masters;
91     mapping(address => bool) public kycers;
92 
93     // database mapping
94     mapping(address => participant) public participants;
95     address[] public participant_keys;
96 
97     // sale open variables
98     bool public arbits_presale_open = false; // Presale variables
99     bool public iconiq_presale_open = false; // ^^^^^^^^^^^^^^^^^
100     bool public arbits_sale_open = false; // Main sale variables
101 
102     // sale state variables
103     uint256 public pre_kyc_bonus_denominator;
104     uint256 public pre_kyc_bonus_numerator;
105     uint256 public pre_kyc_iconiq_bonus_denominator;
106     uint256 public pre_kyc_iconiq_bonus_numerator;
107 
108     uint256 public contrib_arbits_min;
109     uint256 public contrib_arbits_max;
110 
111     // presale variables
112     uint256 public presale_arbits_per_ether;        // two different prices, but same cap
113     uint256 public presale_iconiq_arbits_per_ether; // and sold values
114     uint256 public presale_arbits_total = 18000000;
115     uint256 public presale_arbits_sold;
116 
117     // main sale variables
118     uint256 public sale_arbits_per_ether;
119     uint256 public sale_arbits_total;
120     uint256 public sale_arbits_sold;
121 
122     /* constructor */
123     constructor() public {
124         owners[msg.sender] = true;
125     }
126 
127     /* permission functions */
128     function add_owner(address __subject) public only_owner {
129         owners[__subject] = true;
130     }
131 
132     function remove_owner(address __subject) public only_owner {
133         owners[__subject] = false;
134     }
135 
136     function add_master(address _subject) public only_owner {
137         masters[_subject] = true;
138     }
139 
140     function remove_master(address _subject) public only_owner {
141         masters[_subject] = false;
142     }
143 
144     function add_kycer(address _subject) public only_owner {
145         kycers[_subject] = true;
146     }
147 
148     function remove_kycer(address _subject) public only_owner {
149         kycers[_subject] = false;
150     }
151 
152     /* modifiers */
153     modifier log_participant_update(address __eth_address) {
154         participant_keys.push(__eth_address); // logs the given address in participant_keys
155         _;
156     }
157 
158     modifier only_owner() {
159         require(owners[msg.sender]);
160         _;
161     }
162 
163     modifier only_kycer() {
164         require(kycers[msg.sender]);
165         _;
166     }
167 
168     modifier only_master_or_owner() {
169         require(masters[msg.sender] || owners[msg.sender]);
170         _;
171     }
172 
173     /* database functions */
174     // GENERAL VARIABLE getters & setters
175     // getters    
176     function get_sale_owner(address _a) public view returns(bool) {
177         return sale_owners[_a];
178     }
179     
180     function get_contrib_arbits_min() public view returns(uint256) {
181         return contrib_arbits_min;
182     }
183 
184     function get_contrib_arbits_max() public view returns(uint256) {
185         return contrib_arbits_max;
186     }
187 
188     function get_pre_kyc_bonus_numerator() public view returns(uint256) {
189         return pre_kyc_bonus_numerator;
190     }
191 
192     function get_pre_kyc_bonus_denominator() public view returns(uint256) {
193         return pre_kyc_bonus_denominator;
194     }
195 
196     function get_pre_kyc_iconiq_bonus_numerator() public view returns(uint256) {
197         return pre_kyc_iconiq_bonus_numerator;
198     }
199 
200     function get_pre_kyc_iconiq_bonus_denominator() public view returns(uint256) {
201         return pre_kyc_iconiq_bonus_denominator;
202     }
203 
204     function get_presale_iconiq_arbits_per_ether() public view returns(uint256) {
205         return (presale_iconiq_arbits_per_ether);
206     }
207 
208     function get_presale_arbits_per_ether() public view returns(uint256) {
209         return (presale_arbits_per_ether);
210     }
211 
212     function get_presale_arbits_total() public view returns(uint256) {
213         return (presale_arbits_total);
214     }
215 
216     function get_presale_arbits_sold() public view returns(uint256) {
217         return (presale_arbits_sold);
218     }
219 
220     function get_sale_arbits_per_ether() public view returns(uint256) {
221         return (sale_arbits_per_ether);
222     }
223 
224     function get_sale_arbits_total() public view returns(uint256) {
225         return (sale_arbits_total);
226     }
227 
228     function get_sale_arbits_sold() public view returns(uint256) {
229         return (sale_arbits_sold);
230     }
231 
232     // setters
233     function set_sale_owner(address _a, bool _v) public only_master_or_owner {
234         sale_owners[_a] = _v;
235     }
236 
237     function set_contrib_arbits_min(uint256 _v) public only_master_or_owner {
238         contrib_arbits_min = _v;
239     }
240 
241     function set_contrib_arbits_max(uint256 _v) public only_master_or_owner {
242         contrib_arbits_max = _v;
243     }
244 
245     function set_pre_kyc_bonus_numerator(uint256 _v) public only_master_or_owner {
246         pre_kyc_bonus_numerator = _v;
247     }
248 
249     function set_pre_kyc_bonus_denominator(uint256 _v) public only_master_or_owner {
250         pre_kyc_bonus_denominator = _v;
251     }
252 
253     function set_pre_kyc_iconiq_bonus_numerator(uint256 _v) public only_master_or_owner {
254         pre_kyc_iconiq_bonus_numerator = _v;
255     }
256 
257     function set_pre_kyc_iconiq_bonus_denominator(uint256 _v) public only_master_or_owner {
258         pre_kyc_iconiq_bonus_denominator = _v;
259     }
260 
261     function set_presale_iconiq_arbits_per_ether(uint256 _v) public only_master_or_owner {
262         presale_iconiq_arbits_per_ether = _v;
263     }
264 
265     function set_presale_arbits_per_ether(uint256 _v) public only_master_or_owner {
266         presale_arbits_per_ether = _v;
267     }
268 
269     function set_presale_arbits_total(uint256 _v) public only_master_or_owner {
270         presale_arbits_total = _v;
271     }
272 
273     function set_presale_arbits_sold(uint256 _v) public only_master_or_owner {
274         presale_arbits_sold = _v;
275     }
276 
277     function set_sale_arbits_per_ether(uint256 _v) public only_master_or_owner {
278         sale_arbits_per_ether = _v;
279     }
280 
281     function set_sale_arbits_total(uint256 _v) public only_master_or_owner {
282         sale_arbits_total = _v;
283     }
284 
285     function set_sale_arbits_sold(uint256 _v) public only_master_or_owner {
286         sale_arbits_sold = _v;
287     }
288 
289     // PARTICIPANT SPECIFIC getters and setters
290     // getters
291     function get_participant(address _a) public view returns(
292         address,
293         uint256,
294         uint256,
295         uint256,
296         bool,
297         uint8
298     ) {
299         participant storage subject = participants[_a];
300         return (
301             subject.eth_address,
302             subject.topl_address,
303             subject.arbits,
304             subject.num_of_pro_rata_tokens_alloted,
305             subject.arbits_kyc_whitelist,
306             subject.num_of_uses
307         );
308     }
309 
310     function get_participant_num_of_uses(address _a) public view returns(uint8) {
311         return (participants[_a].num_of_uses);
312     }
313 
314     function get_participant_topl_address(address _a) public view returns(uint256) {
315         return (participants[_a].topl_address);
316     }
317 
318     function get_participant_arbits(address _a) public view returns(uint256) {
319         return (participants[_a].arbits);
320     }
321 
322     function get_participant_num_of_pro_rata_tokens_alloted(address _a) public view returns(uint256) {
323         return (participants[_a].num_of_pro_rata_tokens_alloted);
324     }
325 
326     function get_participant_arbits_kyc_whitelist(address _a) public view returns(bool) {
327         return (participants[_a].arbits_kyc_whitelist);
328     }
329 
330     // setters
331     function set_participant(
332         address _a,
333         uint256 _ta,
334         uint256 _arbits,
335         uint256 _prta,
336         bool _v3,
337         uint8 _nou
338     ) public only_master_or_owner log_participant_update(_a) {
339         participant storage subject = participants[_a];
340         subject.eth_address = _a;
341         subject.topl_address = _ta;
342         subject.arbits = _arbits;
343         subject.num_of_pro_rata_tokens_alloted = _prta;
344         subject.arbits_kyc_whitelist = _v3;
345         subject.num_of_uses = _nou;
346     }
347 
348     function set_participant_num_of_uses(
349         address _a,
350         uint8 _v
351     ) public only_master_or_owner log_participant_update(_a) {
352         participants[_a].num_of_uses = _v;
353     }
354 
355     function set_participant_topl_address(
356         address _a,
357         uint256 _ta
358     ) public only_master_or_owner log_participant_update(_a) {
359         participants[_a].topl_address = _ta;
360     }
361 
362     function set_participant_arbits(
363         address _a,
364         uint256 _v
365     ) public only_master_or_owner log_participant_update(_a) {
366         participants[_a].arbits = _v;
367     }
368 
369     function set_participant_num_of_pro_rata_tokens_alloted(
370         address _a,
371         uint256 _v
372     ) public only_master_or_owner log_participant_update(_a) {
373         participants[_a].num_of_pro_rata_tokens_alloted = _v;
374     }
375 
376     function set_participant_arbits_kyc_whitelist(
377         address _a,
378         bool _v
379     ) public only_kycer log_participant_update(_a) {
380         participants[_a].arbits_kyc_whitelist = _v;
381     }
382 
383 
384     //
385     // STATE FLAG FUNCTIONS: Getter, setter, and toggling functions for state flags.
386 
387     // GETTERS
388     function get_iconiq_presale_open() public view only_master_or_owner returns(bool) {
389         return iconiq_presale_open;
390     }
391 
392     function get_arbits_presale_open() public view only_master_or_owner returns(bool) {
393         return arbits_presale_open;
394     }
395 
396     function get_arbits_sale_open() public view only_master_or_owner returns(bool) {
397         return arbits_sale_open;
398     }
399 
400     // SETTERS
401     function set_iconiq_presale_open(bool _v) public only_master_or_owner {
402         iconiq_presale_open = _v;
403     }
404 
405     function set_arbits_presale_open(bool _v) public only_master_or_owner {
406         arbits_presale_open = _v;
407     }
408 
409     function set_arbits_sale_open(bool _v) public only_master_or_owner {
410         arbits_sale_open = _v;
411     }
412 
413 }
414 
415 // File: contracts\topl_database_lib.sol
416 
417 // This library serves as an wrapper to the database.sol contract
418 
419 library topl_database_lib {
420 
421     //// PARTICIPANT SPECIFIC FUNCTIONS
422     // getters
423     function get_participant(address db, address _a) internal view returns(
424         address,
425         uint256,
426         uint256,
427         uint256,
428         bool,
429         uint8
430     ) {
431         return database(db).get_participant(_a);
432     }
433 
434     function get_topl_address(address db, address _a) internal view returns(uint256) {
435         return database(db).get_participant_topl_address(_a);
436     }
437 
438     function get_arbits(address db, address _a) internal view returns(uint256) {
439         return database(db).get_participant_arbits(_a);
440     }
441 
442     function get_iconiq_tokens(address db, address _a) internal view returns(uint256) {
443         return database(db).get_participant_num_of_pro_rata_tokens_alloted(_a);
444     }
445 
446     function get_arbits_whitelist(address db, address _a) internal view returns(bool) {
447         return database(db).get_participant_arbits_kyc_whitelist(_a);
448     }
449 
450     function get_num_of_uses(address db, address _a) internal view returns(uint8) {
451         return database(db).get_participant_num_of_uses(_a);
452     }
453 
454     // setters
455     function set_participant(
456         address db,
457         address _a,
458         uint256 _ta,
459         uint256 _arbits,
460         uint256 _prta,
461         bool _v3,
462         uint8 _nou
463     ) internal {
464         database(db).set_participant(_a, _ta, _arbits, _prta, _v3, _nou);
465         emit e_set_participant(_a, _ta, _arbits, _prta, _v3, _nou);
466     }
467 
468     function set_topl_address(address db, address _a, uint256 _ta) internal {
469         database(db).set_participant_topl_address(_a, _ta);
470         emit e_set_topl_address(_a, _ta);
471     }
472 
473     function set_arbits(address db, address _a, uint256 _v) internal {
474         database(db).set_participant_arbits(_a, _v);
475         emit e_set_arbits(_a, _v);
476     }
477 
478     function set_iconiq_tokens(address db, address _a, uint256 _v) internal {
479         database(db).set_participant_num_of_pro_rata_tokens_alloted(_a, _v);
480         emit e_set_iconiq_tokens(_a, _v);
481     }
482 
483     function set_arbits_whitelist(address db, address _a, bool _v) internal {
484         database(db).set_participant_arbits_kyc_whitelist(_a, _v);
485         emit e_set_arbits_whitelist(_a, _v);
486     }
487 
488     function set_num_of_uses(address db, address _a, uint8 _v) internal {
489         database(db).set_participant_num_of_uses(_a, _v);
490         emit e_set_num_of_uses(_a, _v);
491     }
492 
493     // modifiers
494     function add_arbits(address db, address _a, uint256 _v) internal {
495         uint256 c = database(db).get_participant_arbits(_a) + _v;     // safe math check
496         assert(c >= database(db).get_participant_arbits(_a)); //
497         database(db).set_participant_arbits(
498             _a,
499             (database(db).get_participant_arbits(_a) + _v)
500         );
501         emit e_add_arbits(_a, _v);
502     }
503 
504     function sub_arbits(address db, address _a, uint256 _v) internal {
505         assert(_v <= database(db).get_participant_arbits(_a)); // safe math check
506         database(db).set_participant_arbits(
507             _a,
508             (database(db).get_participant_arbits(_a) - _v)
509         );
510         emit e_sub_arbits(_a, _v);
511     }
512 
513     //// ICONIQ SALE SPECIFIC FUNCTIONS
514     // getters
515     function get_pre_kyc_iconiq_bonus_numerator(address db) internal view returns(uint256) {
516         return database(db).get_pre_kyc_iconiq_bonus_numerator();
517     }
518 
519     function get_pre_kyc_iconiq_bonus_denominator(address db) internal view returns(uint256) {
520         return database(db).get_pre_kyc_iconiq_bonus_denominator();
521     }
522 
523     function get_iconiq_presale_open(address db) internal view returns(bool) {
524         return database(db).get_iconiq_presale_open();
525     }
526 
527     function get_presale_iconiq_arbits_per_ether(address db) internal view returns(uint256) {
528         return database(db).get_presale_iconiq_arbits_per_ether();
529     }
530 
531     // setters
532     function set_pre_kyc_iconiq_bonus_numerator(address db, uint256 _v) internal {
533         database(db).set_pre_kyc_iconiq_bonus_numerator(_v);
534         emit e_set_pre_kyc_iconiq_bonus_numerator(_v);
535     }
536 
537     function set_pre_kyc_iconiq_bonus_denominator(address db, uint256 _v) internal {
538         database(db).set_pre_kyc_iconiq_bonus_denominator(_v);
539         emit e_set_pre_kyc_iconiq_bonus_denominator(_v);
540     }
541 
542     function set_iconiq_presale_open(address db, bool _v) internal {
543         database(db).set_iconiq_presale_open(_v);
544         emit e_set_iconiq_presale_open(_v);
545     }
546 
547     function set_presale_iconiq_arbits_per_ether(address db, uint256 _v) internal {
548         database(db).set_presale_iconiq_arbits_per_ether(_v);
549         emit e_set_presale_iconiq_arbits_per_ether(_v);
550     }
551 
552     //// PUBLIC PRESALE SPECIFIC FUNCTIONS (arbit_presale)
553     // getters
554     function get_pre_kyc_bonus_numerator(address db) internal view returns(uint256) {
555         return database(db).get_pre_kyc_bonus_numerator();
556     }
557 
558     function get_pre_kyc_bonus_denominator(address db) internal view returns(uint256) {
559         return database(db).get_pre_kyc_bonus_denominator();
560     }
561 
562     function get_arbits_presale_open(address db) internal view returns(bool) {
563         return database(db).get_arbits_presale_open();
564     }
565 
566     function get_presale_arbits_per_ether(address db) internal view returns(uint256) {
567         return database(db).get_presale_arbits_per_ether();
568     }
569 
570     // setters
571     function set_pre_kyc_bonus_numerator(address db, uint256 _v) internal {
572         database(db).set_pre_kyc_bonus_numerator(_v);
573         emit e_set_pre_kyc_bonus_numerator(_v);
574     }
575 
576     function set_pre_kyc_bonus_denominator(address db, uint256 _v) internal {
577         database(db).set_pre_kyc_bonus_denominator(_v);
578         emit e_set_pre_kyc_bonus_denominator(_v);
579     }
580 
581     function set_arbits_presale_open(address db, bool _v) internal {
582         database(db).set_arbits_presale_open(_v);
583         emit e_set_arbits_presale_open(_v);
584     }
585 
586     // this function is not strictly only used by arbit_presale since it is used for rollover
587     // when an iconiq member goes over their allotment.
588     function set_presale_arbits_per_ether(address db, uint256 _v) internal {
589         database(db).set_presale_arbits_per_ether(_v);
590         emit e_set_presale_arbits_per_ether(_v);
591     }
592 
593     //// "GLOABL" SALE FUNCTIONS (applies across the entire presale)
594     // getters
595     function get_presale_arbits_total(address db) internal view returns(uint256) {
596         return database(db).get_presale_arbits_total();
597     }
598 
599     function get_presale_arbits_sold(address db) internal view returns(uint256) {
600         return database(db).get_presale_arbits_sold();
601     }
602 
603     function get_arbits_max_contribution(address db) internal view returns(uint256) {
604         return database(db).get_contrib_arbits_max();
605     }
606 
607     function get_arbits_min_contribution(address db) internal view returns(uint256) {
608         return database(db).get_contrib_arbits_min();
609     }
610 
611     // setters
612     function set_presale_arbits_total(address db, uint256 _v) internal {
613         database(db).set_presale_arbits_total(_v);
614         emit e_set_presale_arbits_total(_v);
615     }
616 
617     function set_presale_arbits_sold(address db, uint256 _v) internal {
618         database(db).set_presale_arbits_sold(_v);
619         emit e_set_presale_arbits_sold(_v);
620     }
621 
622     function set_arbits_max_contribution(address db, uint256 _v) internal {
623         database(db).set_contrib_arbits_max(_v);
624         emit e_set_arbits_max_contribution(_v);
625     }
626 
627     function set_arbits_min_contribution(address db, uint256 _v) internal {
628         database(db).set_contrib_arbits_min(_v);
629         emit e_set_arbits_min_contribution(_v);
630     }
631 
632     // modifiers
633     function add_presale_arbits_sold(address db, uint256 _v) internal {
634         uint256 c = database(db).get_presale_arbits_sold() + _v;     // safe math check
635         assert(c >= database(db).get_presale_arbits_sold()); //
636         database(db).set_presale_arbits_sold(
637             (database(db).get_presale_arbits_sold() + _v)
638         );
639         emit e_add_presale_arbits_sold(_v);
640     }
641 
642     function sub_presale_arbits_sold(address db, uint256 _v) internal {
643         assert(_v <= database(db).get_presale_arbits_sold()); // safe math check
644         database(db).set_presale_arbits_sold(
645             (database(db).get_presale_arbits_sold() - _v)
646         );
647         emit e_sub_presale_arbits_sold(_v);
648     }
649     
650     function set_sale_owner(address db, address _a, bool _v) internal {
651         database(db).set_sale_owner(_a, _v);
652     }
653 
654     function get_sale_owner(address db, address _a) internal view returns(bool) {
655         return database(db).get_sale_owner(_a);
656     }
657 
658     event e_set_sale_owner(address, bool);
659     event e_set_num_of_uses(address, uint8);
660     event e_set_arbits_whitelist(address, bool);
661     event e_set_participant(address, uint256, uint256, uint256, bool, uint8);
662     event e_set_topl_address(address, uint256);
663     event e_set_arbits(address, uint256);
664     event e_set_iconiq_tokens(address, uint256);
665     event e_add_arbits(address, uint256);
666     event e_sub_arbits(address, uint256);
667     event e_set_pre_kyc_bonus_numerator(uint256);
668     event e_set_pre_kyc_bonus_denominator(uint256);
669     event e_set_iconiq_presale_open(bool);
670     event e_set_arbits_presale_open(bool);
671     event e_set_presale_iconiq_arbits_per_ether(uint256);
672     event e_set_presale_arbits_per_ether(uint256);
673     event e_set_presale_arbits_total(uint256);
674     event e_set_presale_arbits_sold(uint256);
675     event e_add_presale_arbits_sold(uint256);
676     event e_sub_presale_arbits_sold(uint256);
677     event e_set_arbits_max_contribution(uint256);
678     event e_set_arbits_min_contribution(uint256);
679     event e_set_pre_kyc_iconiq_bonus_numerator(uint256);
680     event e_set_pre_kyc_iconiq_bonus_denominator(uint256);
681 }
682 
683 // File: contracts\iconiq_data_pipe.sol
684 
685 contract iconiq_data_pipe {
686 
687     using topl_database_lib for address;
688     using SafeMath for uint256;
689 
690     address public db;
691     address public owner;
692 
693     constructor(address __db) public {
694         db = __db;
695         owner = msg.sender;
696     }
697 
698     function owner_linkage() public { // must be called after the sale contract has been linked to the database contract via database's add master function
699         db.set_sale_owner(owner, true);
700     }
701 
702     modifier only_owner() {
703         require(db.get_sale_owner(msg.sender));
704         _;
705     }
706 
707     function set_iconiq_token_amount(address _a, uint256 _v) public only_owner {
708         db.set_iconiq_tokens(_a, _v);
709     }
710 }