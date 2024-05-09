1 pragma solidity ^0.4.8;
2 
3 contract TrustedDocument {
4 
5     // Data structure for keeping document bundles signatures
6     // and metadata
7     struct Document {
8         // Id of the document, starting at 1
9         // 0 reserved for undefined / not found indicator
10         uint documentId;
11 
12         // File name
13         string fileName;
14 
15         // Hash of the main file
16         string documentContentSHA256;
17 
18         // Hash of file containing extra metadata.
19         // Secured same way as content of the file 
20         // size to save gas on transactions.
21         string documentMetadataSHA256;
22 
23         // IPFS hash of directory containing the document and metadata binaries.
24         // Hash of the directory is build as merkle tree, so any change
25         // to any of the files in folder will invalidate this hash.
26         // So there is no need to keep IPFS hash for each single file.
27         string IPFSdirectoryHash;
28 
29         // Block number
30         uint blockNumber;
31 
32         // Document validity begin date, claimed by
33         // publisher. Documents can be published
34         // before they become valid, or in some
35         // cases later.
36         uint validFrom;
37 
38         // Optional valid date to if relevant
39         uint validTo;
40 
41         // Reference to document update. Document
42         // can be updated/replaced, but such update 
43         // history cannot be hidden and it is 
44         // persistant and auditable by everyone.
45         // Update can address document itself aswell
46         // as only metadata, where documentContentSHA256
47         // stays same between updates - it can be
48         // compared between versions.
49         // This works as one way linked list
50         uint updatedVersionId;
51     }
52 
53     // Owner of the contract
54     address public owner;
55 
56     // Needed for keeping new version address.
57     // If 0, then this contract is up to date.
58     // If not 0, no documents can be added to 
59     // this version anymore. Contract becomes 
60     // retired and documents are read only.
61     address public upgradedVersion;
62 
63     // Total count of signed documents
64     uint public documentsCount;
65 
66     // Base URL on which files will be stored
67     string public baseUrl;
68 
69     // Map of signed documents
70     mapping(uint => Document) private documents;
71 
72     // Event for confirmation of adding new document
73     event EventDocumentAdded(uint indexed documentId);
74     // Event for updating document
75     event EventDocumentUpdated(uint indexed referencingDocumentId, uint indexed updatedDocumentId);
76     // Event for going on retirement
77     event Retired(address indexed upgradedVersion);
78 
79     // Restricts call to owner
80     modifier onlyOwner() {
81         if (msg.sender == owner) 
82         _;
83     }
84 
85     // Restricts call only when this version is up to date == upgradedVersion is not set to a new address
86     // or in other words, equal to 0
87     modifier ifNotRetired() {
88         if (upgradedVersion == 0) 
89         _;
90     } 
91 
92     // Constructor
93     constructor() public {
94         owner = msg.sender;
95         baseUrl = "_";
96     }
97 
98     // Enables to transfer ownership. Works even after
99     // retirement. No documents can be added, but some
100     // other tasks still can be performed.
101     function transferOwnership(address _newOwner) public onlyOwner {
102         owner = _newOwner;
103     }
104 
105     // Adds new document - only owner and if not retired
106     function addDocument(
107         string _fileName,
108         string _documentContentSHA256, 
109         string _documentMetadataSHA256,
110         string _IPFSdirectoryHash,  
111         uint _validFrom, uint _validTo) public onlyOwner ifNotRetired {
112         // Documents incremented before use so documents ids will
113         // start with 1 not 0 (shifter by 1)
114         // 0 is reserved as undefined value
115         uint documentId = documentsCount+1;
116         //
117         emit EventDocumentAdded(documentId);
118         documents[documentId] = Document(
119             documentId, 
120             _fileName, 
121             _documentContentSHA256, 
122             _documentMetadataSHA256, 
123             _IPFSdirectoryHash,
124             block.number, 
125             _validFrom, 
126             _validTo, 
127             0
128         );
129         documentsCount++;
130     }
131 
132     // Gets total count of documents
133     function getDocumentsCount() public view
134     returns (uint)
135     {
136         return documentsCount;
137     }
138 
139     // Retire if newer version will be available. To persist
140     // integrity, address of newer version needs to be provided.
141     // After retirement there is no way to add more documents.
142     function retire(address _upgradedVersion) public onlyOwner ifNotRetired {
143         // TODO - check if such contract exists
144         upgradedVersion = _upgradedVersion;
145         emit Retired(upgradedVersion);
146     }
147 
148     // Gets document with ID
149     function getDocument(uint _documentId) public view
150     returns (
151         uint documentId,
152         string fileName,
153         string documentContentSHA256,
154         string documentMetadataSHA256,
155         string IPFSdirectoryHash,
156         uint blockNumber,
157         uint validFrom,
158         uint validTo,
159         uint updatedVersionId
160     ) {
161         Document memory doc = documents[_documentId];
162         return (
163             doc.documentId, 
164             doc.fileName, 
165             doc.documentContentSHA256, 
166             doc.documentMetadataSHA256, 
167             doc.IPFSdirectoryHash,
168             doc.blockNumber, 
169             doc.validFrom, 
170             doc.validTo, 
171             doc.updatedVersionId
172             );
173     }
174 
175     // Gets document updatedVersionId with ID
176     // 0 - no update for document
177     function getDocumentUpdatedVersionId(uint _documentId) public view
178     returns (uint) 
179     {
180         Document memory doc = documents[_documentId];
181         return doc.updatedVersionId;
182     }
183 
184     // Gets base URL so everyone will know where to seek for files storage / GUI.
185     // Multiple URLS can be set in the string and separated by comma
186     function getBaseUrl() public view
187     returns (string) 
188     {
189         return baseUrl;
190     }
191 
192     // Set base URL even on retirement. Files will have to be maintained
193     // for a very long time, and for example domain name could change.
194     // To manage this, owner should be able to set base url anytime
195     function setBaseUrl(string _baseUrl) public onlyOwner {
196         baseUrl = _baseUrl;
197     }
198 
199     // Utility to help seek fo specyfied document
200     function getFirstDocumentIdStartingAtValidFrom(uint _unixTimeFrom) public view
201     returns (uint) 
202     {
203         for (uint i = 0; i < documentsCount; i++) {
204             Document memory doc = documents[i];
205             if (doc.validFrom>=_unixTimeFrom) {
206                 return i;
207             }
208         }
209         return 0;
210     }
211 
212     // Utility to help seek fo specyfied document
213     function getFirstDocumentIdBetweenDatesValidFrom(uint _unixTimeStarting, uint _unixTimeEnding) public view
214     returns (uint firstID, uint lastId) 
215     {
216         firstID = 0;
217         lastId = 0;
218         //
219         for (uint i = 0; i < documentsCount; i++) {
220             Document memory doc = documents[i];
221             if (firstID==0) {
222                 if (doc.validFrom>=_unixTimeStarting) {
223                     firstID = i;
224                 }
225             } else {
226                 if (doc.validFrom<=_unixTimeEnding) {
227                     lastId = i;
228                 }
229             }
230         }
231         //
232         if ((firstID>0)&&(lastId==0)&&(_unixTimeStarting<_unixTimeEnding)) {
233             lastId = documentsCount;
234         }
235     }
236 
237     // Utility to help seek fo specyfied document
238     function getDocumentIdWithContentHash(string _documentContentSHA256) public view
239     returns (uint) 
240     {
241         bytes32 documentContentSHA256Keccak256 = keccak256(_documentContentSHA256);
242         for (uint i = 0; i < documentsCount; i++) {
243             Document memory doc = documents[i];
244             if (keccak256(doc.documentContentSHA256)==documentContentSHA256Keccak256) {
245                 return i;
246             }
247         }
248         return 0;
249     }
250 
251     // Utility to help seek fo specyfied document
252     function getDocumentIdWithIPFSdirectoryHash(string _IPFSdirectoryHash) public view
253     returns (uint) 
254     {
255         bytes32 IPFSdirectoryHashSHA256Keccak256 = keccak256(_IPFSdirectoryHash);
256         for (uint i = 0; i < documentsCount; i++) {
257             Document memory doc = documents[i];
258             if (keccak256(doc.IPFSdirectoryHash)==IPFSdirectoryHashSHA256Keccak256) {
259                 return i;
260             }
261         }
262         return 0;
263     }
264 
265     // Utility to help seek fo specyfied document
266     function getDocumentIdWithName(string _fileName) public view
267     returns (uint) 
268     {
269         bytes32 fileNameKeccak256 = keccak256(_fileName);
270         for (uint i = 0; i < documentsCount; i++) {
271             Document memory doc = documents[i];
272             if (keccak256(doc.fileName)==fileNameKeccak256) {
273                 return i;
274             }
275         }
276         return 0;
277     }
278 
279     // To update document:
280     // 1 - Add new version as ordinary document
281     // 2 - Call this function to link old version with update
282     function updateDocument(uint referencingDocumentId, uint updatedDocumentId) public onlyOwner ifNotRetired {
283         Document storage referenced = documents[referencingDocumentId];
284         Document memory updated = documents[updatedDocumentId];
285         //
286         referenced.updatedVersionId = updated.documentId;
287         emit EventDocumentUpdated(referenced.updatedVersionId,updated.documentId);
288     }
289 }