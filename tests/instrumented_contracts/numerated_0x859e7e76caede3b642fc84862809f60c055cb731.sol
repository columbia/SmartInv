1 pragma solidity ^0.4.7;
2 /// @title EarlyPurchase contract - Keep track of purchased amount by Early Purchasers
3 /// @author Starbase PTE. LTD. - <info@starbase.co>
4 contract AbstractStarbaseCrowdsale {
5     function startDate() constant returns (uint256 startDate) {}
6 }
7 
8 contract StarbaseEarlyPurchase {
9     /*
10      *  Constants
11      */
12     string public constant PURCHASE_AMOUNT_UNIT = 'CNY';    // Chinese Yuan
13     string public constant PURCHASE_AMOUNT_RATE_REFERENCE = 'http://www.xe.com/currencytables/';
14     uint public constant PURCHASE_AMOUNT_CAP = 9000000;
15 
16     /*
17      *  Types
18      */
19     struct EarlyPurchase {
20         address purchaser;
21         uint amount;        // CNY based amount
22         uint purchasedAt;   // timestamp
23     }
24 
25     /*
26      *  External contracts
27      */
28     AbstractStarbaseCrowdsale public starbaseCrowdsale;
29 
30     /*
31      *  Storage
32      */
33     address public owner;
34     EarlyPurchase[] public earlyPurchases;
35     uint public earlyPurchaseClosedAt;
36 
37     /*
38      *  Modifiers
39      */
40     modifier noEther() {
41         if (msg.value > 0) {
42             throw;
43         }
44         _;
45     }
46 
47     modifier onlyOwner() {
48         if (msg.sender != owner) {
49             throw;
50         }
51         _;
52     }
53 
54     modifier onlyBeforeCrowdsale() {
55         if (address(starbaseCrowdsale) != 0 &&
56             starbaseCrowdsale.startDate() > 0)
57         {
58             throw;
59         }
60         _;
61     }
62 
63     modifier onlyEarlyPurchaseTerm() {
64         if (earlyPurchaseClosedAt > 0) {
65             throw;
66         }
67         _;
68     }
69 
70     /*
71      *  Contract functions
72      */
73     /// @dev Returns early purchased amount by purchaser's address
74     /// @param purchaser Purchaser address
75     function purchasedAmountBy(address purchaser)
76         external
77         constant
78         noEther
79         returns (uint amount)
80     {
81         for (uint i; i < earlyPurchases.length; i++) {
82             if (earlyPurchases[i].purchaser == purchaser) {
83                 amount += earlyPurchases[i].amount;
84             }
85         }
86     }
87 
88     /// @dev Returns total amount of raised funds by Early Purchasers
89     function totalAmountOfEarlyPurchases()
90         constant
91         noEther
92         returns (uint totalAmount)
93     {
94         for (uint i; i < earlyPurchases.length; i++) {
95             totalAmount += earlyPurchases[i].amount;
96         }
97     }
98 
99     /// @dev Returns number of early purchases
100     function numberOfEarlyPurchases()
101         external
102         constant
103         noEther
104         returns (uint)
105     {
106         return earlyPurchases.length;
107     }
108 
109     /// @dev Append an early purchase log
110     /// @param purchaser Purchaser address
111     /// @param amount Purchase amount
112     /// @param purchasedAt Timestamp of purchased date
113     function appendEarlyPurchase(address purchaser, uint amount, uint purchasedAt)
114         external
115         noEther
116         onlyOwner
117         onlyBeforeCrowdsale
118         onlyEarlyPurchaseTerm
119         returns (bool)
120     {
121         if (amount == 0 ||
122             totalAmountOfEarlyPurchases() + amount > PURCHASE_AMOUNT_CAP)
123         {
124             return false;
125         }
126 
127         if (purchasedAt == 0 || purchasedAt > now) {
128             throw;
129         }
130 
131         earlyPurchases.push(EarlyPurchase(purchaser, amount, purchasedAt));
132         return true;
133     }
134 
135     /// @dev Close early purchase term
136     function closeEarlyPurchase()
137         external
138         noEther
139         onlyOwner
140         returns (bool)
141     {
142         earlyPurchaseClosedAt = now;
143     }
144 
145     /// @dev Setup function sets external contract's address
146     /// @param starbaseCrowdsaleAddress Token address
147     function setup(address starbaseCrowdsaleAddress)
148         external
149         noEther
150         onlyOwner
151         returns (bool)
152     {
153         if (address(starbaseCrowdsale) == 0) {
154             starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddress);
155             return true;
156         }
157         return false;
158     }
159 
160     /// @dev Contract constructor function
161     function StarbaseEarlyPurchase() noEther {
162         owner = msg.sender;
163     }
164 
165     /// @dev Fallback function always fails
166     function () {
167         throw;
168     }
169 }
170 
171 
172 contract StarbaseEarlyPurchaseAmendment {
173     /*
174      *  Events
175      */
176     event EarlyPurchaseInvalidated(uint epIdx);
177     event EarlyPurchaseAmended(uint epIdx);
178 
179     /*
180      *  External contracts
181      */
182     AbstractStarbaseCrowdsale public starbaseCrowdsale;
183     StarbaseEarlyPurchase public starbaseEarlyPurchase;
184 
185     /*
186      *  Storage
187      */
188     address public owner;
189     uint[] public invalidEarlyPurchaseIndexes;
190     uint[] public amendedEarlyPurchaseIndexes;
191     mapping (uint => StarbaseEarlyPurchase.EarlyPurchase) public amendedEarlyPurchases;
192 
193     /*
194      *  Modifiers
195      */
196     modifier noEther() {
197         if (msg.value > 0) {
198             throw;
199         }
200         _;
201     }
202 
203     modifier onlyOwner() {
204         if (msg.sender != owner) {
205             throw;
206         }
207         _;
208     }
209 
210     modifier onlyBeforeCrowdsale() {
211         if (address(starbaseCrowdsale) != 0 &&
212             starbaseCrowdsale.startDate() > 0)
213         {
214             throw;
215         }
216         _;
217     }
218 
219     modifier onlyEarlyPurchasesLoaded() {
220         if (address(starbaseEarlyPurchase) == 0) {
221             throw;
222         }
223         _;
224     }
225 
226     /*
227      *  Contract functions are compatible with original ones
228      */
229     /// @dev Returns an early purchase record
230     /// @param earlyPurchaseIndex Index number of an early purchase
231     function earlyPurchases(uint earlyPurchaseIndex)
232         external
233         constant
234         onlyEarlyPurchasesLoaded
235         returns (address purchaser, uint amount, uint purchasedAt)
236     {
237         return starbaseEarlyPurchase.earlyPurchases(earlyPurchaseIndex);
238     }
239 
240     /// @dev Returns early purchased amount by purchaser's address
241     /// @param purchaser Purchaser address
242     function purchasedAmountBy(address purchaser)
243         external
244         constant
245         noEther
246         returns (uint amount)
247     {
248         StarbaseEarlyPurchase.EarlyPurchase[] memory normalizedEP =
249             normalizedEarlyPurchases();
250         for (uint i; i < normalizedEP.length; i++) {
251             if (normalizedEP[i].purchaser == purchaser) {
252                 amount += normalizedEP[i].amount;
253             }
254         }
255     }
256 
257     /// @dev Returns total amount of raised funds by Early Purchasers
258     function totalAmountOfEarlyPurchases()
259         constant
260         noEther
261         returns (uint totalAmount)
262     {
263         StarbaseEarlyPurchase.EarlyPurchase[] memory normalizedEP =
264             normalizedEarlyPurchases();
265         for (uint i; i < normalizedEP.length; i++) {
266             totalAmount += normalizedEP[i].amount;
267         }
268     }
269 
270     /// @dev Returns number of early purchases
271     function numberOfEarlyPurchases()
272         external
273         constant
274         noEther
275         returns (uint)
276     {
277         return normalizedEarlyPurchases().length;
278     }
279 
280     /// @dev Setup function sets external contract's address
281     /// @param starbaseCrowdsaleAddress Token address
282     function setup(address starbaseCrowdsaleAddress)
283         external
284         noEther
285         onlyOwner
286         returns (bool)
287     {
288         if (address(starbaseCrowdsale) == 0) {
289             starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddress);
290             return true;
291         }
292         return false;
293     }
294 
295     /*
296      *  Contract functions
297      */
298     function invalidateEarlyPurchase(uint earlyPurchaseIndex)
299         external
300         noEther
301         onlyOwner
302         onlyEarlyPurchasesLoaded
303         onlyBeforeCrowdsale
304         returns (bool)
305     {
306         if (numberOfRawEarlyPurchases() <= earlyPurchaseIndex) {
307             throw;  // Array Index Out of Bounds Exception
308         }
309 
310         for (uint i; i < invalidEarlyPurchaseIndexes.length; i++) {
311             if (invalidEarlyPurchaseIndexes[i] == earlyPurchaseIndex) {
312                 throw;  // disallow duplicated invalidation
313             }
314         }
315 
316         invalidEarlyPurchaseIndexes.push(earlyPurchaseIndex);
317         EarlyPurchaseInvalidated(earlyPurchaseIndex);
318         return true;
319     }
320 
321     function isInvalidEarlyPurchase(uint earlyPurchaseIndex)
322         constant
323         noEther
324         returns (bool)
325     {
326         if (numberOfRawEarlyPurchases() <= earlyPurchaseIndex) {
327             throw;  // Array Index Out of Bounds Exception
328         }
329 
330         for (uint i; i < invalidEarlyPurchaseIndexes.length; i++) {
331             if (invalidEarlyPurchaseIndexes[i] == earlyPurchaseIndex) {
332                 return true;
333             }
334         }
335         return false;
336     }
337 
338     function amendEarlyPurchase(uint earlyPurchaseIndex, address purchaser, uint amount, uint purchasedAt)
339         external
340         noEther
341         onlyOwner
342         onlyEarlyPurchasesLoaded
343         onlyBeforeCrowdsale
344         returns (bool)
345     {
346         if (purchasedAt == 0 || purchasedAt > now) {
347             throw;
348         }
349 
350         if (numberOfRawEarlyPurchases() <= earlyPurchaseIndex) {
351             throw;  // Array Index Out of Bounds Exception
352         }
353 
354         if (isInvalidEarlyPurchase(earlyPurchaseIndex)) {
355             throw;  // Invalid early purchase cannot be amended
356         }
357 
358         if (!isAmendedEarlyPurchase(earlyPurchaseIndex)) {
359             amendedEarlyPurchaseIndexes.push(earlyPurchaseIndex);
360         }
361 
362         amendedEarlyPurchases[earlyPurchaseIndex] =
363             StarbaseEarlyPurchase.EarlyPurchase(purchaser, amount, purchasedAt);
364         EarlyPurchaseAmended(earlyPurchaseIndex);
365         return true;
366     }
367 
368     function isAmendedEarlyPurchase(uint earlyPurchaseIndex)
369         constant
370         noEther
371         returns (bool)
372     {
373         if (numberOfRawEarlyPurchases() <= earlyPurchaseIndex) {
374             throw;  // Array Index Out of Bounds Exception
375         }
376 
377         for (uint i; i < amendedEarlyPurchaseIndexes.length; i++) {
378             if (amendedEarlyPurchaseIndexes[i] == earlyPurchaseIndex) {
379                 return true;
380             }
381         }
382         return false;
383     }
384 
385     function loadStarbaseEarlyPurchases(address starbaseEarlyPurchaseAddress)
386         external
387         noEther
388         onlyOwner
389         onlyBeforeCrowdsale
390         returns (bool)
391     {
392         if (starbaseEarlyPurchaseAddress == 0 ||
393             address(starbaseEarlyPurchase) != 0)
394         {
395             throw;
396         }
397 
398         starbaseEarlyPurchase = StarbaseEarlyPurchase(starbaseEarlyPurchaseAddress);
399         if (starbaseEarlyPurchase.earlyPurchaseClosedAt() == 0) {
400             throw;   // the early purchase must be closed
401         }
402         return true;
403     }
404 
405     /// @dev Contract constructor function
406     function StarbaseEarlyPurchaseAmendment() noEther {
407         owner = msg.sender;
408     }
409 
410     /// @dev Fallback function always fails
411     function () {
412         throw;
413     }
414 
415     /**
416      * Internal functions
417      */
418     function normalizedEarlyPurchases()
419         constant
420         internal
421         returns (StarbaseEarlyPurchase.EarlyPurchase[] normalizedEP)
422     {
423         uint rawEPCount = numberOfRawEarlyPurchases();
424         normalizedEP = new StarbaseEarlyPurchase.EarlyPurchase[](
425             rawEPCount - invalidEarlyPurchaseIndexes.length);
426 
427         uint normalizedIdx;
428         for (uint i; i < rawEPCount; i++) {
429             if (isInvalidEarlyPurchase(i)) {
430                 continue;   // invalid early purchase should be ignored
431             }
432 
433             StarbaseEarlyPurchase.EarlyPurchase memory ep;
434             if (isAmendedEarlyPurchase(i)) {
435                 ep = amendedEarlyPurchases[i];  // amended early purchase should take a priority
436             } else {
437                 ep = getEarlyPurchase(i);
438             }
439 
440             normalizedEP[normalizedIdx] = ep;
441             normalizedIdx++;
442         }
443     }
444 
445     function getEarlyPurchase(uint earlyPurchaseIndex)
446         internal
447         constant
448         onlyEarlyPurchasesLoaded
449         returns (StarbaseEarlyPurchase.EarlyPurchase)
450     {
451         var (purchaser, amount, purchasedAt) =
452             starbaseEarlyPurchase.earlyPurchases(earlyPurchaseIndex);
453         return StarbaseEarlyPurchase.EarlyPurchase(purchaser, amount, purchasedAt);
454     }
455 
456     function numberOfRawEarlyPurchases()
457         internal
458         constant
459         onlyEarlyPurchasesLoaded
460         returns (uint)
461     {
462         return starbaseEarlyPurchase.numberOfEarlyPurchases();
463     }
464 }