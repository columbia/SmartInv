1 pragma solidity ^0.4.2;
2 
3 /**
4  * @notice Declares a contract that can have an owner.
5  */
6 contract OwnedI {
7     event LogOwnerChanged(address indexed previousOwner, address indexed newOwner);
8 
9     function getOwner()
10         constant
11         returns (address);
12 
13     function setOwner(address newOwner)
14         returns (bool success); 
15 }
16 
17 /**
18  * @notice Defines a contract that can have an owner.
19  */
20 contract Owned is OwnedI {
21     /**
22      * @dev Made private to protect against child contract setting it to 0 by mistake.
23      */
24     address private owner;
25 
26     function Owned() {
27         owner = msg.sender;
28     }
29 
30     modifier fromOwner {
31         if (msg.sender != owner) {
32             throw;
33         }
34         _;
35     }
36 
37     function getOwner()
38         constant
39         returns (address) {
40         return owner;
41     }
42 
43     function setOwner(address newOwner)
44         fromOwner 
45         returns (bool success) {
46         if (newOwner == 0) {
47             throw;
48         }
49         if (owner != newOwner) {
50             LogOwnerChanged(owner, newOwner);
51             owner = newOwner;
52         }
53         success = true;
54     }
55 }
56 
57 contract BalanceFixable is OwnedI {
58     function fixBalance() 
59         returns (bool success) {
60         if (!getOwner().send(this.balance)) {
61             throw;
62         }
63         return true;
64     }
65 }
66 
67 // @notice Interface for a certifier database
68 contract CertifierDbI {
69     event LogCertifierAdded(address indexed certifier);
70 
71     event LogCertifierRemoved(address indexed certifier);
72 
73     function addCertifier(address certifier)
74         returns (bool success);
75 
76     function removeCertifier(address certifier)
77         returns (bool success);
78 
79     function getCertifiersCount()
80         constant
81         returns (uint count);
82 
83     function getCertifierStatus(address certifierAddr)
84         constant 
85         returns (bool authorised, uint256 index);
86 
87     function getCertifierAtIndex(uint256 index)
88         constant
89         returns (address);
90 
91     function isCertifier(address certifier)
92         constant
93         returns (bool isIndeed);
94 }
95 
96 contract CertifierDb is Owned, CertifierDbI, BalanceFixable {
97     struct Certifier {
98         bool authorised;
99         /**
100          * @notice The index in the table at which this certifier can be found.
101          */
102         uint256 index;
103     }
104 
105     /**
106      * @notice Addresses of the account or contract that are entitled to certify students.
107      */
108     mapping(address => Certifier) private certifierStatuses;
109     
110     /**
111      * @notice The potentially long list of all certifiers.
112      */
113     address[] private certifiers;
114 
115     modifier fromCertifier {
116         if (!certifierStatuses[msg.sender].authorised) {
117             throw;
118         }
119         _;
120     }
121 
122     function CertifierDb() {
123     }
124 
125     function addCertifier(address certifier)
126         fromOwner
127         returns (bool success) {
128         if (certifier == 0) {
129             throw;
130         }
131         if (!certifierStatuses[certifier].authorised) {
132             certifierStatuses[certifier].authorised = true;
133             certifierStatuses[certifier].index = certifiers.length;
134             certifiers.push(certifier);
135             LogCertifierAdded(certifier);
136         }
137         success = true;
138     }
139 
140     function removeCertifier(address certifier)
141         fromOwner
142         returns (bool success) {
143         if (!certifierStatuses[certifier].authorised) {
144             throw;
145         }
146         // Let's move the last array item into the one we remove.
147         uint256 index = certifierStatuses[certifier].index;
148         certifiers[index] = certifiers[certifiers.length - 1];
149         certifierStatuses[certifiers[index]].index = index;
150         certifiers.length--;
151         delete certifierStatuses[certifier];
152         LogCertifierRemoved(certifier);
153         success = true;
154     }
155 
156     function getCertifiersCount()
157         constant
158         returns (uint256 count) {
159         count = certifiers.length;
160     }
161 
162     function getCertifierStatus(address certifierAddr)
163         constant 
164         returns (bool authorised, uint256 index) {
165         Certifier certifier = certifierStatuses[certifierAddr];
166         return (certifier.authorised,
167             certifier.index);
168     }
169 
170     function getCertifierAtIndex(uint256 index)
171         constant
172         returns (address) {
173         return certifiers[index];
174     }
175 
176     function isCertifier(address certifier)
177         constant
178         returns (bool isIndeed) {
179         isIndeed = certifierStatuses[certifier].authorised;
180     }
181 }