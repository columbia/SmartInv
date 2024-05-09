1 pragma solidity 0.5.7;
2 
3 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
4 
5 /**
6  * @title Elliptic curve signature operations
7  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
8  * TODO Remove this library once solidity supports passing a signature to ecrecover.
9  * See https://github.com/ethereum/solidity/issues/864
10  */
11 
12 library ECDSA {
13     /**
14      * @dev Recover signer address from a message by using their signature
15      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
16      * @param signature bytes signature, the signature is generated using web3.eth.sign()
17      */
18     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
19         // Check the signature length
20         if (signature.length != 65) {
21             return (address(0));
22         }
23 
24         // Divide the signature in r, s and v variables
25         bytes32 r;
26         bytes32 s;
27         uint8 v;
28 
29         // ecrecover takes the signature parameters, and the only way to get them
30         // currently is to use assembly.
31         // solhint-disable-next-line no-inline-assembly
32         assembly {
33             r := mload(add(signature, 0x20))
34             s := mload(add(signature, 0x40))
35             v := byte(0, mload(add(signature, 0x60)))
36         }
37 
38         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
39         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
40         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
41         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
42         //
43         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
44         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
45         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
46         // these malleable signatures as well.
47         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
48             return address(0);
49         }
50 
51         if (v != 27 && v != 28) {
52             return address(0);
53         }
54 
55         // If the signature is valid (and not malleable), return the signer address
56         return ecrecover(hash, v, r, s);
57     }
58 
59     /**
60      * toEthSignedMessageHash
61      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
62      * and hash the result
63      */
64     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
65         // 32 is the length in bytes of hash,
66         // enforced by the type signature above
67         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
68     }
69 }
70 
71 // File: contracts/AliorDurableMedium.sol
72 
73 contract AliorDurableMedium {
74 
75     // ------------------------------------------------------------------------------------------ //
76     // STRUCTS
77     // ------------------------------------------------------------------------------------------ //
78     
79     // Defines a single document
80     struct Document {
81         string fileName;         // file name of the document
82         bytes32 contentHash;     // hash of document's content
83         address signer;          // address of the entity who signed the document
84         address relayer;         // address of the entity who published the transaction
85         uint40 blockNumber;      // number of the block in which the document was added
86         uint40 canceled;         // block number in which document was canceled; 0 otherwise
87     }
88 
89     // ------------------------------------------------------------------------------------------ //
90     // MODIFIERS
91     // ------------------------------------------------------------------------------------------ //
92 
93     // Restricts function use by verifying given signature with nonce
94     modifier ifCorrectlySignedWithNonce(
95         string memory _methodName,
96         bytes memory _methodArguments,
97         bytes memory _signature
98     ) {
99         bytes memory abiEncodedParams = abi.encode(address(this), nonce++, _methodName, _methodArguments);
100         verifySignature(abiEncodedParams, _signature);
101         _;
102     }
103 
104     // Restricts function use by verifying given signature without nonce
105     modifier ifCorrectlySigned(string memory _methodName, bytes memory _methodArguments, bytes memory _signature) {
106         bytes memory abiEncodedParams = abi.encode(address(this), _methodName, _methodArguments);
107         verifySignature(abiEncodedParams, _signature);
108         _;
109     }
110 
111     // Helper function used to verify signature for given bytes array
112     function verifySignature(bytes memory abiEncodedParams, bytes memory signature) internal view {
113         bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(keccak256(abiEncodedParams));
114         address recoveredAddress = ECDSA.recover(ethSignedMessageHash, signature);
115         require(recoveredAddress != address(0), "Error during the signature recovery");
116         require(recoveredAddress == owner, "Signature mismatch");
117     }
118 
119     // Restricts function use after contract's retirement
120     modifier ifNotRetired() {
121         require(upgradedVersion == address(0), "Contract is retired");
122         _;
123     } 
124 
125     // ------------------------------------------------------------------------------------------ //
126     // EVENTS
127     // ------------------------------------------------------------------------------------------ //
128 
129     // An event emitted when the contract gets retired
130     event ContractRetired(address indexed upgradedVersion);
131 
132     // An event emitted when a new document is published on the contract
133     event DocumentAdded(uint indexed documentId);
134 
135     // An event emitted when a document is canceled
136     event DocumentCanceled(uint indexed documentId);
137     
138     // An event emitted when contract owner changes
139     event OwnershipChanged(address indexed newOwner);
140 
141     // ------------------------------------------------------------------------------------------ //
142     // FIELDS
143     // ------------------------------------------------------------------------------------------ //
144 
145     address public upgradedVersion;                           // if the contract gets retired; address of the new contract
146     uint public nonce;                                        // ID of the next action
147     uint private documentCount;                               // count of documents published on the contract
148     mapping(uint => Document) private documents;              // document storage
149     mapping(bytes32 => uint) private contentHashToDocumentId; // mapping that allows retrieving documentId by contentHash
150     address public owner;                                     // owner of the contract
151     // (this address is checked in signature verification)
152 
153     // ------------------------------------------------------------------------------------------ //
154     // CONSTRUCTOR
155     // ------------------------------------------------------------------------------------------ //
156 
157     constructor(address _owner) public {
158         require(_owner != address(0), "Owner cannot be initialised to a null address");
159         owner = _owner;    // address given as a constructor parameter becomes the 'owner'
160         nonce = 0;         // first nonce is 0
161     }
162 
163     // ------------------------------------------------------------------------------------------ //
164     // VIEW FUNCTIONS
165     // ------------------------------------------------------------------------------------------ //
166 
167     // Returns the number of documents stored in the contract
168     function getDocumentCount() public view
169     returns (uint)
170     {
171         return documentCount;
172     }
173 
174     // Returns all information about a single document
175     function getDocument(uint _documentId) public view
176     returns (
177         uint documentId,             // id of the document
178         string memory fileName,      // file name of the document
179         bytes32 contentHash,         // hash of document's content
180         address signer,              // address of the entity who signed the document
181         address relayer,             // address of the entity who published the transaction
182         uint40 blockNumber,          // number of the block in which the document was added
183         uint40 canceled              // block number in which document was canceled; 0 otherwise
184     )
185     {
186         Document memory doc = documents[_documentId];
187         return (
188             _documentId, 
189             doc.fileName, 
190             doc.contentHash,
191             doc.signer,
192             doc.relayer,
193             doc.blockNumber,
194             doc.canceled
195         );
196     }
197 
198     // Gets the id of the document with given contentHash
199     function getDocumentIdWithContentHash(bytes32 _contentHash) public view
200     returns (uint) 
201     {
202         return contentHashToDocumentId[_contentHash];
203     }
204 
205     // ------------------------------------------------------------------------------------------ //
206     // STATE-CHANGING FUNCTIONS
207     // ------------------------------------------------------------------------------------------ //
208 
209     // Changes the contract owner
210     function transferOwnership(address _newOwner, bytes memory _signature) public
211     ifCorrectlySignedWithNonce("transferOwnership", abi.encode(_newOwner), _signature)
212     {
213         require(_newOwner != address(0), "Owner cannot be changed to a null address");
214         require(_newOwner != owner, "Cannot change owner to be the same address");
215         owner = _newOwner;
216         emit OwnershipChanged(_newOwner);
217     }
218 
219     // Adds a new document
220     function addDocument(
221         string memory _fileName,
222         bytes32 _contentHash,
223         bytes memory _signature
224     ) public
225     ifNotRetired
226     ifCorrectlySigned(
227         "addDocument", 
228         abi.encode(
229             _fileName,
230             _contentHash
231         ),
232         _signature
233     )
234     {
235         require(contentHashToDocumentId[_contentHash] == 0, "Document with given hash is already published");
236         uint documentId = documentCount + 1;
237         contentHashToDocumentId[_contentHash] = documentId;
238         emit DocumentAdded(documentId);
239         documents[documentId] = Document(
240             _fileName, 
241             _contentHash,
242             owner,
243             msg.sender,
244             uint40(block.number),
245             0
246         );
247         documentCount++;
248     }
249 
250     // Cancels a published document
251     function cancelDocument(uint _documentId, bytes memory _signature) public
252     ifNotRetired
253     ifCorrectlySignedWithNonce("cancelDocument", abi.encode(_documentId), _signature)
254     {
255         require(_documentId <= documentCount && _documentId > 0, "Cannot cancel a non-existing document");
256         require(documents[_documentId].canceled == 0, "Cannot cancel an already canceled document");
257         documents[_documentId].canceled = uint40(block.number);
258         emit DocumentCanceled(_documentId);
259     }
260 
261     // Retires this contract and saves the address of the new one
262     function retire(address _upgradedVersion, bytes memory _signature) public
263     ifNotRetired
264     ifCorrectlySignedWithNonce("retire", abi.encode(_upgradedVersion), _signature)
265     {
266         upgradedVersion = _upgradedVersion;
267         emit ContractRetired(upgradedVersion);
268     }
269     
270 }