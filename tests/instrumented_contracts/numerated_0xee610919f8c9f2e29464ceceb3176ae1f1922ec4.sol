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
39     // Events
40     event IdentityApproval(address indexed authority, address indexed walletAddress, uint verifiedAttributes);
41     event IdentityRevoke(address indexed authority, address indexed walletAddress);
42 
43     // Struct and enum
44     struct KYC {
45         bool verified;
46         address verifiedBy;
47         uint verifiedAt;
48         uint verifiedAttributes;
49     }
50 
51     // Instance variables
52     uint public verificationFee;
53     mapping(address => uint) public verificationFeeBalances;
54 
55     address public owner;
56     address public authorityContractAddress;
57     address public paymentContractAddress;
58     mapping(address => KYC) public records;
59 
60     // Modifier
61     modifier onlyOwner() {
62         if (msg.sender != owner) {
63             revert();
64         }
65         _;
66     }
67 
68     modifier onlyValidAuthority(address authorityAddress) {
69         if (!isValidAuthority(authorityAddress)) {
70             revert();
71         }
72 
73         _;
74     }
75 
76     modifier onlyAuthoritativeAuthority(address authorityAddress, address userAddress) {
77         // Verifier verification
78         KYC storage kycRecord = records[userAddress];
79         if (kycRecord.verifiedBy != 0x0 && kycRecord.verifiedBy != authorityAddress) {
80             if (isValidAuthority(kycRecord.verifiedBy)) {
81                 revert();
82             }
83         }
84 
85         _;
86     }
87 
88     // Internal
89     function isValidAuthority(address authorityAddress)
90       private
91       view
92       returns (bool)
93     {
94         Authority authority = Authority(authorityContractAddress);
95         return authority.isValidAuthority(authorityAddress, block.number);
96     }
97 
98     function chargeVerificationFee(address userAddress, address authorityAddress)
99       private
100       returns (bool)
101     {
102         if (!ERC20(paymentContractAddress).transferFrom(userAddress, this, verificationFee)) {
103             return false;
104         }
105         uint currentBalance = verificationFeeBalances[authorityAddress];
106         verificationFeeBalances[authorityAddress] = safeAdd(currentBalance, verificationFee);
107         return true;
108     }
109 
110     // Init
111     function SingleSourceIdentity()
112       public
113     {
114         owner = msg.sender;
115         verificationFee = 0 ether;
116     }
117 
118     // Admin
119     function setAuthorityContractAddress(address contractAddress)
120       public
121       onlyOwner()
122     {
123         authorityContractAddress = contractAddress;
124     }
125 
126     function setPaymentContractAddress(address contractAddress)
127       public
128       onlyOwner()
129     {
130         paymentContractAddress = contractAddress;
131     }
132 
133     function setFee(uint fee)
134       public
135       onlyOwner()
136     {
137         verificationFee = fee;
138     }
139 
140     function changeOwner(address newOwner)
141       public
142       onlyOwner()
143     {
144         owner = newOwner;
145     }
146 
147     function withdrawFee()
148       public
149       onlyValidAuthority(msg.sender)
150     {
151         require(paymentContractAddress != 0x0);
152 
153         uint balance = verificationFeeBalances[msg.sender];
154         require(balance > 0);
155 
156         verificationFeeBalances[msg.sender] = 0;
157         if (!ERC20(paymentContractAddress).transfer(msg.sender, balance)) {
158             revert();
159         }
160     }
161 
162     // Functions
163     function hasValidProfile(address userAddress)
164       public
165       view
166       returns (bool)
167     {
168         KYC storage kyc = records[userAddress];
169         if (kyc.verified) {
170             Authority authority = Authority(authorityContractAddress);
171             if (!authority.isValidAuthority(kyc.verifiedBy, kyc.verifiedAt)) {
172                 return false;
173             } else {
174                 return true;
175             }
176         } else {
177             return false;
178         }
179     }
180 
181     function hasVerifiedAttributeIndex(address userAddress, uint attributeIndex)
182       public
183       view
184       returns (bool)
185     {
186         if (!this.hasValidProfile(userAddress)) {
187             return false;
188         } else {
189             KYC storage kyc = records[userAddress];
190             uint attributeValue = 2 ** attributeIndex;
191             return ((kyc.verifiedAttributes & attributeValue) == attributeValue);
192         }
193     }
194 
195     function hasVerifiedAttributeValue(address userAddress, uint attributeValue)
196       public
197       view
198       returns (bool)
199     {
200         if (!this.hasValidProfile(userAddress)) {
201             return false;
202         } else {
203             KYC storage kyc = records[userAddress];
204             return ((kyc.verifiedAttributes & attributeValue) == attributeValue);
205         }
206     }
207 
208 
209     function verifiedAttributes(address userAddress)
210       public
211       view
212       returns (uint)
213     {
214         if (!this.hasValidProfile(userAddress)) {
215             return 0;
216         } else {
217             KYC storage kyc = records[userAddress];
218             return kyc.verifiedAttributes;
219         }
220     }
221 
222 
223     function claim(address verifier, uint verifiedAttributes, uint expires, uint8 v, bytes32 r, bytes32 s)
224       public
225       onlyValidAuthority(verifier)
226       onlyAuthoritativeAuthority(verifier, msg.sender)
227     {
228         // Payment
229         if (verificationFee > 0) {
230             if(!chargeVerificationFee(msg.sender, verifier)) {
231                 revert();
232             }
233         }
234 
235         // Signature verification
236         bytes32 hash = sha256(this, msg.sender, verifiedAttributes, expires);
237         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
238         bytes32 prefixedHash = keccak256(prefix, hash);
239 
240         if (!((ecrecover(prefixedHash, v, r, s) == verifier) && block.number <= expires)) {
241             revert();
242         }
243 
244         // Record
245 
246         KYC memory kyc = KYC({
247             verified: true,
248             verifiedBy: verifier,
249             verifiedAt: block.number,
250             verifiedAttributes: verifiedAttributes
251         });
252 
253         records[msg.sender] = kyc;
254 
255         emit IdentityApproval(verifier, msg.sender, verifiedAttributes);
256     }
257 
258     function approve(address userAddress, uint verifiedAttributes)
259       public
260       onlyValidAuthority(msg.sender)
261       onlyAuthoritativeAuthority(msg.sender, userAddress)
262     {
263         // Record
264         KYC memory kyc = KYC({
265             verified: true,
266             verifiedBy: msg.sender,
267             verifiedAt: block.number,
268             verifiedAttributes: verifiedAttributes
269         });
270 
271         records[userAddress] = kyc;
272 
273         emit IdentityApproval(msg.sender, userAddress, verifiedAttributes);
274     }
275 
276     function revoke(address userAddress)
277       public
278       onlyValidAuthority(msg.sender)
279       onlyAuthoritativeAuthority(msg.sender, userAddress)
280     {
281         // Revoke
282         KYC memory kyc = KYC({
283             verified: false,
284             verifiedBy: msg.sender,
285             verifiedAt: block.number,
286             verifiedAttributes: 0
287         });
288 
289         records[userAddress] = kyc;
290 
291         emit IdentityRevoke(msg.sender, userAddress);
292     }
293 }