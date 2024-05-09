1 pragma solidity ^0.4.8;
2 
3 // 8D806FF01FFBE3374D34C8EC57BE9B1DA7188DF639478D37E4447DE430BA6BF4
4 contract TrustedDocument {
5 
6     // Data structure for keeping document signatures and metadata.
7     // String data types are used because its easier to read by humans 
8     // without need of decoding, gas price is less important.
9     struct Document {
10         // Id of the document, starting at 1
11         // 0 reserved for undefined / not found indicator
12         uint documentId;
13 
14         // File name
15         string fileName;
16 
17         // Hash of the main file
18         string documentContentSHA256;
19 
20         // Hash of file containing extra metadata.
21         // Secured same way as content of the file 
22         // size to save gas on transactions.
23         string documentMetadataSHA256;
24 
25         // IPFS hash of directory containing the document and metadata binaries.
26         // Hash of the directory is build as merkle tree, so any change
27         // to any of the files in folder will invalidate this hash.
28         // So there is no need to keep IPFS hash for each single file.
29         string IPFSdirectoryHash;
30 
31         // Block number
32         uint blockNumber;
33 
34         // Document validity begin date, claimed by
35         // publisher. Documents can be published
36         // before they become valid, or in some
37         // cases later.
38         uint validFrom;
39 
40         // Optional valid date to if relevant
41         uint validTo;
42 
43         // Reference to document update. Document
44         // can be updated/replaced, but such update 
45         // history cannot be hidden and it is 
46         // persistant and auditable by everyone.
47         // Update can address document itself aswell
48         // as only metadata, where documentContentSHA256
49         // stays same between updates - it can be
50         // compared between versions.
51         // This works as one way linked list
52         uint updatedVersionId;
53     }
54 
55     // Owner of the contract
56     address public owner;
57 
58     // Needed for keeping new version address.
59     // If 0, then this contract is up to date.
60     // If not 0, no documents can be added to 
61     // this version anymore. Contract becomes 
62     // retired and documents are read only.
63     address public upgradedVersion;
64 
65     // Total count of signed documents
66     uint public documentsCount;
67 
68     // URLwith documents / GUI
69     string public baseUrl;
70 
71     // Map of signed documents
72     mapping(uint => Document) private documents;
73 
74     // Event for confirmation of adding new document
75     event EventDocumentAdded(uint indexed documentId);
76 
77     // Event for updating document
78     event EventDocumentUpdated(uint indexed referencingDocumentId, uint indexed updatedDocumentId);
79     
80     // Event for going on retirement
81     event Retired(address indexed upgradedVersion);
82 
83     // Restricts call to owner
84     modifier onlyOwner() {
85         if (msg.sender == owner) 
86         _;
87     }
88 
89     // Restricts call only when this version is up to date == upgradedVersion is not set to a new address
90     // or in other words, equal to 0
91     modifier ifNotRetired() {
92         if (upgradedVersion == 0) 
93         _;
94     } 
95 
96     // Constructor
97     constructor() public {
98         owner = msg.sender;
99         baseUrl = "_";
100     }
101 
102     // Enables to transfer ownership. Works even after
103     // retirement. No documents can be added, but some
104     // other tasks still can be performed.
105     function transferOwnership(address _newOwner) public onlyOwner {
106         owner = _newOwner;
107     }
108 
109     // Adds new document - only owner and if not retired
110     function addDocument(
111         string _fileName,
112         string _documentContentSHA256, 
113         string _documentMetadataSHA256,
114         string _IPFSdirectoryHash,  
115         uint _validFrom, uint _validTo) public onlyOwner ifNotRetired {
116         // Documents incremented before use so documents ids will
117         // start with 1 not 0 (shifter by 1)
118         // 0 is reserved as undefined value
119         uint documentId = documentsCount+1;
120         //
121         emit EventDocumentAdded(documentId);
122         documents[documentId] = Document(
123             documentId, 
124             _fileName, 
125             _documentContentSHA256, 
126             _documentMetadataSHA256, 
127             _IPFSdirectoryHash,
128             block.number, 
129             _validFrom, 
130             _validTo, 
131             0
132         );
133         documentsCount++;
134     }
135 
136     // Gets total count of documents
137     function getDocumentsCount() public view
138     returns (uint)
139     {
140         return documentsCount;
141     }
142 
143     // Retire if newer version will be available. To persist
144     // integrity, address of newer version needs to be provided.
145     // After retirement there is no way to add more documents.
146     function retire(address _upgradedVersion) public onlyOwner ifNotRetired {
147         // TODO - check if such contract exists
148         upgradedVersion = _upgradedVersion;
149         emit Retired(upgradedVersion);
150     }
151 
152     // Gets document with ID
153     function getDocument(uint _documentId) public view
154     returns (
155         uint documentId,
156         string fileName,
157         string documentContentSHA256,
158         string documentMetadataSHA256,
159         string IPFSdirectoryHash,
160         uint blockNumber,
161         uint validFrom,
162         uint validTo,
163         uint updatedVersionId
164     ) {
165         Document memory doc = documents[_documentId];
166         return (
167             doc.documentId, 
168             doc.fileName, 
169             doc.documentContentSHA256, 
170             doc.documentMetadataSHA256, 
171             doc.IPFSdirectoryHash,
172             doc.blockNumber, 
173             doc.validFrom, 
174             doc.validTo, 
175             doc.updatedVersionId
176             );
177     }
178 
179     // Gets document updatedVersionId with ID
180     // 0 - no update for document
181     function getDocumentUpdatedVersionId(uint _documentId) public view
182     returns (uint) 
183     {
184         Document memory doc = documents[_documentId];
185         return doc.updatedVersionId;
186     }
187 
188     // Gets base URL so everyone will know where to seek for files storage / GUI.
189     // Multiple URLS can be set in the string and separated by comma
190     function getBaseUrl() public view
191     returns (string) 
192     {
193         return baseUrl;
194     }
195 
196     // Set base URL even on retirement. Files will have to be maintained
197     // for a very long time, and for example domain name could change.
198     // To manage this, owner should be able to set base url anytime
199     function setBaseUrl(string _baseUrl) public onlyOwner {
200         baseUrl = _baseUrl;
201     }
202 
203     // Utility to help seek fo specyfied document
204     function getFirstDocumentIdStartingAtValidFrom(uint _unixTimeFrom) public view
205     returns (uint) 
206     {
207         for (uint i = 0; i < documentsCount; i++) {
208             Document memory doc = documents[i];
209             if (doc.validFrom>=_unixTimeFrom) {
210                 return i;
211             }
212         }
213         return 0;
214     }
215 
216     // Utility to help seek fo specyfied document
217     function getFirstDocumentIdBetweenDatesValidFrom(uint _unixTimeStarting, uint _unixTimeEnding) public view
218     returns (uint firstID, uint lastId) 
219     {
220         firstID = 0;
221         lastId = 0;
222         //
223         for (uint i = 0; i < documentsCount; i++) {
224             Document memory doc = documents[i];
225             if (firstID==0) {
226                 if (doc.validFrom>=_unixTimeStarting) {
227                     firstID = i;
228                 }
229             } else {
230                 if (doc.validFrom<=_unixTimeEnding) {
231                     lastId = i;
232                 }
233             }
234         }
235         //
236         if ((firstID>0)&&(lastId==0)&&(_unixTimeStarting<_unixTimeEnding)) {
237             lastId = documentsCount;
238         }
239     }
240 
241     // Utility to help seek fo specyfied document
242     function getDocumentIdWithContentHash(string _documentContentSHA256) public view
243     returns (uint) 
244     {
245         bytes32 documentContentSHA256Keccak256 = keccak256(_documentContentSHA256);
246         for (uint i = 0; i < documentsCount; i++) {
247             Document memory doc = documents[i];
248             if (keccak256(doc.documentContentSHA256)==documentContentSHA256Keccak256) {
249                 return i;
250             }
251         }
252         return 0;
253     }
254 
255     // Utility to help seek fo specyfied document
256     function getDocumentIdWithIPFSdirectoryHash(string _IPFSdirectoryHash) public view
257     returns (uint) 
258     {
259         bytes32 IPFSdirectoryHashSHA256Keccak256 = keccak256(_IPFSdirectoryHash);
260         for (uint i = 0; i < documentsCount; i++) {
261             Document memory doc = documents[i];
262             if (keccak256(doc.IPFSdirectoryHash)==IPFSdirectoryHashSHA256Keccak256) {
263                 return i;
264             }
265         }
266         return 0;
267     }
268 
269     // Utility to help seek fo specyfied document
270     function getDocumentIdWithName(string _fileName) public view
271     returns (uint) 
272     {
273         bytes32 fileNameKeccak256 = keccak256(_fileName);
274         for (uint i = 0; i < documentsCount; i++) {
275             Document memory doc = documents[i];
276             if (keccak256(doc.fileName)==fileNameKeccak256) {
277                 return i;
278             }
279         }
280         return 0;
281     }
282 
283     // To update document:
284     // 1 - Add new version as ordinary document
285     // 2 - Call this function to link old version with update
286     function updateDocument(uint referencingDocumentId, uint updatedDocumentId) public onlyOwner ifNotRetired {
287         Document storage referenced = documents[referencingDocumentId];
288         Document memory updated = documents[updatedDocumentId];
289         //
290         referenced.updatedVersionId = updated.documentId;
291         emit EventDocumentUpdated(referenced.updatedVersionId,updated.documentId);
292     }
293 }