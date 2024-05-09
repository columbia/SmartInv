1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.10;
4 
5 contract Token {
6     /// total amount of tokens
7     uint256 public totalSupply;
8 	
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance	
11     function balanceOf(address _owner) constant returns (uint256 balance);
12 	
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not	
17     function transfer(address _to, uint256 _value) returns (bool success);
18 	
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not	
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
25 	
26     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of tokens to be approved for transfer
29     /// @return Whether the approval was successful or not	
30     function approve(address _spender, uint256 _value) returns (bool success);
31 	
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent	
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
36 	
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40 
41 contract IMigrationContract {
42     function migrate(address addr, uint256 uip) returns (bool success);
43 }
44 
45 contract SafeMath {
46 
47     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
48       uint256 z = x + y;
49       assert((z >= x) && (z >= y));
50       return z;
51     }
52 
53     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
54       assert(x >= y);
55       uint256 z = x - y;
56       return z;
57     }
58 
59     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
60       uint256 z = x * y;
61       assert((x == 0)||(z/x == y));
62       return z;
63     }
64 
65 }
66 
67 /*  ERC 20 token */
68 contract StandardToken is Token {
69 
70     function transfer(address _to, uint256 _value) returns (bool success) {
71       if (balances[msg.sender] >= _value && _value > 0) {
72         balances[msg.sender] -= _value;
73         balances[_to] += _value;
74         Transfer(msg.sender, _to, _value);
75         return true;
76       } else {
77         return false;
78       }
79     }
80 
81     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
82       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
83         balances[_to] += _value;
84         balances[_from] -= _value;
85         allowed[_from][msg.sender] -= _value;
86         Transfer(_from, _to, _value);
87         return true;
88       } else {
89         return false;
90       }
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
107     mapping (address => uint256) balances;
108     mapping (address => mapping (address => uint256)) allowed;
109 }
110 
111 contract UnlimitedIPToken is StandardToken, SafeMath {
112 
113     // metadata
114     string  public constant name = "UnlimitedIP Token";
115     string  public constant symbol = "UIP";
116     uint256 public constant decimals = 18;
117     string  public version = "1.0";
118 
119     // contracts
120     address public ethFundDeposit;          // deposit address for ETH for UnlimitedIP Team.
121     address public newContractAddr;         // the new contract for UnlimitedIP token updates;
122 
123     // crowdsale parameters
124     bool    public isFunding;                // switched to true in operational state
125     uint256 public fundingStartBlock;
126     uint256 public fundingStopBlock;
127 
128     uint256 public currentSupply;           // current supply tokens for sell
129     uint256 public tokenRaised = 0;         // the number of total sold token
130     uint256 public tokenMigrated = 0;     // the number of total transferted token
131     uint256 public tokenExchangeRate = 1000;             // 1000 UIP tokens per 1 ETH
132 
133     // events
134     event IssueToken(address indexed _to, uint256 _value);      // issue token for public sale;
135     event IncreaseSupply(uint256 _value);
136     event DecreaseSupply(uint256 _value);
137     event Migrate(address indexed _to, uint256 _value);
138     event Burn(address indexed from, uint256 _value);
139     // format decimals.
140     function formatDecimals(uint256 _value) internal returns (uint256 ) {
141         return _value * 10 ** decimals;
142     }
143 
144     // constructor
145     function UnlimitedIPToken()
146     {
147         ethFundDeposit = 0xBbf91Cf4cf582600BEcBb63d5BdB8D969F21779C;
148 
149         isFunding = false;                           //controls pre through crowdsale state
150         fundingStartBlock = 0;
151         fundingStopBlock = 0;
152 
153         currentSupply = formatDecimals(0);
154         totalSupply = formatDecimals(3000000000);
155         require(currentSupply <= totalSupply);
156         balances[ethFundDeposit] = totalSupply-currentSupply;
157     }
158 
159     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
160 
161     /// @dev set the token's tokenExchangeRate,
162     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
163         require(_tokenExchangeRate > 0);
164         require(_tokenExchangeRate != tokenExchangeRate);
165         tokenExchangeRate = _tokenExchangeRate;
166     }
167 
168     /// @dev increase the token's supply
169     function increaseSupply (uint256 _value) isOwner external {
170         uint256 value = formatDecimals(_value);
171         require (value + currentSupply <= totalSupply);
172         require (balances[msg.sender] >= value && value>0);
173         balances[msg.sender] -= value;
174         currentSupply = safeAdd(currentSupply, value);
175         IncreaseSupply(value);
176     }
177 
178     /// @dev decrease the token's supply
179     function decreaseSupply (uint256 _value) isOwner external {
180         uint256 value = formatDecimals(_value);
181         require (value + tokenRaised <= currentSupply);
182         currentSupply = safeSubtract(currentSupply, value);
183         balances[msg.sender] += value;
184         DecreaseSupply(value);
185     }
186 
187     /// @dev turn on the funding state
188     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
189         require(!isFunding);
190         require(_fundingStartBlock < _fundingStopBlock);
191         require(block.number < _fundingStartBlock) ;
192         fundingStartBlock = _fundingStartBlock;
193         fundingStopBlock = _fundingStopBlock;
194         isFunding = true;
195     }
196 
197     /// @dev turn off the funding state
198     function stopFunding() isOwner external {
199         require(isFunding);
200         isFunding = false;
201     }
202 
203     /// @dev set a new contract for recieve the tokens (for update contract)
204     function setMigrateContract(address _newContractAddr) isOwner external {
205         require(_newContractAddr != newContractAddr);
206         newContractAddr = _newContractAddr;
207     }
208 
209     /// @dev set a new owner.
210     function changeOwner(address _newFundDeposit) isOwner() external {
211         require(_newFundDeposit != address(0x0));
212         ethFundDeposit = _newFundDeposit;
213     }
214 
215     /// sends the tokens to new contract
216     function migrate() external {
217         require(!isFunding);
218         require(newContractAddr != address(0x0));
219 
220         uint256 tokens = balances[msg.sender];
221         require (tokens > 0);
222 
223         balances[msg.sender] = 0;
224         tokenMigrated = safeAdd(tokenMigrated, tokens);
225 
226         IMigrationContract newContract = IMigrationContract(newContractAddr);
227         require(newContract.migrate(msg.sender, tokens));
228 
229         Migrate(msg.sender, tokens);               // log it
230     }
231 
232     /// @dev withdraw ETH from contract to UnlimitedIP team address
233     function transferETH() isOwner external {
234         require(this.balance > 0);
235         require(ethFundDeposit.send(this.balance));
236     }
237 
238     function burn(uint256 _value) isOwner returns (bool success){
239         uint256 value = formatDecimals(_value);
240         require(balances[msg.sender] >= value && value>0);
241         balances[msg.sender] -= value;
242         totalSupply -= value;
243         Burn(msg.sender,value);
244         return true;
245     }
246 
247     /// buys the tokens
248     function () payable {
249         require (isFunding);
250         require(msg.value > 0);
251 
252         require(block.number >= fundingStartBlock);
253         require(block.number <= fundingStopBlock);
254 
255         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
256         require(tokens + tokenRaised <= currentSupply);
257 
258         tokenRaised = safeAdd(tokenRaised, tokens);
259         balances[msg.sender] += tokens;
260 
261         IssueToken(msg.sender, tokens);  // logs token issued
262     }
263 }