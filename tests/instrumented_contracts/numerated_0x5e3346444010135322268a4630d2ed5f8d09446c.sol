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
82 contract LockChain is StandardToken, SafeMath {
83 
84     // metadata
85     string public constant name = "LockChain";
86     string public constant symbol = "LOC";
87     uint256 public constant decimals = 18;
88     string public version = "1.0";
89 
90     // contracts
91     address public LockChainFundDeposit;      // deposit address for depositing tokens for owners
92     address public account1Address;      // deposit address for depositing tokens for owners
93     address public account2Address;
94     address public creatorAddress;
95 
96     // crowdsale parameters
97     bool public isFinalized;              // switched to true in operational state
98     bool public isPreSale;
99     bool public isPrePreSale;
100     bool public isMainSale;
101     uint public preSalePeriod;
102     uint public prePreSalePeriod;
103     uint256 public tokenExchangeRate = 0; //  LockChain tokens per 1 ETH
104     uint256 public constant tokenSaleCap =  155 * (10**6) * 10**decimals;
105     uint256 public constant tokenPreSaleCap =  50 * (10**6) * 10**decimals;
106 
107 
108     // events
109     event CreateLOK(address indexed _to, uint256 _value);
110 
111     // constructor
112     function LockChain()
113     {
114       isFinalized = false;                   //controls pre through crowdsale state
115       LockChainFundDeposit = '0x013aF31dc76255d3b33d2185A7148300882EbC7a';
116       account1Address = '0xe0F2653e7928e6CB7c6D3206163b3E466a29c7C3';
117       account2Address = '0x25BC70bFda877e1534151cB92D97AC5E69e1F53D';
118       creatorAddress = '0x953ebf6C38C58C934D58b9b17d8f9D0F121218BB';
119       isPrePreSale = false;
120       isPreSale = false;
121       isMainSale = false;
122       totalSupply = 0;
123     }
124 
125     /// @dev Accepts ether and creates new LOK tokens.
126     function () payable {
127       if (isFinalized) throw;
128       if (!isPrePreSale && !isPreSale && !isMainSale) throw;
129       //if (!saleStarted) throw;
130       if (msg.value == 0) throw;
131       //create tokens
132       uint256 tokens = safeMult(msg.value, tokenExchangeRate); // check that we're not over totals
133       uint256 checkedSupply = safeAdd(totalSupply, tokens);
134 
135       if(!isMainSale){
136         if (tokenPreSaleCap < checkedSupply) throw;
137       }
138 
139       // return money if something goes wrong
140       if (tokenSaleCap < checkedSupply) throw;  // odd fractions won't be found
141       totalSupply = checkedSupply;
142       //All good. start the transfer
143       balances[msg.sender] += tokens;  // safeAdd not needed
144       CreateLOK(msg.sender, tokens);  // logs token creation
145     }
146 
147     /// LockChain Ends the funding period and sends the ETH home
148     function finalize() external {
149       if (isFinalized) throw;
150       if (msg.sender != LockChainFundDeposit) throw; // locks finalize to the ultimate ETH owner
151         uint256 newTokens = totalSupply;
152         uint256 account1Tokens;
153         uint256 account2Tokens;
154         uint256 creatorTokens = 10000 * 10**decimals;
155         uint256 LOKFundTokens;
156         uint256 checkedSupply = safeAdd(totalSupply, newTokens);
157         totalSupply = checkedSupply;
158         if (newTokens % 2 == 0){
159           LOKFundTokens = newTokens/2;
160           account2Tokens = newTokens/2;
161           account1Tokens = LOKFundTokens - creatorTokens;
162           balances[account1Address] += account1Tokens;
163           balances[account2Address] += account2Tokens;
164         }
165         else{
166           uint256 makeEven = newTokens - 1;
167           uint256 halfTokens = makeEven/2;
168           LOKFundTokens = halfTokens;
169           account2Tokens = halfTokens + 1;
170           account1Tokens = LOKFundTokens - creatorTokens;
171           balances[account1Address] += account1Tokens;
172           balances[account2Address] += account2Tokens;
173         }
174         balances[creatorAddress] += creatorTokens;
175         CreateLOK(creatorAddress, creatorTokens);
176         CreateLOK(account1Address, account1Tokens);
177         CreateLOK(account2Address, account2Tokens);
178       // move to operational
179       if(!LockChainFundDeposit.send(this.balance)) throw;
180       isFinalized = true;  // send the eth to LockChain
181     }
182     function switchSaleStage() external {
183       if (msg.sender != LockChainFundDeposit) throw; // locks finalize to the ultimate ETH owner
184       if(isMainSale) throw;
185       if(!isPrePreSale){
186         isPrePreSale = true;
187         tokenExchangeRate = 1150;
188       }
189       else if (!isPreSale){
190         isPreSale = true;
191         tokenExchangeRate = 1000;
192       }
193       else if (!isMainSale){
194         isMainSale = true;
195         if (totalSupply < 10 * (10**6) * 10**decimals)
196         {
197           tokenExchangeRate = 750;
198         }
199         else if (totalSupply >= 10 * (10**6) * 10**decimals && totalSupply < 20 * (10**6) * 10**decimals)
200         {
201           tokenExchangeRate = 700;
202         }
203         else if (totalSupply >= 20 * (10**6) * 10**decimals && totalSupply < 30 * (10**6) * 10**decimals)
204         {
205           tokenExchangeRate = 650;
206         }
207         else if (totalSupply >= 30 * (10**6) * 10**decimals && totalSupply < 40 * (10**6) * 10**decimals)
208         {
209           tokenExchangeRate = 620;
210         }
211         else if (totalSupply >= 40 * (10**6) * 10**decimals && totalSupply <= 50 * (10**6) * 10**decimals)
212         {
213           tokenExchangeRate = 600;
214         }
215 
216       }
217     }
218 
219 
220 }