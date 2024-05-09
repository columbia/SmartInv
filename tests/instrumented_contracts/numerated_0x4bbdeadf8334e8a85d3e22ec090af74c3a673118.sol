1 pragma solidity ^0.4.13;
2 // Last compiled with 0.4.13+commit.0fb4cb1a
3 
4 contract SafeMath {
5   //internals
6 
7   function safeMul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeSub(uint a, uint b) internal returns (uint) {
14     assert(b <= a);
15     return a - b;
16   }
17 
18   function safeAdd(uint a, uint b) internal returns (uint) {
19     uint c = a + b;
20     assert(c>=a && c>=b);
21     return c;
22   }
23 }
24 
25 contract Token {
26 
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
61 }
62 
63 contract StandardToken is Token {
64 
65     function transfer(address _to, uint256 _value) returns (bool success) {
66         //Default assumes totalSupply can't be over max (2^256 - 1).
67         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
68         //Replace the if with this one instead.
69         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
70         //if (balances[msg.sender] >= _value && _value > 0) {
71             balances[msg.sender] -= _value;
72             balances[_to] += _value;
73             Transfer(msg.sender, _to, _value);
74             return true;
75         } else { return false; }
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
79         //same as above. Replace this line with the following if you want to protect against wrapping uints.
80         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
81         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
82             balances[_to] += _value;
83             balances[_from] -= _value;
84             allowed[_from][msg.sender] -= _value;
85             Transfer(_from, _to, _value);
86             return true;
87         } else { return false; }
88     }
89 
90     function balanceOf(address _owner) constant returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94     function approve(address _spender, uint256 _value) returns (bool success) {
95         allowed[msg.sender][_spender] = _value;
96         Approval(msg.sender, _spender, _value);
97         return true;
98     }
99 
100     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
101       return allowed[_owner][_spender];
102     }
103 
104     mapping(address => uint256) balances;
105 
106     mapping (address => mapping (address => uint256)) allowed;
107 
108     uint256 public totalSupply;
109 
110 }
111 
112 contract ReserveToken is StandardToken, SafeMath {
113     string public name;
114     string public symbol;
115     uint public decimals = 18;
116     address public minter;
117     function ReserveToken(string name_, string symbol_) {
118       name = name_;
119       symbol = symbol_;
120       minter = msg.sender;
121     }
122     function create(address account, uint amount) {
123       require(msg.sender == minter);
124       balances[account] = safeAdd(balances[account], amount);
125       totalSupply = safeAdd(totalSupply, amount);
126     }
127     function destroy(address account, uint amount) {
128       require(msg.sender == minter);
129       require(balances[account] >= amount);
130       balances[account] = safeSub(balances[account], amount);
131       totalSupply = safeSub(totalSupply, amount);
132     }
133 }
134 
135 contract YesNo is SafeMath {
136 
137   ReserveToken public yesToken;
138   ReserveToken public noToken;
139 
140   string public name;
141   string public symbol;
142 
143   //Reality Keys:
144   bytes32 public factHash;
145   address public ethAddr;
146   string public url;
147 
148   uint public outcome;
149   bool public resolved = false;
150 
151   address public feeAccount;
152   uint public fee; //percentage of 1 ether
153 
154   event Create(address indexed account, uint value);
155   event Redeem(address indexed account, uint value, uint yesTokens, uint noTokens);
156   event Resolve(bool resolved, uint outcome);
157 
158   function YesNo(string name_, string symbol_, string namey_, string symboly_, string namen_, string symboln_, bytes32 factHash_, address ethAddr_, string url_, address feeAccount_, uint fee_) {
159     name = name_;
160     symbol = symbol_;
161     yesToken = new ReserveToken(namey_, symboly_);
162     noToken = new ReserveToken(namen_, symboln_);
163     factHash = factHash_;
164     ethAddr = ethAddr_;
165     url = url_;
166     feeAccount = feeAccount_;
167     fee = fee_;
168   }
169 
170   function() payable {
171     create();
172   }
173 
174   function create() payable {
175     //send X Ether, get X Yes tokens and X No tokens
176     yesToken.create(msg.sender, msg.value);
177     noToken.create(msg.sender, msg.value);
178     Create(msg.sender, msg.value);
179   }
180 
181   function redeem(uint tokens) {
182     feeAccount.transfer(safeMul(tokens,fee)/(1 ether));
183     if (!resolved) {
184       yesToken.destroy(msg.sender, tokens);
185       noToken.destroy(msg.sender, tokens);
186       msg.sender.transfer(safeMul(tokens,(1 ether)-fee)/(1 ether));
187       Redeem(msg.sender, tokens, tokens, tokens);
188     } else if (resolved) {
189       if (outcome==0) { //no
190         noToken.destroy(msg.sender, tokens);
191         msg.sender.transfer(safeMul(tokens,(1 ether)-fee)/(1 ether));
192         Redeem(msg.sender, tokens, 0, tokens);
193       } else if (outcome==1) { //yes
194         yesToken.destroy(msg.sender, tokens);
195         msg.sender.transfer(safeMul(tokens,(1 ether)-fee)/(1 ether));
196         Redeem(msg.sender, tokens, tokens, 0);
197       }
198     }
199   }
200 
201   function resolve(uint8 v, bytes32 r, bytes32 s, bytes32 value) {
202     require(ecrecover(sha3(factHash, value), v, r, s) == ethAddr);
203     require(!resolved);
204     uint valueInt = uint(value);
205     require(valueInt==0 || valueInt==1);
206     outcome = valueInt;
207     resolved = true;
208     Resolve(resolved, outcome);
209   }
210 }