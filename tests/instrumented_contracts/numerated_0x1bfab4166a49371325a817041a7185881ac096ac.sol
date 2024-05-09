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
32 
33 contract Token {
34     uint256 public totalSupply;
35     function balanceOf(address _owner) constant returns (uint256 balance);
36     function transfer(address _to, uint256 _value) returns (bool success);
37     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
38     function approve(address _spender, uint256 _value) returns (bool success);
39     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 }
43 
44 
45 /*  ERC 20 token */
46 contract StandardToken is Token {
47 
48     function transfer(address _to, uint256 _value) returns (bool success) {
49       if (balances[msg.sender] >= _value && _value > 0) {
50         balances[msg.sender] -= _value;
51         balances[_to] += _value;
52         Transfer(msg.sender, _to, _value);
53         return true;
54       } else {
55         return false;
56       }
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
60       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
61         balances[_to] += _value;
62         balances[_from] -= _value;
63         allowed[_from][msg.sender] -= _value;
64         Transfer(_from, _to, _value);
65         return true;
66       } else {
67         return false;
68       }
69     }
70 
71     function balanceOf(address _owner) constant returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75     function approve(address _spender, uint256 _value) returns (bool success) {
76         allowed[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
82       return allowed[_owner][_spender];
83     }
84 
85     mapping (address => uint256) balances;
86     mapping (address => mapping (address => uint256)) allowed;
87 }
88 contract Indicoin is StandardToken, SafeMath {
89 
90     // metadata
91     string public constant name = "Indicoin";
92     string public constant symbol = "INDI";
93     uint256 public constant decimals = 18;
94     string public version = "1.0";
95 
96     // contracts
97     address public ethFundDeposit;      // deposit address for ETH for Indicoin Developers
98     address public indiFundAndSocialVaultDeposit;      // deposit address for indicoin developers use and social vault 
99     address public bountyDeposit; // deposit address for bounty
100     address public saleDeposit; //deposit address for preSale
101     // crowdsale parameters
102     bool public isFinalized;              // switched to true in operational state
103     uint256 public fundingStartTime;
104     uint256 public fundingEndTime;
105     uint256 public constant indiFundAndSocialVault = 350 * (10**6) * 10**decimals;   // 100m INDI reserved for team use and 250m for social vault
106     uint256 public constant bounty = 50 * (10**6) * 10**decimals; // 50m INDI reserved for bounty
107     uint256 public constant sale = 200 * (10**6) * 10**decimals; 
108     uint256 public constant tokenExchangeRate = 12500; // 12500 INDI tokens per 1 ETH
109     uint256 public constant tokenCreationCap =  1000 * (10**6) * 10**decimals;
110     uint256 public constant tokenCreationMin =  600 * (10**6) * 10**decimals;
111 
112 
113     // events
114     event LogRefund(address indexed _to, uint256 _value);
115     event CreateINDI(address indexed _to, uint256 _value);
116     
117 
118     
119     function Indicoin()
120     {
121       isFinalized = false;                   //controls pre through crowdsale state
122       ethFundDeposit = 0xe16927243587d3293574235314D96B3501fC00b7;
123       indiFundAndSocialVaultDeposit = 0xF83EA33530027A4Fd7F37629E18508E124DFB99D;
124       saleDeposit = 0xC1E5214983d18b80c9Cdd5d2edAC40B7d8ddfCB9;
125       bountyDeposit = 0xB41A19abF814375D89222834aeE3FB264e4b5e77;
126       fundingStartTime = 1507309861;
127       fundingEndTime = 1509580799;
128       
129       totalSupply = indiFundAndSocialVault + bounty + sale;
130       balances[indiFundAndSocialVaultDeposit] = indiFundAndSocialVault; // Deposit Indicoin developers share
131       balances[bountyDeposit] = bounty; //Deposit bounty Share
132       balances[saleDeposit] = sale; //Deposit preSale Share
133       CreateINDI(indiFundAndSocialVaultDeposit, indiFundAndSocialVault);  // logs indicoin developers fund
134       CreateINDI(bountyDeposit, bounty); // logs bounty fund
135       CreateINDI(saleDeposit, sale); // logs preSale fund
136     }
137     
138     
139     /// @dev Accepts ether and creates new INDI tokens.
140     function createTokens() payable external {
141       if (isFinalized) revert();
142       if (now < fundingStartTime) revert();
143       if (now > fundingEndTime) revert();
144       if (msg.value == 0) revert();
145 
146       uint256 tokens = safeMult(msg.value, tokenExchangeRate); // check that we're not over totals
147       uint256 checkedSupply = safeAdd(totalSupply, tokens);
148 
149       // return money if something goes wrong
150       if (tokenCreationCap < checkedSupply) revert();  // odd fractions won't be found
151 
152       totalSupply = checkedSupply;
153       balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
154       CreateINDI(msg.sender, tokens);  // logs token creation
155     }
156 
157     /// @dev Ends the funding period and sends the ETH home
158     function finalize() external {
159       if (isFinalized) revert();
160       if (msg.sender != ethFundDeposit) revert(); // locks finalize to the ultimate ETH owner
161       if(totalSupply < tokenCreationMin) revert();      // have to sell minimum to move to operational
162       if(now <= fundingEndTime && totalSupply != tokenCreationCap) revert();
163       // move to operational
164       isFinalized = true;
165       if(!ethFundDeposit.send(this.balance)) revert();  // send the eth to Indicoin developers
166     }
167 
168     /// @dev Allows contributors to recover their ether in the case of a failed funding campaign.
169     function refund() external {
170       if(isFinalized) revert();                       // prevents refund if operational
171       if (now <= fundingEndTime) revert(); // prevents refund until sale period is over
172       if(totalSupply >= tokenCreationMin) revert();  // no refunds if we sold enough
173       if(msg.sender == indiFundAndSocialVaultDeposit) revert();    // Indicoin developers not entitled to a refund
174       uint256 indiVal = balances[msg.sender];
175       if (indiVal == 0) revert();
176       balances[msg.sender] = 0;
177       totalSupply = safeSubtract(totalSupply, indiVal); // extra safe
178       uint256 ethVal = indiVal / tokenExchangeRate;     // should be safe; previous throws covers edges
179       LogRefund(msg.sender, ethVal);               // log it 
180       if (!msg.sender.send(ethVal)) revert();       // if you're using a contract; make sure it works with .send gas limits
181     }
182 
183 }