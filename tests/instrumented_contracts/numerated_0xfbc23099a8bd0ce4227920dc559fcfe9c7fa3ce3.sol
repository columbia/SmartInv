1 contract BatLimitAsk{
2     address        owner;
3     uint    public pausedUntil;
4     uint    public BATsPerEth;// BAT/ETH
5     BAToken public bat;
6     function BatLimitAsk(){
7         owner = msg.sender;
8         bat = BAToken(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
9     }
10     
11     modifier onlyActive(){ if(pausedUntil < now){ _; }else{ throw; } }
12     
13     function () payable onlyActive{//buy some BAT (market bid)
14         if(!bat.transfer(msg.sender, (msg.value * BATsPerEth))){ throw; }
15     }
16 
17     modifier onlyOwner(){ if(msg.sender == owner) _; }
18     
19     function changeRate(uint _BATsPerEth) onlyOwner{
20         pausedUntil = now + 10; //no new bids for 5 minutes (protects taker)
21         BATsPerEth = _BATsPerEth;
22     }
23 
24     function withdrawETH() onlyOwner{
25         if(!msg.sender.send(this.balance)){ throw; }
26     }
27     function withdrawBAT(uint _amount) onlyOwner{
28         if(!bat.transfer(msg.sender, _amount)){ throw; }
29     }
30 }//pending updates
31 
32 // BAT contract below
33 // https://etherscan.io/address/0x0D8775F648430679A709E98d2b0Cb6250d2887EF#code
34 
35 pragma solidity ^0.4.10;
36 
37 /* taking ideas from FirstBlood token */
38 contract SafeMath {
39 
40     /* function assert(bool assertion) internal { */
41     /*   if (!assertion) { */
42     /*     throw; */
43     /*   } */
44     /* }      // assert no longer needed once solidity is on 0.4.10 */
45 
46     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
47       uint256 z = x + y;
48       assert((z >= x) && (z >= y));
49       return z;
50     }
51 
52     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
53       assert(x >= y);
54       uint256 z = x - y;
55       return z;
56     }
57 
58     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
59       uint256 z = x * y;
60       assert((x == 0)||(z/x == y));
61       return z;
62     }
63 
64 }
65 
66 contract Token {
67     uint256 public totalSupply;
68     function balanceOf(address _owner) constant returns (uint256 balance);
69     function transfer(address _to, uint256 _value) returns (bool success);
70     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
71     function approve(address _spender, uint256 _value) returns (bool success);
72     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
73     event Transfer(address indexed _from, address indexed _to, uint256 _value);
74     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
75 }
76 
77 
78 /*  ERC 20 token */
79 contract StandardToken is Token {
80 
81     function transfer(address _to, uint256 _value) returns (bool success) {
82       if (balances[msg.sender] >= _value && _value > 0) {
83         balances[msg.sender] -= _value;
84         balances[_to] += _value;
85         Transfer(msg.sender, _to, _value);
86         return true;
87       } else {
88         return false;
89       }
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
93       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
94         balances[_to] += _value;
95         balances[_from] -= _value;
96         allowed[_from][msg.sender] -= _value;
97         Transfer(_from, _to, _value);
98         return true;
99       } else {
100         return false;
101       }
102     }
103 
104     function balanceOf(address _owner) constant returns (uint256 balance) {
105         return balances[_owner];
106     }
107 
108     function approve(address _spender, uint256 _value) returns (bool success) {
109         allowed[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
115       return allowed[_owner][_spender];
116     }
117 
118     mapping (address => uint256) balances;
119     mapping (address => mapping (address => uint256)) allowed;
120 }
121 
122 contract BAToken is StandardToken, SafeMath {
123 
124     // metadata
125     string public constant name = "Basic Attention Token";
126     string public constant symbol = "BAT";
127     uint256 public constant decimals = 18;
128     string public version = "1.0";
129 
130     // contracts
131     address public ethFundDeposit;      // deposit address for ETH for Brave International
132     address public batFundDeposit;      // deposit address for Brave International use and BAT User Fund
133 
134     // crowdsale parameters
135     bool public isFinalized;              // switched to true in operational state
136     uint256 public fundingStartBlock;
137     uint256 public fundingEndBlock;
138     uint256 public constant batFund = 500 * (10**6) * 10**decimals;   // 500m BAT reserved for Brave Intl use
139     uint256 public constant tokenExchangeRate = 6400; // 6400 BAT tokens per 1 ETH
140     uint256 public constant tokenCreationCap =  1500 * (10**6) * 10**decimals;
141     uint256 public constant tokenCreationMin =  675 * (10**6) * 10**decimals;
142 
143 
144     // events
145     event LogRefund(address indexed _to, uint256 _value);
146     event CreateBAT(address indexed _to, uint256 _value);
147 
148     // constructor
149     function BAToken(
150         address _ethFundDeposit,
151         address _batFundDeposit,
152         uint256 _fundingStartBlock,
153         uint256 _fundingEndBlock)
154     {
155       isFinalized = false;                   //controls pre through crowdsale state
156       ethFundDeposit = _ethFundDeposit;
157       batFundDeposit = _batFundDeposit;
158       fundingStartBlock = _fundingStartBlock;
159       fundingEndBlock = _fundingEndBlock;
160       totalSupply = batFund;
161       balances[batFundDeposit] = batFund;    // Deposit Brave Intl share
162       CreateBAT(batFundDeposit, batFund);  // logs Brave Intl fund
163     }
164 
165     /// @dev Accepts ether and creates new BAT tokens.
166     function createTokens() payable external {
167       if (isFinalized) throw;
168       if (block.number < fundingStartBlock) throw;
169       if (block.number > fundingEndBlock) throw;
170       if (msg.value == 0) throw;
171 
172       uint256 tokens = safeMult(msg.value, tokenExchangeRate); // check that we're not over totals
173       uint256 checkedSupply = safeAdd(totalSupply, tokens);
174 
175       // return money if something goes wrong
176       if (tokenCreationCap < checkedSupply) throw;  // odd fractions won't be found
177 
178       totalSupply = checkedSupply;
179       balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
180       CreateBAT(msg.sender, tokens);  // logs token creation
181     }
182 
183     /// @dev Ends the funding period and sends the ETH home
184     function finalize() external {
185       if (isFinalized) throw;
186       if (msg.sender != ethFundDeposit) throw; // locks finalize to the ultimate ETH owner
187       if(totalSupply < tokenCreationMin) throw;      // have to sell minimum to move to operational
188       if(block.number <= fundingEndBlock && totalSupply != tokenCreationCap) throw;
189       // move to operational
190       isFinalized = true;
191       if(!ethFundDeposit.send(this.balance)) throw;  // send the eth to Brave International
192     }
193 
194     /// @dev Allows contributors to recover their ether in the case of a failed funding campaign.
195     function refund() external {
196       if(isFinalized) throw;                       // prevents refund if operational
197       if (block.number <= fundingEndBlock) throw; // prevents refund until sale period is over
198       if(totalSupply >= tokenCreationMin) throw;  // no refunds if we sold enough
199       if(msg.sender == batFundDeposit) throw;    // Brave Intl not entitled to a refund
200       uint256 batVal = balances[msg.sender];
201       if (batVal == 0) throw;
202       balances[msg.sender] = 0;
203       totalSupply = safeSubtract(totalSupply, batVal); // extra safe
204       uint256 ethVal = batVal / tokenExchangeRate;     // should be safe; previous throws covers edges
205       LogRefund(msg.sender, ethVal);               // log it 
206       if (!msg.sender.send(ethVal)) throw;       // if you're using a contract; make sure it works with .send gas limits
207     }
208 
209 }