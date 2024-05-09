1 pragma solidity ^0.5.8;
2 
3 // File: contracts/IndividualCertification.sol
4 
5 /**
6   * @title   Individual Certification Contract
7   * @author  Rosen GmbH
8   *
9   * This contract represents the individual certificate.
10   */
11 contract IndividualCertification {
12     address public registryAddress;
13     bytes32 public b0;
14     bytes32 public b1;
15 
16     constructor(bytes32 _b0, bytes32 _b1)
17       public
18     {
19         registryAddress = msg.sender;
20         b0 = _b0;
21         b1 = _b1;
22     }
23     
24     function updateHashValue(bytes32 _b0, bytes32 _b1)
25       public
26       onlyRegistry
27     {
28         b0 = _b0;
29         b1 = _b1;
30     }
31 
32     function changeRegistry(address newRegistryAddress)
33       public
34       onlyRegistry
35     {
36         registryAddress = newRegistryAddress;
37     }
38 
39     function hashValue()
40       public
41       view
42     returns (bytes32, bytes32)
43     {
44         return (b0, b1);
45     }
46     modifier onlyRegistry() {
47         require(msg.sender == registryAddress, "Call invoked from incorrect address");
48         _;
49     }
50     /**
51   * Extinguish this certificate.
52   *
53   * This can be done by the same certifier contract which has created
54   * the certificate in the first place only.
55   */
56     function deleteCertificate() public onlyRegistry {
57         selfdestruct(msg.sender);
58     }
59 }
60 
61 // File: contracts/OrganizationalCertification.sol
62 
63 /**
64   * @title   Certificate Contract
65   * @author  Rosen HCMC Lab
66   *
67   * Each instance of this contract represents a single certificate.
68   */
69 contract OrganizationalCertification  {
70 
71     /**
72       * Address of CertificatioRegistry contract this certificate belongs to.
73       */
74     address public registryAddress;
75 
76     string public CompanyName;
77     string public Standard;
78     string public CertificateId;
79     string public IssueDate;
80     string public ExpireDate;
81     string public Scope;
82     string public CertificationBodyName;
83 
84     /**
85       * Constructor.
86       *
87       * @param _CompanyName Name of company name the certificate is IssueDate to.
88       * @param _Standard The Standard.
89       * @param _CertificateId Unique identifier of the certificate.
90       * @param _IssueDate Timestamp (Unix epoch) when the certificate was IssueDate.
91       * @param _ExpireDate Timestamp (Unix epoch) when the certificate will expire.
92       * @param _Scope The scope of the certificate.
93       * @param _CertificationBodyName The issuer of the certificate.
94       */
95     constructor(
96         string memory _CompanyName,
97         string memory _Standard,
98         string memory _CertificateId,
99         string memory _IssueDate,
100         string memory _ExpireDate,
101         string memory _Scope,
102         string memory _CertificationBodyName)
103         public
104     {
105         registryAddress = msg.sender;
106         CompanyName = _CompanyName;
107         Standard = _Standard;
108         CertificateId = _CertificateId;
109         IssueDate = _IssueDate;
110         ExpireDate = _ExpireDate;
111         Scope = _Scope;
112         CertificationBodyName = _CertificationBodyName;
113     }
114 
115     function updateCertificate(
116         string memory _CompanyName,
117         string memory _Standard,
118         string memory _IssueDate,
119         string memory _ExpireDate,
120         string memory _Scope)
121         public
122         onlyRegistry
123     {
124         CompanyName = _CompanyName;
125         Standard = _Standard;
126         IssueDate = _IssueDate;
127         ExpireDate = _ExpireDate;
128         Scope = _Scope;
129     }
130 
131     function changeRegistry(address newRegistryAddress)
132         public
133         onlyRegistry
134     {
135         registryAddress = newRegistryAddress;
136     }
137 
138     modifier onlyRegistry() {
139         require(msg.sender == registryAddress, "Call invoked from incorrect address");
140         _;
141     }
142     /**
143       * Extinguish this certificate.
144       *
145       * This can be done the same certifier contract which has created
146       * the certificate in the first place only.
147       */
148     function deleteCertificate() public onlyRegistry {
149         selfdestruct(msg.sender);
150     }
151 
152 }
153 
154 // File: contracts\CertificationRegistry.sol
155 
156 /**
157   * @title   Certification Contract
158   * @author  Rosen HCMC Lab
159   * This contract represents the singleton certificate registry.
160   */
161 
162 contract CertificationRegistry {
163 
164     /** @dev Dictionary of all Certificate Contracts issued by the Organization.
165              Stores the Organization ID and which Certificates they issued.
166              Stores the Certification key derived from the keccak256(CertificateOriginalId) and stores the
167              address where the corresponding Certificate is stored.
168              Mapping(keccak256(CertificateOriginalId, organizationID) => certAddress))
169              */
170     mapping (bytes32 => address) public CertificateAddresses;
171     mapping (bytes32 => address) public RosenCertificateAddresses;
172 
173     /** @dev Dictionary that stores which addresses are owntrated by Certification administrators and
174              which Organization those Certification adminisors belong to
175              keccak256 (adminAddress, organizationID) => bool
176      */
177     mapping (bytes32  => bool) public CertAdmins;
178 
179     /** @dev Dictionary that stores which addresses are owned by ROSEN Certification administrators
180              Mapping(adminAddress => bool)
181     */
182     mapping (address => bool) public RosenCertAdmins;
183 
184     /** @dev stores the address of the Global Administrator */
185     address public GlobalAdmin;
186 
187 
188     event OrganizationCertificationSet(address indexed contractAddress);
189     event OrganizationCertificationUpdated(address indexed contractAddress);
190     event IndividualCertificationSet(address indexed contractAddress);
191     event IndividualCertificationUpdated(address indexed contractAddress);
192     event CertificationDeleted(address indexed contractAddress);
193     event CertAdminAdded(address indexed account);
194     event CertAdminDeleted(address account);
195     event GlobalAdminChanged(address indexed account);
196     event Migration(address indexed newRegistryAddress);
197     /**
198       * Constructor.
199       *
200       * The creator of this contract becomes the global administrator.
201       */
202     constructor() public {
203         GlobalAdmin = msg.sender;
204     }
205 
206     // Functions
207 
208     /**
209       * Create a new certificate contract.
210       * This can be done by an certificate administrator only.
211       *
212       * @param _OriginalCertificateId  Globally uniqueID composed by BEC service.
213       * @param _CompanyName Name of company name the certificate is issued to.
214       * @param _Standard The norm.
215       * @param _CertificateId Certificate physical ID
216       * @param _IssueDate Timestamp (Unix epoch) when the certificate was issued.
217       * @param _ExpireDate Timestamp (Unix epoch) when the certificate will expire.
218       * @param _Scope The scope of the certificate.
219       * @param _CertificationBodyName The issuer of the certificate.
220       */
221     function setOrganizationCertificate(
222         string memory _OriginalCertificateId,
223         string memory _CompanyName,
224         string memory _Standard,
225         string memory _CertificateId,
226         string memory _IssueDate,
227         string memory _ExpireDate,
228         string memory _Scope,
229         string memory _CertificationBodyName
230     )
231     public
232     onlyRosenCertAdmin
233     {
234         bytes32 certKey = keccak256(abi.encodePacked(_OriginalCertificateId));
235 
236         OrganizationalCertification orgCert = new OrganizationalCertification(
237             _CompanyName,
238             _Standard,
239             _CertificateId,
240             _IssueDate,
241             _ExpireDate,
242             _Scope,
243             _CertificationBodyName);
244 
245         RosenCertificateAddresses[certKey] = address(orgCert);
246         emit OrganizationCertificationSet(address(orgCert));
247     }
248 
249      /**
250       * Update an organization certificate contract.
251       * This can be done by an certificate administrator only.
252       *
253       * @param _OriginalCertificateId  Globally uniqueID composed by BEC service.
254       * @param _CompanyName Name of company name the certificate is issued to.
255       * @param _Standard The norm.
256       * @param _IssueDate Timestamp (Unix epoch) when the certificate was issued.
257       * @param _ExpireDate Timestamp (Unix epoch) when the certificate will expire.
258       * @param _Scope The scope of the certificate.
259       */
260     function updateOrganizationCertificate(
261         string memory _OriginalCertificateId,
262         string memory _CompanyName,
263         string memory _Standard,
264         string memory _IssueDate,
265         string memory _ExpireDate,
266         string memory _Scope)
267         public
268     onlyRosenCertAdmin
269     {
270         bytes32 certKey = keccak256(abi.encodePacked(_OriginalCertificateId));
271         address certAddress = RosenCertificateAddresses[certKey];
272         OrganizationalCertification(certAddress).updateCertificate(
273             _CompanyName,
274             _Standard,
275             _IssueDate,
276             _ExpireDate,
277             _Scope);
278 
279         emit OrganizationCertificationUpdated(certAddress);
280     }
281     function setIndividualCertificate(
282         bytes32 b0,
283         bytes32 b1,
284         string memory _OriginalCertificateId,
285         string memory _organizationID)
286         public
287         onlyPrivilegedCertAdmin(_organizationID)
288         entryMustNotExist(_OriginalCertificateId, _organizationID)
289     {
290 
291         IndividualCertification individualCert = new IndividualCertification(b0, b1);
292         CertificateAddresses[toCertificateKey(_OriginalCertificateId, _organizationID)] = address(individualCert);
293         emit IndividualCertificationSet(address(individualCert));
294     }
295 
296     function updateIndividualCertificate(bytes32 b0, bytes32 b1, string memory _OriginalCertificateId, string memory _organizationID)
297         public
298         onlyPrivilegedCertAdmin(_organizationID)
299         duplicatedHashGuard(b0, b1, _OriginalCertificateId, _organizationID)
300     {
301 		address certAddr = CertificateAddresses[toCertificateKey(_OriginalCertificateId, _organizationID)];
302         IndividualCertification(certAddr).updateHashValue(b0, b1);
303         emit IndividualCertificationUpdated(certAddr);
304     }
305 
306     /**
307       * Delete an existing certificate.
308       *
309       * This can be done by an certificate administrator only.
310       *
311       * @param _OriginalCertificateId Unique identifier of the certificate to delete.
312       */
313     function delOrganizationCertificate(string memory _OriginalCertificateId)
314         public
315         onlyRosenCertAdmin
316     {
317 		bytes32 certKey = keccak256(abi.encodePacked(_OriginalCertificateId));
318         OrganizationalCertification(RosenCertificateAddresses[certKey]).deleteCertificate();
319 
320         emit CertificationDeleted(RosenCertificateAddresses[certKey]);
321         delete RosenCertificateAddresses[certKey];
322     }
323     /**
324       * Delete an exisiting certificate.
325       *
326       * This can be done by an certificate administrator only.
327       *
328       * @param _OriginalCertificateId Unique identifier of the certificate to delete.
329       * @param _organizationID UUID of organization tenantID.
330       */
331     function delIndividualCertificate(
332         string memory _OriginalCertificateId,
333         string memory _organizationID)
334         public
335         onlyPrivilegedCertAdmin(_organizationID)
336     {
337 		bytes32 certKey = toCertificateKey(_OriginalCertificateId,_organizationID);
338         IndividualCertification(CertificateAddresses[certKey]).deleteCertificate();
339         emit CertificationDeleted(CertificateAddresses[certKey]);
340         delete CertificateAddresses[certKey];
341 
342     }
343     /**
344       * Register a certificate administrator.
345       *
346       * This can be done by the global administrator only.
347       *
348       * @param _CertAdmin Address of certificate administrator to be added.
349       * @param _organizationID UUID of organization tenantID.
350       */
351     function addCertAdmin(address _CertAdmin, string memory _organizationID)
352         public
353         onlyGlobalAdmin
354     {
355         CertAdmins[toCertAdminKey(_CertAdmin, _organizationID)] = true;
356         emit CertAdminAdded(_CertAdmin);
357     }
358 
359     /**
360       * Delete a certificate administrator.
361       *
362       * This can be done by the global administrator only.
363       *
364       * @param _CertAdmin Address of certificate administrator to be removed.
365       * @param _organizationID UUID of organization tenantID.
366       */
367     function delCertAdmin(address _CertAdmin, string memory _organizationID)
368     public
369     onlyGlobalAdmin
370     {
371         delete CertAdmins[toCertAdminKey(_CertAdmin, _organizationID)];
372         emit CertAdminDeleted(_CertAdmin);
373     }
374 
375     /**
376     * Register a ROSEN certificate administrator.
377     *
378     * This can be done by the global administrator only.
379     *
380     * @param _CertAdmin Address of certificate administrator to be added.
381     */
382     function addRosenCertAdmin(address _CertAdmin) public onlyGlobalAdmin {
383         RosenCertAdmins[_CertAdmin] = true;
384         emit CertAdminAdded(_CertAdmin);
385     }
386 
387     /**
388       * Delete a ROSEN certificate administrator.
389       *
390       * This can be done by the global administrator only.
391       *
392       * @param _CertAdmin Address of certificate administrator to be removed.
393       */
394     function delRosenCertAdmin(address _CertAdmin) public onlyGlobalAdmin {
395         delete RosenCertAdmins[_CertAdmin];
396         emit CertAdminDeleted(_CertAdmin);
397     }
398 
399     /**
400       * Change the address of the global administrator.
401       *
402       * This can be done by the global administrator only.
403       *
404       * @param _GlobalAdmin Address of new global administrator to be set.
405       */
406     function changeGlobalAdmin(address _GlobalAdmin) public onlyGlobalAdmin {
407         GlobalAdmin=_GlobalAdmin;
408         emit GlobalAdminChanged(_GlobalAdmin);
409 
410     }
411 
412     // Constant Functions
413 
414     /**
415       * Determines the address of a certificate contract.
416       *
417       * @param _organizationID UUID of organization tenantID.
418       * @param _OriginalCertificateId Unique certificate identifier.
419       * @return Address of certification contract.
420       */
421     function getCertAddressByID(string memory _organizationID, string memory _OriginalCertificateId)
422         public
423         view
424         returns (address)
425     {
426         return CertificateAddresses[toCertificateKey(_OriginalCertificateId, _organizationID)];
427     }
428 
429     /**
430       * Determines the address of a certificate contract.
431       *
432       * @param _OriginalCertificateId Unique certificate identifier.
433       * @return Address of certification contract.
434       */
435     function getOrganizationalCertAddressByID(string memory _OriginalCertificateId)
436         public
437         view
438         returns (address)
439     {
440         return RosenCertificateAddresses[keccak256(abi.encodePacked(_OriginalCertificateId))];
441     }
442 
443 
444     function getCertAdminByOrganizationID(address _certAdmin, string memory _organizationID)
445         public
446         view
447         returns (bool)
448     {
449         return CertAdmins[toCertAdminKey(_certAdmin, _organizationID)];
450     }
451 
452     /**
453       * Derives an unique key from a certificate identifier to be used in the
454       * global mapping CertificateAddresses.
455       *
456       * This is necessary due to certificate identifiers are of type string
457       * which cannot be used as dictionary keys.
458       *
459       * @param _OriginalCertificateId The unique certificate identifier.
460       * @param _organizationID UUID of organization tenantID.
461       * @return The key derived from certificate identifier.
462       */
463     function toCertificateKey(string memory _OriginalCertificateId, string memory _organizationID)
464         public
465         pure
466         returns (bytes32)
467     {
468         return keccak256(abi.encodePacked(_OriginalCertificateId, _organizationID));
469     }
470 
471 
472     function toCertAdminKey(address _certAdmin, string memory _organizationID)
473         public
474         pure
475         returns (bytes32)
476     {
477         return keccak256(abi.encodePacked(_certAdmin, _organizationID));
478     }
479 
480     /**
481      * Use conjunction with updateIndividualCertMapping to migrate IndividualCertication contract to new CertificationRegistry
482      */
483     function migrateIndividualCertificate(address _newRegistryAddress, string memory _OriginalCertificateId, string memory _organizationID)
484         public
485         onlyGlobalAdmin
486     {
487         bytes32 certKey = toCertificateKey(_OriginalCertificateId, _organizationID);
488         address certAddress = CertificateAddresses[certKey];
489         IndividualCertification(certAddress).changeRegistry(_newRegistryAddress);
490         emit Migration(_newRegistryAddress);
491     }
492 
493     /**
494      * Use conjunction with updateOrganizationCertMapping to migrate OrganizationalCertification contract to new CertificationRegistry
495      */
496     function migrateOrganizationCertificate(address _newRegistryAddress, string memory _OriginalCertificateId)
497         public
498         onlyGlobalAdmin
499     {
500         bytes32 certKey = keccak256(abi.encodePacked(_OriginalCertificateId));
501         address certAddress = RosenCertificateAddresses[certKey];
502         IndividualCertification(certAddress).changeRegistry(_newRegistryAddress);
503         emit Migration(_newRegistryAddress);
504     }
505 
506     function updateOrganizationCertMapping(address certAddress, string memory _OriginalCertificateId)
507         public
508         onlyRosenCertAdmin
509     {
510         RosenCertificateAddresses[keccak256(abi.encodePacked(_OriginalCertificateId))] = certAddress;
511     }
512 
513     function updateIndividualCertMapping(address certAddress, string memory _OriginalCertificateId, string memory _organizationID)
514         public
515         onlyPrivilegedCertAdmin(_organizationID)
516     {
517         CertificateAddresses[toCertificateKey(_OriginalCertificateId, _organizationID)] = certAddress;
518     }
519 
520     // Modifiers
521 
522     /**
523       * Ensure that only the global administrator is able to perform.
524       */
525     modifier onlyGlobalAdmin() {
526         require(msg.sender == GlobalAdmin, "Access denied, require global admin account");
527         _;
528     }
529 
530     /**
531       * Ensure that only a privileged certificate administrator is able to perform.
532       */
533     modifier onlyPrivilegedCertAdmin(string memory organizationID) {
534         require(CertAdmins[toCertAdminKey(msg.sender, organizationID)] || RosenCertAdmins[msg.sender], 
535         "Access denied, Please use function with certificate admin privileges");
536         _;
537     }
538 
539     modifier onlyRosenCertAdmin() {
540         require(RosenCertAdmins[msg.sender], "Access denied, Please use function with certificate admin privileges");
541         _;
542     }
543     /**
544      * Ensure individual entry should not exist, prevent re-entrancy
545      */
546     modifier entryMustNotExist(string memory _OriginalCertificateId, string memory _organizationID) {
547         require(CertificateAddresses[toCertificateKey(_OriginalCertificateId, _organizationID)] == address(0), "Entry existed exception!");
548         _;
549     }
550     modifier duplicatedHashGuard(
551       bytes32 _b0,
552       bytes32 _b1,
553       string memory _OriginalCertificateId,
554       string memory _organizationID) {
555 
556         IndividualCertification individualCert = IndividualCertification(CertificateAddresses[toCertificateKey(_OriginalCertificateId, _organizationID)]);
557         require(keccak256(abi.encodePacked(_b0, _b1)) != keccak256(abi.encodePacked(individualCert.b0(), individualCert.b1())),
558         "Duplicated hash-value exception!");
559         _;
560     }
561 }