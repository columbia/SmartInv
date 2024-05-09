1 pragma solidity ^0.4.12;
2  
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) returns (bool success);
5 }
6  
7 contract SafeMath {
8  
9     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
10         uint256 z = x + y;
11         assert((z >= x) && (z >= y));
12         return z;
13     }
14  
15     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
16         assert(x >= y);
17         uint256 z = x - y;
18         return z;
19     }
20  
21     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
22         uint256 z = x * y;
23         assert((x == 0)||(z/x == y));
24         return z;
25     }
26  
27 }
28  
29 contract Token {
30     uint256 public totalSupply;
31     function balanceOf(address _owner) constant returns (uint256 balance);
32     function transfer(address _to, uint256 _value) returns (bool success);
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34     function approve(address _spender, uint256 _value) returns (bool success);
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39  
40  
41 /*  ERC 20 token */
42 contract StandardToken is Token {
43  
44     function transfer(address _to, uint256 _value) returns (bool success) {
45         if (balances[msg.sender] >= _value && _value > 0) {
46             balances[msg.sender] -= _value;
47             balances[_to] += _value;
48             Transfer(msg.sender, _to, _value);
49             return true;
50         } else {
51             return false;
52         }
53     }
54  
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
56         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
57             balances[_to] += _value;
58             balances[_from] -= _value;
59             allowed[_from][msg.sender] -= _value;
60             Transfer(_from, _to, _value);
61             return true;
62         } else {
63             return false;
64         }
65     }
66  
67     function balanceOf(address _owner) constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70  
71     function approve(address _spender, uint256 _value) returns (bool success) {
72         allowed[msg.sender][_spender] = _value;
73         Approval(msg.sender, _spender, _value);
74         return true;
75     }
76  
77     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
78         return allowed[_owner][_spender];
79     }
80  
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;
83 }
84  
85 contract UCCToken is StandardToken, SafeMath {
86  
87     // metadata
88     string  public constant name = "UCC";
89     string  public constant symbol = "UCC";
90     uint256 public constant decimals = 18;
91     string  public version = "1.0";
92     
93     // contracts
94     address public ethFundDeposit; 
95     address public newContractAddr; 
96  
97     // crowdsale parameters
98     bool    public isFunding;        
99     uint256 public fundingStartBlock;
100     uint256 public fundingStopBlock;
101  
102     uint256 public currentSupply;      
103     uint256 public tokenRaised = 0;       
104     uint256 public tokenMigrated = 0;    
105     uint256 public tokenExchangeRate = 2000;
106  
107     // events
108     event AllocateToken(address indexed _to, uint256 _value);
109     event IssueToken(address indexed _to, uint256 _value);
110     event IncreaseSupply(uint256 _value);
111     event DecreaseSupply(uint256 _value);
112     event Migrate(address indexed _to, uint256 _value);
113 
114     function formatDecimals(uint256 _value) internal returns (uint256 ) {
115         return _value * 10 ** decimals;
116     }
117  
118     // constructor
119     function UCCToken(
120         address _ethFundDeposit,
121         uint256 _currentSupply)
122     {
123         ethFundDeposit = _ethFundDeposit;
124  
125         isFunding = false;         
126         fundingStartBlock = 0;
127         fundingStopBlock = 0;
128  
129         currentSupply = formatDecimals(_currentSupply);
130         totalSupply = formatDecimals(100000000);
131         balances[msg.sender] = totalSupply;
132         if(currentSupply > totalSupply) throw;
133     }
134  
135     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
136  
137 
138     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
139         if (_tokenExchangeRate == 0) throw;
140         if (_tokenExchangeRate == tokenExchangeRate) throw;
141  
142         tokenExchangeRate = _tokenExchangeRate;
143     }
144  
145    
146     function increaseSupply (uint256 _value) isOwner external {
147         uint256 value = formatDecimals(_value);
148         if (value + currentSupply > totalSupply) throw;
149         currentSupply = safeAdd(currentSupply, value);
150         IncreaseSupply(value);
151     }
152  
153  
154     function decreaseSupply (uint256 _value) isOwner external {
155         uint256 value = formatDecimals(_value);
156         if (value + tokenRaised > currentSupply) throw;
157  
158         currentSupply = safeSubtract(currentSupply, value);
159         DecreaseSupply(value);
160     }
161  
162 
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
173 
174     function stopFunding() isOwner external {
175         if (!isFunding) throw;
176         isFunding = false;
177     }
178  
179 
180     function setMigrateContract(address _newContractAddr) isOwner external {
181         if (_newContractAddr == newContractAddr) throw;
182         newContractAddr = _newContractAddr;
183     }
184  
185 
186     function changeOwner(address _newFundDeposit) isOwner() external {
187         if (_newFundDeposit == address(0x0)) throw;
188         ethFundDeposit = _newFundDeposit;
189     }
190  
191 
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
205         Migrate(msg.sender, tokens); 
206     }
207  
208 
209     function transferETH() isOwner external {
210         if (this.balance == 0) throw;
211         if (!ethFundDeposit.send(this.balance)) throw;
212     }
213  
214  
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
228     function () payable {
229         if (!isFunding) throw;
230         if (msg.value == 0) throw;
231  
232         if (block.number < fundingStartBlock) throw;
233         if (block.number > fundingStopBlock) throw;
234  
235         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
236         if (tokens + tokenRaised > currentSupply) throw;
237  
238         tokenRaised = safeAdd(tokenRaised, tokens);
239         balances[msg.sender] += tokens;
240  
241         IssueToken(msg.sender, tokens); 
242     }
243 }