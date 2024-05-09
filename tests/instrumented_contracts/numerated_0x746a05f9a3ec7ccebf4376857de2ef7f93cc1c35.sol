1 pragma solidity ^0.6.0;
2 pragma experimental ABIEncoderV2;
3 // version 1.14
4 
5 contract ArtoryRecordStamper {
6     event Stamped(bytes32 dataHash);
7     event StampedRecord(bytes32 dataHash, string recordID);
8 
9     // Indexed strings are hashed to keep data of consistent length for searching, so partner is given twice,
10     // once as a plain parameter and once as an indexed parameter
11     event StampedPartnerRecord(bytes32 dataHash, string recordID, string partner, string indexed indexedPartner);
12 
13     event Message(string message);
14 
15     address private _owner;
16     constructor() public {
17         _owner = msg.sender;
18     }
19 
20     modifier onlyOwner {
21         require(
22             msg.sender == _owner,
23             "Sender not authorized"
24         );
25         _;
26     }
27 
28     function stamp(bytes32 dataHash)
29         public
30         onlyOwner
31     {
32         emit Stamped(dataHash);
33     }
34 
35     function stamp_array(bytes32[] memory dataHashes)
36         public
37         onlyOwner
38     {
39         require(dataHashes.length <= 255, "Stamps per transaction limited to 255");
40 
41         for (uint i = 0; i < dataHashes.length; i++) {
42             emit Stamped(dataHashes[i]);
43         }
44     }
45 
46     function stamp_record(bytes32 dataHash, string memory recordID)
47         public
48         onlyOwner
49     {
50         emit StampedRecord(dataHash, recordID);
51     }
52 
53     function stamp_record_array(bytes32[] memory dataHashes, string[] memory recordIDs)
54         public
55         onlyOwner
56     {
57         require(
58             dataHashes.length <= 255,
59             "Stamps per transaction limited to 255"
60         );
61 
62         require(
63             dataHashes.length == recordIDs.length,
64             "Number of recordsIDs must match number of dataHashes"
65         );
66 
67         for (uint i = 0; i < dataHashes.length; i++) {
68             emit StampedRecord(dataHashes[i], recordIDs[i]);
69         }
70     }
71 
72     function stamp_partner_record(bytes32 dataHash, string memory recordID, string memory partner)
73         public
74         onlyOwner
75     {
76         emit StampedPartnerRecord(dataHash, recordID, partner, partner);
77     }
78 
79     function stamp_partner_record_array(bytes32[] memory dataHashes, string[] memory recordIDs, string[] memory partners)
80         public
81         onlyOwner
82     {
83         require(
84             dataHashes.length <= 255,
85             "Stamps per transaction limited to 255"
86         );
87 
88         require(
89             dataHashes.length == recordIDs.length,
90             "Number of recordsIDs must match number of dataHashes"
91         );
92 
93         require(
94             dataHashes.length == partners.length,
95             "Number of partners must match number of dataHashes"
96         );
97 
98         for (uint i = 0; i < dataHashes.length; i++) {
99             emit StampedPartnerRecord(dataHashes[i], recordIDs[i], partners[i], partners[i]);
100         }
101     }
102 
103     function broadcast_message(string memory str)
104         public
105         onlyOwner
106     {
107         require(
108             bytes(str).length <= 128,
109             "Message must be shorter than 128 characters"
110         );
111         emit Message(str);
112     }
113 }