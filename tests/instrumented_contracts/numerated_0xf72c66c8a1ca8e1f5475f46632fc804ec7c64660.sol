1 pragma solidity ^0.4.17;
2 
3 contract ERC20 {
4     uint public totalSupply;
5     function balanceOf(address who) public constant returns (uint);
6     function allowance(address owner, address spender) public constant returns (uint);
7 
8     function transfer(address to, uint value) public returns (bool ok);
9     function transferFrom(address from, address to, uint value) public returns (bool ok);
10     function approve(address spender, uint value) public returns (bool ok);
11     event Transfer(address indexed from, address indexed to, uint value);
12     event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 contract Authority {
16     function isValidAuthority(address authorityAddress, uint blockNumber) public view returns (bool);
17 }
18 
19 contract SafeMath {
20     function safeSub(uint a, uint b) pure internal returns (uint) {
21         sAssert(b <= a);
22         return a - b;
23     }
24 
25     function safeAdd(uint a, uint b) pure internal returns (uint) {
26         uint c = a + b;
27         sAssert(c>=a && c>=b);
28         return c;
29     }
30 
31     function sAssert(bool assertion) pure internal {
32         if (!assertion) {
33             revert();
34         }
35     }
36 }
37 
38 contract SingleSourceIdentity is SafeMath {
39     // Struct and enum
40     struct KYC {
41         bool verified;
42         address verifiedBy;
43         uint verifiedAt;
44         uint verifiedAttributes;
45     }
46 
47     // Instance variables
48     uint public verificationFee;
49     mapping(address => uint) public verificationFeeBalances;
50 
51     address public owner;
52     address public authorityContractAddress;
53     address public paymentContractAddress;
54     mapping(address => KYC) public records;
55 
56     // Modifier
57     modifier onlyOwner() {
58         if (msg.sender != owner) {
59             revert();
60         }
61         _;
62     }
63 
64     modifier onlyValidAuthority(address authorityAddress) {
65         if (!isValidAuthority(authorityAddress)) {
66             revert();
67         }
68 
69         _;
70     }
71 
72     modifier onlyAuthoritativeAuthority(address authorityAddress, address userAddress) {
73         // Verifier verification
74         KYC storage kycRecord = records[userAddress];
75         if (kycRecord.verifiedBy != 0x0 && kycRecord.verifiedBy != authorityAddress) {
76             if (isValidAuthority(kycRecord.verifiedBy)) {
77                 revert();
78             }
79         }
80 
81         _;
82     }
83 
84     // Internal
85     function isValidAuthority(address authorityAddress)
86       private
87       view
88       returns (bool)
89     {
90         Authority authority = Authority(authorityContractAddress);
91         return authority.isValidAuthority(authorityAddress, block.number);
92     }
93 
94     function chargeVerificationFee(address userAddress, address authorityAddress)
95       private
96       returns (bool)
97     {
98         if (!ERC20(paymentContractAddress).transferFrom(userAddress, this, verificationFee)) {
99             return false;
100         }
101         uint currentBalance = verificationFeeBalances[authorityAddress];
102         verificationFeeBalances[authorityAddress] = safeAdd(currentBalance, verificationFee);
103         return true;
104     }
105 
106     // Init
107     function SingleSourceIdentity()
108       public
109     {
110         owner = msg.sender;
111         verificationFee = 0 ether;
112     }
113 
114     // Admin
115     function setAuthorityContractAddress(address contractAddress)
116       public
117       onlyOwner()
118     {
119         authorityContractAddress = contractAddress;
120     }
121 
122     function setPaymentContractAddress(address contractAddress)
123       public
124       onlyOwner()
125     {
126         paymentContractAddress = contractAddress;
127     }
128 
129     function setFee(uint fee)
130       public
131       onlyOwner()
132     {
133         verificationFee = fee;
134     }
135 
136     function changeOwner(address newOwner)
137       public
138       onlyOwner()
139     {
140         owner = newOwner;
141     }
142 
143     function withdrawFee()
144       public
145       onlyValidAuthority(msg.sender)
146     {
147         require(paymentContractAddress != 0x0);
148 
149         uint balance = verificationFeeBalances[msg.sender];
150         require(balance > 0);
151 
152         verificationFeeBalances[msg.sender] = 0;
153         if (!ERC20(paymentContractAddress).transfer(msg.sender, balance)) {
154             revert();
155         }
156     }
157 
158     // Functions
159     function hasValidProfile(address userAddress)
160       public
161       view
162       returns (bool)
163     {
164         KYC storage kyc = records[userAddress];
165         if (kyc.verified) {
166             Authority authority = Authority(authorityContractAddress);
167             if (!authority.isValidAuthority(kyc.verifiedBy, kyc.verifiedAt)) {
168                 return false;
169             } else {
170                 return true;
171             }
172         } else {
173             return false;
174         }
175     }
176 
177     function hasVerifiedAttributeIndex(address userAddress, uint attributeIndex)
178       public
179       view
180       returns (bool)
181     {
182         if (!this.hasValidProfile(userAddress)) {
183             return false;
184         } else {
185             KYC storage kyc = records[userAddress];
186             uint attributeValue = 2 ** attributeIndex;
187             return ((kyc.verifiedAttributes & attributeValue) == attributeValue);
188         }
189     }
190 
191     function hasVerifiedAttributeValue(address userAddress, uint attributeValue)
192       public
193       view
194       returns (bool)
195     {
196         if (!this.hasValidProfile(userAddress)) {
197             return false;
198         } else {
199             KYC storage kyc = records[userAddress];
200             return ((kyc.verifiedAttributes & attributeValue) == attributeValue);
201         }
202     }
203 
204 
205     function verifiedAttributes(address userAddress)
206       public
207       view
208       returns (uint)
209     {
210         if (!this.hasValidProfile(userAddress)) {
211             return 0;
212         } else {
213             KYC storage kyc = records[userAddress];
214             return kyc.verifiedAttributes;
215         }
216     }
217 
218 
219     function claim(address verifier, uint verifiedAttributes, uint expires, uint8 v, bytes32 r, bytes32 s)
220       public
221       onlyValidAuthority(verifier)
222       onlyAuthoritativeAuthority(verifier, msg.sender)
223     {
224         // Payment
225         if (verificationFee > 0) {
226             if(!chargeVerificationFee(msg.sender, verifier)) {
227                 revert();
228             }
229         }
230 
231         // Signature verification
232         bytes32 hash = sha256(this, msg.sender, verifiedAttributes, expires);
233         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
234         bytes32 prefixedHash = keccak256(prefix, hash);
235 
236         if (!((ecrecover(prefixedHash, v, r, s) == verifier) && block.number <= expires)) {
237             revert();
238         }
239 
240         // Record
241 
242         KYC memory kyc = KYC({
243             verified: true,
244             verifiedBy: verifier,
245             verifiedAt: block.number,
246             verifiedAttributes: verifiedAttributes
247         });
248 
249         records[msg.sender] = kyc;
250     }
251 
252     function approve(address userAddress, uint verifiedAttributes)
253       public
254       onlyValidAuthority(msg.sender)
255       onlyAuthoritativeAuthority(msg.sender, userAddress)
256     {
257         // Record
258         KYC memory kyc = KYC({
259             verified: true,
260             verifiedBy: msg.sender,
261             verifiedAt: block.number,
262             verifiedAttributes: verifiedAttributes
263         });
264 
265         records[userAddress] = kyc;
266     }
267 
268     function revoke(address userAddress)
269       public
270       onlyValidAuthority(msg.sender)
271       onlyAuthoritativeAuthority(msg.sender, userAddress)
272     {
273         // Revoke
274         KYC memory kyc = KYC({
275             verified: false,
276             verifiedBy: msg.sender,
277             verifiedAt: block.number,
278             verifiedAttributes: 0
279         });
280 
281         records[userAddress] = kyc;
282     }
283 }