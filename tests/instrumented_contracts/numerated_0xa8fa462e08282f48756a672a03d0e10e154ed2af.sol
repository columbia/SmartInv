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
39         if ((msg.sender != admin) && (msg.sender != ledger[fips])) {
40             throw;
41         }
42         FipsData(fips, msg.sender, data);
43     }
44 
45     function fipsAddToLedger(bytes20 fips, address owner) internal {
46         if (fipsIsRegistered(fips)) {
47             throw;
48         }
49         ledger[fips] = owner;
50         FipsRegistration(fips, owner);
51     }
52 
53     function fipsChangeOwner(bytes20 fips, address old_owner, address new_owner) internal {
54         if (!fipsIsRegistered(fips)) {
55             throw;
56         }
57         ledger[fips] = new_owner;
58         FipsTransfer(fips, old_owner, new_owner);
59     }
60 
61     function fipsGenerate() internal returns (bytes20 fips) {
62         fips = ripemd160(block.blockhash(block.number), sha256(msg.sender, block.number, block.timestamp, msg.gas));
63         if (fipsIsRegistered(fips)) {
64             return fipsGenerate();
65         }
66         return fips;
67     }
68 
69     function fipsLegacyRegister(bytes20[] fips, address owner) {
70         if (registrants[msg.sender] != true) {
71             throw;
72         }
73         for (uint i = 0; i < fips.length; i++) {
74             fipsAddToLedger(fips[i], owner);
75         }
76     }
77 
78     function fipsRegister(uint count, address owner, bytes data) {
79         if (registrants[msg.sender] != true) {
80             throw;
81         }
82         if ((count < 1) || (count > 100)) {
83             throw;
84         }
85         bytes20 fips;
86         for (uint i = 1; i <= count; i++) {
87             fips = fipsGenerate();
88             fipsAddToLedger(fips, owner);
89             if (data.length > 0) {
90                 FipsData(fips, owner, data);
91             }
92         }
93     }
94 
95     function fipsTransfer(bytes20 fips, address new_owner) {
96         if (msg.sender != ledger[fips]) {
97             throw;
98         }
99         fipsChangeOwner(fips, msg.sender, new_owner);
100     }
101 
102     function registrantApprove(address registrant) onlyAdmin {
103         if (registrants[registrant] != true) {
104             registrants[registrant] = true;
105             RegistrantApproval(registrant);
106         }
107     }
108 
109     function registrantRemove(address registrant) onlyAdmin {
110         if (registrants[registrant] == true) {
111             delete(registrants[registrant]);
112             RegistrantRemoval(registrant);
113         }
114     }
115 
116     function withdrawFunds() onlyAdmin {
117         if (!admin.send(this.balance)) {
118             throw;
119         }
120     }
121 
122 }