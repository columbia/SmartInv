1 pragma solidity ^0.5.0;
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
17     public
18     {
19         registryAddress = msg.sender;
20         b0 = _b0;
21         b1 = _b1;
22     }
23     function updateHashValue(bytes32 _b0, bytes32 _b1)
24     public
25     {
26         require(msg.sender == registryAddress);
27         b0 = _b0;
28         b1 = _b1;
29     }
30 
31     function hashValue()
32     public
33     view
34     returns (bytes32, bytes32)
35     {
36         return (b0, b1);
37     }
38 
39     /**
40   * Extinguish this certificate.
41   *
42   * This can be done by the same certifier contract which has created
43   * the certificate in the first place only.
44   */
45     function deleteCertificate() public {
46         require(msg.sender == registryAddress);
47         selfdestruct(msg.sender);
48     }
49 }
50 
51 // File: contracts/OrganizationalCertification.sol
52 
53 /**
54   * @title   Certificate Contract
55   * @author  Chainstep GmbH
56   *
57   * Each instance of this contract represents a single certificate.
58   */
59 contract OrganizationalCertification  {
60 
61     /**
62       * Address of certifier contract this certificate belongs to.
63       */
64     address public registryAddress;
65 
66     string public CompanyName;
67     string public Norm;
68     string public CertID;
69     uint public issued;
70     uint public expires;
71     string public Scope;
72     string public issuingBody;
73 
74     /**
75       * Constructor.
76       *
77       * @param _CompanyName Name of company name the certificate is issued to.
78       * @param _Norm The norm.
79       * @param _CertID Unique identifier of the certificate.
80       * @param _issued Timestamp (Unix epoch) when the certificate was issued.
81       * @param _expires Timestamp (Unix epoch) when the certificate will expire.
82       * @param _Scope The scope of the certificate.
83       * @param _issuingBody The issuer of the certificate.
84       */
85     constructor(
86         string memory _CompanyName,
87         string memory _Norm,
88         string memory _CertID,
89         uint _issued,
90         uint _expires,
91         string memory _Scope,
92         string memory _issuingBody)
93         public
94     {
95         require(_issued < _expires);
96 
97         registryAddress = msg.sender;
98 
99         CompanyName = _CompanyName;
100         Norm =_Norm;
101         CertID = _CertID;
102         issued = _issued;
103         expires = _expires;
104         Scope = _Scope;
105         issuingBody = _issuingBody;
106     }
107 
108     /**
109       * Extinguish this certificate.
110       *
111       * This can be done the same certifier contract which has created
112       * the certificate in the first place only.
113       */
114     function deleteCertificate() public {
115         require(msg.sender == registryAddress);
116         selfdestruct(tx.origin);
117     }
118 
119 }
120 
121 // File: contracts\CertificationRegistry.sol
122 
123 /**
124   * @title   Certification Contract
125   * @author  Chainstep GmbH
126   * @author  Rosen GmbH
127   * This contract represents the singleton certificate registry.
128   */
129 
130 contract CertificationRegistry {
131 
132     /** @dev Dictionary of all Certificate Contracts issued by the Organization.
133              Stores the Organization ID and which Certificates they issued.
134              Stores the Certification key derived from the sha(CertID) and stores the
135              address where the corresponding Certificate is stored.
136              Mapping(keccak256(CertID, organizationID) => certAddress))
137              */
138     mapping (bytes32 => address) public CertificateAddresses;
139     mapping (bytes32 => address) public RosenCertificateAddresses;
140 
141     /** @dev Dictionary that stores which addresses are owntrated by Certification administrators and
142              which Organization those Certification adminisors belong to
143              keccak256 (adminAddress, organizationID) => bool
144      */
145     mapping (bytes32  => bool) public CertAdmins;
146 
147     /** @dev Dictionary that stores which addresses are owned by ROSEN Certification administrators
148              Mapping(adminAddress => bool)
149     */
150     mapping (address => bool) public RosenCertAdmins;
151 
152     /** @dev stores the address of the Global Administrator*/
153     address public GlobalAdmin;
154 
155 
156     event CertificationSet(address indexed contractAddress);
157     event IndividualCertificationSet(address indexed contractAddress);
158     event IndividualCertificationUpdated(address indexed contractAddress);
159     event CertificationDeleted(address indexed contractAddress);
160     event CertAdminAdded(address indexed account);
161     event CertAdminDeleted(address account);
162     event GlobalAdminChanged(address indexed account);
163 
164     /**
165       * Constructor.
166       *
167       * The creator of this contract becomes the global administrator.
168       */
169     constructor() public {
170         GlobalAdmin = msg.sender;
171     }
172 
173     // Functions
174 
175     /**
176       * Create a new certificate contract.
177       * This can be done by an certificate administrator only.
178       *
179       * @param _CompanyName Name of company name the certificate is issued to.
180       * @param _Norm The norm.
181       * @param _CertID Unique identifier of the certificate.
182       * @param _issued Timestamp (Unix epoch) when the certificate was issued.
183       * @param _expires Timestamp (Unix epoch) when the certificate will expire.
184       * @param _Scope The scope of the certificate.
185       * @param _issuingBody The issuer of the certificate.
186       */
187     function setCertificate(
188             string memory _CompanyName,
189             string memory _Norm,
190             string memory _CertID,
191             uint _issued,
192             uint _expires,
193             string memory _Scope,
194             string memory _issuingBody
195     )
196     public
197     onlyRosenCertAdmin
198     {
199         bytes32 certKey = keccak256(abi.encodePacked(_CertID));
200 
201         OrganizationalCertification orgCert = new OrganizationalCertification(
202             _CompanyName,
203             _Norm,
204             _CertID,
205             _issued,
206             _expires,
207             _Scope,
208             _issuingBody);
209 
210         RosenCertificateAddresses[certKey] = address(orgCert);
211         emit CertificationSet(address(orgCert));
212     }
213 
214     function setIndividualCertificate(
215             bytes32 b0,
216             bytes32 b1,
217             string memory _CertID,
218             string memory _organizationID)
219         public
220         onlyPrivilegedCertAdmin(_organizationID)
221         entryMustNotExist(_CertID, _organizationID)
222     {
223 
224         IndividualCertification individualCert = new IndividualCertification(b0, b1);
225         CertificateAddresses[toCertificateKey(_CertID, _organizationID)] = address(individualCert);
226         emit IndividualCertificationSet(address(individualCert));
227     }
228 
229     function updateIndividualCertificate(bytes32 b0, bytes32 b1, string memory _CertID, string memory _organizationID)
230         public
231         onlyPrivilegedCertAdmin(_organizationID)
232         duplicatedHashGuard(b0, b1, _CertID, _organizationID)
233     {
234 		address certAddr = CertificateAddresses[toCertificateKey(_CertID,_organizationID)];
235         IndividualCertification(certAddr).updateHashValue(b0, b1);
236         emit IndividualCertificationUpdated(certAddr);
237     }
238 
239     /**
240       * Delete an existing certificate.
241       *
242       * This can be done by an certificate administrator only.
243       *
244       * @param _CertID Unique identifier of the certificate to delete.
245       */
246     function delOrganizationCertificate(string memory _CertID)
247         public
248         onlyRosenCertAdmin
249     {
250 		bytes32 certKey = keccak256(abi.encodePacked(_CertID));
251         OrganizationalCertification(RosenCertificateAddresses[certKey]).deleteCertificate();
252 
253         emit CertificationDeleted(RosenCertificateAddresses[certKey]);
254         delete RosenCertificateAddresses[certKey];
255     }
256     /**
257       * Delete an exisiting certificate.
258       *
259       * This can be done by an certificate administrator only.
260       *
261       * @param _CertID Unique identifier of the certificate to delete.
262       */
263     function delIndividualCertificate(
264         string memory _CertID,
265         string memory _organizationID)
266     public
267     onlyPrivilegedCertAdmin(_organizationID)
268     {
269 		bytes32 certKey = toCertificateKey(_CertID,_organizationID);
270         IndividualCertification(CertificateAddresses[certKey]).deleteCertificate();
271         emit CertificationDeleted(CertificateAddresses[certKey]);
272         delete CertificateAddresses[certKey];
273 
274     }
275     /**
276       * Register a certificate administrator.
277       *
278       * This can be done by the global administrator only.
279       *
280       * @param _CertAdmin Address of certificate administrator to be added.
281       */
282     function addCertAdmin(address _CertAdmin, string memory _organizationID)
283         public
284         onlyGlobalAdmin
285     {
286         CertAdmins[toCertAdminKey(_CertAdmin, _organizationID)] = true;
287         emit CertAdminAdded(_CertAdmin);
288     }
289 
290     /**
291       * Delete a certificate administrator.
292       *
293       * This can be done by the global administrator only.
294       *
295       * @param _CertAdmin Address of certificate administrator to be removed.
296       */
297     function delCertAdmin(address _CertAdmin, string memory _organizationID)
298     public
299     onlyGlobalAdmin
300     {
301         delete CertAdmins[toCertAdminKey(_CertAdmin, _organizationID)];
302         emit CertAdminDeleted(_CertAdmin);
303     }
304 
305     /**
306   * Register a ROSEN certificate administrator.
307   *
308   * This can be done by the global administrator only.
309   *
310   * @param _CertAdmin Address of certificate administrator to be added.
311   */
312     function addRosenCertAdmin(address _CertAdmin) public onlyGlobalAdmin {
313         RosenCertAdmins[_CertAdmin] = true;
314         emit CertAdminAdded(_CertAdmin);
315     }
316 
317     /**
318       * Delete a ROSEN certificate administrator.
319       *
320       * This can be done by the global administrator only.
321       *
322       * @param _CertAdmin Address of certificate administrator to be removed.
323       */
324     function delRosenCertAdmin(address _CertAdmin) public onlyGlobalAdmin {
325         delete RosenCertAdmins[_CertAdmin];
326         emit CertAdminDeleted(_CertAdmin);
327     }
328 
329     /**
330       * Change the address of the global administrator.
331       *
332       * This can be done by the global administrator only.
333       *
334       * @param _GlobalAdmin Address of new global administrator to be set.
335       */
336     function changeGlobalAdmin(address _GlobalAdmin) public onlyGlobalAdmin {
337         GlobalAdmin=_GlobalAdmin;
338         emit GlobalAdminChanged(_GlobalAdmin);
339 
340     }
341 
342     // Constant Functions
343 
344     /**
345       * Determines the address of a certificate contract.
346       *
347       * @param _CertID Unique certificate identifier.
348       * @return Address of certification contract.
349       */
350     function getCertAddressByID(string memory _organizationID, string memory _CertID)
351         public
352         view
353         returns (address)
354     {
355         return CertificateAddresses[toCertificateKey(_CertID,_organizationID)];
356     }
357 
358     /**
359       * Determines the address of a certificate contract.
360       *
361       * @param _CertID Unique certificate identifier.
362       * @return Address of certification contract.
363       */
364     function getOrganizationalCertAddressByID(string memory _CertID)
365         public
366         view
367         returns (address)
368     {
369         return RosenCertificateAddresses[keccak256(abi.encodePacked(_CertID))];
370     }
371 
372 
373     function getCertAdminByOrganizationID(address _certAdmin, string memory _organizationID)
374         public
375         view
376         returns (bool)
377     {
378         return CertAdmins[toCertAdminKey(_certAdmin, _organizationID)];
379     }
380 
381     /**
382       * Derives an unique key from a certificate identifier to be used in the
383       * global mapping CertificateAddresses.
384       *
385       * This is necessary due to certificate identifiers are of type string
386       * which cannot be used as dictionary keys.
387       *
388       * @param _CertID The unique certificate identifier.
389       * @return The key derived from certificate identifier.
390       */
391     function toCertificateKey(string memory _CertID, string memory _organizationID)
392         public
393         pure
394         returns (bytes32)
395     {
396         return keccak256(abi.encodePacked(_CertID, _organizationID));
397     }
398 
399 
400     function toCertAdminKey(address _certAdmin, string memory _organizationID)
401         public
402         pure
403         returns (bytes32)
404     {
405         return keccak256(abi.encodePacked(_certAdmin, _organizationID));
406     }
407 
408 
409     // Modifiers
410 
411     /**
412       * Ensure that only the global administrator is able to perform.
413       */
414     modifier onlyGlobalAdmin () {
415         require(msg.sender == GlobalAdmin,
416 		"Access denied, require global admin account");
417         _;
418     }
419 
420     /**
421       * Ensure that only a privileged certificate administrator is able to perform.
422       */
423     modifier onlyPrivilegedCertAdmin(string memory organizationID) {
424         require(CertAdmins[toCertAdminKey(msg.sender, organizationID)] || RosenCertAdmins[msg.sender], 
425 		"Access denied, Please use function with certificate admin privileges");
426         _;
427     }
428 
429     modifier onlyRosenCertAdmin() {
430         require(RosenCertAdmins[msg.sender],
431         "Access denied, Please use function with certificate admin privileges");
432         _;
433     }
434     /**
435      * Ensure individual entry should not exist, prevent re-entrancy
436      */
437     modifier entryMustNotExist(string memory _CertID, string memory _organizationID) {
438         require(CertificateAddresses[toCertificateKey(_CertID, _organizationID)] == address(0),
439         "Entry existed exception!");
440         _;
441     }
442     modifier duplicatedHashGuard(
443       bytes32 _b0,
444       bytes32 _b1,
445       string memory _CertID,
446       string memory _organizationID) {
447 
448         IndividualCertification individualCert = IndividualCertification(CertificateAddresses[toCertificateKey(_CertID, _organizationID)]);
449         require(keccak256(abi.encodePacked(_b0, _b1)) != keccak256(abi.encodePacked(individualCert.b0(), individualCert.b1())),
450         "Duplicated hash-value exception!");
451         _;
452     }
453 }