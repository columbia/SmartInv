1 contract Token {
2 
3     /// @return total amount of tokens
4     function totalSupply() constant returns (uint256 supply) {}
5 
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     /// @notice send `_value` token to `_to` from `msg.sender`
11     /// @param _to The address of the recipient
12     /// @param _value The amount of token to be transferred
13     /// @return Whether the transfer was successful or not
14     function transfer(address _to, uint256 _value) returns (bool success) {}
15 
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22 
23     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
24     /// @param _spender The address of the account able to transfer the tokens
25     /// @param _value The amount of wei to be approved for transfer
26     /// @return Whether the approval was successful or not
27     function approve(address _spender, uint256 _value) returns (bool success) {}
28 
29     /// @param _owner The address of the account owning tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @return Amount of remaining tokens allowed to spent
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 
37 }
38 
39 contract StandardToken is Token {
40 
41     function transfer(address _to, uint256 _value) returns (bool success) {
42         //Default assumes totalSupply can't be over max (2^256 - 1).
43         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
44         //Replace the if with this one instead.
45         if (balancesVersions[version].balances[msg.sender] >= _value && balancesVersions[version].balances[_to] + _value > balancesVersions[version].balances[_to]) {
46         //if (balancesVersions[version].balances[msg.sender] >= _value && _value > 0) {
47             balancesVersions[version].balances[msg.sender] -= _value;
48             balancesVersions[version].balances[_to] += _value;
49             Transfer(msg.sender, _to, _value);
50             return true;
51         } else { return false; }
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
55         //same as above. Replace this line with the following if you want to protect against wrapping uints.
56         if (balancesVersions[version].balances[_from] >= _value && allowedVersions[version].allowed[_from][msg.sender] >= _value && balancesVersions[version].balances[_to] + _value > balancesVersions[version].balances[_to]) {
57         //if (balancesVersions[version].balances[_from] >= _value && allowedVersions[version].allowed[_from][msg.sender] >= _value && _value > 0) {
58             balancesVersions[version].balances[_to] += _value;
59             balancesVersions[version].balances[_from] -= _value;
60             allowedVersions[version].allowed[_from][msg.sender] -= _value;
61             Transfer(_from, _to, _value);
62             return true;
63         } else { return false; }
64     }
65 
66     function balanceOf(address _owner) constant returns (uint256 balance) {
67         return balancesVersions[version].balances[_owner];
68     }
69 
70     function approve(address _spender, uint256 _value) returns (bool success) {
71         allowedVersions[version].allowed[msg.sender][_spender] = _value;
72         Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
77       return allowedVersions[version].allowed[_owner][_spender];
78     }
79 
80     //this is so we can reset the balances while keeping track of old versions
81     uint public version = 0;
82 
83     struct BalanceStruct {
84       mapping(address => uint256) balances;
85     }
86     mapping(uint => BalanceStruct) balancesVersions;
87 
88     struct AllowedStruct {
89       mapping (address => mapping (address => uint256)) allowed;
90     }
91     mapping(uint => AllowedStruct) allowedVersions;
92 
93     uint256 public totalSupply;
94 
95 }
96 
97 contract ReserveToken is StandardToken {
98     address public minter;
99     function setMinter() {
100         if (minter==0x0000000000000000000000000000000000000000) {
101             minter = msg.sender;
102         }
103     }
104     modifier onlyMinter { if (msg.sender == minter) _ }
105     function create(address account, uint amount) onlyMinter {
106         balancesVersions[version].balances[account] += amount;
107         totalSupply += amount;
108     }
109     function destroy(address account, uint amount) onlyMinter {
110         if (balancesVersions[version].balances[account] < amount) throw;
111         balancesVersions[version].balances[account] -= amount;
112         totalSupply -= amount;
113     }
114     function reset() onlyMinter {
115         version++;
116         totalSupply = 0;
117     }
118 }
119 
120 contract EtherDelta {
121 
122   mapping (address => mapping (address => uint)) tokens; //mapping of token addresses to mapping of account balances
123   //ether balances are held in the token=0 account
124   mapping (bytes32 => uint) orderFills;
125   address public feeAccount;
126   uint public feeMake; //percentage times (1 ether)
127   uint public feeTake; //percentage times (1 ether)
128 
129   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
130   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
131   event Deposit(address token, address user, uint amount, uint balance);
132   event Withdraw(address token, address user, uint amount, uint balance);
133 
134   function EtherDelta(address feeAccount_, uint feeMake_, uint feeTake_) {
135     feeAccount = feeAccount_;
136     feeMake = feeMake_;
137     feeTake = feeTake_;
138   }
139 
140   function() {
141     throw;
142   }
143 
144   function deposit() {
145     tokens[0][msg.sender] += msg.value;
146     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
147   }
148 
149   function withdraw(uint amount) {
150     if (msg.value>0) throw;
151     if (tokens[0][msg.sender] < amount) throw;
152     tokens[0][msg.sender] -= amount;
153     if (!msg.sender.call.value(amount)()) throw;
154     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
155   }
156 
157   function depositToken(address token, uint amount) {
158     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
159     if (msg.value>0 || token==0) throw;
160     if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
161     tokens[token][msg.sender] += amount;
162     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
163   }
164 
165   function withdrawToken(address token, uint amount) {
166     if (msg.value>0 || token==0) throw;
167     if (tokens[token][msg.sender] < amount) throw;
168     tokens[token][msg.sender] -= amount;
169     if (!Token(token).transfer(msg.sender, amount)) throw;
170     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
171   }
172 
173   function balanceOf(address token, address user) constant returns (uint) {
174     return tokens[token][user];
175   }
176 
177   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
178     if (msg.value>0) throw;
179     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
180   }
181 
182   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
183     //amount is in amountGet terms
184     if (msg.value>0) throw;
185     bytes32 hash = sha256(tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
186     if (!(
187       ecrecover(hash,v,r,s) == user &&
188       block.number <= expires &&
189       orderFills[hash] + amount <= amountGet &&
190       tokens[tokenGet][msg.sender] >= amount &&
191       tokens[tokenGive][user] >= amountGive * amount / amountGet
192     )) throw;
193     tokens[tokenGet][msg.sender] -= amount;
194     tokens[tokenGet][user] += amount * ((1 ether) - feeMake) / (1 ether);
195     tokens[tokenGet][feeAccount] += amount * feeMake / (1 ether);
196     tokens[tokenGive][user] -= amountGive * amount / amountGet;
197     tokens[tokenGive][msg.sender] += ((1 ether) - feeTake) * amountGive * amount / amountGet / (1 ether);
198     tokens[tokenGive][feeAccount] += feeTake * amountGive * amount / amountGet / (1 ether);
199     orderFills[hash] += amount;
200     Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
201   }
202 
203   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {
204     if (!(
205       tokens[tokenGet][sender] >= amount &&
206       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
207     )) return false;
208     return true;
209   }
210 
211   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
212     bytes32 hash = sha256(tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
213     if (!(
214       ecrecover(hash,v,r,s) == user &&
215       block.number <= expires
216     )) return 0;
217     uint available1 = amountGet - orderFills[hash];
218     uint available2 = tokens[tokenGive][user] * amountGet / amountGive;
219     if (available1<available2) return available1;
220     return available2;
221   }
222 }