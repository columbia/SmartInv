1 pragma solidity ^0.4.19;
2 
3 contract SafeMath {
4     function safeMul(uint a, uint b) internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeSub(uint a, uint b) internal returns (uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function safeAdd(uint a, uint b) internal returns (uint) {
16         uint c = a + b;
17         assert(c>=a && c>=b);
18         return c;
19     }
20 
21     function assert(bool assertion) internal {
22         if (!assertion) throw;
23     }
24 }
25 
26 contract Token {
27     /// @return total amount of tokens
28     function totalSupply() constant returns (uint256 supply) {}
29 
30     /// @param _owner The address from which the balance will be retrieved
31     /// @return The balance
32     function balanceOf(address _owner) constant returns (uint256 balance) {}
33 
34     /// @notice send `_value` token to `_to` from `msg.sender`
35     /// @param _to The address of the recipient
36     /// @param _value The amount of token to be transferred
37     /// @return Whether the transfer was successful or not
38     function transfer(address _to, uint256 _value) returns (bool success) {}
39 
40     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
41     /// @param _from The address of the sender
42     /// @param _to The address of the recipient
43     /// @param _value The amount of token to be transferred
44     /// @return Whether the transfer was successful or not
45     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
46 
47     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @param _value The amount of wei to be approved for transfer
50     /// @return Whether the approval was successful or not
51     function approve(address _spender, uint256 _value) returns (bool success) {}
52 
53     /// @param _owner The address of the account owning tokens
54     /// @param _spender The address of the account able to transfer the tokens
55     /// @return Amount of remaining tokens allowed to spent
56     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
57 
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 
61     uint public decimals;
62     string public name;
63 }
64 
65 contract StandardToken is Token {
66 
67     function transfer(address _to, uint256 _value) returns (bool success) {
68         //Default assumes totalSupply can't be over max (2^256 - 1).
69         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
70         //Replace the if with this one instead.
71         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
72             //if (balances[msg.sender] >= _value && _value > 0) {
73             balances[msg.sender] -= _value;
74             balances[_to] += _value;
75             Transfer(msg.sender, _to, _value);
76             return true;
77         } else { return false; }
78     }
79 
80     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
81         //same as above. Replace this line with the following if you want to protect against wrapping uints.
82         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
83             //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
84             balances[_to] += _value;
85             balances[_from] -= _value;
86             allowed[_from][msg.sender] -= _value;
87             Transfer(_from, _to, _value);
88             return true;
89         } else { return false; }
90     }
91 
92     function balanceOf(address _owner) constant returns (uint256 balance) {
93         return balances[_owner];
94     }
95 
96     function approve(address _spender, uint256 _value) returns (bool success) {
97         allowed[msg.sender][_spender] = _value;
98         Approval(msg.sender, _spender, _value);
99         return true;
100     }
101 
102     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
103         return allowed[_owner][_spender];
104     }
105 
106     mapping(address => uint256) balances;
107 
108     mapping (address => mapping (address => uint256)) allowed;
109 
110     uint256 public totalSupply;
111 }
112 
113 contract ReserveToken is StandardToken, SafeMath {
114     address public minter;
115     function ReserveToken() {
116         minter = msg.sender;
117     }
118     function create(address account, uint amount) {
119         if (msg.sender != minter) throw;
120         balances[account] = safeAdd(balances[account], amount);
121         totalSupply = safeAdd(totalSupply, amount);
122     }
123     function destroy(address account, uint amount) {
124         if (msg.sender != minter) throw;
125         if (balances[account] < amount) throw;
126         balances[account] = safeSub(balances[account], amount);
127         totalSupply = safeSub(totalSupply, amount);
128     }
129 }
130 
131 contract DecentrEx is SafeMath {
132     address public admin; //the admin address
133     address public feeAccount; //the account that will receive fees
134     uint public feeMake; //percentage times (1 ether)
135     uint public feeTake; //percentage times (1 ether)
136     mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
137     mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
138     mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
139 
140     event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
141     event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
142     event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
143     event Deposit(address token, address user, uint amount, uint balance);
144     event Withdraw(address token, address user, uint amount, uint balance);
145 
146     function DecentrEx(address admin_, address feeAccount_, uint feeMake_, uint feeTake_) {
147         admin = admin_;
148         feeAccount = feeAccount_;
149         feeMake = feeMake_;
150         feeTake = feeTake_;
151     }
152 
153     function() {
154         throw;
155     }
156 
157     function changeAdmin(address admin_) {
158         if (msg.sender != admin) throw;
159         admin = admin_;
160     }
161 
162     function changeFeeAccount(address feeAccount_) {
163         if (msg.sender != admin) throw;
164         feeAccount = feeAccount_;
165     }
166 
167     function changeFeeMake(uint feeMake_) {
168         if (msg.sender != admin) throw;
169         if (feeMake_ > feeMake) throw;
170         feeMake = feeMake_;
171     }
172 
173     function changeFeeTake(uint feeTake_) {
174         if (msg.sender != admin) throw;
175         if (feeTake_ > feeTake) throw;
176         feeTake = feeTake_;
177     }
178 
179     function deposit() payable {
180         tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
181         Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
182     }
183 
184     function withdraw(uint amount) {
185         if (tokens[0][msg.sender] < amount) throw;
186         tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
187         if (!msg.sender.call.value(amount)()) throw;
188         Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
189     }
190 
191     function depositToken(address token, uint amount) {
192         //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
193         if (token==0) throw;
194         if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
195         tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
196         Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
197     }
198 
199     function withdrawToken(address token, uint amount) {
200         if (token==0) throw;
201         if (tokens[token][msg.sender] < amount) throw;
202         tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
203         if (!Token(token).transfer(msg.sender, amount)) throw;
204         Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
205     }
206 
207     function balanceOf(address token, address user) constant returns (uint) {
208         return tokens[token][user];
209     }
210 
211     function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {
212         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
213         orders[msg.sender][hash] = true;
214         Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
215     }
216 
217     function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
218         //amount is in amountGet terms
219         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
220         if (!(
221         (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
222         block.number <= expires &&
223         safeAdd(orderFills[user][hash], amount) <= amountGet
224         )) throw;
225         tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
226         orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
227         Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
228     }
229 
230     function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
231         uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
232         uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
233         uint feeRebateXfer = 0;
234 
235         tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
236         tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
237         tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
238         tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
239         tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
240     }
241 
242     function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {
243         if (!(
244         tokens[tokenGet][sender] >= amount &&
245         availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
246         )) return false;
247         return true;
248     }
249 
250     function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
251         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
252         if (!(
253         (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
254         block.number <= expires
255         )) return 0;
256         uint available1 = safeSub(amountGet, orderFills[user][hash]);
257         uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
258         if (available1<available2) return available1;
259         return available2;
260     }
261 
262     function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
263         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
264         return orderFills[user][hash];
265     }
266 
267     function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
268         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
269         if (!(orders[msg.sender][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) throw;
270         orderFills[msg.sender][hash] = amountGet;
271         Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
272     }
273 }