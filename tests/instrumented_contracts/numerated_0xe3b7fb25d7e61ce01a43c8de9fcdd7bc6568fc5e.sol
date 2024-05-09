1 pragma solidity ^0.4.2;
2 
3 contract OwnedI {
4     event LogOwnerChanged(address indexed previousOwner, address indexed newOwner);
5 
6     function getOwner()
7         constant
8         returns (address);
9 
10     function setOwner(address newOwner)
11         returns (bool success); 
12 }
13 
14 contract Owned is OwnedI {
15     /**
16      * @dev Made private to protect against child contract setting it to 0 by mistake.
17      */
18     address private owner;
19 
20     function Owned() {
21         owner = msg.sender;
22     }
23 
24     modifier fromOwner {
25         if (msg.sender != owner) {
26             throw;
27         }
28         _;
29     }
30 
31     function getOwner()
32         constant
33         returns (address) {
34         return owner;
35     }
36 
37     function setOwner(address newOwner)
38         fromOwner 
39         returns (bool success) {
40         if (newOwner == 0) {
41             throw;
42         }
43         if (owner != newOwner) {
44             LogOwnerChanged(owner, newOwner);
45             owner = newOwner;
46         }
47         success = true;
48     }
49 }
50 
51 contract PullPaymentCapable {
52     uint256 private totalBalance;
53     mapping(address => uint256) private payments;
54 
55     event LogPaymentReceived(address indexed dest, uint256 amount);
56 
57     function PullPaymentCapable() {
58         if (0 < this.balance) {
59             asyncSend(msg.sender, this.balance);
60         }
61     }
62 
63     // store sent amount as credit to be pulled, called by payer
64     function asyncSend(address dest, uint256 amount) internal {
65         if (amount > 0) {
66             totalBalance += amount;
67             payments[dest] += amount;
68             LogPaymentReceived(dest, amount);
69         }
70     }
71 
72     function getTotalBalance()
73         constant
74         returns (uint256) {
75         return totalBalance;
76     }
77 
78     function getPaymentOf(address beneficiary) 
79         constant
80         returns (uint256) {
81         return payments[beneficiary];
82     }
83 
84     // withdraw accumulated balance, called by payee
85     function withdrawPayments()
86         external 
87         returns (bool success) {
88         uint256 payment = payments[msg.sender];
89         payments[msg.sender] = 0;
90         totalBalance -= payment;
91         if (!msg.sender.call.value(payment)()) {
92             throw;
93         }
94         success = true;
95     }
96 
97     function fixBalance()
98         returns (bool success);
99 
100     function fixBalanceInternal(address dest)
101         internal
102         returns (bool success) {
103         if (totalBalance < this.balance) {
104             uint256 amount = this.balance - totalBalance;
105             payments[dest] += amount;
106             LogPaymentReceived(dest, amount);
107         }
108         return true;
109     }
110 }
111 
112 contract WithBeneficiary is Owned {
113     /**
114      * @notice Address that is forwarded all value.
115      * @dev Made private to protect against child contract setting it to 0 by mistake.
116      */
117     address private beneficiary;
118     
119     event LogBeneficiarySet(address indexed previousBeneficiary, address indexed newBeneficiary);
120 
121     function WithBeneficiary(address _beneficiary) payable {
122         if (_beneficiary == 0) {
123             throw;
124         }
125         beneficiary = _beneficiary;
126         if (msg.value > 0) {
127             asyncSend(beneficiary, msg.value);
128         }
129     }
130 
131     function asyncSend(address dest, uint amount) internal;
132 
133     function getBeneficiary()
134         constant
135         returns (address) {
136         return beneficiary;
137     }
138 
139     function setBeneficiary(address newBeneficiary)
140         fromOwner 
141         returns (bool success) {
142         if (newBeneficiary == 0) {
143             throw;
144         }
145         if (beneficiary != newBeneficiary) {
146             LogBeneficiarySet(beneficiary, newBeneficiary);
147             beneficiary = newBeneficiary;
148         }
149         success = true;
150     }
151 
152     function () payable {
153         asyncSend(beneficiary, msg.value);
154     }
155 }
156 
157 contract CertificationCentreI {
158     event LogCertificationDbRegistered(address indexed db);
159 
160     event LogCertificationDbUnRegistered(address indexed db);
161 
162     function getCertificationDbCount()
163         constant
164         returns (uint);
165 
166     function getCertificationDbStatus(address db)
167         constant
168         returns (bool valid, uint256 index);
169 
170     function getCertificationDbAtIndex(uint256 index)
171         constant
172         returns (address db);
173 
174     function registerCertificationDb(address db)
175         returns (bool success);
176 
177     function unRegisterCertificationDb(address db)
178         returns (bool success);
179 }
180 
181 contract CertificationCentre is CertificationCentreI, WithBeneficiary, PullPaymentCapable {
182     struct CertificationDbStruct {
183         bool valid;
184         uint256 index;
185     }
186 
187     mapping (address => CertificationDbStruct) private certificationDbStatuses;
188     address[] private certificationDbs;
189 
190     function CertificationCentre(address beneficiary)
191         WithBeneficiary(beneficiary) {
192         if (msg.value > 0) {
193             throw;
194         }
195     }
196 
197     function getCertificationDbCount()
198         constant
199         returns (uint256) {
200         return certificationDbs.length;
201     }
202 
203     function getCertificationDbStatus(address db)
204         constant
205         returns (bool valid, uint256 index) {
206         CertificationDbStruct status = certificationDbStatuses[db];
207         return (status.valid, status.index);
208     }
209 
210     function getCertificationDbAtIndex(uint256 index)
211         constant
212         returns (address db) {
213         return certificationDbs[index];
214     }
215 
216     function registerCertificationDb(address db) 
217         fromOwner
218         returns (bool success) {
219         if (db == 0) {
220             throw;
221         }
222         if (!certificationDbStatuses[db].valid) {
223             certificationDbStatuses[db].valid = true;
224             certificationDbStatuses[db].index = certificationDbs.length;
225             certificationDbs.push(db);
226         }
227         LogCertificationDbRegistered(db);
228         success = true;
229     }
230 
231     function unRegisterCertificationDb(address db)
232         fromOwner
233         returns (bool success) {
234         if (certificationDbStatuses[db].valid) {
235             uint256 index = certificationDbStatuses[db].index;
236             certificationDbs[index] = certificationDbs[certificationDbs.length - 1];
237             certificationDbStatuses[certificationDbs[index]].index = index;
238             delete certificationDbStatuses[db];
239             certificationDbs.length--;
240         }
241         LogCertificationDbUnRegistered(db);
242         success = true;
243     }
244 
245     function fixBalance()
246         returns (bool success) {
247         return fixBalanceInternal(getBeneficiary());
248     }
249 }