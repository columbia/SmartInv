1 pragma solidity 0.4.26;
2 
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) public returns (bool success);
5 }
6 
7 /* safe calculate */
8 contract SafeMath {
9     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
10         uint256 z = x + y;
11         assert((z >= x) && (z >= y));
12         return z;
13     }
14     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
15         assert(x >= y);
16         uint256 z = x - y;
17         return z;
18     }
19     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
20         uint256 z = x * y;
21         assert((x == 0)||(z/x == y));
22         return z;
23     }
24 }
25 
26 // token interface properties and methods
27 contract Token {
28     uint256 public totalSupply;
29     function balanceOf(address _owner) public constant returns (uint256 balance);
30     function transfer(address _to, uint256 _value) public returns (bool success);
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
32     function approve(address _spender, uint256 _value) public returns (bool success);
33     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 
38 
39 /*  ERC 20 token */
40 contract StandardToken is Token {
41 
42     function transfer(address _to, uint256 _value) public returns (bool success) {
43         if (balances[msg.sender] >= _value && _value > 0) {
44             balances[msg.sender] -= _value;
45             balances[_to] += _value;
46             emit Transfer(msg.sender, _to, _value);
47             return true;
48         } else {
49             return false;
50         }
51     }
52 
53     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
54         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
55             balances[_to] += _value;
56             balances[_from] -= _value;
57             allowed[_from][msg.sender] -= _value;
58             emit Transfer(_from, _to, _value);
59             return true;
60         } else {
61             return false;
62         }
63     }
64 
65     function balanceOf(address _owner) public constant returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69     function approve(address _spender, uint256 _value) public returns (bool success) {
70         allowed[msg.sender][_spender] = _value;
71         emit Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
76         return allowed[_owner][_spender];
77     }
78 
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowed;
81 }
82 
83 // the new contact coind main
84 contract HEBC is StandardToken, SafeMath {
85 
86     // metadata
87     string  public constant name = "HEBC";
88     string  public constant symbol = "HEBC";
89     uint256 public constant decimals = 18;
90     string  public version = "1.0";
91 
92     // contracts
93     address public ethFundDeposit;          // ETH address
94     address public newContractAddr;         // token update address
95 
96     // crowdsale parameters
97     bool    public isFunding;                // change status to true
98     uint256 public fundingStartBlock;
99     uint256 public fundingStopBlock;
100 
101     uint256 public currentSupply;           // solding tokens count
102     uint256 public tokenRaised = 0;         // all sold token
103     uint256 public tokenMigrated = 0;     // all transfered token
104     uint256 public tokenExchangeRate = 100000;             // 100000  contract coin to 1 ETH
105     uint256 public constant initialSupply = 380000000;  // total supply of this contract
106 
107     // events
108     event AllocateToken(address indexed _to, uint256 _value);   // private transfer token;
109     event IssueToken(address indexed _to, uint256 _value);      // issue token;
110     event IncreaseSupply(uint256 _value);
111     event DecreaseSupply(uint256 _value);
112     event Migrate(address indexed _to, uint256 _value);
113 
114     // change unit
115     function formatDecimals(uint256 _value) internal pure returns (uint256 ) {
116         return _value * 10 ** decimals;
117     }
118 
119     // constructor
120     constructor() public
121     {
122         initializeSaleWalletAddress();
123         isFunding = false;                           // change status
124         fundingStartBlock = 0;
125         fundingStopBlock = 0;
126 
127         currentSupply = formatDecimals(initialSupply);
128         totalSupply = formatDecimals(initialSupply);
129         balances[msg.sender] = totalSupply;
130         if(currentSupply > totalSupply) revert();
131     }
132     
133     function initializeSaleWalletAddress() private {
134         ethFundDeposit = 0x54ED20e3Aefc01cAf7CB536a9F49186caF2A6251;
135     }
136 
137     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
138 
139     ///  set token exchange
140     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
141         if (_tokenExchangeRate == 0) revert();
142         if (_tokenExchangeRate == tokenExchangeRate) revert();
143 
144         tokenExchangeRate = _tokenExchangeRate;
145     }
146 
147     /// @dev overflow token
148     function increaseSupply (uint256 _value) isOwner external {
149         uint256 value = formatDecimals(_value);
150         if (value + currentSupply > totalSupply) revert();
151         currentSupply = safeAdd(currentSupply, value);
152         emit IncreaseSupply(value);
153     }
154 
155     /// @dev missed token
156     function decreaseSupply (uint256 _value) isOwner external {
157         uint256 value = formatDecimals(_value);
158         if (value + tokenRaised > currentSupply) revert();
159 
160         currentSupply = safeSubtract(currentSupply, value);
161         emit DecreaseSupply(value);
162     }
163 
164     ///  start exceptions
165     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
166         if (isFunding) revert();
167         if (_fundingStartBlock >= _fundingStopBlock) revert();
168         if (block.number >= _fundingStartBlock) revert();
169 
170         fundingStartBlock = _fundingStartBlock;
171         fundingStopBlock = _fundingStopBlock;
172         isFunding = true;
173     }
174 
175     ///  close exceptions
176     function stopFunding() isOwner external {
177         if (!isFunding) revert();
178         isFunding = false;
179     }
180 
181     /// new contract address
182     function setMigrateContract(address _newContractAddr) isOwner external {
183         if (_newContractAddr == newContractAddr) revert();
184         newContractAddr = _newContractAddr;
185     }
186 
187     /// new contract address for owner
188     function changeOwner(address _newFundDeposit) isOwner() external {
189         if (_newFundDeposit == address(0x0)) revert();
190         ethFundDeposit = _newFundDeposit;
191     }
192 
193     // migrate to Contract address
194     function migrate() external {
195         if(isFunding) revert();
196         if(newContractAddr == address(0x0)) revert();
197 
198         uint256 tokens = balances[msg.sender];
199         if (tokens == 0) revert();
200 
201         balances[msg.sender] = 0;
202         tokenMigrated = safeAdd(tokenMigrated, tokens);
203 
204         IMigrationContract newContract = IMigrationContract(newContractAddr);
205         if (!newContract.migrate(msg.sender, tokens)) revert();
206 
207         emit Migrate(msg.sender, tokens);               // log it
208     }
209 
210     // tansfer eth
211     function transferETH() isOwner external {
212         if (address(this).balance == 0) revert();
213         if (!ethFundDeposit.send(address(this).balance)) revert();
214     }
215 
216     //  let Contract token allocate to the address
217     function allocateToken (address _addr, uint256 _eth) isOwner external {
218         if (_eth == 0) revert();
219         if (_addr == address(0x0)) revert();
220 
221         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
222         if (tokens + tokenRaised > currentSupply) revert();
223 
224         tokenRaised = safeAdd(tokenRaised, tokens);
225         balances[_addr] += tokens;
226 
227         emit AllocateToken(_addr, tokens);  // log token record
228     }
229 
230     // buy token
231     function () payable public{
232         if (!isFunding) revert();
233         if (msg.value == 0) revert();
234 
235         if (block.number < fundingStartBlock) revert();
236         if (block.number > fundingStopBlock) revert();
237 
238         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
239         if (tokens + tokenRaised > currentSupply) revert();
240 
241         tokenRaised = safeAdd(tokenRaised, tokens);
242         balances[msg.sender] += tokens;
243 
244         emit IssueToken(msg.sender, tokens);  // log record
245     }
246 }