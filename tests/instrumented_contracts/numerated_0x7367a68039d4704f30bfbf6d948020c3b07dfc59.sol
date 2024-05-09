1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * A contract containing the fundamental state variables of the Beercoin
6  */
7 contract InternalBeercoin {
8     // As 18 decimal places will be used, the constants are multiplied by 10^18
9     uint256 internal constant INITIAL_SUPPLY = 15496000000 * 10**18;
10     uint256 internal constant DIAMOND_VALUE = 10000 * 10**18;
11     uint256 internal constant GOLD_VALUE = 100 * 10**18;
12     uint256 internal constant SILVER_VALUE = 10 * 10**18;
13     uint256 internal constant BRONZE_VALUE = 1 * 10**18;
14 
15     // In addition to the initial total supply of 15496000000 Beercoins,
16     // more Beercoins will only be added by scanning bottle caps.
17     // 20800000000 bottle caps will be eventually produced.
18     //
19     // Within 10000 bottle caps,
20     // 1 (i.e. every 10000th cap in total) has a value of 10000 ("Diamond") Beercoins,
21     // 9 (i.e. every 1000th cap in total) have a value of 100 ("Gold") Beercoins,
22     // 990 (i.e. every 10th cap in total) have a value of 10 ("Silver") Beercoins,
23     // 9000 (i.e. every remaining cap) have a value of 1 ("Bronze") Beercoin.
24     //
25     // Therefore one bottle cap has an average Beercoin value of
26     // (1 * 10000 + 9 * 100 + 990 * 10 + 9000 * 1) / 10000 = 2.98.
27     //
28     // This means the total Beercoin value of all bottle caps that will
29     // be eventually produced equals 20800000000 * 2.98 = 61984000000.
30     uint64 internal producibleCaps = 20800000000;
31 
32     // The  amounts of diamond, gold, silver, and bronze caps are stored
33     // as a single 256-bit value divided into four sections of 64 bits.
34     //
35     // Bits 255 to 192 are used for the amount of diamond caps,
36     // bits 191 to 128 are used for the amount of gold caps,
37     // bits 127 to 64 are used for the amount of silver caps,
38     // bits 63 to 0 are used for the amount of bronze caps.
39     //
40     // For example, the following numbers represent a single cap of a certain type:
41     // 0x0000000000000001000000000000000000000000000000000000000000000000 (diamond)
42     // 0x0000000000000000000000000000000100000000000000000000000000000000 (gold)
43     // 0x0000000000000000000000000000000000000000000000010000000000000000 (silver)
44     // 0x0000000000000000000000000000000000000000000000000000000000000001 (bronze)
45     uint256 internal packedProducedCaps = 0;
46     uint256 internal packedScannedCaps = 0;
47 
48     // The amount of irreversibly burnt Beercoins
49     uint256 internal burntValue = 0;
50 }
51 
52 
53 /**
54  * A contract containing functions to understand the packed low-level data
55  */
56 contract ExplorableBeercoin is InternalBeercoin {
57     /**
58      * The amount of caps that can still be produced
59      */
60     function unproducedCaps() public view returns (uint64) {
61         return producibleCaps;
62     }
63 
64     /**
65      * The amount of caps that is produced but not yet scanned
66      */
67     function unscannedCaps() public view returns (uint64) {
68         uint256 caps = packedProducedCaps - packedScannedCaps;
69         uint64 amount = uint64(caps >> 192);
70         amount += uint64(caps >> 128);
71         amount += uint64(caps >> 64);
72         amount += uint64(caps);
73         return amount;
74     }
75 
76     /**
77      * The amount of all caps produced so far
78      */
79     function producedCaps() public view returns (uint64) {
80         uint256 caps = packedProducedCaps;
81         uint64 amount = uint64(caps >> 192);
82         amount += uint64(caps >> 128);
83         amount += uint64(caps >> 64);
84         amount += uint64(caps);
85         return amount;
86     }
87 
88     /**
89      * The amount of all caps scanned so far
90      */
91     function scannedCaps() public view returns (uint64) {
92         uint256 caps = packedScannedCaps;
93         uint64 amount = uint64(caps >> 192);
94         amount += uint64(caps >> 128);
95         amount += uint64(caps >> 64);
96         amount += uint64(caps);
97         return amount;
98     }
99 
100     /**
101      * The amount of diamond caps produced so far
102      */
103     function producedDiamondCaps() public view returns (uint64) {
104         return uint64(packedProducedCaps >> 192);
105     }
106 
107     /**
108      * The amount of diamond caps scanned so far
109      */
110     function scannedDiamondCaps() public view returns (uint64) {
111         return uint64(packedScannedCaps >> 192);
112     }
113 
114     /**
115      * The amount of gold caps produced so far
116      */
117     function producedGoldCaps() public view returns (uint64) {
118         return uint64(packedProducedCaps >> 128);
119     }
120 
121     /**
122      * The amount of gold caps scanned so far
123      */
124     function scannedGoldCaps() public view returns (uint64) {
125         return uint64(packedScannedCaps >> 128);
126     }
127 
128     /**
129      * The amount of silver caps produced so far
130      */
131     function producedSilverCaps() public view returns (uint64) {
132         return uint64(packedProducedCaps >> 64);
133     }
134 
135     /**
136      * The amount of silver caps scanned so far
137      */
138     function scannedSilverCaps() public view returns (uint64) {
139         return uint64(packedScannedCaps >> 64);
140     }
141 
142     /**
143      * The amount of bronze caps produced so far
144      */
145     function producedBronzeCaps() public view returns (uint64) {
146         return uint64(packedProducedCaps);
147     }
148 
149     /**
150      * The amount of bronze caps scanned so far
151      */
152     function scannedBronzeCaps() public view returns (uint64) {
153         return uint64(packedScannedCaps);
154     }
155 }
156 
157 
158 /**
159  * A contract implementing all standard ERC20 functionality for the Beercoin
160  */
161 contract ERC20Beercoin is ExplorableBeercoin {
162     event Transfer(address indexed _from, address indexed _to, uint256 _value);
163     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
164 
165     mapping (address => uint256) internal balances;
166     mapping (address => mapping (address => uint256)) internal allowances;
167 
168     /**
169      * Beercoin's name
170      */
171     function name() public pure returns (string) {
172         return "Beercoin";
173     }
174 
175     /**
176      * Beercoin's symbol
177      */
178     function symbol() public pure returns (string) {
179         return "?";
180     }
181 
182     /**
183      * Beercoin's decimal places
184      */
185     function decimals() public pure returns (uint8) {
186         return 18;
187     }
188 
189     /**
190      * The current total supply of Beercoins
191      */
192     function totalSupply() public view returns (uint256) {
193         uint256 caps = packedScannedCaps;
194         uint256 supply = INITIAL_SUPPLY;
195         supply += (caps >> 192) * DIAMOND_VALUE;
196         supply += ((caps >> 128) & 0xFFFFFFFFFFFFFFFF) * GOLD_VALUE;
197         supply += ((caps >> 64) & 0xFFFFFFFFFFFFFFFF) * SILVER_VALUE;
198         supply += (caps & 0xFFFFFFFFFFFFFFFF) * BRONZE_VALUE;
199         return supply - burntValue;
200     }
201 
202     /**
203      * Check the balance of a Beercoin user
204      *
205      * @param _owner the user to check
206      */
207     function balanceOf(address _owner) public view returns (uint256) {
208         return balances[_owner];
209     }
210 
211     /**
212      * Transfer Beercoins to another user
213      *
214      * @param _to the address of the recipient
215      * @param _value the amount to send
216      */
217     function transfer(address _to, uint256 _value) public returns (bool) {
218         require(_to != 0x0);
219 
220         uint256 balanceFrom = balances[msg.sender];
221 
222         require(_value <= balanceFrom);
223 
224         uint256 oldBalanceTo = balances[_to];
225         uint256 newBalanceTo = oldBalanceTo + _value;
226 
227         require(oldBalanceTo <= newBalanceTo);
228 
229         balances[msg.sender] = balanceFrom - _value;
230         balances[_to] = newBalanceTo;
231 
232         Transfer(msg.sender, _to, _value);
233 
234         return true;
235     }
236 
237     /**
238      * Transfer Beercoins from other address if a respective allowance exists
239      *
240      * @param _from the address of the sender
241      * @param _to the address of the recipient
242      * @param _value the amount to send
243      */
244     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
245         require(_to != 0x0);
246 
247         uint256 balanceFrom = balances[_from];
248         uint256 allowanceFrom = allowances[_from][msg.sender];
249 
250         require(_value <= balanceFrom);
251         require(_value <= allowanceFrom);
252 
253         uint256 oldBalanceTo = balances[_to];
254         uint256 newBalanceTo = oldBalanceTo + _value;
255 
256         require(oldBalanceTo <= newBalanceTo);
257 
258         balances[_from] = balanceFrom - _value;
259         balances[_to] = newBalanceTo;
260         allowances[_from][msg.sender] = allowanceFrom - _value;
261 
262         Transfer(_from, _to, _value);
263 
264         return true;
265     }
266 
267     /**
268      * Allow another user to spend a certain amount of Beercoins on your behalf
269      *
270      * @param _spender the address of the user authorized to spend
271      * @param _value the maximum amount that can be spent on your behalf
272      */
273     function approve(address _spender, uint256 _value) public returns (bool) {
274         allowances[msg.sender][_spender] = _value;
275         Approval(msg.sender, _spender, _value);
276         return true;
277     }
278 
279     /**
280      * The amount of Beercoins that can be spent by a user on behalf of another
281      *
282      * @param _owner the address of the user user whose Beercoins are spent
283      * @param _spender the address of the user who executes the transaction
284      */
285     function allowance(address _owner, address _spender) public view returns (uint256) {
286         return allowances[_owner][_spender];
287     }
288 }
289 
290 
291 /**
292  * A contract that defines a master with special debiting abilities
293  * required for operating a user-friendly Beercoin redemption system
294  */
295 contract MasteredBeercoin is ERC20Beercoin {
296     address internal beercoinMaster;
297     mapping (address => bool) internal directDebitAllowances;
298 
299     /**
300      * Construct the MasteredBeercoin contract
301      * and make the sender the master
302      */
303     function MasteredBeercoin() public {
304         beercoinMaster = msg.sender;
305     }
306 
307     /**
308      * Restrict to the master only
309      */
310     modifier onlyMaster {
311         require(msg.sender == beercoinMaster);
312         _;
313     }
314 
315     /**
316      * The master of the Beercoin
317      */
318     function master() public view returns (address) {
319         return beercoinMaster;
320     }
321 
322     /**
323      * Declare a master at another address
324      *
325      * @param newMaster the new owner's address
326      */
327     function declareNewMaster(address newMaster) public onlyMaster {
328         beercoinMaster = newMaster;
329     }
330 
331     /**
332      * Allow the master to withdraw Beercoins from your
333      * account so you don't have to send Beercoins yourself
334      */
335     function allowDirectDebit() public {
336         directDebitAllowances[msg.sender] = true;
337     }
338 
339     /**
340      * Forbid the master to withdraw Beercoins from you account
341      */
342     function forbidDirectDebit() public {
343         directDebitAllowances[msg.sender] = false;
344     }
345 
346     /**
347      * Check whether a user allows direct debits by the master
348      *
349      * @param user the user to check
350      */
351     function directDebitAllowance(address user) public view returns (bool) {
352         return directDebitAllowances[user];
353     }
354 
355     /**
356      * Withdraw Beercoins from multiple users
357      *
358      * Beercoins are only withdrawn this way if and only if
359      * a user deliberately wants it to happen by initiating
360      * a transaction on a plattform operated by the owner
361      *
362      * @param users the addresses of the users to take Beercoins from
363      * @param values the respective amounts to take
364      */
365     function debit(address[] users, uint256[] values) public onlyMaster returns (bool) {
366         require(users.length == values.length);
367 
368         uint256 oldBalance = balances[msg.sender];
369         uint256 newBalance = oldBalance;
370 
371         address currentUser;
372         uint256 currentValue;
373         uint256 currentBalance;
374         for (uint256 i = 0; i < users.length; ++i) {
375             currentUser = users[i];
376             currentValue = values[i];
377             currentBalance = balances[currentUser];
378 
379             require(directDebitAllowances[currentUser]);
380             require(currentValue <= currentBalance);
381             balances[currentUser] = currentBalance - currentValue;
382             
383             newBalance += currentValue;
384 
385             Transfer(currentUser, msg.sender, currentValue);
386         }
387 
388         require(oldBalance <= newBalance);
389         balances[msg.sender] = newBalance;
390 
391         return true;
392     }
393 
394     /**
395      * Withdraw Beercoins from multiple users
396      *
397      * Beercoins are only withdrawn this way if and only if
398      * a user deliberately wants it to happen by initiating
399      * a transaction on a plattform operated by the owner
400      *
401      * @param users the addresses of the users to take Beercoins from
402      * @param value the amount to take from each user
403      */
404     function debitEqually(address[] users, uint256 value) public onlyMaster returns (bool) {
405         uint256 oldBalance = balances[msg.sender];
406         uint256 newBalance = oldBalance + (users.length * value);
407 
408         require(oldBalance <= newBalance);
409         balances[msg.sender] = newBalance;
410 
411         address currentUser;
412         uint256 currentBalance;
413         for (uint256 i = 0; i < users.length; ++i) {
414             currentUser = users[i];
415             currentBalance = balances[currentUser];
416 
417             require(directDebitAllowances[currentUser]);
418             require(value <= currentBalance);
419             balances[currentUser] = currentBalance - value;
420 
421             Transfer(currentUser, msg.sender, value);
422         }
423 
424         return true;
425     }
426 
427     /**
428      * Send Beercoins to multiple users
429      *
430      * @param users the addresses of the users to send Beercoins to
431      * @param values the respective amounts to send
432      */
433     function credit(address[] users, uint256[] values) public onlyMaster returns (bool) {
434         require(users.length == values.length);
435 
436         uint256 balance = balances[msg.sender];
437         uint256 totalValue = 0;
438 
439         address currentUser;
440         uint256 currentValue;
441         uint256 currentOldBalance;
442         uint256 currentNewBalance;
443         for (uint256 i = 0; i < users.length; ++i) {
444             currentUser = users[i];
445             currentValue = values[i];
446             currentOldBalance = balances[currentUser];
447             currentNewBalance = currentOldBalance + currentValue;
448 
449             require(currentOldBalance <= currentNewBalance);
450             balances[currentUser] = currentNewBalance;
451 
452             totalValue += currentValue;
453 
454             Transfer(msg.sender, currentUser, currentValue);
455         }
456 
457         require(totalValue <= balance);
458         balances[msg.sender] = balance - totalValue;
459 
460         return true;
461     }
462 
463     /**
464      * Send Beercoins to multiple users
465      *
466      * @param users the addresses of the users to send Beercoins to
467      * @param value the amounts to send to each user
468      */
469     function creditEqually(address[] users, uint256 value) public onlyMaster returns (bool) {
470         uint256 balance = balances[msg.sender];
471         uint256 totalValue = users.length * value;
472 
473         require(totalValue <= balance);
474         balances[msg.sender] = balance - totalValue;
475 
476         address currentUser;
477         uint256 currentOldBalance;
478         uint256 currentNewBalance;
479         for (uint256 i = 0; i < users.length; ++i) {
480             currentUser = users[i];
481             currentOldBalance = balances[currentUser];
482             currentNewBalance = currentOldBalance + value;
483 
484             require(currentOldBalance <= currentNewBalance);
485             balances[currentUser] = currentNewBalance;
486 
487             Transfer(msg.sender, currentUser, value);
488         }
489 
490         return true;
491     }
492 }
493 
494 
495 /**
496  * A contract that defines the central business logic
497  * which also mirrors the life of a Beercoin
498  */
499 contract Beercoin is MasteredBeercoin {
500     event Produce(uint256 newCaps);
501     event Scan(address[] users, uint256[] caps);
502     event Burn(uint256 value);
503 
504     /**
505      * Construct the Beercoin contract and
506      * assign the initial supply to the creator
507      */
508     function Beercoin() public {
509         balances[msg.sender] = INITIAL_SUPPLY;
510     }
511 
512     /**
513      * Increase the amounts of produced diamond, gold, silver, and
514      * bronze bottle caps in respect to their occurrence probabilities
515      *
516      * This function is called if and only if a brewery has actually
517      * ordered codes to produce the specified amount of bottle caps
518      *
519      * @param numberOfCaps the number of bottle caps to be produced
520      */
521     function produce(uint64 numberOfCaps) public onlyMaster returns (bool) {
522         require(numberOfCaps <= producibleCaps);
523 
524         uint256 producedCaps = packedProducedCaps;
525 
526         uint64 targetTotalCaps = numberOfCaps;
527         targetTotalCaps += uint64(producedCaps >> 192);
528         targetTotalCaps += uint64(producedCaps >> 128);
529         targetTotalCaps += uint64(producedCaps >> 64);
530         targetTotalCaps += uint64(producedCaps);
531 
532         uint64 targetDiamondCaps = (targetTotalCaps - (targetTotalCaps % 10000)) / 10000;
533         uint64 targetGoldCaps = ((targetTotalCaps - (targetTotalCaps % 1000)) / 1000) - targetDiamondCaps;
534         uint64 targetSilverCaps = ((targetTotalCaps - (targetTotalCaps % 10)) / 10) - targetDiamondCaps - targetGoldCaps;
535         uint64 targetBronzeCaps = targetTotalCaps - targetDiamondCaps - targetGoldCaps - targetSilverCaps;
536 
537         uint256 targetProducedCaps = 0;
538         targetProducedCaps |= uint256(targetDiamondCaps) << 192;
539         targetProducedCaps |= uint256(targetGoldCaps) << 128;
540         targetProducedCaps |= uint256(targetSilverCaps) << 64;
541         targetProducedCaps |= uint256(targetBronzeCaps);
542 
543         producibleCaps -= numberOfCaps;
544         packedProducedCaps = targetProducedCaps;
545 
546         Produce(targetProducedCaps - producedCaps);
547 
548         return true;
549     }
550 
551     /**
552      * Approve scans of multiple users and grant Beercoins
553      *
554      * This function is called periodically to mass-transfer Beercoins to
555      * multiple users if and only if each of them has scanned codes that
556      * our server has never verified before for the same or another user
557      *
558      * @param users the addresses of the users who scanned valid codes
559      * @param caps the amounts of caps the users have scanned as single 256-bit values
560      */
561     function scan(address[] users, uint256[] caps) public onlyMaster returns (bool) {
562         require(users.length == caps.length);
563 
564         uint256 scannedCaps = packedScannedCaps;
565 
566         uint256 currentCaps;
567         uint256 capsValue;
568         for (uint256 i = 0; i < users.length; ++i) {
569             currentCaps = caps[i];
570 
571             capsValue = DIAMOND_VALUE * (currentCaps >> 192);
572             capsValue += GOLD_VALUE * ((currentCaps >> 128) & 0xFFFFFFFFFFFFFFFF);
573             capsValue += SILVER_VALUE * ((currentCaps >> 64) & 0xFFFFFFFFFFFFFFFF);
574             capsValue += BRONZE_VALUE * (currentCaps & 0xFFFFFFFFFFFFFFFF);
575 
576             balances[users[i]] += capsValue;
577             scannedCaps += currentCaps;
578         }
579 
580         require(scannedCaps <= packedProducedCaps);
581         packedScannedCaps = scannedCaps;
582 
583         Scan(users, caps);
584 
585         return true;
586     }
587 
588     /**
589      * Remove Beercoins from the system irreversibly
590      *
591      * @param value the amount of Beercoins to burn
592      */
593     function burn(uint256 value) public onlyMaster returns (bool) {
594         uint256 balance = balances[msg.sender];
595         require(value <= balance);
596 
597         balances[msg.sender] = balance - value;
598         burntValue += value;
599 
600         Burn(value);
601 
602         return true;
603     }
604 }