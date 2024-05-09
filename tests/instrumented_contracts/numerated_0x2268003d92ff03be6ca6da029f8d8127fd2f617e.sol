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
85   event LongBought(address[2] sellerShort,uint[5] amountNonceExpiryDM,uint8 v,bytes32[3] hashRS,uint value);
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
123       amount == safeMul(orderRecord[msg.sender][orderHash].balance,minMaxDMWCPNonce[6]) &&
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
147       msg.value == minMaxDMWCPNonce[5] &&
148       block.number <= minMaxDMWCPNonce[2]
149     );
150     orderRecord[msg.sender][orderHash].coupon = safeAdd(orderRecord[msg.sender][orderHash].coupon,msg.value);
151     CouponDeposit(tokenUser,minMaxDMWCPNonce,v,rs,msg.value);
152   }
153 
154   function placeLong(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external payable {
155     bytes32 orderHash = keccak256 (
156         tokenUser[0],
157         tokenUser[1],
158         minMaxDMWCPNonce[0],
159         minMaxDMWCPNonce[1],
160         minMaxDMWCPNonce[2], 
161         minMaxDMWCPNonce[3],
162         minMaxDMWCPNonce[4],
163         minMaxDMWCPNonce[5],
164         minMaxDMWCPNonce[6], 
165         minMaxDMWCPNonce[7]
166       );
167     require(
168       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1] &&
169       block.number <= minMaxDMWCPNonce[2] &&
170       orderRecord[tokenUser[1]][orderHash].coupon == minMaxDMWCPNonce[5] &&
171       orderRecord[tokenUser[1]][orderHash].balance <= minMaxDMWCPNonce[1]
172     );
173     orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = safeAdd(orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender],msg.value);
174     orderRecord[tokenUser[1]][orderHash].balance = safeAdd(orderRecord[tokenUser[1]][orderHash].balance,msg.value);
175     LongPlace(tokenUser,minMaxDMWCPNonce,v,rs,msg.value);
176   }
177   
178   function buyLong(address[2] sellerShort,uint[5] amountNonceExpiryDM,uint8 v,bytes32[3] hashRS) external payable {
179     bytes32 longTransferHash = keccak256 (
180         sellerShort[0],
181         amountNonceExpiryDM[0],
182         amountNonceExpiryDM[1],
183         amountNonceExpiryDM[2]
184     );
185     require(
186       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",longTransferHash),v,hashRS[1],hashRS[2]) == sellerShort[1] &&
187       block.number > amountNonceExpiryDM[3] &&
188       block.number <= safeSub(amountNonceExpiryDM[4],amountNonceExpiryDM[2]) &&
189       msg.value == amountNonceExpiryDM[0]
190     );
191     sellerShort[0].transfer(amountNonceExpiryDM[0]);
192     orderRecord[sellerShort[1]][hashRS[0]].longBalance[msg.sender] = orderRecord[sellerShort[1]][hashRS[0]].longBalance[sellerShort[0]];
193     orderRecord[sellerShort[1]][hashRS[0]].longBalance[sellerShort[0]] = uint(0);
194     LongBought(sellerShort,amountNonceExpiryDM,v,hashRS,amountNonceExpiryDM[0]);
195   }
196 
197   function exerciseLong(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external {
198     bytes32 orderHash = keccak256 (
199         tokenUser[0],
200         tokenUser[1],
201         minMaxDMWCPNonce[0],
202         minMaxDMWCPNonce[1],
203         minMaxDMWCPNonce[2], 
204         minMaxDMWCPNonce[3],
205         minMaxDMWCPNonce[4],
206         minMaxDMWCPNonce[5],
207         minMaxDMWCPNonce[6], 
208         minMaxDMWCPNonce[7]
209       );
210     require(
211       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1] &&
212       block.number > minMaxDMWCPNonce[3] &&
213       block.number <= minMaxDMWCPNonce[4] &&
214       orderRecord[tokenUser[1]][orderHash].balance >= minMaxDMWCPNonce[0]
215     );
216     uint couponProportion = safeDiv(orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender],orderRecord[tokenUser[1]][orderHash].balance);
217     uint couponAmount;
218     if(orderRecord[msg.sender][orderHash].tokenDeposit) {
219       couponAmount = safeMul(orderRecord[tokenUser[1]][orderHash].coupon,couponProportion);
220       uint amount = safeMul(orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender],minMaxDMWCPNonce[6]);
221       msg.sender.transfer(couponAmount);
222       Token(tokenUser[0]).transfer(msg.sender,amount);
223       orderRecord[tokenUser[1]][orderHash].coupon = safeSub(orderRecord[tokenUser[1]][orderHash].coupon,couponAmount);
224       orderRecord[tokenUser[1]][orderHash].balance = safeSub(orderRecord[tokenUser[1]][orderHash].balance,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
225       orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[0]] = safeSub(orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[0]],amount);
226       orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = uint(0);
227       TokenLongExercised(tokenUser,minMaxDMWCPNonce,v,rs,couponAmount,amount);
228     }
229     else if(!orderRecord[msg.sender][orderHash].tokenDeposit){
230       couponAmount = safeMul(orderRecord[tokenUser[1]][orderHash].coupon,couponProportion);
231       msg.sender.transfer(safeAdd(couponAmount,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]));
232       orderRecord[tokenUser[1]][orderHash].coupon = safeSub(orderRecord[tokenUser[1]][orderHash].coupon,couponAmount);
233       orderRecord[tokenUser[1]][orderHash].balance = safeSub(orderRecord[tokenUser[1]][orderHash].balance,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
234       orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = uint(0); 
235       EthLongExercised(tokenUser,minMaxDMWCPNonce,v,rs,couponAmount,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
236     }
237   }
238 
239   function claimDonations(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external onlyAdmin {
240     bytes32 orderHash = keccak256 (
241         tokenUser[0],
242         tokenUser[1],
243         minMaxDMWCPNonce[0],
244         minMaxDMWCPNonce[1],
245         minMaxDMWCPNonce[2], 
246         minMaxDMWCPNonce[3],
247         minMaxDMWCPNonce[4],
248         minMaxDMWCPNonce[5],
249         minMaxDMWCPNonce[6], 
250         minMaxDMWCPNonce[7]
251       );
252     require(
253       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1] &&
254       block.number > minMaxDMWCPNonce[4]
255     );
256     admin.transfer(safeAdd(orderRecord[tokenUser[1]][orderHash].coupon,orderRecord[tokenUser[1]][orderHash].balance));
257     Token(tokenUser[0]).transfer(admin,orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[0]]);
258     orderRecord[tokenUser[1]][orderHash].balance = uint(0);
259     orderRecord[tokenUser[1]][orderHash].coupon = uint(0);
260     orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[0]] = uint(0);
261     DonationClaimed(tokenUser,minMaxDMWCPNonce,v,rs,orderRecord[tokenUser[1]][orderHash].coupon,orderRecord[tokenUser[1]][orderHash].balance);
262   }
263 
264   function nonActivationShortWithdrawal(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external {
265     bytes32 orderHash = keccak256 (
266         tokenUser[0],
267         tokenUser[1],
268         minMaxDMWCPNonce[0],
269         minMaxDMWCPNonce[1],
270         minMaxDMWCPNonce[2], 
271         minMaxDMWCPNonce[3],
272         minMaxDMWCPNonce[4],
273         minMaxDMWCPNonce[5],
274         minMaxDMWCPNonce[6], 
275         minMaxDMWCPNonce[7]
276       );
277     require(
278       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == msg.sender &&
279       block.number > minMaxDMWCPNonce[2] &&
280       orderRecord[tokenUser[1]][orderHash].balance < minMaxDMWCPNonce[0]
281     );
282     msg.sender.transfer(orderRecord[msg.sender][orderHash].coupon);
283     orderRecord[msg.sender][orderHash].coupon = uint(0);
284     NonActivationWithdrawal(tokenUser,minMaxDMWCPNonce,v,rs,orderRecord[msg.sender][orderHash].coupon);
285   }
286 
287   function nonActivationWithdrawal(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external {
288     bytes32 orderHash = keccak256 (
289         tokenUser[0],
290         tokenUser[1],
291         minMaxDMWCPNonce[0],
292         minMaxDMWCPNonce[1],
293         minMaxDMWCPNonce[2], 
294         minMaxDMWCPNonce[3],
295         minMaxDMWCPNonce[4],
296         minMaxDMWCPNonce[5],
297         minMaxDMWCPNonce[6], 
298         minMaxDMWCPNonce[7]
299       );
300     require(
301       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1] &&
302       block.number > minMaxDMWCPNonce[2] &&
303       block.number <= minMaxDMWCPNonce[4] &&
304       orderRecord[tokenUser[1]][orderHash].balance < minMaxDMWCPNonce[0]
305     );
306     msg.sender.transfer(orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
307     orderRecord[tokenUser[1]][orderHash].balance = safeSub(orderRecord[tokenUser[1]][orderHash].balance,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
308     orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = uint(0);
309     ActivationWithdrawal(tokenUser,minMaxDMWCPNonce,v,rs,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
310   }
311 
312   function returnBalance(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external constant returns (uint) {
313     bytes32 orderHash = keccak256 (
314         tokenUser[0],
315         tokenUser[1],
316         minMaxDMWCPNonce[0],
317         minMaxDMWCPNonce[1],
318         minMaxDMWCPNonce[2], 
319         minMaxDMWCPNonce[3],
320         minMaxDMWCPNonce[4],
321         minMaxDMWCPNonce[5],
322         minMaxDMWCPNonce[6], 
323         minMaxDMWCPNonce[7]
324       );
325     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1]);
326     return orderRecord[tokenUser[1]][orderHash].balance;
327   }
328 
329   function returnTokenBalance(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external constant returns (uint) {
330     bytes32 orderHash = keccak256 (
331         tokenUser[0],
332         tokenUser[1],
333         minMaxDMWCPNonce[0],
334         minMaxDMWCPNonce[1],
335         minMaxDMWCPNonce[2], 
336         minMaxDMWCPNonce[3],
337         minMaxDMWCPNonce[4],
338         minMaxDMWCPNonce[5],
339         minMaxDMWCPNonce[6], 
340         minMaxDMWCPNonce[7]
341       );
342     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1]);
343     return orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[1]];
344   }
345 
346   function returnUserBalance(address _user,address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external constant returns (uint) {
347     bytes32 orderHash = keccak256 (
348         tokenUser[0],
349         tokenUser[1],
350         minMaxDMWCPNonce[0],
351         minMaxDMWCPNonce[1],
352         minMaxDMWCPNonce[2], 
353         minMaxDMWCPNonce[3],
354         minMaxDMWCPNonce[4],
355         minMaxDMWCPNonce[5],
356         minMaxDMWCPNonce[6], 
357         minMaxDMWCPNonce[7]
358       );
359     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1]);
360     return orderRecord[tokenUser[1]][orderHash].longBalance[_user];
361   }
362 
363   function returnCoupon(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external constant returns (uint) {
364     bytes32 orderHash = keccak256 (
365         tokenUser[0],
366         tokenUser[1],
367         minMaxDMWCPNonce[0],
368         minMaxDMWCPNonce[1],
369         minMaxDMWCPNonce[2], 
370         minMaxDMWCPNonce[3],
371         minMaxDMWCPNonce[4],
372         minMaxDMWCPNonce[5],
373         minMaxDMWCPNonce[6], 
374         minMaxDMWCPNonce[7]
375       );
376     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1]);
377     return orderRecord[tokenUser[1]][orderHash].coupon;
378   }
379 
380   function returnTokenDepositState(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external constant returns (bool) {
381     bytes32 orderHash = keccak256 (
382         tokenUser[0],
383         tokenUser[1],
384         minMaxDMWCPNonce[0],
385         minMaxDMWCPNonce[1],
386         minMaxDMWCPNonce[2], 
387         minMaxDMWCPNonce[3],
388         minMaxDMWCPNonce[4],
389         minMaxDMWCPNonce[5],
390         minMaxDMWCPNonce[6], 
391         minMaxDMWCPNonce[7]
392       );
393     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1]);
394     return orderRecord[tokenUser[1]][orderHash].tokenDeposit;
395   }
396  
397   function returnHash(address[2] tokenUser,uint[8] minMaxDMWCPNonce)  external pure returns (bytes32) {
398     return  
399       keccak256 (
400         tokenUser[0],
401         tokenUser[1],
402         minMaxDMWCPNonce[0],
403         minMaxDMWCPNonce[1],
404         minMaxDMWCPNonce[2], 
405         minMaxDMWCPNonce[3],
406         minMaxDMWCPNonce[4],
407         minMaxDMWCPNonce[5],
408         minMaxDMWCPNonce[6], 
409         minMaxDMWCPNonce[7]
410       );
411   }
412 
413 
414   function returnAddress(bytes32 orderHash,uint8 v,bytes32[2] rs) external pure returns (address) {
415     return ecrecover(orderHash,v,rs[0],rs[1]);
416   }
417 
418   function returnHashLong(address seller,uint[3] amountNonceExpiry)  external pure returns (bytes32) {
419     return keccak256(seller,amountNonceExpiry[0],amountNonceExpiry[1],amountNonceExpiry[2]);
420   }
421 
422   function returnLongAddress(bytes32 orderHash,uint8 v,bytes32[2] rs) external pure returns (address) {
423     return ecrecover(orderHash,v,rs[0],rs[1]);
424   }
425 
426 }