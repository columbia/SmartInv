1 /*
2 This smartcontract used to store documents text on the Ethereum blockchain
3 and to get the document by document's hash (sha256).
4 
5 */
6 
7 contract ProofOfExistence{
8 
9     /* ---- Public variables: */
10     string public created;
11     address public manager; // account that adds info to this smartcontract
12     uint256 public docIndex;   // record's numbers and number of records
13 
14     mapping (uint256 => Doc) public indexedDocs; // docIndex => Doc
15     // to get Doc obj call ProofOfExistence.indexedDocs(docIndex);
16 
17     mapping (bytes32 => Doc) public sha256Docs; // docHash => Doc
18     // to get Doc obj call ProofOfExistence.docs(docHash);
19     mapping (bytes32 => Doc) public sha3Docs; // docHash => Doc
20     // to get Doc obj call ProofOfExistence.docs(docHash);
21 
22 
23     /* ---- Stored document structure: */
24 
25     struct Doc {
26         uint256 docIndex; // .............................................1
27         string publisher; // publisher's email............................2
28         uint256 publishedOnUnixTime; // block timestamp (block.timestamp).3
29         uint256 publishedInBlockNumber; // block.number...................4
30         string docText; // text of the document...........................5
31         bytes32 sha256Hash; // ...........................................6
32         bytes32 sha3Hash; // .............................................7
33     }
34 
35     /* ---- Constructor: */
36 
37     function ProofOfExistence(){
38         manager = msg.sender;
39         created = "cryptonomica.net";
40     }
41 
42     /* ---- Event:  */
43     // This generates a public event on the blockchain that will notify clients.
44     // In 'Mist' SmartContract page enable 'Watch contract events'
45     event DocumentAdded(uint256 docIndex,
46                         string publisher,
47                         uint256 publishedOnUnixTime);
48 
49 
50     /* ----- Main method: */
51 
52     function addDoc(
53                     string _publisher,
54                     string _docText) returns (bytes32) {
55         // authorization
56         if (msg.sender != manager){
57             // throw;
58             return sha3("not authorized"); //
59             // <- is 'bytes32' too:
60             // "0x8aed0440c9cacb4460ecdd12f6aff03c27cace39666d71f0946a6f3e9022a4a1"
61         }
62 
63         // chech if exists
64         if (sha256Docs[sha256(_docText)].docIndex > 0){
65             // throw;
66             return sha3("text already exists"); //
67             // <- is 'bytes32' too:
68             // "0xd42b321cfeadc9593d0a28c4d013aaad8e8c68fc8e0450aa419a130a53175137"
69         }
70         // document number
71         docIndex = docIndex + 1;
72         // add document data:
73         indexedDocs[docIndex] = Doc(docIndex,
74                                     _publisher,
75                                     now,
76                                     block.number,
77                                     _docText,
78                                     sha256(_docText),
79                                     sha3(_docText)
80                                     );
81         sha256Docs[sha256(_docText)] = indexedDocs[docIndex];
82         sha3Docs[sha3(_docText)]   = indexedDocs[docIndex];
83         // add event
84         DocumentAdded(indexedDocs[docIndex].docIndex,
85                       indexedDocs[docIndex].publisher,
86                       indexedDocs[docIndex].publishedOnUnixTime
87                       );
88         // return sha3 of the stored document
89         // (sha3 is better for in web3.js)
90         return indexedDocs[docIndex].sha3Hash;
91     }
92 
93     /* ---- Utilities: */
94 
95     function () {
96         // This function gets executed if a
97         // transaction with invalid data is sent to
98         // the contract or just ether without data.
99         // We revert the send so that no-one
100         // accidentally loses money when using the
101         // contract.
102         throw;
103     }
104 
105 }