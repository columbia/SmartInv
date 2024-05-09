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
52 	    require(_to != address(0));
53 	    require(_value <= balances[msg.sender]);
54 
55 	    balances[msg.sender] -= _value;
56 	    balances[_to] += _value;
57 	    emit Transfer(msg.sender, _to, _value);
58 	    return true;
59 	}
60 
61 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
62 	    require(_to != address(0));
63 	    require(_value <= balances[_from]);
64 	    require(_value <= allowed[_from][msg.sender]);
65 
66 	    balances[_from] -= _value;
67 	    balances[_to] += _value;
68 	    allowed[_from][msg.sender] -= _value;
69 	    emit Transfer(_from, _to, _value);
70 	    return true;
71 	}
72  
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76  
77     function approve(address _spender, uint256 _value) returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82  
83     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
84         return allowed[_owner][_spender];
85     }
86  
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89 }
90  
91 contract LEOSToken is StandardToken, SafeMath {
92  
93     // metadata
94     string  public constant name = "LEOS";
95     string  public constant symbol = "LEOS";
96     uint256 public constant decimals = 18;
97     string  public version = "1.0";
98  
99     // contracts
100     address public ethFundDeposit;          // deposit address for ETH for Nebulas Team.
101     address public newContractAddr;         // the new contract for nebulas token updates;
102  
103     // crowdsale parameters
104     bool    public isFunding;                // switched to true in operational state
105     uint256 public fundingStartBlock;
106     uint256 public fundingStopBlock;
107  
108     uint256 public currentSupply;           // current supply tokens for sell
109     uint256 public tokenRaised = 0;         // the number of total sold token
110     uint256 public tokenMigrated = 0;      // the number of total transferted token
111     uint256 public tokenExchangeRate = 625;              // 625 NAS tokens per 1 ETH
112  
113     // events
114     event AllocateToken(address indexed _to, uint256 _value);    // allocate token for private sale;
115     event IssueToken(address indexed _to, uint256 _value);      // issue token for public sale;
116     event IncreaseSupply(uint256 _value);
117     event DecreaseSupply(uint256 _value);
118     event Migrate(address indexed _to, uint256 _value);
119  
120     
121     function formatDecimals(uint256 _value) internal returns (uint256 ) {
122         return _value * 10 ** decimals;
123     }
124  
125     // constructor
126     function LEOSToken(
127         address _ethFundDeposit,
128         uint256 _currentSupply)
129     {
130         ethFundDeposit = _ethFundDeposit;
131  
132         isFunding = false;                          //controls pre through crowdsale state
133         fundingStartBlock = 0;
134         fundingStopBlock = 0;
135  
136         currentSupply = formatDecimals(_currentSupply);
137         totalSupply = formatDecimals(300000000);
138         balances[msg.sender] = totalSupply;
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
152  
153     /// @dev decrease the token's supply
154     function decreaseSupply (uint256 _value) isOwner external {
155         uint256 value = formatDecimals(_value);
156         if (value + tokenRaised > currentSupply) throw;
157  
158         currentSupply = safeSubtract(currentSupply, value);
159         DecreaseSupply(value);
160     }
161  
162    /// @dev turn on the funding state
163     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
164         if (isFunding) throw;
165         if (_fundingStartBlock >= _fundingStopBlock) throw;
166         if (block.number >= _fundingStartBlock) throw;
167  
168         fundingStartBlock = _fundingStartBlock;
169         fundingStopBlock = _fundingStopBlock;
170         isFunding = true;
171     }
172  
173    /// @dev turn off the funding state
174     function stopFunding() isOwner external {
175         if (!isFunding) throw;
176         isFunding = false;
177     }
178  
179      /// @dev set a new contract for recieve the tokens (for update contract)
180     function setMigrateContract(address _newContractAddr) isOwner external {
181         if (_newContractAddr == newContractAddr) throw;
182         newContractAddr = _newContractAddr;
183     }
184  
185     /// @dev set a new owner.
186     function changeOwner(address _newFundDeposit) isOwner() external {
187         if (_newFundDeposit == address(0x0)) throw;
188         ethFundDeposit = _newFundDeposit;
189     }
190  
191     /// sends the tokens to new contract
192     function migrate() external {
193         if(isFunding) throw;
194         if(newContractAddr == address(0x0)) throw;
195  
196         uint256 tokens = balances[msg.sender];
197         if (tokens == 0) throw;
198  
199         balances[msg.sender] = 0;
200         tokenMigrated = safeAdd(tokenMigrated, tokens);
201  
202         IMigrationContract newContract = IMigrationContract(newContractAddr);
203         if (!newContract.migrate(msg.sender, tokens)) throw;
204  
205         Migrate(msg.sender, tokens);               // log it
206     }
207  
208     /// @dev sends ETH to Nebulas team
209     function transferETH() isOwner external {
210         if (this.balance == 0) throw;
211         if (!ethFundDeposit.send(this.balance)) throw;
212     }
213  
214     /// @dev allocates NAS tokens to pre-sell address.
215     function allocateToken (address _addr, uint256 _eth) isOwner external {
216         if (_eth == 0) throw;
217         if (_addr == address(0x0)) throw;
218  
219         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
220         if (tokens + tokenRaised > currentSupply) throw;
221  
222         tokenRaised = safeAdd(tokenRaised, tokens);
223         balances[_addr] += tokens;
224  
225         AllocateToken(_addr, tokens);  
226     }
227  
228     /// buys the tokens
229     function () payable {
230         if (!isFunding) throw;
231         if (msg.value == 0) throw;
232  
233         if (block.number < fundingStartBlock) throw;
234         if (block.number > fundingStopBlock) throw;
235  
236         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
237         if (tokens + tokenRaised > currentSupply) throw;
238  
239         tokenRaised = safeAdd(tokenRaised, tokens);
240         balances[msg.sender] += tokens;
241  
242         IssueToken(msg.sender, tokens);  
243     }}