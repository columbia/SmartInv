1 pragma solidity 0.4.24;
2 
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) public returns (bool success);
5 }
6 
7 /* taking ideas from FirstBlood token */
8 contract SafeMath {
9 
10     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
11         uint256 z = x + y;
12         assert((z >= x) && (z >= y));
13         return z;
14     }
15 
16     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
17         assert(x >= y);
18         uint256 z = x - y;
19         return z;
20     }
21 
22     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
23         uint256 z = x * y;
24         assert((x == 0)||(z/x == y));
25         return z;
26     }
27 
28 }
29 
30 contract Token {
31     uint256 public totalSupply;
32     function balanceOf(address _owner) public view returns (uint256 balance);
33     function transfer(address _to, uint256 _value) public returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35     function approve(address _spender, uint256 _value) public returns (bool success);
36     function allowance(address _owner, address _spender) public view returns (uint256 remaining); 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40 
41 
42 /*  ERC 20 token */
43 contract StandardToken is Token {
44 
45     function transfer(address _to, uint256 _value) public returns (bool success) {
46         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
47             balances[msg.sender] -= _value;
48             balances[_to] += _value;
49             emit Transfer(msg.sender, _to, _value);
50             return true;
51         } else {
52             return false;
53         }
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
57         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
58             balances[_to] += _value;
59             balances[_from] -= _value;
60             allowed[_from][msg.sender] -= _value;
61             emit Transfer(_from, _to, _value);
62             return true;
63         } else {
64             return false;
65         }
66     }
67 
68     function balanceOf(address _owner) public view returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) public returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         emit Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) public view returns (uint256 remaining) { 
79         return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84 }
85 
86 contract BugXToken is StandardToken, SafeMath {
87 
88     // metadata
89     string  public constant name = "BUGX Token";
90     string  public constant symbol = "BUGX";
91     uint256 public constant decimals = 18;
92     string  public version = "1.0";
93 
94     // contracts
95     address public ethFundDeposit;          // deposit address for ETH for BUGX Team.
96     address public newContractAddr;         // the new contract for BUGX token updates;
97 
98     // crowdsale parameters
99     bool    public isFunding;                // switched to true in operational state
100     uint256 public fundingStartBlock;
101     uint256 public fundingStopBlock;
102 
103     uint256 public currentSupply;           // current supply tokens for sell
104     uint256 public tokenRaised = 0;         // the number of total sold token
105     uint256 public tokenIssued = 0;         // the number of total issued token
106     uint256 public tokenMigrated = 0;     // the number of total transferted token
107     uint256 public tokenExchangeRate = 6000;             // 6000 BXT tokens per 1 ETH
108 
109     // events
110     event AllocateToken(address indexed _to, uint256 _value);   // issue token to buyer;
111     event IssueToken(address indexed _to, uint256 _value);      // record token issue info;
112     event IncreaseSupply(uint256 _value);
113     event DecreaseSupply(uint256 _value);
114     event Migrate(address indexed _to, uint256 _value);
115 
116     // format decimals.
117     function formatDecimals(uint256 _value) internal pure returns (uint256 ) {
118         return _value * 10 ** decimals;
119     }
120 
121     // constructor
122     constructor(
123         address _ethFundDeposit,
124         uint256 _currentSupply) public
125     {
126         ethFundDeposit = _ethFundDeposit;
127 
128         isFunding = false;                           //controls pre through crowdsale state
129         fundingStartBlock = 0;
130         fundingStopBlock = 0;
131 
132         currentSupply = formatDecimals(_currentSupply);
133         totalSupply = formatDecimals(1500000000);    //1,500,000,000 total supply
134         require(currentSupply <= totalSupply);
135     }
136 
137     modifier isOwner()  {require(msg.sender == ethFundDeposit); _;}
138 
139     /// @dev set the token's tokenExchangeRate,
140     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
141         require (_tokenExchangeRate != 0);
142         require (_tokenExchangeRate != tokenExchangeRate);
143 
144         tokenExchangeRate = _tokenExchangeRate;
145     }
146 
147     /// @dev increase the token's supply
148     function increaseSupply (uint256 _value) isOwner external {
149         uint256 value = formatDecimals(_value);
150         require (value + currentSupply <= totalSupply);
151         currentSupply = safeAdd(currentSupply, value);
152         emit IncreaseSupply(value);
153     }
154 
155     /// @dev decrease the token's supply
156     function decreaseSupply (uint256 _value) isOwner external {
157         uint256 value = formatDecimals(_value);
158         require (value + tokenRaised <= currentSupply);
159 
160         currentSupply = safeSubtract(currentSupply, value);
161         emit DecreaseSupply(value);
162     }
163 
164     /// @dev turn on the funding state
165     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
166         require (!isFunding);
167         require (_fundingStartBlock < _fundingStopBlock);
168         require (block.number < _fundingStartBlock);
169 
170         fundingStartBlock = _fundingStartBlock;
171         fundingStopBlock = _fundingStopBlock;
172         isFunding = true;
173     }
174 
175     /// @dev turn off the funding state
176     function stopFunding() isOwner external {
177         require (isFunding);
178         isFunding = false;
179     }
180 
181     /// @dev set a new contract for recieve the tokens (for update contract)
182     function setMigrateContract(address _newContractAddr) isOwner external {
183         require (_newContractAddr != newContractAddr);
184         newContractAddr = _newContractAddr;
185     }
186 
187     /// @dev set a new owner.
188     function changeOwner(address _newFundDeposit) isOwner() external {
189         require (_newFundDeposit != address(0x0));
190         ethFundDeposit = _newFundDeposit;
191     }
192 
193     /// sends the tokens to new contract
194     function migrate() external {
195         require(!isFunding);
196         require(newContractAddr != address(0x0));
197 
198         uint256 tokens = balances[msg.sender];
199         require (tokens != 0);
200 
201         balances[msg.sender] = 0;
202         tokenMigrated = safeAdd(tokenMigrated, tokens);
203 
204         IMigrationContract newContract = IMigrationContract(newContractAddr);
205         require (newContract.migrate(msg.sender, tokens));
206 
207         emit Migrate(msg.sender, tokens);               // log it
208     }
209 
210     /// @dev sends ETH to BUGX team
211     function transferETH() isOwner external {
212         require (address(this).balance != 0);
213         require (ethFundDeposit.send(address(this).balance));
214     }
215 
216     /// @dev allocates BXT tokens to buyers. 25% per 3 months.
217     function allocateToken (address _addr, uint256 _eth) isOwner external {
218         require (_eth != 0);
219         require (_addr != address(0x0));
220 
221         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
222 
223         tokenIssued = safeAdd(tokenIssued, tokens);
224         balances[_addr] += tokens;
225 
226         emit AllocateToken(_addr, tokens);  // logs token issued
227     }
228 
229     function () public payable {
230         require (isFunding);
231         require (msg.value != 0);
232 
233         require (block.number >= fundingStartBlock);
234         require (block.number <= fundingStopBlock);
235 
236         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
237         require (tokens + tokenRaised <= currentSupply);
238 
239         tokenRaised = safeAdd(tokenRaised, tokens);
240         balances[msg.sender] += tokens;
241 
242         emit IssueToken(msg.sender, msg.value);  // logs token issued
243     }
244 }