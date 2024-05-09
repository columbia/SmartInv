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
26 contract Token {
27     uint256 public totalSupply;
28     function balanceOf(address _owner) public constant returns (uint256 balance);
29     function transfer(address _to, uint256 _value) public returns (bool success);
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
31     function approve(address _spender, uint256 _value) public returns (bool success);
32     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 
37 
38 /*  ERC 20 token */
39 contract StandardToken is Token {
40 
41     function transfer(address _to, uint256 _value) public returns (bool success) {
42         if (balances[msg.sender] >= _value && _value > 0) {
43             balances[msg.sender] -= _value;
44             balances[_to] += _value;
45             emit Transfer(msg.sender, _to, _value);
46             return true;
47         } else {
48             return false;
49         }
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
53         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
54             balances[_to] += _value;
55             balances[_from] -= _value;
56             allowed[_from][msg.sender] -= _value;
57             emit Transfer(_from, _to, _value);
58             return true;
59         } else {
60             return false;
61         }
62     }
63 
64     function balanceOf(address _owner) public constant returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function approve(address _spender, uint256 _value) public returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         emit Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
75         return allowed[_owner][_spender];
76     }
77 
78     mapping (address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;
80 }
81 
82 contract LuryToken is StandardToken, SafeMath {
83 
84     // metadata
85     string  public constant name = "Lury";
86     string  public constant symbol = "LuryCoin";
87     uint256 public constant decimals = 18;
88     string  public version = "1.0.1";
89 
90     // contracts
91     address public ethFundDeposit;          // ETH address
92     address public newContractAddr;         // token update address
93 
94     // crowdsale parameters
95     bool    public isFunding;                // change status to true
96     uint256 public fundingStartBlock;
97     uint256 public fundingStopBlock;
98 
99     uint256 public currentSupply;           // solding tokens count
100     uint256 public tokenRaised = 0;         // all sold token
101     uint256 public tokenMigrated = 0;     // all transfered token
102     uint256 public tokenExchangeRate = 1000;             // 1000  contract coin to 1 ETH
103     uint256 public constant initialSupply = 60000000;  // total supply of this contract
104 
105     // events
106     event AllocateToken(address indexed _to, uint256 _value);   // private transfer token;
107     event IssueToken(address indexed _to, uint256 _value);      // issue token;
108     event IncreaseSupply(uint256 _value);
109     event DecreaseSupply(uint256 _value);
110     event Migrate(address indexed _to, uint256 _value);
111 
112     // change unit
113     function formatDecimals(uint256 _value) internal pure returns (uint256 ) {
114         return _value * 10 ** decimals;
115     }
116 
117     // constructor
118     constructor() public
119     {
120         initializeSaleWalletAddress();
121         isFunding = false;                           // change status
122         fundingStartBlock = 0;
123         fundingStopBlock = 0;
124 
125         currentSupply = formatDecimals(initialSupply);
126         totalSupply = formatDecimals(initialSupply);
127         balances[msg.sender] = totalSupply;
128         if(currentSupply > totalSupply) revert();
129     }
130     
131     function initializeSaleWalletAddress() private {
132         ethFundDeposit = 0x6Ae7d9412a9247b8bF3173C347B909E3148c29CE;
133     }
134 
135     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
136 
137     ///  set token exchange
138     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
139         if (_tokenExchangeRate == 0) revert();
140         if (_tokenExchangeRate == tokenExchangeRate) revert();
141 
142         tokenExchangeRate = _tokenExchangeRate;
143     }
144 
145     /// @dev overflow token
146     function increaseSupply (uint256 _value) isOwner external {
147         uint256 value = formatDecimals(_value);
148         if (value + currentSupply > totalSupply) revert();
149         currentSupply = safeAdd(currentSupply, value);
150         emit IncreaseSupply(value);
151     }
152 
153     /// @dev missed token
154     function decreaseSupply (uint256 _value) isOwner external {
155         uint256 value = formatDecimals(_value);
156         if (value + tokenRaised > currentSupply) revert();
157 
158         currentSupply = safeSubtract(currentSupply, value);
159         emit DecreaseSupply(value);
160     }
161 
162     ///  start exceptions
163     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
164         if (isFunding) revert();
165         if (_fundingStartBlock >= _fundingStopBlock) revert();
166         if (block.number >= _fundingStartBlock) revert();
167 
168         fundingStartBlock = _fundingStartBlock;
169         fundingStopBlock = _fundingStopBlock;
170         isFunding = true;
171     }
172 
173     ///  close exceptions
174     function stopFunding() isOwner external {
175         if (!isFunding) revert();
176         isFunding = false;
177     }
178 
179     /// new contract address
180     function setMigrateContract(address _newContractAddr) isOwner external {
181         if (_newContractAddr == newContractAddr) revert();
182         newContractAddr = _newContractAddr;
183     }
184 
185     /// new contract address for owner
186     function changeOwner(address _newFundDeposit) isOwner() external {
187         if (_newFundDeposit == address(0x0)) revert();
188         ethFundDeposit = _newFundDeposit;
189     }
190 
191     // migrate to Contract address
192     function migrate() external {
193         if(isFunding) revert();
194         if(newContractAddr == address(0x0)) revert();
195 
196         uint256 tokens = balances[msg.sender];
197         if (tokens == 0) revert();
198 
199         balances[msg.sender] = 0;
200         tokenMigrated = safeAdd(tokenMigrated, tokens);
201 
202         IMigrationContract newContract = IMigrationContract(newContractAddr);
203         if (!newContract.migrate(msg.sender, tokens)) revert();
204 
205         emit Migrate(msg.sender, tokens);               // log it
206     }
207 
208     // tansfer eth
209     function transferETH() isOwner external {
210         if (address(this).balance == 0) revert();
211         if (!ethFundDeposit.send(address(this).balance)) revert();
212     }
213 
214     //  let Contract token allocate to the address
215     function allocateToken (address _addr, uint256 _eth) isOwner external {
216         if (_eth == 0) revert();
217         if (_addr == address(0x0)) revert();
218 
219         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
220         if (tokens + tokenRaised > currentSupply) revert();
221 
222         tokenRaised = safeAdd(tokenRaised, tokens);
223         balances[_addr] += tokens;
224 
225         emit AllocateToken(_addr, tokens);  // log token record
226     }
227 
228     // buy token
229     function () payable public{
230         if (!isFunding) revert();
231         if (msg.value == 0) revert();
232 
233         if (block.number < fundingStartBlock) revert();
234         if (block.number > fundingStopBlock) revert();
235 
236         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
237         if (tokens + tokenRaised > currentSupply) revert();
238 
239         tokenRaised = safeAdd(tokenRaised, tokens);
240         balances[msg.sender] += tokens;
241 
242         emit IssueToken(msg.sender, tokens);  // log record
243     }
244 }