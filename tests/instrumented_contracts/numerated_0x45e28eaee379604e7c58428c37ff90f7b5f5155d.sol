1 /**
2  * @title Certificate Library
3  *  ░V░e░r░i░f░i░e░d░ ░O░n░ ░C░h░a░i░n░
4  * Visit https://verifiedonchain.com/
5  */
6 
7 pragma solidity 0.4.24;
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipRenounced(address indexed previousOwner);
19   event OwnershipTransferred(
20     address indexed previousOwner,
21     address indexed newOwner
22   );
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   constructor() public {
30     owner = msg.sender;
31   }
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   /**
42    * @dev Allows the current owner to relinquish control of the contract.
43    * @notice Renouncing to ownership will leave the contract without an owner.
44    * It will not be possible to call the functions with the `onlyOwner`
45    * modifier anymore.
46    */
47   function renounceOwnership() public onlyOwner {
48     emit OwnershipRenounced(owner);
49     owner = address(0);
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address _newOwner) public onlyOwner {
57     _transferOwnership(_newOwner);
58   }
59 
60   /**
61    * @dev Transfers control of the contract to a newOwner.
62    * @param _newOwner The address to transfer ownership to.
63    */
64   function _transferOwnership(address _newOwner) internal {
65     require(_newOwner != address(0));
66     emit OwnershipTransferred(owner, _newOwner);
67     owner = _newOwner;
68   }
69 }
70 
71 library CertificateLibrary {
72     struct Document {
73         bytes ipfsHash;
74         bytes32 transcriptHash;
75         bytes32 contentHash;
76     }
77     
78     /**
79      * @notice Add Certification to a student
80      * @param _contentHash - Hash of the document
81      * @param _ipfsHash - IPFS Hash of the document
82      * @param _transcriptHash - Transcript Hash of the document
83      **/
84     function addCertification(Document storage self, bytes32 _contentHash, bytes _ipfsHash, bytes32 _transcriptHash) public {
85         self.ipfsHash = _ipfsHash;
86         self.contentHash= _contentHash;
87         self.transcriptHash = _transcriptHash;
88     }
89     
90     /**
91      * @notice Validate Certification to a student
92      * @param _ipfsHash - IPFS Hash of the document
93      * @param _contentHash - Content Hash of the document
94      * @param _transcriptHash - Transcript Hash of the document
95      * @return Returns true if validation is successful
96      **/
97     function validate(Document storage self, bytes _ipfsHash, bytes32 _contentHash, bytes32 _transcriptHash) public view returns(bool) {
98         bytes storage ipfsHash = self.ipfsHash;
99         bytes32 contentHash = self.contentHash;
100         bytes32 transcriptHash = self.transcriptHash;
101         return contentHash == _contentHash && keccak256(ipfsHash) == keccak256(_ipfsHash) && transcriptHash == _transcriptHash;
102     }
103     
104     /**
105      * @notice Validate IPFS Hash alone of a student
106      * @param _ipfsHash - IPFS Hash of the document
107      * @return Returns true if validation is successful
108      **/
109     function validateIpfsDoc(Document storage self, bytes _ipfsHash) public view returns(bool) {
110         bytes storage ipfsHash = self.ipfsHash;
111         return keccak256(ipfsHash) == keccak256(_ipfsHash);
112     }
113     
114     /**
115      * @notice Validate Content Hash alone of a student
116      * @param _contentHash - Content Hash of the document
117      * @return Returns true if validation is successful
118      **/
119     function validateContentHash(Document storage self, bytes32 _contentHash) public view returns(bool) {
120         bytes32 contentHash = self.contentHash;
121         return contentHash == _contentHash;
122     }
123     
124     /**
125      * @notice Validate Content Hash alone of a student
126      * @param _transcriptHash - Transcript Hash of the document
127      * @return Returns true if validation is successful
128      **/
129     function validateTranscriptHash(Document storage self, bytes32 _transcriptHash) public view returns(bool) {
130         bytes32 transcriptHash = self.transcriptHash;
131         return transcriptHash == _transcriptHash;
132     }
133 }
134 
135 contract Certificate is Ownable {
136     
137     using CertificateLibrary for CertificateLibrary.Document;
138     
139     struct Certification {
140         mapping (uint => CertificateLibrary.Document) documents;
141         uint16 indx;
142     }
143     
144     mapping (address => Certification) studentCertifications;
145     
146     event CertificationAdded(address userAddress, uint docIndx);
147     
148     /**
149      * @notice Add Certification to a student
150      * @param _student - Address of student
151      * @param _contentHash - Hash of the document
152      * @param _ipfsHash - IPFS Hash of the document
153      * @param _transcriptHash - Transcript Hash of the document
154      **/
155     function addCertification(address _student, bytes32 _contentHash, bytes _ipfsHash, bytes32 _transcriptHash) public onlyOwner {
156         uint currIndx = studentCertifications[_student].indx;
157         (studentCertifications[_student].documents[currIndx]).addCertification(_contentHash, _ipfsHash, _transcriptHash);
158         studentCertifications[_student].indx++;
159         emit CertificationAdded(_student, currIndx);
160     }
161     
162     /**
163      * @notice Validate Certification to a student
164      * @param _student - Address of student
165      * @param _docIndx - Index of the document to be validated
166      * @param _contentHash - Content Hash of the document
167      * @param _ipfsHash - IPFS Hash of the document
168      * @param _transcriptHash - Transcript Hash of the GradeSheet
169      * @return Returns true if validation is successful
170      **/
171     function validate(address _student, uint _docIndx, bytes32 _contentHash, bytes _ipfsHash, bytes32 _transcriptHash) public view returns(bool) {
172         Certification storage certification  = studentCertifications[_student];
173         return (certification.documents[_docIndx]).validate(_ipfsHash, _contentHash, _transcriptHash);
174     }
175     
176     /**
177      * @notice Validate IPFS Hash alone of a student
178      * @param _student - Address of student
179      * @param _docIndx - Index of the document to be validated
180      * @param _ipfsHash - IPFS Hash of the document
181      * @return Returns true if validation is successful
182      **/
183     function validateIpfsDoc(address _student, uint _docIndx, bytes _ipfsHash) public view returns(bool) {
184         Certification storage certification  = studentCertifications[_student];
185         return (certification.documents[_docIndx]).validateIpfsDoc(_ipfsHash);
186     }
187     
188     /**
189      * @notice Validate Content Hash alone of a student
190      * @param _student - Address of student
191      * @param _docIndx - Index of the document to be validated
192      * @param _contentHash - Content Hash of the document
193      * @return Returns true if validation is successful
194      **/
195     function validateContentHash(address _student, uint _docIndx, bytes32 _contentHash) public view returns(bool) {
196         Certification storage certification  = studentCertifications[_student];
197         return (certification.documents[_docIndx]).validateContentHash(_contentHash);
198     }
199     
200     /**
201      * @notice Validate Transcript Hash alone of a student
202      * @param _student - Address of student
203      * @param _transcriptHash - Transcript Hash of the GradeSheet
204      * @return Returns true if validation is successful
205      **/
206     function validateTranscriptHash(address _student, uint _docIndx, bytes32 _transcriptHash) public view returns(bool) {
207         Certification storage certification  = studentCertifications[_student];
208         return (certification.documents[_docIndx]).validateTranscriptHash(_transcriptHash);
209     }
210     
211     /**
212      * @notice Get Certification Document Count
213      * @param _student - Address of student
214      * @return Returns the total number of certifications for a student
215      **/
216     function getCertifiedDocCount(address _student) public view returns(uint256) {
217         return studentCertifications[_student].indx;
218     }
219     
220     /**
221      * @notice Get Certification Document from DocType
222      * @param _student - Address of student
223      * @param _docIndx - Index of the document to be validated
224      * @return Returns IPFSHash, ContentHash, TranscriptHash of the document
225      **/
226     function getCertificationDocument(address _student, uint _docIndx) public view onlyOwner returns (bytes, bytes32, bytes32) {
227         return ((studentCertifications[_student].documents[_docIndx]).ipfsHash, (studentCertifications[_student].documents[_docIndx]).contentHash, (studentCertifications[_student].documents[_docIndx]).transcriptHash);
228     }
229     
230     /**
231      * @param _studentAddrOld - Address of student old
232      * @param _studentAddrNew - Address of student new
233      * May fail due to gas exceptions
234      * ADVICE:
235      * Check gas and then send
236      **/
237     function transferAll(address _studentAddrOld, address _studentAddrNew) public onlyOwner {
238         studentCertifications[_studentAddrNew] = studentCertifications[_studentAddrOld];
239         delete studentCertifications[_studentAddrOld];
240     }
241     
242     /**
243      * @param _studentAddrOld - Address of student old
244      * @param _studentAddrNew - Address of student new
245      **/
246     function transferDoc(uint docIndx, address _studentAddrOld, address _studentAddrNew) public onlyOwner {
247         studentCertifications[_studentAddrNew].documents[docIndx] = studentCertifications[_studentAddrOld].documents[docIndx];
248         delete studentCertifications[_studentAddrOld].documents[docIndx];
249     }
250 }