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
82 contract test4 is StandardToken, SafeMath {
83 
84     // metadata
85     string public constant name = "test4";
86     string public constant symbol = "tt4";
87     uint256 public constant decimals = 18;
88     string public version = "1.0";
89 
90     // contracts
91     address public ethFundDeposit;      // deposit address for ETH for Phoenix
92     address public PhoenixFundDeposit;      // deposit address for depositing tokens for owners
93     address public PhoenixExchangeDeposit;      // deposit address depositing tokens for promotion, Exchange
94 
95     // crowdsale parameters
96     bool public isFinalized;              // switched to true in operational state
97     bool public saleStarted; //switched to true during ICO
98     uint public firstWeek;
99     uint public secondWeek;
100     uint public thirdWeek;
101     uint public fourthWeek;
102     uint256 public bonus;
103     uint256 public constant PhoenixFund = 500 * (10**5) * 10**decimals;   // 12.5m Phoenix reserved for Owners
104     uint256 public constant PhoenixExchangeFund = 500 * (10**5) * 10**decimals;   // 12.5m Phoenix reserved for Promotion, Exchange etc.
105     uint256 public tokenExchangeRate = 55; //  Phoenix tokens per 1 ETH
106     uint256 public constant tokenCreationCap =  200 * (10**6) * 10**decimals;
107     uint256 public constant tokenPreSaleCap =  1500 * (10**5) * 10**decimals;
108 
109 
110     // events
111     event CreatePHX(address indexed _to, uint256 _value);
112 
113     // constructor
114     function test4()
115     {
116       isFinalized = false;                   //controls pre through crowdsale state
117       saleStarted = false;
118       PhoenixFundDeposit = 0x1e8973b531f3eAb8a998C9d9eB89C8d51f90575D;
119       PhoenixExchangeDeposit = 0x1F7cA22AD1BceD2FC624a3086b4b77BB1ec575E8;
120       ethFundDeposit = 0xE61686aA75f59328C49b51e9ffb907D9680fC3Fb;
121       totalSupply = PhoenixFund + PhoenixExchangeFund;
122       balances[PhoenixFundDeposit] = PhoenixFund;    // Deposit tokens for Owners
123       balances[PhoenixExchangeDeposit] = PhoenixExchangeFund;    // Deposit tokens for Exchange and Promotion
124       CreatePHX(PhoenixFundDeposit, PhoenixFund);  // logs Owners deposit
125       CreatePHX(PhoenixExchangeDeposit, PhoenixExchangeFund);  // logs Exchange deposit
126     }
127 
128     /// @dev Accepts ether and creates new BAT tokens.
129     function () payable {
130       bool isPreSale = true;
131       if (isFinalized) throw;
132       if (!saleStarted) throw;
133       if (msg.value == 0) throw;
134       //change exchange rate based on duration
135       if (now > firstWeek && now < secondWeek){
136         tokenExchangeRate = 41;
137       }
138       else if (now > secondWeek && now < thirdWeek){
139         tokenExchangeRate = 29;
140       }
141       else if (now > thirdWeek && now < fourthWeek){
142         tokenExchangeRate = 25;
143       }
144       else if (now > fourthWeek){
145         tokenExchangeRate = 18;
146         isPreSale = false;
147       }
148       //create tokens
149       uint256 tokens = safeMult(msg.value, tokenExchangeRate); // check that we're not over totals
150       uint256 checkedSupply = safeAdd(totalSupply, tokens);
151 
152       // return money if something goes wrong
153       if(isPreSale && tokenPreSaleCap < checkedSupply) throw;
154       if (tokenCreationCap < checkedSupply) throw;  // odd fractions won't be found
155       totalSupply = checkedSupply;
156       //All good. start the transfer
157       balances[msg.sender] += tokens;  // safeAdd not needed
158       CreatePHX(msg.sender, tokens);  // logs token creation
159     }
160 
161     /// Phoenix Ends the funding period and sends the ETH home
162     function finalize() external {
163       if (isFinalized) throw;
164       if (msg.sender != ethFundDeposit) throw; // locks finalize to the ultimate ETH owner
165       if (totalSupply < tokenCreationCap){
166         uint256 remainingTokens = safeSubtract(tokenCreationCap, totalSupply);
167         uint256 checkedSupply = safeAdd(totalSupply, remainingTokens);
168         if (tokenCreationCap < checkedSupply) throw;
169         totalSupply = checkedSupply;
170         balances[msg.sender] += remainingTokens;
171         CreatePHX(msg.sender, remainingTokens);
172       }
173       // move to operational
174       if(!ethFundDeposit.send(this.balance)) throw;
175       isFinalized = true;  // send the eth to Phoenix
176     }
177 
178     function startSale() external {
179       if(saleStarted) throw;
180       if (msg.sender != ethFundDeposit) throw; // locks start sale to the ultimate ETH owner
181       firstWeek = now + 1 weeks; //sets duration of first cutoff
182       secondWeek = firstWeek + 1 weeks; //sets duration of second cutoff
183       thirdWeek = secondWeek + 1 weeks; //sets duration of third cutoff
184       fourthWeek = thirdWeek + 1 weeks; //sets duration of fourth cutoff
185       saleStarted = true; //start the sale
186     }
187 
188 
189 }