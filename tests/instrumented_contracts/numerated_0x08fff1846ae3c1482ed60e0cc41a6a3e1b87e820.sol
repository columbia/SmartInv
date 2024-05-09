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
54     bool allowTransfer = false;
55 
56     function transfer(address _to, uint256 _value) returns (bool success) {
57         if (balances[msg.sender] >= _value && _value > 0 && allowTransfer) {
58             balances[msg.sender] -= _value;
59             balances[_to] += _value;
60             Transfer(msg.sender, _to, _value);
61             return true;
62         } else {
63             return false;
64         }
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
68         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && allowTransfer) {
69             balances[_to] += _value;
70             balances[_from] -= _value;
71             allowed[_from][msg.sender] -= _value;
72             Transfer(_from, _to, _value);
73             return true;
74         } else {
75             return false;
76         }
77     }
78 
79     function balanceOf(address _owner) constant returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83     function approve(address _spender, uint256 _value) returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
90         return allowed[_owner][_spender];
91     }
92 }
93 
94 /////////////////////
95 //GAME.COM ICO TOKEN//
96 /////////////////////
97 
98 contract GameICO is StandardToken, SafeMath {
99     // Descriptive properties
100     string public constant name = "Game.com Token";
101     string public constant symbol = "GTC";
102     uint256 public constant decimals = 18;
103     string public version = "1.0";
104 
105     // Account for ether proceed.
106     address public etherProceedsAccount = 0x0;
107     address public multiWallet = 0x0;
108 
109     // These params specify the start, end, min, and max of the sale.
110     bool public isFinalized;
111 
112     uint256 public window0TotalSupply = 0;
113     uint256 public window1TotalSupply = 0;
114     uint256 public window2TotalSupply = 0;
115     uint256 public window3TotalSupply = 0;
116 
117     uint256 public window0StartTime = 0;
118     uint256 public window0EndTime = 0;
119     uint256 public window1StartTime = 0;
120     uint256 public window1EndTime = 0;
121     uint256 public window2StartTime = 0;
122     uint256 public window2EndTime = 0;
123     uint256 public window3StartTime = 0;
124     uint256 public window3EndTime = 0;
125 
126     // setting the capacity of every part of ico
127     uint256 public preservedTokens = 1300000000 * 10**decimals;
128     uint256 public window0TokenCreationCap = 200000000 * 10**decimals;
129     uint256 public window1TokenCreationCap = 200000000 * 10**decimals;
130     uint256 public window2TokenCreationCap = 300000000 * 10**decimals;
131     uint256 public window3TokenCreationCap = 0 * 10**decimals;
132 
133     // Setting the exchange rate for the ICO.
134     uint256 public window0TokenExchangeRate = 5000;
135     uint256 public window1TokenExchangeRate = 4000;
136     uint256 public window2TokenExchangeRate = 3000;
137     uint256 public window3TokenExchangeRate = 0;
138 
139     uint256 public preICOLimit = 0;
140     bool public instantTransfer = false;
141 
142     // Events for logging refunds and token creation.
143     event CreateGameIco(address indexed _to, uint256 _value);
144     event PreICOTokenPushed(address indexed _buyer, uint256 _amount);
145 
146     // constructor
147     function GameICO()
148     {
149         totalSupply             = 2000000000 * 10**decimals;
150         isFinalized             = false;
151         etherProceedsAccount    = msg.sender;
152     }
153     function adjustTime(
154     uint256 _window0StartTime, uint256 _window0EndTime,
155     uint256 _window1StartTime, uint256 _window1EndTime,
156     uint256 _window2StartTime, uint256 _window2EndTime)
157     {
158         require(msg.sender == etherProceedsAccount);
159         window0StartTime = _window0StartTime;
160         window0EndTime = _window0EndTime;
161         window1StartTime = _window1StartTime;
162         window1EndTime = _window1EndTime;
163         window2StartTime = _window2StartTime;
164         window2EndTime = _window2EndTime;
165     }
166     function adjustSupply(uint256 _window0TotalSupply, uint256 _window1TotalSupply, uint256 _window2TotalSupply){
167         require(msg.sender == etherProceedsAccount);
168         window0TotalSupply = _window0TotalSupply * 10**decimals;
169         window1TotalSupply = _window1TotalSupply * 10**decimals;
170         window2TotalSupply = _window2TotalSupply * 10**decimals;
171     }
172     function adjustCap(uint256 _preservedTokens, uint256 _window0TokenCreationCap, uint256 _window1TokenCreationCap, uint256 _window2TokenCreationCap){
173         require(msg.sender == etherProceedsAccount);
174         preservedTokens = _preservedTokens * 10**decimals;
175         window0TokenCreationCap = _window0TokenCreationCap * 10**decimals;
176         window1TokenCreationCap = _window1TokenCreationCap * 10**decimals;
177         window2TokenCreationCap = _window2TokenCreationCap * 10**decimals;
178     }
179     function adjustRate(uint256 _window0TokenExchangeRate, uint256 _window1TokenExchangeRate, uint256 _window2TokenExchangeRate){
180         require(msg.sender == etherProceedsAccount);
181         window0TokenExchangeRate = _window0TokenExchangeRate;
182         window1TokenExchangeRate = _window1TokenExchangeRate;
183         window2TokenExchangeRate = _window2TokenExchangeRate;
184     }
185     function setProceedsAccount(address _newEtherProceedsAccount) {
186         require(msg.sender == etherProceedsAccount);
187         etherProceedsAccount = _newEtherProceedsAccount;
188     }
189     function setMultiWallet(address _newWallet){
190         require(msg.sender == etherProceedsAccount);
191         multiWallet = _newWallet;
192     }
193     function setPreICOLimit(uint256 _preICOLimit){
194         require(msg.sender == etherProceedsAccount);
195         preICOLimit = _preICOLimit;// * 10**decimals;
196     }
197     function setInstantTransfer(bool _instantTransfer){
198         require(msg.sender == etherProceedsAccount);
199         instantTransfer = _instantTransfer;
200     }
201     function setAllowTransfer(bool _allowTransfer){
202         require(msg.sender == etherProceedsAccount);
203         allowTransfer = _allowTransfer;
204     }
205 
206     function preICOPush(address buyer, uint256 amount) {
207         require(msg.sender == etherProceedsAccount);
208 
209         uint256 tokens = 0;
210         uint256 checkedSupply = 0;
211         checkedSupply = safeAdd(window0TotalSupply, amount);
212         require(window0TokenCreationCap >= checkedSupply);
213         balances[buyer] += tokens;
214         window0TotalSupply = checkedSupply;
215         PreICOTokenPushed(buyer, amount);
216     }
217 
218     function () payable {
219         create();
220     }
221     function create() internal{
222         require(!isFinalized);
223         require(msg.value >= 0.01 ether);
224         uint256 tokens = 0;
225         uint256 checkedSupply = 0;
226 
227         if(window0StartTime != 0 && window0EndTime != 0 && time() >= window0StartTime && time() <= window0EndTime){
228             if(preICOLimit > 0){
229                 require(msg.value >= preICOLimit);
230             }
231             tokens = safeMult(msg.value, window0TokenExchangeRate);
232             checkedSupply = safeAdd(window0TotalSupply, tokens);
233             require(window0TokenCreationCap >= checkedSupply);
234             balances[msg.sender] += tokens;
235             window0TotalSupply = checkedSupply;
236             if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);
237             CreateGameIco(msg.sender, tokens);
238         }else if(window1StartTime != 0 && window1EndTime!= 0 && time() >= window1StartTime && time() <= window1EndTime){
239             tokens = safeMult(msg.value, window1TokenExchangeRate);
240             checkedSupply = safeAdd(window1TotalSupply, tokens);
241             require(window1TokenCreationCap >= checkedSupply);
242             balances[msg.sender] += tokens;
243             window1TotalSupply = checkedSupply;
244             if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);
245             CreateGameIco(msg.sender, tokens);
246         }else if(window2StartTime != 0 && window2EndTime != 0 && time() >= window2StartTime && time() <= window2EndTime){
247             tokens = safeMult(msg.value, window2TokenExchangeRate);
248             checkedSupply = safeAdd(window2TotalSupply, tokens);
249             require(window2TokenCreationCap >= checkedSupply);
250             balances[msg.sender] += tokens;
251             window2TotalSupply = checkedSupply;
252             if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);
253             CreateGameIco(msg.sender, tokens);
254         }else{
255             require(false);
256         }
257 
258     }
259 
260     function time() internal returns (uint) {
261         return block.timestamp;
262     }
263 
264     function today(uint startTime) internal returns (uint) {
265         return dayFor(time(), startTime);
266     }
267 
268     function dayFor(uint timestamp, uint startTime) internal returns (uint) {
269         return timestamp < startTime ? 0 : safeSubtract(timestamp, startTime) / 24 hours + 1;
270     }
271 
272     function withDraw(uint256 _value){
273         require(msg.sender == etherProceedsAccount);
274         if(multiWallet != 0x0){
275             if (!multiWallet.send(_value)) require(false);
276         }else{
277             if (!etherProceedsAccount.send(_value)) require(false);
278         }
279     }
280 
281     function finalize() {
282         require(!isFinalized);
283         require(msg.sender == etherProceedsAccount);
284         isFinalized = true;
285         balances[etherProceedsAccount] += totalSupply- window0TotalSupply- window1TotalSupply - window2TotalSupply;
286         if(multiWallet != 0x0){
287             if (!multiWallet.send(this.balance)) require(false);
288         }else{
289             if (!etherProceedsAccount.send(this.balance)) require(false);
290         }
291     }
292 
293 }