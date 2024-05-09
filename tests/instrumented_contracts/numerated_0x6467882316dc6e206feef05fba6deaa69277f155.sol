1 pragma solidity ^0.4.11;
2 
3 /* taking ideas from FirstBlood token */
4 contract SafeMath {
5 
6 function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
7 uint256 z = x + y;
8       assert((z >= x) && (z >= y));
9       return z;
10     }
11 
12     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
13       assert(x >= y);
14       uint256 z = x - y;
15       return z;
16     }
17 
18     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
19       uint256 z = x * y;
20       assert((x == 0)||(z/x == y));
21       return z;
22     }
23 
24 }
25 
26 contract Token {
27     uint256 public totalSupply;
28     function balanceOf(address _owner) constant returns (uint256 balance);
29     function transfer(address _to, uint256 _value) returns (bool success);
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
31     function approve(address _spender, uint256 _value) returns (bool success);
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 
37 
38 /*  ERC 20 token */
39 contract StandardToken is Token {
40 
41     function transfer(address _to, uint256 _value) returns (bool success) {
42       if (balances[msg.sender] >= _value && _value > 0) {
43         balances[msg.sender] -= _value;
44         balances[_to] += _value;
45         Transfer(msg.sender, _to, _value);
46         return true;
47       } else {
48         return false;
49       }
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
54         balances[_to] += _value;
55         balances[_from] -= _value;
56         allowed[_from][msg.sender] -= _value;
57         Transfer(_from, _to, _value);
58         return true;
59       } else {
60         return false;
61       }
62     }
63 
64     function balanceOf(address _owner) constant returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function approve(address _spender, uint256 _value) returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
75       return allowed[_owner][_spender];
76     }
77 
78     mapping (address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;
80 }
81 
82 contract FAPcoin is StandardToken, SafeMath {
83 
84     // metadata
85     string public constant name = "FAPcoin";
86     string public constant symbol = "FAP";
87     uint256 public constant decimals = 18;
88     string public version = "1.0";
89 
90     // contracts
91     address public ethFundDeposit;      // deposit address for ETH for FAP
92     address public FAPFounder;
93     address public FAPFundDeposit1;      // deposit address for depositing tokens for owners
94     address public FAPFundDeposit2;      // deposit address for depositing tokens for owners
95     address public FAPFundDeposit3;      // deposit address for depositing tokens for owners
96     address public FAPFundDeposit4;      // deposit address for depositing tokens for owners
97     address public FAPFundDeposit5;      // deposit address for depositing tokens for owners
98 
99     // crowdsale parameters
100     uint public firstStage;
101     uint public secondStage;
102     uint public thirdStage;
103     uint public fourthStage;
104     bool public isFinalized;              // switched to true in operational state
105     bool public saleStarted; //switched to true during ICO
106     uint256 public constant FAPFund = 50 * (10**6) * 10**decimals;   // FAPcoin reserved for Owners
107     uint256 public constant FAPFounderFund = 150 * (10**6) * 10**decimals;   // FAPcoin reserved for Owners
108     uint256 public tokenExchangeRate = 1500; //  FAPcoin tokens per 1 ETH
109     uint256 public constant tokenCreationCap =  500 * (10**6) * 10**decimals;
110 
111 
112     // events
113     event CreateFAP(address indexed _to, uint256 _value);
114 
115     // constructor
116     function FAPcoin()
117     {
118       isFinalized = false;                   //controls pre through crowdsale state
119       saleStarted = false;
120       FAPFounder = '0x97F5eD1c6af0F45B605f4Ebe62Bae572B2e2198A';
121       FAPFundDeposit1 = '0xF946cB03dC53Bfc13a902022C1c37eA830F8E35B';
122       FAPFundDeposit2 = '0x19Eb1FE8Fdc51C0f785F455D8aB3BD22Af50cf11';
123       FAPFundDeposit3 = '0xaD349885e35657956859c965670c41EE9A044b84';
124       FAPFundDeposit4 = '0x4EEbfDEe9141796AaaA65b53A502A6DcFF21d397';
125       FAPFundDeposit5 = '0x20a0A5759a56aDE253cf8BF3683923D7934CC84a';
126       ethFundDeposit = '0x6404B11A733b8a62Bd4bf3A27d08e40DD13a5686';
127       totalSupply = safeMult(FAPFund,5);
128       totalSupply = safeAdd(totalSupply,FAPFounderFund);
129       balances[FAPFundDeposit1] = FAPFund;    // Deposit tokens for Owners
130       balances[FAPFundDeposit2] = FAPFund;    // Deposit tokens for Owners
131       balances[FAPFundDeposit3] = FAPFund;    // Deposit tokens for Owners
132       balances[FAPFundDeposit4] = FAPFund;    // Deposit tokens for Owners
133       balances[FAPFundDeposit5] = FAPFund;    // Deposit tokens for Owners
134       balances[FAPFounder] = FAPFounderFund;    // Deposit tokens for Owners
135       CreateFAP(FAPFundDeposit1, FAPFund);  // logs Owners deposit
136       CreateFAP(FAPFundDeposit2, FAPFund);  // logs Owners deposit
137       CreateFAP(FAPFundDeposit3, FAPFund);  // logs Owners deposit
138       CreateFAP(FAPFundDeposit4, FAPFund);  // logs Owners deposit
139       CreateFAP(FAPFundDeposit5, FAPFund);  // logs Owners deposit
140       CreateFAP(FAPFounder, FAPFounderFund);  // logs Owners deposit
141     }
142 
143     /// @dev Accepts ether and creates new FAP tokens.
144     function () payable {
145       if (isFinalized) throw;
146       if (!saleStarted) throw;
147       if (msg.value == 0) throw;
148       //change exchange rate based on duration
149       if (now > firstStage && now <= secondStage){
150         tokenExchangeRate = 1300;
151       }
152       else if (now > secondStage && now <= thirdStage){
153         tokenExchangeRate = 1100;
154       }
155       if (now > thirdStage && now <= fourthStage){
156         tokenExchangeRate = 1050;
157       }
158       if (now > fourthStage){
159         tokenExchangeRate = 1000;
160       }
161       //create tokens
162       uint256 tokens = safeMult(msg.value, tokenExchangeRate); // check that we're not over totals
163       uint256 checkedSupply = safeAdd(totalSupply, tokens);
164 
165       // return money if something goes wrong
166       if (tokenCreationCap < checkedSupply) throw;  // odd fractions won't be found
167       totalSupply = checkedSupply;
168       //All good. start the transfer
169       balances[msg.sender] += tokens;  // safeAdd not needed
170       CreateFAP(msg.sender, tokens);  // logs token creation
171     }
172 
173     /// FAPcoin Ends the funding period and sends the ETH home
174     function finalize() external {
175       if (isFinalized) throw;
176       if (msg.sender != ethFundDeposit) throw; // locks finalize to the ultimate ETH owner
177       if (totalSupply < tokenCreationCap){
178         uint256 remainingTokens = safeSubtract(tokenCreationCap, totalSupply);
179         uint256 checkedSupply = safeAdd(totalSupply, remainingTokens);
180         if (tokenCreationCap < checkedSupply) throw;
181         totalSupply = checkedSupply;
182         balances[msg.sender] += remainingTokens;
183         CreateFAP(msg.sender, remainingTokens);
184       }
185       // move to operational
186       if(!ethFundDeposit.send(this.balance)) throw;
187       isFinalized = true;  // send the eth to FAPcoin
188     }
189 
190     function startSale() external {
191       if(saleStarted) throw;
192       if (msg.sender != ethFundDeposit) throw; // locks start sale to the ultimate ETH owner
193       firstStage = now + 15 days; //sets duration of first cutoff
194       secondStage = firstStage + 15 days; //sets duration of second cutoff
195       thirdStage = secondStage + 7 days; //sets duration of third cutoff
196       fourthStage = thirdStage + 6 days; //sets duration of third cutoff
197       saleStarted = true; //start the sale
198     }
199 
200 
201 }