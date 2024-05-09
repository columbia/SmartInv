1 pragma solidity ^0.4.11;
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
18     function safeSub(uint256 x, uint256 y) internal returns(uint256) {
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
32 contract owned {
33     address public owner;
34 
35     function owned() {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner {
40         assert(msg.sender == owner);
41         _;
42     }
43 
44     function transferOwnership(address newOwner) onlyOwner {
45         owner = newOwner;
46     }
47 }
48 
49 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
50 
51 contract Token is owned {
52     uint256 public totalSupply;
53     function balanceOf(address _owner) constant returns (uint256 balance);
54     function transfer(address _to, uint256 _value) returns (bool success);
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
56     function approve(address _spender, uint256 _value) returns (bool success);
57     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
58     
59     /* This generates a public event on the blockchain that will notify clients */
60     event Transfer(address indexed _from, address indexed _to, uint256 _value);
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 }
63 
64 
65 /*  ERC 20 token */
66 contract StandardToken is SafeMath, Token {
67     /* Send coins */
68     function transfer(address _to, uint256 _value) returns (bool success) {
69         if (balances[msg.sender] >= _value && _value > 0) {
70             balances[msg.sender] = safeSub(balances[msg.sender], _value);
71             balances[_to] = safeAdd(balances[_to], _value);
72             Transfer(msg.sender, _to, _value);
73             return true;
74         } else {
75             return false;
76         }
77     }
78 
79     /* A contract attempts to get the coins */
80     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
81         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
82             balances[_to] = safeAdd(balances[_to], _value);
83             balances[_from] = safeSub(balances[_from], _value);
84             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
85             Transfer(_from, _to, _value);
86             return true;
87         } else {
88             return false;
89         }
90     }
91 
92     function balanceOf(address _owner) constant returns (uint256 balance) {
93         return balances[_owner];
94     }
95 
96     /* Allow another contract to spend some tokens in your behalf */
97     function approve(address _spender, uint256 _value) returns (bool success) {
98         assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
99         allowed[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 
104     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
105         return allowed[_owner][_spender];
106     }
107 
108     /* This creates an array with all balances */
109     mapping (address => uint256) balances;
110     mapping (address => mapping (address => uint256)) allowed;
111 }
112 
113 contract XPAToken is StandardToken {
114 
115     // metadata
116     string public constant name = "XPlay Token";
117     string public constant symbol = "XPA";
118     uint256 public constant decimals = 18;
119     string public version = "1.0";
120 
121     // contracts
122     address public ethFundDeposit;      // deposit address of ETH for XPlay Ltd.
123     address public xpaFundDeposit;      // deposit address for XPlay Ltd. use and XPA User Fund
124 
125     // crowdsale parameters
126     bool public isFinalized;              // switched to true in operational state
127     uint256 public fundingStartBlock;
128     uint256 public fundingEndBlock;
129     uint256 public crowdsaleSupply = 0;         // crowdsale supply
130     uint256 public tokenExchangeRate = 23000;   // 23000 XPA tokens per 1 ETH
131     uint256 public constant tokenCreationCap =  10 * (10**9) * 10**decimals;
132     uint256 public tokenCrowdsaleCap =  4 * (10**8) * 10**decimals;
133 
134     // events
135     event CreateXPA(address indexed _to, uint256 _value);
136 
137     // constructor
138     function XPAToken(
139         address _ethFundDeposit,
140         address _xpaFundDeposit,
141         uint256 _tokenExchangeRate,
142         uint256 _fundingStartBlock,
143         uint256 _fundingEndBlock)
144     {
145         isFinalized = false;                   //controls pre through crowdsale state
146         ethFundDeposit = _ethFundDeposit;
147         xpaFundDeposit = _xpaFundDeposit;
148         tokenExchangeRate = _tokenExchangeRate;
149         fundingStartBlock = _fundingStartBlock;
150         fundingEndBlock = _fundingEndBlock;
151         totalSupply = tokenCreationCap;
152         balances[xpaFundDeposit] = tokenCreationCap;    // deposit all XPA to XPlay Ltd.
153         CreateXPA(xpaFundDeposit, tokenCreationCap);    // logs deposit of XPlay Ltd. fund
154     }
155 
156     function () payable {
157         assert(!isFinalized);
158         require(block.number >= fundingStartBlock);
159         require(block.number < fundingEndBlock);
160         require(msg.value > 0);
161 
162         uint256 tokens = safeMult(msg.value, tokenExchangeRate);    // check that we're not over totals
163         crowdsaleSupply = safeAdd(crowdsaleSupply, tokens);
164 
165         // return money if something goes wrong
166         require(tokenCrowdsaleCap >= crowdsaleSupply);
167 
168         balances[msg.sender] += tokens;     // add amount of XPA to sender
169         balances[xpaFundDeposit] = safeSub(balances[xpaFundDeposit], tokens); // subtracts amount from XPlay's balance
170         CreateXPA(msg.sender, tokens);      // logs token creation
171 
172     }
173     /// @dev Accepts ether and creates new XPA tokens.
174     function createTokens() payable external {
175         assert(!isFinalized);
176         require(block.number >= fundingStartBlock);
177         require(block.number < fundingEndBlock);
178         require(msg.value > 0);
179 
180         uint256 tokens = safeMult(msg.value, tokenExchangeRate);    // check that we're not over totals
181         crowdsaleSupply = safeAdd(crowdsaleSupply, tokens);
182 
183         // return money if something goes wrong
184         require(tokenCrowdsaleCap >= crowdsaleSupply);
185 
186         balances[msg.sender] += tokens;     // add amount of XPA to sender
187         balances[xpaFundDeposit] = safeSub(balances[xpaFundDeposit], tokens); // subtracts amount from XPlay's balance
188         CreateXPA(msg.sender, tokens);      // logs token creation
189     }
190 
191     /* Approve and then communicate the approved contract in a single tx */
192     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
193         returns (bool success) {    
194         tokenRecipient spender = tokenRecipient(_spender);
195         if (approve(_spender, _value)) {
196             spender.receiveApproval(msg.sender, _value, this, _extraData);
197             return true;
198         }
199     }
200     /// @dev Update crowdsale parameter
201     function updateParams(
202         uint256 _tokenExchangeRate,
203         uint256 _tokenCrowdsaleCap,
204         uint256 _fundingStartBlock,
205         uint256 _fundingEndBlock) onlyOwner external 
206     {
207         assert(block.number < fundingStartBlock);
208         assert(!isFinalized);
209       
210         // update system parameters
211         tokenExchangeRate = _tokenExchangeRate;
212         tokenCrowdsaleCap = _tokenCrowdsaleCap;
213         fundingStartBlock = _fundingStartBlock;
214         fundingEndBlock = _fundingEndBlock;
215     }
216     /// @dev Ends the funding period and sends the ETH home
217     function finalize() onlyOwner external {
218         assert(!isFinalized);
219       
220         // move to operational
221         isFinalized = true;
222         assert(ethFundDeposit.send(this.balance));              // send the eth to XPlay ltd.
223     }
224 }