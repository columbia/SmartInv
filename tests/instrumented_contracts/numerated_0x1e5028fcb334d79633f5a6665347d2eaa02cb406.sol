1 pragma solidity 0.4.25;
2 
3 /**
4  * @notice Declares a contract that can have an owner.
5  */
6 contract OwnedI {
7     event LogOwnerChanged(address indexed previousOwner, address indexed newOwner);
8 
9     function getOwner()
10         view public
11         returns (address);
12 
13     function setOwner(address newOwner)
14         public
15         returns (bool success); 
16 }
17 
18 /**
19  * @notice Defines a contract that can have an owner.
20  */
21 contract Owned is OwnedI {
22     /**
23      * @dev Made private to protect against child contract setting it to 0 by mistake.
24      */
25     address private owner;
26 
27     constructor() public {
28         owner = msg.sender;
29     }
30 
31     modifier fromOwner {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function getOwner()
37         view public
38         returns (address) {
39         return owner;
40     }
41 
42     function setOwner(address newOwner)
43         fromOwner public
44         returns (bool success) {
45         require(newOwner != 0);
46         if (owner != newOwner) {
47             emit LogOwnerChanged(owner, newOwner);
48             owner = newOwner;
49         }
50         success = true;
51     }
52 }
53 
54 contract WithBeneficiary is Owned {
55     /**
56      * @notice Address that is forwarded all value.
57      * @dev Made private to protect against child contract setting it to 0 by mistake.
58      */
59     address private beneficiary;
60     
61     event LogBeneficiarySet(address indexed previousBeneficiary, address indexed newBeneficiary);
62 
63     constructor(address _beneficiary) payable public {
64         require(_beneficiary != 0);
65         beneficiary = _beneficiary;
66         if (msg.value > 0) {
67             asyncSend(beneficiary, msg.value);
68         }
69     }
70 
71     function asyncSend(address dest, uint amount) internal;
72 
73     function getBeneficiary()
74         view public
75         returns (address) {
76         return beneficiary;
77     }
78 
79     function setBeneficiary(address newBeneficiary)
80         fromOwner public
81         returns (bool success) {
82         require(newBeneficiary != 0);
83         if (beneficiary != newBeneficiary) {
84             emit LogBeneficiarySet(beneficiary, newBeneficiary);
85             beneficiary = newBeneficiary;
86         }
87         success = true;
88     }
89 
90     function () payable public {
91         asyncSend(beneficiary, msg.value);
92     }
93 }
94 
95 contract WithFee is WithBeneficiary {
96     // @notice Contracts asking for a confirmation of a certification need to pass this fee.
97     uint256 private queryFee;
98 
99     event LogQueryFeeSet(uint256 previousQueryFee, uint256 newQueryFee);
100 
101     constructor(
102             address beneficiary,
103             uint256 _queryFee) public
104         WithBeneficiary(beneficiary) {
105         queryFee = _queryFee;
106     }
107 
108     modifier requestFeePaid {
109         require(queryFee <= msg.value);
110         asyncSend(getBeneficiary(), msg.value);
111         _;
112     }
113 
114     function getQueryFee()
115         view public
116         returns (uint256) {
117         return queryFee;
118     }
119 
120     function setQueryFee(uint256 newQueryFee)
121         fromOwner public
122         returns (bool success) {
123         if (queryFee != newQueryFee) {
124             emit LogQueryFeeSet(queryFee, newQueryFee);
125             queryFee = newQueryFee;
126         }
127         success = true;
128     }
129 }
130 
131 /*
132  * @notice Base contract supporting async send for pull payments.
133  * Inherit from this contract and use asyncSend instead of send.
134  * https://github.com/OpenZeppelin/zep-solidity/blob/master/contracts/PullPaymentCapable.sol
135  */
136 contract PullPaymentCapable {
137     uint256 private totalBalance;
138     mapping(address => uint256) private payments;
139 
140     event LogPaymentReceived(address indexed dest, uint256 amount);
141 
142     constructor() public {
143         if (0 < address(this).balance) {
144             asyncSend(msg.sender, address(this).balance);
145         }
146     }
147 
148     // store sent amount as credit to be pulled, called by payer
149     function asyncSend(address dest, uint256 amount) internal {
150         if (amount > 0) {
151             totalBalance += amount;
152             payments[dest] += amount;
153             emit LogPaymentReceived(dest, amount);
154         }
155     }
156 
157     function getTotalBalance()
158         view public
159         returns (uint256) {
160         return totalBalance;
161     }
162 
163     function getPaymentOf(address beneficiary) 
164         view public
165         returns (uint256) {
166         return payments[beneficiary];
167     }
168 
169     // withdraw accumulated balance, called by payee
170     function withdrawPayments()
171         external 
172         returns (bool success) {
173         uint256 payment = payments[msg.sender];
174         payments[msg.sender] = 0;
175         totalBalance -= payment;
176         require(msg.sender.call.value(payment)());
177         success = true;
178     }
179 
180     function fixBalance()
181         public
182         returns (bool success);
183 
184     function fixBalanceInternal(address dest)
185         internal
186         returns (bool success) {
187         if (totalBalance < address(this).balance) {
188             uint256 amount = address(this).balance - totalBalance;
189             payments[dest] += amount;
190             emit LogPaymentReceived(dest, amount);
191         }
192         return true;
193     }
194 }
195 
196 // @notice Interface for a certifier database
197 contract CertifierDbI {
198     event LogCertifierAdded(address indexed certifier);
199 
200     event LogCertifierRemoved(address indexed certifier);
201 
202     function addCertifier(address certifier)
203         public
204         returns (bool success);
205 
206     function removeCertifier(address certifier)
207         public
208         returns (bool success);
209 
210     function getCertifiersCount()
211         view public
212         returns (uint count);
213 
214     function getCertifierStatus(address certifierAddr)
215         view public 
216         returns (bool authorised, uint256 index);
217 
218     function getCertifierAtIndex(uint256 index)
219         view public
220         returns (address);
221 
222     function isCertifier(address certifier)
223         view public
224         returns (bool isIndeed);
225 }
226 
227 contract CertificationDbI {
228     event LogCertifierDbChanged(
229         address indexed previousCertifierDb,
230         address indexed newCertifierDb);
231 
232     event LogStudentCertified(
233         address indexed student, uint timestamp,
234         address indexed certifier, bytes32 indexed document);
235 
236     event LogStudentUncertified(
237         address indexed student, uint timestamp,
238         address indexed certifier);
239 
240     event LogCertificationDocumentAdded(
241         address indexed student, bytes32 indexed document);
242 
243     event LogCertificationDocumentRemoved(
244         address indexed student, bytes32 indexed document);
245 
246     function getCertifierDb()
247         view public
248         returns (address);
249 
250     function setCertifierDb(address newCertifierDb)
251         public
252         returns (bool success);
253 
254     function certify(address student, bytes32 document)
255         public
256         returns (bool success);
257 
258     function uncertify(address student)
259         public
260         returns (bool success);
261 
262     function addCertificationDocument(address student, bytes32 document)
263         public
264         returns (bool success);
265 
266     function addCertificationDocumentToSelf(bytes32 document)
267         public
268         returns (bool success);
269 
270     function removeCertificationDocument(address student, bytes32 document)
271         public
272         returns (bool success);
273 
274     function removeCertificationDocumentFromSelf(bytes32 document)
275         public
276         returns (bool success);
277 
278     function getCertifiedStudentsCount()
279         view public
280         returns (uint count);
281 
282     function getCertifiedStudentAtIndex(uint index)
283         payable public
284         returns (address student);
285 
286     function getCertification(address student)
287         payable public
288         returns (bool certified, uint timestamp, address certifier, uint documentCount);
289 
290     function isCertified(address student)
291         payable public
292         returns (bool isIndeed);
293 
294     function getCertificationDocumentAtIndex(address student, uint256 index)
295         payable public
296         returns (bytes32 document);
297 
298     function isCertification(address student, bytes32 document)
299         payable public
300         returns (bool isIndeed);
301 }
302 
303 contract CertificationDb is CertificationDbI, WithFee, PullPaymentCapable {
304     // @notice Where we check for certifiers.
305     CertifierDbI private certifierDb;
306 
307     struct DocumentStatus {
308         bool isValid;
309         uint256 index;
310     }
311 
312     struct Certification {
313         bool certified;
314         uint256 timestamp;
315         address certifier;
316         mapping(bytes32 => DocumentStatus) documentStatuses;
317         bytes32[] documents;
318         uint256 index;
319     }
320 
321     // @notice Address of certified students.
322     mapping(address => Certification) studentCertifications;
323     // @notice The potentially long list of all certified students.
324     address[] certifiedStudents;
325 
326     constructor(
327             address beneficiary,
328             uint256 certificationQueryFee,
329             address _certifierDb)
330             public
331             WithFee(beneficiary, certificationQueryFee) {
332         require(_certifierDb != 0);
333         certifierDb = CertifierDbI(_certifierDb);
334     }
335 
336     modifier fromCertifier {
337         require(certifierDb.isCertifier(msg.sender));
338         _;
339     }
340 
341     function getCertifierDb()
342         view public
343         returns (address) {
344         return certifierDb;
345     }
346 
347     function setCertifierDb(address newCertifierDb)
348         fromOwner public
349         returns (bool success) {
350         require(newCertifierDb != 0);
351         if (certifierDb != newCertifierDb) {
352             emit LogCertifierDbChanged(certifierDb, newCertifierDb);
353             certifierDb = CertifierDbI(newCertifierDb);
354         }
355         success = true;
356     }
357 
358     function certify(address student, bytes32 document) 
359         fromCertifier public
360         returns (bool success) {
361         require(student != 0);
362         require(!studentCertifications[student].certified);
363         bool documentExists = document != 0;
364         studentCertifications[student] = Certification({
365             certified: true,
366             timestamp: now,
367             certifier: msg.sender,
368             documents: new bytes32[](0),
369             index: certifiedStudents.length
370         });
371         if (documentExists) {
372             studentCertifications[student].documentStatuses[document] = DocumentStatus({
373                 isValid: true,
374                 index: studentCertifications[student].documents.length
375             });
376             studentCertifications[student].documents.push(document);
377         }
378         certifiedStudents.push(student);
379         emit LogStudentCertified(student, now, msg.sender, document);
380         success = true;
381     }
382 
383     function uncertify(address student) 
384         fromCertifier public
385         returns (bool success) {
386         require(studentCertifications[student].certified);
387         // You need to uncertify all documents first
388         require(studentCertifications[student].documents.length == 0);
389         uint256 index = studentCertifications[student].index;
390         delete studentCertifications[student];
391         if (certifiedStudents.length > 1) {
392             certifiedStudents[index] = certifiedStudents[certifiedStudents.length - 1];
393             studentCertifications[certifiedStudents[index]].index = index;
394         }
395         certifiedStudents.length--;
396         emit LogStudentUncertified(student, now, msg.sender);
397         success = true;
398     }
399 
400     function addCertificationDocument(address student, bytes32 document)
401         fromCertifier public
402         returns (bool success) {
403         success = addCertificationDocumentInternal(student, document);
404     }
405 
406     function addCertificationDocumentToSelf(bytes32 document)
407         public
408         returns (bool success) {
409         success = addCertificationDocumentInternal(msg.sender, document);
410     }
411 
412     function addCertificationDocumentInternal(address student, bytes32 document)
413         internal
414         returns (bool success) {
415         require(studentCertifications[student].certified);
416         require(document != 0);
417         Certification storage certification = studentCertifications[student];
418         if (!certification.documentStatuses[document].isValid) {
419             certification.documentStatuses[document] = DocumentStatus({
420                 isValid:  true,
421                 index: certification.documents.length
422             });
423             certification.documents.push(document);
424             emit LogCertificationDocumentAdded(student, document);
425         }
426         success = true;
427     }
428 
429     function removeCertificationDocument(address student, bytes32 document)
430         fromCertifier public
431         returns (bool success) {
432         success = removeCertificationDocumentInternal(student, document);
433     }
434 
435     function removeCertificationDocumentFromSelf(bytes32 document)
436         public
437         returns (bool success) {
438         success = removeCertificationDocumentInternal(msg.sender, document);
439     }
440 
441     function removeCertificationDocumentInternal(address student, bytes32 document)
442         internal
443         returns (bool success) {
444         require(studentCertifications[student].certified);
445         Certification storage certification = studentCertifications[student];
446         if (certification.documentStatuses[document].isValid) {
447             uint256 index = certification.documentStatuses[document].index;
448             delete certification.documentStatuses[document];
449             if (certification.documents.length > 1) {
450                 certification.documents[index] =
451                     certification.documents[certification.documents.length - 1];
452                 certification.documentStatuses[certification.documents[index]].index = index;
453             }
454             certification.documents.length--;
455             emit LogCertificationDocumentRemoved(student, document);
456         }
457         success = true;
458     }
459 
460     function getCertifiedStudentsCount()
461         view public
462         returns (uint256 count) {
463         count = certifiedStudents.length;
464     }
465 
466     function getCertifiedStudentAtIndex(uint256 index)
467         payable public
468         requestFeePaid
469         returns (address student) {
470         student = certifiedStudents[index];
471     }
472 
473     /**
474      * @notice Requesting a certification is a paying feature.
475      */
476     function getCertification(address student)
477         payable public
478         requestFeePaid
479         returns (bool certified, uint256 timestamp, address certifier, uint256 documentCount) {
480         Certification storage certification = studentCertifications[student];
481         return (certification.certified,
482             certification.timestamp,
483             certification.certifier,
484             certification.documents.length);
485     }
486 
487     /**
488      * @notice Requesting a certification confirmation is a paying feature.
489      */
490     function isCertified(address student)
491         payable public
492         requestFeePaid
493         returns (bool isIndeed) {
494         isIndeed = studentCertifications[student].certified;
495     }
496 
497     /**
498      * @notice Requesting a certification document by index is a paying feature.
499      */
500     function getCertificationDocumentAtIndex(address student, uint256 index)
501         payable public
502         requestFeePaid
503         returns (bytes32 document) {
504         document = studentCertifications[student].documents[index];
505     }
506 
507     /**
508      * @notice Requesting a confirmation that a document is a certification is a paying feature.
509      */
510     function isCertification(address student, bytes32 document)
511         payable public
512         requestFeePaid
513         returns (bool isIndeed) {
514         isIndeed = studentCertifications[student].documentStatuses[document].isValid;
515     }
516 
517     function fixBalance()
518         public
519         returns (bool success) {
520         return fixBalanceInternal(getBeneficiary());
521     }
522 }