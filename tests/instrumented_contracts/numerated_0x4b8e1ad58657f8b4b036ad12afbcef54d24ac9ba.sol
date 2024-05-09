1 contract BasicSign {
2 
3     event Created(
4         address indexed from,
5         uint256 id
6     );
7     event Signed(
8         address indexed from,
9         uint256 docId,
10         uint8 singId,
11         bytes16 signType,
12         bytes sign
13     );
14 
15     address owner;
16     mapping (uint256 => Document) public documents;
17 
18     struct Document {
19         address organizer;
20         Sign[] signs;
21     }
22 
23     struct Sign {
24         address signer;
25         bytes16 signType;
26         bytes   sign;
27     }
28 
29     function SimpleSign() {
30         owner = msg.sender;
31     }
32 
33     function createDocument(uint256 nonce) returns (uint256 docId) {
34         docId = generateId(nonce);
35         if (documents[docId].organizer != 0) throw;
36         documents[docId].organizer = msg.sender;
37         Created(msg.sender, docId);
38     }
39 
40     function removeDocument(uint256 docId) {
41         Document doc = documents[docId];
42         if (doc.organizer != msg.sender) throw;
43         delete documents[docId];
44     }
45 
46     function addSignature(uint256 docId, bytes16 _type, bytes _sign) {
47         Document doc = documents[docId];
48         if (doc.organizer != msg.sender) throw;
49         if (doc.signs.length >= 0xFF) throw;
50         uint idx = doc.signs.push(Sign(msg.sender, _type, _sign));
51         Signed(msg.sender, docId, uint8(idx), _type, _sign);
52     }
53 
54     function getDocumentDetails(uint256 docId) returns (address organizer, uint count) {
55         Document doc = documents[docId];
56         organizer = doc.organizer;
57         count = doc.signs.length;
58     }
59 
60     function getSignsCount(uint256 docId) returns (uint) {
61         return documents[docId].signs.length;
62     }
63 
64     function getSignDetails(uint256 docId, uint8 signId) returns (address, bytes16) {
65         Document doc = documents[docId];
66         Sign s = doc.signs[signId];
67         return (s.signer, s.signType);
68     }
69 
70     function getSignData(uint256 docId, uint8 signId) returns (bytes) {
71         Document doc = documents[docId];
72         Sign s = doc.signs[signId];
73         return s.sign;
74     }
75 
76     function generateId(uint256 nonce) returns (uint256) {
77         return uint256(sha3(msg.sender, nonce));
78     }
79 
80     function () {
81         throw;
82     }
83 
84 }