1 pragma solidity >=0.4.12 <0.7.0;
2  
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) public returns (bool success);
5 }
6  
7 
8 contract SafeMath {
9  
10  
11     function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {
12         uint256 z = x + y;
13         assert((z >= x) && (z >= y));
14         return z;
15     }
16  
17     function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {
18         assert(x >= y);
19         uint256 z = x - y;
20         return z;
21     }
22  
23     function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {
24         uint256 z = x * y;
25         assert((x == 0)||(z/x == y));
26         return z;
27     }
28  
29 }
30  
31 contract Token {
32     uint256 public totalSupply;
33     function balanceOf(address _owner) view public returns (uint256 balance);
34     function transfer(address _to, uint256 _value) public returns (bool success);
35     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
36     function approve(address _spender, uint256 _value) public returns (bool success);
37     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41  
42  
43 /*  ERC 20 token */
44 contract StandardToken is Token {
45  
46     function transfer(address _to, uint256 _value) public returns (bool success) {
47         if (balances[msg.sender] >= _value && _value > 0) {
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             emit Transfer(msg.sender, _to, _value);
51             return true;
52         } else {
53             return false;
54         }
55     }
56  
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
59             balances[_to] += _value;
60             balances[_from] -= _value;
61             allowed[_from][msg.sender] -= _value;
62             emit Transfer(_from, _to, _value);
63             return true;
64         } else {
65             return false;
66         }
67     }
68  
69     function balanceOf(address _owner) view public returns (uint256 balance) {
70         return balances[_owner];
71     }
72  
73     function approve(address _spender, uint256 _value) public returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         emit Approval(msg.sender, _spender, _value);
76         return true;
77     }
78  
79     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
80         return allowed[_owner][_spender];
81     }
82  
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowed;
85 }
86  
87 contract GMCToken is StandardToken, SafeMath {
88  
89     // metadata
90     string  public constant name = "GMCToken";
91     string  public constant symbol = "GMC";
92     uint256 public constant decimals = 18;
93     string  public version = "1.0";
94  
95     // contracts
96     address public ethFundDeposit;
97     address public newContractAddr;
98  
99     // crowdsale parameters
100     bool    public isFunding;
101     uint256 public fundingStartBlock;
102     uint256 public fundingStopBlock;
103  
104     uint256 public currentSupply;
105     uint256 public tokenRaised = 0;
106     uint256 public tokenMigrated = 0;
107     uint256 public tokenExchangeRate = 6250;
108  
109     // events
110     event AllocateToken(address indexed _to, uint256 _value);
111     event IssueToken(address indexed _to, uint256 _value);
112     event IncreaseSupply(uint256 _value);
113     event DecreaseSupply(uint256 _value);
114     event Migrate(address indexed _to, uint256 _value);
115  
116     function formatDecimals(uint256 _value)pure internal returns (uint256 ) {
117         return _value * 10 ** decimals;
118     }
119  
120     // constructor
121     constructor (
122         address _ethFundDeposit,
123         uint256 _currentSupply) public
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
134         if(currentSupply > totalSupply) revert();
135     }
136  
137     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
138  
139     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
140         if (_tokenExchangeRate == 0) revert();
141         if (_tokenExchangeRate == tokenExchangeRate) revert();
142  
143         tokenExchangeRate = _tokenExchangeRate;
144     }
145  
146     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
147         if (isFunding) revert();
148         if (_fundingStartBlock >= _fundingStopBlock) revert();
149         if (block.number >= _fundingStartBlock) revert();
150  
151         fundingStartBlock = _fundingStartBlock;
152         fundingStopBlock = _fundingStopBlock;
153         isFunding = true;
154     }
155  
156     function stopFunding() isOwner external {
157         if (!isFunding) revert();
158         isFunding = false;
159     }
160  
161     function setMigrateContract(address _newContractAddr) isOwner external {
162         if (_newContractAddr == newContractAddr) revert();
163         newContractAddr = _newContractAddr;
164     }
165  
166     function changeOwner(address _newFundDeposit) isOwner() external {
167         if (_newFundDeposit == address(0x0)) revert();
168         ethFundDeposit = _newFundDeposit;
169     }
170  
171     function migrate() external {
172         if(isFunding) revert();
173         if(newContractAddr == address(0x0)) revert();
174  
175         uint256 tokens = balances[msg.sender];
176         if (tokens == 0) revert();
177  
178         balances[msg.sender] = 0;
179         tokenMigrated = safeAdd(tokenMigrated, tokens);
180  
181         IMigrationContract newContract = IMigrationContract(newContractAddr);
182         if (!newContract.migrate(msg.sender, tokens)) revert();
183  
184         emit Migrate(msg.sender, tokens);               // log it
185     }
186  
187     function allocateToken (address _addr, uint256 _eth) isOwner external {
188         if (_eth == 0) revert();
189         if (_addr == address(0x0)) revert();
190  
191         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
192         if (tokens + tokenRaised > currentSupply) revert();
193  
194         tokenRaised = safeAdd(tokenRaised, tokens);
195         balances[_addr] += tokens;
196  
197         emit AllocateToken(_addr, tokens);
198     }
199  
200     function () payable external {
201         if (!isFunding) revert();
202         if (msg.value == 0) revert();
203  
204         if (block.number < fundingStartBlock) revert();
205         if (block.number > fundingStopBlock) revert();
206  
207         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
208         if (tokens + tokenRaised > currentSupply) revert();
209  
210         tokenRaised = safeAdd(tokenRaised, tokens);
211         balances[msg.sender] += tokens;
212  
213         emit IssueToken(msg.sender, tokens);
214     }
215 }