1 /**
2  *Submitted for verification at Etherscan.io on 2017-08-26
3 */
4 
5 // Abstract contract for the full ERC 20 Token standard
6 // https://github.com/ethereum/EIPs/issues/20
7 pragma solidity ^0.4.10;
8 
9 contract Token {
10     /// total amount of tokens
11     uint256 public totalSupply;
12 	
13     /// @param _owner The address from which the balance will be retrieved
14     /// @return The balance	
15     function balanceOf(address _owner) constant returns (uint256 balance);
16 	
17     /// @notice send `_value` token to `_to` from `msg.sender`
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not	
21     function transfer(address _to, uint256 _value) returns (bool success);
22 	
23     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24     /// @param _from The address of the sender
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not	
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
29 	
30     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @param _value The amount of tokens to be approved for transfer
33     /// @return Whether the approval was successful or not	
34     function approve(address _spender, uint256 _value) returns (bool success);
35 	
36     /// @param _owner The address of the account owning tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @return Amount of remaining tokens allowed to spent	
39     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
40 	
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 }
44 
45 contract IMigrationContract {
46     function migrate(address addr, uint256 gbs) returns (bool success);
47 }
48 
49 contract SafeMath {
50 
51     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
52       uint256 z = x + y;
53       assert((z >= x) && (z >= y));
54       return z;
55     }
56 
57     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
58       assert(x >= y);
59       uint256 z = x - y;
60       return z;
61     }
62 
63     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
64       uint256 z = x * y;
65       assert((x == 0)||(z/x == y));
66       return z;
67     }
68 
69 }
70 
71 /*  ERC 20 token */
72 contract StandardToken is Token {
73 
74     function transfer(address _to, uint256 _value) returns (bool success) {
75       if (balances[msg.sender] >= _value && _value > 0) {
76         balances[msg.sender] -= _value;
77         balances[_to] += _value;
78         Transfer(msg.sender, _to, _value);
79         return true;
80       } else {
81         return false;
82       }
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
86       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
87         balances[_to] += _value;
88         balances[_from] -= _value;
89         allowed[_from][msg.sender] -= _value;
90         Transfer(_from, _to, _value);
91         return true;
92       } else {
93         return false;
94       }
95     }
96 
97     function balanceOf(address _owner) constant returns (uint256 balance) {
98         return balances[_owner];
99     }
100 
101     function approve(address _spender, uint256 _value) returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
108       return allowed[_owner][_spender];
109     }
110 
111     mapping (address => uint256) balances;
112     mapping (address => mapping (address => uint256)) allowed;
113 }
114 
115 contract GODBeastCoinToken is StandardToken, SafeMath {
116 
117     // metadata
118     string  public constant name = "GOD Beast Coin";
119     string  public constant symbol = "GBC";
120     uint256 public constant decimals = 18;
121     string  public version = "1.0";
122 
123     // contracts
124     address public ethFundDeposit;          // deposit address for ETH for UnlimitedIP Team.
125     address public newContractAddr;         // the new contract for UnlimitedIP token updates;
126 
127     // crowdsale parameters
128     bool    public isFunding;                // switched to true in operational state
129     uint256 public fundingStartBlock;
130     uint256 public fundingStopBlock;
131 
132     uint256 public currentSupply;           // current supply tokens for sell
133     uint256 public tokenRaised = 0;         // the number of total sold token
134     uint256 public tokenMigrated = 0;     // the number of total transferted token
135     uint256 public tokenExchangeRate = 1000;             // 1000 GBS tokens per 1 ETH
136 
137     // events
138     event IssueToken(address indexed _to, uint256 _value);      // issue token for public sale;
139     event IncreaseSupply(uint256 _value);
140     event DecreaseSupply(uint256 _value);
141     event Migrate(address indexed _to, uint256 _value);
142     event Burn(address indexed from, uint256 _value);
143     // format decimals.
144     function formatDecimals(uint256 _value) internal returns (uint256 ) {
145         return _value * 10 ** decimals;
146     }
147 
148     // constructor
149     function GODBeastCoinToken()
150     {
151         ethFundDeposit = 0x0DC090b3E72A6ec2E0E78EC028659221f76db330;
152 
153         isFunding = false;                           //controls pre through crowdsale state
154         fundingStartBlock = 0;
155         fundingStopBlock = 0;
156 
157         currentSupply = formatDecimals(0);
158         totalSupply = formatDecimals(330000000);
159         require(currentSupply <= totalSupply);
160         balances[ethFundDeposit] = totalSupply-currentSupply;
161     }
162 
163     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
164 
165     /// @dev set the token's tokenExchangeRate,
166     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
167         require(_tokenExchangeRate > 0);
168         require(_tokenExchangeRate != tokenExchangeRate);
169         tokenExchangeRate = _tokenExchangeRate;
170     }
171 
172     /// @dev increase the token's supply
173     function increaseSupply (uint256 _value) isOwner external {
174         uint256 value = formatDecimals(_value);
175         require (value + currentSupply <= totalSupply);
176         require (balances[msg.sender] >= value && value>0);
177         balances[msg.sender] -= value;
178         currentSupply = safeAdd(currentSupply, value);
179         IncreaseSupply(value);
180     }
181 
182     /// @dev decrease the token's supply
183     function decreaseSupply (uint256 _value) isOwner external {
184         uint256 value = formatDecimals(_value);
185         require (value + tokenRaised <= currentSupply);
186         currentSupply = safeSubtract(currentSupply, value);
187         balances[msg.sender] += value;
188         DecreaseSupply(value);
189     }
190 
191     /// @dev turn on the funding state
192     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
193         require(!isFunding);
194         require(_fundingStartBlock < _fundingStopBlock);
195         require(block.number < _fundingStartBlock) ;
196         fundingStartBlock = _fundingStartBlock;
197         fundingStopBlock = _fundingStopBlock;
198         isFunding = true;
199     }
200 
201     /// @dev turn off the funding state
202     function stopFunding() isOwner external {
203         require(isFunding);
204         isFunding = false;
205     }
206 
207     /// @dev set a new contract for recieve the tokens (for update contract)
208     function setMigrateContract(address _newContractAddr) isOwner external {
209         require(_newContractAddr != newContractAddr);
210         newContractAddr = _newContractAddr;
211     }
212 
213     /// @dev set a new owner.
214     function changeOwner(address _newFundDeposit) isOwner() external {
215         require(_newFundDeposit != address(0x0));
216         ethFundDeposit = _newFundDeposit;
217     }
218 
219     /// sends the tokens to new contract
220     function migrate() external {
221         require(!isFunding);
222         require(newContractAddr != address(0x0));
223 
224         uint256 tokens = balances[msg.sender];
225         require (tokens > 0);
226 
227         balances[msg.sender] = 0;
228         tokenMigrated = safeAdd(tokenMigrated, tokens);
229 
230         IMigrationContract newContract = IMigrationContract(newContractAddr);
231         require(newContract.migrate(msg.sender, tokens));
232 
233         Migrate(msg.sender, tokens);               // log it
234     }
235 
236     /// @dev withdraw ETH from contract to UnlimitedIP team address
237     function transferETH() isOwner external {
238         require(this.balance > 0);
239         require(ethFundDeposit.send(this.balance));
240     }
241 
242     function burn(uint256 _value) isOwner returns (bool success){
243         uint256 value = formatDecimals(_value);
244         require(balances[msg.sender] >= value && value>0);
245         balances[msg.sender] -= value;
246         totalSupply -= value;
247         Burn(msg.sender,value);
248         return true;
249     }
250 
251     /// buys the tokens
252     function () payable {
253         require (isFunding);
254         require(msg.value > 0);
255 
256         require(block.number >= fundingStartBlock);
257         require(block.number <= fundingStopBlock);
258 
259         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
260         require(tokens + tokenRaised <= currentSupply);
261 
262         tokenRaised = safeAdd(tokenRaised, tokens);
263         balances[msg.sender] += tokens;
264 
265         IssueToken(msg.sender, tokens);  // logs token issued
266     }
267 }