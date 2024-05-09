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
89     event Withdraw(address indexed token, address indexed user, uint256 amount, uint256 balance);
90     event ApplyWithdraw(address indexed token, address indexed user, uint256 amount, uint256 time);
91     event Trade(address indexed maker, address indexed taker, uint256 amount, uint256 makerFee, uint256 takerFee, uint256 makerNonce, uint256 takerNonce);
92     modifier onlyAdmin {
93         require(admins[msg.sender]);
94         _;
95     }
96     modifier isWithdrawEnabled {
97         require(withdrawEnabled);
98         _;
99     }
100     modifier isFeeAccount(address fa) {
101         require(feeAccounts[fa]);
102         _;
103     }
104     modifier notStop() {
105         require(!stop);
106         _;
107     }
108     function() public {
109         revert();
110     }
111     function setAdmin(address admin, bool isAdmin) public onlyOwner {
112         require(admin != 0);
113         admins[admin] = isAdmin;
114     }
115     function setFeeAccount(address acc, bool asFee) public onlyOwner {
116         require(acc != 0);
117         feeAccounts[acc] = asFee;
118     }
119     function enableWithdraw(bool enabled) public onlyOwner {
120         withdrawEnabled = enabled;
121     }
122     function changeLockTime(uint lock) public onlyOwner {
123         require(lock <= 7 days);
124         applyWait = lock;
125     }
126     function changeFeeRate(uint fr) public onlyOwner {
127         //max fee rate MUST <=10%
128         require(fr >= 10);
129         feeRate = fr;
130     }
131     function stopTrade() public onlyOwner {
132         stop = true;
133     }
134     /**
135     * cancel the order that before nonce.
136     **/
137     function batchCancel(address[] users, uint256[] nonces) public onlyAdmin {
138         require(users.length == nonces.length);
139         for (uint i = 0; i < users.length; i++) {
140             require(nonces[i] >= canceled[users[i]]);
141             canceled[users[i]] = nonces[i];
142         }
143     }
144     function deposit() public payable {
145         tokenList[0][msg.sender] = safeAdd(tokenList[0][msg.sender], msg.value);
146         Deposit(0, msg.sender, msg.value, tokenList[0][msg.sender]);
147     }
148     function depositToken(address token, uint256 amount) public {
149         require(token != 0);
150         tokenList[token][msg.sender] = safeAdd(tokenList[token][msg.sender], amount);
151         require(Token(token).transferFrom(msg.sender, this, amount));
152         Deposit(token, msg.sender, amount, tokenList[token][msg.sender]);
153     }
154     function applyWithdraw(address token, uint256 amount) public {
155         uint256 apply = safeAdd(applyList[token][msg.sender], amount);
156         require(safeAdd(apply, withdrawAllowance[token][msg.sender]) <= tokenList[token][msg.sender]);
157         applyList[token][msg.sender] = apply;
158         latestApply[token][msg.sender] = block.timestamp;
159         ApplyWithdraw(token, msg.sender, amount, block.timestamp);
160     }
161     /**
162     * approve user's withdraw application
163     **/
164     function approveWithdraw(address token, address user) public onlyAdmin {
165         withdrawAllowance[token][user] = safeAdd(withdrawAllowance[token][user], applyList[token][user]);
166         applyList[token][user] = 0;
167         latestApply[token][user] = 0;
168     }
169     /**
170     * user's withdraw will success in two cases:
171     *    1. when the admin calls the approveWithdraw function;
172     * or 2. when the lock time has passed since the application;
173     **/
174     function withdraw(address token, uint256 amount) public {
175         require(amount <= tokenList[token][msg.sender]);
176         if (amount > withdrawAllowance[token][msg.sender]) {
177             //withdraw wait over time
178             require(latestApply[token][msg.sender] != 0 && safeSub(block.timestamp, latestApply[token][msg.sender]) > applyWait);
179             withdrawAllowance[token][msg.sender] = safeAdd(withdrawAllowance[token][msg.sender], applyList[token][msg.sender]);
180             applyList[token][msg.sender] = 0;
181         }
182         require(amount <= withdrawAllowance[token][msg.sender]);
183         withdrawAllowance[token][msg.sender] = safeSub(withdrawAllowance[token][msg.sender], amount);
184         tokenList[token][msg.sender] = safeSub(tokenList[token][msg.sender], amount);
185         latestApply[token][msg.sender] = 0;
186         if (token == 0) {//withdraw ether
187             require(msg.sender.send(amount));
188         } else {//withdraw token
189             require(Token(token).transfer(msg.sender, amount));
190         }
191         Withdraw(token, msg.sender, amount, tokenList[token][msg.sender]);
192     }
193     /**
194     * withdraw directly when withdrawEnabled=true
195     **/
196     function withdrawNoLimit(address token, uint256 amount) public isWithdrawEnabled {
197         require(amount <= tokenList[token][msg.sender]);
198         tokenList[token][msg.sender] = safeSub(tokenList[token][msg.sender], amount);
199         if (token == 0) {//withdraw ether
200             require(msg.sender.send(amount));
201         } else {//withdraw token
202             require(Token(token).transfer(msg.sender, amount));
203         }
204         Withdraw(token, msg.sender, amount, tokenList[token][msg.sender]);
205     }
206     /**
207     * admin withdraw according to user's signed withdraw info
208     * PARAMS:
209     * addresses:
210     * [0] user
211     * [1] token
212     * [2] feeAccount
213     * values:
214     * [0] amount
215     * [1] nonce
216     * [2] fee
217     **/
218     function adminWithdraw(address[3] addresses, uint256[3] values, uint8 v, bytes32 r, bytes32 s)
219     public
220     onlyAdmin
221     isFeeAccount(addresses[2])
222     {
223         address user = addresses[0];
224         address token = addresses[1];
225         address feeAccount = addresses[2];
226         uint256 amount = values[0];
227         uint256 nonce = values[1];
228         uint256 fee = values[2];
229         require(amount <= tokenList[token][user]);
230         fee = checkFee(amount, fee);
231         bytes32 hash = keccak256(this,user, token, amount, nonce);
232         require(!withdrawn[hash]);
233         withdrawn[hash] = true;
234         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user);
235         tokenList[token][user] = safeSub(tokenList[token][user], amount);
236         tokenList[token][feeAccount] = safeAdd(tokenList[token][feeAccount], fee);
237         amount = safeSub(amount, fee);
238         if (token == 0) {//withdraw ether
239             require(user.send(amount));
240         } else {//withdraw token
241             require(Token(token).transfer(user, amount));
242         }
243         Withdraw(token, user, amount, tokenList[token][user]);
244     }
245     function checkFee(uint256 amount, uint256 fee) private returns (uint256){
246         uint256 maxFee = fee;
247         if (safeMul(fee, feeRate) > amount) {
248             maxFee = amount / feeRate;
249         }
250         return maxFee;
251     }
252     function getOrderHash(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, address base, uint256 expires, uint256 nonce, address feeToken) public view returns (bytes32) {
253         return keccak256(this,tokenBuy, amountBuy, tokenSell, amountSell, base, expires, nonce, feeToken);
254     }
255     function balanceOf(address token, address user) public constant returns (uint256) {
256         return tokenList[token][user];
257     }
258     struct Order {
259         address tokenBuy;
260         address tokenSell;
261         uint256 amountBuy;
262         uint256 amountSell;
263         address user;
264         uint256 fee;
265         uint256 expires;
266         uint256 nonce;
267         bytes32 orderHash;
268         address baseToken;
269         address feeToken;//0:default;others:payed with erc-20 token
270     }
271     /**
272     * swap maker and taker's tokens according to their signed order info.
273     *
274     * PARAMS:
275     * addresses:
276     * [0]:maker tokenBuy
277     * [1]:taker tokenBuy
278     * [2]:maker tokenSell
279     * [3]:taker tokenSell
280     * [4]:maker user
281     * [5]:taker user
282     * [6]:maker baseTokenAddr .default:0 ,then baseToken is ETH
283     * [7]:taker baseTokenAddr .default:0 ,then baseToken is ETH
284     * [8]:maker feeToken .
285     * [9]:taker feeToken .
286     * [10]:feeAccount
287     * values:
288     * [0]:maker amountBuy
289     * [1]:taker amountBuy
290     * [2]:maker amountSell
291     * [3]:taker amountSell
292     * [4]:maker fee
293     * [5]:taker fee
294     * [6]:maker expires
295     * [7]:taker expires
296     * [8]:maker nonce
297     * [9]:taker nonce
298     * [10]:tradeAmount of token
299     * v,r,s:maker and taker's signature
300     **/
301     function trade(
302         address[11] addresses,
303         uint256[11] values,
304         uint8[2] v,
305         bytes32[2] r,
306         bytes32[2] s
307     ) public
308     onlyAdmin
309     isFeeAccount(addresses[10])
310     notStop
311     {
312         Order memory makerOrder = Order({
313             tokenBuy : addresses[0],
314             tokenSell : addresses[2],
315             user : addresses[4],
316             amountBuy : values[0],
317             amountSell : values[2],
318             fee : values[4],
319             expires : values[6],
320             nonce : values[8],
321             orderHash : 0,
322             baseToken : addresses[6],
323             feeToken : addresses[8]
324             });
325         Order memory takerOrder = Order({
326             tokenBuy : addresses[1],
327             tokenSell : addresses[3],
328             user : addresses[5],
329             amountBuy : values[1],
330             amountSell : values[3],
331             fee : values[5],
332             expires : values[7],
333             nonce : values[9],
334             orderHash : 0,
335             baseToken : addresses[7],
336             feeToken : addresses[9]
337             });
338         uint256 tradeAmount = values[10];
339         //check expires
340         require(makerOrder.expires >= block.number && takerOrder.expires >= block.number);
341         //check order nonce canceled
342         require(makerOrder.nonce >= canceled[makerOrder.user] && takerOrder.nonce >= canceled[takerOrder.user]);
343         //make sure both is the same trade pair
344         require(makerOrder.baseToken == takerOrder.baseToken && makerOrder.tokenBuy == takerOrder.tokenSell && makerOrder.tokenSell == takerOrder.tokenBuy);
345         require(takerOrder.baseToken == takerOrder.tokenBuy || takerOrder.baseToken == takerOrder.tokenSell);
346         makerOrder.orderHash = getOrderHash(makerOrder.tokenBuy, makerOrder.amountBuy, makerOrder.tokenSell, makerOrder.amountSell, makerOrder.baseToken, makerOrder.expires, makerOrder.nonce, makerOrder.feeToken);
347         takerOrder.orderHash = getOrderHash(takerOrder.tokenBuy, takerOrder.amountBuy, takerOrder.tokenSell, takerOrder.amountSell, takerOrder.baseToken, takerOrder.expires, takerOrder.nonce, takerOrder.feeToken);
348         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", makerOrder.orderHash), v[0], r[0], s[0]) == makerOrder.user);
349         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", takerOrder.orderHash), v[1], r[1], s[1]) == takerOrder.user);
350         balance(makerOrder, takerOrder, addresses[10], tradeAmount);
351         //emit event
352         Trade(makerOrder.user, takerOrder.user, tradeAmount, makerOrder.fee, takerOrder.fee, makerOrder.nonce, takerOrder.nonce);
353     }
354     function balance(Order makerOrder, Order takerOrder, address feeAccount, uint256 tradeAmount) internal {
355         ///check the price meets the condition.
356         ///match condition: (makerOrder.amountSell*takerOrder.amountSell)/(makerOrder.amountBuy*takerOrder.amountBuy) >=1
357         require(safeMul(makerOrder.amountSell, takerOrder.amountSell) >= safeMul(makerOrder.amountBuy, takerOrder.amountBuy));
358         ///If the price is ok,always use maker's price first!
359         uint256 takerBuy = 0;
360         uint256 takerSell = 0;
361         if (takerOrder.baseToken == takerOrder.tokenBuy) {
362             //taker sell tokens
363             uint256 makerAmount = safeSub(makerOrder.amountBuy, orderFilled[makerOrder.user][makerOrder.orderHash]);
364             uint256 takerAmount = safeSub(takerOrder.amountSell, orderFilled[takerOrder.user][takerOrder.orderHash]);
365             require(tradeAmount > 0 && tradeAmount <= makerAmount && tradeAmount <= takerAmount);
366             takerSell = tradeAmount;
367             takerBuy = safeMul(makerOrder.amountSell, takerSell) / makerOrder.amountBuy;
368             orderFilled[takerOrder.user][takerOrder.orderHash] = safeAdd(orderFilled[takerOrder.user][takerOrder.orderHash], takerSell);
369             orderFilled[makerOrder.user][makerOrder.orderHash] = safeAdd(orderFilled[makerOrder.user][makerOrder.orderHash], takerSell);
370         } else {
371             // taker buy tokens
372             takerAmount = safeSub(takerOrder.amountBuy, orderFilled[takerOrder.user][takerOrder.orderHash]);
373             makerAmount = safeSub(makerOrder.amountSell, orderFilled[makerOrder.user][makerOrder.orderHash]);
374             require(tradeAmount > 0 && tradeAmount <= makerAmount && tradeAmount <= takerAmount);
375             takerBuy = tradeAmount;
376             takerSell = safeMul(makerOrder.amountBuy, takerBuy) / makerOrder.amountSell;
377             orderFilled[takerOrder.user][takerOrder.orderHash] = safeAdd(orderFilled[takerOrder.user][takerOrder.orderHash], takerBuy);
378             orderFilled[makerOrder.user][makerOrder.orderHash] = safeAdd(orderFilled[makerOrder.user][makerOrder.orderHash], takerBuy);
379         }
380         uint256 makerFee = chargeFee(makerOrder, feeAccount, takerSell);
381         uint256 takerFee = chargeFee(takerOrder, feeAccount, takerBuy);
382         //taker give tokens
383         tokenList[takerOrder.tokenSell][takerOrder.user] = safeSub(tokenList[takerOrder.tokenSell][takerOrder.user], takerSell);
384         //taker get tokens
385         tokenList[takerOrder.tokenBuy][takerOrder.user] = safeAdd(tokenList[takerOrder.tokenBuy][takerOrder.user], safeSub(takerBuy, takerFee));
386         //maker give tokens
387         tokenList[makerOrder.tokenSell][makerOrder.user] = safeSub(tokenList[makerOrder.tokenSell][makerOrder.user], takerBuy);
388         //maker get tokens
389         tokenList[makerOrder.tokenBuy][makerOrder.user] = safeAdd(tokenList[makerOrder.tokenBuy][makerOrder.user], safeSub(takerSell, makerFee));
390     }
391     ///charge fees.fee can be payed as other erc20 token or the tokens that user get
392     ///returns:fees to reduce from the user's tokenBuy
393     function chargeFee(Order order, address feeAccount, uint256 amountBuy) internal returns (uint256){
394         uint256 classicFee = 0;
395         if (order.feeToken != 0) {
396             ///use erc-20 token as fee .
397             //make sure the user has enough tokens
398             require(order.fee <= tokenList[order.feeToken][order.user]);
399             tokenList[order.feeToken][feeAccount] = safeAdd(tokenList[order.feeToken][feeAccount], order.fee);
400             tokenList[order.feeToken][order.user] = safeSub(tokenList[order.feeToken][order.user], order.fee);
401         } else {
402             order.fee = checkFee(amountBuy, order.fee);
403             classicFee = order.fee;
404             tokenList[order.tokenBuy][feeAccount] = safeAdd(tokenList[order.tokenBuy][feeAccount], order.fee);
405         }
406         return classicFee;
407     }
408     function batchTrade(
409         address[11][] addresses,
410         uint256[11][] values,
411         uint8[2][] v,
412         bytes32[2][] r,
413         bytes32[2][] s
414     ) public onlyAdmin {
415         for (uint i = 0; i < addresses.length; i++) {
416             trade(addresses[i], values[i], v[i], r[i], s[i]);
417         }
418     }
419     ///help to refund token to users.this method is called when contract needs updating
420     function refund(address user, address[] tokens) public onlyAdmin {
421         for (uint i = 0; i < tokens.length; i++) {
422             address token = tokens[i];
423             uint256 amount = tokenList[token][user];
424             if (amount > 0) {
425                 tokenList[token][user] = 0;
426                 if (token == 0) {//withdraw ether
427                     require(user.send(amount));
428                 } else {//withdraw token
429                     require(Token(token).transfer(user, amount));
430                 }
431                 Withdraw(token, user, amount, tokenList[token][user]);
432             }
433         }
434     }
435 }