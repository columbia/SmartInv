1 pragma solidity ^0.4.18;
2 
3 contract Token {
4     
5   function totalSupply() constant returns (uint256 supply) {}
6   function balanceOf(address _owner) constant returns (uint256 balance) {}
7   function transfer(address _to,uint256 _value) returns (bool success) {}
8   function transferFrom(address _from,address _to,uint256 _value) returns (bool success) {}
9   function approve(address _spender,uint256 _value) returns (bool success) {}
10   function allowance(address _owner,address _spender) constant returns (uint256 remaining) {}
11 
12   event Transfer(address indexed _from,address indexed _to,uint256 _value);
13   event Approval(address indexed _owner,address indexed _spender,uint256 _value);
14 
15   uint decimals;
16   string name;
17 }
18 
19 contract SafeMath {
20     
21   function safeMul(uint a,uint b) internal returns (uint) {
22     uint c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27 
28   function safeDiv(uint a,uint b) internal returns (uint) {
29     uint c = a / b;
30     return c;
31   }
32 
33   function safeSub(uint a,uint b) internal returns (uint) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function safeAdd(uint a,uint b) internal returns (uint) {
39     uint c = a + b;
40     assert(c>=a && c>=b);
41     return c;
42   }
43 
44 }
45 
46 contract ShortOrder is SafeMath {
47 
48   address admin;
49 
50   struct Order {
51     uint coupon;
52     uint balance;
53     uint shortBalance;
54     bool tokenDeposit;
55     mapping (address => uint) longBalance;
56   }
57 
58   mapping (address => mapping (bytes32 => Order)) orderRecord;
59 
60   event TokenFulfillment(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint blockNumber);
61   event CouponDeposit(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint blockNumber);
62   event LongPlace(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint value,uint blockNumber);
63   event LongBought(address[2] sellerShort,uint[3] amountNonceExpiry,uint blockNumber);
64   event TokenLongExercised(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint amount,uint blockNumber);
65   event EthLongExercised(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint blockNumber);
66   event DonationClaimed(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint balance,uint blockNumber);
67   event NonActivationWithdrawal(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint blockNumber);
68   event ActivationWithdrawal(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint balance,uint blockNumber);
69 
70   modifier onlyAdmin() {
71     require(msg.sender == admin);
72     _;
73   }
74 
75   function ShortOrder() {
76     admin = msg.sender;
77   }
78 
79   function changeAdmin(address _admin) external onlyAdmin {
80     admin = _admin;
81   }
82   
83   function tokenFulfillmentDeposit(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint8 v,bytes32[2] rs) external {
84     bytes32 orderHash = keccak256 (
85         tokenUser[0],
86         tokenUser[1],
87         tokenMinMaxDMWCNonce[0],
88         tokenMinMaxDMWCNonce[1], 
89         tokenMinMaxDMWCNonce[2],
90         tokenMinMaxDMWCNonce[3],
91         tokenMinMaxDMWCNonce[4],
92         tokenMinMaxDMWCNonce[5], 
93         tokenMinMaxDMWCNonce[6],
94         tokenMinMaxDMWCNonce[7]
95       );
96     require(
97       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == msg.sender &&
98       block.number > tokenMinMaxDMWCNonce[3] &&
99       block.number <= tokenMinMaxDMWCNonce[4] && 
100       orderRecord[msg.sender][orderHash].balance > tokenMinMaxDMWCNonce[1] &&
101       orderRecord[msg.sender][orderHash].balance <= tokenMinMaxDMWCNonce[2] &&      
102       !orderRecord[msg.sender][orderHash].tokenDeposit
103     );
104     Token(tokenUser[0]).transferFrom(msg.sender,this,tokenMinMaxDMWCNonce[0]);
105     orderRecord[msg.sender][orderHash].shortBalance = safeAdd(orderRecord[msg.sender][orderHash].shortBalance,tokenMinMaxDMWCNonce[0]);
106     orderRecord[msg.sender][orderHash].tokenDeposit = true;
107     TokenFulfillment(tokenUser,tokenMinMaxDMWCNonce,block.number);
108   }
109 
110   function depositCoupon(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint8 v,bytes32[2] rs) external payable {
111     bytes32 orderHash = keccak256 (
112         tokenUser[0],
113         tokenUser[1],
114         tokenMinMaxDMWCNonce[0],
115         tokenMinMaxDMWCNonce[1], 
116         tokenMinMaxDMWCNonce[2],
117         tokenMinMaxDMWCNonce[3],
118         tokenMinMaxDMWCNonce[4],
119         tokenMinMaxDMWCNonce[5], 
120         tokenMinMaxDMWCNonce[6],
121         tokenMinMaxDMWCNonce[7]
122       );
123     require(
124       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == msg.sender &&
125       msg.value == tokenMinMaxDMWCNonce[6] &&
126       orderRecord[msg.sender][orderHash].coupon == uint(0) &&
127       block.number <= tokenMinMaxDMWCNonce[3]
128     );
129     orderRecord[msg.sender][orderHash].coupon = safeAdd(orderRecord[msg.sender][orderHash].coupon,msg.value);
130     CouponDeposit(tokenUser,tokenMinMaxDMWCNonce,block.number);
131   }
132 
133   function placeLong(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint8 v,bytes32[2] rs) external payable {
134     bytes32 orderHash = keccak256 (
135         tokenUser[0],
136         tokenUser[1],
137         tokenMinMaxDMWCNonce[0],
138         tokenMinMaxDMWCNonce[1], 
139         tokenMinMaxDMWCNonce[2],
140         tokenMinMaxDMWCNonce[3],
141         tokenMinMaxDMWCNonce[4],
142         tokenMinMaxDMWCNonce[5], 
143         tokenMinMaxDMWCNonce[6],
144         tokenMinMaxDMWCNonce[7]
145       );
146     require(  
147       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1] &&
148       block.number <= tokenMinMaxDMWCNonce[3] &&
149       orderRecord[tokenUser[1]][orderHash].coupon == tokenMinMaxDMWCNonce[6] &&
150       orderRecord[msg.sender][orderHash].balance > tokenMinMaxDMWCNonce[1] &&
151       orderRecord[msg.sender][orderHash].balance <= tokenMinMaxDMWCNonce[2]
152     );
153     orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = safeAdd(orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender],msg.value);
154     orderRecord[tokenUser[1]][orderHash].balance = safeAdd(orderRecord[tokenUser[1]][orderHash].balance,msg.value);
155     LongPlace(tokenUser,tokenMinMaxDMWCNonce,msg.value,block.number);
156   }
157 
158   function buyLong(address[2] sellerShort,uint[3] amountNonceExpiry,uint8 v,bytes32[3] hashRS) external payable {
159     bytes32 longTransferHash = keccak256 (
160         sellerShort[0],
161         amountNonceExpiry[0],
162         amountNonceExpiry[1],
163         amountNonceExpiry[2]
164     );
165     require(
166       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",longTransferHash),v,hashRS[1],hashRS[2]) == sellerShort[1] &&
167       block.number <= amountNonceExpiry[2] &&
168       msg.value == amountNonceExpiry[0]
169     );
170     sellerShort[0].transfer(amountNonceExpiry[0]);
171     orderRecord[sellerShort[1]][hashRS[0]].longBalance[msg.sender] = orderRecord[sellerShort[1]][hashRS[0]].longBalance[sellerShort[0]];
172     orderRecord[sellerShort[1]][hashRS[0]].longBalance[sellerShort[0]] = uint(0);
173     LongBought(sellerShort,amountNonceExpiry,block.number);
174   }
175 
176   function exerciseLong(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint8 v,bytes32[2] rs) external {
177     bytes32 orderHash = keccak256 (
178         tokenUser[0],
179         tokenUser[1],
180         tokenMinMaxDMWCNonce[0],
181         tokenMinMaxDMWCNonce[1], 
182         tokenMinMaxDMWCNonce[2],
183         tokenMinMaxDMWCNonce[3],
184         tokenMinMaxDMWCNonce[4],
185         tokenMinMaxDMWCNonce[5], 
186         tokenMinMaxDMWCNonce[6],
187         tokenMinMaxDMWCNonce[7]
188       );
189     require(
190       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1] &&
191       block.number > tokenMinMaxDMWCNonce[4] &&
192       block.number <= tokenMinMaxDMWCNonce[5] &&
193       orderRecord[msg.sender][orderHash].balance > tokenMinMaxDMWCNonce[1] &&
194       orderRecord[msg.sender][orderHash].balance <= tokenMinMaxDMWCNonce[2]
195     );
196     uint couponAmount = safeDiv(safeMul(orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender],orderRecord[tokenUser[1]][orderHash].coupon),tokenMinMaxDMWCNonce[2]);
197     if(orderRecord[msg.sender][orderHash].tokenDeposit) {
198       uint amount = safeDiv(safeMul(orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender],orderRecord[tokenUser[1]][orderHash].shortBalance),tokenMinMaxDMWCNonce[2]);
199       msg.sender.transfer(couponAmount);
200       Token(tokenUser[0]).transfer(msg.sender,amount);
201       orderRecord[tokenUser[1]][orderHash].coupon = safeSub(orderRecord[tokenUser[1]][orderHash].coupon,couponAmount);
202       orderRecord[tokenUser[1]][orderHash].balance = safeSub(orderRecord[tokenUser[1]][orderHash].balance,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
203       orderRecord[tokenUser[1]][orderHash].shortBalance = safeSub(orderRecord[tokenUser[1]][orderHash].shortBalance,amount);
204       orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = uint(0);
205       TokenLongExercised(tokenUser,tokenMinMaxDMWCNonce,amount,block.number);
206     }
207     else if(!orderRecord[msg.sender][orderHash].tokenDeposit){
208       msg.sender.transfer(safeAdd(couponAmount,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]));
209       orderRecord[tokenUser[1]][orderHash].coupon = safeSub(orderRecord[tokenUser[1]][orderHash].coupon,couponAmount);
210       orderRecord[tokenUser[1]][orderHash].balance = safeSub(orderRecord[tokenUser[1]][orderHash].balance,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
211       orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = uint(0); 
212       EthLongExercised(tokenUser,tokenMinMaxDMWCNonce,block.number);
213     }
214   }
215 
216   function claimDonations(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint8 v,bytes32[2] rs) external onlyAdmin {
217     bytes32 orderHash = keccak256 (
218         tokenUser[0],
219         tokenUser[1],
220         tokenMinMaxDMWCNonce[0],
221         tokenMinMaxDMWCNonce[1], 
222         tokenMinMaxDMWCNonce[2],
223         tokenMinMaxDMWCNonce[3],
224         tokenMinMaxDMWCNonce[4],
225         tokenMinMaxDMWCNonce[5], 
226         tokenMinMaxDMWCNonce[6],
227         tokenMinMaxDMWCNonce[7]
228       );
229     require(
230       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1] &&
231       block.number > tokenMinMaxDMWCNonce[5]
232     );
233     admin.transfer(safeAdd(orderRecord[tokenUser[1]][orderHash].coupon,orderRecord[tokenUser[1]][orderHash].balance));
234     Token(tokenUser[0]).transfer(admin,orderRecord[tokenUser[1]][orderHash].shortBalance);
235     orderRecord[tokenUser[1]][orderHash].balance = uint(0);
236     orderRecord[tokenUser[1]][orderHash].coupon = uint(0);
237     orderRecord[tokenUser[1]][orderHash].shortBalance = uint(0);
238     DonationClaimed(tokenUser,tokenMinMaxDMWCNonce,orderRecord[tokenUser[1]][orderHash].balance,block.number);
239   }
240 
241   function nonActivationShortWithdrawal(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint8 v,bytes32[2] rs) external {
242     bytes32 orderHash = keccak256 (
243         tokenUser[0],
244         tokenUser[1],
245         tokenMinMaxDMWCNonce[0],
246         tokenMinMaxDMWCNonce[1], 
247         tokenMinMaxDMWCNonce[2],
248         tokenMinMaxDMWCNonce[3],
249         tokenMinMaxDMWCNonce[4],
250         tokenMinMaxDMWCNonce[5], 
251         tokenMinMaxDMWCNonce[6],
252         tokenMinMaxDMWCNonce[7]
253       );
254 
255     require(
256       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == msg.sender &&
257       block.number > tokenMinMaxDMWCNonce[3] &&
258       orderRecord[tokenUser[1]][orderHash].balance < tokenMinMaxDMWCNonce[1]
259     );
260     msg.sender.transfer(orderRecord[msg.sender][orderHash].coupon);
261     orderRecord[msg.sender][orderHash].coupon = uint(0);
262     NonActivationWithdrawal(tokenUser,tokenMinMaxDMWCNonce,block.number);
263   }
264 
265   function nonActivationWithdrawal(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce,uint8 v,bytes32[2] rs) external {
266     bytes32 orderHash = keccak256 (
267         tokenUser[0],
268         tokenUser[1],
269         tokenMinMaxDMWCNonce[0],
270         tokenMinMaxDMWCNonce[1], 
271         tokenMinMaxDMWCNonce[2],
272         tokenMinMaxDMWCNonce[3],
273         tokenMinMaxDMWCNonce[4],
274         tokenMinMaxDMWCNonce[5], 
275         tokenMinMaxDMWCNonce[6],
276         tokenMinMaxDMWCNonce[7]
277       );
278 
279     require(
280       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1] &&
281       block.number > tokenMinMaxDMWCNonce[3] &&
282       block.number <= tokenMinMaxDMWCNonce[5] &&
283       orderRecord[tokenUser[1]][orderHash].balance < tokenMinMaxDMWCNonce[1]
284     );
285     msg.sender.transfer(orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
286     orderRecord[tokenUser[1]][orderHash].balance = safeSub(orderRecord[tokenUser[1]][orderHash].balance,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
287     orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = uint(0);
288     ActivationWithdrawal(tokenUser,tokenMinMaxDMWCNonce,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender],block.number);
289   }
290 
291   function returnBalance(address _creator,bytes32 orderHash) external constant returns (uint) {
292     return orderRecord[_creator][orderHash].balance;
293   }
294 
295   function returnTokenBalance(address _creator,bytes32 orderHash) external constant returns (uint) {
296     return orderRecord[_creator][orderHash].shortBalance;
297   }
298 
299   function returnUserBalance(address[2] creatorUser,bytes32 orderHash) external constant returns (uint) {
300     return orderRecord[creatorUser[0]][orderHash].longBalance[creatorUser[1]];
301   }
302 
303   function returnCoupon(address _creator,bytes32 orderHash) external constant returns (uint) {
304     return orderRecord[_creator][orderHash].coupon;
305   }
306 
307   function returnTokenDepositState(address _creator,bytes32 orderHash) external constant returns (bool) {
308     return orderRecord[_creator][orderHash].tokenDeposit;
309   }
310  
311   function returnHash(address[2] tokenUser,uint[8] tokenMinMaxDMWCNonce)  external pure returns (bytes32) {
312     return  
313       keccak256 (
314         tokenUser[0],
315         tokenUser[1],
316         tokenMinMaxDMWCNonce[0],
317         tokenMinMaxDMWCNonce[1], 
318         tokenMinMaxDMWCNonce[2],
319         tokenMinMaxDMWCNonce[3],
320         tokenMinMaxDMWCNonce[4],
321         tokenMinMaxDMWCNonce[5], 
322         tokenMinMaxDMWCNonce[6],
323         tokenMinMaxDMWCNonce[7]
324       );
325   }
326 
327 
328   function returnAddress(bytes32 orderHash,uint8 v,bytes32[2] rs) external pure returns (address) {
329     return ecrecover(orderHash,v,rs[0],rs[1]);
330   }
331 
332   function returnHashLong(address seller,uint[3] amountNonceExpiry)  external pure returns (bytes32) {
333     return keccak256(seller,amountNonceExpiry[0],amountNonceExpiry[1],amountNonceExpiry[2]);
334   }
335 
336   function returnLongAddress(bytes32 orderHash,uint8 v,bytes32[2] rs) external pure returns (address) {
337     return ecrecover(orderHash,v,rs[0],rs[1]);
338   }
339 
340   function returnCoupon(address[3] tokenUserSender,bytes32 orderHash) external view returns (uint){
341     return orderRecord[tokenUserSender[1]][orderHash].coupon;
342   }
343 
344   function returnLongTokenAmount(address[3] tokenUserSender,bytes32 orderHash) external view returns (uint) {
345     return orderRecord[tokenUserSender[1]][orderHash].shortBalance;
346   }
347 
348 }