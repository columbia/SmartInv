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
77     // mapping(token address => mapping(owner address => mapping(channelId uint => uint256))) public tokenList;
78     mapping(address => mapping(address => mapping(uint256 => uint256))) public tokenList;
79     // mapping(owner address =>  mapping(orderHash bytes32 => uint256)) public tokenList;
80     mapping(address => mapping(bytes32 => uint256)) public orderFilled;//tokens filled
81     mapping(bytes32 => bool) public withdrawn;
82     mapping(address => mapping(address => mapping(uint256 => uint256))) public withdrawAllowance;
83     mapping(address => mapping(address => mapping(uint256 => uint256))) public applyList;//withdraw apply list
84     mapping(address => mapping(address => mapping(uint256 => uint))) public latestApply;//save the latest apply timestamp
85     // mapping(owner address => mapping(channelId uint => nonce uint256))) public canceled;
86     mapping(address => mapping(uint256 => uint)) public canceled;
87     string public constant version = '2.0.0';
88     uint public applyWait = 1 days;
89     uint public feeRate = 10;
90     bool public withdrawEnabled = false;
91     bool public stop = false;
92     uint256 private DEFAULT_CHANNEL_ID = 0;
93     bool public depositToEnabled = true;
94     bool public transferEnabled = false;
95     bool public changeChannelEnabled = false;
96     event Deposit(address indexed token, address indexed user, uint256 amount, uint256 balance, uint256 channelId);
97     event DepositTo(address indexed token, address indexed from, address indexed user, uint256 amount, uint256 balance, uint256 channelId);
98     event Withdraw(address indexed token, address indexed user, uint256 amount, uint256 balance, uint256 channelId);
99     event ApplyWithdraw(address indexed token, address indexed user, uint256 amount, uint256 time, uint256 channelId);
100     event ApproveWithdraw(address indexed token, address indexed user, uint256 channelId);
101     event Trade(address indexed maker, address indexed taker, uint256 amount, uint256 makerFee, uint256 takerFee, uint256 makerNonce, uint256 takerNonce);
102     event InnerTransfer(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 balance, uint256 channelId);
103     event ChangeChannel(address indexed token, address indexed user, uint256 amount, uint256 fromChannelId, uint256 toChannelId);
104     event BatchCancel(uint256 count, uint256 channelId);
105     modifier onlyAdmin {
106         require(admins[msg.sender]);
107         _;
108     }
109     modifier isWithdrawEnabled {
110         require(withdrawEnabled);
111         _;
112     }
113     modifier isFeeAccount(address fa) {
114         require(feeAccounts[fa]);
115         _;
116     }
117     modifier notStop() {
118         require(!stop);
119         _;
120     }
121     modifier isDepositToEnabled() {
122         require(depositToEnabled);
123         _;
124     }
125     modifier isTransferEnabled() {
126         require(transferEnabled);
127         _;
128     }
129     modifier isChangeChannelEnabled() {
130         require(changeChannelEnabled);
131         _;
132     }
133     function() public {
134         revert();
135     }
136     function setAdmin(address admin, bool isAdmin) public onlyOwner {
137         require(admin != 0);
138         admins[admin] = isAdmin;
139     }
140     function setFeeAccount(address acc, bool asFee) public onlyOwner {
141         require(acc != 0);
142         feeAccounts[acc] = asFee;
143     }
144     function enableWithdraw(bool enabled) public onlyOwner {
145         withdrawEnabled = enabled;
146     }
147     function enableDepositTo(bool enabled) public onlyOwner {
148         depositToEnabled = enabled;
149     }
150     function enableTransfer(bool enabled) public onlyOwner {
151         transferEnabled = enabled;
152     }
153     function enableChangeChannel(bool enabled) public onlyOwner {
154         changeChannelEnabled = enabled;
155     }
156     function changeLockTime(uint lock) public onlyOwner {
157         require(lock <= 7 days);
158         applyWait = lock;
159     }
160     function changeFeeRate(uint fr) public onlyOwner {
161         //max fee rate MUST <=10%
162         require(fr >= 10);
163         feeRate = fr;
164     }
165     function stopTrade() public onlyOwner {
166         stop = true;
167     }
168     /**
169     * cancel the order that before nonce.
170     **/
171     function batchCancel(address[] users, uint256[] nonces, uint256 channelId) public onlyAdmin {
172         require(users.length == nonces.length);
173         uint256 count = 0;
174         for (uint i = 0; i < users.length; i++) {
175             require(nonces[i] >= canceled[users[i]][channelId]);
176             canceled[users[i]][channelId] = nonces[i];
177             count++;
178         }
179         BatchCancel(count, channelId);
180     }
181     function deposit(uint256 channelId) public payable {
182         tokenList[0][msg.sender][channelId] = safeAdd(tokenList[0][msg.sender][channelId], msg.value);
183         Deposit(0, msg.sender, msg.value, tokenList[0][msg.sender][channelId], channelId);
184     }
185     function depositToken(address token, uint256 amount, uint256 channelId) public {
186         require(token != 0);
187         tokenList[token][msg.sender][channelId] = safeAdd(tokenList[token][msg.sender][channelId], amount);
188         require(Token(token).transferFrom(msg.sender, this, amount));
189         Deposit(token, msg.sender, amount, tokenList[token][msg.sender][channelId], channelId);
190     }
191     function depositTo(address to, uint256 channelId) public payable isDepositToEnabled {
192         require(to != 0 && msg.value > 0);
193         tokenList[0][to][channelId] = safeAdd(tokenList[0][to][channelId], msg.value);
194         DepositTo(0, msg.sender, to, msg.value, tokenList[0][to][channelId], channelId);
195     }
196     function depositTokenTo(address token, address to, uint256 amount, uint256 channelId) public isDepositToEnabled {
197         require(token != 0 && to != 0 && amount > 0);
198         tokenList[token][to][channelId] = safeAdd(tokenList[token][to][channelId], amount);
199         require(Token(token).transferFrom(msg.sender, this, amount));
200         DepositTo(token, msg.sender, to, amount, tokenList[token][to][channelId], channelId);
201     }
202     function batchDepositTokenTo(address[] token, address[] to, uint256[] amount, uint256 channelId) public isDepositToEnabled {
203         require(to.length == amount.length && to.length <= 200);
204         for (uint i = 0; i < to.length; i++) {
205             depositTokenTo(token[i], to[i], amount[i], channelId);
206         }
207     }
208     function innerTransfer(address token, address to, uint256 amount, uint256 channelId) public isTransferEnabled {
209         require(to != 0);
210         require(amount <= tokenList[token][msg.sender][channelId]);
211         tokenList[token][msg.sender][channelId] = safeSub(tokenList[token][msg.sender][channelId], amount);
212         tokenList[token][to][channelId] = safeAdd(tokenList[token][to][channelId], amount);
213         InnerTransfer(token, msg.sender, to, amount, tokenList[token][msg.sender][channelId], channelId);
214     }
215     function batchInnerTransfer(address[] token, address[] to, uint256[] amount, uint256 channelId) public isTransferEnabled {
216         require(to.length == amount.length && to.length <= 200);
217         for (uint i = 0; i < to.length; i++) {
218             innerTransfer(token[i], to[i], amount[i], channelId);
219         }
220     }
221     function changeChannel(address token, uint256 amount, uint256 fromChannelId, uint256 toChannelId) public isChangeChannelEnabled {
222         require(amount <= tokenList[token][msg.sender][fromChannelId]);
223         tokenList[token][msg.sender][fromChannelId] = safeSub(tokenList[token][msg.sender][fromChannelId], amount);
224         tokenList[token][msg.sender][toChannelId] = safeAdd(tokenList[token][msg.sender][toChannelId], amount);
225         ChangeChannel(token, msg.sender, amount, fromChannelId, toChannelId);
226     }
227     function batchChangeChannel(address[] token, uint256[] amount, uint256 fromChannelId, uint256 toChannelId) public isChangeChannelEnabled {
228         require(token.length == amount.length && amount.length <= 200);
229         for (uint i = 0; i < amount.length; i++) {
230             changeChannel(token[i], amount[i], fromChannelId, toChannelId);
231         }
232     }
233     function applyWithdraw(address token, uint256 amount, uint256 channelId) public {
234         uint256 apply = safeAdd(applyList[token][msg.sender][channelId], amount);
235         require(safeAdd(apply, withdrawAllowance[token][msg.sender][channelId]) <= tokenList[token][msg.sender][channelId]);
236         applyList[token][msg.sender][channelId] = apply;
237         latestApply[token][msg.sender][channelId] = block.timestamp;
238         ApplyWithdraw(token, msg.sender, amount, block.timestamp, channelId);
239     }
240     /**
241     * approve user's withdraw application
242     **/
243     function approveWithdraw(address token, address user, uint256 channelId) public onlyAdmin {
244         withdrawAllowance[token][user][channelId] = safeAdd(withdrawAllowance[token][user][channelId], applyList[token][user][channelId]);
245         applyList[token][user][channelId] = 0;
246         latestApply[token][user][channelId] = 0;
247         ApproveWithdraw(token, user, channelId);
248     }
249     /**
250     * user's withdraw will success in two cases:
251     *    1. when the admin calls the approveWithdraw function;
252     * or 2. when the lock time has passed since the application;
253     **/
254     function withdraw(address token, uint256 amount, uint256 channelId) public {
255         require(amount <= tokenList[token][msg.sender][channelId]);
256         if (amount > withdrawAllowance[token][msg.sender][channelId]) {
257             //withdraw wait over time
258             require(latestApply[token][msg.sender][channelId] != 0 && safeSub(block.timestamp, latestApply[token][msg.sender][channelId]) > applyWait);
259             withdrawAllowance[token][msg.sender][channelId] = safeAdd(withdrawAllowance[token][msg.sender][channelId], applyList[token][msg.sender][channelId]);
260             applyList[token][msg.sender][channelId] = 0;
261         }
262         require(amount <= withdrawAllowance[token][msg.sender][channelId]);
263         withdrawAllowance[token][msg.sender][channelId] = safeSub(withdrawAllowance[token][msg.sender][channelId], amount);
264         tokenList[token][msg.sender][channelId] = safeSub(tokenList[token][msg.sender][channelId], amount);
265         latestApply[token][msg.sender][channelId] = 0;
266         if (token == 0) {//withdraw ether
267             require(msg.sender.send(amount));
268         } else {//withdraw token
269             require(Token(token).transfer(msg.sender, amount));
270         }
271         Withdraw(token, msg.sender, amount, tokenList[token][msg.sender][channelId], channelId);
272     }
273     /**
274     * withdraw directly when withdrawEnabled=true
275     **/
276     function withdrawNoLimit(address token, uint256 amount, uint256 channelId) public isWithdrawEnabled {
277         require(amount <= tokenList[token][msg.sender][channelId]);
278         tokenList[token][msg.sender][channelId] = safeSub(tokenList[token][msg.sender][channelId], amount);
279         if (token == 0) {//withdraw ether
280             require(msg.sender.send(amount));
281         } else {//withdraw token
282             require(Token(token).transfer(msg.sender, amount));
283         }
284         Withdraw(token, msg.sender, amount, tokenList[token][msg.sender][channelId], channelId);
285     }
286     struct AdminWithdrawParam {
287         address user;
288         address token;
289         address feeAccount;
290         address channelFeeAccount;
291         uint256 amount;
292         uint256 nonce;
293         uint256 fee;
294         uint256 channelFee;
295         uint256 channelId;
296     }
297     /**
298     * admin withdraw according to user's signed withdraw info
299     * PARAMS:
300     * addresses:
301     * [0] user
302     * [1] token
303     * [2] feeAccount
304     * [3] channelFeeAccount
305     * values:
306     * [0] amount
307     * [1] nonce
308     * [2] fee
309     * [3] channelFee
310     * [4] channelId
311     **/
312     function adminWithdraw(address[4] addresses, uint256[5] values, uint8 v, bytes32 r, bytes32 s)
313     public
314     onlyAdmin
315     isFeeAccount(addresses[2])
316     {
317         AdminWithdrawParam memory param = AdminWithdrawParam({
318             user : addresses[0],
319             token : addresses[1],
320             feeAccount : addresses[2],
321             channelFeeAccount : addresses[3],
322             amount : values[0],
323             nonce : values[1],
324             fee : values[2],
325             channelFee : values[3],
326             channelId : values[4]
327             });
328         require(param.amount <= tokenList[param.token][param.user][param.channelId]);
329         param.fee = checkFee(param.amount, param.fee);
330         param.channelFee = checkFee(param.amount, param.channelFee);
331         bytes32 hash = keccak256(this, param.user, param.token, param.amount, param.nonce, param.channelFeeAccount, param.channelId);
332         require(!withdrawn[hash]);
333         withdrawn[hash] = true;
334         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == param.user);
335         tokenList[param.token][param.user][param.channelId] = safeSub(tokenList[param.token][param.user][param.channelId], param.amount);
336         tokenList[param.token][param.feeAccount][DEFAULT_CHANNEL_ID] = safeAdd(tokenList[param.token][param.feeAccount][DEFAULT_CHANNEL_ID], param.fee);
337         tokenList[param.token][param.channelFeeAccount][param.channelId] = safeAdd(tokenList[param.token][param.channelFeeAccount][param.channelId], param.channelFee);
338         param.amount = safeSub(param.amount, param.fee);
339         param.amount = safeSub(param.amount, param.channelFee);
340         if (param.token == 0) {//withdraw ether
341             require(param.user.send(param.amount));
342         } else {//withdraw token
343             require(Token(param.token).transfer(param.user, param.amount));
344         }
345         Withdraw(param.token, param.user, param.amount, tokenList[param.token][param.user][param.channelId], param.channelId);
346     }
347     function checkFee(uint256 amount, uint256 fee) private returns (uint256){
348         uint256 maxFee = fee;
349         if (safeMul(fee, feeRate) > amount) {
350             maxFee = amount / feeRate;
351         }
352         return maxFee;
353     }
354     function getOrderHash(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, address base, uint256 expires, uint256 nonce, address feeToken, address channelFeeAccount, uint256 channelId) public view returns (bytes32) {
355         return keccak256(this, tokenBuy, amountBuy, tokenSell, amountSell, base, expires, nonce, feeToken, channelFeeAccount, channelId);
356     }
357     function balanceOf(address token, address user, uint256 channelId) public constant returns (uint256) {
358         return tokenList[token][user][channelId];
359     }
360     struct Order {
361         address tokenBuy;
362         address tokenSell;
363         uint256 amountBuy;
364         uint256 amountSell;
365         address user;
366         uint256 fee;
367         uint256 expires;
368         uint256 nonce;
369         bytes32 orderHash;
370         address baseToken;
371         address feeToken;//0:default;others:payed with erc-20 token
372         address channelFeeAccount;
373         uint256 channelFee;
374         uint256 channelId;
375     }
376     /**
377     * swap maker and taker's tokens according to their signed order info.
378     *
379     * PARAMS:
380     * addresses:
381     * [0]:maker tokenBuy
382     * [1]:taker tokenBuy
383     * [2]:maker tokenSell
384     * [3]:taker tokenSell
385     * [4]:maker user
386     * [5]:taker user
387     * [6]:maker baseTokenAddr .default:0 ,then baseToken is ETH
388     * [7]:taker baseTokenAddr .default:0 ,then baseToken is ETH
389     * [8]:maker feeToken .
390     * [9]:taker feeToken .
391     * [10]:feeAccount
392     * [11]:makerChannelAccount
393     * [12]:takerChannelAccount
394     * values:
395     * [0]:maker amountBuy
396     * [1]:taker amountBuy
397     * [2]:maker amountSell
398     * [3]:taker amountSell
399     * [4]:maker fee
400     * [5]:taker fee
401     * [6]:maker expires
402     * [7]:taker expires
403     * [8]:maker nonce
404     * [9]:taker nonce
405     * [10]:tradeAmount of token
406     * [11]:makerChannelFee
407     * [12]:takerChannelFee
408     * [13]:makerChannelId
409     * [14]:takerChannelId
410     * v,r,s:maker and taker's signature
411     **/
412     function trade(
413         address[13] addresses,
414         uint256[15] values,
415         uint8[2] v,
416         bytes32[2] r,
417         bytes32[2] s
418     ) public
419     onlyAdmin
420     isFeeAccount(addresses[10])
421     notStop
422     {
423         Order memory makerOrder = Order({
424             tokenBuy : addresses[0],
425             tokenSell : addresses[2],
426             user : addresses[4],
427             amountBuy : values[0],
428             amountSell : values[2],
429             fee : values[4],
430             expires : values[6],
431             nonce : values[8],
432             orderHash : 0,
433             baseToken : addresses[6],
434             feeToken : addresses[8],
435             channelFeeAccount : addresses[11],
436             channelFee : values[11],
437             channelId : values[13]
438             });
439         Order memory takerOrder = Order({
440             tokenBuy : addresses[1],
441             tokenSell : addresses[3],
442             user : addresses[5],
443             amountBuy : values[1],
444             amountSell : values[3],
445             fee : values[5],
446             expires : values[7],
447             nonce : values[9],
448             orderHash : 0,
449             baseToken : addresses[7],
450             feeToken : addresses[9],
451             channelFeeAccount : addresses[12],
452             channelFee : values[12],
453             channelId : values[14]
454             });
455         uint256 tradeAmount = values[10];
456         //check expires
457         require(makerOrder.expires >= block.number && takerOrder.expires >= block.number);
458         //check order nonce canceled
459         require(makerOrder.nonce >= canceled[makerOrder.user][makerOrder.channelId] && takerOrder.nonce >= canceled[takerOrder.user][takerOrder.channelId]);
460         //make sure both is the same trade pair
461         require(makerOrder.baseToken == takerOrder.baseToken && makerOrder.tokenBuy == takerOrder.tokenSell && makerOrder.tokenSell == takerOrder.tokenBuy);
462         require(takerOrder.baseToken == takerOrder.tokenBuy || takerOrder.baseToken == takerOrder.tokenSell);
463         makerOrder.orderHash = getOrderHash(makerOrder.tokenBuy, makerOrder.amountBuy, makerOrder.tokenSell, makerOrder.amountSell, makerOrder.baseToken, makerOrder.expires, makerOrder.nonce, makerOrder.feeToken, makerOrder.channelFeeAccount, makerOrder.channelId);
464         takerOrder.orderHash = getOrderHash(takerOrder.tokenBuy, takerOrder.amountBuy, takerOrder.tokenSell, takerOrder.amountSell, takerOrder.baseToken, takerOrder.expires, takerOrder.nonce, takerOrder.feeToken, takerOrder.channelFeeAccount, takerOrder.channelId);
465         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", makerOrder.orderHash), v[0], r[0], s[0]) == makerOrder.user);
466         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", takerOrder.orderHash), v[1], r[1], s[1]) == takerOrder.user);
467         balance(makerOrder, takerOrder, addresses[10], tradeAmount);
468         //event
469         Trade(makerOrder.user, takerOrder.user, tradeAmount, makerOrder.fee, takerOrder.fee, makerOrder.nonce, takerOrder.nonce);
470     }
471     function balance(Order makerOrder, Order takerOrder, address feeAccount, uint256 tradeAmount) internal {
472         ///check the price meets the condition.
473         ///match condition: (makerOrder.amountSell*takerOrder.amountSell)/(makerOrder.amountBuy*takerOrder.amountBuy) >=1
474         require(safeMul(makerOrder.amountSell, takerOrder.amountSell) >= safeMul(makerOrder.amountBuy, takerOrder.amountBuy));
475         ///If the price is ok,always use maker's price first!
476         uint256 takerBuy = 0;
477         uint256 takerSell = 0;
478         if (takerOrder.baseToken == takerOrder.tokenBuy) {
479             //taker sell tokens
480             uint256 makerAmount = safeSub(makerOrder.amountBuy, orderFilled[makerOrder.user][makerOrder.orderHash]);
481             uint256 takerAmount = safeSub(takerOrder.amountSell, orderFilled[takerOrder.user][takerOrder.orderHash]);
482             require(tradeAmount > 0 && tradeAmount <= makerAmount && tradeAmount <= takerAmount);
483             takerSell = tradeAmount;
484             takerBuy = safeMul(makerOrder.amountSell, takerSell) / makerOrder.amountBuy;
485             orderFilled[takerOrder.user][takerOrder.orderHash] = safeAdd(orderFilled[takerOrder.user][takerOrder.orderHash], takerSell);
486             orderFilled[makerOrder.user][makerOrder.orderHash] = safeAdd(orderFilled[makerOrder.user][makerOrder.orderHash], takerSell);
487         } else {
488             // taker buy tokens
489             takerAmount = safeSub(takerOrder.amountBuy, orderFilled[takerOrder.user][takerOrder.orderHash]);
490             makerAmount = safeSub(makerOrder.amountSell, orderFilled[makerOrder.user][makerOrder.orderHash]);
491             require(tradeAmount > 0 && tradeAmount <= makerAmount && tradeAmount <= takerAmount);
492             takerBuy = tradeAmount;
493             takerSell = safeMul(makerOrder.amountBuy, takerBuy) / makerOrder.amountSell;
494             orderFilled[takerOrder.user][takerOrder.orderHash] = safeAdd(orderFilled[takerOrder.user][takerOrder.orderHash], takerBuy);
495             orderFilled[makerOrder.user][makerOrder.orderHash] = safeAdd(orderFilled[makerOrder.user][makerOrder.orderHash], takerBuy);
496         }
497         //taker give tokens
498         tokenList[takerOrder.tokenSell][takerOrder.user][takerOrder.channelId] = safeSub(tokenList[takerOrder.tokenSell][takerOrder.user][takerOrder.channelId], takerSell);
499         //taker get tokens
500         tokenList[takerOrder.tokenBuy][takerOrder.user][takerOrder.channelId] = safeAdd(tokenList[takerOrder.tokenBuy][takerOrder.user][takerOrder.channelId], takerBuy);
501         //maker give tokens
502         tokenList[makerOrder.tokenSell][makerOrder.user][makerOrder.channelId] = safeSub(tokenList[makerOrder.tokenSell][makerOrder.user][makerOrder.channelId], takerBuy);
503         //maker get tokens
504         tokenList[makerOrder.tokenBuy][makerOrder.user][makerOrder.channelId] = safeAdd(tokenList[makerOrder.tokenBuy][makerOrder.user][makerOrder.channelId], takerSell);
505         chargeFee(makerOrder, feeAccount, takerSell);
506         chargeFee(takerOrder, feeAccount, takerBuy);
507     }
508     ///charge fees.fee can be payed as other erc20 token or the tokens that user get
509     ///returns:fees to reduce from the user's tokenBuy
510     function chargeFee(Order order, address feeAccount, uint256 amountBuy) internal returns (uint256){
511         uint256 totalFee = 0;
512         if (order.feeToken != 0) {
513             ///use erc-20 token as fee .
514             //make sure the user has enough tokens
515             totalFee = safeAdd(order.fee, order.channelFee);
516             require(totalFee <= tokenList[order.feeToken][order.user][order.channelId]);
517             tokenList[order.feeToken][feeAccount][DEFAULT_CHANNEL_ID] = safeAdd(tokenList[order.feeToken][feeAccount][DEFAULT_CHANNEL_ID], order.fee);
518             tokenList[order.feeToken][order.channelFeeAccount][order.channelId] = safeAdd(tokenList[order.feeToken][order.channelFeeAccount][order.channelId], order.channelFee);
519             tokenList[order.feeToken][order.user][order.channelId] = safeSub(tokenList[order.feeToken][order.user][order.channelId], totalFee);
520         } else {
521             order.fee = checkFee(amountBuy, order.fee);
522             order.channelFee = checkFee(amountBuy, order.channelFee);
523             totalFee = safeAdd(order.fee, order.channelFee);
524             tokenList[order.tokenBuy][feeAccount][DEFAULT_CHANNEL_ID] = safeAdd(tokenList[order.tokenBuy][feeAccount][DEFAULT_CHANNEL_ID], order.fee);
525             tokenList[order.tokenBuy][order.channelFeeAccount][order.channelId] = safeAdd(tokenList[order.tokenBuy][order.channelFeeAccount][order.channelId], order.channelFee);
526             tokenList[order.tokenBuy][order.user][order.channelId] = safeSub(tokenList[order.tokenBuy][order.user][order.channelId], totalFee);
527         }
528     }
529     function batchTrade(
530         address[13][] addresses,
531         uint256[15][] values,
532         uint8[2][] v,
533         bytes32[2][] r,
534         bytes32[2][] s
535     ) public onlyAdmin {
536         for (uint i = 0; i < addresses.length; i++) {
537             trade(addresses[i], values[i], v[i], r[i], s[i]);
538         }
539     }
540     ///help to refund token to users.this method is called when contract needs updating
541     function refund(address user, address[] tokens, uint256[] channelIds) public onlyAdmin {
542         for (uint i = 0; i < tokens.length; i++) {
543             address token = tokens[i];
544             for (uint j = 0; j < channelIds.length; j++) {
545                 uint256 channelId = channelIds[j];
546                 uint256 amount = tokenList[token][user][channelId];
547                 if (amount > 0) {
548                     tokenList[token][user][channelId] = 0;
549                     if (token == 0) {//withdraw ether
550                         require(user.send(amount));
551                     } else {//withdraw token
552                         require(Token(token).transfer(user, amount));
553                     }
554                     Withdraw(token, user, amount, tokenList[token][user][channelId], channelId);
555                 }
556             }
557         }
558     }
559 }