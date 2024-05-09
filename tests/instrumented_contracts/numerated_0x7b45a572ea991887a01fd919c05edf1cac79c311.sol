1 ///auto-generated single file for verifying contract on etherscan
2 pragma solidity ^0.4.20;
3 
4 contract SafeMath {
5 
6     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
7         uint256 z = _x + _y;
8         assert(z >= _x);
9         return z;
10     }
11 
12     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
13         assert(_x >= _y);
14         return _x - _y;
15     }
16 
17     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
18         uint256 z = _x * _y;
19         assert(_x == 0 || z / _x == _y);
20         return z;
21     }
22 }
23 
24 contract Ownable {
25     address public owner;
26 
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30 
31     /**
32      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33      * account.
34      */
35     function Ownable() public {
36         owner = msg.sender;
37     }
38 
39     /**
40      * @dev Throws if called by any account other than the owner.
41      */
42     modifier onlyOwner() {
43         require(msg.sender == owner);
44         _;
45     }
46 
47     /**
48      * @dev Allows the current owner to transfer control of the contract to a newOwner.
49      * @param newOwner The address to transfer ownership to.
50      */
51     function transferOwnership(address newOwner) public onlyOwner {
52         require(newOwner != address(0));
53         OwnershipTransferred(owner, newOwner);
54         owner = newOwner;
55     }
56 }
57 
58 contract Token {
59     uint256 public totalSupply;
60 
61     function balanceOf(address _owner) public constant returns (uint256 balance);
62 
63     function transfer(address _to, uint256 _value) public returns (bool success);
64 
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
66 
67     function approve(address _spender, uint256 _value) public returns (bool success);
68 
69     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 }
74 contract R1Exchange is SafeMath, Ownable {
75     mapping(address => bool) public admins;
76     mapping(address => bool) public feeAccounts;
77     mapping(address => mapping(address => uint256)) public tokenList;
78     mapping(address => mapping(bytes32 => uint256)) public orderFilled;//tokens filled
79     mapping(bytes32 => bool) public withdrawn;
80     mapping(address => mapping(address => uint256)) public withdrawAllowance;
81     mapping(address => mapping(address => uint256)) public applyList;//withdraw apply list
82     mapping(address => mapping(address => uint)) public latestApply;//save the latest apply timestamp
83     mapping(address => uint256) public canceled;
84     uint public applyWait = 1 days;
85     uint public feeRate = 10;
86     bool public withdrawEnabled = false;
87     bool public stop = false;
88     event Deposit(address indexed token, address indexed user, uint256 amount, uint256 balance);
89     event DepositTo(address indexed token, address indexed from, address indexed user, uint256 amount, uint256 balance);
90     event Withdraw(address indexed token, address indexed user, uint256 amount, uint256 balance);
91     event ApplyWithdraw(address indexed token, address indexed user, uint256 amount, uint256 time);
92     event Trade(address indexed maker, address indexed taker, uint256 amount, uint256 makerFee, uint256 takerFee, uint256 makerNonce, uint256 takerNonce);
93     modifier onlyAdmin {
94         require(admins[msg.sender]);
95         _;
96     }
97     modifier isWithdrawEnabled {
98         require(withdrawEnabled);
99         _;
100     }
101     modifier isFeeAccount(address fa) {
102         require(feeAccounts[fa]);
103         _;
104     }
105     modifier notStop() {
106         require(!stop);
107         _;
108     }
109     function() public {
110         revert();
111     }
112     function setAdmin(address admin, bool isAdmin) public onlyOwner {
113         require(admin != 0);
114         admins[admin] = isAdmin;
115     }
116     function setFeeAccount(address acc, bool asFee) public onlyOwner {
117         require(acc != 0);
118         feeAccounts[acc] = asFee;
119     }
120     function enableWithdraw(bool enabled) public onlyOwner {
121         withdrawEnabled = enabled;
122     }
123     function changeLockTime(uint lock) public onlyOwner {
124         require(lock <= 7 days);
125         applyWait = lock;
126     }
127     function changeFeeRate(uint fr) public onlyOwner {
128         //max fee rate MUST <=10%
129         require(fr >= 10);
130         feeRate = fr;
131     }
132     function stopTrade() public onlyOwner {
133         stop = true;
134     }
135     /**
136     * cancel the order that before nonce.
137     **/
138     function batchCancel(address[] users, uint256[] nonces) public onlyAdmin {
139         require(users.length == nonces.length);
140         for (uint i = 0; i < users.length; i++) {
141             require(nonces[i] >= canceled[users[i]]);
142             canceled[users[i]] = nonces[i];
143         }
144     }
145     function deposit() public payable {
146         tokenList[0][msg.sender] = safeAdd(tokenList[0][msg.sender], msg.value);
147         Deposit(0, msg.sender, msg.value, tokenList[0][msg.sender]);
148     }
149     function depositToken(address token, uint256 amount) public {
150         require(token != 0);
151         tokenList[token][msg.sender] = safeAdd(tokenList[token][msg.sender], amount);
152         require(Token(token).transferFrom(msg.sender, this, amount));
153         Deposit(token, msg.sender, amount, tokenList[token][msg.sender]);
154     }
155     function depositTo(address token, address to, uint256 amount) public {
156         require(token != 0 && to != 0);
157         tokenList[token][to] = safeAdd(tokenList[token][to], amount);
158         require(Token(token).transferFrom(msg.sender, this, amount));
159         DepositTo(token, msg.sender, to, amount, tokenList[token][to]);
160     }
161     function batchDepositTo(address token, address[] to, uint256[] amount) public {
162         require(to.length == amount.length && to.length <= 200);
163         for (uint i = 0; i < to.length; i++) {
164             depositTo(token, to[i], amount[i]);
165         }
166     }
167     function applyWithdraw(address token, uint256 amount) public {
168         uint256 apply = safeAdd(applyList[token][msg.sender], amount);
169         require(safeAdd(apply, withdrawAllowance[token][msg.sender]) <= tokenList[token][msg.sender]);
170         applyList[token][msg.sender] = apply;
171         latestApply[token][msg.sender] = block.timestamp;
172         ApplyWithdraw(token, msg.sender, amount, block.timestamp);
173     }
174     /**
175     * approve user's withdraw application
176     **/
177     function approveWithdraw(address token, address user) public onlyAdmin {
178         withdrawAllowance[token][user] = safeAdd(withdrawAllowance[token][user], applyList[token][user]);
179         applyList[token][user] = 0;
180         latestApply[token][user] = 0;
181     }
182     /**
183     * user's withdraw will success in two cases:
184     *    1. when the admin calls the approveWithdraw function;
185     * or 2. when the lock time has passed since the application;
186     **/
187     function withdraw(address token, uint256 amount) public {
188         require(amount <= tokenList[token][msg.sender]);
189         if (amount > withdrawAllowance[token][msg.sender]) {
190             //withdraw wait over time
191             require(latestApply[token][msg.sender] != 0 && safeSub(block.timestamp, latestApply[token][msg.sender]) > applyWait);
192             withdrawAllowance[token][msg.sender] = safeAdd(withdrawAllowance[token][msg.sender], applyList[token][msg.sender]);
193             applyList[token][msg.sender] = 0;
194         }
195         require(amount <= withdrawAllowance[token][msg.sender]);
196         withdrawAllowance[token][msg.sender] = safeSub(withdrawAllowance[token][msg.sender], amount);
197         tokenList[token][msg.sender] = safeSub(tokenList[token][msg.sender], amount);
198         latestApply[token][msg.sender] = 0;
199         if (token == 0) {//withdraw ether
200             require(msg.sender.send(amount));
201         } else {//withdraw token
202             require(Token(token).transfer(msg.sender, amount));
203         }
204         Withdraw(token, msg.sender, amount, tokenList[token][msg.sender]);
205     }
206     /**
207     * withdraw directly when withdrawEnabled=true
208     **/
209     function withdrawNoLimit(address token, uint256 amount) public isWithdrawEnabled {
210         require(amount <= tokenList[token][msg.sender]);
211         tokenList[token][msg.sender] = safeSub(tokenList[token][msg.sender], amount);
212         if (token == 0) {//withdraw ether
213             require(msg.sender.send(amount));
214         } else {//withdraw token
215             require(Token(token).transfer(msg.sender, amount));
216         }
217         Withdraw(token, msg.sender, amount, tokenList[token][msg.sender]);
218     }
219     /**
220     * admin withdraw according to user's signed withdraw info
221     * PARAMS:
222     * addresses:
223     * [0] user
224     * [1] token
225     * [2] feeAccount
226     * values:
227     * [0] amount
228     * [1] nonce
229     * [2] fee
230     **/
231     function adminWithdraw(address[3] addresses, uint256[3] values, uint8 v, bytes32 r, bytes32 s)
232     public
233     onlyAdmin
234     isFeeAccount(addresses[2])
235     {
236         address user = addresses[0];
237         address token = addresses[1];
238         address feeAccount = addresses[2];
239         uint256 amount = values[0];
240         uint256 nonce = values[1];
241         uint256 fee = values[2];
242         require(amount <= tokenList[token][user]);
243         fee = checkFee(amount, fee);
244         bytes32 hash = keccak256(this, user, token, amount, nonce);
245         require(!withdrawn[hash]);
246         withdrawn[hash] = true;
247         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user);
248         tokenList[token][user] = safeSub(tokenList[token][user], amount);
249         tokenList[token][feeAccount] = safeAdd(tokenList[token][feeAccount], fee);
250         amount = safeSub(amount, fee);
251         if (token == 0) {//withdraw ether
252             require(user.send(amount));
253         } else {//withdraw token
254             require(Token(token).transfer(user, amount));
255         }
256         Withdraw(token, user, amount, tokenList[token][user]);
257     }
258     function checkFee(uint256 amount, uint256 fee) private returns (uint256){
259         uint256 maxFee = fee;
260         if (safeMul(fee, feeRate) > amount) {
261             maxFee = amount / feeRate;
262         }
263         return maxFee;
264     }
265     function getOrderHash(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, address base, uint256 expires, uint256 nonce, address feeToken) public view returns (bytes32) {
266         return keccak256(this, tokenBuy, amountBuy, tokenSell, amountSell, base, expires, nonce, feeToken);
267     }
268     function balanceOf(address token, address user) public constant returns (uint256) {
269         return tokenList[token][user];
270     }
271     struct Order {
272         address tokenBuy;
273         address tokenSell;
274         uint256 amountBuy;
275         uint256 amountSell;
276         address user;
277         uint256 fee;
278         uint256 expires;
279         uint256 nonce;
280         bytes32 orderHash;
281         address baseToken;
282         address feeToken;//0:default;others:payed with erc-20 token
283     }
284     /**
285     * swap maker and taker's tokens according to their signed order info.
286     *
287     * PARAMS:
288     * addresses:
289     * [0]:maker tokenBuy
290     * [1]:taker tokenBuy
291     * [2]:maker tokenSell
292     * [3]:taker tokenSell
293     * [4]:maker user
294     * [5]:taker user
295     * [6]:maker baseTokenAddr .default:0 ,then baseToken is ETH
296     * [7]:taker baseTokenAddr .default:0 ,then baseToken is ETH
297     * [8]:maker feeToken .
298     * [9]:taker feeToken .
299     * [10]:feeAccount
300     * values:
301     * [0]:maker amountBuy
302     * [1]:taker amountBuy
303     * [2]:maker amountSell
304     * [3]:taker amountSell
305     * [4]:maker fee
306     * [5]:taker fee
307     * [6]:maker expires
308     * [7]:taker expires
309     * [8]:maker nonce
310     * [9]:taker nonce
311     * [10]:tradeAmount of token
312     * v,r,s:maker and taker's signature
313     **/
314     function trade(
315         address[11] addresses,
316         uint256[11] values,
317         uint8[2] v,
318         bytes32[2] r,
319         bytes32[2] s
320     ) public
321     onlyAdmin
322     isFeeAccount(addresses[10])
323     notStop
324     {
325         Order memory makerOrder = Order({
326             tokenBuy : addresses[0],
327             tokenSell : addresses[2],
328             user : addresses[4],
329             amountBuy : values[0],
330             amountSell : values[2],
331             fee : values[4],
332             expires : values[6],
333             nonce : values[8],
334             orderHash : 0,
335             baseToken : addresses[6],
336             feeToken : addresses[8]
337             });
338         Order memory takerOrder = Order({
339             tokenBuy : addresses[1],
340             tokenSell : addresses[3],
341             user : addresses[5],
342             amountBuy : values[1],
343             amountSell : values[3],
344             fee : values[5],
345             expires : values[7],
346             nonce : values[9],
347             orderHash : 0,
348             baseToken : addresses[7],
349             feeToken : addresses[9]
350             });
351         uint256 tradeAmount = values[10];
352         //check expires
353         require(makerOrder.expires >= block.number && takerOrder.expires >= block.number);
354         //check order nonce canceled
355         require(makerOrder.nonce >= canceled[makerOrder.user] && takerOrder.nonce >= canceled[takerOrder.user]);
356         //make sure both is the same trade pair
357         require(makerOrder.baseToken == takerOrder.baseToken && makerOrder.tokenBuy == takerOrder.tokenSell && makerOrder.tokenSell == takerOrder.tokenBuy);
358         require(takerOrder.baseToken == takerOrder.tokenBuy || takerOrder.baseToken == takerOrder.tokenSell);
359         makerOrder.orderHash = getOrderHash(makerOrder.tokenBuy, makerOrder.amountBuy, makerOrder.tokenSell, makerOrder.amountSell, makerOrder.baseToken, makerOrder.expires, makerOrder.nonce, makerOrder.feeToken);
360         takerOrder.orderHash = getOrderHash(takerOrder.tokenBuy, takerOrder.amountBuy, takerOrder.tokenSell, takerOrder.amountSell, takerOrder.baseToken, takerOrder.expires, takerOrder.nonce, takerOrder.feeToken);
361         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", makerOrder.orderHash), v[0], r[0], s[0]) == makerOrder.user);
362         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", takerOrder.orderHash), v[1], r[1], s[1]) == takerOrder.user);
363         balance(makerOrder, takerOrder, addresses[10], tradeAmount);
364         //emit event
365         Trade(makerOrder.user, takerOrder.user, tradeAmount, makerOrder.fee, takerOrder.fee, makerOrder.nonce, takerOrder.nonce);
366     }
367     function balance(Order makerOrder, Order takerOrder, address feeAccount, uint256 tradeAmount) internal {
368         ///check the price meets the condition.
369         ///match condition: (makerOrder.amountSell*takerOrder.amountSell)/(makerOrder.amountBuy*takerOrder.amountBuy) >=1
370         require(safeMul(makerOrder.amountSell, takerOrder.amountSell) >= safeMul(makerOrder.amountBuy, takerOrder.amountBuy));
371         ///If the price is ok,always use maker's price first!
372         uint256 takerBuy = 0;
373         uint256 takerSell = 0;
374         if (takerOrder.baseToken == takerOrder.tokenBuy) {
375             //taker sell tokens
376             uint256 makerAmount = safeSub(makerOrder.amountBuy, orderFilled[makerOrder.user][makerOrder.orderHash]);
377             uint256 takerAmount = safeSub(takerOrder.amountSell, orderFilled[takerOrder.user][takerOrder.orderHash]);
378             require(tradeAmount > 0 && tradeAmount <= makerAmount && tradeAmount <= takerAmount);
379             takerSell = tradeAmount;
380             takerBuy = safeMul(makerOrder.amountSell, takerSell) / makerOrder.amountBuy;
381             orderFilled[takerOrder.user][takerOrder.orderHash] = safeAdd(orderFilled[takerOrder.user][takerOrder.orderHash], takerSell);
382             orderFilled[makerOrder.user][makerOrder.orderHash] = safeAdd(orderFilled[makerOrder.user][makerOrder.orderHash], takerSell);
383         } else {
384             // taker buy tokens
385             takerAmount = safeSub(takerOrder.amountBuy, orderFilled[takerOrder.user][takerOrder.orderHash]);
386             makerAmount = safeSub(makerOrder.amountSell, orderFilled[makerOrder.user][makerOrder.orderHash]);
387             require(tradeAmount > 0 && tradeAmount <= makerAmount && tradeAmount <= takerAmount);
388             takerBuy = tradeAmount;
389             takerSell = safeMul(makerOrder.amountBuy, takerBuy) / makerOrder.amountSell;
390             orderFilled[takerOrder.user][takerOrder.orderHash] = safeAdd(orderFilled[takerOrder.user][takerOrder.orderHash], takerBuy);
391             orderFilled[makerOrder.user][makerOrder.orderHash] = safeAdd(orderFilled[makerOrder.user][makerOrder.orderHash], takerBuy);
392         }
393         uint256 makerFee = chargeFee(makerOrder, feeAccount, takerSell);
394         uint256 takerFee = chargeFee(takerOrder, feeAccount, takerBuy);
395         //taker give tokens
396         tokenList[takerOrder.tokenSell][takerOrder.user] = safeSub(tokenList[takerOrder.tokenSell][takerOrder.user], takerSell);
397         //taker get tokens
398         tokenList[takerOrder.tokenBuy][takerOrder.user] = safeAdd(tokenList[takerOrder.tokenBuy][takerOrder.user], safeSub(takerBuy, takerFee));
399         //maker give tokens
400         tokenList[makerOrder.tokenSell][makerOrder.user] = safeSub(tokenList[makerOrder.tokenSell][makerOrder.user], takerBuy);
401         //maker get tokens
402         tokenList[makerOrder.tokenBuy][makerOrder.user] = safeAdd(tokenList[makerOrder.tokenBuy][makerOrder.user], safeSub(takerSell, makerFee));
403     }
404     ///charge fees.fee can be payed as other erc20 token or the tokens that user get
405     ///returns:fees to reduce from the user's tokenBuy
406     function chargeFee(Order order, address feeAccount, uint256 amountBuy) internal returns (uint256){
407         uint256 classicFee = 0;
408         if (order.feeToken != 0) {
409             ///use erc-20 token as fee .
410             //make sure the user has enough tokens
411             require(order.fee <= tokenList[order.feeToken][order.user]);
412             tokenList[order.feeToken][feeAccount] = safeAdd(tokenList[order.feeToken][feeAccount], order.fee);
413             tokenList[order.feeToken][order.user] = safeSub(tokenList[order.feeToken][order.user], order.fee);
414         } else {
415             order.fee = checkFee(amountBuy, order.fee);
416             classicFee = order.fee;
417             tokenList[order.tokenBuy][feeAccount] = safeAdd(tokenList[order.tokenBuy][feeAccount], order.fee);
418         }
419         return classicFee;
420     }
421     function batchTrade(
422         address[11][] addresses,
423         uint256[11][] values,
424         uint8[2][] v,
425         bytes32[2][] r,
426         bytes32[2][] s
427     ) public onlyAdmin {
428         for (uint i = 0; i < addresses.length; i++) {
429             trade(addresses[i], values[i], v[i], r[i], s[i]);
430         }
431     }
432     ///help to refund token to users.this method is called when contract needs updating
433     function refund(address user, address[] tokens) public onlyAdmin {
434         for (uint i = 0; i < tokens.length; i++) {
435             address token = tokens[i];
436             uint256 amount = tokenList[token][user];
437             if (amount > 0) {
438                 tokenList[token][user] = 0;
439                 if (token == 0) {//withdraw ether
440                     require(user.send(amount));
441                 } else {//withdraw token
442                     require(Token(token).transfer(user, amount));
443                 }
444                 Withdraw(token, user, amount, tokenList[token][user]);
445             }
446         }
447     }
448 }