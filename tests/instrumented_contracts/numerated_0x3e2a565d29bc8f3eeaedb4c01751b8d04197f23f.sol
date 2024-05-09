1 pragma solidity ^0.6.11;
2 
3 //certo c063v200826 noima (c) all rights reserved 2020
4 
5 /// @title  A CertoProof Of  existence smartcontract
6 /// @author Mauro G. Cordioli ezlab
7 /// @notice Check the details at https://certo.legal/smartcontract/v63
8 contract ProofCertoChainContract {
9     int256 public constant Version = 0x6320082601;
10     address payable creator;
11     address payable owner;
12     mapping(bytes32 => uint256) private CertoLedgerTimestamp;
13     string public Description; //Contract Purpose
14 
15     modifier onlyBy(address _account) {
16         require(msg.sender == _account, "not allowed");
17         _;
18     }
19 
20     function setCreator(address payable _creator) public onlyBy(creator) {
21         creator = _creator;
22         emit EventSetCreator();
23     }
24 
25     function setOwner(address payable _owner) public onlyBy(creator) {
26         owner = _owner;
27         emit EventSetOwner();
28     }
29 
30     function setDescription(string memory _Description) public onlyBy(owner) {
31         Description = _Description;
32     }
33 
34     constructor(string memory _Description) public {
35         creator = msg.sender;
36         owner = msg.sender;
37 
38         Description = _Description;
39 
40         emit EventReady();
41     }
42 
43     /// @notice Notarize the hash emit block timestamp of the  block
44     /// @param hashproof The proof sha256 hash to timestamp
45     function NotarizeProofTimeStamp(bytes32 hashproof) public onlyBy(owner) {
46         uint256 ts = CertoLedgerTimestamp[hashproof];
47         if (ts == 0) {
48             ts = block.timestamp;
49             CertoLedgerTimestamp[hashproof] = ts;
50         }
51 
52         emit EventProof(hashproof, ts);
53     }
54 
55 
56     /// @notice Notarize both hashes  emit  block timestamp  with logged note
57     /// @param hashproof The proof  sha256 hash to timestamp
58     /// @param hashmeta  The metadata sha256 hash to timestamp
59     /// @param note  The note to be logged on the blokchain
60     function NotarizeProofMetaNoteTimeStamp(
61         bytes32 hashproof,
62         bytes32 hashmeta,
63         string memory note
64     ) public onlyBy(owner) {
65         uint256 tsproof = CertoLedgerTimestamp[hashproof];
66         if (tsproof == 0) {
67             tsproof = block.timestamp;
68             CertoLedgerTimestamp[hashproof] = tsproof;
69         }
70 
71         uint256 tsmeta = CertoLedgerTimestamp[hashmeta];
72         if (tsmeta == 0) {
73             tsmeta=block.timestamp;
74             CertoLedgerTimestamp[hashmeta] = tsmeta;
75         }
76 
77         emit EventProofMetaWithNote(hashproof, hashmeta, tsproof, tsmeta, note);
78     }
79 
80     /// @notice Notarize both hashes and emit  block timestamps   
81     /// @param hashproof The proof sha256 hash to timestamp
82     /// @param hashmeta The metadata sha256 hash to timestamp
83     function NotarizeProofMetaTimeStamp(bytes32 hashproof, bytes32 hashmeta)
84         public
85         onlyBy(owner)
86     {
87         uint256 tsproof = CertoLedgerTimestamp[hashproof];
88         if (tsproof == 0) {
89             tsproof = block.timestamp;
90             CertoLedgerTimestamp[hashproof] = tsproof;
91         }
92 
93         uint256 tsmeta = CertoLedgerTimestamp[hashmeta];
94         if (tsmeta == 0) {
95             tsmeta = block.timestamp;
96             CertoLedgerTimestamp[hashmeta] = tsmeta;
97         }
98 
99         emit EventProofMeta(hashproof, hashmeta, tsproof, tsmeta);
100     }
101 
102     /// @notice Notarize the hash emit   block timestamp  with  logged note
103     /// @param hashproof The sha256 hash to timestamp
104     /// @param note  The note to be logged on the blokchain
105     function NotarizeProofTimeStampWithNote(
106         bytes32 hashproof,
107         string memory note
108     ) public onlyBy(owner) {
109         uint256 ts = CertoLedgerTimestamp[hashproof];
110         if (ts == 0) {
111             ts = block.timestamp;
112             CertoLedgerTimestamp[hashproof] = ts;
113         }
114         emit EventProofWithNote(hashproof, ts, note);
115     }
116 
117     /// @notice check the hash  to verify the proof  emit  the block timestamp if ok  or zero if not.
118     /// @param hashproof The sha256 hash be checked
119     /// @return block timestamp if ok zero if not
120     function CheckProofTimeStampByHashReturnsNonZeroUnixEpochIFOk(
121         bytes32 hashproof
122     ) public view returns (uint256) {
123         return CertoLedgerTimestamp[hashproof];
124     }
125 
126     event EventProofMetaWithNote(
127         bytes32 hashproof,
128         bytes32 hashmeta,
129         uint256 tsproof,
130         uint256 tsmeta,
131         string note
132     ); // trace a note in the logs
133     event EventProofMeta(
134         bytes32 hashproof,
135         bytes32 hashmeta,
136         uint256 tsproof,
137         uint256 tsmeta
138     );
139     event EventProofWithNote(bytes32 hashproof, uint256 ts, string note); // trace a note in the logs
140     event EventProof(bytes32 hashproof, uint256 ts);
141     event EventSetOwner(); //invoked when creator changes owner
142     event EventSetCreator(); //invoked when creator changes creator
143     event EventReady(); //invoked when we have done the method action
144 }