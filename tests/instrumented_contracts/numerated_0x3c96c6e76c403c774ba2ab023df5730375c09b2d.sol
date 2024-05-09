1 pragma solidity ^0.4.18;
2 
3 contract Token {
4   /// @return total amount of tokens
5   function totalSupply() constant returns (uint256 supply) {}
6 
7   /// @param _owner The address from which the balance will be retrieved
8   /// @return The balance
9   function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11   /// @notice send `_value` token to `_to` from `msg.sender`
12   /// @param _to The address of the recipient
13   /// @param _value The amount of token to be transferred
14   /// @return Whether the transfer was successful or not
15   function transfer(address _to,uint256 _value) returns (bool success) {}
16 
17   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
18   /// @param _from The address of the sender
19   /// @param _to The address of the recipient
20   /// @param _value The amount of token to be transferred
21   /// @return Whether the transfer was successful or not
22   function transferFrom(address _from,address _to,uint256 _value) returns (bool success) {}
23 
24   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
25   /// @param _spender The address of the account able to transfer the tokens
26   /// @param _value The amount of wei to be approved for transfer
27   /// @return Whether the approval was successful or not
28   function approve(address _spender,uint256 _value) returns (bool success) {}
29 
30   /// @param _owner The address of the account owning tokens
31   /// @param _spender The address of the account able to transfer the tokens
32   /// @return Amount of remaining tokens allowed to spent
33   function allowance(address _owner,address _spender) constant returns (uint256 remaining) {}
34 
35   event Transfer(address indexed _from,address indexed _to,uint256 _value);
36   event Approval(address indexed _owner,address indexed _spender,uint256 _value);
37 
38   uint decimals;
39   string name;
40 }
41 
42 contract SafeMath {
43   function safeMul(uint a,uint b) internal returns (uint) {
44     uint c = a * b;
45     assert(a == 0 || c / a == b);
46     return c;
47   }
48 
49 
50   function safeDiv(uint a,uint b) internal returns (uint) {
51     uint c = a / b;
52     return c;
53   }
54 
55   function safeSub(uint a,uint b) internal returns (uint) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function safeAdd(uint a,uint b) internal returns (uint) {
61     uint c = a + b;
62     assert(c>=a && c>=b);
63     return c;
64   }
65 
66 }
67 
68 contract ShortOrder is SafeMath {
69 
70   address admin;
71 
72   struct Order {
73     uint coupon;
74     uint balance;
75     bool tokenDeposit;
76     mapping (address => uint) shortBalance;
77     mapping (address => uint) longBalance;
78   }
79 
80   mapping (address => mapping (bytes32 => Order)) orderRecord;
81 
82   event TokenFulfillment(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs,uint amount);
83   event CouponDeposit(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs,uint value);
84   event LongPlace(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs,uint value);
85   event LongBought(address[2] sellerShort,uint[3] amountNonceExpiry,uint8 v,bytes32[3] hashRS,uint value);
86   event TokenLongExercised(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs,uint couponAmount,uint amount);
87   event EthLongExercised(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs,uint couponAmount,uint amount);
88   event DonationClaimed(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs,uint coupon,uint balance);
89   event NonActivationWithdrawal(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs,uint coupon);
90   event ActivationWithdrawal(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs,uint balance);
91 
92   modifier onlyAdmin() {
93     require(msg.sender == admin);
94     _;
95   }
96 
97   function ShortOrder() {
98     admin = msg.sender;
99   }
100 
101   function changeAdmin(address _admin) external onlyAdmin {
102     admin = _admin;
103   }
104 
105   function tokenFulfillmentDeposit(address[2] tokenUser,uint amount,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external {
106     bytes32 orderHash = keccak256 (
107         tokenUser[0],
108         tokenUser[1],
109         minMaxDMWCPNonce[0],
110         minMaxDMWCPNonce[1],
111         minMaxDMWCPNonce[2], 
112         minMaxDMWCPNonce[3],
113         minMaxDMWCPNonce[4],
114         minMaxDMWCPNonce[5],
115         minMaxDMWCPNonce[6], 
116         minMaxDMWCPNonce[7]
117       );
118     require(
119       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == msg.sender &&
120       block.number > minMaxDMWCPNonce[2] &&
121       block.number <= minMaxDMWCPNonce[3] && 
122       orderRecord[tokenUser[1]][orderHash].balance >= minMaxDMWCPNonce[0] &&
123       amount >= safeMul(orderRecord[msg.sender][orderHash].balance,minMaxDMWCPNonce[6]) &&
124       !orderRecord[msg.sender][orderHash].tokenDeposit
125     );
126     Token(tokenUser[0]).transferFrom(msg.sender,this,amount);
127     orderRecord[msg.sender][orderHash].shortBalance[tokenUser[0]] = safeAdd(orderRecord[msg.sender][orderHash].shortBalance[tokenUser[0]],amount);
128     orderRecord[msg.sender][orderHash].tokenDeposit = true;
129     TokenFulfillment(tokenUser,minMaxDMWCPNonce,v,rs,amount);
130   }
131  
132   function depositCoupon(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external payable {
133     bytes32 orderHash = keccak256 (
134         tokenUser[0],
135         tokenUser[1],
136         minMaxDMWCPNonce[0],
137         minMaxDMWCPNonce[1],
138         minMaxDMWCPNonce[2], 
139         minMaxDMWCPNonce[3],
140         minMaxDMWCPNonce[4],
141         minMaxDMWCPNonce[5],
142         minMaxDMWCPNonce[6], 
143         minMaxDMWCPNonce[7]
144       );
145     require(
146       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == msg.sender &&
147       msg.value >= minMaxDMWCPNonce[5]
148     );
149     orderRecord[msg.sender][orderHash].coupon = safeAdd(orderRecord[msg.sender][orderHash].coupon,msg.value);
150     CouponDeposit(tokenUser,minMaxDMWCPNonce,v,rs,msg.value);
151   }
152 
153   function placeLong(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external payable {
154     bytes32 orderHash = keccak256 (
155         tokenUser[0],
156         tokenUser[1],
157         minMaxDMWCPNonce[0],
158         minMaxDMWCPNonce[1],
159         minMaxDMWCPNonce[2], 
160         minMaxDMWCPNonce[3],
161         minMaxDMWCPNonce[4],
162         minMaxDMWCPNonce[5],
163         minMaxDMWCPNonce[6], 
164         minMaxDMWCPNonce[7]
165       );
166     require(
167       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1] &&
168       block.number <= minMaxDMWCPNonce[2] &&
169       orderRecord[tokenUser[1]][orderHash].coupon >= minMaxDMWCPNonce[5]&&
170       orderRecord[tokenUser[1]][orderHash].balance <= minMaxDMWCPNonce[1]
171     );
172     orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = safeAdd(orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender],msg.value);
173     orderRecord[tokenUser[1]][orderHash].balance = safeAdd(orderRecord[tokenUser[1]][orderHash].balance,msg.value);
174     LongPlace(tokenUser,minMaxDMWCPNonce,v,rs,msg.value);
175   }
176   
177   function buyLong(address[2] sellerShort,uint[3] amountNonceExpiry,uint8 v,bytes32[3] hashRS) external payable {
178     bytes32 longTransferHash = keccak256(sellerShort[0],amountNonceExpiry);
179     require(
180       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",longTransferHash[0]),v,hashRS[1],hashRS[2]) == sellerShort[1] &&
181       msg.value >= amountNonceExpiry[0] 
182     );
183     sellerShort[0].transfer(msg.value);
184     orderRecord[sellerShort[1]][hashRS[0]].longBalance[msg.sender] = orderRecord[sellerShort[1]][hashRS[0]].longBalance[sellerShort[0]];
185     orderRecord[sellerShort[1]][hashRS[0]].longBalance[sellerShort[0]] = uint(0);
186     LongBought(sellerShort,amountNonceExpiry,v,hashRS,msg.value);
187   }
188 
189   function exerciseLong(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external {
190     bytes32 orderHash = keccak256 (
191         tokenUser[0],
192         tokenUser[1],
193         minMaxDMWCPNonce[0],
194         minMaxDMWCPNonce[1],
195         minMaxDMWCPNonce[2], 
196         minMaxDMWCPNonce[3],
197         minMaxDMWCPNonce[4],
198         minMaxDMWCPNonce[5],
199         minMaxDMWCPNonce[6], 
200         minMaxDMWCPNonce[7]
201       );
202     require(
203       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1] &&
204       block.number > minMaxDMWCPNonce[3] &&
205       block.number <= minMaxDMWCPNonce[4] &&
206       orderRecord[tokenUser[1]][orderHash].balance >= minMaxDMWCPNonce[0]
207     );
208     uint couponProportion = safeDiv(orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender],orderRecord[tokenUser[1]][orderHash].balance);
209     uint couponAmount;
210     if(orderRecord[msg.sender][orderHash].tokenDeposit) {
211       couponAmount = safeMul(orderRecord[tokenUser[1]][orderHash].coupon,couponProportion);
212       uint amount = safeMul(orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender],minMaxDMWCPNonce[6]);
213       msg.sender.transfer(couponAmount);
214       Token(tokenUser[0]).transfer(msg.sender,amount);
215       orderRecord[tokenUser[1]][orderHash].coupon = safeSub(orderRecord[tokenUser[1]][orderHash].coupon,couponAmount);
216       orderRecord[tokenUser[1]][orderHash].balance = safeSub(orderRecord[tokenUser[1]][orderHash].balance,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
217       orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[0]] = safeSub(orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[0]],amount);
218       orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = uint(0);
219       TokenLongExercised(tokenUser,minMaxDMWCPNonce,v,rs,couponAmount,amount);
220     }
221     else {
222       couponAmount = safeMul(orderRecord[tokenUser[1]][orderHash].coupon,couponProportion);
223       msg.sender.transfer(safeAdd(couponAmount,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]));
224       orderRecord[tokenUser[1]][orderHash].coupon = safeSub(orderRecord[tokenUser[1]][orderHash].coupon,couponAmount);
225       orderRecord[tokenUser[1]][orderHash].balance = safeSub(orderRecord[tokenUser[1]][orderHash].balance,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
226       orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = uint(0); 
227       EthLongExercised(tokenUser,minMaxDMWCPNonce,v,rs,couponAmount,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
228     }
229   }
230 
231   function claimDonations(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external onlyAdmin {
232     bytes32 orderHash = keccak256 (
233         tokenUser[0],
234         tokenUser[1],
235         minMaxDMWCPNonce[0],
236         minMaxDMWCPNonce[1],
237         minMaxDMWCPNonce[2], 
238         minMaxDMWCPNonce[3],
239         minMaxDMWCPNonce[4],
240         minMaxDMWCPNonce[5],
241         minMaxDMWCPNonce[6], 
242         minMaxDMWCPNonce[7]
243       );
244     require(
245       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1] &&
246       block.number > minMaxDMWCPNonce[4]
247     );
248     admin.transfer(safeAdd(orderRecord[tokenUser[1]][orderHash].coupon,orderRecord[tokenUser[1]][orderHash].balance));
249     Token(tokenUser[0]).transfer(admin,orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[0]]);
250     orderRecord[tokenUser[1]][orderHash].balance = uint(0);
251     orderRecord[tokenUser[1]][orderHash].coupon = uint(0);
252     orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[0]] = uint(0);
253     DonationClaimed(tokenUser,minMaxDMWCPNonce,v,rs,orderRecord[tokenUser[1]][orderHash].coupon,orderRecord[tokenUser[1]][orderHash].balance);
254   }
255 
256   function nonActivationShortWithdrawal(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external {
257     bytes32 orderHash = keccak256 (
258         tokenUser[0],
259         tokenUser[1],
260         minMaxDMWCPNonce[0],
261         minMaxDMWCPNonce[1],
262         minMaxDMWCPNonce[2], 
263         minMaxDMWCPNonce[3],
264         minMaxDMWCPNonce[4],
265         minMaxDMWCPNonce[5],
266         minMaxDMWCPNonce[6], 
267         minMaxDMWCPNonce[7]
268       );
269     require(
270       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == msg.sender &&
271       block.number > minMaxDMWCPNonce[3] &&
272       block.number <= minMaxDMWCPNonce[4] &&
273       orderRecord[tokenUser[1]][orderHash].balance < minMaxDMWCPNonce[0]
274     );
275     msg.sender.transfer(orderRecord[msg.sender][orderHash].coupon);
276     orderRecord[msg.sender][orderHash].coupon = uint(0);
277     NonActivationWithdrawal(tokenUser,minMaxDMWCPNonce,v,rs,orderRecord[msg.sender][orderHash].coupon);
278   }
279 
280   function nonActivationWithdrawal(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external {
281     bytes32 orderHash = keccak256 (
282         tokenUser[0],
283         tokenUser[1],
284         minMaxDMWCPNonce[0],
285         minMaxDMWCPNonce[1],
286         minMaxDMWCPNonce[2], 
287         minMaxDMWCPNonce[3],
288         minMaxDMWCPNonce[4],
289         minMaxDMWCPNonce[5],
290         minMaxDMWCPNonce[6], 
291         minMaxDMWCPNonce[7]
292       );
293     require(
294       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1] &&
295       block.number > minMaxDMWCPNonce[3] &&
296       block.number <= minMaxDMWCPNonce[4] &&
297       orderRecord[tokenUser[1]][orderHash].balance < minMaxDMWCPNonce[0]
298     );
299     msg.sender.transfer(orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
300     orderRecord[tokenUser[1]][orderHash].balance = safeSub(orderRecord[tokenUser[1]][orderHash].balance,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
301     orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = uint(0);
302     ActivationWithdrawal(tokenUser,minMaxDMWCPNonce,v,rs,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
303   }
304 
305   function returnBalance(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external constant returns (uint) {
306     bytes32 orderHash = keccak256 (
307         tokenUser[0],
308         tokenUser[1],
309         minMaxDMWCPNonce[0],
310         minMaxDMWCPNonce[1],
311         minMaxDMWCPNonce[2], 
312         minMaxDMWCPNonce[3],
313         minMaxDMWCPNonce[4],
314         minMaxDMWCPNonce[5],
315         minMaxDMWCPNonce[6], 
316         minMaxDMWCPNonce[7]
317       );
318     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1]);
319     return orderRecord[tokenUser[1]][orderHash].balance;
320   }
321 
322   function returnTokenBalance(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external constant returns (uint) {
323     bytes32 orderHash = keccak256 (
324         tokenUser[0],
325         tokenUser[1],
326         minMaxDMWCPNonce[0],
327         minMaxDMWCPNonce[1],
328         minMaxDMWCPNonce[2], 
329         minMaxDMWCPNonce[3],
330         minMaxDMWCPNonce[4],
331         minMaxDMWCPNonce[5],
332         minMaxDMWCPNonce[6], 
333         minMaxDMWCPNonce[7]
334       );
335     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1]);
336     return orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[1]];
337   }
338 
339   function returnUserBalance(address _user,address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external constant returns (uint) {
340     bytes32 orderHash = keccak256 (
341         tokenUser[0],
342         tokenUser[1],
343         minMaxDMWCPNonce[0],
344         minMaxDMWCPNonce[1],
345         minMaxDMWCPNonce[2], 
346         minMaxDMWCPNonce[3],
347         minMaxDMWCPNonce[4],
348         minMaxDMWCPNonce[5],
349         minMaxDMWCPNonce[6], 
350         minMaxDMWCPNonce[7]
351       );
352     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1]);
353     return orderRecord[tokenUser[1]][orderHash].longBalance[_user];
354   }
355 
356   function returnCoupon(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external constant returns (uint) {
357     bytes32 orderHash = keccak256 (
358         tokenUser[0],
359         tokenUser[1],
360         minMaxDMWCPNonce[0],
361         minMaxDMWCPNonce[1],
362         minMaxDMWCPNonce[2], 
363         minMaxDMWCPNonce[3],
364         minMaxDMWCPNonce[4],
365         minMaxDMWCPNonce[5],
366         minMaxDMWCPNonce[6], 
367         minMaxDMWCPNonce[7]
368       );
369     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1]);
370     return orderRecord[tokenUser[1]][orderHash].coupon;
371   }
372 
373   function returnTokenDepositState(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external constant returns (bool) {
374     bytes32 orderHash = keccak256 (
375         tokenUser[0],
376         tokenUser[1],
377         minMaxDMWCPNonce[0],
378         minMaxDMWCPNonce[1],
379         minMaxDMWCPNonce[2], 
380         minMaxDMWCPNonce[3],
381         minMaxDMWCPNonce[4],
382         minMaxDMWCPNonce[5],
383         minMaxDMWCPNonce[6], 
384         minMaxDMWCPNonce[7]
385       );
386     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1]);
387     return orderRecord[tokenUser[1]][orderHash].tokenDeposit;
388   }
389  
390   function returnHash(address[2] tokenUser,uint[8] minMaxDMWCPNonce) external pure returns (bytes32) {
391     bytes32 orderHash = keccak256 (
392         tokenUser[0],
393         tokenUser[1],
394         minMaxDMWCPNonce[0],
395         minMaxDMWCPNonce[1],
396         minMaxDMWCPNonce[2],
397         minMaxDMWCPNonce[3],
398         minMaxDMWCPNonce[4],
399         minMaxDMWCPNonce[5],
400         minMaxDMWCPNonce[6],
401         minMaxDMWCPNonce[7]
402       );
403     return keccak256("\x19Ethereum Signed Message:\n32",orderHash);
404   }
405 
406   function returnAddress(bytes32 orderHash,uint8 v,bytes32[2] rs) external pure returns (address) {
407     return ecrecover(orderHash,v,rs[0],rs[1]);
408   }
409 
410   function returnHashLong(address seller,uint[3] amountNonceExpiry)  external pure returns (bytes32) {
411     bytes32 orderHash =  keccak256(seller,amountNonceExpiry[0],amountNonceExpiry[1],amountNonceExpiry[2]);
412     return keccak256("\x19Ethereum Signed Message:\n32",orderHash);
413   }
414 
415   function returnLongAddress(bytes32 orderHash,uint8 v,bytes32[2] rs) external pure returns (address) {
416     return ecrecover(orderHash,v,rs[0],rs[1]);
417   }
418 
419 }