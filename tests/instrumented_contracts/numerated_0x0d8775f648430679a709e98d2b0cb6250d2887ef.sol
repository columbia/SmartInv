1 pragma solidity ^0.4.10;
2 
3 /* taking ideas from FirstBlood token */
4 contract SafeMath {
5 
6     /* function assert(bool assertion) internal { */
7     /*   if (!assertion) { */
8     /*     throw; */
9     /*   } */
10     /* }      // assert no longer needed once solidity is on 0.4.10 */
11 
12     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
13       uint256 z = x + y;
14       assert((z >= x) && (z >= y));
15       return z;
16     }
17 
18     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
19       assert(x >= y);
20       uint256 z = x - y;
21       return z;
22     }
23 
24     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
25       uint256 z = x * y;
26       assert((x == 0)||(z/x == y));
27       return z;
28     }
29 
30 }
31 
32 contract Token {
33     uint256 public totalSupply;
34     function balanceOf(address _owner) constant returns (uint256 balance);
35     function transfer(address _to, uint256 _value) returns (bool success);
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
37     function approve(address _spender, uint256 _value) returns (bool success);
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 
44 /*  ERC 20 token */
45 contract StandardToken is Token {
46 
47     function transfer(address _to, uint256 _value) returns (bool success) {
48       if (balances[msg.sender] >= _value && _value > 0) {
49         balances[msg.sender] -= _value;
50         balances[_to] += _value;
51         Transfer(msg.sender, _to, _value);
52         return true;
53       } else {
54         return false;
55       }
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
59       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60         balances[_to] += _value;
61         balances[_from] -= _value;
62         allowed[_from][msg.sender] -= _value;
63         Transfer(_from, _to, _value);
64         return true;
65       } else {
66         return false;
67       }
68     }
69 
70     function balanceOf(address _owner) constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
81       return allowed[_owner][_spender];
82     }
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86 }
87 
88 contract BAToken is StandardToken, SafeMath {
89 
90     // metadata
91     string public constant name = "Basic Attention Token";
92     string public constant symbol = "BAT";
93     uint256 public constant decimals = 18;
94     string public version = "1.0";
95 
96     // contracts
97     address public ethFundDeposit;      // deposit address for ETH for Brave International
98     address public batFundDeposit;      // deposit address for Brave International use and BAT User Fund
99 
100     // crowdsale parameters
101     bool public isFinalized;              // switched to true in operational state
102     uint256 public fundingStartBlock;
103     uint256 public fundingEndBlock;
104     uint256 public constant batFund = 500 * (10**6) * 10**decimals;   // 500m BAT reserved for Brave Intl use
105     uint256 public constant tokenExchangeRate = 6400; // 6400 BAT tokens per 1 ETH
106     uint256 public constant tokenCreationCap =  1500 * (10**6) * 10**decimals;
107     uint256 public constant tokenCreationMin =  675 * (10**6) * 10**decimals;
108 
109 
110     // events
111     event LogRefund(address indexed _to, uint256 _value);
112     event CreateBAT(address indexed _to, uint256 _value);
113 
114     // constructor
115     function BAToken(
116         address _ethFundDeposit,
117         address _batFundDeposit,
118         uint256 _fundingStartBlock,
119         uint256 _fundingEndBlock)
120     {
121       isFinalized = false;                   //controls pre through crowdsale state
122       ethFundDeposit = _ethFundDeposit;
123       batFundDeposit = _batFundDeposit;
124       fundingStartBlock = _fundingStartBlock;
125       fundingEndBlock = _fundingEndBlock;
126       totalSupply = batFund;
127       balances[batFundDeposit] = batFund;    // Deposit Brave Intl share
128       CreateBAT(batFundDeposit, batFund);  // logs Brave Intl fund
129     }
130 
131     /// @dev Accepts ether and creates new BAT tokens.
132     function createTokens() payable external {
133       if (isFinalized) throw;
134       if (block.number < fundingStartBlock) throw;
135       if (block.number > fundingEndBlock) throw;
136       if (msg.value == 0) throw;
137 
138       uint256 tokens = safeMult(msg.value, tokenExchangeRate); // check that we're not over totals
139       uint256 checkedSupply = safeAdd(totalSupply, tokens);
140 
141       // return money if something goes wrong
142       if (tokenCreationCap < checkedSupply) throw;  // odd fractions won't be found
143 
144       totalSupply = checkedSupply;
145       balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
146       CreateBAT(msg.sender, tokens);  // logs token creation
147     }
148 
149     /// @dev Ends the funding period and sends the ETH home
150     function finalize() external {
151       if (isFinalized) throw;
152       if (msg.sender != ethFundDeposit) throw; // locks finalize to the ultimate ETH owner
153       if(totalSupply < tokenCreationMin) throw;      // have to sell minimum to move to operational
154       if(block.number <= fundingEndBlock && totalSupply != tokenCreationCap) throw;
155       // move to operational
156       isFinalized = true;
157       if(!ethFundDeposit.send(this.balance)) throw;  // send the eth to Brave International
158     }
159 
160     /// @dev Allows contributors to recover their ether in the case of a failed funding campaign.
161     function refund() external {
162       if(isFinalized) throw;                       // prevents refund if operational
163       if (block.number <= fundingEndBlock) throw; // prevents refund until sale period is over
164       if(totalSupply >= tokenCreationMin) throw;  // no refunds if we sold enough
165       if(msg.sender == batFundDeposit) throw;    // Brave Intl not entitled to a refund
166       uint256 batVal = balances[msg.sender];
167       if (batVal == 0) throw;
168       balances[msg.sender] = 0;
169       totalSupply = safeSubtract(totalSupply, batVal); // extra safe
170       uint256 ethVal = batVal / tokenExchangeRate;     // should be safe; previous throws covers edges
171       LogRefund(msg.sender, ethVal);               // log it 
172       if (!msg.sender.send(ethVal)) throw;       // if you're using a contract; make sure it works with .send gas limits
173     }
174 
175 }