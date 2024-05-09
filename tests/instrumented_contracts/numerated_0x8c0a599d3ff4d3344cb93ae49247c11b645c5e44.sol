1 pragma solidity ^0.4.1;
2 
3 contract FipsNotary {
4 
5     address admin;
6     mapping(bytes20 => address) ledger;
7     mapping(address => bool) registrants;
8 
9     event FipsData(bytes20 indexed fips, address indexed publisher, bytes data);
10     event FipsRegistration(bytes20 indexed fips, address indexed owner);
11     event FipsTransfer(bytes20 indexed fips, address indexed old_owner, address indexed new_owner);
12     event RegistrantApproval(address indexed registrant);
13     event RegistrantRemoval(address indexed registrant);
14 
15     modifier onlyAdmin() {
16         if (msg.sender != admin) throw;
17         _
18         ;
19     }
20 
21     function() {
22         throw;
23     }
24 
25     function FipsNotary() {
26         admin = msg.sender;
27         registrantApprove(admin);
28     }
29 
30     function fipsIsRegistered(bytes20 fips) constant returns (bool exists) {
31         return (ledger[fips] != 0x0) ? true : false;
32     }
33 
34     function fipsOwner(bytes20 fips) constant returns (address owner) {
35         return ledger[fips];
36     }
37 
38     function fipsPublishData(bytes20 fips, bytes data) {
39         if ((msg.sender == admin) || (msg.sender == ledger[fips])) {
40             FipsData(fips, msg.sender, data);
41         }
42     }
43 
44     function fipsPublishDataMulti(bytes20[] fips, bytes data) {
45         for (uint i = 0; i < fips.length; i++) {
46             fipsPublishData(fips[i], data);
47         }
48     }
49 
50     function fipsAddToLedger(bytes20 fips, address owner, bytes data) internal {
51         if (!fipsIsRegistered(fips)) {
52             ledger[fips] = owner;
53             FipsRegistration(fips, owner);
54             if (data.length > 0) {
55                 FipsData(fips, owner, data);
56             }
57         }
58     }
59 
60     function fipsGenerate() internal returns (bytes20 fips) {
61         fips = ripemd160(block.blockhash(block.number), sha256(msg.sender, block.number, block.timestamp, msg.gas));
62         if (fipsIsRegistered(fips)) {
63             return fipsGenerate();
64         }
65         return fips;
66     }
67 
68     function fipsLegacyRegister(bytes20 fips, address owner, bytes data) {
69         if (registrants[msg.sender] == true) {
70             fipsAddToLedger(fips, owner, data);
71         }
72     }
73 
74     function fipsLegacyRegisterMulti(bytes20[] fips, address owner, bytes data) {
75         if (registrants[msg.sender] == true) {
76             for (uint i = 0; i < fips.length; i++) {
77                 fipsAddToLedger(fips[i], owner, data);
78             }
79         }
80     }
81 
82     function fipsRegister(address owner, bytes data) {
83         if (registrants[msg.sender] == true) {
84             fipsAddToLedger(fipsGenerate(), owner, data);
85         }
86     }
87 
88     function fipsRegisterMulti(uint count, address owner, bytes data) {
89         if (registrants[msg.sender] == true) {
90             if ((count > 0) && (count <= 100)) {
91                 for (uint i = 0; i < count; i++) {
92                     fipsAddToLedger(fipsGenerate(), owner, data);
93                 }
94             }
95         }
96     }
97 
98     function fipsTransfer(bytes20 fips, address new_owner) {
99         if (fipsOwner(fips) == msg.sender) {
100             ledger[fips] = new_owner;
101             FipsTransfer(fips, msg.sender, new_owner);
102         }
103     }
104 
105     function fipsTransferMulti(bytes20[] fips, address new_owner) {
106         for (uint i = 0; i < fips.length; i++) {
107             fipsTransfer(fips[i], new_owner);
108         }
109     }
110 
111     function registrantApprove(address registrant) onlyAdmin {
112         if (registrants[registrant] != true) {
113             registrants[registrant] = true;
114             RegistrantApproval(registrant);
115         }
116     }
117 
118     function registrantRemove(address registrant) onlyAdmin {
119         if (registrants[registrant] == true) {
120             delete(registrants[registrant]);
121             RegistrantRemoval(registrant);
122         }
123     }
124 
125     function withdrawFunds() onlyAdmin {
126         if (!admin.send(this.balance)) {
127             throw;
128         }
129     }
130 
131 }