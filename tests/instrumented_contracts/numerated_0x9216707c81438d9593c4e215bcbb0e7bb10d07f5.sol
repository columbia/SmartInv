1 pragma solidity ^0.4.10;
2 
3 contract Token {
4     uint256 public totalSupply;
5 	
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance	
8     function balanceOf(address _owner) constant returns (uint256 balance);
9 	
10     /// @notice send `_value` token to `_to` from `msg.sender`
11     /// @param _to The address of the recipient
12     /// @param _value The amount of token to be transferred
13     /// @return Whether the transfer was successful or not	
14     function transfer(address _to, uint256 _value) returns (bool success);
15 	
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not	
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
22 	
23     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
24     /// @param _spender The address of the account able to transfer the tokens
25     /// @param _value The amount of tokens to be approved for transfer
26     /// @return Whether the approval was successful or not	
27     function approve(address _spender, uint256 _value) returns (bool success);
28 	
29     /// @param _owner The address of the account owning tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @return Amount of remaining tokens allowed to spent	
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
33 	
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 
38 contract IMigrationContract {
39     function migrate(address addr, uint256 uip) returns (bool success);
40 }
41 
42 contract SafeMath {
43 
44     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
45       uint256 z = x + y;
46       assert((z >= x) && (z >= y));
47       return z;
48     }
49 
50     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
51       assert(x >= y);
52       uint256 z = x - y;
53       return z;
54     }
55 
56     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
57       uint256 z = x * y;
58       assert((x == 0)||(z/x == y));
59       return z;
60     }
61 
62 }
63 
64 /*  ERC 20 token */
65 contract StandardToken is Token {
66 
67     function transfer(address _to, uint256 _value) returns (bool success) {
68       if (balances[msg.sender] >= _value && _value > 0) {
69         balances[msg.sender] -= _value;
70         balances[_to] += _value;
71         Transfer(msg.sender, _to, _value);
72         return true;
73       } else {
74         return false;
75       }
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
79       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
80         balances[_to] += _value;
81         balances[_from] -= _value;
82         allowed[_from][msg.sender] -= _value;
83         Transfer(_from, _to, _value);
84         return true;
85       } else {
86         return false;
87       }
88     }
89 
90     function balanceOf(address _owner) constant returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94     function approve(address _spender, uint256 _value) returns (bool success) {
95         allowed[msg.sender][_spender] = _value;
96         Approval(msg.sender, _spender, _value);
97         return true;
98     }
99 
100     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
101       return allowed[_owner][_spender];
102     }
103 
104     mapping (address => uint256) balances;
105     mapping (address => mapping (address => uint256)) allowed;
106 }
107 
108 contract RealEstateCouponToken is StandardToken, SafeMath {
109 
110     // metadata
111     string  public constant name = "Real Estate Coupon Token";
112     string  public constant symbol = "RECT";
113     uint256 public constant decimals = 18;
114     string  public version = "1.0";
115 
116     // contracts
117     address public ethFundDeposit;          // deposit address for ETH for UnlimitedIP Team.
118     address public newContractAddr;         // the new contract for UnlimitedIP token updates;
119 
120     // crowdsale parameters
121     bool    public isFunding;                // switched to true in operational state
122     uint256 public fundingStartBlock;
123     uint256 public fundingStopBlock;
124 
125     uint256 public currentSupply;           // current supply tokens for sell
126     uint256 public tokenRaised = 0;         // the number of total sold token
127     uint256 public tokenMigrated = 0;     // the number of total transferted token
128     uint256 public tokenExchangeRate = 1000;             // 1000 HCT tokens per 1 ETH
129 
130     // events
131     event IssueToken(address indexed _to, uint256 _value);      // issue token for public sale;
132     event IncreaseSupply(uint256 _value);
133     event DecreaseSupply(uint256 _value);
134     event Migrate(address indexed _to, uint256 _value);
135     event Burn(address indexed from, uint256 _value);
136     // format decimals.
137     function formatDecimals(uint256 _value) internal returns (uint256 ) {
138         return _value * 10 ** decimals;
139     }
140 
141     // constructor
142     function RealEstateCouponToken()
143     {
144         ethFundDeposit = 0xaaA2680052A158Bf1Db3cF1F67a06aa1f6A1Bb47;
145 
146         isFunding = false; //controls pre through crowdsale state
147         fundingStartBlock = 0;
148         fundingStopBlock = 0;
149 
150         currentSupply = formatDecimals(0);
151         totalSupply = formatDecimals(20000000);
152         require(currentSupply <= totalSupply);
153         balances[ethFundDeposit] = totalSupply-currentSupply;
154     }
155 
156     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
157 
158     /// @dev set the token's tokenExchangeRate,
159     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
160         require(_tokenExchangeRate > 0);
161         require(_tokenExchangeRate != tokenExchangeRate);
162         tokenExchangeRate = _tokenExchangeRate;
163     }
164 
165     /// @dev increase the token's supply
166     function increaseSupply (uint256 _value) isOwner external {
167         uint256 value = formatDecimals(_value);
168         require (value + currentSupply <= totalSupply);
169         require (balances[msg.sender] >= value && value>0);
170         balances[msg.sender] -= value;
171         currentSupply = safeAdd(currentSupply, value);
172         IncreaseSupply(value);
173     }
174 
175     /// @dev decrease the token's supply
176     function decreaseSupply (uint256 _value) isOwner external {
177         uint256 value = formatDecimals(_value);
178         require (value + tokenRaised <= currentSupply);
179         currentSupply = safeSubtract(currentSupply, value);
180         balances[msg.sender] += value;
181         DecreaseSupply(value);
182     }
183 
184     /// @dev turn on the funding state
185     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
186         require(!isFunding);
187         require(_fundingStartBlock < _fundingStopBlock);
188         require(block.number < _fundingStartBlock) ;
189         fundingStartBlock = _fundingStartBlock;
190         fundingStopBlock = _fundingStopBlock;
191         isFunding = true;
192     }
193 
194     /// @dev turn off the funding state
195     function stopFunding() isOwner external {
196         require(isFunding);
197         isFunding = false;
198     }
199 
200     /// @dev set a new contract for recieve the tokens (for update contract)
201     function setMigrateContract(address _newContractAddr) isOwner external {
202         require(_newContractAddr != newContractAddr);
203         newContractAddr = _newContractAddr;
204     }
205 
206     /// @dev set a new owner.
207     function changeOwner(address _newFundDeposit) isOwner() external {
208         require(_newFundDeposit != address(0x0));
209         ethFundDeposit = _newFundDeposit;
210     }
211 
212     /// sends the tokens to new contract
213     function migrate() external {
214         require(!isFunding);
215         require(newContractAddr != address(0x0));
216 
217         uint256 tokens = balances[msg.sender];
218         require (tokens > 0);
219 
220         balances[msg.sender] = 0;
221         tokenMigrated = safeAdd(tokenMigrated, tokens);
222 
223         IMigrationContract newContract = IMigrationContract(newContractAddr);
224         require(newContract.migrate(msg.sender, tokens));
225 
226         Migrate(msg.sender, tokens);               // log it
227     }
228 
229     /// @dev withdraw ETH from contract to UnlimitedIP team address
230     function transferETH() isOwner external {
231         require(this.balance > 0);
232         require(ethFundDeposit.send(this.balance));
233     }
234 
235     function burn(uint256 _value) isOwner returns (bool success){
236         uint256 value = formatDecimals(_value);
237         require(balances[msg.sender] >= value && value>0);
238         balances[msg.sender] -= value;
239         totalSupply -= value;
240         Burn(msg.sender,value);
241         return true;
242     }
243 
244     /// buys the tokens
245     function () payable {
246         require (isFunding);
247         require(msg.value > 0);
248 
249         require(block.number >= fundingStartBlock);
250         require(block.number <= fundingStopBlock);
251 
252         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
253         require(tokens + tokenRaised <= currentSupply);
254 
255         tokenRaised = safeAdd(tokenRaised, tokens);
256         balances[msg.sender] += tokens;
257 
258         IssueToken(msg.sender, tokens);  // logs token issued
259     }
260 }