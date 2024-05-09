1 pragma solidity ^0.4.18;
2 
3 // File: contracts/Certification.sol
4 
5 contract Certification  {
6 
7   /**
8     * Address of certifier contract this certificate belongs to.
9     */
10   address public certifierAddress;
11 
12   string public CompanyName;
13   string public Norm;
14   string public CertID;
15   string public issued;
16   string public expires;
17   string public Scope;
18   string public issuingBody;
19 
20   /**
21     * Constructor.
22     *
23     * @param _CompanyName Name of company name the certificate is issued to.
24     * @param _Norm The norm.
25     * @param _CertID Unique identifier of the certificate.
26     * @param _issued Timestamp (Unix epoch) when the certificate was issued.
27     * @param _expires Timestamp (Unix epoch) when the certificate will expire.
28     * @param _Scope The scope of the certificate.
29     * @param _issuingBody The issuer of the certificate.
30     */
31   function Certification(string _CompanyName,
32       string _Norm,
33       string _CertID,
34       string _issued,
35       string _expires,
36       string _Scope,
37       string _issuingBody) public {
38 
39       certifierAddress = msg.sender;
40 
41       CompanyName = _CompanyName;
42       Norm =_Norm;
43       CertID = _CertID;
44       issued = _issued;
45       expires = _expires;
46       Scope = _Scope;
47       issuingBody = _issuingBody;
48   }
49 
50   /**
51     * Extinguish this certificate.
52     *
53     * This can be done the same certifier contract which has created
54     * the certificate in the first place only.
55     */
56   function deleteCertificate() public {
57       require(msg.sender == certifierAddress);
58       selfdestruct(tx.origin);
59   }
60 
61 }
62 
63 // File: contracts/Certifier.sol
64 
65 /**
66   * @title   Certification Contract
67   * @author  Chainstep GmbH
68   *
69   * This contract represents the singleton certificate registry.
70   */
71 contract Certifier {
72 
73     /** @dev Dictionary of all Certificate Contracts issued by the Certifier.
74              Stores the Certification key derived from the sha(CertID) and stores the
75              address where the coresponding Certificate is stored. */
76     mapping (bytes32 => address) public CertificateAddresses;
77 
78     /** @dev Dictionary that stores which addresses are owned by Certification administrators */
79     mapping (address => bool) public CertAdmins;
80 
81     /** @dev stores the address of the Global Administrator*/
82     address public GlobalAdmin;
83 
84     event CertificationSet(string _certID, address _certAdrress, uint setTime);
85     event CertificationDeleted(string _certID, address _certAdrress, uint delTime);
86     event CertAdminAdded(address _certAdmin);
87     event CertAdminDeleted(address _certAdmin);
88     event GlobalAdminChanged(address _globalAdmin);
89 
90 
91 
92     /**
93       * Constructor.
94       *
95       * The creator of this contract becomes the global administrator.
96       */
97     function Certifier() public {
98         GlobalAdmin = msg.sender;
99     }
100 
101     // Functions
102 
103     /**
104       * Create a new certificate contract.
105       * This can be done by an certificate administrator only.
106       *
107       * @param _CompanyName Name of company name the certificate is issued to.
108       * @param _Norm The norm.
109       * @param _CertID Unique identifier of the certificate.
110       * @param _issued Timestamp (Unix epoch) when the certificate was issued.
111       * @param _expires Timestamp (Unix epoch) when the certificate will expire.
112       * @param _Scope The scope of the certificate.
113       * @param _issuingBody The issuer of the certificate.
114       */
115     function setCertificate(string _CompanyName,
116                             string _Norm,
117                             string _CertID,
118                             string _issued,
119                             string _expires,
120                             string _Scope,
121                             string _issuingBody) public onlyCertAdmin {
122         bytes32 certKey = getCertKey(_CertID);
123 
124         CertificateAddresses[certKey] = new Certification(_CompanyName,
125                                                                _Norm,
126                                                                _CertID,
127                                                                _issued,
128                                                                _expires,
129                                                                _Scope,
130                                                                _issuingBody);
131         CertificationSet(_CertID, CertificateAddresses[certKey], now);
132     }
133 
134     /**
135       * Delete an exisiting certificate.
136       *
137       * This can be done by an certificate administrator only.
138       *
139       * @param _CertID Unique identifier of the certificate to delete.
140       */
141     function delCertificate(string _CertID) public onlyCertAdmin {
142         bytes32 certKey = getCertKey(_CertID);
143 
144         Certification(CertificateAddresses[certKey]).deleteCertificate();
145         CertificationDeleted(_CertID, CertificateAddresses[certKey], now);
146         delete CertificateAddresses[certKey];
147     }
148 
149     /**
150       * Register a certificate administrator.
151       *
152       * This can be done by the global administrator only.
153       *
154       * @param _CertAdmin Address of certificate administrator to be added.
155       */
156     function addCertAdmin(address _CertAdmin) public onlyGlobalAdmin {
157         CertAdmins[_CertAdmin] = true;
158         CertAdminAdded(_CertAdmin);
159     }
160 
161     /**
162       * Delete a certificate administrator.
163       *
164       * This can be done by the global administrator only.
165       *
166       * @param _CertAdmin Address of certificate administrator to be removed.
167       */
168     function delCertAdmin(address _CertAdmin) public onlyGlobalAdmin {
169         delete CertAdmins[_CertAdmin];
170         CertAdminDeleted(_CertAdmin);
171     }
172     /**
173       * Change the address of the global administrator.
174       *
175       * This can be done by the global administrator only.
176       *
177       * @param _GlobalAdmin Address of new global administrator to be set.
178       */
179     function changeGlobalAdmin(address _GlobalAdmin) public onlyGlobalAdmin {
180         GlobalAdmin=_GlobalAdmin;
181         GlobalAdminChanged(_GlobalAdmin);
182 
183     }
184 
185     // Constant Functions
186 
187     /**
188       * Determines the address of a certificate contract.
189       *
190       * @param _CertID Unique certificate identifier.
191       * @return Address of certification contract.
192       */
193     function getCertAddressByID(string _CertID) public constant returns (address) {
194         return CertificateAddresses[getCertKey(_CertID)];
195     }
196 
197     /**
198       * Derives an unique key from a certificate identifier to be used in the
199       * global mapping CertificateAddresses.
200       *
201       * This is necessary due to certificate identifiers are of type string
202       * which cannot be used as dictionary keys.
203       *
204       * @param _CertID The unique certificate identifier.
205       * @return The key derived from certificate identifier.
206       */
207     function getCertKey(string _CertID) public pure returns (bytes32) {
208         return sha256(_CertID);
209     }
210 
211 
212     // Modifiers
213 
214     /**
215       * Ensure that only the global administrator is able to perform.
216       */
217     modifier onlyGlobalAdmin () {
218         require(msg.sender==GlobalAdmin);
219         _;
220     }
221 
222     /**
223       * Ensure that only a certificate administrator is able to perform.
224       */
225     modifier onlyCertAdmin () {
226         require(CertAdmins[msg.sender]);
227         _;
228     }
229 
230 }
231 /**
232   * @title   Certificate Contract
233   * @author  Chainstep GmbH
234   *
235   * Each instance of this contract represents a single certificate.
236   */