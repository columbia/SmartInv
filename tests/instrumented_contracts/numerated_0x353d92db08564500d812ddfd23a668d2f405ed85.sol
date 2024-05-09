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
77     bool public withdrawEnabled = false;
78     mapping(address => mapping(address => uint256)) public tokenList;
79     mapping(address => mapping(bytes32 => uint256)) public orderFilled;//tokens filled
80     mapping(bytes32 => bool) public withdrawn;
81     mapping(address => mapping(address => uint256)) public withdrawAllowance;
82     mapping(address => mapping(address => uint256)) public applyList;//withdraw apply list
83     mapping(address => mapping(address => uint)) public latestApply;//save the latest apply timestamp
84     uint public applyWait = 7 days;
85     uint public feeRate = 1;
86     event Deposit(address indexed token, address indexed user, uint256 amount, uint256 balance);
87     event Withdraw(address indexed token, address indexed user, uint256 amount, uint256 balance);
88     event ApplyWithdraw(address indexed token, address indexed user, uint256 amount, uint256 time);
89     modifier onlyAdmin {
90         require(admins[msg.sender]);
91         _;
92     }
93     modifier isWithdrawEnabled {
94         require(withdrawEnabled);
95         _;
96     }
97     modifier isFeeAccount(address fa) {
98         require(feeAccounts[fa]);
99         _;
100     }
101     function() public {
102         revert();
103     }
104     function setAdmin(address admin, bool isAdmin) public onlyOwner {
105         require(admin != 0);
106         admins[admin] = isAdmin;
107     }
108     function setFeeAccount(address acc, bool asFee) public onlyOwner {
109         require(acc != 0);
110         feeAccounts[acc] = asFee;
111     }
112     function enableWithdraw(bool enabled) public onlyOwner {
113         withdrawEnabled = enabled;
114     }
115     function changeLockTime(uint lock) public onlyOwner {
116         require(lock <= 7 days);
117         applyWait = lock;
118     }
119     function changeFeeRate(uint fr) public onlyOwner {
120         require(fr > 0);
121         feeRate = fr;
122     }
123     function deposit() public payable {
124         tokenList[0][msg.sender] = safeAdd(tokenList[0][msg.sender], msg.value);
125         Deposit(0, msg.sender, msg.value, tokenList[0][msg.sender]);
126     }
127     function depositToken(address token, uint256 amount) public {
128         require(token != 0);
129         tokenList[token][msg.sender] = safeAdd(tokenList[token][msg.sender], amount);
130         require(Token(token).transferFrom(msg.sender, this, amount));
131         Deposit(token, msg.sender, amount, tokenList[token][msg.sender]);
132     }
133     function applyWithdraw(address token, uint256 amount) public {
134         uint256 apply = safeAdd(applyList[token][msg.sender], amount);
135         require(safeAdd(apply, withdrawAllowance[token][msg.sender]) <= tokenList[token][msg.sender]);
136         applyList[token][msg.sender] = apply;
137         latestApply[token][msg.sender] = block.timestamp;
138         ApplyWithdraw(token, msg.sender, amount, block.timestamp);
139     }
140     /**
141     * approve user's withdraw application
142     **/
143     function approveWithdraw(address token, address user) public onlyAdmin {
144         withdrawAllowance[token][user] = safeAdd(withdrawAllowance[token][user], applyList[token][user]);
145         applyList[token][user] = 0;
146         latestApply[token][user] = 0;
147     }
148     /**
149     * user's withdraw will success in two cases:
150     *    1. when the admin calls the approveWithdraw function;
151     * or 2. when the lock time has passed since the application;
152     **/
153     function withdraw(address token, uint256 amount) public {
154         require(amount <= tokenList[token][msg.sender]);
155         if (amount > withdrawAllowance[token][msg.sender]) {
156             //withdraw wait over time
157             require(latestApply[token][msg.sender] != 0 && safeSub(block.timestamp, latestApply[token][msg.sender]) > applyWait);
158             withdrawAllowance[token][msg.sender] = safeAdd(withdrawAllowance[token][msg.sender], applyList[token][msg.sender]);
159             applyList[token][msg.sender] = 0;
160         }
161         require(amount <= withdrawAllowance[token][msg.sender]);
162         withdrawAllowance[token][msg.sender] = safeSub(withdrawAllowance[token][msg.sender], amount);
163         tokenList[token][msg.sender] = safeSub(tokenList[token][msg.sender], amount);
164         latestApply[token][msg.sender] = 0;
165         if (token == 0) {//withdraw ether
166             require(msg.sender.send(amount));
167         } else {//withdraw token
168             require(Token(token).transfer(msg.sender, amount));
169         }
170         Withdraw(token, msg.sender, amount, tokenList[token][msg.sender]);
171     }
172     /**
173     * withdraw directly when withdrawEnabled=true
174     **/
175     function withdrawNoLimit(address token, uint256 amount) public isWithdrawEnabled {
176         require(amount <= tokenList[token][msg.sender]);
177         tokenList[token][msg.sender] = safeSub(tokenList[token][msg.sender], amount);
178         if (token == 0) {//withdraw ether
179             require(msg.sender.send(amount));
180         } else {//withdraw token
181             require(Token(token).transfer(msg.sender, amount));
182         }
183         Withdraw(token, msg.sender, amount, tokenList[token][msg.sender]);
184     }
185     /**
186     * admin withdraw according to user's signed withdraw info
187     * PARAMS:
188     * addresses:
189     * [0] user
190     * [1] token
191     * [2] feeAccount
192     * values:
193     * [0] amount
194     * [1] nonce
195     * [2] fee
196     **/
197     function adminWithdraw(address[3] addresses, uint256[3] values, uint8 v, bytes32 r, bytes32 s)
198     public
199     onlyAdmin
200     isFeeAccount(addresses[2])
201     {
202         address user = addresses[0];
203         address token = addresses[1];
204         address feeAccount = addresses[2];
205         uint256 amount = values[0];
206         uint256 nonce = values[1];
207         uint256 fee = values[2];
208         require(amount <= tokenList[token][user]);
209         require(safeMul(fee, feeRate) < amount);
210         bytes32 hash = keccak256(user, token, amount, nonce);
211         require(!withdrawn[hash]);
212         withdrawn[hash] = true;
213         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user);
214         tokenList[token][user] = safeSub(tokenList[token][user], amount);
215         tokenList[token][feeAccount] = safeAdd(tokenList[token][feeAccount], fee);
216         amount = safeSub(amount, fee);
217         if (token == 0) {//withdraw ether
218             require(user.send(amount));
219         } else {//withdraw token
220             require(Token(token).transfer(user, amount));
221         }
222         Withdraw(token, user, amount, tokenList[token][user]);
223     }
224     function getOrderHash(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, address base, uint256 expires, uint256 nonce, address feeToken) public pure returns (bytes32) {
225         return keccak256(tokenBuy, amountBuy, tokenSell, amountSell, base, expires, nonce, feeToken);
226     }
227     function balanceOf(address token, address user) public constant returns (uint256) {
228         return tokenList[token][user];
229     }
230     struct Order {
231         address tokenBuy;
232         address tokenSell;
233         uint256 amountBuy;
234         uint256 amountSell;
235         address user;
236         uint256 fee;
237         uint256 expires;
238         uint256 nonce;
239         bytes32 orderHash;
240         address baseToken;
241         address feeToken;//0:default;others:payed with erc-20 token
242     }
243     /**
244     * swap maker and taker's tokens according to their signed order info.
245     *
246     * PARAMS:
247     * addresses:
248     * [0]:maker tokenBuy
249     * [1]:taker tokenBuy
250     * [2]:maker tokenSell
251     * [3]:taker tokenSell
252     * [4]:maker user
253     * [5]:taker user
254     * [6]:maker baseTokenAddr .default:0 ,then baseToken is ETH
255     * [7]:taker baseTokenAddr .default:0 ,then baseToken is ETH
256     * [8]:maker feeToken .
257     * [9]:taker feeToken .
258     * [10]:feeAccount
259     * values:
260     * [0]:maker amountBuy
261     * [1]:taker amountBuy
262     * [2]:maker amountSell
263     * [3]:taker amountSell
264     * [4]:maker fee
265     * [5]:taker fee
266     * [6]:maker expires
267     * [7]:taker expires
268     * [8]:maker nonce
269     * [9]:taker nonce
270     * [10]:tradeAmount of token
271     * v,r,s:maker and taker's signature
272     **/
273     function trade(
274         address[11] addresses,
275         uint256[11] values,
276         uint8[2] v,
277         bytes32[2] r,
278         bytes32[2] s
279     ) public
280     onlyAdmin
281     isFeeAccount(addresses[10])
282     {
283         Order memory makerOrder = Order({
284             tokenBuy : addresses[0],
285             tokenSell : addresses[2],
286             user : addresses[4],
287             amountBuy : values[0],
288             amountSell : values[2],
289             fee : values[4],
290             expires : values[6],
291             nonce : values[8],
292             orderHash : 0,
293             baseToken : addresses[6],
294             feeToken : addresses[8]
295             });
296         Order memory takerOrder = Order({
297             tokenBuy : addresses[1],
298             tokenSell : addresses[3],
299             user : addresses[5],
300             amountBuy : values[1],
301             amountSell : values[3],
302             fee : values[5],
303             expires : values[7],
304             nonce : values[9],
305             orderHash : 0,
306             baseToken : addresses[7],
307             feeToken : addresses[9]
308             });
309         uint256 tradeAmount = values[10];
310         //check expires
311         require(makerOrder.expires >= block.number && takerOrder.expires >= block.number);
312         //make sure both is the same trade pair
313         require(makerOrder.baseToken == takerOrder.baseToken && makerOrder.tokenBuy == takerOrder.tokenSell && makerOrder.tokenSell == takerOrder.tokenBuy);
314         require(takerOrder.baseToken == takerOrder.tokenBuy || takerOrder.baseToken == takerOrder.tokenSell);
315         makerOrder.orderHash = getOrderHash(makerOrder.tokenBuy, makerOrder.amountBuy, makerOrder.tokenSell, makerOrder.amountSell, makerOrder.baseToken, makerOrder.expires, makerOrder.nonce, makerOrder.feeToken);
316         takerOrder.orderHash = getOrderHash(takerOrder.tokenBuy, takerOrder.amountBuy, takerOrder.tokenSell, takerOrder.amountSell, takerOrder.baseToken, takerOrder.expires, takerOrder.nonce, takerOrder.feeToken);
317         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", makerOrder.orderHash), v[0], r[0], s[0]) == makerOrder.user);
318         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", takerOrder.orderHash), v[1], r[1], s[1]) == takerOrder.user);
319         balance(makerOrder, takerOrder, addresses[10], tradeAmount);
320     }
321     function balance(Order makerOrder, Order takerOrder, address feeAccount, uint256 tradeAmount) internal {
322         ///check the price meets the condition.
323         ///match condition: (makerOrder.amountSell*takerOrder.amountSell)/(makerOrder.amountBuy*takerOrder.amountBuy) >=1
324         require(safeMul(makerOrder.amountSell, takerOrder.amountSell) >= safeMul(makerOrder.amountBuy, takerOrder.amountBuy));
325         ///If the price is ok,always use maker's price first!
326         uint256 takerBuy = 0;
327         uint256 takerSell = 0;
328         if (takerOrder.baseToken == takerOrder.tokenBuy) {
329             //taker sell tokens
330             uint256 makerAmount = safeSub(makerOrder.amountBuy, orderFilled[makerOrder.user][makerOrder.orderHash]);
331             uint256 takerAmount = safeSub(takerOrder.amountSell, orderFilled[takerOrder.user][takerOrder.orderHash]);
332             require(tradeAmount > 0 && tradeAmount <= makerAmount && tradeAmount <= takerAmount);
333             takerSell = tradeAmount;
334             takerBuy = safeMul(makerOrder.amountSell, takerSell) / makerOrder.amountBuy;
335             orderFilled[takerOrder.user][takerOrder.orderHash] = safeAdd(orderFilled[takerOrder.user][takerOrder.orderHash], takerSell);
336             orderFilled[makerOrder.user][makerOrder.orderHash] = safeAdd(orderFilled[makerOrder.user][makerOrder.orderHash], takerSell);
337         } else {
338             // taker buy tokens
339             takerAmount = safeSub(takerOrder.amountBuy, orderFilled[takerOrder.user][takerOrder.orderHash]);
340             makerAmount = safeSub(makerOrder.amountSell, orderFilled[makerOrder.user][makerOrder.orderHash]);
341             require(tradeAmount > 0 && tradeAmount <= makerAmount && tradeAmount <= takerAmount);
342             takerBuy = tradeAmount;
343             takerSell = safeMul(makerOrder.amountBuy, takerBuy) / makerOrder.amountSell;
344             orderFilled[takerOrder.user][takerOrder.orderHash] = safeAdd(orderFilled[takerOrder.user][takerOrder.orderHash], takerBuy);
345             orderFilled[makerOrder.user][makerOrder.orderHash] = safeAdd(orderFilled[makerOrder.user][makerOrder.orderHash], takerBuy);
346         }
347         uint256 makerFee = chargeFee(makerOrder, feeAccount, takerSell);
348         uint256 takerFee = chargeFee(takerOrder, feeAccount, takerBuy);
349         //taker give tokens
350         tokenList[takerOrder.tokenSell][takerOrder.user] = safeSub(tokenList[takerOrder.tokenSell][takerOrder.user], takerSell);
351         //taker get tokens
352         tokenList[takerOrder.tokenBuy][takerOrder.user] = safeAdd(tokenList[takerOrder.tokenBuy][takerOrder.user], safeSub(takerBuy, takerFee));
353         //maker give tokens
354         tokenList[makerOrder.tokenSell][makerOrder.user] = safeSub(tokenList[makerOrder.tokenSell][makerOrder.user], takerBuy);
355         //maker get tokens
356         tokenList[makerOrder.tokenBuy][makerOrder.user] = safeAdd(tokenList[makerOrder.tokenBuy][makerOrder.user], safeSub(takerSell, makerFee));
357     }
358     ///charge fees.fee can be payed as other erc20 token or the tokens that user get
359     ///returns:fees to reduce from the user's tokenBuy
360     function chargeFee(Order order, address feeAccount, uint256 amountBuy) internal returns (uint256){
361         uint256 classicFee = 0;
362         if (order.feeToken != 0) {
363             ///use erc-20 token as fee .
364             //make sure the user has enough tokens
365             require(order.fee <= tokenList[order.feeToken][order.user]);
366             tokenList[order.feeToken][feeAccount] = safeAdd(tokenList[order.feeToken][feeAccount], order.fee);
367             tokenList[order.feeToken][order.user] = safeSub(tokenList[order.feeToken][order.user], order.fee);
368         } else {
369             classicFee = order.fee;
370             require(safeMul(order.fee, feeRate) <= amountBuy);
371             tokenList[order.tokenBuy][feeAccount] = safeAdd(tokenList[order.tokenBuy][feeAccount], order.fee);
372         }
373         return classicFee;
374     }
375     function batchTrade(
376         address[11][] addresses,
377         uint256[11][] values,
378         uint8[2][] v,
379         bytes32[2][] r,
380         bytes32[2][] s
381     ) public onlyAdmin {
382         for (uint i = 0; i < addresses.length; i++) {
383             trade(addresses[i], values[i], v[i], r[i], s[i]);
384         }
385     }
386     ///help to refund token to users.this method is called when contract needs updating
387     function refund(address user, address[] tokens) public onlyAdmin {
388         for (uint i = 0; i < tokens.length; i++) {
389             address token = tokens[i];
390             uint256 amount = tokenList[token][user];
391             if (amount > 0) {
392                 tokenList[token][user] = 0;
393                 if (token == 0) {//withdraw ether
394                     require(user.send(amount));
395                 } else {//withdraw token
396                     require(Token(token).transfer(user, amount));
397                 }
398                 Withdraw(token, user, amount, tokenList[token][user]);
399             }
400         }
401     }
402 }