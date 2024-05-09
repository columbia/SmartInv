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
123         if (msg.value > 0) {
124             throw;
125         }
126     }
127 
128     function addCertifier(address certifier)
129         fromOwner
130         returns (bool success) {
131         if (certifier == 0) {
132             throw;
133         }
134         if (!certifierStatuses[certifier].authorised) {
135             certifierStatuses[certifier].authorised = true;
136             certifierStatuses[certifier].index = certifiers.length;
137             certifiers.push(certifier);
138             LogCertifierAdded(certifier);
139         }
140         success = true;
141     }
142 
143     function removeCertifier(address certifier)
144         fromOwner
145         returns (bool success) {
146         if (!certifierStatuses[certifier].authorised) {
147             throw;
148         }
149         // Let's move the last array item into the one we remove.
150         uint256 index = certifierStatuses[certifier].index;
151         certifiers[index] = certifiers[certifiers.length - 1];
152         certifierStatuses[certifiers[index]].index = index;
153         certifiers.length--;
154         delete certifierStatuses[certifier];
155         LogCertifierRemoved(certifier);
156         success = true;
157     }
158 
159     function getCertifiersCount()
160         constant
161         returns (uint256 count) {
162         count = certifiers.length;
163     }
164 
165     function getCertifierStatus(address certifierAddr)
166         constant 
167         returns (bool authorised, uint256 index) {
168         Certifier certifier = certifierStatuses[certifierAddr];
169         return (certifier.authorised,
170             certifier.index);
171     }
172 
173     function getCertifierAtIndex(uint256 index)
174         constant
175         returns (address) {
176         return certifiers[index];
177     }
178 
179     function isCertifier(address certifier)
180         constant
181         returns (bool isIndeed) {
182         isIndeed = certifierStatuses[certifier].authorised;
183     }
184 }