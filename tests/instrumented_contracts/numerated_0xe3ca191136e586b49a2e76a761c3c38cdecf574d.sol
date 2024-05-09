1 /*
2 
3 DVIP Terms of Service
4 
5 By purchasing, using, and possessing the DVIP token you agree to be legally bound by these terms, which shall take effect immediately upon receipt of the token.
6 
7 1. Rights of DVIP holders: Each membership entitles the customer to ZERO transaction fees on all on-chain transfers of DC Assets, and ½ off fees for purchasing and redeeming DC Assets through Crypto Capital. DVIP also entitles the customer to discounts on select future DC services. These discounts only apply to the fees specified on the decentralized capital website. DC is not responsible for any fees charged by third parties including, but not limited to, dapps, exchanges, Crypto Capital, and Coinapult.
8 
9 2. DVIP membership rights expire on January 1st, 2020.
10 
11 3. Customers can purchase more than one membership, but only one membership can be active at a time for any one wallet. DVIP can only be purchased in whole number increments. Under no circumstances are members eligible for a refund on the DVIP purchase.
12 
13 4. DVIP tokens are not equity in Decentralized Capital and do not give holders any power over Decentralized Capital including, but not limited to, shareholder voting, a claim on assets, or input into how Decentralized Capital is governed and managed.
14 
15 5. Possession of the DVIP token operates as proof of membership, and  DVIP tokens can be transferred to any other wallet on Ethereum. If the DVIP token is transferred to a 3rd party, the membership benefits no longer pertain to the original party. In the event of a transfer, membership benefits will apply only AFTER a 24 hour incubation period; any withdrawal initiated prior to the end of this incubation period will be charged the standard transaction fee. DC reserves the right to adjust the duration of the incubation period; the incubation period will never be more than 7 days.
16 
17 6. DVIP membership benefits are only available to individual users. Platforms such as exchanges and dapps can hold DVIP, but the transaction fee discounts specified in section 1 will not apply.
18 
19 7. Membership benefits are executed via the DC smart contract system; the DC membership must be held in the wallet used for DC Asset transactions in order for the discounts to apply. No transaction fees will be waived for members who receive transactions using a wallet that does not hold their DVIP token.
20 
21 8. In the event of bankruptcy: DVIP is valid until January 1st, 2020. In the event that Decentralized Capital ceases operations, DVIP does not represent any claim on company assets nor does Decentralized Capital have any further commitment to holders of DVIP, such as a refund on the purchase of the DVIP.
22 
23 9. Future DVIP sales: 2500 DVIP have been created, and 2000 will be sold in the initial membership sale. The remaining 500 memberships will be used for marketing events, both leading up to and after the sale, as well as future sale on the open market to generate further revenue. DC reserves the right to create and sell more DVIP in the future, however the total amount of DVIP is capped at 10,000.
24 
25 10. Entire Agreement: The foregoing Membership Terms & Conditions contain the entire terms and agreements in connection with Member's participation in the DC service and no representations, inducements, promises or agreement, or otherwise, between DC and the Member not included herein, shall be of any force or effect. If any of the foregoing terms or provisions shall be invalid or unenforceable, the remaining terms and provisions hereof shall not be affected.
26 
27 11. This agreement shall be governed by and construed under, and the legal relations among the parties hereto shall be determined in accordance with the laws of the United Kingdom of Great Britain and Northern Ireland.
28 
29 */
30 
31 contract DVIP {
32   function transfer(address to, uint256 value) returns (bool success);
33 }
34 
35 contract Assertive {
36   function assert(bool assertion) {
37     if (!assertion) throw;
38   }
39 }
40 
41 contract Math is Assertive {
42   function safeMul(uint a, uint b) internal returns (uint) {
43     uint c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function safeSub(uint a, uint b) internal returns (uint) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function safeAdd(uint a, uint b) internal returns (uint) {
54     uint c = a + b;
55     assert(c>=a && c>=b);
56     return c;
57   }
58 }
59 
60 contract Owned is Assertive {
61   address public owner;
62   event SetOwner(address indexed previousOwner, address indexed newOwner);
63   function Owned () {
64     owner = msg.sender;
65   }
66   modifier onlyOwner {
67     assert(msg.sender == owner);
68     _
69   }
70   function setOwner(address newOwner) onlyOwner {
71     SetOwner(owner, newOwner);
72     owner = newOwner;
73   }
74 }
75 
76 contract MembershipVendor is Owned, Math {
77   event MembershipPurchase(address indexed from, uint256 indexed amount, uint256 indexed price);
78   event PropertySet(address indexed from, bytes32 indexed sig, bytes32 indexed args);
79   address public dvipAddress;
80   address public beneficiary;
81   uint256 public price;
82   string public tos;
83   string[] public terms;
84   function setToS(string _tos) onlyOwner returns (bool success) {
85     tos = _tos;
86     PropertySet(msg.sender, msg.sig, sha3(tos));
87     return true;
88   }
89   function pushTerm(string term) onlyOwner returns (bool success) {
90     terms.push(term);
91     PropertySet(msg.sender, msg.sig, sha3(term));
92     return true;
93   }
94   function setTerm(uint256 idx, string term) onlyOwner returns (bool success) {
95     terms[idx] = term;
96     PropertySet(msg.sender, msg.sig, sha3(idx, term));
97     return true;
98   }
99   function setBeneficiary(address addr) onlyOwner returns (bool success) {
100     beneficiary = addr;
101     PropertySet(msg.sender, msg.sig, bytes32(addr));
102     return true;
103   }
104   function withdraw(address addr, uint256 amt) onlyOwner returns (bool success) {
105     if (!addr.send(amt)) throw;
106     return true;
107   }
108   function setDVIP(address addr) onlyOwner returns (bool success) {
109     dvipAddress = addr;
110     PropertySet(msg.sender, msg.sig, bytes32(addr));
111     return true;
112   }
113   function setPrice(uint256 _price) onlyOwner returns (bool success) {
114     price = _price;
115     PropertySet(msg.sender, msg.sig, bytes32(_price));
116     return true;
117   }
118   function () {
119     if (msg.value < price) throw;
120     uint256 qty = msg.value / price;
121     uint256 val = safeMul(price, qty);
122     if (!DVIP(dvipAddress).transfer(msg.sender, qty)) throw;
123     if (msg.value > val && !msg.sender.send(safeSub(msg.value, val))) throw;
124     if (beneficiary != address(0x0) && !beneficiary.send(val)) throw;
125   }
126 }