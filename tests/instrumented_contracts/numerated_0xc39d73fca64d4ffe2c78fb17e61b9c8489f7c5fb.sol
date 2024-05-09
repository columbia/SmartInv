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
133 contract YesNo is SafeMath {
134 
135   ReserveToken public yesToken;
136   ReserveToken public noToken;
137 
138   //Reality Keys:
139   bytes32 public factHash;
140   address public ethAddr;
141   string public url;
142 
143   uint public outcome;
144   bool public resolved = false;
145 
146   address public feeAccount;
147   uint public fee; //percentage of 1 ether
148 
149   event Create(address indexed account, uint value);
150   event Redeem(address indexed account, uint value, uint yesTokens, uint noTokens);
151   event Resolve(bool resolved, uint outcome);
152 
153   function() {
154     throw;
155   }
156 
157   function YesNo(bytes32 factHash_, address ethAddr_, string url_, address feeAccount_, uint fee_) {
158     yesToken = new ReserveToken();
159     noToken = new ReserveToken();
160     factHash = factHash_;
161     ethAddr = ethAddr_;
162     url = url_;
163     feeAccount = feeAccount_;
164     fee = fee_;
165   }
166 
167   function create() {
168     //send X Ether, get X Yes tokens and X No tokens
169     yesToken.create(msg.sender, msg.value);
170     noToken.create(msg.sender, msg.value);
171     Create(msg.sender, msg.value);
172   }
173 
174   function redeem(uint tokens) {
175     if (!feeAccount.call.value(safeMul(tokens,fee)/(1 ether))()) throw;
176     if (!resolved) {
177       yesToken.destroy(msg.sender, tokens);
178       noToken.destroy(msg.sender, tokens);
179       if (!msg.sender.call.value(safeMul(tokens,(1 ether)-fee)/(1 ether))()) throw;
180       Redeem(msg.sender, tokens, tokens, tokens);
181     } else if (resolved) {
182       if (outcome==0) { //no
183         noToken.destroy(msg.sender, tokens);
184         if (!msg.sender.call.value(safeMul(tokens,(1 ether)-fee)/(1 ether))()) throw;
185         Redeem(msg.sender, tokens, 0, tokens);
186       } else if (outcome==1) { //yes
187         yesToken.destroy(msg.sender, tokens);
188         if (!msg.sender.call.value(safeMul(tokens,(1 ether)-fee)/(1 ether))()) throw;
189         Redeem(msg.sender, tokens, tokens, 0);
190       }
191     }
192   }
193 
194   function resolve(uint8 v, bytes32 r, bytes32 s, bytes32 value) {
195     if (ecrecover(sha3(factHash, value), v, r, s) != ethAddr) throw;
196     if (resolved) throw;
197     uint valueInt = uint(value);
198     if (valueInt==0 || valueInt==1) {
199       outcome = valueInt;
200       resolved = true;
201       Resolve(resolved, outcome);
202     } else {
203       throw;
204     }
205   }
206 }