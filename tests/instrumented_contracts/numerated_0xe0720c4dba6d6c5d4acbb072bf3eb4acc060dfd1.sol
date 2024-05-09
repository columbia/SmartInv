1 pragma solidity ^0.4.9;
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
28   function totalSupply() constant returns (uint256 supply) {}
29 
30   /// @param _owner The address from which the balance will be retrieved
31   /// @return The balance
32   function balanceOf(address _owner) constant returns (uint256 balance) {}
33 
34   /// @notice send `_value` token to `_to` from `msg.sender`
35   /// @param _to The address of the recipient
36   /// @param _value The amount of token to be transferred
37   /// @return Whether the transfer was successful or not
38   function transfer(address _to, uint256 _value) returns (bool success) {}
39 
40   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
41   /// @param _from The address of the sender
42   /// @param _to The address of the recipient
43   /// @param _value The amount of token to be transferred
44   /// @return Whether the transfer was successful or not
45   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
46 
47   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
48   /// @param _spender The address of the account able to transfer the tokens
49   /// @param _value The amount of wei to be approved for transfer
50   /// @return Whether the approval was successful or not
51   function approve(address _spender, uint256 _value) returns (bool success) {}
52 
53   /// @param _owner The address of the account owning tokens
54   /// @param _spender The address of the account able to transfer the tokens
55   /// @return Amount of remaining tokens allowed to spent
56   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
57 
58   event Transfer(address indexed _from, address indexed _to, uint256 _value);
59   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 
61   uint public decimals;
62   string public name;
63 }
64 
65 contract StandardToken is Token {
66 
67   function transfer(address _to, uint256 _value) returns (bool success) {
68     //Default assumes totalSupply can't be over max (2^256 - 1).
69     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
70     //Replace the if with this one instead.
71     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
72     //if (balances[msg.sender] >= _value && _value > 0) {
73       balances[msg.sender] -= _value;
74       balances[_to] += _value;
75       Transfer(msg.sender, _to, _value);
76       return true;
77     } else { return false; }
78   }
79 
80   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
81     //same as above. Replace this line with the following if you want to protect against wrapping uints.
82     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
83     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
84       balances[_to] += _value;
85       balances[_from] -= _value;
86       allowed[_from][msg.sender] -= _value;
87       Transfer(_from, _to, _value);
88       return true;
89     } else { return false; }
90   }
91 
92   function balanceOf(address _owner) constant returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96   function approve(address _spender, uint256 _value) returns (bool success) {
97     allowed[msg.sender][_spender] = _value;
98     Approval(msg.sender, _spender, _value);
99     return true;
100   }
101 
102   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
103     return allowed[_owner][_spender];
104   }
105 
106   mapping(address => uint256) balances;
107 
108   mapping (address => mapping (address => uint256)) allowed;
109 
110   uint256 public totalSupply;
111 }
112 
113 contract ReserveToken is StandardToken, SafeMath {
114   address public minter;
115   function ReserveToken() {
116     minter = msg.sender;
117   }
118   function create(address account, uint amount) {
119     if (msg.sender != minter) throw;
120     balances[account] = safeAdd(balances[account], amount);
121     totalSupply = safeAdd(totalSupply, amount);
122   }
123   function destroy(address account, uint amount) {
124     if (msg.sender != minter) throw;
125     if (balances[account] < amount) throw;
126     balances[account] = safeSub(balances[account], amount);
127     totalSupply = safeSub(totalSupply, amount);
128   }
129 }
130 
131 contract AccountLevels {
132   //given a user, returns an account level
133   //0 = regular user (pays take fee and make fee)
134   //1 = market maker silver (pays take fee, no make fee, gets rebate)
135   //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
136   function accountLevel(address user) constant returns(uint) {}
137 }
138 
139 contract AccountLevelsTest is AccountLevels {
140   mapping (address => uint) public accountLevels;
141 
142   function setAccountLevel(address user, uint level) {
143     accountLevels[user] = level;
144   }
145 
146   function accountLevel(address user) constant returns(uint) {
147     return accountLevels[user];
148   }
149 }
150 
151 contract ELTWagerLedger is SafeMath {
152   address public admin; //the admin address
153 
154   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
155   
156   
157   event Deposit(address token, address user, uint amount, uint balance);
158   event Withdraw(address token, address user, uint amount, uint balance);
159 
160   function ELTWagerLedger(address admin_) {
161     admin = admin_;
162   }
163 
164   function() {
165     throw;
166   }
167 
168   function changeAdmin(address admin_) {
169     if (msg.sender != admin) throw;
170     admin = admin_;
171   }
172 
173   function deposit() payable {
174     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
175     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
176   }
177 
178   function withdraw(uint amount) {
179     if (tokens[0][msg.sender] < amount) throw;
180     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
181     if (!msg.sender.call.value(amount)()) throw;
182     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
183   }
184 
185   function depositToken(address token, uint amount) {
186     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
187     if (token==0) throw;
188     if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
189     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
190     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
191   }
192 
193   function withdrawToken(address token, uint amount) {
194     if (token==0) throw;
195     if (tokens[token][msg.sender] < amount) throw;
196     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
197     if (!Token(token).transfer(msg.sender, amount)) throw;
198     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
199   }
200 
201   function balanceOf(address token, address user) constant returns (uint) {
202     return tokens[token][user];
203   }
204 }