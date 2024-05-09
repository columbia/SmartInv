1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeSub(uint a, uint b) internal returns (uint) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function safeAdd(uint a, uint b) internal returns (uint) {
16     uint c = a + b;
17     assert(c>=a && c>=b);
18     return c;
19   }
20 
21   function assert(bool assertion) internal {
22     if (!assertion) throw;
23   }
24 }
25 
26 contract Token {
27   /// @return total amount of tokens
28   function totalSupply() constant returns (uint256 supply) {supply=supply;}
29 
30   /// @param _owner The address from which the balance will be retrieved
31   /// @return The balance
32   function balanceOf(address _owner) constant returns (uint256 balance) {
33       _owner=_owner;
34       balance=balance;
35   }
36 
37   /// @notice send `_value` token to `_to` from `msg.sender`
38   /// @param _to The address of the recipient
39   /// @param _value The amount of token to be transferred
40   /// @return Whether the transfer was successful or not
41   function transfer(address _to, uint256 _value) returns (bool success) {
42       _to=_to;
43       _value=_value;
44       success=success;
45   }
46 
47   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
48   /// @param _from The address of the sender
49   /// @param _to The address of the recipient
50   /// @param _value The amount of token to be transferred
51   /// @return Whether the transfer was successful or not
52   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53       _from=_from;
54       _to=_to;
55       _value=_value;
56       success=success;
57   }
58 
59   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
60   /// @param _spender The address of the account able to transfer the tokens
61   /// @param _value The amount of wei to be approved for transfer
62   /// @return Whether the approval was successful or not
63   function approve(address _spender, uint256 _value) returns (bool success) {
64       _spender=_spender;
65       _value=_value;
66       success=success;
67   }
68 
69   /// @param _owner The address of the account owning tokens
70   /// @param _spender The address of the account able to transfer the tokens
71   /// @return Amount of remaining tokens allowed to spent
72   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
73       _owner=_owner;
74       _spender=_spender;
75       remaining=remaining;
76   }
77 
78   event Transfer(address indexed _from, address indexed _to, uint256 _value);
79   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80 
81   uint public decimals;
82   string public name;
83 }
84 
85 contract StandardToken is Token {
86 
87   function transfer(address _to, uint256 _value) returns (bool success) {
88     //Default assumes totalSupply can't be over max (2^256 - 1).
89     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
90     //Replace the if with this one instead.
91     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
92     //if (balances[msg.sender] >= _value && _value > 0) {
93       balances[msg.sender] -= _value;
94       balances[_to] += _value;
95       Transfer(msg.sender, _to, _value);
96       return true;
97     } else { return false; }
98   }
99 
100   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
101     //same as above. Replace this line with the following if you want to protect against wrapping uints.
102     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
103     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
104       balances[_to] += _value;
105       balances[_from] -= _value;
106       allowed[_from][msg.sender] -= _value;
107       Transfer(_from, _to, _value);
108       return true;
109     } else { return false; }
110   }
111 
112   function balanceOf(address _owner) constant returns (uint256 balance) {
113     return balances[_owner];
114   }
115 
116   function approve(address _spender, uint256 _value) returns (bool success) {
117     allowed[msg.sender][_spender] = _value;
118     Approval(msg.sender, _spender, _value);
119     return true;
120   }
121 
122   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
123     return allowed[_owner][_spender];
124   }
125 
126   mapping(address => uint256) balances;
127 
128   mapping (address => mapping (address => uint256)) allowed;
129 
130   uint256 public totalSupply;
131 }
132 
133 contract ReserveToken is StandardToken, SafeMath {
134   address public minter;
135   function ReserveToken() {
136     minter = msg.sender;
137   }
138   function create(address account, uint amount) {
139     if (msg.sender != minter) throw;
140     balances[account] = safeAdd(balances[account], amount);
141     totalSupply = safeAdd(totalSupply, amount);
142   }
143   function destroy(address account, uint amount) {
144     if (msg.sender != minter) throw;
145     if (balances[account] < amount) throw;
146     balances[account] = safeSub(balances[account], amount);
147     totalSupply = safeSub(totalSupply, amount);
148   }
149 }
150 
151 contract AccountLevels {
152   function accountLevel(address user) constant returns(uint) {
153       user=user;
154   }
155 }
156 
157 contract AccountLevelsTest is AccountLevels {
158   mapping (address => uint) public accountLevels;
159 
160   function setAccountLevel(address user, uint level) {
161     accountLevels[user] = level;
162   }
163 
164   function accountLevel(address user) constant returns(uint) {
165     return accountLevels[user];
166   }
167 }
168 
169 contract Cryptex is SafeMath {
170   address public admin; //the admin address
171   address feeAccount; //the account that will receive fees
172   address accountLevelsAddr; //the address of the AccountLevels contract
173   uint feeMake = 0;
174   uint feeTake = 0; 
175   uint feeRebate = 0;
176   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
177   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
178   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
179 
180   uint public tradeFee;
181   uint public feesPool;
182   address public sharesAddress = 0xA8CDE321DDB903bfeA9b64E2c938c1BE5468bB75;
183   uint public gasFee = 1000000;
184 
185   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
186   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
187   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
188   event Deposit(address token, address user, uint amount, uint balance);
189   event Withdraw(address token, address user, uint amount, uint balance);
190 
191   function Cryptex(address admin_, address feeAccount_, address accountLevelsAddr_, uint feeMake_, uint feeTake_, uint feeRebate_) {
192     admin = admin_;
193     feeAccount = feeAccount_;
194     accountLevelsAddr = accountLevelsAddr_;
195     feeMake = feeMake_;
196     feeTake = feeTake_;
197     feeRebate = feeRebate_;
198   }
199  
200   function() payable {
201 throw;
202   }
203 
204   function changeAdmin(address admin_) {
205     if (msg.sender != admin) throw;
206     admin = admin_;
207   }
208   
209     function changeTradeFee(uint tradeFee_) {
210     if (msg.sender != admin) throw;
211     if (tradeFee_ > 10 finney) throw;
212     if (tradeFee_ < 1 finney) throw;
213     tradeFee = tradeFee_;
214   }
215 
216     function changeGasFee(uint gasFee_) {
217     if (msg.sender != admin) throw;
218     if (gasFee_ > 200000) throw;
219     if (gasFee_ < 2000000) throw;
220     gasFee = gasFee_;
221   }
222 
223     function transferDividendToShares() {
224 	if(feesPool > 5300000000000000000){
225 	bool boolsent;
226         feesPool -=  5300000000000000000;
227         boolsent = sharesAddress.call.gas(gasFee).value(5300000000000000000)();
228 	}
229   }
230 
231   function deposit() payable {
232     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
233     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
234   }
235 
236   function withdraw(uint amount) payable {
237     if (tokens[0][msg.sender] < amount) throw;
238     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
239     if (!msg.sender.call.value(amount)()) throw;
240     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
241   }
242 
243   function depositToken(address token, uint amount) payable {
244     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
245     if (token==0) throw;
246     if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
247     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
248     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
249   }
250 
251   function withdrawToken(address token, uint amount) {
252     if (token==0) throw;
253     if (tokens[token][msg.sender] < amount) throw;
254     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
255     if (!Token(token).transfer(msg.sender, amount)) throw;
256     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
257   }
258 
259   function balanceOf(address token, address user) constant returns (uint) {
260     return tokens[token][user];
261   }
262 
263   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {
264     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
265     orders[msg.sender][hash] = true;
266     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
267   }
268 
269   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) payable {
270    
271    //add trade fee to fees pool
272     if(msg.value != tradeFee) {throw;}
273         feesPool += msg.value;
274 
275     //amount is in amountGet terms
276     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
277     if (!(
278       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
279       block.number <= expires &&
280       safeAdd(orderFills[user][hash], amount) <= amountGet
281     )) throw;
282     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
283     orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
284     Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
285 
286   }
287 
288   function tradeBalances (address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
289 
290     uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
291     uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
292     uint feeRebateXfer = 0;
293     if (accountLevelsAddr != 0x0) {
294       uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
295       if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);
296       if (accountLevel==2) feeRebateXfer = feeTakeXfer;
297     }
298     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
299     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
300     tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
301     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
302     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
303   }
304 
305   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {
306     if (!(
307       tokens[tokenGet][sender] >= amount &&
308       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
309     )) return false;
310     return true;
311   }
312 
313   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
314     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
315     if (!(
316       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
317       block.number <= expires
318     )) return 0;
319     uint available1 = safeSub(amountGet, orderFills[user][hash]);
320     uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
321     if (available1<available2) return available1;
322     return available2;
323   }
324 
325   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
326     tokenGet=tokenGet;
327     amountGet=amountGet;
328     tokenGive=tokenGive;
329     amountGive=amountGive;
330     expires=expires;
331     nonce=nonce;
332     user=user;
333     v=v;
334     r=r;
335     s=s;
336     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
337     return orderFills[user][hash];
338   }
339 
340   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
341     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
342     if (!(orders[msg.sender][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) throw;
343     orderFills[msg.sender][hash] = amountGet;
344     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
345   }
346 }