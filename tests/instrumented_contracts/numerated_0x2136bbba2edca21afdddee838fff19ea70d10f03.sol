1 //last compiled with soljson-v0.3.5-2016-07-21-6610add.js
2 
3 contract SafeMath {
4   //internals
5 
6   function safeMul(uint a, uint b) internal returns (uint) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function safeSub(uint a, uint b) internal returns (uint) {
13     assert(b <= a);
14     return a - b;
15   }
16 
17   function safeAdd(uint a, uint b) internal returns (uint) {
18     uint c = a + b;
19     assert(c>=a && c>=b);
20     return c;
21   }
22 
23   function assert(bool assertion) internal {
24     if (!assertion) throw;
25   }
26 }
27 
28 contract Token {
29 
30     /// @return total amount of tokens
31     function totalSupply() constant returns (uint256 supply) {}
32 
33     /// @param _owner The address from which the balance will be retrieved
34     /// @return The balance
35     function balanceOf(address _owner) constant returns (uint256 balance) {}
36 
37     /// @notice send `_value` token to `_to` from `msg.sender`
38     /// @param _to The address of the recipient
39     /// @param _value The amount of token to be transferred
40     /// @return Whether the transfer was successful or not
41     function transfer(address _to, uint256 _value) returns (bool success) {}
42 
43     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
44     /// @param _from The address of the sender
45     /// @param _to The address of the recipient
46     /// @param _value The amount of token to be transferred
47     /// @return Whether the transfer was successful or not
48     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
49 
50     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
51     /// @param _spender The address of the account able to transfer the tokens
52     /// @param _value The amount of wei to be approved for transfer
53     /// @return Whether the approval was successful or not
54     function approve(address _spender, uint256 _value) returns (bool success) {}
55 
56     /// @param _owner The address of the account owning tokens
57     /// @param _spender The address of the account able to transfer the tokens
58     /// @return Amount of remaining tokens allowed to spent
59     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
60 
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 
64 }
65 
66 contract StandardToken is Token {
67 
68     function transfer(address _to, uint256 _value) returns (bool success) {
69         //Default assumes totalSupply can't be over max (2^256 - 1).
70         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
71         //Replace the if with this one instead.
72         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
73         //if (balances[msg.sender] >= _value && _value > 0) {
74             balances[msg.sender] -= _value;
75             balances[_to] += _value;
76             Transfer(msg.sender, _to, _value);
77             return true;
78         } else { return false; }
79     }
80 
81     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
82         //same as above. Replace this line with the following if you want to protect against wrapping uints.
83         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
84         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
85             balances[_to] += _value;
86             balances[_from] -= _value;
87             allowed[_from][msg.sender] -= _value;
88             Transfer(_from, _to, _value);
89             return true;
90         } else { return false; }
91     }
92 
93     function balanceOf(address _owner) constant returns (uint256 balance) {
94         return balances[_owner];
95     }
96 
97     function approve(address _spender, uint256 _value) returns (bool success) {
98         allowed[msg.sender][_spender] = _value;
99         Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
104       return allowed[_owner][_spender];
105     }
106 
107     mapping(address => uint256) balances;
108 
109     mapping (address => mapping (address => uint256)) allowed;
110 
111     uint256 public totalSupply;
112 
113 }
114 
115 contract ReserveToken is StandardToken, SafeMath {
116     address public minter;
117     function ReserveToken() {
118       minter = msg.sender;
119     }
120     function create(address account, uint amount) {
121       if (msg.sender != minter) throw;
122       balances[account] = safeAdd(balances[account], amount);
123       totalSupply = safeAdd(totalSupply, amount);
124     }
125     function destroy(address account, uint amount) {
126       if (msg.sender != minter) throw;
127       if (balances[account] < amount) throw;
128       balances[account] = safeSub(balances[account], amount);
129       totalSupply = safeSub(totalSupply, amount);
130     }
131 }
132 
133 contract EtherDelta is SafeMath {
134 
135   mapping (address => mapping (address => uint)) tokens; //mapping of token addresses to mapping of account balances
136   //ether balances are held in the token=0 account
137   mapping (bytes32 => uint) orderFills;
138   address public feeAccount;
139   uint public feeMake; //percentage times (1 ether)
140   uint public feeTake; //percentage times (1 ether)
141 
142   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
143   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
144   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
145   event Deposit(address token, address user, uint amount, uint balance);
146   event Withdraw(address token, address user, uint amount, uint balance);
147 
148   function EtherDelta(address feeAccount_, uint feeMake_, uint feeTake_) {
149     feeAccount = feeAccount_;
150     feeMake = feeMake_;
151     feeTake = feeTake_;
152   }
153 
154   function() {
155     throw;
156   }
157 
158   function deposit() {
159     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
160     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
161   }
162 
163   function withdraw(uint amount) {
164     if (msg.value>0) throw;
165     if (tokens[0][msg.sender] < amount) throw;
166     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
167     if (!msg.sender.call.value(amount)()) throw;
168     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
169   }
170 
171   function depositToken(address token, uint amount) {
172     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
173     if (msg.value>0 || token==0) throw;
174     if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
175     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
176     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
177   }
178 
179   function withdrawToken(address token, uint amount) {
180     if (msg.value>0 || token==0) throw;
181     if (tokens[token][msg.sender] < amount) throw;
182     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
183     if (!Token(token).transfer(msg.sender, amount)) throw;
184     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
185   }
186 
187   function balanceOf(address token, address user) constant returns (uint) {
188     return tokens[token][user];
189   }
190 
191   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
192     if (msg.value>0) throw;
193     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
194   }
195 
196   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
197     //amount is in amountGet terms
198     if (msg.value>0) throw;
199     bytes32 hash = sha256(tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
200     if (!(
201       ecrecover(hash,v,r,s) == user &&
202       block.number <= expires &&
203       safeAdd(orderFills[hash], amount) <= amountGet &&
204       tokens[tokenGet][msg.sender] >= amount &&
205       tokens[tokenGive][user] >= safeMul(amountGive, amount) / amountGet
206     )) throw;
207     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], amount);
208     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeMul(amount, ((1 ether) - feeMake)) / (1 ether));
209     tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeMul(amount, feeMake) / (1 ether));
210     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
211     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(safeMul(((1 ether) - feeTake), amountGive), amount) / amountGet / (1 ether));
212     tokens[tokenGive][feeAccount] = safeAdd(tokens[tokenGive][feeAccount], safeMul(safeMul(feeTake, amountGive), amount) / amountGet / (1 ether));
213     orderFills[hash] = safeAdd(orderFills[hash], amount);
214     Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
215   }
216 
217   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {
218     if (!(
219       tokens[tokenGet][sender] >= amount &&
220       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
221     )) return false;
222     return true;
223   }
224 
225   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
226     bytes32 hash = sha256(tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
227     if (!(
228       ecrecover(hash,v,r,s) == user &&
229       block.number <= expires
230     )) return 0;
231     uint available1 = safeSub(amountGet, orderFills[hash]);
232     uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
233     if (available1<available2) return available1;
234     return available2;
235   }
236 
237   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) {
238     if (msg.value>0) throw;
239     bytes32 hash = sha256(tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
240     if (user!=msg.sender) throw;
241     orderFills[hash] = amountGet;
242     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
243   }
244 }