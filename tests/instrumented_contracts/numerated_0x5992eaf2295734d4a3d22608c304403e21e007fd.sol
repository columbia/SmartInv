1 pragma solidity ^0.4.11;
2 
3 // ERC20 token protocol, see more details at
4 // https://theethereum.wiki/w/index.php/ERC20_Token_Standard
5 // And also https://github.com/ethereum/eips/issues/20
6 
7 contract Token {
8   function totalSupply() constant returns (uint256 supply);
9   function balanceOf(address _owner) constant returns (uint256 balance);
10   function transfer(address _to, uint256 _value) returns (bool success);
11   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
12   function approve(address _spender, uint256 _value) returns (bool success);
13   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
14 
15   event Transfer(address indexed _from, address indexed _to, uint256 _value);
16   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 // Safe mathematics to make the code more readable
20 
21 contract SafeMath {
22   function safeMul(uint a, uint b) internal returns (uint) {
23     uint c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function safeSub(uint a, uint b) internal returns (uint) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function safeAdd(uint a, uint b) internal returns (uint) {
34     uint c = a + b;
35     assert(c>=a && c>=b);
36     return c;
37   }
38 }
39 
40 // Ownable interface to simplify owner checks
41 
42 contract Ownable {
43   address public owner;
44 
45   function Ownable() {
46     owner = msg.sender;
47   }
48 
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   function transferOwnership(address _newOwner) onlyOwner {
55     require(_newOwner != address(0));
56     owner = _newOwner;
57   }
58 }
59 
60 // Interface for trading discounts and rebates for specific accounts
61 
62 contract AccountModifiersInterface {
63   function accountModifiers(address _user) constant returns(uint takeFeeDiscount, uint rebatePercentage);
64   function tradeModifiers(address _maker, address _taker) constant returns(uint takeFeeDiscount, uint rebatePercentage);
65 }
66 
67 // Interface for trade tacker
68 
69 contract TradeTrackerInterface {
70   function tradeComplete(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, address _get, address _give, uint _takerFee, uint _makerRebate);
71 }
72 
73 // Exchange contract
74 
75 contract Coinshatoshi is SafeMath, Ownable {
76 
77   // The account that will receive fees
78   address feeAccount;
79 
80   // The account that stores fee discounts/rebates
81   address accountModifiers;
82   
83   // Trade tracker account
84   address tradeTracker;
85 
86   // We charge only the takers and this is the fee, percentage times 1 ether
87   uint public fee;
88 
89   // Mapping of token addresses to mapping of account balances (token 0 means Ether)
90   mapping (address => mapping (address => uint)) public tokens;
91 
92   // Mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
93   mapping (address => mapping (bytes32 => uint)) public orderFills;
94   
95   // Address of a next and previous versions of the contract, also status of the contract
96   // can be used for user-triggered fund migrations
97   address public successor;
98   address public predecessor;
99   bool public deprecated;
100   uint16 public version;
101 
102   // Logging events
103   // Note: Order creation is handled off-chain, see explanation further below
104   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
105   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give, uint nonce);
106   event Deposit(address token, address user, uint amount, uint balance);
107   event Withdraw(address token, address user, uint amount, uint balance);
108   event FundsMigrated(address user);
109 
110   function Coinshatoshi(uint _fee, address _predecessor) {
111     feeAccount = owner;
112     fee = _fee;
113     predecessor = _predecessor;
114     deprecated = false;
115     if (predecessor != address(0)) {
116       version = Coinshatoshi(predecessor).version() + 1;
117     } else {
118       version = 1;
119     }
120   }
121 
122   // Throw on default handler to prevent direct transactions of Ether
123   function() {
124     revert();
125   }
126   
127   modifier deprecable() {
128     require(!deprecated);
129     _;
130   }
131 
132   function deprecate(bool _deprecated, address _successor) onlyOwner {
133     deprecated = _deprecated;
134     successor = _successor;
135   }
136 
137   function changeFeeAccount(address _feeAccount) onlyOwner {
138     require(_feeAccount != address(0));
139     feeAccount = _feeAccount;
140   }
141 
142   function changeAccountModifiers(address _accountModifiers) onlyOwner {
143     accountModifiers = _accountModifiers;
144   }
145   
146   function changeTradeTracker(address _tradeTracker) onlyOwner {
147     tradeTracker = _tradeTracker;
148   }
149 
150   // Fee can only be decreased!
151   function changeFee(uint _fee) onlyOwner {
152     require(_fee <= fee);
153     fee = _fee;
154   }
155   
156   // Allows a user to get her current discount/rebate
157   function getAccountModifiers() constant returns(uint takeFeeDiscount, uint rebatePercentage) {
158     if (accountModifiers != address(0)) {
159       return AccountModifiersInterface(accountModifiers).accountModifiers(msg.sender);
160     } else {
161       return (0, 0);
162     }
163   }
164   
165   ////////////////////////////////////////////////////////////////////////////////
166   // Deposits, withdrawals, balances
167   ////////////////////////////////////////////////////////////////////////////////
168 
169   function deposit() payable deprecable {
170     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
171     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
172   }
173 
174   function withdraw(uint _amount) {
175     require(tokens[0][msg.sender] >= _amount);
176     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], _amount);
177     if (!msg.sender.call.value(_amount)()) {
178       revert();
179     }
180     Withdraw(0, msg.sender, _amount, tokens[0][msg.sender]);
181   }
182 
183   function depositToken(address _token, uint _amount) deprecable {
184     // Note that Token(_token).approve(this, _amount) needs to be called
185     // first or this contract will not be able to do the transfer.
186     require(_token != 0);
187     if (!Token(_token).transferFrom(msg.sender, this, _amount)) {
188       revert();
189     }
190     tokens[_token][msg.sender] = safeAdd(tokens[_token][msg.sender], _amount);
191     Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
192   }
193 
194   function withdrawToken(address _token, uint _amount) {
195     require(_token != 0);
196     require(tokens[_token][msg.sender] >= _amount);
197     tokens[_token][msg.sender] = safeSub(tokens[_token][msg.sender], _amount);
198     if (!Token(_token).transfer(msg.sender, _amount)) {
199       revert();
200     }
201     Withdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]);
202   }
203 
204   function balanceOf(address _token, address _user) constant returns (uint) {
205     return tokens[_token][_user];
206   }
207   
208   ////////////////////////////////////////////////////////////////////////////////
209   // Trading
210   ////////////////////////////////////////////////////////////////////////////////
211 
212   // Note: Order creation happens off-chain but the orders are signed by creators,
213   // we validate the contents and the creator address in the logic below
214 
215   function trade(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive,
216       uint _expires, uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s, uint _amount) {
217     bytes32 hash = sha256(this, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce);
218     // Check order signatures and expiration, also check if not fulfilled yet
219 		if (ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash), _v, _r, _s) != _user ||
220       block.number > _expires ||
221       safeAdd(orderFills[_user][hash], _amount) > _amountGet) {
222       revert();
223     }
224     tradeBalances(_tokenGet, _amountGet, _tokenGive, _amountGive, _user, msg.sender, _amount);
225     orderFills[_user][hash] = safeAdd(orderFills[_user][hash], _amount);
226     Trade(_tokenGet, _amount, _tokenGive, _amountGive * _amount / _amountGet, _user, msg.sender, _nonce);
227   }
228   
229   function tradeBalances(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive,
230       address _user, address _caller, uint _amount) private {
231 
232     uint feeTakeValue = safeMul(_amount, fee) / (1 ether);
233     uint rebateValue = 0;
234     uint tokenGiveValue = safeMul(_amountGive, _amount) / _amountGet; // Proportionate to request ratio
235 
236     // Apply modifiers
237     if (accountModifiers != address(0)) {
238       var (feeTakeDiscount, rebatePercentage) = AccountModifiersInterface(accountModifiers).tradeModifiers(_user, _caller);
239       // Check that the discounts/rebates are never higher then 100%
240       if (feeTakeDiscount > 100) {
241         feeTakeDiscount = 0;
242       }
243       if (rebatePercentage > 100) {
244         rebatePercentage = 0;
245       }
246       feeTakeValue = safeMul(feeTakeValue, 100 - feeTakeDiscount) / 100;  // discounted fee
247       rebateValue = safeMul(rebatePercentage, feeTakeValue) / 100;        // % of actual taker fee
248     }
249     
250     tokens[_tokenGet][_user] = safeAdd(tokens[_tokenGet][_user], safeAdd(_amount, rebateValue));
251     tokens[_tokenGet][_caller] = safeSub(tokens[_tokenGet][_caller], safeAdd(_amount, feeTakeValue));
252     tokens[_tokenGive][_user] = safeSub(tokens[_tokenGive][_user], tokenGiveValue);
253     tokens[_tokenGive][_caller] = safeAdd(tokens[_tokenGive][_caller], tokenGiveValue);
254     tokens[_tokenGet][feeAccount] = safeAdd(tokens[_tokenGet][feeAccount], safeSub(feeTakeValue, rebateValue));
255     
256     if (tradeTracker != address(0)) {
257       TradeTrackerInterface(tradeTracker).tradeComplete(_tokenGet, _amount, _tokenGive, tokenGiveValue, _user, _caller, feeTakeValue, rebateValue);
258     }
259   }
260 
261   function testTrade(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires,
262       uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s, uint _amount, address _sender) constant returns(bool) {
263     if (tokens[_tokenGet][_sender] < _amount ||
264       availableVolume(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, _user, _v, _r, _s) < _amount) {
265       return false;
266     }
267     return true;
268   }
269 
270   function availableVolume(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires,
271       uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s) constant returns(uint) {
272     bytes32 hash = sha256(this, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce);
273     if (ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash), _v, _r, _s) != _user ||
274       block.number > _expires) {
275       return 0;
276     }
277     uint available1 = safeSub(_amountGet, orderFills[_user][hash]);
278     uint available2 = safeMul(tokens[_tokenGive][_user], _amountGet) / _amountGive;
279     if (available1 < available2) return available1;
280     return available2;
281   }
282 
283   function amountFilled(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires,
284       uint _nonce, address _user) constant returns(uint) {
285     bytes32 hash = sha256(this, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce);
286     return orderFills[_user][hash];
287   }
288 
289   function cancelOrder(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires,
290       uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) {
291     bytes32 hash = sha256(this, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce);
292     if (!(ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash), _v, _r, _s) == msg.sender)) {
293       revert();
294     }
295     orderFills[msg.sender][hash] = _amountGet;
296     Cancel(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, msg.sender, _v, _r, _s);
297   }
298   
299   ////////////////////////////////////////////////////////////////////////////////
300   // Migrations
301   ////////////////////////////////////////////////////////////////////////////////
302 
303   // User-triggered (!) fund migrations in case contract got updated
304   // Similar to withdraw but we use a successor account instead
305   // As we don't store user tokens list on chain, it has to be passed from the outside
306   function migrateFunds(address[] _tokens) {
307   
308     // Get the latest successor in the chain
309     require(successor != address(0));
310     Coinshatoshi newExchange = Coinshatoshi(successor);
311     for (uint16 n = 0; n < 20; n++) {  // We will look past 20 contracts in the future
312       address nextSuccessor = newExchange.successor();
313       if (nextSuccessor == address(this)) {  // Circular succession
314         revert();
315       }
316       if (nextSuccessor == address(0)) { // We reached the newest, stop
317         break;
318       }
319       newExchange = Coinshatoshi(nextSuccessor);
320     }
321 
322     // Ether
323     uint etherAmount = tokens[0][msg.sender];
324     if (etherAmount > 0) {
325       tokens[0][msg.sender] = 0;
326       newExchange.depositForUser.value(etherAmount)(msg.sender);
327     }
328 
329     // Tokens
330     for (n = 0; n < _tokens.length; n++) {
331       address token = _tokens[n];
332       require(token != address(0)); // 0 = Ether, we handle it above
333       uint tokenAmount = tokens[token][msg.sender];
334       if (tokenAmount == 0) {
335         continue;
336       }
337       if (!Token(token).approve(newExchange, tokenAmount)) {
338         revert();
339       }
340       tokens[token][msg.sender] = 0;
341       newExchange.depositTokenForUser(token, tokenAmount, msg.sender);
342     }
343 
344     FundsMigrated(msg.sender);
345   }
346 
347   // This is used for migrations only. To be called by previous exchange only,
348   // user-triggered, on behalf of the user called the migrateFunds method.
349   // Note that it does exactly the same as depositToken, but as this is called
350   // by a previous generation of exchange itself, we credit internally not the
351   // previous exchange, but the user it was called for.
352   function depositForUser(address _user) payable deprecable {
353     require(_user != address(0));
354     require(msg.value > 0);
355     Coinshatoshi caller = Coinshatoshi(msg.sender);
356     require(caller.version() > 0); // Make sure it's an exchange account
357     tokens[0][_user] = safeAdd(tokens[0][_user], msg.value);
358   }
359 
360   function depositTokenForUser(address _token, uint _amount, address _user) deprecable {
361     require(_token != address(0));
362     require(_user != address(0));
363     require(_amount > 0);
364     Coinshatoshi caller = Coinshatoshi(msg.sender);
365     require(caller.version() > 0); // Make sure it's an exchange account
366     if (!Token(_token).transferFrom(msg.sender, this, _amount)) {
367       revert();
368     }
369     tokens[_token][_user] = safeAdd(tokens[_token][_user], _amount);
370   }
371 }