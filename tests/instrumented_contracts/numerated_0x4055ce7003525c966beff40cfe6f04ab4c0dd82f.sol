1 pragma solidity ^0.4.8;
2 
3 // @address 0x4055ce7003525c966beff40cfe6f04ab4c0dd82f
4 // The implementation for the Game ICO smart contract was inspired by
5 // the Ethereum token creation tutorial, the FirstBlood token, and the BAT token.
6 
7 ///////////////
8 // SAFE MATH //
9 ///////////////
10 
11 contract SafeMath {
12 
13     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
14         uint256 z = x + y;
15         require((z >= x) && (z >= y));
16         return z;
17     }
18 
19     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
20         require(x >= y);
21         uint256 z = x - y;
22         return z;
23     }
24 
25     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
26         uint256 z = x * y;
27         require((x == 0)||(z/x == y));
28         return z;
29     }
30 
31 }
32 
33 
34 ////////////////////
35 // STANDARD TOKEN //
36 ////////////////////
37 
38 contract Token {
39     uint256 public totalSupply;
40     function balanceOf(address _owner) constant returns (uint256 balance);
41     function transfer(address _to, uint256 _value) returns (bool success);
42     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
43     function approve(address _spender, uint256 _value) returns (bool success);
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 /*  ERC 20 token */
50 contract StandardToken is Token {
51 
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) allowed;
54 
55     function transfer(address _to, uint256 _value) returns (bool success) {
56         if (balances[msg.sender] >= _value && _value > 0) {
57             balances[msg.sender] -= _value;
58             balances[_to] += _value;
59             Transfer(msg.sender, _to, _value);
60             return true;
61         } else {
62             return false;
63         }
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
67         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
68             balances[_to] += _value;
69             balances[_from] -= _value;
70             allowed[_from][msg.sender] -= _value;
71             Transfer(_from, _to, _value);
72             return true;
73         } else {
74             return false;
75         }
76     }
77 
78     function balanceOf(address _owner) constant returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82     function approve(address _spender, uint256 _value) returns (bool success) {
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
89         return allowed[_owner][_spender];
90     }
91 }
92 
93 /////////////////////
94 //GAME.COM ICO TOKEN//
95 /////////////////////
96 
97 contract GameICO is StandardToken, SafeMath {
98     // Descriptive properties
99     string public constant name = "Game.com Token";
100     string public constant symbol = "GTC";
101     uint256 public constant decimals = 18;
102     string public version = "1.0";
103 
104     // Account for ether proceed.
105     address public etherProceedsAccount = 0x0;
106     address public multiWallet = 0x0;
107 
108     // These params specify the start, end, min, and max of the sale.
109     bool public isFinalized;
110 
111     uint256 public window0TotalSupply = 0;
112     uint256 public window1TotalSupply = 0;
113     uint256 public window2TotalSupply = 0;
114     uint256 public window3TotalSupply = 0;
115 
116     uint256 public window0StartTime = 0;
117     uint256 public window0EndTime = 0;
118     uint256 public window1StartTime = 0;
119     uint256 public window1EndTime = 0;
120     uint256 public window2StartTime = 0;
121     uint256 public window2EndTime = 0;
122     uint256 public window3StartTime = 0;
123     uint256 public window3EndTime = 0;
124 
125     // setting the capacity of every part of ico
126     uint256 public preservedTokens = 1300000000 * 10**decimals;
127     uint256 public window0TokenCreationCap = 200000000 * 10**decimals;
128     uint256 public window1TokenCreationCap = 200000000 * 10**decimals;
129     uint256 public window2TokenCreationCap = 300000000 * 10**decimals;
130     uint256 public window3TokenCreationCap = 0 * 10**decimals;
131 
132     // Setting the exchange rate for the ICO.
133     uint256 public window0TokenExchangeRate = 5000;
134     uint256 public window1TokenExchangeRate = 4000;
135     uint256 public window2TokenExchangeRate = 3000;
136     uint256 public window3TokenExchangeRate = 0;
137 
138     uint256 public preICOLimit = 0;
139 
140     // Events for logging refunds and token creation.
141     //event LogRefund(address indexed _to, uint256 _value);
142     event CreateGameIco(address indexed _to, uint256 _value);
143     event PreICOTokenPushed(address indexed _buyer, uint256 _amount);
144 
145     // constructor
146     function GameICO()
147     {
148         totalSupply =  2000000000 * 10**decimals;
149         isFinalized             = false;
150         etherProceedsAccount    = msg.sender;
151     }
152     function adjustTime(
153     uint256 _window0StartTime, uint256 _window0EndTime,
154     uint256 _window1StartTime, uint256 _window1EndTime,
155     uint256 _window2StartTime, uint256 _window2EndTime)
156     {
157         require(msg.sender == etherProceedsAccount);
158         window0StartTime = _window0StartTime;
159         window0EndTime = _window0EndTime;
160         window1StartTime = _window1StartTime;
161         window1EndTime = _window1EndTime;
162         window2StartTime = _window2StartTime;
163         window2EndTime = _window2EndTime;
164     }
165     function adjustSupply(uint256 _window0TotalSupply, uint256 _window1TotalSupply, uint256 _window2TotalSupply){
166         require(msg.sender == etherProceedsAccount);
167         window0TotalSupply = _window0TotalSupply * 10**decimals;
168         window1TotalSupply = _window1TotalSupply * 10**decimals;
169         window2TotalSupply = _window2TotalSupply * 10**decimals;
170     }
171     function adjustCap(uint256 _preservedTokens, uint256 _window0TokenCreationCap, uint256 _window1TokenCreationCap, uint256 _window2TokenCreationCap){
172         require(msg.sender == etherProceedsAccount);
173         preservedTokens = _preservedTokens * 10**decimals;
174         window0TokenCreationCap = _window0TokenCreationCap * 10**decimals;
175         window1TokenCreationCap = _window1TokenCreationCap * 10**decimals;
176         window2TokenCreationCap = _window2TokenCreationCap * 10**decimals;
177     }
178     function adjustRate(uint256 _window0TokenExchangeRate, uint256 _window1TokenExchangeRate, uint256 _window2TokenExchangeRate){
179         require(msg.sender == etherProceedsAccount);
180         window0TokenExchangeRate = _window0TokenExchangeRate;
181         window1TokenExchangeRate = _window1TokenExchangeRate;
182         window2TokenExchangeRate = _window2TokenExchangeRate;
183     }
184     function setProceedsAccount(address _newEtherProceedsAccount) {
185         require(msg.sender == etherProceedsAccount);
186         etherProceedsAccount = _newEtherProceedsAccount;
187     }
188     function setMultiWallet(address _newWallet){
189         require(msg.sender == etherProceedsAccount);
190         multiWallet = _newWallet;
191     }
192     function setPreICOLimit(uint256 _preICOLimit){
193         require(msg.sender == etherProceedsAccount);
194         preICOLimit = _preICOLimit;
195     }
196 
197     function preICOPush(address buyer, uint256 amount) {
198         require(msg.sender == etherProceedsAccount);
199 
200         uint256 tokens = 0;
201         uint256 checkedSupply = 0;
202         checkedSupply = safeAdd(window0TotalSupply, amount);
203         require(window0TokenCreationCap >= checkedSupply);
204         balances[buyer] += tokens;
205         window0TotalSupply = checkedSupply;
206         PreICOTokenPushed(buyer, amount);
207     }
208 
209     function () payable {
210         create();
211     }
212     function create() internal{
213         require(!isFinalized);
214         require(msg.value >= 0.001 ether);
215         uint256 tokens = 0;
216         uint256 checkedSupply = 0;
217 
218         if(window0StartTime != 0 && window0EndTime != 0 && time() >= window0StartTime && time() <= window0EndTime){
219             if(preICOLimit > 0){
220                 require(msg.value >= preICOLimit);
221             }
222             tokens = safeMult(msg.value, window0TokenExchangeRate);
223             checkedSupply = safeAdd(window0TotalSupply, tokens);
224             require(window0TokenCreationCap >= checkedSupply);
225             balances[msg.sender] += tokens;
226             window0TotalSupply = checkedSupply;
227             CreateGameIco(msg.sender, tokens);
228         }else if(window1StartTime != 0 && window1EndTime!= 0 && time() >= window1StartTime && time() <= window1EndTime){
229             tokens = safeMult(msg.value, window1TokenExchangeRate);
230             checkedSupply = safeAdd(window1TotalSupply, tokens);
231             require(window1TokenCreationCap >= checkedSupply);
232             balances[msg.sender] += tokens;
233             window1TotalSupply = checkedSupply;
234             CreateGameIco(msg.sender, tokens);
235         }else if(window2StartTime != 0 && window2EndTime != 0 && time() >= window2StartTime && time() <= window2EndTime){
236             tokens = safeMult(msg.value, window2TokenExchangeRate);
237             checkedSupply = safeAdd(window2TotalSupply, tokens);
238             require(window2TokenCreationCap >= checkedSupply);
239             balances[msg.sender] += tokens;
240             window2TotalSupply = checkedSupply;
241             CreateGameIco(msg.sender, tokens);
242         }else{
243             require(false);
244         }
245 
246     }
247 
248     function time() internal returns (uint) {
249         return block.timestamp;
250     }
251 
252     function today(uint startTime) internal returns (uint) {
253         return dayFor(time(), startTime);
254     }
255 
256     function dayFor(uint timestamp, uint startTime) internal returns (uint) {
257         return timestamp < startTime ? 0 : safeSubtract(timestamp, startTime) / 24 hours + 1;
258     }
259 
260     function withDraw(uint256 _value){
261         require(msg.sender == etherProceedsAccount);
262         if(multiWallet != 0x0){
263             if (!multiWallet.send(_value)) require(false);
264         }else{
265             if (!etherProceedsAccount.send(_value)) require(false);
266         }
267     }
268 
269     function finalize() {
270         require(!isFinalized);
271         require(msg.sender == etherProceedsAccount);
272         isFinalized = true;
273         balances[etherProceedsAccount] += totalSupply- window0TotalSupply- window1TotalSupply - window2TotalSupply;
274         if(multiWallet != 0x0){
275             if (!multiWallet.send(this.balance)) require(false);
276         }else{
277             if (!etherProceedsAccount.send(this.balance)) require(false);
278         }
279     }
280 
281 }