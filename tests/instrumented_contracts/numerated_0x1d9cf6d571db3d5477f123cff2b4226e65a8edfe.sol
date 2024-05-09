1 pragma solidity ^0.4.12;
2  
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) returns (bool success);
5 }
6  
7 /* taking ideas from FirstBlood token */
8 contract SafeMath {
9     /* function assert(bool assertion) internal { */
10     /*   if (!assertion) { */
11     /*     throw; */
12     /*   } */
13     /* }      // assert no longer needed once solidity is on 0.4.10 */
14  
15  
16     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
17         uint256 z = x + y;
18         assert((z >= x) && (z >= y));
19         return z;
20     }
21  
22     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
23         assert(x >= y);
24         uint256 z = x - y;
25         return z;
26     }
27  
28     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
29         uint256 z = x * y;
30         assert((x == 0)||(z/x == y));
31         return z;
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
52         if (balances[msg.sender] >= _value && _value > 0) {
53             balances[msg.sender] -= _value;
54             balances[_to] += _value;
55             Transfer(msg.sender, _to, _value);
56             return true;
57         } else {
58             return false;
59         }
60     }
61  
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
64             balances[_to] += _value;
65             balances[_from] -= _value;
66             allowed[_from][msg.sender] -= _value;
67             Transfer(_from, _to, _value);
68             return true;
69         } else {
70             return false;
71         }
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
85         return allowed[_owner][_spender];
86     }
87  
88     mapping (address => uint256) balances;
89     mapping (address => mapping (address => uint256)) allowed;
90 }
91  
92 contract SYSCToken is StandardToken, SafeMath {
93  
94     // metadata
95     string  public constant name = "水芸链";
96     string  public constant symbol = "SYSC";
97     uint256 public constant decimals = 18;
98     string  public version = "1.0";
99  
100     // contracts
101     address public ethFundDeposit;          // deposit address for ETH for Nebulas Team.
102     address public newContractAddr;         // the new contract for nebulas token updates;
103  
104     // crowdsale parameters
105     bool    public isFunding;                // switched to true in operational state
106     uint256 public fundingStartBlock;
107     uint256 public fundingStopBlock;
108  
109     uint256 public currentSupply;           // current supply tokens for sell
110     uint256 public tokenRaised = 0;         // the number of total sold token
111     uint256 public tokenMigrated = 0;      // the number of total transferted token
112     uint256 public tokenExchangeRate = 625;              // 625 NAS tokens per 1 ETH
113  
114     // events
115     event AllocateToken(address indexed _to, uint256 _value);    // allocate token for private sale;
116     event IssueToken(address indexed _to, uint256 _value);      // issue token for public sale;
117     event IncreaseSupply(uint256 _value);
118     event DecreaseSupply(uint256 _value);
119     event Migrate(address indexed _to, uint256 _value);
120  
121     
122     function formatDecimals(uint256 _value) internal returns (uint256 ) {
123         return _value * 10 ** decimals;
124     }
125  
126     // constructor
127     function SYSCToken(
128         address _ethFundDeposit,
129         uint256 _currentSupply)
130     {
131         ethFundDeposit = _ethFundDeposit;
132  
133         isFunding = false;                          //controls pre through crowdsale state
134         fundingStartBlock = 0;
135         fundingStopBlock = 0;
136  
137         currentSupply = formatDecimals(_currentSupply);
138         totalSupply = formatDecimals(1000000000);
139         balances[msg.sender] = totalSupply;
140         if(currentSupply > totalSupply) throw;
141     }
142  
143     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
144  
145     /// @dev set the token's tokenExchangeRate,
146     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
147         if (_tokenExchangeRate == 0) throw;
148         if (_tokenExchangeRate == tokenExchangeRate) throw;
149  
150         tokenExchangeRate = _tokenExchangeRate;
151     }
152  
153      /// @dev increase the token's supply
154     function increaseSupply (uint256 _value) isOwner external {
155         uint256 value = formatDecimals(_value);
156         if (value + currentSupply > totalSupply) throw;
157         currentSupply = safeAdd(currentSupply, value);
158         IncreaseSupply(value);
159     }
160  
161     /// @dev decrease the token's supply
162     function decreaseSupply (uint256 _value) isOwner external {
163         uint256 value = formatDecimals(_value);
164         if (value + tokenRaised > currentSupply) throw;
165  
166         currentSupply = safeSubtract(currentSupply, value);
167         DecreaseSupply(value);
168     }
169  
170    /// @dev turn on the funding state
171     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
172         if (isFunding) throw;
173         if (_fundingStartBlock >= _fundingStopBlock) throw;
174         if (block.number >= _fundingStartBlock) throw;
175  
176         fundingStartBlock = _fundingStartBlock;
177         fundingStopBlock = _fundingStopBlock;
178         isFunding = true;
179     }
180  
181    /// @dev turn off the funding state
182     function stopFunding() isOwner external {
183         if (!isFunding) throw;
184         isFunding = false;
185     }
186  
187      /// @dev set a new contract for recieve the tokens (for update contract)
188     function setMigrateContract(address _newContractAddr) isOwner external {
189         if (_newContractAddr == newContractAddr) throw;
190         newContractAddr = _newContractAddr;
191     }
192  
193     /// @dev set a new owner.
194     function changeOwner(address _newFundDeposit) isOwner() external {
195         if (_newFundDeposit == address(0x0)) throw;
196         ethFundDeposit = _newFundDeposit;
197     }
198  
199     /// sends the tokens to new contract
200     function migrate() external {
201         if(isFunding) throw;
202         if(newContractAddr == address(0x0)) throw;
203  
204         uint256 tokens = balances[msg.sender];
205         if (tokens == 0) throw;
206  
207         balances[msg.sender] = 0;
208         tokenMigrated = safeAdd(tokenMigrated, tokens);
209  
210         IMigrationContract newContract = IMigrationContract(newContractAddr);
211         if (!newContract.migrate(msg.sender, tokens)) throw;
212  
213         Migrate(msg.sender, tokens);               // log it
214     }
215  
216     /// @dev sends ETH to Nebulas team
217     function transferETH() isOwner external {
218         if (this.balance == 0) throw;
219         if (!ethFundDeposit.send(this.balance)) throw;
220     }
221  
222     /// @dev allocates NAS tokens to pre-sell address.
223     function allocateToken (address _addr, uint256 _eth) isOwner external {
224         if (_eth == 0) throw;
225         if (_addr == address(0x0)) throw;
226  
227         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
228         if (tokens + tokenRaised > currentSupply) throw;
229  
230         tokenRaised = safeAdd(tokenRaised, tokens);
231         balances[_addr] += tokens;
232  
233         AllocateToken(_addr, tokens);  
234     }
235  
236     /// buys the tokens
237     function () payable {
238         if (!isFunding) throw;
239         if (msg.value == 0) throw;
240  
241         if (block.number < fundingStartBlock) throw;
242         if (block.number > fundingStopBlock) throw;
243  
244         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
245         if (tokens + tokenRaised > currentSupply) throw;
246  
247         tokenRaised = safeAdd(tokenRaised, tokens);
248         balances[msg.sender] += tokens;
249  
250         IssueToken(msg.sender, tokens);  
251     }
252 }