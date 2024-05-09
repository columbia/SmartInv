1 pragma solidity ^0.4.8;
2 
3 contract TrustedDocument {
4     // Data structure for keeping document bundles signatures
5     // and metadata
6     struct Document {
7         // Id of the document, starting at 1
8         // 0 reserved for undefined / not found etc
9         uint documentId;
10         // File name
11         bytes32 fileName;
12         // Hash of the file -> (SHA256(TOBASE64(FILECONTENT)))
13         string documentContentSHA256;
14         // Hash of file containing extra metadata
15         // describing file. Secured same way as
16         // content of the file and can be any
17         // size to save gas on transactions
18         string documentMetadataSHA256;
19         // Block time when document was added to
20         // block / was mined
21         uint blockTime;
22         // Block number
23         uint blockNumber;
24         // Document validity date from claimed by
25         // publisher. Documents can be published
26         // before they become valid, or in some
27         // cases later.
28         uint validFrom;
29         // Optional valid date to if relevant
30         uint validTo;
31         // Reference to document update. Document
32         // can be updated/replaced, but such update 
33         // history cannot be hidden and it is 
34         // persistant and auditable by everyone.
35         // Update can address document itself aswell
36         // as only metadata, where documentContentSHA256
37         // stays same between updates - it can be
38         // compared between versions.
39         // This works as one way linked list
40         uint updatedVersionId;
41     }
42 
43     // Owner of the contract
44     address public owner;
45 
46     // Needed for keeping new version address.
47     // If 0, then this contract is up to date.
48     // If not 0, no documents can be added to 
49     // this version anymore. Contract becomes 
50     // retired and documents are read only.
51     address public upgradedVersion;
52 
53     // Total count of signed documents
54     uint public documentsCount;
55 
56     // Base URL on which files will be stored
57     string public baseUrl;
58 
59     // Map of signed documents
60     mapping(uint => Document) private documents;
61 
62     // Event for confirmation of adding new document
63     event EventDocumentAdded(uint indexed documentId);
64     // Event for updating document
65     event EventDocumentUpdated(uint indexed referencingDocumentId, uint indexed updatedDocumentId);
66     // Event for going on retirement
67     event Retired(address indexed upgradedVersion);
68 
69     // Restricts call to owner
70     modifier onlyOwner() {
71         if (msg.sender == owner) 
72         _;
73     }
74 
75     // Restricts call only when this version is up to date == upgradedVersion is not set to a new address
76     // or in other words, equal to 0
77     modifier ifNotRetired() {
78         if (upgradedVersion == 0) 
79         _;
80     } 
81 
82     // Constructor
83     function TrustedDocument() public {
84         owner = msg.sender;
85         baseUrl = "_";
86     }
87 
88     // Enables to transfer ownership. Works even after
89     // retirement. No documents can be added, but some
90     // other tasks still can be performed.
91     function transferOwnership(address _newOwner) public onlyOwner {
92         owner = _newOwner;
93     }
94 
95     // Adds new document - only owner and if not retired
96     function addDocument(bytes32 _fileName, string _documentContentSHA256, string _documentMetadataSHA256, uint _validFrom, uint _validTo) public onlyOwner ifNotRetired {
97         // Documents incremented before use so documents ids will
98         // start with 1 not 0 (shifter by 1)
99         // 0 is reserved as undefined value
100         uint documentId = documentsCount+1;
101         //
102         EventDocumentAdded(documentId);
103         documents[documentId] = Document(documentId, _fileName, _documentContentSHA256, _documentMetadataSHA256, block.timestamp, block.number, _validFrom, _validTo, 0);
104         documentsCount++;
105     }
106 
107     // Gets total count of documents
108     function getDocumentsCount() public view
109     returns (uint)
110     {
111         return documentsCount;
112     }
113 
114     // Retire if newer version will be available. To persist
115     // integrity, address of newer version needs to be provided.
116     // After retirement there is no way to add more documents.
117     function retire(address _upgradedVersion) public onlyOwner ifNotRetired {
118         // TODO - check if such contract exists
119         upgradedVersion = _upgradedVersion;
120         Retired(upgradedVersion);
121     }
122 
123     // Gets document with ID
124     function getDocument(uint _documentId) public view
125     returns (
126         uint documentId,
127         bytes32 fileName,
128         string documentContentSHA256,
129         string documentMetadataSHA256,
130         uint blockTime,
131         uint blockNumber,
132         uint validFrom,
133         uint validTo,
134         uint updatedVersionId
135     ) {
136         Document memory doc = documents[_documentId];
137         return (doc.documentId, doc.fileName, doc.documentContentSHA256, doc.documentMetadataSHA256, doc.blockTime, doc.blockNumber, doc.validFrom, doc.validTo, doc.updatedVersionId);
138     }
139 
140     // Gets document updatedVersionId with ID
141     // 0 - no update for document
142     function getDocumentUpdatedVersionId(uint _documentId) public view
143     returns (uint) 
144     {
145         Document memory doc = documents[_documentId];
146         return doc.updatedVersionId;
147     }
148 
149     // Gets base URL so GUI will know where to seek for storage.
150     // Multiple URLS can be set in the string and separated by comma
151     function getBaseUrl() public view
152     returns (string) 
153     {
154         return baseUrl;
155     }
156 
157     // Set base URL even on retirement. Files will have to be maintained
158     // for a very long time, and for example domain name could change.
159     // To manage this, owner should be able to set base url anytime
160     function setBaseUrl(string _baseUrl) public onlyOwner {
161         baseUrl = _baseUrl;
162     }
163 
164     // Utility to help seek fo specyfied document
165     function getFirstDocumentIdStartingAtValidFrom(uint _unixTimeFrom) public view
166     returns (uint) 
167     {
168         for (uint i = 0; i < documentsCount; i++) {
169            Document memory doc = documents[i];
170            if (doc.validFrom>=_unixTimeFrom) {
171                return i;
172            }
173         }
174         return 0;
175     }
176 
177     // Utility to help seek fo specyfied document
178     function getFirstDocumentIdBetweenDatesValidFrom(uint _unixTimeStarting, uint _unixTimeEnding) public view
179     returns (uint firstID, uint lastId) 
180     {
181         firstID = 0;
182         lastId = 0;
183         //
184         for (uint i = 0; i < documentsCount; i++) {
185             Document memory doc = documents[i];
186             if (firstID==0) {
187                 if (doc.validFrom>=_unixTimeStarting) {
188                     firstID = i;
189                 }
190             } else {
191                 if (doc.validFrom<=_unixTimeEnding) {
192                     lastId = i;
193                 }
194             }
195         }
196         //
197         if ((firstID>0)&&(lastId==0)&&(_unixTimeStarting<_unixTimeEnding)) {
198             lastId = documentsCount;
199         }
200     }
201 
202     // Utility to help seek fo specyfied document
203     function getDocumentIdWithContentHash(string _documentContentSHA256) public view
204     returns (uint) 
205     {
206         bytes32 documentContentSHA256Keccak256 = keccak256(_documentContentSHA256);
207         for (uint i = 0; i < documentsCount; i++) {
208            Document memory doc = documents[i];
209            if (keccak256(doc.documentContentSHA256)==documentContentSHA256Keccak256) {
210                return i;
211            }
212         }
213         return 0;
214     }
215 
216     // Utility to help seek fo specyfied document
217     function getDocumentIdWithName(string _fileName) public view
218     returns (uint) 
219     {
220         bytes32 fileNameKeccak256 = keccak256(_fileName);
221         for (uint i = 0; i < documentsCount; i++) {
222            Document memory doc = documents[i];
223            if (keccak256(doc.fileName)==fileNameKeccak256) {
224                return i;
225            }
226         }
227         return 0;
228     }
229 
230     // To update document:
231     // 1 - Add new version as ordinary document
232     // 2 - Call this function to link old version with update
233     function updateDocument(uint referencingDocumentId, uint updatedDocumentId) public onlyOwner ifNotRetired {
234         Document storage referenced = documents[referencingDocumentId];
235         Document memory updated = documents[updatedDocumentId];
236         //
237         referenced.updatedVersionId = updated.documentId;
238         EventDocumentUpdated(referenced.updatedVersionId,updated.documentId);
239     }
240 }