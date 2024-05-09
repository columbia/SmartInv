1 pragma solidity 0.4.20;
2 
3 /**
4 * @title DocumentaryContract
5 */
6 contract DocumentaryContract {
7 
8     // Owner of the contract    
9     address owner;
10     
11     // Get the editor rights of an address
12     mapping (address => bool) isEditor;
13 
14     // Total number of documents, starts with 1    
15     uint128 doccnt;
16     
17     // Get the author of a document with a given docid
18     mapping (uint128 => address) docauthor;		                    // docid => author
19     
20     // Get visibility of a document with a given docid
21     mapping (uint128 => bool) isInvisible;		                    // docid => invisibility
22     
23     // Get the number of documents authored by an address
24     mapping (address => uint32) userdoccnt;		                    // author => number docs of user
25     
26     // Get the document id that relates to the document number of a given address
27     mapping (address => mapping (uint32 => uint128)) userdocid;		// author => (userdocid => docid)
28 
29 
30     // Documents a new or modified document    
31     event DocumentEvent (
32         uint128 indexed docid,
33         uint128 indexed refid,
34         uint16 state,   // 0: original. Bit 1: edited
35         uint doctime,
36         address indexed author,
37         string tags,
38         string title,
39         string text
40     );
41 
42     // Documents a registration of a tag
43     event TagEvent (
44         uint128 docid,
45         address indexed author,
46         bytes32 indexed taghash,
47         uint64 indexed channelid
48     );
49 
50     // Documents the change of the visibility of a document 
51     event InvisibleDocumentEvent (
52         uint128 indexed docid,
53         uint16 state    // 0: inactive. Bit 1: active
54     );
55     
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     modifier onlyEditor {
62         require(isEditor[msg.sender] == true);
63         _;
64     }
65 
66     modifier onlyAuthor(uint128 docid) {
67         require(docauthor[docid] == msg.sender);
68         _;
69     }
70 
71     modifier onlyVisible(uint128 docid) {
72         require(isInvisible[docid] == false);
73         _;
74     }
75 
76     modifier onlyInvisible(uint128 docid) {
77         require(isInvisible[docid] == true);
78         _;
79     }
80 
81     function DocumentaryContract() public {
82         owner = msg.sender;
83         grantEditorRights(owner);
84         doccnt = 1;
85     }
86     
87     /**
88     * @dev Grants editor rights to the passed address
89     * @param user Address to obtain editor rights
90     */
91     function grantEditorRights(address user) public onlyOwner {
92         isEditor[user] = true;
93     }
94 
95     /**
96     * @dev Revokes editor rights of the passed address
97     * @param editor Address to revoke editor rights from
98     */
99     function revokeEditorRights(address editor) public onlyOwner {
100         isEditor[editor] = false;
101     }
102 
103     /**
104     * @dev Adds a document to the blockchain
105     * @param refid The document id to that the new document refers
106     * @param doctime Timestamp of the creation of the document
107     * @param taghashes Array containing the hashes of up to 5 tags
108     * @param tags String containing the tags of the document
109     * @param title String containing the title of the document
110     * @param text String containing the text of the document
111     */
112     function documentIt(uint128 refid, uint64 doctime, bytes32[] taghashes, string tags, string title, string text) public {
113         writeDocument(refid, 0, doctime, taghashes, tags, title, text);
114     }
115     
116     /**
117     * @dev Edits a document that is already present of the blockchain. The document is edited by writing a modified version to the blockchain
118     * @param docid The document id of the document that is edited
119     * @param doctime Timestamp of the edit of the document
120     * @param taghashes Array containing the hashes of up to 5 tags
121     * @param tags String containing the modified tags of the document
122     * @param title String containing the modified title of the document
123     * @param text String containing the modified text of the document
124     */
125     function editIt(uint128 docid, uint64 doctime, bytes32[] taghashes, string tags, string title, string text) public onlyAuthor(docid) onlyVisible(docid) {
126         writeDocument(docid, 1, doctime, taghashes, tags, title, text);
127     }
128 
129     /**
130     * @dev Generic function that adds a document to the blockchain or modifies a document that already exists on the blockchain
131     * @param refid The document id to that the new document refers
132     * @param state The state of the document, if 0 a new document is written, if 1 an existing document is edited
133     * @param doctime Timestamp of the creation of the document
134     * @param taghashes Array containing the hashes of up to 5 tags
135     * @param tags String containing the tags of the document
136     * @param title String containing the title of the document
137     * @param text String containing the text of the document
138     */
139     function writeDocument(uint128 refid, uint16 state, uint doctime, bytes32[] taghashes, string tags, string title, string text) internal {
140 
141         docauthor[doccnt] = msg.sender;
142         userdocid[msg.sender][userdoccnt[msg.sender]] = doccnt;
143         userdoccnt[msg.sender]++;
144         
145         DocumentEvent(doccnt, refid, state, doctime, msg.sender, tags, title, text);
146         for (uint8 i=0; i<taghashes.length; i++) {
147             if (i>=5) break;
148             if (taghashes[i] != 0) TagEvent(doccnt, msg.sender, taghashes[i], 0);
149         }
150         doccnt++;
151     }
152     
153     /**
154     * @dev Markes the document with the passed id as invisible
155     * @param docid Id of the document to be marked invisible
156     */
157     function makeInvisible(uint128 docid) public onlyEditor onlyVisible(docid) {
158         isInvisible[docid] = true;
159         InvisibleDocumentEvent(docid, 1);
160     }
161 
162     /**
163     * @dev Markes the document with the passed id as visible
164     * @param docid Id of the document to be marked visible
165     */
166     function makeVisible(uint128 docid) public onlyEditor onlyInvisible(docid) {
167         isInvisible[docid] = false;
168         InvisibleDocumentEvent(docid, 0);
169     }
170     
171     /**
172     * @dev Returns the total number of documents on the blockchain
173     * @return The total number of documents on the blockchain as uint128
174     */
175     function getDocCount() public view returns (uint128) {
176         return doccnt;
177     }
178 
179     /**
180     * @dev Returns the total number of documents on the blockchain written by the passed user 
181     * @param user Address of the user 
182     * @return The total number of documents written by the passe user as uint32
183     */
184     function getUserDocCount(address user) public view returns (uint32) {
185         return userdoccnt[user];
186     }
187 
188     /**
189     * @dev Returns the document id of the x-th document written by the passed user
190     * @param user Address of the user
191     * @param docnum Order number of the document 
192     * @return The document id as uint128
193     */
194     function getUserDocId(address user, uint32 docnum) public view returns (uint128) {
195         return userdocid[user][docnum];
196     }
197 }