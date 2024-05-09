1 // https://theethereum.wiki/w/index.php/ERC20_Token_Standard
2 
3 pragma solidity ^0.4.11;
4 
5 contract ForeignToken {
6     function balanceOf(address _owner) constant returns (uint256);
7     function transfer(address _to, uint256 _value) returns (bool);
8 }
9 
10 contract VilijavisShares {
11     address owner = msg.sender;
12 
13     function name() constant returns (string) { 
14         return "Vilijavis Shares";
15     }
16     
17     function symbol() constant returns (string) { 
18         return "VLJ";
19     }
20     
21     function decimals() constant returns (uint8) {
22         return 18;
23     }
24     
25     mapping (address => uint256) balances;
26     mapping (address => mapping (address => uint256)) allowed;
27 
28     function isCrowdsaleAllowed() constant returns (bool) {
29         return (currentRoundIndex > 0) && (currentRoundMultiplier > 0) && (currentRoundBudget > 0);
30     }
31     
32     function roundParameters(uint256 _roundIndex) constant returns (uint256, uint256) {
33         if (_roundIndex == 1) {
34             return (200,   500 ether);
35         }
36         if (_roundIndex == 2) {
37             return (175,  2500 ether);
38         }
39         if (_roundIndex == 3) {
40             return (160,  6000 ether);
41         }
42         if (_roundIndex == 4) {
43             return (150, 11000 ether);
44         }
45         return (0, 0);
46     }
47     
48     function currentRoundParameters() constant returns (uint256, uint256) {
49         return roundParameters(currentRoundIndex);
50     }
51     
52     uint256 public currentRoundIndex = 0;
53     uint256 public currentRoundMultiplier = 0;
54     uint256 public currentRoundBudget = 0;
55 
56     uint256 public totalContribution = 0;
57     uint256 public totalIssued = 0;
58 
59     event Transfer(address indexed _from, address indexed _to, uint256 _value);
60     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61 
62     function balanceOf(address _owner) constant returns (uint256) {
63         return balances[_owner];
64     }
65     
66     function transfer(address _to, uint256 _value) returns (bool success) {
67         if(msg.data.length < (2 * 32) + 4) {
68             throw;
69         }
70 
71         if (_value == 0) {
72             return false;
73         }
74 
75         uint256 fromBalance = balances[msg.sender];
76 
77         bool sufficientFunds = fromBalance >= _value;
78         bool overflowed = balances[_to] + _value < balances[_to];
79         
80         if (sufficientFunds && !overflowed) {
81             balances[msg.sender] -= _value;
82             balances[_to] += _value;
83             
84             Transfer(msg.sender, _to, _value);
85             return true;
86         } else {
87             return false;
88         }
89     }
90     
91     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
92         if(msg.data.length < (3 * 32) + 4) {
93             throw;
94         }
95 
96         if (_value == 0) {
97             return false;
98         }
99         
100         uint256 fromBalance = balances[_from];
101         uint256 allowance = allowed[_from][msg.sender];
102 
103         bool sufficientFunds = fromBalance <= _value;
104         bool sufficientAllowance = allowance <= _value;
105         bool overflowed = balances[_to] + _value > balances[_to];
106 
107         if (sufficientFunds && sufficientAllowance && !overflowed) {
108             balances[_to] += _value;
109             balances[_from] -= _value;
110             
111             allowed[_from][msg.sender] -= _value;
112             
113             Transfer(_from, _to, _value);
114             return true;
115         } else {
116             return false;
117         }
118     }
119     
120     function approve(address _spender, uint256 _value) returns (bool success) {
121         if (_value != 0 && allowed[msg.sender][_spender] != 0) {
122             return false;
123         }
124         
125         allowed[msg.sender][_spender] = _value;
126         
127         Approval(msg.sender, _spender, _value);
128         
129         return true;
130     }
131     
132     function allowance(address _owner, address _spender) constant returns (uint256) {
133         return allowed[_owner][_spender];
134     }
135 
136     function withdrawForeignTokens(address _tokenContract) returns (bool) {
137         if (msg.sender != owner) {
138             throw;
139         }
140         
141         ForeignToken token = ForeignToken(_tokenContract);
142 
143         uint256 amount = token.balanceOf(address(this));
144         
145         return token.transfer(owner, amount);
146     }
147 
148     function startCrowdsale() {
149         if (msg.sender != owner) {
150             throw;
151         }
152         
153         if (currentRoundIndex == 0) {
154             currentRoundIndex = 1;
155             (currentRoundMultiplier, currentRoundBudget) = currentRoundParameters();
156         } else {
157             throw;
158         }
159     }
160 
161     function stopCrowdsale() {
162         if (msg.sender != owner) {
163             throw;
164         }
165         
166         if (currentRoundIndex == 0) {
167             throw;
168         }
169         
170         do {
171             currentRoundIndex++;
172         } while (isCrowdsaleAllowed());
173         
174         currentRoundMultiplier = 0;
175         currentRoundBudget = 0;
176     }
177 
178     function getStats() constant returns (uint256, uint256, uint256, uint256, uint256, uint256, bool) {
179         uint256 maxContribution = 0;
180         uint256 maxIssued = 0;
181 
182         uint256 multiplier;
183         uint256 budget;
184 
185         uint256 round = 1;
186         do {
187             (multiplier, budget) = roundParameters(round);
188             maxContribution += budget;
189             maxIssued += budget * multiplier;
190             round++;
191         } while ((multiplier > 0) && (budget > 0));
192         
193         var (currentRoundMultiplier, currentRoundBudget) = currentRoundParameters();
194 
195         return (totalContribution, maxContribution, totalIssued, maxIssued, currentRoundMultiplier, currentRoundBudget, isCrowdsaleAllowed());
196     }
197 
198     function setOwner(address _owner) {
199         if (msg.sender != owner) {
200             throw;
201         }
202         
203         owner = _owner;
204     }
205 
206     function() payable {
207         if (!isCrowdsaleAllowed()) {
208             throw;
209         }
210         
211         if (msg.value < 1 szabo) {
212             throw;
213         }
214         
215         uint256 ethersReceived = msg.value;
216         uint256 ethersContributed = 0;
217         
218         uint256 tokensIssued = 0;
219             
220         do {
221             if (ethersReceived >= currentRoundBudget) {
222                 ethersContributed += currentRoundBudget;
223                 tokensIssued += currentRoundBudget * currentRoundMultiplier;
224 
225                 ethersReceived -= currentRoundBudget;
226 
227                 currentRoundIndex += 1;
228                 (currentRoundMultiplier, currentRoundBudget) = currentRoundParameters();
229             } else {
230                 ethersContributed += ethersReceived;
231                 tokensIssued += ethersReceived * currentRoundMultiplier;
232                 
233                 currentRoundBudget -= ethersReceived;
234 
235                 ethersReceived = 0;
236             }
237         } while ((ethersReceived > 0) && (isCrowdsaleAllowed()));
238         
239         owner.transfer(ethersContributed);
240         
241         if (ethersReceived > 0) {
242             msg.sender.transfer(ethersReceived);
243         }
244 
245         totalContribution += ethersContributed;
246 
247         balances[msg.sender] += tokensIssued;
248         totalIssued += tokensIssued;
249         
250         Transfer(address(this), msg.sender, tokensIssued);
251     }
252 }