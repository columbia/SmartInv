1 pragma solidity ^0.4.12;
2  
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) returns (bool success);
5 }
6  
7 contract SafeMath {
8  
9  
10     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
11         uint256 z = x + y;
12         assert((z >= x) && (z >= y));
13         return z;
14     }
15  
16     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
17         assert(x >= y);
18         uint256 z = x - y;
19         return z;
20     }
21  
22     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
23         uint256 z = x * y;
24         assert((x == 0)||(z/x == y));
25         return z;
26     }
27  
28 }
29  
30 contract Token {
31     uint256 public totalSupply;
32     function balanceOf(address _owner) constant returns (uint256 balance);
33     function transfer(address _to, uint256 _value) returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35     function approve(address _spender, uint256 _value) returns (bool success);
36     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40  
41  
42 /*  ERC 20 token */
43 contract StandardToken is Token {
44  
45     function transfer(address _to, uint256 _value) returns (bool success) {
46         if (balances[msg.sender] >= _value && _value > 0) {
47             balances[msg.sender] -= _value;
48             balances[_to] += _value;
49             Transfer(msg.sender, _to, _value);
50             return true;
51         } else {
52             return false;
53         }
54     }
55  
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
58             balances[_to] += _value;
59             balances[_from] -= _value;
60             allowed[_from][msg.sender] -= _value;
61             Transfer(_from, _to, _value);
62             return true;
63         } else {
64             return false;
65         }
66     }
67  
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71  
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77  
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79         return allowed[_owner][_spender];
80     }
81  
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84 }
85  
86 contract SPMTToken is StandardToken, SafeMath {
87  
88     // metadata
89     string  public constant name = "Super Pass Mall Token";
90     string  public constant symbol = "SPMT";
91     uint256 public constant decimals = 18;
92     string  public version = "1.0";
93  
94     // contracts
95     address public ethFundDeposit;          
96     address public newContractAddr;         
97  
98     // crowdsale parameters
99     bool    public isFunding;                
100     uint256 public fundingStartBlock;
101     uint256 public fundingStopBlock;
102  
103     uint256 public currentSupply;           
104     uint256 public tokenRaised = 0;        
105     uint256 public tokenMigrated = 0;     
106     uint256 public tokenExchangeRate = 625;             
107  
108     // events
109     event AllocateToken(address indexed _to, uint256 _value);  
110     event IssueToken(address indexed _to, uint256 _value);      
111     event IncreaseSupply(uint256 _value);
112     event DecreaseSupply(uint256 _value);
113     event Migrate(address indexed _to, uint256 _value);
114  
115     // 
116     function formatDecimals(uint256 _value) internal returns (uint256 ) {
117         return _value * 10 ** decimals;
118     }
119  
120     // constructor
121     function SPMTToken(
122         address _ethFundDeposit,
123         uint256 _currentSupply)
124     {
125         ethFundDeposit = _ethFundDeposit;
126  
127         isFunding = false;                           
128         fundingStartBlock = 0;
129         fundingStopBlock = 0;
130  
131         currentSupply = formatDecimals(_currentSupply);
132         totalSupply = formatDecimals(1000000000);
133         balances[msg.sender] = totalSupply;
134         if(currentSupply > totalSupply) throw;
135     }
136  
137     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
138  
139     ///  
140     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
141         if (_tokenExchangeRate == 0) throw;
142         if (_tokenExchangeRate == tokenExchangeRate) throw;
143  
144         tokenExchangeRate = _tokenExchangeRate;
145     }
146  
147     function increaseSupply (uint256 _value) isOwner external {
148         uint256 value = formatDecimals(_value);
149         if (value + currentSupply > totalSupply) throw;
150         currentSupply = safeAdd(currentSupply, value);
151         IncreaseSupply(value);
152     }
153  
154     /// @dev 
155     function decreaseSupply (uint256 _value) isOwner external {
156         uint256 value = formatDecimals(_value);
157         if (value + tokenRaised > currentSupply) throw;
158  
159         currentSupply = safeSubtract(currentSupply, value);
160         DecreaseSupply(value);
161     }
162  
163     ///  
164     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
165         if (isFunding) throw;
166         if (_fundingStartBlock >= _fundingStopBlock) throw;
167         if (block.number >= _fundingStartBlock) throw;
168  
169         fundingStartBlock = _fundingStartBlock;
170         fundingStopBlock = _fundingStopBlock;
171         isFunding = true;
172     }
173  
174     ///  
175     function stopFunding() isOwner external {
176         if (!isFunding) throw;
177         isFunding = false;
178     }
179  
180     /// 
181     function setMigrateContract(address _newContractAddr) isOwner external {
182         if (_newContractAddr == newContractAddr) throw;
183         newContractAddr = _newContractAddr;
184     }
185  
186     /// 
187     function changeOwner(address _newFundDeposit) isOwner() external {
188         if (_newFundDeposit == address(0x0)) throw;
189         ethFundDeposit = _newFundDeposit;
190     }
191  
192     ///
193     function migrate() external {
194         if(isFunding) throw;
195         if(newContractAddr == address(0x0)) throw;
196  
197         uint256 tokens = balances[msg.sender];
198         if (tokens == 0) throw;
199  
200         balances[msg.sender] = 0;
201         tokenMigrated = safeAdd(tokenMigrated, tokens);
202  
203         IMigrationContract newContract = IMigrationContract(newContractAddr);
204         if (!newContract.migrate(msg.sender, tokens)) throw;
205  
206         Migrate(msg.sender, tokens);               // log it
207     }
208  
209     /// 
210     function transferETH() isOwner external {
211         if (this.balance == 0) throw;
212         if (!ethFundDeposit.send(this.balance)) throw;
213     }
214  
215     /// 
216     function allocateToken (address _addr, uint256 _eth) isOwner external {
217         if (_eth == 0) throw;
218         if (_addr == address(0x0)) throw;
219  
220         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
221         if (tokens + tokenRaised > currentSupply) throw;
222  
223         tokenRaised = safeAdd(tokenRaised, tokens);
224         balances[_addr] += tokens;
225  
226         AllocateToken(_addr, tokens);  // 
227     }
228  
229     /// 
230     function () payable {
231         if (!isFunding) throw;
232         if (msg.value == 0) throw;
233  
234         if (block.number < fundingStartBlock) throw;
235         if (block.number > fundingStopBlock) throw;
236  
237         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
238         if (tokens + tokenRaised > currentSupply) throw;
239  
240         tokenRaised = safeAdd(tokenRaised, tokens);
241         balances[msg.sender] += tokens;
242  
243         IssueToken(msg.sender, tokens);  //
244     }
245 }