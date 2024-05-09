1 pragma solidity ^0.4.4;
2 
3 contract SafeMath {
4      function safeMul(uint a, uint b) internal returns (uint) {
5           uint c = a * b;
6           assert(a == 0 || c / a == b);
7           return c;
8      }
9 
10      function safeSub(uint a, uint b) internal returns (uint) {
11           assert(b <= a);
12           return a - b;
13      }
14 
15      function safeAdd(uint a, uint b) internal returns (uint) {
16           uint c = a + b;
17           assert(c>=a && c>=b);
18           return c;
19      }
20 
21      function assert(bool assertion) internal {
22           if (!assertion) throw;
23      }
24 }
25 
26 // Standard token interface (ERC 20)
27 // https://github.com/ethereum/EIPs/issues/20
28 contract Token is SafeMath {
29      // Functions:
30      /// @return total amount of tokens
31      function totalSupply() constant returns (uint256 supply) {}
32 
33      /// @param _owner The address from which the balance will be retrieved
34      /// @return The balance
35      function balanceOf(address _owner) constant returns (uint256 balance) {}
36 
37      /// @notice send `_value` token to `_to` from `msg.sender`
38      /// @param _to The address of the recipient
39      /// @param _value The amount of token to be transferred
40      function transfer(address _to, uint256 _value) {}
41 
42      /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
43      /// @param _from The address of the sender
44      /// @param _to The address of the recipient
45      /// @param _value The amount of token to be transferred
46      /// @return Whether the transfer was successful or not
47      function transferFrom(address _from, address _to, uint256 _value){}
48 
49      /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
50      /// @param _spender The address of the account able to transfer the tokens
51      /// @param _value The amount of wei to be approved for transfer
52      /// @return Whether the approval was successful or not
53      function approve(address _spender, uint256 _value) returns (bool success) {}
54 
55      /// @param _owner The address of the account owning tokens
56      /// @param _spender The address of the account able to transfer the tokens
57      /// @return Amount of remaining tokens allowed to spent
58      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
59 
60      // Events:
61      event Transfer(address indexed _from, address indexed _to, uint256 _value);
62      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 }
64 
65 contract StdToken is Token {
66      // Fields:
67      mapping(address => uint256) balances;
68      mapping (address => mapping (address => uint256)) allowed;
69      uint public totalSupply = 0;
70 
71      // Functions:
72      function transfer(address _to, uint256 _value) {
73           if((balances[msg.sender] < _value) || (balances[_to] + _value <= balances[_to])) {
74                throw;
75           }
76 
77           balances[msg.sender] -= _value;
78           balances[_to] += _value;
79           Transfer(msg.sender, _to, _value);
80      }
81 
82      function transferFrom(address _from, address _to, uint256 _value) {
83           if((balances[_from] < _value) || 
84                (allowed[_from][msg.sender] < _value) || 
85                (balances[_to] + _value <= balances[_to])) 
86           {
87                throw;
88           }
89 
90           balances[_to] += _value;
91           balances[_from] -= _value;
92           allowed[_from][msg.sender] -= _value;
93 
94           Transfer(_from, _to, _value);
95      }
96 
97      function balanceOf(address _owner) constant returns (uint256 balance) {
98           return balances[_owner];
99      }
100 
101      function approve(address _spender, uint256 _value) returns (bool success) {
102           allowed[msg.sender][_spender] = _value;
103           Approval(msg.sender, _spender, _value);
104 
105           return true;
106      }
107 
108      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
109           return allowed[_owner][_spender];
110      }
111 
112      modifier onlyPayloadSize(uint _size) {
113           if(msg.data.length < _size + 4) {
114                throw;
115           }
116           _;
117      }
118 }
119 
120 contract GOLD is StdToken {
121 /// Fields:
122      string public constant name = "Goldmint GOLD Token";
123      string public constant symbol = "GOLD";
124      uint public constant decimals = 18;
125 
126      address public creator = 0x0;
127      address public tokenManager = 0x0;
128 
129      // lock by default all methods
130      bool public lock = true;
131 
132 /// Modifiers:
133      modifier onlyCreator() { if(msg.sender != creator) throw; _; }
134      modifier onlyCreatorOrTokenManager() { if((msg.sender!=creator) && (msg.sender!=tokenManager)) throw; _; }
135 
136      function setCreator(address _creator) onlyCreator {
137           creator = _creator;
138      }
139 
140      function setTokenManager(address _manager) onlyCreator {
141           tokenManager = _manager;
142      }
143 
144      function lockContract(bool _lock) onlyCreator {
145           lock = _lock;
146      }
147 
148 /// Functions:
149      /// @dev Constructor
150      function GOLD() {
151           creator = msg.sender;
152           tokenManager = msg.sender;
153      }
154 
155      /// @dev Override
156      function transfer(address _to, uint256 _value) public {
157           if(lock && (msg.sender!=tokenManager)){
158                throw;
159           }
160 
161           super.transfer(_to,_value);
162      }
163 
164      /// @dev Override
165      function transferFrom(address _from, address _to, uint256 _value)public{
166           if(lock && (msg.sender!=tokenManager)){
167                throw;
168           }
169 
170           super.transferFrom(_from,_to,_value);
171      }
172 
173      /// @dev Override
174      function approve(address _spender, uint256 _value) public returns (bool) {
175           if(lock && (msg.sender!=tokenManager)){
176                throw;
177           }
178 
179           return super.approve(_spender,_value);
180      }
181 
182      function issueTokens(address _who, uint _tokens) onlyCreatorOrTokenManager {
183           if(lock && (msg.sender!=tokenManager)){
184                throw;
185           }
186 
187           balances[_who] += _tokens;
188           totalSupply += _tokens;
189      }
190 
191      function burnTokens(address _who, uint _tokens) onlyCreatorOrTokenManager {
192           if(lock && (msg.sender!=tokenManager)){
193                throw;
194           }
195 
196           balances[_who] = safeSub(balances[_who], _tokens);
197           totalSupply = safeSub(totalSupply, _tokens);
198      }
199 
200      // Do not allow to send money directly to this contract
201      function() {
202           throw;
203      }
204 }