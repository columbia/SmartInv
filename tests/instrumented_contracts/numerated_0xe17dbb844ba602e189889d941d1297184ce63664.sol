1 pragma solidity ^0.4.19;
2 
3 // ERC20 token protocol, see more details at
4 // https://theethereum.wiki/w/index.php/ERC20_Token_Standard
5 // And also https://github.com/ethereum/eips/issues/20
6 
7 contract Token {
8 
9   string public name;
10   string public symbol;
11   uint8 public decimals;
12 
13   function totalSupply() constant returns (uint256 supply);
14   function balanceOf(address _owner) constant returns (uint256 balance);
15   function transfer(address _to, uint256 _value) returns (bool success);
16   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
17   function approve(address _spender, uint256 _value) returns (bool success);
18   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
19 
20   event Transfer(address indexed _from, address indexed _to, uint256 _value);
21   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 }
23 
24 // Safe mathematics to make the code more readable
25 
26 contract SafeMath {
27   function safeMul(uint a, uint b) internal returns (uint) {
28     uint c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function safeSub(uint a, uint b) internal returns (uint) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function safeAdd(uint a, uint b) internal returns (uint) {
39     uint c = a + b;
40     assert(c>=a && c>=b);
41     return c;
42   }
43 }
44 
45 // Ownable interface to simplify owner checks
46 
47 contract Ownable {
48   address public owner;
49 
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   function transferOwnership(address _newOwner) onlyOwner {
60     require(_newOwner != address(0));
61     owner = _newOwner;
62   }
63 }
64 
65 // Interface for trading discounts and rebates for specific accounts
66 
67 contract AccountModifiersInterface {
68   function accountModifiers(address _user) constant returns(uint takeFeeDiscount, uint rebatePercentage);
69   function tradeModifiers(address _maker, address _taker) constant returns(uint takeFeeDiscount, uint rebatePercentage);
70 }
71 
72 // Interface for trade tacker
73 
74 contract TradeTrackerInterface {
75   function tradeComplete(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, address _get, address _give, uint _takerFee, uint _makerRebate);
76 }
77 
78 // Exchange contract
79 
80 contract TokenStore is SafeMath, Ownable {
81 
82   // The account that will receive fees
83   address feeAccount;
84 
85   // The account that stores fee discounts/rebates
86   address accountModifiers;
87 
88   // Trade tracker account
89   address tradeTracker;
90 
91   // We charge only the takers and this is the fee, percentage times 1 ether
92   uint public fee;
93 
94   // Mapping of token addresses to mapping of account balances (token 0 means Ether)
95   mapping (address => mapping (address => uint)) public tokens;
96 
97   // Mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
98   mapping (address => mapping (bytes32 => uint)) public orderFills;
99 
100   // Address of a next and previous versions of the contract, also status of the contract
101   // can be used for user-triggered fund migrations
102   address public successor;
103   address public predecessor;
104   bool public deprecated;
105   uint16 public version;
106 
107   // Logging events
108   // Note: Order creation is handled off-chain, see explanation further below
109   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
110   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give, uint nonce);
111   event Deposit(address token, address user, uint amount, uint balance);
112   event Withdraw(address token, address user, uint amount, uint balance);
113   event FundsMigrated(address user);
114 
115   function TokenStore(uint _fee, address _predecessor) {
116     feeAccount = owner;
117     fee = _fee;
118     predecessor = _predecessor;
119     deprecated = false;
120     if (predecessor != address(0)) {
121       version = TokenStore(predecessor).version() + 1;
122     } else {
123       version = 1;
124     }
125   }
126 
127   // Throw on default handler to prevent direct transactions of Ether
128   function() {
129     revert();
130   }
131 
132   modifier deprecable() {
133     require(!deprecated);
134     _;
135   }
136 
137   function deprecate(bool _deprecated, address _successor) onlyOwner {
138     deprecated = _deprecated;
139     successor = _successor;
140   }
141 
142   function changeFeeAccount(address _feeAccount) onlyOwner {
143     require(_feeAccount != address(0));
144     feeAccount = _feeAccount;
145   }
146 
147   function changeAccountModifiers(address _accountModifiers) onlyOwner {
148     accountModifiers = _accountModifiers;
149   }
150 
151   function changeTradeTracker(address _tradeTracker) onlyOwner {
152     tradeTracker = _tradeTracker;
153   }
154 
155   // Fee can only be decreased!
156   function changeFee(uint _fee) onlyOwner {
157     require(_fee <= fee);
158     fee = _fee;
159   }
160 
161   // Allows a user to get her current discount/rebate
162   function getAccountModifiers() constant returns(uint takeFeeDiscount, uint rebatePercentage) {
163     if (accountModifiers != address(0)) {
164       return AccountModifiersInterface(accountModifiers).accountModifiers(msg.sender);
165     } else {
166       return (0, 0);
167     }
168   }
169 
170   ////////////////////////////////////////////////////////////////////////////////
171   // Deposits, withdrawals, balances
172   ////////////////////////////////////////////////////////////////////////////////
173 
174   function deposit() payable deprecable {
175     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
176     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
177   }
178 
179   function withdraw(uint _amount) {
180     require(tokens[0][msg.sender] >= _amount);
181     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], _amount);
182     if (!msg.sender.call.value(_amount)()) {
183       revert();
184     }
185     Withdraw(0, msg.sender, _amount, tokens[0][msg.sender]);
186   }
187 
188   function depositToken(address _token, uint _amount) deprecable {
189     // Note that Token(_token).approve(this, _amount) needs to be called
190     // first or this contract will not be able to do the transfer.
191     require(_token != 0);
192     if (!Token(_token).transferFrom(msg.sender, this, _amount)) {
193       revert();
194     }
195     tokens[_token][msg.sender] = safeAdd(tokens[_token][msg.sender], _amount);
196     Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
197   }
198 
199   function withdrawToken(address _token, uint _amount) {
200     require(_token != 0);
201     require(tokens[_token][msg.sender] >= _amount);
202     tokens[_token][msg.sender] = safeSub(tokens[_token][msg.sender], _amount);
203     if (!Token(_token).transfer(msg.sender, _amount)) {
204       revert();
205     }
206     Withdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]);
207   }
208 
209   function balanceOf(address _token, address _user) constant returns (uint) {
210     return tokens[_token][_user];
211   }
212 
213   ////////////////////////////////////////////////////////////////////////////////
214   // Trading
215   ////////////////////////////////////////////////////////////////////////////////
216 
217   // Note: Order creation happens off-chain but the orders are signed by creators,
218   // we validate the contents and the creator address in the logic below
219 
220   function trade(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive,
221       uint _expires, uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s, uint _amount) {
222     bytes32 hash = sha256(this, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce);
223     // Check order signatures and expiration, also check if not fulfilled yet
224 		if (ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash), _v, _r, _s) != _user ||
225       block.number > _expires ||
226       safeAdd(orderFills[_user][hash], _amount) > _amountGet) {
227       revert();
228     }
229     tradeBalances(_tokenGet, _amountGet, _tokenGive, _amountGive, _user, msg.sender, _amount);
230     orderFills[_user][hash] = safeAdd(orderFills[_user][hash], _amount);
231     Trade(_tokenGet, _amount, _tokenGive, _amountGive * _amount / _amountGet, _user, msg.sender, _nonce);
232   }
233 
234   function tradeBalances(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive,
235       address _user, address _caller, uint _amount) private {
236 
237     uint feeTakeValue = safeMul(_amount, fee) / (1 ether);
238     uint rebateValue = 0;
239     uint tokenGiveValue = safeMul(_amountGive, _amount) / _amountGet; // Proportionate to request ratio
240 
241     // Apply modifiers
242     if (accountModifiers != address(0)) {
243       var (feeTakeDiscount, rebatePercentage) = AccountModifiersInterface(accountModifiers).tradeModifiers(_user, _caller);
244       // Check that the discounts/rebates are never higher then 100%
245       if (feeTakeDiscount > 100) {
246         feeTakeDiscount = 0;
247       }
248       if (rebatePercentage > 100) {
249         rebatePercentage = 0;
250       }
251       feeTakeValue = safeMul(feeTakeValue, 100 - feeTakeDiscount) / 100;  // discounted fee
252       rebateValue = safeMul(rebatePercentage, feeTakeValue) / 100;        // % of actual taker fee
253     }
254 
255     tokens[_tokenGet][_user] = safeAdd(tokens[_tokenGet][_user], safeAdd(_amount, rebateValue));
256     tokens[_tokenGet][_caller] = safeSub(tokens[_tokenGet][_caller], safeAdd(_amount, feeTakeValue));
257     tokens[_tokenGive][_user] = safeSub(tokens[_tokenGive][_user], tokenGiveValue);
258     tokens[_tokenGive][_caller] = safeAdd(tokens[_tokenGive][_caller], tokenGiveValue);
259     tokens[_tokenGet][feeAccount] = safeAdd(tokens[_tokenGet][feeAccount], safeSub(feeTakeValue, rebateValue));
260 
261     if (tradeTracker != address(0)) {
262       TradeTrackerInterface(tradeTracker).tradeComplete(_tokenGet, _amount, _tokenGive, tokenGiveValue, _user, _caller, feeTakeValue, rebateValue);
263     }
264   }
265 
266   function testTrade(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires,
267       uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s, uint _amount, address _sender) constant returns(bool) {
268     if (tokens[_tokenGet][_sender] < _amount ||
269       availableVolume(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, _user, _v, _r, _s) < _amount) {
270       return false;
271     }
272     return true;
273   }
274 
275   function availableVolume(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires,
276       uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s) constant returns(uint) {
277     bytes32 hash = sha256(this, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce);
278     if (ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash), _v, _r, _s) != _user ||
279       block.number > _expires) {
280       return 0;
281     }
282     uint available1 = safeSub(_amountGet, orderFills[_user][hash]);
283     uint available2 = safeMul(tokens[_tokenGive][_user], _amountGet) / _amountGive;
284     if (available1 < available2) return available1;
285     return available2;
286   }
287 
288   function amountFilled(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires,
289       uint _nonce, address _user) constant returns(uint) {
290     bytes32 hash = sha256(this, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce);
291     return orderFills[_user][hash];
292   }
293 
294   function cancelOrder(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires,
295       uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) {
296     bytes32 hash = sha256(this, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce);
297     if (!(ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash), _v, _r, _s) == msg.sender)) {
298       revert();
299     }
300     orderFills[msg.sender][hash] = _amountGet;
301     Cancel(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, msg.sender, _v, _r, _s);
302   }
303 
304   ////////////////////////////////////////////////////////////////////////////////
305   // Migrations
306   ////////////////////////////////////////////////////////////////////////////////
307 
308   // User-triggered (!) fund migrations in case contract got updated
309   // Similar to withdraw but we use a successor account instead
310   // As we don't store user tokens list on chain, it has to be passed from the outside
311   function migrateFunds(address[] _tokens) {
312 
313     // Get the latest successor in the chain
314     require(successor != address(0));
315     TokenStore newExchange = TokenStore(successor);
316     for (uint16 n = 0; n < 20; n++) {  // We will look past 20 contracts in the future
317       address nextSuccessor = newExchange.successor();
318       if (nextSuccessor == address(this)) {  // Circular succession
319         revert();
320       }
321       if (nextSuccessor == address(0)) { // We reached the newest, stop
322         break;
323       }
324       newExchange = TokenStore(nextSuccessor);
325     }
326 
327     // Ether
328     uint etherAmount = tokens[0][msg.sender];
329     if (etherAmount > 0) {
330       tokens[0][msg.sender] = 0;
331       newExchange.depositForUser.value(etherAmount)(msg.sender);
332     }
333 
334     // Tokens
335     for (n = 0; n < _tokens.length; n++) {
336       address token = _tokens[n];
337       require(token != address(0)); // 0 = Ether, we handle it above
338       uint tokenAmount = tokens[token][msg.sender];
339       if (tokenAmount == 0) {
340         continue;
341       }
342       if (!Token(token).approve(newExchange, tokenAmount)) {
343         revert();
344       }
345       tokens[token][msg.sender] = 0;
346       newExchange.depositTokenForUser(token, tokenAmount, msg.sender);
347     }
348 
349     FundsMigrated(msg.sender);
350   }
351 
352   // This is used for migrations only. To be called by previous exchange only,
353   // user-triggered, on behalf of the user called the migrateFunds method.
354   // Note that it does exactly the same as depositToken, but as this is called
355   // by a previous generation of exchange itself, we credit internally not the
356   // previous exchange, but the user it was called for.
357   function depositForUser(address _user) payable deprecable {
358     require(_user != address(0));
359     require(msg.value > 0);
360     TokenStore caller = TokenStore(msg.sender);
361     require(caller.version() > 0); // Make sure it's an exchange account
362     tokens[0][_user] = safeAdd(tokens[0][_user], msg.value);
363   }
364 
365   function depositTokenForUser(address _token, uint _amount, address _user) deprecable {
366     require(_token != address(0));
367     require(_user != address(0));
368     require(_amount > 0);
369     TokenStore caller = TokenStore(msg.sender);
370     require(caller.version() > 0); // Make sure it's an exchange account
371     if (!Token(_token).transferFrom(msg.sender, this, _amount)) {
372       revert();
373     }
374     tokens[_token][_user] = safeAdd(tokens[_token][_user], _amount);
375   }
376 }
377 
378 contract InstantTrade is SafeMath, Ownable {
379 
380   // This is needed so we can withdraw funds from other smart contracts
381   function() payable {
382   }
383   
384   // End to end trading in a single call
385   function instantTrade(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive,
386       uint _expires, uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s, uint _amount, address _store) payable {
387     
388     // Fix max fee (0.4%) and always reserve it
389     uint totalValue = safeMul(_amount, 1004) / 1000;
390     
391     // Paying with Ethereum or token? Deposit to the actual store
392     if (_tokenGet == address(0)) {
393       // Check amount of ether sent to make sure it's correct
394       if (msg.value != totalValue) {
395         revert();
396       }
397       TokenStore(_store).deposit.value(totalValue)();
398     } else {
399       // Assuming user already approved transfer, transfer first to this contract
400       if (!Token(_tokenGet).transferFrom(msg.sender, this, totalValue)) {
401         revert();
402       }
403       // Allow now actual store to deposit
404       if (!Token(_tokenGet).approve(_store, totalValue)) {
405         revert();
406       }
407       TokenStore(_store).depositToken(_tokenGet, totalValue);
408     }
409     
410     // Trade
411     TokenStore(_store).trade(_tokenGet, _amountGet, _tokenGive, _amountGive,
412       _expires, _nonce, _user, _v, _r, _s, _amount);
413     
414     // Check how much did we get and how much should we send back
415     totalValue = TokenStore(_store).balanceOf(_tokenGive, this);
416     uint customerValue = safeMul(_amountGive, _amount) / _amountGet;
417     
418     // Now withdraw all the funds into this contract and then pass to the user
419     if (_tokenGive == address(0)) {
420       TokenStore(_store).withdraw(totalValue);
421       msg.sender.transfer(customerValue);
422     } else {
423       TokenStore(_store).withdrawToken(_tokenGive, totalValue);
424       if (!Token(_tokenGive).transfer(msg.sender, customerValue)) {
425         revert();
426       }
427     }
428   }
429   
430   function withdrawFees(address _token) onlyOwner {
431     if (_token == address(0)) {
432       msg.sender.transfer(this.balance);
433     } else {
434       uint amount = Token(_token).balanceOf(this);
435       if (!Token(_token).transfer(msg.sender, amount)) {
436         revert();
437       }
438     }
439   }  
440 }