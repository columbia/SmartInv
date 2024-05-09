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
15     function FipsNotary() {
16         admin = msg.sender;
17         registrantApprove(admin);
18         fipsNotaryLegacy68b4();
19     }
20 
21     function fipsNotaryLegacy68b4() internal {
22         fipsAddToLedger(0x8b8cbda1197a64c5224f987221ca694e921307a1, 0x087520b1cd9ccb9a8badd0565698be2cd5117d5c);
23         fipsAddToLedger(0xf770f3a6ff43a619e5ad2ec1440899c7c1f9a31d, 0x087520b1cd9ccb9a8badd0565698be2cd5117d5c);
24         fipsAddToLedger(0x63a6bb10860f4366f5cd039808ae1a056017bb16, 0x087520b1cd9ccb9a8badd0565698be2cd5117d5c);
25         fipsAddToLedger(0x3cf83fd0c83a575b8c8a1fa8e205f81f5937327a, 0x087520b1cd9ccb9a8badd0565698be2cd5117d5c);
26         fipsAddToLedger(0xcd08a58a9138e8fa7a1eb393f0ca7a0a535371f3, 0x087520b1cd9ccb9a8badd0565698be2cd5117d5c);
27         fipsAddToLedger(0x1edb330494e92f1a2072062f864ed158f935aa0d, 0x087520b1cd9ccb9a8badd0565698be2cd5117d5c);
28         fipsAddToLedger(0xb5cc3ca04e6952e8edd01b3c22b19a5cc8296ce0, 0x087520b1cd9ccb9a8badd0565698be2cd5117d5c);
29         fipsAddToLedger(0xf6b7c86b6045fed17e4d2378d045c6d45d31f428, 0x087520b1cd9ccb9a8badd0565698be2cd5117d5c);
30         fipsAddToLedger(0x80653be4bab57d100722f6294d6d7b0b2f318627, 0x087520b1cd9ccb9a8badd0565698be2cd5117d5c);
31         fipsAddToLedger(0x401d035db4274112f7ed25dd698c0f8302afe939, 0x087520b1cd9ccb9a8badd0565698be2cd5117d5c);
32         fipsAddToLedger(0xc007a3bf3ce32145d36c4d016ca4b552bb31050d, 0x8ae53d7d3881ded6644245f91e996c140ea1a716);
33         fipsAddToLedger(0x44fa23d01a4b2f990b7a5c0c21ca48fb9cfcaecf, 0x087520b1cd9ccb9a8badd0565698be2cd5117d5c);
34         fipsAddToLedger(0x5379f06755cdfffc4acf4c7c62ed03280515ef97, 0x087520b1cd9ccb9a8badd0565698be2cd5117d5c);
35         registrantApprove(0x8ae53d7d3881ded6644245f91e996c140ea1a716);
36     }
37 
38     modifier onlyAdmin() {
39         if (msg.sender != admin) throw;
40         _
41         ;
42     }
43 
44     function() {
45         throw;
46     }
47 
48     function fipsIsRegistered(bytes20 fips) constant returns (bool exists) {
49         if (ledger[fips] != 0x0) {
50             return true;
51         } else {
52             return false;
53         }
54     }
55 
56     function fipsOwner(bytes20 fips) constant returns (address owner) {
57         return ledger[fips];
58     }
59 
60     function fipsPublishData(bytes20 fips, bytes data) constant {
61         if ((msg.sender != admin) && (msg.sender != ledger[fips])) {
62             throw;
63         }
64         FipsData(fips, msg.sender, data);
65     }
66 
67     function fipsAddToLedger(bytes20 fips, address owner) internal {
68         ledger[fips] = owner;
69         FipsRegistration(fips, owner);
70     }
71 
72     function fipsChangeOwner(bytes20 fips, address old_owner, address new_owner) internal {
73         ledger[fips] = new_owner;
74         FipsTransfer(fips, old_owner, new_owner);
75     }
76 
77     function fipsGenerate() internal returns (bytes20 fips) {
78         fips = ripemd160(block.blockhash(block.number), sha256(msg.sender, block.number, block.timestamp, msg.gas));
79         if (fipsIsRegistered(fips)) {
80             return fipsGenerate();
81         }
82         return fips;
83     }
84 
85     function fipsRegister(uint count, address owner, bytes data) {
86         if (registrants[msg.sender] != true) {
87             throw;
88         }
89         if ((count < 1) || (count > 1000)) {
90             throw;
91         }
92         bytes20 fips;
93         for (uint i = 1; i <= count; i++) {
94             fips = fipsGenerate();
95             fipsAddToLedger(fips, owner);
96             if (data.length > 0) {
97                 FipsData(fips, owner, data);
98             }
99         }
100     }
101 
102     function fipsRegister() { fipsRegister(1, msg.sender, ""); }
103     function fipsRegister(uint count) { fipsRegister(count, msg.sender, ""); }
104     function fipsRegister(uint count, bytes data) { fipsRegister(count, msg.sender, data); }
105     function fipsRegister(address owner) { fipsRegister(1, owner, ""); }
106     function fipsRegister(address owner, bytes data) { fipsRegister(1, owner, data); }
107 
108     function fipsTransfer(bytes20 fips, address new_owner) {
109         if (msg.sender != ledger[fips]) {
110             throw;
111         }
112         fipsChangeOwner(fips, msg.sender, new_owner);
113     }
114 
115     function registrantApprove(address registrant) onlyAdmin {
116         if (registrants[registrant] != true) {
117             registrants[registrant] = true;
118             RegistrantApproval(registrant);
119         }
120     }
121 
122     function registrantRemove(address registrant) onlyAdmin {
123         if (registrants[registrant] == true) {
124             delete(registrants[registrant]);
125             RegistrantRemoval(registrant);
126         }
127     }
128 
129     function withdrawFunds() onlyAdmin {
130         if (!admin.send(this.balance)) {
131             throw;
132         }
133     }
134 
135 }