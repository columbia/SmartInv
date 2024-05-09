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
82   event TokenFulfillment(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint amount);
83   event CouponDeposit(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint value);
84   event LongPlace(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint value);
85   event LongBought(address[2] sellerShort,uint[5] amountNonceExpiryDM,uint value);
86   event TokenLongExercised(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint couponAmount,uint amount);
87   event EthLongExercised(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint couponAmount,uint amount);
88   event DonationClaimed(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint coupon,uint balance);
89   event NonActivationWithdrawal(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint coupon);
90   event ActivationWithdrawal(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint balance);
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
123       orderRecord[msg.sender][orderHash].balance == safeMul(amount,minMaxDMWCPNonce[6]) &&
124       !orderRecord[msg.sender][orderHash].tokenDeposit
125     );
126     Token(tokenUser[0]).transferFrom(msg.sender,this,amount);
127     orderRecord[msg.sender][orderHash].shortBalance[tokenUser[0]] = safeAdd(orderRecord[msg.sender][orderHash].shortBalance[tokenUser[0]],amount);
128     orderRecord[msg.sender][orderHash].tokenDeposit = true;
129     TokenFulfillment(tokenUser,minMaxDMWCPNonce,amount);
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
151     CouponDeposit(tokenUser,minMaxDMWCPNonce,msg.value);
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
175     LongPlace(tokenUser,minMaxDMWCPNonce,msg.value);
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
194     LongBought(sellerShort,amountNonceExpiryDM,amountNonceExpiryDM[0]);
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
216     uint couponProportion = safeDiv(safeMul(orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender],100),orderRecord[tokenUser[1]][orderHash].balance);
217     uint couponAmount = safeDiv(safeMul(orderRecord[tokenUser[1]][orderHash].coupon,safeSub(100,couponProportion)),100);
218     if(orderRecord[msg.sender][orderHash].tokenDeposit) {
219       uint amount = safeDiv(safeMul(orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[0]],safeSub(100,couponProportion)),100);
220       msg.sender.transfer(couponAmount);
221       Token(tokenUser[0]).transfer(msg.sender,amount);
222       orderRecord[tokenUser[1]][orderHash].coupon = safeSub(orderRecord[tokenUser[1]][orderHash].coupon,couponAmount);
223       orderRecord[tokenUser[1]][orderHash].balance = safeSub(orderRecord[tokenUser[1]][orderHash].balance,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
224       orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[0]] = safeSub(orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[0]],amount);
225       orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = uint(0);
226       TokenLongExercised(tokenUser,minMaxDMWCPNonce,couponAmount,amount);
227     }
228     else if(!orderRecord[msg.sender][orderHash].tokenDeposit){
229       msg.sender.transfer(safeAdd(couponAmount,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]));
230       orderRecord[tokenUser[1]][orderHash].coupon = safeSub(orderRecord[tokenUser[1]][orderHash].coupon,couponAmount);
231       orderRecord[tokenUser[1]][orderHash].balance = safeSub(orderRecord[tokenUser[1]][orderHash].balance,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
232       orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = uint(0); 
233       EthLongExercised(tokenUser,minMaxDMWCPNonce,couponAmount,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
234     }
235   }
236 
237   function claimDonations(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external onlyAdmin {
238     bytes32 orderHash = keccak256 (
239         tokenUser[0],
240         tokenUser[1],
241         minMaxDMWCPNonce[0],
242         minMaxDMWCPNonce[1],
243         minMaxDMWCPNonce[2], 
244         minMaxDMWCPNonce[3],
245         minMaxDMWCPNonce[4],
246         minMaxDMWCPNonce[5],
247         minMaxDMWCPNonce[6], 
248         minMaxDMWCPNonce[7]
249       );
250     require(
251       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1] &&
252       block.number > minMaxDMWCPNonce[4]
253     );
254     admin.transfer(safeAdd(orderRecord[tokenUser[1]][orderHash].coupon,orderRecord[tokenUser[1]][orderHash].balance));
255     Token(tokenUser[0]).transfer(admin,orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[0]]);
256     orderRecord[tokenUser[1]][orderHash].balance = uint(0);
257     orderRecord[tokenUser[1]][orderHash].coupon = uint(0);
258     orderRecord[tokenUser[1]][orderHash].shortBalance[tokenUser[0]] = uint(0);
259     DonationClaimed(tokenUser,minMaxDMWCPNonce,orderRecord[tokenUser[1]][orderHash].coupon,orderRecord[tokenUser[1]][orderHash].balance);
260   }
261 
262   function nonActivationShortWithdrawal(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external {
263     bytes32 orderHash = keccak256 (
264         tokenUser[0],
265         tokenUser[1],
266         minMaxDMWCPNonce[0],
267         minMaxDMWCPNonce[1],
268         minMaxDMWCPNonce[2], 
269         minMaxDMWCPNonce[3],
270         minMaxDMWCPNonce[4],
271         minMaxDMWCPNonce[5],
272         minMaxDMWCPNonce[6], 
273         minMaxDMWCPNonce[7]
274       );
275     require(
276       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == msg.sender &&
277       block.number > minMaxDMWCPNonce[2] &&
278       orderRecord[tokenUser[1]][orderHash].balance < minMaxDMWCPNonce[0]
279     );
280     msg.sender.transfer(orderRecord[msg.sender][orderHash].coupon);
281     orderRecord[msg.sender][orderHash].coupon = uint(0);
282     NonActivationWithdrawal(tokenUser,minMaxDMWCPNonce,orderRecord[msg.sender][orderHash].coupon);
283   }
284 
285   function nonActivationWithdrawal(address[2] tokenUser,uint[8] minMaxDMWCPNonce,uint8 v,bytes32[2] rs) external {
286     bytes32 orderHash = keccak256 (
287         tokenUser[0],
288         tokenUser[1],
289         minMaxDMWCPNonce[0],
290         minMaxDMWCPNonce[1],
291         minMaxDMWCPNonce[2], 
292         minMaxDMWCPNonce[3],
293         minMaxDMWCPNonce[4],
294         minMaxDMWCPNonce[5],
295         minMaxDMWCPNonce[6], 
296         minMaxDMWCPNonce[7]
297       );
298     require(
299       ecrecover(keccak256("\x19Ethereum Signed Message:\n32",orderHash),v,rs[0],rs[1]) == tokenUser[1] &&
300       block.number > minMaxDMWCPNonce[2] &&
301       block.number <= minMaxDMWCPNonce[4] &&
302       orderRecord[tokenUser[1]][orderHash].balance < minMaxDMWCPNonce[0]
303     );
304     msg.sender.transfer(orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
305     orderRecord[tokenUser[1]][orderHash].balance = safeSub(orderRecord[tokenUser[1]][orderHash].balance,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
306     orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender] = uint(0);
307     ActivationWithdrawal(tokenUser,minMaxDMWCPNonce,orderRecord[tokenUser[1]][orderHash].longBalance[msg.sender]);
308   }
309 
310   function returnBalance(address _creator,bytes32 orderHash) external constant returns (uint) {
311     return orderRecord[_creator][orderHash].balance;
312   }
313 
314   function returnTokenBalance(address[2] creatorToken,bytes32 orderHash) external constant returns (uint) {
315     return orderRecord[creatorToken[0]][orderHash].shortBalance[creatorToken[1]];
316   }
317 
318   function returnUserBalance(address[2] creatorUser,bytes32 orderHash) external constant returns (uint) {
319     return orderRecord[creatorUser[0]][orderHash].longBalance[creatorUser[1]];
320   }
321 
322   function returnCoupon(address _creator,bytes32 orderHash) external constant returns (uint) {
323     return orderRecord[_creator][orderHash].coupon;
324   }
325 
326   function returnTokenDepositState(address _creator,bytes32 orderHash) external constant returns (bool) {
327     return orderRecord[_creator][orderHash].tokenDeposit;
328   }
329  
330   function returnHash(address[2] tokenUser,uint[8] minMaxDMWCPNonce)  external pure returns (bytes32) {
331     return  
332       keccak256 (
333         tokenUser[0],
334         tokenUser[1],
335         minMaxDMWCPNonce[0],
336         minMaxDMWCPNonce[1],
337         minMaxDMWCPNonce[2], 
338         minMaxDMWCPNonce[3],
339         minMaxDMWCPNonce[4],
340         minMaxDMWCPNonce[5],
341         minMaxDMWCPNonce[6], 
342         minMaxDMWCPNonce[7]
343       );
344   }
345 
346 
347   function returnAddress(bytes32 orderHash,uint8 v,bytes32[2] rs) external pure returns (address) {
348     return ecrecover(orderHash,v,rs[0],rs[1]);
349   }
350 
351   function returnHashLong(address seller,uint[3] amountNonceExpiry)  external pure returns (bytes32) {
352     return keccak256(seller,amountNonceExpiry[0],amountNonceExpiry[1],amountNonceExpiry[2]);
353   }
354 
355   function returnLongAddress(bytes32 orderHash,uint8 v,bytes32[2] rs) external pure returns (address) {
356     return ecrecover(orderHash,v,rs[0],rs[1]);
357   }
358 
359   function returnCouponProportion(address[3] tokenUserSender,bytes32 orderHash) external view returns (uint){
360     return safeDiv(safeMul(orderRecord[tokenUserSender[1]][orderHash].longBalance[tokenUserSender[2]],100),orderRecord[tokenUserSender[1]][orderHash].balance);
361   }
362 
363   function returnLongCouponAmount(address[3] tokenUserSender,bytes32 orderHash,uint couponProportion) external view returns (uint) {
364     return safeDiv(safeMul(orderRecord[tokenUserSender[1]][orderHash].coupon,safeSub(100,couponProportion)),100);
365   }
366 
367   function returnLongTokenAmount(address[3] tokenUserSender,bytes32 orderHash,uint couponProportion) external view returns (uint) {
368     return safeDiv(safeMul(orderRecord[tokenUserSender[1]][orderHash].shortBalance[tokenUserSender[0]],safeSub(100,couponProportion)),100);
369   }
370 
371 }