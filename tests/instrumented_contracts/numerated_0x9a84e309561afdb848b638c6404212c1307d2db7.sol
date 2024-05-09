1 pragma solidity ^0.4.12;
2 
3 contract IMigrationContract {
4     function migrate(address addr, uint256 xxc) returns (bool success);
5 }
6 
7 /* taking ideas from FirstBlood token */
8 contract SafeMath {
9 
10     /* function assert(bool assertion) internal { */
11     /*   if (!assertion) { */
12     /*     throw; */
13     /*   } */
14     /* }      // assert no longer needed once solidity is on 0.4.10 */
15 
16     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
17       uint256 z = x + y;
18       assert((z >= x) && (z >= y));
19       return z;
20     }
21 
22     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
23       assert(x >= y);
24       uint256 z = x - y;
25       return z;
26     }
27 
28     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
29       uint256 z = x * y;
30       assert((x == 0)||(z/x == y));
31       return z;
32     }
33 
34 }
35 
36 contract Token {
37     uint256 public totalSupply;
38     function balanceOf(address _owner) constant returns (uint256 balance);
39     function transfer(address _to, uint256 _value) returns (bool success);
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
41     function approve(address _spender, uint256 _value) returns (bool success);
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 
48 /*  ERC 20 token */
49 contract StandardToken is Token {
50 
51     function transfer(address _to, uint256 _value) returns (bool success) {
52       if (balances[msg.sender] >= _value && _value > 0) {
53         balances[msg.sender] -= _value;
54         balances[_to] += _value;
55         Transfer(msg.sender, _to, _value);
56         return true;
57       } else {
58         return false;
59       }
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
64         balances[_to] += _value;
65         balances[_from] -= _value;
66         allowed[_from][msg.sender] -= _value;
67         Transfer(_from, _to, _value);
68         return true;
69       } else {
70         return false;
71       }
72     }
73 
74     function balanceOf(address _owner) constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     function approve(address _spender, uint256 _value) returns (bool success) {
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
85       return allowed[_owner][_spender];
86     }
87 
88     mapping (address => uint256) balances;
89     mapping (address => mapping (address => uint256)) allowed;
90 }
91 
92 contract XinXianToken is StandardToken, SafeMath {
93 
94     // metadata
95     string  public constant name = "XinXian";
96     string  public constant symbol = "XXC";
97     uint256 public constant decimals = 18;
98     string  public version = "1.0";
99 
100     // contracts
101     address public ethFundDeposit;          // deposit address for ETH for XinXian Team.
102     address public newContractAddr;         // the new contract for XinXian token updates;
103 
104     // crowdsale parameters
105     bool    public isFunding;                // switched to true in operational state
106     uint256 public fundingStartBlock;
107     uint256 public fundingStopBlock;
108 
109     uint256 public currentSupply;           // current supply tokens for sell
110     uint256 public tokenRaised = 0;         // the number of total sold token
111     uint256 public tokenMigrated = 0;     // the number of total transferted token
112     uint256 public tokenExchangeRate = 625;             // 625 tokens per 1 ETH
113 
114     // events
115     event AllocateToken(address indexed _to, uint256 _value);   // allocate token for private sale;
116     event IssueToken(address indexed _to, uint256 _value);      // issue token for public sale;
117     event IncreaseSupply(uint256 _value);
118     event DecreaseSupply(uint256 _value);
119     event Migrate(address indexed _to, uint256 _value);
120 
121     // format decimals.
122     function formatDecimals(uint256 _value) internal returns (uint256 ) {
123         return _value * 10 ** decimals;
124     }
125 
126     // constructor
127     function XinXianToken(
128         address _ethFundDeposit,
129         uint256 _currentSupply)
130     {
131         ethFundDeposit = _ethFundDeposit;
132 
133         isFunding = false;                           //controls pre through crowdsale state
134         fundingStartBlock = 0;
135         fundingStopBlock = 0;
136 
137         currentSupply = formatDecimals(_currentSupply);
138         totalSupply = formatDecimals(1000000000); 
139         if(currentSupply > totalSupply) throw;
140     }
141 
142     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
143 
144     /// @dev set the token's tokenExchangeRate,
145     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
146         if (_tokenExchangeRate == 0) throw;
147         if (_tokenExchangeRate == tokenExchangeRate) throw;
148 
149         tokenExchangeRate = _tokenExchangeRate;
150     }
151 
152     /// @dev increase the token's supply
153     function increaseSupply (uint256 _value) isOwner external {
154         uint256 value = formatDecimals(_value);
155         if (value + currentSupply > totalSupply) throw;
156         currentSupply = safeAdd(currentSupply, value);
157         IncreaseSupply(value);
158     }
159 
160     /// @dev decrease the token's supply
161     function decreaseSupply (uint256 _value) isOwner external {
162         uint256 value = formatDecimals(_value);
163         if (value + tokenRaised > currentSupply) throw;
164 
165         currentSupply = safeSubtract(currentSupply, value);
166         DecreaseSupply(value);
167     }
168 
169     /// @dev turn on the funding state
170     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
171         if (isFunding) throw;
172         if (_fundingStartBlock >= _fundingStopBlock) throw;
173         if (block.number >= _fundingStartBlock) throw;
174 
175         fundingStartBlock = _fundingStartBlock;
176         fundingStopBlock = _fundingStopBlock;
177         isFunding = true;
178     }
179 
180     /// @dev turn off the funding state
181     function stopFunding() isOwner external {
182         if (!isFunding) throw;
183         isFunding = false;
184     }
185 
186     /// @dev set a new contract for recieve the tokens (for update contract)
187     function setMigrateContract(address _newContractAddr) isOwner external {
188         if (_newContractAddr == newContractAddr) throw;
189         newContractAddr = _newContractAddr;
190     }
191 
192     /// @dev set a new owner.
193     function changeOwner(address _newFundDeposit) isOwner() external {
194         if (_newFundDeposit == address(0x0)) throw;
195         ethFundDeposit = _newFundDeposit;
196     }
197 
198     /// sends the tokens to new contract
199     function migrate() external {
200         if(isFunding) throw;
201         if(newContractAddr == address(0x0)) throw;
202 
203         uint256 tokens = balances[msg.sender];
204         if (tokens == 0) throw;
205 
206         balances[msg.sender] = 0;
207         tokenMigrated = safeAdd(tokenMigrated, tokens);
208 
209         IMigrationContract newContract = IMigrationContract(newContractAddr);
210         if (!newContract.migrate(msg.sender, tokens)) throw;
211 
212         Migrate(msg.sender, tokens);               // log it
213     }
214 
215     /// @dev sends ETH to XinXian team
216     function transferETH() isOwner external {
217         if (this.balance == 0) throw;
218         if (!ethFundDeposit.send(this.balance)) throw;
219     }
220 
221     /// @dev allocates tokens to pre-sell address.
222     function allocateToken (address _addr, uint256 _eth) isOwner external {
223         if (_eth == 0) throw;
224         if (_addr == address(0x0)) throw;
225 
226         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
227         if (tokens + tokenRaised > currentSupply) throw;
228 
229         tokenRaised = safeAdd(tokenRaised, tokens);
230         balances[_addr] += tokens;
231 
232         AllocateToken(_addr, tokens);  // logs token issued
233     }
234 
235     /// buys the tokens
236     function () payable {
237         if (!isFunding) throw;
238         if (msg.value == 0) throw;
239 
240         if (block.number < fundingStartBlock) throw;
241         if (block.number > fundingStopBlock) throw;
242 
243         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
244         if (tokens + tokenRaised > currentSupply) throw;
245 
246         tokenRaised = safeAdd(tokenRaised, tokens);
247         balances[msg.sender] += tokens;
248 
249         IssueToken(msg.sender, tokens);  // logs token issued
250     }
251 }