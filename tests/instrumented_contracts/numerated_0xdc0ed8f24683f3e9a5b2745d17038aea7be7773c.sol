1 pragma solidity ^0.4.12;
2  
3 contract IMigrationContract {
4     function migrate(address addr, uint256 ulc) returns (bool success);
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
85 contract ULCToken is StandardToken, SafeMath {
86  
87     // metadata
88     string  public constant name = "ULCToken";
89     string  public constant symbol = "ULC";
90     uint256 public constant decimals = 8;
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
105     uint256 public tokenExchangeRate = 3500;            
106  
107     event AllocateToken(address indexed _to, uint256 _value);   
108     event IssueToken(address indexed _to, uint256 _value);      
109     event IncreaseSupply(uint256 _value);
110     event DecreaseSupply(uint256 _value);
111     event Migrate(address indexed _to, uint256 _value);
112  
113     function formatDecimals(uint256 _value) internal returns (uint256 ) {
114         return _value * 10 ** decimals;
115     }
116  
117     // constructor
118     function ULCToken(
119         address _ethFundDeposit,
120         uint256 _currentSupply)
121     {
122         ethFundDeposit = _ethFundDeposit;
123  
124         isFunding = false;                           
125         fundingStartBlock = 0;
126         fundingStopBlock = 0;
127  
128         currentSupply = formatDecimals(_currentSupply);
129         totalSupply = formatDecimals(1000000000);
130         balances[msg.sender] = totalSupply;
131         if(currentSupply > totalSupply) throw;
132     }
133  
134     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
135  
136 
137     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
138         if (_tokenExchangeRate == 0) throw;
139         if (_tokenExchangeRate == tokenExchangeRate) throw;
140  
141         tokenExchangeRate = _tokenExchangeRate;
142     }
143  
144 
145     function increaseSupply (uint256 _value) isOwner external {
146         uint256 value = formatDecimals(_value);
147         if (value + currentSupply > totalSupply) throw;
148         currentSupply = safeAdd(currentSupply, value);
149         IncreaseSupply(value);
150     }
151  
152 
153     function decreaseSupply (uint256 _value) isOwner external {
154         uint256 value = formatDecimals(_value);
155         if (value + tokenRaised > currentSupply) throw;
156  
157         currentSupply = safeSubtract(currentSupply, value);
158         DecreaseSupply(value);
159     }
160  
161 
162     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
163         if (isFunding) throw;
164         if (_fundingStartBlock >= _fundingStopBlock) throw;
165         if (block.number >= _fundingStartBlock) throw;
166  
167         fundingStartBlock = _fundingStartBlock;
168         fundingStopBlock = _fundingStopBlock;
169         isFunding = true;
170     }
171  
172 
173     function stopFunding() isOwner external {
174         if (!isFunding) throw;
175         isFunding = false;
176     }
177  
178 
179     function setMigrateContract(address _newContractAddr) isOwner external {
180         if (_newContractAddr == newContractAddr) throw;
181         newContractAddr = _newContractAddr;
182     }
183  
184 
185     function changeOwner(address _newFundDeposit) isOwner() external {
186         if (_newFundDeposit == address(0x0)) throw;
187         ethFundDeposit = _newFundDeposit;
188     }
189  
190 
191     function migrate() external {
192         if(isFunding) throw;
193         if(newContractAddr == address(0x0)) throw;
194  
195         uint256 tokens = balances[msg.sender];
196         if (tokens == 0) throw;
197  
198         balances[msg.sender] = 0;
199         tokenMigrated = safeAdd(tokenMigrated, tokens);
200  
201         IMigrationContract newContract = IMigrationContract(newContractAddr);
202         if (!newContract.migrate(msg.sender, tokens)) throw;
203  
204         Migrate(msg.sender, tokens);               
205     }
206  
207 
208     function transferETH() isOwner external {
209         if (this.balance == 0) throw;
210         if (!ethFundDeposit.send(this.balance)) throw;
211     }
212  
213 
214     function allocateToken (address _addr, uint256 _eth) isOwner external {
215         if (_eth == 0) throw;
216         if (_addr == address(0x0)) throw;
217  
218         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
219         if (tokens + tokenRaised > currentSupply) throw;
220  
221         tokenRaised = safeAdd(tokenRaised, tokens);
222         balances[_addr] += tokens;
223  
224         AllocateToken(_addr, tokens);  
225     }
226  
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