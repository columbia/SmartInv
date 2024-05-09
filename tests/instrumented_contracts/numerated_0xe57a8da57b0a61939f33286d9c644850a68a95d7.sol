1 pragma solidity ^0.4.18;
2 
3 contract Math {
4     function safeMul(uint a, uint b) internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return uint(c);
8     }
9 
10     function safeSub(uint a, uint b) internal returns (uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function safeAdd(uint a, uint b) internal returns (uint) {
16         uint c = a + b;
17         assert(c>=a && c>=b);
18         return uint(c);
19     }
20 
21     function assert(bool assertion) internal {
22         if (!assertion)
23             revert();
24     }
25 }
26 
27 contract Bartcoin is Math {
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Refund(address indexed to, uint256 value);
30     event Reward(address indexed to, uint256 value);
31     
32     //BARC META - non-changable
33     string SYMBOL = "BARC";
34     string TOKEN_NAME = "Bartcoin";
35     uint DECIMAL_PLACES = 3;
36     
37     //BARC INFO
38     uint256 TOTAL_SUPPLY = 168000000 * 1e3;
39     uint256 MINER_REWARD = 64;
40     address LASTEST_MINER;
41     uint256 TIME_FOR_CROWDSALE;
42     uint256 CREATION_TIME = now;
43     address NEUTRAL_ADDRESS = 0xf4fa2a94c38f114bdcfa9d941c03cdd7e5e860a1;
44     
45     //BARC OWNER INFO
46     address OWNER;
47     string OWNER_NAME = "OCTAVE YOUSEEME FRANCE";
48     
49     //BARC VARIABLES
50     mapping(address => uint) users;
51     uint BLOCK_COUNT = 0;
52     uint CYCLES = 1; //update reward cycles, reward will be halved after every 1024 blocks
53     
54     /*
55     * modifier
56     */
57     modifier onlyOwner {
58         if (msg.sender != OWNER)
59             revert(); 
60         _;
61     }
62     
63     /*
64     * Ownership functions
65     */
66     constructor(uint256 numberOfDays) public {
67         OWNER = msg.sender;
68         users[this] = TOTAL_SUPPLY;
69         
70         TIME_FOR_CROWDSALE = CREATION_TIME + (numberOfDays * 1 days);
71     }
72     
73     function transferOwnership(address newOwner) onlyOwner public {
74         if (newOwner == 0x0) {
75             revert();
76         } else {
77             OWNER = newOwner;
78         }
79     }
80     
81     function getCrowdsaleTime() public constant returns(uint256) {
82         return TIME_FOR_CROWDSALE;
83     }
84     
85     function increaseCrowsaleTime(uint256 daysToIncrease) public onlyOwner {
86         uint256 crowdSaleTime = daysToIncrease * 1 days;
87         TIME_FOR_CROWDSALE = TIME_FOR_CROWDSALE + crowdSaleTime;
88     }
89 
90     /**
91      * ERC20 Token
92      */
93     function name() public constant returns(string) {
94         return TOKEN_NAME;
95     }
96     
97     function totalSupply() public constant returns (uint256) {
98         return TOTAL_SUPPLY;
99     }
100     
101     function decimals() public constant returns(uint) {
102         return DECIMAL_PLACES;
103     }
104     
105     function symbol() public constant returns(string) {
106         return SYMBOL;
107     }
108 
109     //Enable Mining BARC for Ethereum miner
110     function rewardToMiner() internal {
111         if (MINER_REWARD == 0) {
112            return; 
113         }
114         
115         BLOCK_COUNT = BLOCK_COUNT + 1;
116         uint reward = MINER_REWARD * 1e3;
117         if (users[this] > reward) {
118             users[this] = safeSub(users[this], reward);
119             users[block.coinbase] = safeAdd(users[block.coinbase], reward);
120             LASTEST_MINER = block.coinbase;
121             emit Reward(block.coinbase, MINER_REWARD);
122         }
123         
124         uint blockToUpdate = CYCLES * 1024;
125         if (BLOCK_COUNT == blockToUpdate) {
126             MINER_REWARD = MINER_REWARD / 2;
127         }
128     }
129 
130     function transfer(address to, uint256 tokens) public {
131         if (users[msg.sender] < tokens) {
132             revert();
133         }
134 
135         users[msg.sender] = safeSub(users[msg.sender], tokens);
136         users[to] = safeAdd(users[to], tokens);
137         emit Transfer(msg.sender, to, tokens);
138 
139         rewardToMiner();
140     }
141     
142     function give(address to, uint256 tokens) public onlyOwner {
143         if (users[NEUTRAL_ADDRESS] < tokens) {
144             revert();
145         }
146         
147         //lock all remaining coins
148         if (TIME_FOR_CROWDSALE < now){
149             revert(); 
150         }
151 
152         users[NEUTRAL_ADDRESS] = safeSub(users[NEUTRAL_ADDRESS], tokens);
153         users[to] = safeAdd(users[to], tokens);
154         emit Transfer(NEUTRAL_ADDRESS, to, tokens);
155 
156         rewardToMiner();
157     }
158     
159     function purchase(uint256 tokens) public onlyOwner {
160         if (users[this] < tokens) {
161             revert();
162         }
163         
164         //lock all remaining coins
165         if (TIME_FOR_CROWDSALE < now){
166             revert(); 
167         }
168 
169         users[this] = safeSub(users[this], tokens);
170         users[NEUTRAL_ADDRESS] = safeAdd(users[NEUTRAL_ADDRESS], tokens);
171         emit Transfer(msg.sender, NEUTRAL_ADDRESS, tokens);
172 
173         rewardToMiner();
174     }
175     
176     function balanceOf(address tokenOwner) public constant returns (uint balance) {
177         return users[tokenOwner];
178     }
179     
180     /**
181      * Normal functions
182      */
183     function getMiningInfo() public constant returns(address lastetMiner, uint currentBlockCount, uint currentReward) {
184         return (LASTEST_MINER, BLOCK_COUNT, MINER_REWARD);
185     }
186     
187     function getOwner() public constant returns (address ownerAddress, uint balance) {
188         uint ownerBalance = users[OWNER];
189         return (OWNER, ownerBalance);
190     }
191     
192     function() payable public {
193         revert();
194     }
195     
196     function increaseTotal(uint amount) public onlyOwner {
197         TOTAL_SUPPLY = TOTAL_SUPPLY + amount;
198         users[this] = users[this] + amount;
199     }
200     
201     function decreaseTotal(uint amount) public onlyOwner {
202         if (users[this] < amount){
203             revert();
204         } else {
205             TOTAL_SUPPLY = TOTAL_SUPPLY - amount;
206             users[this] = users[this] - amount;
207         }
208     }
209 }
210 
211 contract BartcoinFaucet is Math {
212     address BARTCOIN_ADDRESS;
213     address OWNER;
214     uint256 LASTEST_SUPPLY = 0;
215     
216     mapping(address => uint256) BALANCES;
217     mapping(address => mapping (address => uint256)) ALLOWANCE;
218     
219     event Transfer(address indexed _from, address indexed _to, uint256 _value);
220     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
221     event Withdraw(address indexed _to, uint256 _value);
222     event Sync(uint256 indexed _remaining, uint256 _supply);
223     
224     modifier onlyOwner {
225         if (msg.sender != OWNER)
226             revert(); 
227         _;
228     }
229     
230     constructor(address _bartcoinAddress) {
231         BARTCOIN_ADDRESS = _bartcoinAddress;
232         OWNER = msg.sender;
233     }
234     
235     function synchronizeFaucet() {
236         //If faucetSupply changes, do synchronize
237         if (LASTEST_SUPPLY < faucetSupply()) {
238             uint256 _diff = faucetSupply() - LASTEST_SUPPLY;
239             BALANCES[this] = safeAdd(BALANCES[this], _diff);
240         }
241         
242         //Faucet capacity decreases, update LASTEST_SUPPLY only
243         LASTEST_SUPPLY = faucetSupply();
244         emit Sync(BALANCES[this], LASTEST_SUPPLY);
245     }
246     
247     function give(address _to, uint256 _value) onlyOwner returns (bool success) {
248         if (_to == 0x0) revert();
249         if (_value <= 0) revert();
250         if (_value > faucetSupply()) revert();
251         
252         synchronizeFaucet();
253         if(_value > BALANCES[this]) revert();
254         
255         BALANCES[this] = safeSub(BALANCES[this], _value);
256         BALANCES[_to] = safeAdd(BALANCES[_to], _value);
257         
258         emit Transfer(this, _to, _value);
259         return true;
260     }
261 
262     function transfer(address _to, uint256 _value) returns (bool success) {
263         if (_to == 0x0) revert();
264 		if (_value <= 0) revert();
265         if (faucetSupply() < _value) revert();
266         if (_value > BALANCES[msg.sender]) revert();
267         
268         Bartcoin(BARTCOIN_ADDRESS).transfer(_to, _value);
269         BALANCES[msg.sender] = safeSub(BALANCES[msg.sender], _value);
270         emit Transfer(msg.sender, _to, _value);
271         emit Withdraw(_to, _value);
272         
273         return true;
274     }
275 
276     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
277         if (_to == 0x0) revert();
278 		if (_value <= 0) revert();
279         if (faucetSupply() < _value) revert();
280         
281         if (_value > ALLOWANCE[_from][msg.sender]) revert();
282         if (_value > BALANCES[_from]) revert();
283         
284         if (BALANCES[_to] + _value < BALANCES[_to]) revert();
285         
286         BALANCES[_from] = safeSub(BALANCES[_from], _value);
287         BALANCES[_to] = safeAdd(BALANCES[_to], _value); 
288         ALLOWANCE[_from][msg.sender] = safeSub(ALLOWANCE[_from][msg.sender], _value);
289         emit Transfer(_from, _to, _value);
290         return true;
291     }
292 
293     function approve(address _spender, uint256 _value) returns (bool success) {
294         if (_value <= 0) revert(); //value less than 0
295         if (_value > faucetSupply()) revert(); //value larger than faucetSupply
296         if (_value > BALANCES[msg.sender]) revert(); // value larger than owner capacity
297         ALLOWANCE[msg.sender][_spender] = _value;
298         emit Approval(msg.sender, _spender, _value);
299         return true;
300     }
301     
302     function changeBartcoinContract(address _bartcoinAddress) {
303         BARTCOIN_ADDRESS = _bartcoinAddress;
304     }
305     
306     function faucetSupply() constant returns (uint256 supply) {
307         return Bartcoin(BARTCOIN_ADDRESS).balanceOf(this);
308     }
309     
310     function balanceOf(address _owner) constant returns (uint256 balance) {
311         return BALANCES[_owner];
312     }
313 
314     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
315         return ALLOWANCE[_owner][_spender];
316     }
317     
318     function name() public constant returns(string) {
319         return Bartcoin(BARTCOIN_ADDRESS).name();
320     }
321     
322     function decimals() public constant returns(uint) {
323         return Bartcoin(BARTCOIN_ADDRESS).decimals();
324     }
325     
326     function symbol() public constant returns(string) {
327         return Bartcoin(BARTCOIN_ADDRESS).symbol();
328     }
329     
330     function totalSupply() constant returns (uint256 supply) {
331         return Bartcoin(BARTCOIN_ADDRESS).totalSupply();
332     }
333 }