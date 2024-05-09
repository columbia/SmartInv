1 pragma solidity ^0.4.2;
2 
3 /**
4  * @notice Declares a contract that can have an owner.
5  */
6 contract OwnedI {
7     event LogOwnerChanged(address indexed previousOwner, address indexed newOwner);
8 
9     function getOwner()
10         constant
11         returns (address);
12 
13     function setOwner(address newOwner)
14         returns (bool success); 
15 }
16 
17 /**
18  * @notice Defines a contract that can have an owner.
19  */
20 contract Owned is OwnedI {
21     /**
22      * @dev Made private to protect against child contract setting it to 0 by mistake.
23      */
24     address private owner;
25 
26     function Owned() {
27         owner = msg.sender;
28     }
29 
30     modifier fromOwner {
31         if (msg.sender != owner) {
32             throw;
33         }
34         _;
35     }
36 
37     function getOwner()
38         constant
39         returns (address) {
40         return owner;
41     }
42 
43     function setOwner(address newOwner)
44         fromOwner 
45         returns (bool success) {
46         if (newOwner == 0) {
47             throw;
48         }
49         if (owner != newOwner) {
50             LogOwnerChanged(owner, newOwner);
51             owner = newOwner;
52         }
53         success = true;
54     }
55 }
56 
57 contract WithBeneficiary is Owned {
58     /**
59      * @notice Address that is forwarded all value.
60      * @dev Made private to protect against child contract setting it to 0 by mistake.
61      */
62     address private beneficiary;
63     
64     event LogBeneficiarySet(address indexed previousBeneficiary, address indexed newBeneficiary);
65 
66     function WithBeneficiary(address _beneficiary) payable {
67         if (_beneficiary == 0) {
68             throw;
69         }
70         beneficiary = _beneficiary;
71         if (msg.value > 0) {
72             asyncSend(beneficiary, msg.value);
73         }
74     }
75 
76     function asyncSend(address dest, uint amount) internal;
77 
78     function getBeneficiary()
79         constant
80         returns (address) {
81         return beneficiary;
82     }
83 
84     function setBeneficiary(address newBeneficiary)
85         fromOwner 
86         returns (bool success) {
87         if (newBeneficiary == 0) {
88             throw;
89         }
90         if (beneficiary != newBeneficiary) {
91             LogBeneficiarySet(beneficiary, newBeneficiary);
92             beneficiary = newBeneficiary;
93         }
94         success = true;
95     }
96 
97     function () payable {
98         asyncSend(beneficiary, msg.value);
99     }
100 }
101 
102 contract WithFee is WithBeneficiary {
103     // @notice Contracts asking for a confirmation of a certification need to pass this fee.
104     uint256 private queryFee;
105 
106     event LogQueryFeeSet(uint256 previousQueryFee, uint256 newQueryFee);
107 
108     function WithFee(
109             address beneficiary,
110             uint256 _queryFee)
111         WithBeneficiary(beneficiary) {
112         queryFee = _queryFee;
113     }
114 
115     modifier requestFeePaid {
116         if (msg.value < queryFee) {
117             throw;
118         }
119         asyncSend(getBeneficiary(), msg.value);
120         _;
121     }
122 
123     function getQueryFee()
124         constant
125         returns (uint256) {
126         return queryFee;
127     }
128 
129     function setQueryFee(uint256 newQueryFee)
130         fromOwner
131         returns (bool success) {
132         if (queryFee != newQueryFee) {
133             LogQueryFeeSet(queryFee, newQueryFee);
134             queryFee = newQueryFee;
135         }
136         success = true;
137     }
138 }
139 
140 /*
141  * @notice Base contract supporting async send for pull payments.
142  * Inherit from this contract and use asyncSend instead of send.
143  * https://github.com/OpenZeppelin/zep-solidity/blob/master/contracts/PullPaymentCapable.sol
144  */
145 contract PullPaymentCapable {
146     uint256 private totalBalance;
147     mapping(address => uint256) private payments;
148 
149     event LogPaymentReceived(address indexed dest, uint256 amount);
150 
151     function PullPaymentCapable() {
152         if (0 < this.balance) {
153             asyncSend(msg.sender, this.balance);
154         }
155     }
156 
157     // store sent amount as credit to be pulled, called by payer
158     function asyncSend(address dest, uint256 amount) internal {
159         if (amount > 0) {
160             totalBalance += amount;
161             payments[dest] += amount;
162             LogPaymentReceived(dest, amount);
163         }
164     }
165 
166     function getTotalBalance()
167         constant
168         returns (uint256) {
169         return totalBalance;
170     }
171 
172     function getPaymentOf(address beneficiary) 
173         constant
174         returns (uint256) {
175         return payments[beneficiary];
176     }
177 
178     // withdraw accumulated balance, called by payee
179     function withdrawPayments()
180         external 
181         returns (bool success) {
182         uint256 payment = payments[msg.sender];
183         payments[msg.sender] = 0;
184         totalBalance -= payment;
185         if (!msg.sender.call.value(payment)()) {
186             throw;
187         }
188         success = true;
189     }
190 
191     function fixBalance()
192         returns (bool success);
193 
194     function fixBalanceInternal(address dest)
195         internal
196         returns (bool success) {
197         if (totalBalance < this.balance) {
198             uint256 amount = this.balance - totalBalance;
199             payments[dest] += amount;
200             LogPaymentReceived(dest, amount);
201         }
202         return true;
203     }
204 }
205 
206 // @notice Interface for a certifier database
207 contract CertifierDbI {
208     event LogCertifierAdded(address indexed certifier);
209 
210     event LogCertifierRemoved(address indexed certifier);
211 
212     function addCertifier(address certifier)
213         returns (bool success);
214 
215     function removeCertifier(address certifier)
216         returns (bool success);
217 
218     function getCertifiersCount()
219         constant
220         returns (uint count);
221 
222     function getCertifierStatus(address certifierAddr)
223         constant 
224         returns (bool authorised, uint256 index);
225 
226     function getCertifierAtIndex(uint256 index)
227         constant
228         returns (address);
229 
230     function isCertifier(address certifier)
231         constant
232         returns (bool isIndeed);
233 }
234 
235 contract CertificationDbI {
236     event LogCertifierDbChanged(
237         address indexed previousCertifierDb,
238         address indexed newCertifierDb);
239 
240     event LogStudentCertified(
241         address indexed student, uint timestamp,
242         address indexed certifier, bytes32 indexed document);
243 
244     event LogStudentUncertified(
245         address indexed student, uint timestamp,
246         address indexed certifier);
247 
248     event LogCertificationDocumentAdded(
249         address indexed student, bytes32 indexed document);
250 
251     event LogCertificationDocumentRemoved(
252         address indexed student, bytes32 indexed document);
253 
254     function getCertifierDb()
255         constant
256         returns (address);
257 
258     function setCertifierDb(address newCertifierDb)
259         returns (bool success);
260 
261     function certify(address student, bytes32 document)
262         returns (bool success);
263 
264     function uncertify(address student)
265         returns (bool success);
266 
267     function addCertificationDocument(address student, bytes32 document)
268         returns (bool success);
269 
270     function addCertificationDocumentToSelf(bytes32 document)
271         returns (bool success);
272 
273     function removeCertificationDocument(address student, bytes32 document)
274         returns (bool success);
275 
276     function removeCertificationDocumentFromSelf(bytes32 document)
277         returns (bool success);
278 
279     function getCertifiedStudentsCount()
280         constant
281         returns (uint count);
282 
283     function getCertifiedStudentAtIndex(uint index)
284         payable
285         returns (address student);
286 
287     function getCertification(address student)
288         payable
289         returns (bool certified, uint timestamp, address certifier, uint documentCount);
290 
291     function isCertified(address student)
292         payable
293         returns (bool isIndeed);
294 
295     function getCertificationDocumentAtIndex(address student, uint256 index)
296         payable
297         returns (bytes32 document);
298 
299     function isCertification(address student, bytes32 document)
300         payable
301         returns (bool isIndeed);
302 }
303 
304 contract CertificationDb is CertificationDbI, WithFee, PullPaymentCapable {
305     // @notice Where we check for certifiers.
306     CertifierDbI private certifierDb;
307 
308     struct DocumentStatus {
309         bool isValid;
310         uint256 index;
311     }
312 
313     struct Certification {
314         bool certified;
315         uint256 timestamp;
316         address certifier;
317         mapping(bytes32 => DocumentStatus) documentStatuses;
318         bytes32[] documents;
319         uint256 index;
320     }
321 
322     // @notice Address of certified students.
323     mapping(address => Certification) studentCertifications;
324     // @notice The potentially long list of all certified students.
325     address[] certifiedStudents;
326 
327     function CertificationDb(
328             address beneficiary,
329             uint256 certificationQueryFee,
330             address _certifierDb)
331             WithFee(beneficiary, certificationQueryFee) {
332         if (msg.value > 0) {
333             throw;
334         }
335         if (_certifierDb == 0) {
336             throw;
337         }
338         certifierDb = CertifierDbI(_certifierDb);
339     }
340 
341     modifier fromCertifier {
342         if (!certifierDb.isCertifier(msg.sender)) {
343             throw;
344         }
345         _;
346     }
347 
348     function getCertifierDb()
349         constant
350         returns (address) {
351         return certifierDb;
352     }
353 
354     function setCertifierDb(address newCertifierDb)
355         fromOwner
356         returns (bool success) {
357         if (newCertifierDb == 0) {
358             throw;
359         }
360         if (certifierDb != newCertifierDb) {
361             LogCertifierDbChanged(certifierDb, newCertifierDb);
362             certifierDb = CertifierDbI(newCertifierDb);
363         }
364         success = true;
365     }
366 
367     function certify(address student, bytes32 document) 
368         fromCertifier
369         returns (bool success) {
370         if (student == 0 || studentCertifications[student].certified) {
371             throw;
372         }
373         bool documentExists = document != 0;
374         studentCertifications[student] = Certification({
375             certified: true,
376             timestamp: now,
377             certifier: msg.sender,
378             documents: new bytes32[](0),
379             index: certifiedStudents.length
380         });
381         if (documentExists) {
382             studentCertifications[student].documentStatuses[document] = DocumentStatus({
383                 isValid: true,
384                 index: studentCertifications[student].documents.length
385             });
386             studentCertifications[student].documents.push(document);
387         }
388         certifiedStudents.push(student);
389         LogStudentCertified(student, now, msg.sender, document);
390         success = true;
391     }
392 
393     function uncertify(address student) 
394         fromCertifier 
395         returns (bool success) {
396         if (!studentCertifications[student].certified
397             // You need to uncertify all documents first
398             || studentCertifications[student].documents.length > 0) {
399             throw;
400         }
401         uint256 index = studentCertifications[student].index;
402         delete studentCertifications[student];
403         if (certifiedStudents.length > 1) {
404             certifiedStudents[index] = certifiedStudents[certifiedStudents.length - 1];
405             studentCertifications[certifiedStudents[index]].index = index;
406         }
407         certifiedStudents.length--;
408         LogStudentUncertified(student, now, msg.sender);
409         success = true;
410     }
411 
412     function addCertificationDocument(address student, bytes32 document)
413         fromCertifier
414         returns (bool success) {
415         success = addCertificationDocumentInternal(student, document);
416     }
417 
418     function addCertificationDocumentToSelf(bytes32 document)
419         returns (bool success) {
420         success = addCertificationDocumentInternal(msg.sender, document);
421     }
422 
423     function addCertificationDocumentInternal(address student, bytes32 document)
424         internal
425         returns (bool success) {
426         if (!studentCertifications[student].certified
427             || document == 0) {
428             throw;
429         }
430         Certification certification = studentCertifications[student];
431         if (!certification.documentStatuses[document].isValid) {
432             certification.documentStatuses[document] = DocumentStatus({
433                 isValid:  true,
434                 index: certification.documents.length
435             });
436             certification.documents.push(document);
437             LogCertificationDocumentAdded(student, document);
438         }
439         success = true;
440     }
441 
442     function removeCertificationDocument(address student, bytes32 document)
443         fromCertifier
444         returns (bool success) {
445         success = removeCertificationDocumentInternal(student, document);
446     }
447 
448     function removeCertificationDocumentFromSelf(bytes32 document)
449         returns (bool success) {
450         success = removeCertificationDocumentInternal(msg.sender, document);
451     }
452 
453     function removeCertificationDocumentInternal(address student, bytes32 document)
454         internal
455         returns (bool success) {
456         if (!studentCertifications[student].certified) {
457             throw;
458         }
459         Certification certification = studentCertifications[student];
460         if (certification.documentStatuses[document].isValid) {
461             uint256 index = certification.documentStatuses[document].index;
462             delete certification.documentStatuses[document];
463             if (certification.documents.length > 1) {
464                 certification.documents[index] =
465                     certification.documents[certification.documents.length - 1];
466                 certification.documentStatuses[certification.documents[index]].index = index;
467             }
468             certification.documents.length--;
469             LogCertificationDocumentRemoved(student, document);
470         }
471         success = true;
472     }
473 
474     function getCertifiedStudentsCount()
475         constant
476         returns (uint256 count) {
477         count = certifiedStudents.length;
478     }
479 
480     function getCertifiedStudentAtIndex(uint256 index)
481         payable
482         requestFeePaid
483         returns (address student) {
484         student = certifiedStudents[index];
485     }
486 
487     /**
488      * @notice Requesting a certification is a paying feature.
489      */
490     function getCertification(address student)
491         payable
492         requestFeePaid
493         returns (bool certified, uint256 timestamp, address certifier, uint256 documentCount) {
494         Certification certification = studentCertifications[student];
495         return (certification.certified,
496             certification.timestamp,
497             certification.certifier,
498             certification.documents.length);
499     }
500 
501     /**
502      * @notice Requesting a certification confirmation is a paying feature.
503      */
504     function isCertified(address student)
505         payable
506         requestFeePaid
507         returns (bool isIndeed) {
508         isIndeed = studentCertifications[student].certified;
509     }
510 
511     /**
512      * @notice Requesting a certification document by index is a paying feature.
513      */
514     function getCertificationDocumentAtIndex(address student, uint256 index)
515         payable
516         requestFeePaid
517         returns (bytes32 document) {
518         document = studentCertifications[student].documents[index];
519     }
520 
521     /**
522      * @notice Requesting a confirmation that a document is a certification is a paying feature.
523      */
524     function isCertification(address student, bytes32 document)
525         payable
526         requestFeePaid
527         returns (bool isIndeed) {
528         isIndeed = studentCertifications[student].documentStatuses[document].isValid;
529     }
530 
531     function fixBalance()
532         returns (bool success) {
533         return fixBalanceInternal(getBeneficiary());
534     }
535 }