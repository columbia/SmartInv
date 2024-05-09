1 //last compiled with soljson-v0.3.6-2016-08-29-b8060c5.js
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
64     uint public decimals;
65     string public name;
66 }
67 
68 contract StandardToken is Token {
69 
70     function transfer(address _to, uint256 _value) returns (bool success) {
71         //Default assumes totalSupply can't be over max (2^256 - 1).
72         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
73         //Replace the if with this one instead.
74         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
75         //if (balances[msg.sender] >= _value && _value > 0) {
76             balances[msg.sender] -= _value;
77             balances[_to] += _value;
78             Transfer(msg.sender, _to, _value);
79             return true;
80         } else { return false; }
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
84         //same as above. Replace this line with the following if you want to protect against wrapping uints.
85         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
86         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
87             balances[_to] += _value;
88             balances[_from] -= _value;
89             allowed[_from][msg.sender] -= _value;
90             Transfer(_from, _to, _value);
91             return true;
92         } else { return false; }
93     }
94 
95     function balanceOf(address _owner) constant returns (uint256 balance) {
96         return balances[_owner];
97     }
98 
99     function approve(address _spender, uint256 _value) returns (bool success) {
100         allowed[msg.sender][_spender] = _value;
101         Approval(msg.sender, _spender, _value);
102         return true;
103     }
104 
105     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
106       return allowed[_owner][_spender];
107     }
108 
109     mapping(address => uint256) balances;
110 
111     mapping (address => mapping (address => uint256)) allowed;
112 
113     uint256 public totalSupply;
114 
115 }
116 
117 contract ReserveToken is StandardToken, SafeMath {
118     address public minter;
119     function ReserveToken() {
120       minter = msg.sender;
121     }
122     function create(address account, uint amount) {
123       if (msg.sender != minter) throw;
124       balances[account] = safeAdd(balances[account], amount);
125       totalSupply = safeAdd(totalSupply, amount);
126     }
127     function destroy(address account, uint amount) {
128       if (msg.sender != minter) throw;
129       if (balances[account] < amount) throw;
130       balances[account] = safeSub(balances[account], amount);
131       totalSupply = safeSub(totalSupply, amount);
132     }
133 }
134 
135 contract EtherDelta is SafeMath {
136 
137   mapping (address => mapping (address => uint)) tokens; //mapping of token addresses to mapping of account balances
138   //ether balances are held in the token=0 account
139   mapping (bytes32 => uint) orderFills;
140   address public feeAccount;
141   uint public feeMake; //percentage times (1 ether)
142   uint public feeTake; //percentage times (1 ether)
143 
144   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
145   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
146   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
147   event Deposit(address token, address user, uint amount, uint balance);
148   event Withdraw(address token, address user, uint amount, uint balance);
149 
150   function EtherDelta(address feeAccount_, uint feeMake_, uint feeTake_) {
151     feeAccount = feeAccount_;
152     feeMake = feeMake_;
153     feeTake = feeTake_;
154   }
155 
156   function() {
157     throw;
158   }
159 
160   function deposit() {
161     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
162     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
163   }
164 
165   function withdraw(uint amount) {
166     if (msg.value>0) throw;
167     if (tokens[0][msg.sender] < amount) throw;
168     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
169     if (!msg.sender.call.value(amount)()) throw;
170     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
171   }
172 
173   function depositToken(address token, uint amount) {
174     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
175     if (msg.value>0 || token==0) throw;
176     if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
177     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
178     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
179   }
180 
181   function withdrawToken(address token, uint amount) {
182     if (msg.value>0 || token==0) throw;
183     if (tokens[token][msg.sender] < amount) throw;
184     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
185     if (!Token(token).transfer(msg.sender, amount)) throw;
186     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
187   }
188 
189   function balanceOf(address token, address user) constant returns (uint) {
190     return tokens[token][user];
191   }
192 
193   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
194     if (msg.value>0) throw;
195     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
196   }
197 
198   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
199     //amount is in amountGet terms
200     if (msg.value>0) throw;
201     bytes32 hash = sha256(tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
202     if (!(
203       ecrecover(hash,v,r,s) == user &&
204       block.number <= expires &&
205       safeAdd(orderFills[hash], amount) <= amountGet &&
206       tokens[tokenGet][msg.sender] >= amount &&
207       tokens[tokenGive][user] >= safeMul(amountGive, amount) / amountGet
208     )) throw;
209     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], amount);
210     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeMul(amount, ((1 ether) - feeMake)) / (1 ether));
211     tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeMul(amount, feeMake) / (1 ether));
212     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
213     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(safeMul(((1 ether) - feeTake), amountGive), amount) / amountGet / (1 ether));
214     tokens[tokenGive][feeAccount] = safeAdd(tokens[tokenGive][feeAccount], safeMul(safeMul(feeTake, amountGive), amount) / amountGet / (1 ether));
215     orderFills[hash] = safeAdd(orderFills[hash], amount);
216     Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
217   }
218 
219   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {
220     if (!(
221       tokens[tokenGet][sender] >= amount &&
222       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
223     )) return false;
224     return true;
225   }
226 
227   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
228     bytes32 hash = sha256(tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
229     if (!(
230       ecrecover(hash,v,r,s) == user &&
231       block.number <= expires
232     )) return 0;
233     uint available1 = safeSub(amountGet, orderFills[hash]);
234     uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
235     if (available1<available2) return available1;
236     return available2;
237   }
238 
239   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
240     if (msg.value>0) throw;
241     bytes32 hash = sha256(tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
242     if (ecrecover(hash,v,r,s) != msg.sender) throw;
243     orderFills[hash] = amountGet;
244     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
245   }
246 }